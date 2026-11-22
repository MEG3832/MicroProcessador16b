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

      0  => B"0001_0001_0000001010",   -- LD R1, 10
      1  => B"0001_0011_0000110010",   -- LD R3, 50
      2  => B"0001_0101_0001111000",   -- LD R5, 120
      3  => B"0001_1110_0010100101",   -- LD A1, 165
      4  => B"0110_1110_0001_000000",  -- SW A1, R1
      5  => B"0001_1111_0111110100",   -- LD A2, 500
      6  => B"0110_1111_0011_000000",  -- SW A2, R3
      7  => B"0001_1110_1000111011",   -- LD A1, 571
      8  => B"0110_1110_0101_000000",  -- SW A1, R5
      9  => B"0001_1110_0000000000",   -- LD A1, 0
      10 => B"0001_1111_0000000000",   -- LD A2, 0
      11 => B"0101_1110_0001_000000",  -- LW A1, R1
      12 => B"0101_1111_0101_000000",  -- LW A2, R5
      13 => B"0101_1110_0011_000000",  -- LW A1, R3

      -- abaixo: casos omissos => (zero em todos os bits)
      others => (others=>'0')
   );
begin
         dado <= conteudo_rom(to_integer(endereco));
end architecture;