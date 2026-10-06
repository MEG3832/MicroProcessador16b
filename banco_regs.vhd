library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--notas:
-- **rst**: zera todos os registradores ao mesmo tempo
-- **wr_en_br**: pega o valor do data_wr e salva no registrador indicado pelo reg_wr 
-- se este pino estiver em '1' no momento em que o clock der um pulso de subida
-- **data_wr**: valor a ser escrito no registrador selecionado
-- **reg_read**: identifica em qual registrador estamos lendo
-- **reg_wr**: identifica em qual registrador estamos escrevendo
-- **data_reg**: saída do registrador q selecionamos pelo reg_read

entity banco_regs is
    port (
        wr_en_br: in std_logic;
        clk: in std_logic;
        rst: in std_logic;

        data_wr: in unsigned(15 downto 0);

        reg_read: in unsigned(3 downto 0); -- identifica em quall registrador estamos lendo...
        reg_wr: in unsigned(3 downto 0); -- identifica em quall registrador estamos escrevendo...

        data_reg: out unsigned(15 downto 0) -- saída

    );
end entity;


architecture a_banco_regs of banco_regs is
    component reg_16bits
    port (
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)

    );
    end component;

-- Esses dados já vem das entradas do banco de registradores :)
-- signal clk, rst, wr_en: std_logic; 
-- signal data_in, data_out: unsigned(15 downto 0);
signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6, wr_en7, wr_en8, wr_en9: std_logic;
signal out_reg0, out_reg1, out_reg2, out_reg3, out_reg4, out_reg5, out_reg6, out_reg7, out_reg8, out_reg9: unsigned(15 downto 0);

begin

    wr_en0 <= '1' when (wr_en_br = '1' and reg_wr = "0000") else '0';
    wr_en1 <= '1' when (wr_en_br = '1' and reg_wr = "0001") else '0';
    wr_en2 <= '1' when (wr_en_br = '1' and reg_wr = "0010") else '0';
    wr_en3 <= '1' when (wr_en_br = '1' and reg_wr = "0011") else '0';
    wr_en4 <= '1' when (wr_en_br = '1' and reg_wr = "0100") else '0';
    wr_en5 <= '1' when (wr_en_br = '1' and reg_wr = "0101") else '0';
    wr_en6 <= '1' when (wr_en_br = '1' and reg_wr = "0110") else '0';
    wr_en7 <= '1' when (wr_en_br = '1' and reg_wr = "0111") else '0';
    wr_en8 <= '1' when (wr_en_br = '1' and reg_wr = "1000") else '0';
    wr_en9 <= '1' when (wr_en_br = '1' and reg_wr = "1001") else '0';

    reg0: reg_16bits port map (clk => clk,
                               rst => rst,
                               wr_en => wr_en0,
                               data_in => data_wr,
                               data_out => out_reg0);
    reg1: reg_16bits port map (clk => clk,
                               rst => rst,
                               wr_en => wr_en1,
                               data_in => data_wr,
                               data_out => out_reg1);
    reg2: reg_16bits port map (clk => clk,
                               rst => rst,
                               wr_en => wr_en2,
                               data_in => data_wr,
                               data_out => out_reg2);
    reg3: reg_16bits port map (clk => clk,
                               rst => rst,
                               wr_en => wr_en3,
                               data_in => data_wr,
                               data_out => out_reg3);
    reg4: reg_16bits port map (clk => clk,
                               rst => rst,
                               wr_en => wr_en4,
                               data_in => data_wr,
                               data_out => out_reg4);
    reg5: reg_16bits port map (clk => clk,
                               rst => rst,
                               wr_en => wr_en5,
                               data_in => data_wr,
                               data_out => out_reg5);
    reg6: reg_16bits port map (clk => clk,
                               rst => rst,
                               wr_en => wr_en6,
                               data_in => data_wr,
                               data_out => out_reg6);
    reg7: reg_16bits port map (clk => clk,
                               rst => rst,
                               wr_en => wr_en7,
                               data_in => data_wr,
                               data_out => out_reg7);
    reg8: reg_16bits port map (clk => clk,
                               rst => rst,
                               wr_en => wr_en8,
                               data_in => data_wr,
                               data_out => out_reg8);
    reg9: reg_16bits port map (clk => clk,
                               rst => rst,
                               wr_en => wr_en9,
                               data_in => data_wr,
                               data_out => out_reg9);

    -- O bloco 'process' não entra aqui porque o clock é lido dentro dos registradores
    data_reg <= out_reg0 when reg_read = "0000" else -- se estou lendo os regs,
                out_reg1 when reg_read = "0001" else -- a saída do banco d regs eh alimentado
                out_reg2 when reg_read = "0010" else
                out_reg3 when reg_read = "0011" else
                out_reg4 when reg_read = "0100" else
                out_reg5 when reg_read = "0101" else
                out_reg6 when reg_read = "0110" else
                out_reg7 when reg_read = "0111" else
                out_reg8 when reg_read = "1000" else
                out_reg9 when reg_read = "1001" else
                "0000000000000000";

end architecture;