library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real.all;

entity network_interface is
  generic (
    rx_buff_size: integer -- number of chars
  )
  
  port (
    data: inout std_logic_vector(3 downto 0);
    read: in std_logic;
    ready: out std_logic;

    clk: in std_logic
  );
end network_interface;

architecture behavioural of network_interface is
  constant char_size: integer := 4; -- 4 bits per address
  constant addr_size: integer := integer(ceil(log2(real(rx_buff_size))));

  signal rx_head_addr, rx_tail_addr: unsigned(addr_size-1 downto 0);

  signal rx_buff_out, rx_buff_in: std_logic_vector(char_size-1 downto 0);
  signal rx_buff_read, rx_buff_enable: std_logic;
  signal rx_buff_addr: unsigned(addr_size-1 downto 0);
  
  signal rx_ready: std_logic;
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if read = '1' then
        if rx_ready = '1' then
          rx_buff_read <= '1';
          rx_buff_in <= data;
          rx_buff_addr <= rx_head_addr;
          rx_ready <= '0';
        
        elsif rx_ready = '0' then
          rx_buff_read <= '0';
          rx_buff_addr <= rx_buff_addr + 1
          rx_ready <= '1';
        end if;
      end if;
    end if;
  end process;

  ready <= rx_ready;

  rx_buff: entity work.sram
    generic map (
      char_size => char_size,
      size => rx_buff_size
    )

    port map (
      clk => clk,
      read => rx_buff_read,
      enable => rx_buff_enable,
      address => rx_buff_address,
      data_in => rx_buff_in,
      data_out => rx_buff_out
    );
end behavaioural;
