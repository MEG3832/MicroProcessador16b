library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port(
        clk : in std_logic; -- clk para o FF
        instr : in unsigned(17 downto 0);
        rst_FF : in std_logic;
        pc_wr_en : out std_logic;
        jump_en : out std_logic
    );                       
end entity;

architecture a_UC of UC is

    signal opcode: unsigned(3 downto 0);

    -- o flipflop por enquanto vai ser a nossa máquina de estado
    -- o estado 0 dá "fetc" na instruçao atual e o estado 1 passa para a próxima instruçao do pc (incrementa)
    component flipflopT
      port( clk      : in std_logic;
            rst      : in std_logic;
            estado : out std_logic
            );
    end component;

begin
   -- opcode nos 4 bits MSB
   opcode <= instr(17 downto 14);
   -- jump: opcode 1111
   jump_en <=  '1' when opcode="1111" else
               '0';

    FF_T: flipflopT port map(clk => clk,
                             rst => rst_FF,
                             estado => pc_wr_en
    );

end architecture;






