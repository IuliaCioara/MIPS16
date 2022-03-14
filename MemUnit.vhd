library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MemUnit is
    Port (
        clk: in std_logic;
        ALURes: in std_logic_vector(15 downto 0);
        WriteData: in std_logic_vector(15 downto 0);
        MemWriteCtrl: in std_logic;
        
        MemData: out std_logic_vector(15 downto 0);
        ALUResOUT: out std_logic_vector(15 downto 0)
         );
end MemUnit;

architecture Behavioral of MemUnit is

signal address: std_logic_vector(3 downto 0):="0000";

type RAM is array (0 to 15) of std_logic_vector(0 to 15);
signal memRAM: RAM := (
		X"0000",
		X"0001",
		X"0002",
		X"0003",
		X"0004",
		X"0005",
		X"0006",
		X"0007",	
		others =>X"FFFF");
begin

    address <= ALURes(3 downto 0);
    
    --read/write memory--
    memory:process(clk, address)
            begin
                if(rising_edge(clk)) then
                    if MemWriteCtrl = '1' then
                        memRAM(conv_integer(address))<=WriteData;
                    end if;
                end if;
                MemData <= memRAM(conv_integer(address));
            end process;

    ALUResOUT <= ALURes;

end Behavioral;