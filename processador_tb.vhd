library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- O nome do testbench top-level deve ser obrigatoriamente "processador_tb.vhd" 
entity processador_tb is
end entity;

architecture a_processador_tb of processador_tb is
    
    -- Componente do topo da hierarquia, com as entradas clk e rst, 
    -- e os pinos visíveis para o GTKWave (incluindo o out_ULA adicionado anteriormente)
    component processador
        port(
            clk : in std_logic;
            rst : in std_logic;
            estado_out : out unsigned(1 downto 0);
            pc_out     : out unsigned(6 downto 0);
            instr_out  : out unsigned(17 downto 0);
            out_BR     : out unsigned(15 downto 0);
            out_ACC1   : out unsigned(15 downto 0);
            out_ACC2   : out unsigned(15 downto 0);
            out_ULA    : out unsigned(15 downto 0) 
        );
    end component;

    -- Controle de tempo herdado dos seus testbenches anteriores
    constant period_time: time:= 100 ns;
    signal finished: std_logic := '0';
    signal clk: std_logic := '0';
    signal rst: std_logic := '0';

    -- Sinais para capturar as saídas e observar no GTKWave
    signal estado_out : unsigned(1 downto 0);
    signal pc_out     : unsigned(6 downto 0);
    signal instr_out  : unsigned(17 downto 0);
    signal out_BR     : unsigned(15 downto 0);
    signal out_ACC1   : unsigned(15 downto 0);
    signal out_ACC2   : unsigned(15 downto 0);
    signal out_ULA    : unsigned(15 downto 0);

begin
    -- Mapeamento do processador completo
    uut: processador port map (
        clk        => clk,
        rst        => rst,
        estado_out => estado_out,
        pc_out     => pc_out,
        instr_out  => instr_out,
        out_BR     => out_BR,
        out_ACC1   => out_ACC1,
        out_ACC2   => out_ACC2,
        out_ULA    => out_ULA
    );

    -- Processo de reset inicial idêntico ao do ULA_BancReg_tb
    reset_global: process
    begin
        rst <= '1'; 
        wait for period_time * 2; 
        rst <= '0'; 
        wait;
    end process;
    
    -- Tempo de simulação (5 us costuma ser o suficiente para o programa rodar várias vezes)
    sim_time_proc: process
    begin
        wait for 5 us; 
        finished <= '1';
        wait;
    end process sim_time_proc;

    -- Geração do clock idêntica à dos seus testbenches
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

    -- NOTA: Você não precisa de um processo injetando estímulos manuais aqui,
    -- pois as instruções virão automaticamente da ROM a cada ciclo de clock!

end architecture;