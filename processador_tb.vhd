library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end entity;

architecture a_processador_tb of processador_tb is
    
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

    constant period_time: time := 100 ns;
    signal finished: std_logic := '0';
    signal clk: std_logic := '0';
    signal rst: std_logic := '0';

    signal estado_out : unsigned(1 downto 0);
    signal pc_out     : unsigned(6 downto 0);
    signal instr_out  : unsigned(17 downto 0);
    signal out_BR     : unsigned(15 downto 0);
    signal out_ACC1   : unsigned(15 downto 0);
    signal out_ACC2   : unsigned(15 downto 0);
    signal out_ULA    : unsigned(15 downto 0);

begin

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

    reset_global: process
    begin
        rst <= '1'; 
        wait for period_time * 2; 
        rst <= '0'; 
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 300 us; 
        finished <= '1';
        wait;
    end process sim_time_proc;

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

end architecture;