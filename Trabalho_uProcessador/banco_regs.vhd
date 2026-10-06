library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs is
    port (
        wr_en_br: in std_logic;
        clk: in std_logic;
        rst: in std_logic;

        data_wr: in unsigned(15 downto 0);

        reg_read: in unsigned(3 downto 0); -- identifica em quall registrador estamos lendo...
        reg_wr: in unsigned(3 downto 0); -- identifica em quall registrador estamos escrevendo...

        data_reg: out unsigned(15 downto 0)

    );
end entity;


architecture a_banco_regs of banco_reg is
    component reg_16bits
    port (

        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)

    );
    end component;

signal clk, rst, wr_en: std_logic;
signal data_in, data_out: unsigned(15 downto 0);

begin

    reg0: reg_16bits    
    port map (

        clk => clk
        rst => rst
        wr_en => 



    )
