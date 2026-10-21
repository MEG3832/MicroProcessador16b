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
            rst_PC   : in std_logic;
            rst_FF   : in std_logic;
            out_ROM  : out unsigned(17 downto 0) 
        );
    end component;

    -- 2. Sinais do Testbench
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk         : std_logic := '0';
    
    -- Sinais de Controle
    signal   rst_PC      : std_logic := '0';
    signal   rst_FF      : std_logic := '0';
    
    -- Sinal de Saída
    signal   out_ROM     : unsigned(17 downto 0);

begin

    -- 3. Instanciação do componente
    uut: PC_e_ROM port map (
        clk      => clk,
        rst_PC   => rst_PC,
        rst_FF   => rst_FF,
        out_ROM  => out_ROM
    );

    -- 4. Processo de Reset Inicial
    reset_global: process
    begin
        rst_PC <= '1'; -- Força o PC para o endereço zero
        rst_FF <= '1'; -- Força a máquina de estados para o Estado 0 (Fetch)
        wait for period_time * 2; 
        rst_PC <= '0'; -- Libera o PC
        rst_FF <= '0'; -- Libera a máquina de estados
        wait;
    end process;
    
    -- 5. Tempo máximo da simulação
    sim_time_proc: process
    begin
        wait for 3 us; -- Aumentei o tempo, pois agora cada instrução leva 2 clocks!
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
        -- Como a Unidade de Controle (Flip-Flop T) agora dita o ritmo internamente,
        -- nós não precisamos forçar nenhum sinal de 'wr_en' aqui.
        -- O hardware trabalha sozinho a partir do reset!
        wait; 
    end process;

end architecture;