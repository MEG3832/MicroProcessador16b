library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2in_tb is
end;

architecture arq_mux_2in_tb of mux_2in_tb is
    component mux_2in
    port (
            input0: in unsigned(15 downto 0);
            input1: in unsigned(15 downto 0);
            sel       : in std_logic;
            saida     : out unsigned(15 downto 0)

    );
    end component;

    signal input0, input1: unsigned(15 downto 0);
    signal sel: std_logic;
    signal saida: unsigned(15 downto 0);

    begin
        uut: mux_2in port map
        (
            input0 => input0,
            input1 => input1,
            sel => sel,
            saida => saida
        );

process
begin

    input0 <= "0000000000000001";
    input1 <= "0000000000000010";
    sel <= '0'; wait for 50 ns;

    input0 <= "0000000000000001";
    input1 <= "0000000000000010";
    sel <= '1'; wait for 50 ns;

wait;
end process;
end architecture;