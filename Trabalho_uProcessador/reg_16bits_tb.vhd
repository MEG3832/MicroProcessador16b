library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_16bits_tb is
end;

architecture arq_reg_16bits_tb of reg_16bits_tb is
    component reg_16bits
    port (

        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)

    );
    end component;

--sinais

constant period_time : time      := 100 ns;
signal data_in, data_out: unsigned(15 downto 0);
signal   finished    : std_logic := '0';
signal   clk, rst, wr_en  : std_logic;

begin
        uut: reg_16bits port map
        (
           clk => clk,
           rst => rst,
           wr_en => wr_en,
           data_in => data_in,
           data_out => data_out

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
      wait for 200 ns;
      wr_en <= '1';
      data_in <= "0000000000000010";
      wait for 100 ns;
      data_in <= "0000000000000001";
      wait;                     -- <== OBRIGATÓRIO TERMINAR COM WAIT; !!!
   end process;
end architecture arq_reg_16bits_tb;