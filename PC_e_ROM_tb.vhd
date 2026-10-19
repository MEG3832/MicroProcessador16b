library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_e_ROM_tb is
end;

architecture a_PC_e_ROM_tb of PC_e_ROM_tb is

    -- 1. Declaração do Componente Top Level
    component PC_e_ROM
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            out_ROM  : out unsigned(17 downto 0) 
        );
    end component;

    -- 2. Sinais do Testbench
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk         : std_logic := '0';
    
    -- Sinais de Controle
    signal   rst         : std_logic := '0';
    signal   wr_en       : std_logic := '0';
    
    -- Sinal de Saída (A instrução inteira de 18 bits)
    signal   out_ROM     : unsigned(17 downto 0);

begin

    -- 3. Instanciação do componente
    uut: PC_e_ROM port map (
        clk      => clk,
        rst      => rst,
        wr_en    => wr_en,
        out_ROM  => out_ROM
    );

    -- 4. Processo de Reset Global Inicial
    reset_global: process
    begin
        rst <= '1'; -- Força o PC para o endereço zero
        wait for period_time * 2; 
        rst <= '0'; -- Libera o PC
        wait;
    end process;
    
    -- 5. Tempo máximo da simulação
    sim_time_proc: process
    begin
        wait for 2 us; -- Suficiente para ler umas 15 instruções
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

    -- 7. Estímulos
    process
    begin
        wait for 200 ns; -- Espera o reset global terminar

        -- Deixa a escrita do PC sempre ligada para ele ir somando 1 a cada clock
        wr_en <= '1'; 
        
        wait; 
    end process;

end architecture;