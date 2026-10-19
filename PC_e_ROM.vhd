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

    -- o flipflop por enquanto vai ser a nossa máquina de estado/UC (Unidade de Controle)...
    -- o estado 0 dá "fetc" na instruçao atual e o estado 1 passa para a próxima instruçao do pc (incrementa)
    component flipflopT
      port( clk      : in std_logic;
            rst      : in std_logic;
            estado : out std_logic
            );
    end component;


    signal ucOUT_pcIN: std_logic;
    
    signal pcOUT_romIN: unsigned(6 downto 0);

    begin

    rom_inst: ROM port map(endereco => pcOUT_romIN,
                           dado => out_ROM

    );

    FF_T: flipflopT port map(clk => clk,
                             rst => rst_FF,
                             estado => ucOUT_pcIN
    );

    PC_inst: PC_e_cont port map (clk => clk,
                                     rst => rst_PC,
                                     wr_en => ucOUT_pcIN,
                                     data_out => pcOUT_romIN);

end architecture;