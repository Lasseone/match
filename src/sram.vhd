library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity SRAM is
  generic (
    char_size: integer; -- how many bits are fit into each index e.g. incrementing a pointer will jump char bits
    size: integer -- number of char worth of sram
  )

  port (
    clk: in std_logic;
    read, enable: in std_logic;
    address: in unsigned(ceil(log2(real(size)))-1 downto 0);
    data_in: in std_logic_vector(char_size-1 downto 0);
    data_out: out std_logic_vector(char_size-1 downto 0);
  );
end SRAM;

architecture behavioural of SRAM is
  type mem_block is array(0 to size-1) of std_logic_vector(char_size-1 downto 0);

  signal data: mem_block;
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if read = '1' then
        mem_block(to_integer(address)) <= data_in;
      end if;
    end if;
  end process;

  process(enable)
  begin
    if enable = '1' then
      data_out <= mem_block(to_integer(address));
    elsif enable = '0' then
      data_out <= (others => 'Z');
    end if;
  end process;
end behavioural;
