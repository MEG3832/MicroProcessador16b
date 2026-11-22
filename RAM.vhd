library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------------------------------------------
entity RAM is
   port( 
         clk      : in std_logic;
         endereco : in unsigned(6 downto 0);
         wr_en    : in std_logic;
         dado_in  : in unsigned(15 downto 0);
         dado_out : out unsigned(15 downto 0) 
   );
end entity;
------------------------------------------------------------------------
architecture a_RAM of RAM is
   type mem is array (0 to 127) of unsigned(15 downto 0); -- vetor de 128 posições de 16 bits
   signal conteudo_RAM : mem;
begin
   process(clk,wr_en)
   begin
      if rising_edge(clk) then
         if wr_en='1' then
            conteudo_RAM(to_integer(endereco)) <= dado_in;
         end if;
      end if;
   end process;
   dado_out <= conteudo_RAM(to_integer(endereco));
end architecture;

-- detalhes do funcionamento !

-- 1) a leitura eh assincrona, ou seja:

-- no instante em que o valor no pino endereco muda,
-- o dado armazenado naquela posição aparece imediatamente na saída dado_out.

