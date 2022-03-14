----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2021 04:16:57 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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
entity SSD is
    Port ( d0 : in STD_LOGIC_VECTOR (3 downto 0);
           d1 : in STD_LOGIC_VECTOR (3 downto 0);
           d2 : in STD_LOGIC_VECTOR (3 downto 0);
           d3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end SSD;

architecture Behavioral of SSD is

signal sel: STD_LOGIC_VECTOR(15 DOWNTO 0);
signal tempD: STD_LOGIC_VECTOR(3 DOWNTO 0);
signal cnt: STD_LOGIC_VECTOR(15 DOWNTO 0);
begin

mux41_1: process(sel, d0, d1, d2, d3)
begin
    case sel(15 DOWNTO 14)  is
        when "00"	=> tempD <= d0; 
        when "01"	=> tempD <= d1; 
        when "10"	=> tempD <= d2; 
        when others	=> tempD <= d3; 
    end case;
end process;

mux41_2: process(sel)
begin
    case sel(15 DOWNTO 14) is
        when "00"	=>  an <= "1110";
        when "01"	=>  an <= "1101";
        when "10"	=>  an <= "1011";
        when others	=>  an <= "0111";
    end case;
end process;

counter: process(clk)
begin 
if rising_edge(clk) then
    sel <= sel + 1;
 end if;
 end process;

    
     with tempD SELect
    cat<= "1111001" when "0001",   --1
          "0100100" when "0010",   --2
          "0110000" when "0011",   --3
          "0011001" when "0100",   --4
          "0010010" when "0101",   --5
          "0000010" when "0110",   --6
          "1111000" when "0111",   --7
          "0000000" when "1000",   --8
          "0010000" when "1001",   --9
          "0001000" when "1010",   --A
          "0000011" when "1011",   --b
          "1000110" when "1100",   --C
          "0100001" when "1101",   --d
          "0000110" when "1110",   --E
          "0001110" when "1111",   --F
          "1000000" when others;   --0
       
end Behavioral;
