library ieee;
use ieee.std_logic_1164.all;

entity FFs_flagsULA is
    port (
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        
        -- vem da ULA
        z_in     : in std_logic;
        n_in     : in std_logic;
        v_in     : in std_logic;
        
        -- vão para a UC
        z_out    : out std_logic;
        n_out    : out std_logic;
        v_out    : out std_logic
    );
end entity;

architecture arq_FFs_flagsULA of FFs_flagsULA is
begin

    process(clk, rst)
    begin
        if rst = '1' then

            z_out <= '0';
            n_out <= '0';
            v_out <= '0';
            
        elsif falling_edge(clk) then

            if wr_en = '1' then
                z_out <= z_in;
                n_out <= n_in;
                v_out <= v_in;
            end if;
            -- se wr_en for '0', os valores anteriores sao mantidos
        end if;
    end process;

end architecture;