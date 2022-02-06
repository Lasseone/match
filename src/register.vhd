library ieee;
use ieee.std_logic_1164.all;

entity reg is
  generic (
    size: integer
  );

  port(
    clk: in std_logic;
    load, enable: in std_logic;
    d: in std_logic_vector(size_bits-1 downto 0);
    q: out std_logic_vector(size_bits-1 downto 0);
  );
end reg;

architecture behavioural of reg is
  signal _d: std_logic_vector(size_bits-1 downto 0);

begin
  process(clk)
  begin
    if rising_edge(clk) then
      if load = '1' then
        _d <= d;
      end if;
    end if;
  end process;

  process(enable)
  begin
    if enable = '1' then
      q <= _d;
    elsif enable = '0' then
      q <= 'Z';
    end if;
  end process;
end behavioural;
