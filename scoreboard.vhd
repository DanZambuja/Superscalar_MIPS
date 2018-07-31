library IEEE; 
use IEEE.STD_LOGIC_1164.all;  
use IEEE.STD_LOGIC_ARITH.all;

entity scoreboard is
    port(
        clock, reset :  in  STD_LOGIC
    );
end scoreboard;

architecture hierarchical of scoreboard is 

    component FU_status is
        port(
            clock         :  in  STD_LOGIC;
            reset         :  in  STD_LOGIC;
            write_enable  :  in  STD_LOGIC;
            FU_sel        :  in  STD_LOGIC_VECTOR(2 downto 0);
            write_status  :  in  STD_LOGIC_VECTOR(26 downto 0);
            status        :  out STD_LOGIC_VECTOR(26 downto 0);
            busy_A, busy_B, busy_C  : out STD_LOGIC_VECTOR(26 downto 0)
        );
    end component;

    component instruction_status is
        port(
            clock         :  in  STD_LOGIC;
            reset         :  in  STD_LOGIC;
            write_enable  :  in  STD_LOGIC;
            instr_address :  in  STD_LOGIC_VECTOR(5 downto 0);
            write_status  :  in  STD_LOGIC_VECTOR(26 downto 0);
            status        :  out STD_LOGIC_VECTOR(26 downto 0)
        );
    end component;

    component reg_res_status is
        port(
            clock         :  in  STD_LOGIC;
            reset         :  in  STD_LOGIC;
            write_enable  :  in  STD_LOGIC;
            reg_sel       :  in  STD_LOGIC_VECTOR(4 downto 0);
            write_status  :  out STD_LOGIC_VECTOR(1 downto 0);
            status        :  out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    component available_FU is
        port(
            selector        : in  STD_LOGIC_VECTOR(2 downto 0);
            available       : out STD_LOGIC_VECTOR(1 downto 0)     
        );
    end component;
    
    component Instruction_Memory is -- instruction memory
        port(
            limited_PC:  in  STD_LOGIC_VECTOR(5 downto 0);
            instruction_A, instruction_B, instruction_C: out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;



    signal pc, instr : STD_LOGIC_VECTOR(31 downto 0);
    signal FU_WE    : STD_LOGIC;
    signal FU_sel    : STD_LOGIC_VECTOR(2 downto 0);
    signal FU_write_status, FU_stat : STD_LOGIC_VECTOR(26 downto 0);
    signal busy_A, busy_B, busy_C :  STD_LOGIC_VECTOR(26 downto 0);
    signal avlb_FU  : STD_LOGIC_VECTOR(1 downto 0);
    signal FU_vect  : STD_LOGIC_VECTOR(2 downto 0);
    
begin

    FU_vect <= busy_A(26) & busy_B(26) & busy_C(26);

    FU_states :  FU_status port map (clock, reset, FU_WE, FU_sel, FU_write_status, FU_stat, busy_A, busy_B, busy_C);

    --instr_stat : instruction_status port map(clock, reset);

    --reg_status : reg_res_status port map(clock, reset);


    avail_FU    : available_FU port map(FU_vect, avlb_FU);

    --scrb_ctrl : scoreboard_control port map(clock, reset);



    --instr_mem : Instruction_Memory port map(pc(7 downto 2), instr);


end;