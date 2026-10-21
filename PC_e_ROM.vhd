library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_e_ROM is
   port( clk      : in std_logic;
         rst_PC      : in std_logic;
         rst_FF      : in std_logic;
         wr_en: in std_logic;
         out_ROM : out unsigned(17 downto 0) -- out da ROM !!!! irá para o conjunto (bancoReg + ULA) dps
   );
end entity;


architecture a_PC_e_ROM of PC_e_ROM is

    component PC_e_cont --vou chamar o conjunto PC+contador de apenas PC
        port( clk      : in std_logic;
              rst      : in std_logic;
              wr_en    : in std_logic;
              data_out : out unsigned(6 downto 0)
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


    signal pcOUT_romIN: unsigned(6 downto 0);
    signal romOUT_ucIN: unsigned(17 downto 0);
    signal ucOUT_wr_en: std_logic;
    
    

    begin

    rom_inst: ROM port map(endereco => pcOUT_romIN,
                           dado => out_ROM

    );

    PC_inst: PC_e_cont port map (clk => clk,
                                     rst => rst_PC,
                                     wr_en => ucOUT_wr_en,
                                     data_out => pcOUT_romIN);

      UC_inst: UC port map (clk => clk,
                            rst_FF => rst_FF,
                            instr => romOUT_ucIN,
                            pc_wr_en => ucOUT_wr_en,
                            jump_en =>);

end architecture;