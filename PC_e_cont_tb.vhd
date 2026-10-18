library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_e_cont_tb is
end;

architecture a_PC_e_cont_tb of PC_e_cont_tb is

    -- 1. Declaração do Componente a testar
    component PC_e_cont
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_out : out unsigned(6 downto 0) 
        );
    end component;

    -- 2. Sinais do Testbench
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk         : std_logic := '0';
    
    -- Sinais de Controle
    signal   rst         : std_logic := '0';
    signal   wr_en       : std_logic := '0';
    
    -- Sinal de Saída (O valor atual do PC)
    signal   data_out    : unsigned(6 downto 0);

begin

    -- 3. Instanciação do componente
    uut: PC_e_cont port map (
        clk      => clk,
        rst      => rst,
        wr_en    => wr_en,
        data_out => data_out
    );

    -- 4. Processo de Reset Global Inicial
    reset_global: process
    begin
        rst <= '1'; -- Força o PC para 0000000
        wait for period_time * 2; 
        rst <= '0'; -- Libera o PC para começar a funcionar
        wait;
    end process;
    
    -- 5. Tempo máximo da simulação
    sim_time_proc: process
    begin
        wait for 2 us; -- Tempo suficiente para ver o contador ir do 0 até o 18
        finished <= '1';
        wait;
    end process sim_time_proc;

    -- 6. Geração do Clock
    clk_proc: process
    begin                       
        while finished /= '1' loop
            clk <= '0';
            wait for period_time / 2;
            clk <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    -- 7. Estímulos dos Testes
    process
    begin
        wait for 200 ns; -- Espera o reset global terminar

        -- Deixa a permissão de escrita sempre ligada,
        -- para que o PC atualize a cada borda de subida do clock.
        wr_en <= '1'; 
        
        -- O simulador fará o resto. A cada clock, a saída do PC (data_out)
        -- passará pelo contador (+1) e voltará para a entrada do PC, 
        -- sendo gravada no clock seguinte.
        
        wait; -- Fim do processo
    end process;

end architecture;