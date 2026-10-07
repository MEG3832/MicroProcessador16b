library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_BancReg is
    port(
            clk: in std_logic;
            wr_en_ACC1, wr_en_ACC2, rst_ACC1, rst_ACC2: in std_logic; -- vem da UC
            wr_en_BR: in std_logic; -- vem da UC
            rst_BR: in std_logic;
            rst_ACC: in unsigned(1 downto 0); -- 2 bits pra representar os 2 acumuladores

            sel_OP_ULA: in unsigned(1 downto 0); -- a ula vai ter 6 operacoes
            load_cte: in unsigned(15 downto 0); -- sinal q vai para os MUXes pra ver se vamos carregar uma cte
            sel_mux_acc_in: in unsigned (1 downto 0); -- mux para escoler se o resultado para o acc é da ULA, do load cte ou do BR
            sel_mux_br: in std_logic; -- escole se vamos carregar cte ou fazer uma copia (mov)
            sel_ACCs: in std_logic; -- escolhe os acumuladores de saída
            sel_mux_ULA_br: in std_logic; -- escolhe se a entrada 1 da ULA é uma cte ou vem do br
            sel_mux_ULA_acc: in std_logic; -- escolha se a entrada 2 da ula vem do acc ou da cte
            cte_comparacao: in unsigned(15 downto 0); -- constante q vamos comparar com o valor do reg do BR ou a constante com o valor do acc
            reg_wr_br: in unsigned(3 downto 0);
            reg_read_br: in unsigned(3 downto 0);

            out_BR: out unsigned(15 downto 0);
            out_ACC1: out unsigned(15 downto 0);
            out_ACC2: out unsigned(15 downto 0)
    );

end entity;

architecture a_ULA_BancReg of ULA_BancReg is
    component reg_16bits
    port (
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)

    );
    end component;

    component ULA
    port(
        entrada_A: in unsigned(15 downto 0);
        entrada_B: in unsigned(15 downto 0);
        select_op: in unsigned(1 downto 0);

        saida: out unsigned(15 downto 0)

    );
    end component;

    component banco_regs
    port(
        wr_en_br: in std_logic;
        clk: in std_logic;
        rst: in std_logic;

        data_wr: in unsigned(15 downto 0);

        reg_read: in unsigned(3 downto 0); -- identifica em quall registrador estamos lendo...
        reg_wr: in unsigned(3 downto 0); -- identifica em quall registrador estamos escrevendo...

        data_reg: out unsigned(15 downto 0) -- saída

    );
    end component;

    component mux_2in
    port(
        input0: in unsigned(15 downto 0);
        input1: in unsigned(15 downto 0);
        sel       : in std_logic;
        saida     : out unsigned(15 downto 0)

    );
    end component;

    component mux_3in
    port(
        input0: in unsigned(15 downto 0);
        input1: in unsigned(15 downto 0);
        input2: in unsigned(15 downto 0);
        sel       : in unsigned(1 downto 0);
        saida     : out unsigned(15 downto 0)
    );
    end component;

    signal acc_in, acc1_out, acc2_out, br_in, br_out,
    br_ula, acc_ula, ula_out, acc_out: unsigned(15 downto 0);

    begin

    acc1: reg_16bits port map (clk => clk,
                               rst => rst_ACC1,
                               wr_en => wr_en_ACC1,
                               data_in => acc_in,
                               data_out => acc1_out);
    acc2: reg_16bits port map (clk => clk,
                               rst => rst_ACC2,
                               wr_en => wr_en_ACC2,
                               data_in => acc_in,
                               data_out => acc2_out);

    inst_ula: ULA port map (entrada_A => br_ula,
                       entrada_B => acc_ula,
                       select_op => sel_OP_ULA,
                       saida => ula_out);

    br: banco_regs port map (wr_en_br => wr_en_BR,
                             clk => clk,
                             rst => rst_BR,
                             data_wr => br_in,
                             reg_read => reg_read_br,
                             reg_wr => reg_wr_br,
                             data_reg => br_out);

    mux_2in_br_in: mux_2in port map ( input0 => load_cte,
                                      input1 => acc_out,
                                      sel => sel_mux_br,
                                      saida => br_in);

    mux_2in_acc_out: mux_2in port map ( input0 => acc1_out,
                                        input1 => acc2_out,
                                        sel => sel_ACCs,
                                        saida => acc_out);

    mux_2in_br_ula: mux_2in port map ( input0 => br_out,
                                       input1 => cte_comparacao,
                                       sel => sel_mux_ULA_br,
                                       saida => br_ula);

    mux_2in_acc_ula: mux_2in port map ( input0 => acc_out,
                                        input1 => cte_comparacao,
                                        sel => sel_mux_ULA_acc,
                                        saida => acc_ula);

    mux_3in_acc_in: mux_3in port map ( input0 => br_out,
                                      input1 => load_cte,
                                      input2 => ula_out,
                                      sel => sel_mux_acc_in,
                                      saida => acc_in);
    
    out_BR <= br_out;
    out_ACC1 <= acc1_out;
    out_ACC2 <= acc2_out;

end architecture;
