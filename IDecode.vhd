----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2021 04:08:51 PM
-- Design Name: 
-- Module Name: IDecode - Behavioral
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

entity IDecode is
    Port ( 
        clk : in std_logic;
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
end IDecode;

architecture Behavioral of IDecode is

component RegisterFile is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           regWr : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;

    signal mux_WriteAddr: std_logic_vector(2 downto 0);


begin

RF1: RegisterFile port map(instr(12 downto 10), instr(9 downto 7), mux_WriteAddr, writeData, clk, regWrite, readData1, readData2);

--mux 
process(regDst, instr(6 downto 4), instr(9 downto 7))
begin

    case (regDst) is
        when '0' => mux_WriteAddr <= instr(9 downto 7);
        when '1' => mux_WriteAddr <= instr(6 downto 4);
        when others => mux_WriteAddr <= instr(6 downto 4);
    end case;
end process;

--sign extension
process(extOp, instr)
begin
    if (extOp = '0') then --zero ext
            extendedImm<= ("000000000" & instr(6 downto 0));
    else
            if (instr(6) = '1') then --sign ext
                extendedImm<= "111111111" & instr(6 downto 0);
            else
                extendedImm<= "000000000" & instr(6 downto 0);
            end if;
    end if;
end process;

funct <= instr(2 downto 0);
sa <= instr(3);

end Behavioral;
