library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2in is
    port (
            input0: in unsigned(15 downto 0);
            input1: in unsigned(15 downto 0);
            sel       : in std_logic;
            saida     : out unsigned(15 downto 0)
    );
end entity;

architecture arq_mux of mux_2in is
begin
    saida <= input0 when sel = '0' else
             input1 when sel = '1' else
    "0000000000000000";
end architecture;
