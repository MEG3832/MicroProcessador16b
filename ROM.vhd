library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rom is
   port( endereco : in unsigned(6 downto 0);
         dado     : out unsigned(17 downto 0) -- é a própria instrução! no futuro, a saída ira para a UC (unidade de controle/decodifador de instruções)
   );
end entity;
architecture a_rom of rom is
   type mem is array (0 to 127) of unsigned(17 downto 0);
   constant conteudo_rom : mem := (
      -- caso endereco => conteudo
      -- 4 bits opcode + 7 bits zeros + 7 bits endereço
      
      0  => "000000000000000000", 
      1  => "000000000000000001",
      
      -- salto para frente: salta do endereço 2 para o endereço 5
      2  => "111100000000000101", 
      
      -- ignoramos o 3 e o 4 pela primeira vez...
      3  => "000000000000000011", 
      4  => "000000000000000100", 
      
      -- loop: saltamos do endereço 5 para o 3...
      5  => "111100000000000011",
      
      -- abaixo: casos omissos => (zero em todos os bits)
      others => (others=>'0')
   );
begin
         dado <= conteudo_rom(to_integer(endereco));
end architecture;