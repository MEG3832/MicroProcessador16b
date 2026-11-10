library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ULA is
    port (
        entrada_A: in unsigned(15 downto 0);
        entrada_B: in unsigned(15 downto 0);
        select_op: in unsigned(1 downto 0);


        zero: out std_logic;
        negativo: out std_logic;
        overflow: out std_logic;
        saida: out unsigned(15 downto 0)

    );
end entity;

architecture arq_ULA of ULA is

    signal saida_s : unsigned(15 downto 0);

begin

    saida_s <= (entrada_A + entrada_B) when select_op = "00" else
               (entrada_B - entrada_A) when select_op = "01" else
               (entrada_A or entrada_B) when select_op = "10" else
               (entrada_A and entrada_B) when select_op = "11" else
               "0000000000000000";

    saida <= saida_s;

    zero <= '1' when saida_s = "0000000000000000" else '0';

    negativo <= saida_s(15);

    overflow <= '1' when (select_op = "00" and (entrada_A(15) = entrada_B(15)) and (saida_s(15) /= entrada_A(15))) else
                '1' when (select_op = "01" and (entrada_A(15) /= entrada_B(15)) and (saida_s(15) /= entrada_A(15))) else
                '0';


end architecture;
    