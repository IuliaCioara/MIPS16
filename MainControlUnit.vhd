library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MainControlUnit is
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
end MainControlUnit;

architecture Behavioral of MainControlUnit is
begin
    process(instr)
        begin
            case instr is
            when "000"=> --Instructiuni de tip R--
			RegDst<='1';
			ExtOp<='X';
			ALUSrc<='0';
			Branch<='0';
			Jmp<='0';
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='1';
			ALUOp<="000";
						
		when "001"=> --ADDI--
			RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jmp<='0';
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='1';
			ALUOp<="000";
					
		when "010"=> --LW--
			RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jmp<='0';
			MemWrite<='0';
			MemtoReg<='1';
			RegWrite<='1';
			ALUOp<="000";
					
		when "011"=> --SW--
			RegDst<='X';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jmp<='0';
			MemWrite<='1';
			MemtoReg<='X';
			RegWrite<='0';
			ALUOp<="000";
			
			
		when "100"=> --BEQ--
			RegDst<='X';
			ExtOp<='1';
			ALUSrc<='0';
			Branch<='1';
			Jmp<='0';
			MemWrite<='0';
			MemtoReg<='X';
			RegWrite<='0';
			ALUOp<="001";
			
			
		when "110"=> --ORI--
			RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jmp<='0';
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='1';
			ALUOp<="110";
			
		when "101"=> --ANDI--
			RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jmp<='0';
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='1';
			ALUOp<="101";
			
			
		when "111"=> --JUMP--
			RegDst<='X';
			ExtOp<='1';
			ALUSrc<='X';
			Branch<='0';
			Jmp<='1';
			MemWrite<='0';
			MemtoReg<='X';
			RegWrite<='0';
			ALUOp<="001";
		
		when others =>	--OTHERS--
			RegDst<='X';
			ExtOp<='X';
			ALUSrc<='X';
			Branch<='0';
			Jmp<='0';
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='0';
			ALUOp<="000";
	end case;
           
        end process;


end Behavioral;