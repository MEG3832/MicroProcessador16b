library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_instrucao is
    port (
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(17 downto 0);
        data_out : out unsigned(17 downto 0)
    );
end entity;

architecture a_reg_instrucao of reg_instrucao is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            if wr_en = '1' then
                data_out <= data_in;
            end if;
        end if;
    end process;
end architecture;