library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clk : in std_logic;
        rst : in std_logic; -- reset global para todos os componentes

        -- pinos para visualizar as formas de onda
        estado_out : out unsigned(1 downto 0);
        pc_out     : out unsigned(6 downto 0);
        instr_out  : out unsigned(17 downto 0);
        out_BR     : out unsigned(15 downto 0);
        out_ACC1   : out unsigned(15 downto 0);
        out_ACC2   : out unsigned(15 downto 0);
        out_ULA    : out unsigned(15 downto 0)
    );
end entity;

architecture a_processador of processador is

    component PC_e_ROM
       port( clk, rst_PC, pc_wr_en, jump_en, branch_en : in std_logic;
             cte_desvio : in unsigned(6 downto 0);
             out_ROM   : out unsigned(17 downto 0);
             pc_out    : out unsigned(6 downto 0) );
    end component;

    component UC
        port( clk, rst : in std_logic;
              instr    : in unsigned(17 downto 0);
              flag_z, flag_n, flag_v : in std_logic;
              pc_wr_en, jump_en, branch_en, wr_en_flags : out std_logic;
              cte_desvio : out unsigned(6 downto 0);
              wr_en_ACC1, wr_en_ACC2, wr_en_BR : out std_logic;
              sel_OP_ULA : out unsigned(1 downto 0);
              load_cte   : out unsigned(15 downto 0);
              sel_mux_acc_in : out unsigned(1 downto 0);
              sel_mux_br, sel_ACCs, sel_mux_ULA_br, sel_mux_ULA_acc : out std_logic;
              reg_wr_br, reg_read_br : out unsigned(3 downto 0);
              wr_en_RI   : out std_logic;
              estado_out : out unsigned(1 downto 0) );
    end component;

    component reg_instrucao
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(17 downto 0);
            data_out : out unsigned(17 downto 0)
        );
    end component;

    component ULA_BancReg
        port( clk : in std_logic;
              wr_en_ACC1, wr_en_ACC2, rst_ACC1, rst_ACC2 : in std_logic;
              wr_en_BR, rst_BR : in std_logic;
              sel_OP_ULA : in unsigned(1 downto 0);
              load_cte : in unsigned(15 downto 0);
              sel_mux_acc_in : in unsigned (1 downto 0);
              sel_mux_br, sel_ACCs, sel_mux_ULA_br, sel_mux_ULA_acc : in std_logic;
              cte_comparacao : in unsigned(15 downto 0);
              reg_wr_br, reg_read_br : in unsigned(3 downto 0);
              flag_z, flag_n, flag_v : out std_logic;
              out_BR, out_ACC1, out_ACC2, out_ULA : out unsigned(15 downto 0) );
    end component;

    component FFs_flagsULA
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            z_in     : in std_logic;
            n_in     : in std_logic;
            v_in     : in std_logic;
            z_out    : out std_logic;
            n_out    : out std_logic;
            v_out    : out std_logic
        );
    end component;

    --sinais
   signal instr_s       : unsigned(17 downto 0);
    signal pc_wr_en_s    : std_logic;
    signal jump_en_s     : std_logic;
    
    signal branch_en_s   : std_logic;
    signal cte_desvio_s  : unsigned(6 downto 0);
    
    signal wr_en_ACC1_s  : std_logic;
    signal wr_en_ACC2_s  : std_logic;
    signal wr_en_BR_s    : std_logic;
    
    signal sel_OP_ULA_s  : unsigned(1 downto 0);
    signal load_cte_s    : unsigned(15 downto 0);
    signal sel_mux_acc_in_s : unsigned(1 downto 0);
    signal sel_mux_br_s  : std_logic;
    signal sel_ACCs_s    : std_logic;
    signal sel_mux_ULA_br_s, sel_mux_ULA_acc_s : std_logic;
    signal reg_wr_br_s, reg_read_br_s : unsigned(3 downto 0);

    signal out_ROM_s     : unsigned(17 downto 0);
    signal wr_en_RI_s    : std_logic;             

    signal flag_z_ula_s, flag_n_ula_s, flag_v_ula_s : std_logic; -- dados q saem da ULA_BancReg
    
    signal flag_z_salva_s, flag_n_salva_s, flag_v_salva_s : std_logic; -- dados salvos saindo dos FFs indo para a UC
    
    signal wr_en_flags_s : std_logic;             

    begin
    
    instr_out <= instr_s;

    -- PC e ROM --
    inst_pc_rom: PC_e_ROM port map(
        clk       => clk,
        rst_PC    => rst,
        pc_wr_en  => pc_wr_en_s,
        jump_en   => jump_en_s,
        branch_en => branch_en_s,
        cte_desvio => cte_desvio_s,
        out_ROM   => out_ROM_s,     
        pc_out    => pc_out
    );

    inst_RI: reg_instrucao port map(
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_RI_s,
        data_in   => out_ROM_s,
        data_out  => instr_s
    );

    -- unidade de controle...
    inst_uc: UC port map(
        clk => clk,
        rst => rst,
        instr => instr_s, -- recebe a instrução do RI


        -- UC recebe as flags dos FFs..
        flag_z => flag_z_salva_s,
        flag_n => flag_n_salva_s,
        flag_v => flag_v_salva_s,
        
       -- saídas para o PC_e_ROM
        pc_wr_en        => pc_wr_en_s,
        jump_en         => jump_en_s,
        branch_en       => branch_en_s,
        cte_desvio      => cte_desvio_s,
        wr_en_flags     => wr_en_flags_s,
        
        -- saídas para o bloco ULA_BancReg
        wr_en_ACC1      => wr_en_ACC1_s,
        wr_en_ACC2      => wr_en_ACC2_s,
        wr_en_BR        => wr_en_BR_s,
        sel_OP_ULA      => sel_OP_ULA_s,
        load_cte        => load_cte_s,
        sel_mux_acc_in  => sel_mux_acc_in_s,
        sel_mux_br      => sel_mux_br_s,
        sel_ACCs        => sel_ACCs_s,
        sel_mux_ULA_br  => sel_mux_ULA_br_s,
        sel_mux_ULA_acc => sel_mux_ULA_acc_s,
        reg_wr_br       => reg_wr_br_s,
        reg_read_br     => reg_read_br_s,
        
        wr_en_RI        => wr_en_RI_s,
        estado_out      => estado_out
    );


    -- bloco de FFs.. conectando a ULA com a UC
    inst_FFs_flags: FFs_flagsULA port map(
        clk   => clk,
        rst   => rst,
        wr_en => wr_en_flags_s,
        z_in  => flag_z_ula_s,
        n_in  => flag_n_ula_s,
        v_in  => flag_v_ula_s,
        z_out => flag_z_salva_s,
        n_out => flag_n_salva_s,
        v_out => flag_v_salva_s
    );


    -- ULA e banco de registradores
    inst_datapath: ULA_BancReg port map(
        clk => clk,
        
        -- resets
        rst_ACC1 => rst,
        rst_ACC2 => rst,
        rst_BR => rst,
        
        -- controles vindos da UC
        wr_en_ACC1      => wr_en_ACC1_s,
        wr_en_ACC2      => wr_en_ACC2_s,
        wr_en_BR        => wr_en_BR_s,
        sel_OP_ULA      => sel_OP_ULA_s,
        load_cte        => load_cte_s,
        sel_mux_acc_in  => sel_mux_acc_in_s,
        sel_mux_br      => sel_mux_br_s,
        sel_ACCs        => sel_ACCs_s,
        sel_mux_ULA_br  => sel_mux_ULA_br_s,
        sel_mux_ULA_acc => sel_mux_ULA_acc_s,
        reg_wr_br       => reg_wr_br_s,
        reg_read_br     => reg_read_br_s,
        
        -- constante não utilizada nas instruções atuais
        cte_comparacao  => "0000000000000000",
        
        -- saídas para observar as formas de onda...

        flag_z          => flag_z_ula_s,
        flag_n          => flag_n_ula_s,
        flag_v          => flag_v_ula_s,

        out_BR          => out_BR,
        out_ACC1        => out_ACC1,
        out_ACC2        => out_ACC2,
        out_ULA         => out_ULA
    );

end architecture;