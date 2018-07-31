library IEEE; 
use IEEE.STD_LOGIC_1164.all;  
use IEEE.STD_LOGIC_ARITH.all;

entity flopr_en is -- flip-flop with synchronous reset
  generic(width: integer);
  port(
    clk, reset: in  STD_LOGIC;
    enable    : in  STD_LOGIC;
    d         : in  STD_LOGIC_VECTOR(width-1 downto 0);
    q         : out STD_LOGIC_VECTOR(width-1 downto 0)
  );
end;

architecture asynchronous of flopr_en is
begin
  process(clk, reset, enable) begin
    if reset then  q <= (others => '0');
    elsif rising_edge(clk) then
        if enable then 
            q <= d;
        end if;
    end if;
  end process;
end;