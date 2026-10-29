library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port(
        clk : in std_logic;
        instr : in unsigned(17 downto 0);
        rst: in std_logic; -- reset para maq de estados

        -- sinais de controle do PC e JUMP
        pc_wr_en        : out std_logic;                    -- incrementa ou atualiza o PC
        jump_en         : out std_logic;                    -- ativa o mux de jump no PC
        addr_jump       : out unsigned(6 downto 0);         -- endereço do jump (7 bits)

        -- sinais de controle do ULA_BancReg
        wr_en_ACC1      : out std_logic;                    -- habilita escrita acc1
        wr_en_ACC2      : out std_logic;                    -- habilita escrita no acc2
        wr_en_BR        : out std_logic;                    -- habilita escrita no br
        
        sel_OP_ULA      : out unsigned(1 downto 0);         -- operação da ULA
        load_cte        : out unsigned(15 downto 0);        -- cte extendida de 10 para 16 bits
        
        sel_mux_acc_in  : out unsigned(1 downto 0);         -- MUX entrada acc (00 - BR, 01 - CTE, 10 - ULA)
        sel_mux_br      : out std_logic;                    -- MUX entrada br (0: CTE, 1: ACC)
        sel_ACCs        : out std_logic;                    -- escolhe acumulador de saída (0: ACC1, 1: ACC2)
        sel_mux_ULA_br  : out std_logic;                    -- MUX entrada 1 ULA (0: BR, 1: cte_comp)
        sel_mux_ULA_acc : out std_logic;                    -- MUX entrada 2 ULA (0: ACC, 1: cte_comp)
        
        reg_wr_br       : out unsigned(3 downto 0);         -- endereço de escrita no BR
        reg_read_br     : out unsigned(3 downto 0);         -- endereço de leitura no BR

        wr_en_RI        : out std_logic;                    -- habilita escrita no registrador de instruções

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
    signal opcode   : unsigned(3 downto 0); -- opcode
    signal funct    : unsigned(2 downto 0); -- funct

    signal reg_dest_s : unsigned(3 downto 0); -- reg destino
    signal reg_src_s  : unsigned(3 downto 0); -- reg fonte

    -- identificação dos destinos
    signal dest_is_a1 : std_logic;
    signal dest_is_a2 : std_logic;
    signal dest_is_br : std_logic;

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

    -- separação do bits da instrução!

   -- opcode nos 4 bits MSB
   opcode <= instr(17 downto 14);

   -- bits q representam os registradores de fonte e destino...
   reg_dest_s <= instr(13 downto 10);
   reg_src_s  <= instr(9 downto 6);

   --bits que representam a funct..
   funct      <= instr(2 downto 0);


   -- *************************** --

   is_ld   <= '1' when opcode = "0001" else '0'; -- LD  (carrega constante)
   is_mov  <= '1' when opcode = "0010" and funct = "000" else '0'; -- MOV (copia registrador)
   is_add  <= '1' when opcode = "0010" and funct = "001" else '0'; -- ADD (soma na ULA)
   is_sub  <= '1' when opcode = "0010" and funct = "010" else '0'; -- SUB (subtrai na ULA)
   is_jump <=  '1' when opcode = "0011" else '0'; -- jump (pulo incondicional)

   -- A1 = 1110, A2 = 1111, BR = 0000 a 1010
    dest_is_a1 <= '1' when reg_dest_s = "1110" else '0';
    dest_is_a2 <= '1' when reg_dest_s = "1111" else '0';
    dest_is_br <= '1' when reg_dest_s <= "1010" else '0';


    -- atribuição das saídas de dados
    reg_wr_br   <= reg_dest_s;
    reg_read_br <= reg_src_s;
    addr_jump   <= instr(6 downto 0);


    -- extendendo a constante de 10 para 16 bits (com zeros à esquerda)
    load_cte    <= "000000" & instr(9 downto 0);

    -- op na ULA (00: ADD, 01: SUB, 10: Passa)
    sel_OP_ULA <= "00" when is_add = '1' else
                  "01" when is_sub = '1' else
                  "10";

    -- entrada dos ACCs: 01 = LD (Constante), 10 = ULA, 00 = BR (no MOV)
    sel_mux_acc_in <= "01" when is_ld = '1' else
                      "10" when (is_add = '1' or is_sub = '1') else
                      "00";

    -- entrada do BR: 0 = LD (Constante), 1 = Acumulador (no MOV)
    sel_mux_br <= '0' when is_ld = '1' else '1';

    -- seleciona d qual acumulador ler: '0' se a fonte for A1 (1110), '1' se for A2 (1111)
    sel_ACCs <= '1' when reg_src_s = "1111" else '0';

    -- entradas padrão da ULA sem constante de comparação
    sel_mux_ULA_br  <= '0'; 
    sel_mux_ULA_acc <= '0';

    -- ativar escritas ... (ocorre só no estado "10"!!)
    pc_wr_en   <= '1' when estado_s = "10" else '0';
    jump_en    <= '1' when (is_jump = '1' and estado_s = "10") else '0';

    wr_en_ACC1 <= '1' when (dest_is_a1 = '1' and (is_ld = '1' or is_mov = '1' or is_add = '1' or is_sub = '1') and estado_s = "10") else '0';
    wr_en_ACC2 <= '1' when (dest_is_a2 = '1' and (is_ld = '1' or is_mov = '1' or is_add = '1' or is_sub = '1') and estado_s = "10") else '0';
    wr_en_BR   <= '1' when (dest_is_br = '1' and (is_ld = '1' or is_mov = '1') and estado_s = "10") else '0';

    -- habilitar escrita no RI no segundo estado (estado "01")
    wr_en_RI   <= '1' when estado_s = "01" else '0';



end architecture;






