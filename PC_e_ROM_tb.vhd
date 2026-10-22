library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_e_ROM_tb is
end;

architecture a_PC_e_ROM_tb of PC_e_ROM_tb is

    component PC_e_ROM
        port( 
            clk      : in std_logic;
            rst_PC   : in std_logic;
            rst_FF   : in std_logic;
            out_ROM  : out unsigned(17 downto 0) 
        );
    end component;

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk         : std_logic := '0';
    
    signal   rst_PC      : std_logic := '0';
    signal   rst_FF      : std_logic := '0';
    
    signal   out_ROM     : unsigned(17 downto 0);

begin

    uut: PC_e_ROM port map (
        clk      => clk,
        rst_PC   => rst_PC,
        rst_FF   => rst_FF,
        out_ROM  => out_ROM
    );

    reset_global: process
    begin
        rst_PC <= '1'; 
        rst_FF <= '1'; 
        wait for period_time * 2; 
        rst_PC <= '0'; 
        rst_FF <= '0'; 
        wait;
    end process;
    
   
    sim_time_proc: process
    begin
        
        wait for 5 us; 
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

   
    process
    begin
       
        wait; 
    end process;

end architecture;