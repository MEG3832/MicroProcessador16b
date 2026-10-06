library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ULA is
    port (
        entrada_A: in unsigned(15 downto 0);
        entrada_B: in unsigned(15 downto 0);
        select_op: in unsigned(1 downto 0);

        saida: out unsigned(15 downto 0)

    );
end entity;

architecture arq_ULA of ULA is

begin

    saida <= (entrada_A + entrada_B) when select_op = "00" else
             (entrada_A - entrada_B) when select_op = "01" else
             (entrada_A or entrada_B) when select_op = "10" else
             (entrada_A and entrada_B) when select_op = "11" else
             "0000000000000000";


end architecture;
    