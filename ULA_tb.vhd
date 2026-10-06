library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_tb is
end;

architecture arq_ULA_tb of ULA_tb is
    component ULA
    port (
        entrada_A: in unsigned(15 downto 0);
        entrada_B: in unsigned(15 downto 0);
        select_op: in unsigned(1 downto 0);

        saida: out unsigned(15 downto 0)

    );
    end component;

    signal entrada_A, entrada_B, saida: unsigned(15 downto 0);
    signal select_op: unsigned(1 downto 0);

begin
        uut: ULA port map
        (
           entrada_A => entrada_A,
           entrada_B => entrada_B,
           select_op => select_op,
           saida => saida

        );

process
begin

    -- teste 1: A = 1, B = 0
    entrada_A <= "0000000000000001";
    entrada_B <= "0000000000000000";
    select_op <= "00"; wait for 50 ns; -- soma
    select_op <= "01"; wait for 50 ns; -- sub
    select_op <= "10"; wait for 50 ns; -- OR
    select_op <= "11"; wait for 50 ns; -- AND

    -- teste 2: A = 0, B = 1
    entrada_A <= "0000000000000000";
    entrada_B <= "0000000000000001";
    select_op <= "00"; wait for 50 ns; -- soma
    select_op <= "01"; wait for 50 ns; -- sub
    select_op <= "10"; wait for 50 ns; -- OR
    select_op <= "11"; wait for 50 ns; -- AND

    -- teste 3: A = -1, B = 1
    entrada_A <= "1111111111111111";
    entrada_B <= "0000000000000001";
    select_op <= "00"; wait for 50 ns; -- soma
    select_op <= "01"; wait for 50 ns; -- sub
    select_op <= "10"; wait for 50 ns; -- OR
    select_op <= "11"; wait for 50 ns; -- AND 

    -- teste 4: A = 1, B = -1
    entrada_A <= "0000000000000001";
    entrada_B <= "1111111111111111";
    select_op <= "00"; wait for 50 ns; -- soma
    select_op <= "01"; wait for 50 ns; -- sub
    select_op <= "10"; wait for 50 ns; -- OR
    select_op <= "11"; wait for 50 ns; -- AND

    -- teste 5: A = -1, B = -1
    entrada_A <= "1111111111111111";
    entrada_B <= "1111111111111111";
    select_op <= "00"; wait for 50 ns; -- soma
    select_op <= "01"; wait for 50 ns; -- sub
    select_op <= "10"; wait for 50 ns; -- OR
    select_op <= "11"; wait for 50 ns; -- AND

    -- teste 6: A = 1, B = 1
    entrada_A <= "0000000000000001";
    entrada_B <= "0000000000000001";
    select_op <= "00"; wait for 50 ns; -- soma
    select_op <= "01"; wait for 50 ns; -- sub
    select_op <= "10"; wait for 50 ns; -- OR
    select_op <= "11"; wait for 50 ns; -- AND
    wait;
end process;
end architecture;

    