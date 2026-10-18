library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flipflopT_tb is
end;

architecture arq_flipflopT_tb of flipflopT_tb is
    component flipflopT
    port (

        clk      : in std_logic;
        rst      : in std_logic;
        estado : out std_logic

    );
    end component;

--sinais

constant period_time : time      := 100 ns;
signal   finished, estado    : std_logic := '0';
signal   clk, rst  : std_logic;

begin
        uut: flipflopT port map
        (
           clk => clk,
           rst => rst,
           estado => estado

        );


    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        rst <= '0';
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 10 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process                      -- sinais dos casos de teste (p.ex.)
    begin
      wait until finished = '1';
      wait;                     -- <== OBRIGATÓRIO TERMINAR COM WAIT; !!!
   end process;
end architecture arq_flipflopT_tb;