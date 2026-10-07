library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
    port (
            input1: in unsigned(15 downto 0);
            input2: in unsigned(15 downto 0);
            sel       : in std_logic;
            saida     : out unsigned(15 downto 0)
    );
end entity;

architecture arq_mux of mux is
begin
    saida <= input1 when sel = '0' else 
             input2;
end architecture;
