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
      
      0  => B"0001_0011_0000000000",    -- A: LD R3, 0
      1  => B"0001_0100_0000000000",    -- B: LD R4, 0
      2  => B"0010_1110_0011_000_000",  -- C: MOV A1, R3
      3  => B"0010_1110_0100_000_001",  --    ADD A1, R4
      4  => B"0010_0100_1110_000_000",  --    MOV R4, A1
      5  => B"0001_1110_0000000001",    -- D: LD A1, 1
      6  => B"0010_1110_0011_000_001",  --    ADD A1, R3
      7  => B"0010_0011_1110_000_000",  --    MOV R3, A1
      8  => B"0001_1110_0000011110",    -- E: LD A1, 30
      9  => B"0010_1110_0011_000_010",  --    SUB A1, R3
      10 => B"0100_001_0000_1110111",   --    BGE -8
      11 => B"0010_1110_0100_000_000",  -- F: MOV A1, R4
      12 => B"0010_0101_1110_000_000",   --    MOV R5, A1

      -- abaixo: casos omissos => (zero em todos os bits)
      others => (others=>'0')
   );
begin
         dado <= conteudo_rom(to_integer(endereco));
end architecture;