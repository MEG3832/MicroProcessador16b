library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_BancReg_tb is
end;

architecture a_ULA_BancReg_tb of ULA_BancReg_tb is
    
    component ULA_BancReg
    port(
            clk: in std_logic;
            wr_en_ACC1, wr_en_ACC2, rst_ACC1, rst_ACC2: in std_logic; 
            wr_en_BR: in std_logic; 
            rst_BR: in std_logic;
            rst_ACC: in unsigned(1 downto 0); 

            sel_OP_ULA: in unsigned(1 downto 0); 
            load_cte: in unsigned(15 downto 0); 
            sel_mux_acc_in: in unsigned (1 downto 0); 
            sel_mux_br: in std_logic; 
            sel_ACCs: in std_logic; 
            sel_mux_ULA_br: in std_logic; 
            sel_mux_ULA_acc: in std_logic; 
            cte_comparacao: in unsigned(15 downto 0); 
            reg_wr_br: in unsigned(3 downto 0);
            reg_read_br: in unsigned(3 downto 0);

            out_BR: out unsigned(15 downto 0);
            out_ACC1: out unsigned(15 downto 0);
            out_ACC2: out unsigned(15 downto 0)
    );
    end component;

    -- 2. Sinais do Testbench
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk         : std_logic := '0';

    -- Sinais de Controle (1 bit)
    signal wr_en_ACC1, wr_en_ACC2, rst_ACC1, rst_ACC2 : std_logic := '0';
    signal wr_en_BR, rst_BR : std_logic := '0';
    signal sel_mux_br, sel_ACCs, sel_mux_ULA_br, sel_mux_ULA_acc : std_logic := '0';
    
    -- Sinais de Dados e Seletores Múltiplos
    signal rst_ACC : unsigned(1 downto 0) := "00";
    signal sel_OP_ULA : unsigned(1 downto 0) := "00";
    signal load_cte, cte_comparacao : unsigned(15 downto 0) := (others => '0');
    signal sel_mux_acc_in : unsigned(1 downto 0) := "00";
    signal reg_wr_br, reg_read_br : unsigned(3 downto 0) := "0000";

    -- Sinais de Saída para o GTKWave
    signal out_BR, out_ACC1, out_ACC2 : unsigned(15 downto 0);

begin
    -- 3. Instanciação do UUT (Unit Under Test)
    uut: ULA_BancReg port map (
        clk => clk,
        wr_en_ACC1 => wr_en_ACC1, wr_en_ACC2 => wr_en_ACC2,
        rst_ACC1 => rst_ACC1, rst_ACC2 => rst_ACC2,
        wr_en_BR => wr_en_BR, rst_BR => rst_BR, rst_ACC => rst_ACC,
        sel_OP_ULA => sel_OP_ULA,
        load_cte => load_cte,
        sel_mux_acc_in => sel_mux_acc_in,
        sel_mux_br => sel_mux_br,
        sel_ACCs => sel_ACCs,
        sel_mux_ULA_br => sel_mux_ULA_br,
        sel_mux_ULA_acc => sel_mux_ULA_acc,
        cte_comparacao => cte_comparacao,
        reg_wr_br => reg_wr_br, reg_read_br => reg_read_br,
        out_BR => out_BR, out_ACC1 => out_ACC1, out_ACC2 => out_ACC2
    );

    -- 4. Geração de Clock e Tempo Máximo de Simulação
    reset_global: process
    begin
        -- Zera o Banco e os Acumuladores no começo da simulação
        rst_BR <= '1'; rst_ACC1 <= '1'; rst_ACC2 <= '1';
        wait for period_time*2; 
        rst_BR <= '0'; rst_ACC1 <= '0'; rst_ACC2 <= '0';
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 20 us; -- Aumentei um pouco para caber vários testes
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

    -- 5. Processo de Estímulos (O "Cérebro" testando o caminho dos dados)
    process
    begin
        wait for 200 ns; -- Aguarda o reset terminar

        -- ==============================================================
        -- TESTE 1: Instrução de Carga Direta no ACC1 (Ex: LD A, 5)
        -- ==============================================================
        -- Objetivo: Fazer o número 5 chegar da entrada constante até o ACC1
        load_cte <= "0000000000000101"; -- Valor 5
        -- No seu mux_3in_acc_in: input1 é o load_cte. Logo o seletor é "01"
        sel_mux_acc_in <= "01"; 
        wr_en_ACC1 <= '1'; -- Autoriza a escrita no ACC1
        wait for period_time;
        wr_en_ACC1 <= '0'; -- Fecha a escrita
        wait for period_time;


        -- ==============================================================
        -- TESTE 2: Instrução de Carga Direta no Banco (Ex: LD R3, 10)
        -- ==============================================================
        -- Objetivo: Gravar o valor 10 no registrador R3
        load_cte <= "0000000000001010"; -- Valor 10
        -- No seu mux_2in_br_in: input0 é o load_cte. Logo seletor é '0'
        sel_mux_br <= '0';
        reg_wr_br <= "0011"; -- Seleciona a gaveta R3
        wr_en_BR <= '1'; -- Autoriza escrita no Banco
        wait for period_time;
        wr_en_BR <= '0'; -- Fecha a escrita
        wait for period_time;


        -- ==============================================================
        -- TESTE 3: Instrução de Soma (Ex: ADD A, R3)
        -- ==============================================================
        -- Objetivo: Somar ACC1 (5) + R3 (10) e guardar o resultado (15) no ACC1
        
        -- 3.1) Configurar as leituras
        sel_ACCs <= '0';      -- Escolhe ler o ACC1 para mandar pra ULA
        reg_read_br <= "0011";-- Escolhe ler o R3 para mandar pra ULA
        
        -- 3.2) Roteamento para as entradas da ULA
        sel_mux_ULA_acc <= '0'; -- Entrada A da ULA recebe do ACC (input0)
        sel_mux_ULA_br <= '0';  -- Entrada B da ULA recebe do Banco (input0)
        
        -- 3.3) Operação da ULA
        sel_OP_ULA <= "00"; -- Assumindo que "000" é a soma na sua ULA
        
        -- 3.4) Roteamento da saída da ULA de volta para o Acumulador
        -- No mux_3in_acc_in: input2 é o ula_out. Logo o seletor é "10"
        sel_mux_acc_in <= "10"; 
        
        -- 3.5) Pulso de gravação no ACC1
        wr_en_ACC1 <= '1'; 
        wait for period_time;
        wr_en_ACC1 <= '0';
        
        -- Neste ponto, se você olhar o GTKWave, a saída "out_ACC1" 
        -- deve pular de 5 para 15 (0x000F em Hexadecimal).
        wait for period_time;

        wait; -- <== OBRIGATÓRIO TERMINAR COM WAIT; !!!
    end process;

end architecture a_ULA_BancReg_tb;