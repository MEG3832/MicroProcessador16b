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
      
      0  => B"0001_0011_0000000101",    -- A:  LD   R3, 5
      1  => B"0001_0100_0000001000",    -- B:  LD   R4, 8
      2  => B"0010_1110_0011_000_000",  -- C:  MOV  A1, R3
      3  => B"0010_1110_0100_000_001",  --     ADD  A1, R4
      4  => B"0010_0101_1110_000_000",  --     MOV  R5, A1
      5  => B"0001_0010_0000000001",    -- D:  LD   R2, 1
      6  => B"0010_1110_0101_000_000",  --     MOV  A1, R5
      7  => B"0010_1110_0010_000_010",  --     SUB  A1, R2
      8  => B"0010_0101_1110_000_000",  --     MOV  R5, A1
      9  => B"0011_0000000_0010100",    -- E:  JUMP 20
      10 => B"0000_0000_0000000000",    -- NOP (0x0)
      11 => B"0000_0000_0000000000",
      12 => B"0000_0000_0000000000",
      13 => B"0000_0000_0000000000",
      14 => B"0000_0000_0000000000",
      15 => B"0000_0000_0000000000",
      16 => B"0000_0000_0000000000",
      17 => B"0000_0000_0000000000",
      18 => B"0000_0000_0000000000",
      19 => B"0000_0000_0000000000",
      20 => B"0010_0011_0101_000_000",  -- G: MOV  R3, R5
      21 => B"0011_0000000_0000010",    -- H: JUMP 2
      22 => B"0001_0011_0000000000",    -- I: LD  R3, 0

      -- abaixo: casos omissos => (zero em todos os bits)
      others => (others=>'0')
   );
begin
         dado <= conteudo_rom(to_integer(endereco));
end architecture;