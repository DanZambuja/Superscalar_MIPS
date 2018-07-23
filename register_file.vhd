library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity Register_File is
  port(
    CLK:           in  STD_LOGIC;
    WE_A, WE_B, WE_C: in  STD_LOGIC; --write enable
    RA1_A, RA2_A: in STD_LOGIC_VECTOR(4 downto 0); -- register selector for ULA 1
    RA1_B, RA2_B: in STD_LOGIC_VECTOR(4 downto 0); -- register selector for ULA 2
    RA1_C, RA2_C: in STD_LOGIC_VECTOR(4 downto 0); -- register selector for ULA 3
    WA_A, WA_B, WA_C: in  STD_LOGIC_VECTOR(4 downto 0); -- register selector for write operation
    WD_A, WD_B, WD_C: in  STD_LOGIC_VECTOR(31 downto 0); -- data to be writen
    RD1_A, RD2_A: out STD_LOGIC_VECTOR(31 downto 0); -- output data for ULA 1
    RD1_B, RD2_B: out STD_LOGIC_VECTOR(31 downto 0); -- output data for ULA 2
    RD1_C, RD2_C: out STD_LOGIC_VECTOR(31 downto 0) -- output data for ULA 3
  ); 
end;

architecture Behavioral of Register_File is
  type ramtype is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
  signal mem: ramtype;
begin
  -- three-ported register file
  -- read two ports combinationally
  -- write third port on rising edge of clock
  -- register 0 hardwired to 0
  -- note: for pipelined processor, write third port
  -- on falling edge of clk
  process(CLK) begin
    if rising_edge(CLK) then
      if WE_A = '1' then mem(to_integer(WA_A)) <= WD_A;
      end if;
      if WE_B = '1' then mem(to_integer(WA_B)) <= WD_B;
      end if;
      if WE_C = '1' then mem(to_integer(WA_C)) <= WD_C;
      end if;
    end if;
  end process;
  process(all) begin -- register 0 hardcoded to 0 due to usage frequency
    if (to_integer(RA1_A) = 0) then RD1_A <= X"00000000";
      else RD1_A <= mem(to_integer(RA1_A));
    end if;
    if (to_integer(RA2_A) = 0) then RD2_A <= X"00000000"; 
      else RD2_A <= mem(to_integer(RA2_A));
    end if;
    if (to_integer(RA1_B) = 0) then RD1_B <= X"00000000";
      else RD1_B <= mem(to_integer(RA1_B));
    end if;
    if (to_integer(RA2_B) = 0) then RD2_B <= X"00000000"; 
      else RD2_B <= mem(to_integer(RA2_B));
    end if;
    if (to_integer(RA1_C) = 0) then RD1_C <= X"00000000";
      else RD1_C <= mem(to_integer(RA1_C));
    end if;
    if (to_integer(RA2_C) = 0) then RD2_C <= X"00000000"; 
      else RD2_C <= mem(to_integer(RA2_C));
    end if;
  end process;
end;