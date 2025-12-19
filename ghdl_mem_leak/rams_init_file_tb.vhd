library std;
use std.textio.all;
use std.env.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rams_init_file_tb is
end rams_init_file_tb;

architecture sim of rams_init_file_tb is

  type array_bv8_t is array (natural range <>) of bit_vector(8-1 downto 0);

  -- memory configuration --
  constant mem_size_c : natural := 4*1024*1024; -- bytes
--
  -- initialize array_bv8_t array from plain binary file --
  impure function array_bv8_init_bin_f(
    file_name : string;
    size      : natural
  ) return array_bv8_t is
    type char_file is file of character;
    file     init_f : char_file;
    variable array_v : array_bv8_t(0 to size-1);
    variable index_v : natural;
    variable data_v  : character;
  begin
    if (file_name /= "") then
      file_open(init_f, file_name, READ_MODE);
      index_v := 0;
      while (endfile(init_f) = false) and (index_v < size) loop
        read(init_f, data_v);
        array_v(index_v) := to_bitvector(std_logic_vector(to_unsigned(character'pos(data_v),8)));
        index_v := index_v + 1;
      end loop;
    end if;
    file_close(init_f);
    return array_v;
  end function array_bv8_init_bin_f;

  -- generators --
  signal clk, rst : std_ulogic := '0';

  signal mem8 : array_bv8_t(0 to mem_size_c-1);

begin

  -- clock/reset

  clk <= not clk after 5 ns;
  
  process
  begin
    rst <= '1';
    for i in 0 to 10-1 loop
      wait until rising_edge(clk);
    end loop;
    -- synchronous reset release
    rst <= '0';
    wait;
  end process;

  -- memory

  main: process
  begin
    -- memory initialization
    mem8 <= array_bv8_init_bin_f("main.bin", mem_size_c);
    wait;
  end process main;

end sim;
