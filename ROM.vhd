library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rom is
   port( endereco : in unsigned(6 downto 0);
         dado     : out unsigned(17 downto 0) 
   );
end entity;
architecture a_rom of rom is
   type mem is array (0 to 127) of unsigned(17 downto 0);
   constant conteudo_rom : mem := (
      -- caso endereco => conteudo
      0  => "000000000010000000",
      1  => "100000000000000000",
      2  => "000000000000000000",
      3  => "000000000000000000",
      4  => "100000000000000000",
      5  => "000000000010000000",
      6  => "111100000011000000",
      7  => "000000000010000000",
      8  => "000000000010000000",
      9  => "000000000000000000",
      10 => "000000000000000000",
      -- abaixo: casos omissos => (zero em todos os bits)
      others => (others=>'0')
   );
begin
         dado <= conteudo_rom(to_integer(endereco));
end architecture;