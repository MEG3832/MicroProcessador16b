library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs_tb is
end;

architecture a_banco_regs_tb of banco_regs_tb is
    component banco_regs
    port (

        wr_en_br: in std_logic;
        clk: in std_logic;
        rst: in std_logic;

        data_wr: in unsigned(15 downto 0);

        reg_read: in unsigned(3 downto 0); -- identifica em quall registrador estamos lendo...
        reg_wr: in unsigned(3 downto 0); -- identifica em quall registrador estamos escrevendo...

        data_reg: out unsigned(15 downto 0)

    );
    end component;

    --sinais

    constant period_time : time      := 100 ns;
    
    signal   finished    : std_logic := '0';

    signal clk,rst: std_logic;

    signal   wr_en_br: std_logic := '0';

    signal data_wr: unsigned(15 downto 0);

    signal reg_read, reg_wr: unsigned(3 downto 0);

    signal data_reg: unsigned(15 downto 0);


begin
        uut: banco_regs port map
        (
            wr_en_br => wr_en_br,
            clk => clk,
            rst => rst,
            data_wr => data_wr,
            reg_read => reg_read,
            reg_wr => reg_wr,
            data_reg => data_reg

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
      wait for 200 ns; -- teste 1
      wr_en_br <= '1';
      data_wr <= "0000000000000010";
      reg_read <= "0011";
      reg_wr <= "0011";


      wait for 100 ns; -- teste 2
      
      wr_en_br <= '0';
      data_wr <= "0000000000000001";
      reg_read <= "0011";
      reg_wr <= "0011";



      wait;                     -- <== OBRIGATÓRIO TERMINAR COM WAIT; !!!


   end process;

end architecture a_banco_regs_tb;
