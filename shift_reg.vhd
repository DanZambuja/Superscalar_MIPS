library IEEE; use IEEE.STD_LOGIC_1164.all;  use IEEE.STD_LOGIC_ARITH.all;

entity shift_register is -- flip-flop with synchronous reset
  generic(width: integer);
  port(clk, enable, reset: in  STD_LOGIC;
       d:          in  STD_LOGIC_VECTOR(31 downto 0);
       q:          out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture asynchronous of shift_register is
signal un1, un2: unsigned(31 downto 0);
begin
  process(clk, reset) begin
    if reset then  q <= (others => '0');
    elsif rising_edge(clk) then
        if enable then
            un1 <= unsigned(d) + 1;
            q <= q(30 downto 0) & '0';
        end if;
    end if;
  end process;
end;