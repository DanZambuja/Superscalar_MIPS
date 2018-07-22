library IEEE; 
use IEEE.STD_LOGIC_1164.all; use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all; 

entity Data_Memory is -- data memory
  port(
    CLK, WE_A, WE_B, WE_C  :  in STD_LOGIC;
    WA_A, WA_B, WA_C       :  in STD_LOGIC_VECTOR(4 downto 0);
    WD_A, WD_B, WD_C       :  in STD_LOGIC_VECTOR(31 downto 0);
    RD_A, RD_B, RD_C       :  out STD_LOGIC_VECTOR(31 downto 0)
  );
end;

architecture behave of Data_Memory is
begin
  process is
    type ramtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    variable mem: ramtype;
  begin
    -- read or write memory
    loop
      if clk'event and clk = '1' then
          if (we = '1') then mem(to_integer(a(7 downto 2))) := wd;
          end if;
      end if;
      rd <= mem(to_integer(a(7 downto 2))); 
      wait on clk, a;
    end loop;

  end process;
end;