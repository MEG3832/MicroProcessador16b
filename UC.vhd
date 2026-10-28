library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port(
        clk : in std_logic;
        instr : in unsigned(17 downto 0);
        rst: in std_logic; -- reset para maq de estados

        -- sinais de p/ habilitar escrita
        pc_wr_en  : out std_logic;
        jump_en   : out std_logic;
        reg_wr_en : out std_logic;

        estado_out: out unsigned(1 downto 0) -- para analisarmos as formas de onda dps, como pedido...
    );                       
end entity;

architecture a_UC of UC is

    -- ** máquina de estado! **
    -- o estado 0 dá "fetch", ou seja, leitura da instrução vinda da ROM
    -- o estado 1 faz a UC "separar" os bits da instrução em opcode, registradores que vão ser usados, etc
    -- o estado 2 é o execute, ou seja, faz a operação em si e grava as informações onde deve gravar..
    component maq_estados
        port(
            clk, rst : in std_logic;
            estado   : out unsigned(1 downto 0)
        );
    end component;

    -- ** sinais.... **

    signal estado_s : unsigned(1 downto 0);
    signal opcode   : unsigned(3 downto 0);

    -- ..sinais para opcodes
    signal is_ld   : std_logic;
    signal is_mov  : std_logic;
    signal is_add  : std_logic;
    signal is_sub  : std_logic;
    signal is_jump : std_logic;


begin

    maq_inst: maq_estados port map (clk    => clk,
                                    rst    => rst,
                                    estado => estado_s);

    estado_out <= estado_s;

   -- opcode nos 4 bits MSB
   opcode <= instr(17 downto 14);


   is_ld   <= '1' when opcode = "0001" else '0'; -- LD  (carrega constante)
   is_mov  <= '1' when opcode = "0010" else '0'; -- MOV (copia registrador)
   is_add  <= '1' when opcode = "0011" else '0'; -- ADD (soma na ULA)
   is_sub  <= '1' when opcode = "0100" else '0'; -- SUB (subtrai na ULA)
   is_jump <=  '1' when opcode="0101" else '0'; -- jump (pulo incondicional)


    -- ativação dos sinais de controle.. 

    jump_en <= '1' when (is_jump = '1' and estado_s = "10") else '0';

    pc_wr_en <= '1' when estado_s = "10" else '0';

    reg_wr_en <= '1' when ((is_ld = '1' or is_mov = '1' or is_add = '1' or is_sub = '1') and estado_s = "10") else '0';
    

    -- TERMINAR DE INTERPRETAR O RESTO DOS BITS DA INSTRUÇÃO!! . . .. 


end architecture;






