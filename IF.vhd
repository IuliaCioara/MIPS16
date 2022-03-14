----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2021 08:31:49 AM
-- Design Name: 
-- Module Name: IF - Behavioral
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

entity InstrFetch is
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
end InstrFetch;

architecture Behavioral of InstrFetch is

--PC
signal pc: std_logic_vector(15 downto 0):=X"0000";
signal pcIncr: std_logic_vector(15 downto 0):=X"0000";
signal mux1_Out: std_logic_vector(15 downto 0):=X"0000";
signal nextAddrS: std_logic_vector(15 downto 0):=X"0000";

--ROM
type ROM is array (0 to 15) of STD_LOGIC_VECTOR (15 downto 0);
signal memInstr: ROM :=(
B"001_000_010_0000001",  --X"2101", addi $2,$0,1  --initializam R2 cu 1
B"001_000_001_0000000",  --X"2080"	--addi $1,$0,0 -- initializam R1 cu 0
B"001_000_100_0000001",	 --X"2201"	--addi $4,$0,1 --initializam R4 cu 1
B"001_000_011_0000001", --x"2181", addi $3,$0,1   --initializam R3 cu 1
B"111_0000000000010", --X"E002", J 2 --salt la instr cu index 2
B"000_011_011_001_0_011",  --X"0EA3", add $1,$3,$2 -- R1=R2+R3
B"000_0_001_001_001_100", --x"0249", sll $1,$1,1 --deplasam R1 cu 1 la stanga cu 1 bit 
B"011_011_001_0000111", --X"6b87", sw $1,7($3)  --stocam in memorie la adresa 7+R3 valoarea din R1
B"010_010_010_0001010", --X"4A0A", lw $2,10($2) --incarca din memorie in R2 de la adresa 10+R2
B"100_001_010_0000001", --X"8501", beq $1,$2,1  --daca R1=R2 se sare cu 2 instr
B"111_0000000000100", --X"E004", J 4 --salt la instr cu index 4
B"011_000_001_0001010", --X"508A", sw $1,10($0) --stocheaza in memorie la adresa 10 val din R1
others=>X"0000"
);	 
 
begin
programcounter: process(clk, pcReset)
begin 
    if pcReset = '1' then
         pc <=  X"0000";
    else if rising_edge(clk) and btnEn ='1'  then
         pc <= nextAddrS;
    end if;
    end if;
 
 end process;
 
 -- PC + 1
  pcIncr <= pc + 1;   
  
  -- ROM
  instr <= memInstr(conv_integer(pc(3 downto 0)));
  
   -- next instruction
   nextInstrAddr <= nextAddrS; 
           
  -- mux for branch
  process(branchCtrl, pcIncr, branchAddr)
  begin
    case (branchCtrl) is
        when '0' => mux1_Out <= pcIncr;
        when '1' => mux1_Out <= branchAddr;
        when others => mux1_Out <= x"0000";
    end case;
  end process;
  
  -- mux for jump
  process(jmpCtrl, jmpAddr, mux1_Out)
  begin
    case (jmpCtrl) is
        when '0' => nextAddrS <= mux1_Out;
        when '1' => nextAddrS <= jmpAddr;
        when others => nextAddrS <= X"0000";
     end case;
  end process;
 
end Behavioral;

