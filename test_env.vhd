----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2021 07:39:11 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is 
      Port(clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG
    Port ( btn : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           clk : in STD_LOGIC;
           en : out STD_LOGIC_VECTOR(4 DOWNTO 0));
end component ;

component SSD
    Port ( d0 : in STD_LOGIC_VECTOR (3 downto 0);
           d1 : in STD_LOGIC_VECTOR (3 downto 0);
           d2 : in STD_LOGIC_VECTOR (3 downto 0);
           d3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component InstrFetch is
    Port (
        clk: in std_logic;
        branchAddr: in std_logic_vector(15 downto 0);
        jmpAddr: in std_logic_vector(15 downto 0);
        jmpCtrl: in std_logic; 
        branchCtrl: in std_logic;
        btnEn: in std_logic; --button from en MPG
        pcReset: in std_logic; --button from en MPG      
        instr: out std_logic_vector(15 downto 0);
        nextInstrAddr: out std_logic_vector(15 downto 0) 
        );
end component;

component IDecode 
    Port (clk : in std_logic;
        instr: in std_logic_vector(15 downto 0);
        writeData: in std_logic_vector(15 downto 0);
        --control signals
        regWrite: in std_logic;
        regDst: in std_logic;
        extOp: in std_logic;
            
        readData1: out std_logic_vector(15 downto 0); 
        readData2: out std_logic_vector(15 downto 0); 
        extendedImm: out std_logic_vector(15 downto 0);
        funct: out std_logic_vector(2 downto 0);
        sa: out std_logic  
    );
end component;

component MainControlUnit 
   Port(instr : in std_logic_vector(2 downto 0);
		regDst : out std_logic;
		extOp: out std_logic;
		ALUSrc: out std_logic;
		branch: out std_logic;
		jmp: out std_logic;
		memWrite: out std_logic;
		memToReg: out std_logic;
		regWrite : out std_logic;
		ALUOp : out std_logic_vector(2 downto 0));
end component;

component IExecuteUnit 
    Port (next_instruction : in  STD_LOGIC_VECTOR (15 downto 0);
          rd1 : in  STD_LOGIC_VECTOR (15 downto 0);
          rd2 : in  STD_LOGIC_VECTOR (15 downto 0);
          ext_imm : in  STD_LOGIC_VECTOR (15 downto 0);
          sa : in  STD_LOGIC;
          func : in  STD_LOGIC_VECTOR (2 downto 0);
          ALUSrc : in  STD_LOGIC;
          ALUOp : in  STD_LOGIC_vector (2 downto 0);
          branch_address : out  STD_LOGIC_VECTOR (15 downto 0); 
          ALURes : out  STD_LOGIC_VECTOR (15 downto 0);
          zero : out  STD_LOGIC);
         
end component;

component MemUnit 
    Port (
        clk: in std_logic;
        ALURes: in std_logic_vector(15 downto 0);
        WriteData: in std_logic_vector(15 downto 0);
        MemWriteCtrl: in std_logic;
        
        MemData: out std_logic_vector(15 downto 0);
        ALUResOUT: out std_logic_vector(15 downto 0)
         );
end component;

    -- IF
signal PCSrcS: std_logic;
signal branchAddrS :std_logic_vector(15 downto 0):=x"0000";
signal jumpAddrS : std_logic_vector(15 downto 0); 
signal instrS: std_logic_vector(15 downto 0); 
signal nextInstrAddrS : std_logic_vector(15 downto 0);
-- counter
signal cnt: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal disp_data: STD_LOGIC_VECTOR(15 downto 0);
signal en: STD_LOGIC_VECTOR(4 downto 0);

--MCU
signal regDstS : STD_LOGIC;
signal extOpS : STD_LOGIC;
signal ALUSrcS :  STD_LOGIC;
signal branchS :  STD_LOGIC;
signal jmpS :  STD_LOGIC;
signal ALUOpS :  STD_LOGIC_VECTOR (2 downto 0);
signal memToRegS :  STD_LOGIC;
signal memWriteS :  STD_LOGIC;
signal regWriteS : STD_LOGIC;
signal regWrite : STD_LOGIC;
signal readData1S : STD_LOGIC_VECTOR (15 downto 0);
signal readData2S :  STD_LOGIC_VECTOR (15 downto 0);

signal extendedImmS :  STD_LOGIC_VECTOR (15 downto 0);
signal functS : STD_LOGIC_VECTOR (2 downto 0);
signal saS: STD_LOGIC;
signal writeDataS :  STD_LOGIC_VECTOR (15 downto 0);
signal WriteDataReg: std_logic_vector(15 downto 0);

-- Exec unit
signal zeroS: STD_LOGIC;
signal ALUResS : std_logic_vector (15 downto 0); -- iesirea din ALU
signal branch_addressS:  std_logic_vector (15 downto 0);

--write back unit
signal ALUResFinalS: STD_LOGIC_VECTOR (15 downto 0);
signal MemDataS: STD_LOGIC_VECTOR (15 downto 0);

begin

display: SSD port map( disp_data(3 downto 0),disp_data(7 downto 4),disp_data(11 downto 8),disp_data(15 downto 12), clk, cat, an);
  
M1: MPG port map(btn, clk, en);


IFetch: InstrFetch port map(clk, branch_addressS,jumpAddrS ,jmpS, PCSrcS, en(1), en(2), instrS, nextInstrAddrS);
      
controlUnit: MainControlUnit port map(instrS(15 downto 13),regDstS, extOpS, ALUSrcS, branchS, jmpS, memWriteS, memToRegS, regWriteS, ALUOpS);

ExecUnit: IExecuteUnit port map(nextInstrAddrS, readData1S, readData2S, extendedImmS, saS , functS, ALUSrcS, ALUOpS, branch_addressS,  ALUResS, zeroS );

MemoryUnit: MemUnit port map(clk, ALUResS, readData2S, memWriteS, memDataS, ALUResFinalS);

-- Zero+Branch
PCSrcS <= zeroS and branchS;

--Jump address
jumpAddrS <= nextInstrAddrS(15 downto 14) & instrS(13 downto 0);

--WriteBack unit-- MUX --
process(MemToRegS, MemDataS, ALUResFinalS)
begin
    case (MemToRegS) is 
        when '1' => writeDataS <= MemDataS;
        when '0' => writeDataS <= ALUResFinalS;
        when others => writeDataS <= ALUResFinalS;
    end case;
end process;

regWrite <=  regWriteS and en(2);  

process(instrS,nextInstrAddrS, readData1S,readData2S,writeDataS,extendedImmS,ALUResS ,MemDataS,writeDataS, sw(7 downto 5))
   begin
     case sw(7 downto 5) is 
       when "000" => disp_data<= instrS;
       when "001" => disp_data<=nextInstrAddrS;
       when "010" => disp_data <=readData1S;
       when "011" => disp_data <=readData2S;
       when "100" => disp_data <= extendedImmS;
       when "101" => disp_data <= ALUResFinalS;
       when "110" => disp_data <= MemDataS;
       when "111" => disp_data <= writeDataS;
       when others => disp_data <=x"FFFF";
      end case;
    end process;
 
 process( sw(0))
   begin
     case sw(0) is 
      when '0' => led(0)<=regDstS;
                  led(1)<=extOpS;
                  led(2)<=ALUSrcS;
                  led(3)<=branchS;
                  led(4)<=jmpS;
                  led(5)<=memToRegS;
                  led(6)<=memWriteS;
                  led(7)<=regWriteS;
                  
      when '1' => led <= X"0000";
                  led(0)<=ALUOpS(0);
                  led(1)<=ALUOpS(1);
                  led(2)<=ALUOpS(2);
        
      when others => led <= x"0000";
      end case;
    end process;


end Behavioral;