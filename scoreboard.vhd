library IEEE; 
use IEEE.STD_LOGIC_1164.all;  
use IEEE.STD_LOGIC_ARITH.all;

entity scoreboard is

end scoreboard;

architecture hierarchical of scoreboard is 

    component FU_status is
        port(
            clock         :  in  STD_LOGIC;
            write_enable  :  in  STD_LOGIC;
            FU_sel        :  in  STD_LOGIC_VECTOR(1 downto 0);
            write_status  :  out STD_LOGIC_VECTOR(26 downto 0);
            status        :  out STD_LOGIC_VECTOR(26 downto 0)
        );
    end component;

    component instruction_status is
        port(
            clock         :  in  STD_LOGIC;
            write_enable  :  in  STD_LOGIC;
            instr_address :  in  STD_LOGIC_VECTOR(5 downto 0);
            write_status  :  in  STD_LOGIC_VECTOR(26 downto 0);
            status        :  out STD_LOGIC_VECTOR(26 downto 0)
        );
    end component;

    component reg_res_status is
        port(
            clock         :  in  STD_LOGIC;
            write_enable  :  in  STD_LOGIC;
            reg_sel       :  in  STD_LOGIC_VECTOR(4 downto 0);
            write_status  :  out STD_LOGIC_VECTOR(1 downto 0);
            status        :  out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

begin



end;