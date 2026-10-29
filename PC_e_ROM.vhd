library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_e_ROM is
   port( clk      : in std_logic;
         rst_PC      : in std_logic;
         pc_wr_en  : in std_logic;            -- vem da UC (externa)
         jump_en   : in std_logic;            -- vem da UC (externa)
         addr_jump : in unsigned(6 downto 0); -- vem da UC (externa)
         out_ROM : out unsigned(17 downto 0); -- out da ROM !!!! irá para o conjunto (bancoReg + ULA) dps
         pc_out    : out unsigned(6 downto 0) -- apenas para vermos o sinal depois...
   );
end entity;


architecture a_PC_e_ROM of PC_e_ROM is


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


    component ROM
        port( endereco : in unsigned(6 downto 0);
              dado     : out unsigned(17 downto 0) 
        );
    end component;

      component mux_2in_7bits -- usamos um mux pra passar adiante como data_in do pc OU o endereço
      port(                   -- para o qual vamos fazer o JUMP (está na estrutura da instruçãos) OU o +1 do contador
            input0: in unsigned(6 downto 0);
            input1: in unsigned(6 downto 0);
            sel       : in std_logic;
            saida     : out unsigned(6 downto 0)

      );
      end component;

      


    signal pcOUT_s   : unsigned(6 downto 0);
    signal contOUT_s : unsigned(6 downto 0);
    signal muxOUT_s  : unsigned(6 downto 0);
    signal romOUT_s  : unsigned(17 downto 0);
    
    

    begin

    rom_inst: ROM port map(endereco => pcOUT_s,
                           dado => romOUT_s);

    
      
     cont: contador port map (in_cont => pcOUT_s,
                              out_cont => contOUT_s);
    

     PC_inst: PC port map (clk => clk,
                           rst => rst_PC,
                           wr_en => pc_wr_en,
                           data_in => muxOUT_s,
                           data_out => pcOUT_s);                                

     mux_2in_inst: mux_2in_7bits port map (input0 => contOUT_s,
                                           input1 => addr_jump,
                                           sel => jump_en,
                                           saida => muxOUT_s);

    out_ROM <= romOUT_s;
    pc_out  <= pcOUT_s;

end architecture;
