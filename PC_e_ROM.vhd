library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_e_ROM is
   port( clk      : in std_logic;
         rst_PC      : in std_logic;
         rst_FF      : in std_logic;
         out_ROM : out unsigned(17 downto 0) -- out da ROM !!!! irá para o conjunto (bancoReg + ULA) dps
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

    component UC
      port(
            clk : in std_logic; -- clk para o FF
            instr : in unsigned(17 downto 0);
            rst_FF : in std_logic;
            pc_wr_en : out std_logic;
            jump_en : out std_logic
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

      


    signal pcOUT_romIN: unsigned(6 downto 0);
    signal pcOUT_contIN: unsigned(6 downto 0);
    signal romOUT_s: unsigned(17 downto 0); -- instrução total que sai da ROM e vai para a UC !!
    signal addr_jump: unsigned(6 downto 0); -- parte da instrução total q eh o endereço para o qual vamos estar pulando
    signal ucOUT_wr_en: std_logic;
    signal jump_en_s: std_logic; -- ativa ou não o mux
    signal contOUT: unsigned(6 downto 0);
    signal muxOUT_pcIN: unsigned(6 downto 0);
    
    

    begin
    
    --bifurcações e cópias de sinais importantes
    addr_jump <= romOUT_s(6 downto 0);
    pcOUT_romIN <= pcOUT_contIN;




    rom_inst: ROM port map(endereco => pcOUT_romIN,
                           dado => romOUT_s);

    
      
     cont: contador port map (in_cont => pcOUT_contIN,
                              out_cont => contOUT);
    

     PC_inst: PC port map (clk => clk,
                           rst => rst_PC,
                           wr_en => ucOUT_wr_en,
                           data_in => muxOUT_pcIN,
                           data_out => pcOUT_contIN);                                

     UC_inst: UC port map (clk => clk,
                           rst_FF => rst_FF,
                           instr => romOUT_s,
                           pc_wr_en => ucOUT_wr_en,
                           jump_en => jump_en_s);

     mux_2in_inst: mux_2in_7bits port map (input0 => contOUT,
                                           input1 => addr_jump,
                                           sel => jump_en_s,
                                           saida => muxOUT_pcIN);

      out_ROM <= romOUT_s;

end architecture;
