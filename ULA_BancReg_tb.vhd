library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_BancReg_tb is
end;

architecture a_ULA_BancReg_tb of ULA_BancReg_tb is
    component ULA_BancReg
    port(
        clk: in std_logic;

        -- Acumuladores
        wr_en_ACC1, wr_en_ACC2: in std_logic;
        rst_ACC1, rst_ACC2: in std_logic; 

        load_cte: in unsigned(15 downto 0); 

        -- Banco de Registradores
        wr_en_BR: in std_logic; 
        rst_BR: in std_logic;
        reg_wr_br: in unsigned(3 downto 0);
        reg_read_br: in unsigned(3 downto 0);

        -- ULA
        sel_OP_ULA: in unsigned(1 downto 0); 
        cte_comparacao: in unsigned(15 downto 0); 
    
        -- Multiplexadores
        sel_mux_acc_in: in unsigned (1 downto 0); 
        sel_mux_br: in std_logic; 
        sel_ACCs: in std_logic; 
        sel_mux_ULA_br: in std_logic; 
        sel_mux_ULA_acc: in std_logic; 

        -- Saídas
        out_BR: out unsigned(15 downto 0);
        out_ACC1: out unsigned(15 downto 0);
        out_ACC2: out unsigned(15 downto 0)
    );
    end component;

    -- Controle
    constant period_time: time:= 100 ns;
    signal finished: std_logic := '0';
    signal clk: std_logic := '0';

    -- Acumuladores
    signal wr_en_ACC1, wr_en_ACC2: std_logic := '0';
    signal rst_ACC1, rst_ACC2 : std_logic := '0';

    signal load_cte: unsigned(15 downto 0);

    -- Banco de Registradores
    signal wr_en_BR: std_logic := '0';
    signal rst_BR: std_logic := '0';
    signal reg_wr_br: unsigned(3 downto 0) := "0000";
    signal reg_read_br : unsigned(3 downto 0) := "0000";

    -- ULA
    signal sel_OP_ULA: unsigned(1 downto 0) := "00";
    signal cte_comparacao: unsigned(15 downto 0);

    -- Multiplexadores
    signal sel_mux_acc_in : unsigned(1 downto 0) := "00";
    signal sel_mux_br: std_logic := '0';
    signal sel_ACCs: std_logic := '0';
    signal sel_mux_ULA_br: std_logic := '0';
    signal sel_mux_ULA_acc: std_logic := '0';

    -- Saídas
    signal out_BR: unsigned(15 downto 0);
    signal out_ACC1: unsigned(15 downto 0);
    signal out_ACC2 : unsigned(15 downto 0);

begin
    uut: ULA_BancReg port map (
        clk => clk,

        -- Acumuladores
        wr_en_ACC1 => wr_en_ACC1, wr_en_ACC2 => wr_en_ACC2,
        rst_ACC1 => rst_ACC1, rst_ACC2 => rst_ACC2,

        load_cte => load_cte,

        -- Banco de Registradores
        wr_en_BR => wr_en_BR,
        rst_BR => rst_BR,
        reg_wr_br => reg_wr_br,
        reg_read_br => reg_read_br,

        -- ULA
        sel_OP_ULA => sel_OP_ULA,
        cte_comparacao => cte_comparacao,
    
        -- Multiplexadores
        sel_mux_acc_in => sel_mux_acc_in,
        sel_mux_br => sel_mux_br,
        sel_ACCs => sel_ACCs,
        sel_mux_ULA_br => sel_mux_ULA_br,
        sel_mux_ULA_acc => sel_mux_ULA_acc,

        -- Saídas
        out_BR => out_BR,
        out_ACC1 => out_ACC1,
        out_ACC2 => out_ACC2                
    );

    reset_global: process
    begin
        rst_BR <= '1'; rst_ACC1 <= '1'; rst_ACC2 <= '1'; -- Zera o Banco e os Acumuladores no começo da simulação
        wait for period_time*2; 
        rst_BR <= '0'; rst_ACC1 <= '0'; rst_ACC2 <= '0';
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 20 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin                       
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process
    begin
        wait for 200 ns;

        -- TESTE 1: LD A1, 5
        load_cte <= "0000000000000101";
        sel_mux_acc_in <= "01"; -- Seleciona load_cte
        wr_en_ACC1 <= '1';

        wait for period_time;
        wr_en_ACC1 <= '0';

        -- TESTE 2: LD R3, 10
        load_cte <= "0000000000001010";
        sel_mux_br <= '0';      -- Seleciona load_cte para o BR
        reg_wr_br <= "0011";    -- Registrador R3
        reg_read_br <= "0011";  -- Aponta a leitura para R3
        wr_en_BR <= '1';

        wait for period_time;
        wr_en_BR <= '0';

        -- TESTE 3: ADD A1, R3
        sel_ACCs <= '0';        -- Manda ACC1 para a ULA
        reg_read_br <= "0011";  -- Manda R3 para a ULA
        sel_mux_ULA_acc <= '0';
        sel_mux_ULA_br <= '0';
        sel_OP_ULA <= "00";     -- ADD
        sel_mux_acc_in <= "10"; -- Seleciona saída da ULA para a entrada do ACC1
        wr_en_ACC1 <= '1'; 

        wait for period_time;
        wr_en_ACC1 <= '0';

        -- TESTE 4: MOV R5, ACC1 (ACC1 -> R5)
        sel_ACCs <= '0';        -- Seleciona ACC1
        sel_mux_br <= '1';      -- Seleciona acc_out no MUX de entrada do Banco
        reg_wr_br <= "0101";    -- Escreve no R5
        reg_read_br <= "0101";  -- Aponta a leitura do Banco para R5
        wr_en_BR <= '1';
        
        wait for period_time;
        wr_en_BR <= '0';

        -- TESTE 5: MOV ACC2, R3 (R3 -> ACC2)
        reg_read_br <= "0011";   -- Lê R3
        sel_mux_acc_in <= "00";  -- Seleciona br_out no MUX de entrada do ACC
        wr_en_ACC2 <= '1';       -- Habilita escrita no ACC2
        
        wait for period_time;
        wr_en_ACC2 <= '0';

        wait;
    end process;

end architecture a_ULA_BancReg_tb;