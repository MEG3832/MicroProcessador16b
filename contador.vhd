library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador is
   port( clk      : in std_logic;
         data_in  : in unsigned(6 downto 0); -- recebe o "out" do PC, que é o endereço
         data_out : out unsigned(6 downto 0)
   );
end entity;

architecture a_contador of contador is
   signal resultado: unsigned(6 downto 0);
begin
   process(clk)  
   begin                
      if falling_edge(clk) then
        resultado <= data_in + 1;
      end if;
   end process;
   
   data_out <= resultado;  -- conexao direta, fora do processo
end architecture;