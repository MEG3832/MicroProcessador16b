library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM_tb is
end;

architecture arq_ROM_tb of ROM_tb is
    component ROM
        port (
            endereco: in unsigned (6 downto 0);
            dado: out unsigned (17 downto 0)
        );
    end component;

    signal endereco: unsigned (6 downto 0);
    signal dado: unsigned (17 downto 0);

    begin
        uut: ROM port map
        (
           endereco => endereco,
           dado => dado
        );

    process
    begin
        endereco <= "0000000";
        wait for 50 ns;

        endereco <= "0000001";
        wait for 50 ns;
        
        endereco <= "0000010";
        wait for 50 ns;

        endereco <= "0000011";
        wait for 50 ns;

        endereco <= "0000100";
        wait for 50 ns;

        endereco <= "0000101";
        wait for 50 ns;

        endereco <= "0000110";
        wait for 50 ns;

        wait;

    end process;
end architecture;

