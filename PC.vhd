library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
   port( clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         data_in  : in unsigned(6 downto 0);
         data_out : out unsigned(6 downto 0) -- o out do PC é o endereço q vamos acessar (a saída do PC vai para a entrada da ROM)
   );
end entity;

architecture a_PC of PC is

    signal resultado: unsigned(6 downto 0);

begin
   process(clk,rst,wr_en)  -- acionado se houver mudança em clk ou wr_en
   begin
    if rst='1' then
         resultado <= "0000000"; -- PC começa no endereço '0000000'

        elsif falling_edge(clk) then 
            if wr_en = '1' then
            resultado <= data_in;
            end if;
        end if;
   end process;
   
   data_out <= resultado;  -- conexao direta, fora do processo
end architecture;