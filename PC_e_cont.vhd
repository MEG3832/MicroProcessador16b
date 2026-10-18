library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_e_cont is
   port( clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         data_out : out unsigned(6 downto 0) -- o out do PC é o endereço q vamos acessar (a saída do PC vai para a entrada da ROM)
   );
end entity;


architecture a_PC_e_cont of PC_e_cont is

    component contador
        port(

            in_cont  : in unsigned(6 downto 0); -- recebe o "out" do PC, que é o endereço
            out_cont : out unsigned(6 downto 0)

        );
        end component;

    component PC
        port(   
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0) -- o out do PC é o endereço q vamos acessar (a saída do PC vai para a entrada da ROM)
        );
        end component;

    signal contOUT_pcIN: unsigned(6 downto 0);
    signal pcOUT_contIN: unsigned(6 downto 0);

    begin

    cont: contador port map (in_cont => pcOUT_contIN,
                             out_cont => contOUT_pcIN);
    

    PC_inst: PC port map (clk => clk,
                          rst => rst,
                          wr_en => wr_en,
                          data_in => contOUT_pcIN,
                          data_out => pcOUT_contIN);
                          
    data_out <= pcOUT_contIN;

end architecture;