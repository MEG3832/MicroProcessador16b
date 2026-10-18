library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador is
   port(
         in_cont  : in unsigned(6 downto 0); -- recebe o "out" do PC, que é o endereço
         out_cont : out unsigned(6 downto 0)
   );
end entity;

architecture a_contador of contador is
begin
   out_cont <= in_cont + 1;  -- conexao direta, fora do processo
end architecture;