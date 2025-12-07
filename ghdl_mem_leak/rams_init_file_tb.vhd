-- Initializing Block RAM from external data file
-- File: rams_init_file.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity rams_init_file_tb is
    generic (
        AW : positive := 6;
        DW : positive := 32
    );
end rams_init_file_tb;

architecture behav of rams_init_file is
    signal clk  : std_logic;
    signal we   : std_logic;
    signal addr : std_logic_vector(AW-1 downto 0);
    signal din  : std_logic_vector(DW-1 downto 0);
    signal dout : std_logic_vector(DW-1 downto 0);
begin

    -- clock
    clk <= not clk after 5 ns;

    -- stimuli
    process
    begin
        wait until rising_edge(clk);
        we   <= '1';
        for i in 0 to 2**AW-1 loop
            addr <= std_logic_vector(to_unsigned(i, AW));
            din  <= std_logic_vector(to_unsigned(i, DW));
            wait until rising_edge(clk);
        end loop;
        we   <= '0';
        din  <= (others => 'U');
        wait until rising_edge(clk);
        for i in 0 to 2**AW-1 loop
            addr <= std_logic_vector(to_unsigned(i, AW));
            wait until rising_edge(clk);
        end loop;
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait;
    end process;

end behav;
