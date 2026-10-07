library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_3in is
    port (
            input0: in unsigned(15 downto 0);
            input1: in unsigned(15 downto 0);
            input2: in unsigned(15 downto 0);
            sel       : in unsigned(1 downto 0);
            saida     : out unsigned(15 downto 0)
    );
end entity;

architecture arq_mux of mux_3in is
begin
    saida <= input0 when sel = "00" else 
             input1 when sel = "01" else
             input2 when sel = "10" else
    "0000000000000000";

end architecture;
