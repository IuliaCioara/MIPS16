library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IExecuteUnit is
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
         
end IExecuteUnit;

architecture Behavioral of IExecuteUnit is

    signal iesireMux  : std_logic_vector (15 downto 0):=x"0000";
    signal ALUcontrol : std_logic_vector (2 downto 0):="000";
    
    signal ALUResAux: std_logic_vector (15 downto 0):=x"0000";
    signal ZeroAux: std_logic;
begin

       branch_address <= ext_imm + next_instruction;
        
        mux: process(ALUSrc, rd2, ext_imm)
        begin
            case ALUSrc is
                when '0' => iesireMux <= rd2;
                when '1' => iesireMux <= ext_imm;
                when others => iesireMux <= ext_imm;
            end case;
        end process;	
    
       ALUctrl : process(ALUOp, func)
        begin
            case ALUOp is
               when "000"=>
				case (Func) is
					when "000"=> ALUControl<="000"; --ADD--
					when "001"=> ALUControl<="001";	--SUB--
					when "010"=> ALUControl<="010";	--SLL--
					when "011"=> ALUControl<="011";	--SRL--
					when "100"=> ALUControl<="100";	--AND--
					when "101"=> ALUControl<="101";	--OR--
					when "110"=> ALUControl<="110";	--XOR--
					when "111"=> ALUControl<="111";	--SRA--
					when others=> ALUControl<="0000";--OTHERS--
				end case;
		when "001"=> ALUControl<="000";	--ADDI-- --LW-- --SW--
		when "010"=> ALUControl<="001";	--BEQ--
		when "110"=> ALUControl<="101";	--ORI--
		when "101"=> ALUControl<="100";	--ANDI--
		when others=> ALUControl<="000";--JUMP--	
	end case;
        end process;
    
        ALU : process (ALUcontrol, iesireMux, rd1, sa)
        begin
            case ALUcontrol is
                when "000" => ALUResAux <= (rd1 + iesireMux); -- ADUNARE
                when "001" => ALUResAux <= (rd1 - iesireMux); -- SCADERE
                when "010" => 
                        if ( sa = '1') then				  -- SLL
                            ALUResAux(15 downto 1) <= rd1 (14 downto 0);
                            ALUResAux(0) <= '0';
                        else
                            ALUResAux <= rd1;
                        end if;
                when "011" =>
                        if ( sa = '1') then				  -- SRL
                            ALUResAux(14 downto 0) <= rd1 (15 downto 1);
                            ALUResAux(15) <= '0';
                        else
                            ALUResAux <= rd1;
                        end if;
                when "100" => ALUResAux <= rd1 and iesireMux; -- AND
                when "101" => ALUResAux <= rd1 or iesireMux; -- OR
                when "110" => ALUResAux <= rd1 xor  iesireMux; -- XOR
                when "111" => 
                         if ( rd1 < iesireMux) then 
                            ALUResAux <= x"0001";
                         else 
                            ALUResAux <= x"0000";
                         end if; 
                when others => ALUResAux <= x"0000";
        end case;           
end process;

process (ALUResAux)
begin
    case (ALUResAux) is					--ZERO SIGNAL--
		when X"0000" => ZeroAux<='1';
		when others => ZeroAux<='0';
	end case;
end process;
     
	   ALURes <= ALUResAux;
	   zero <= ZeroAux;
	   
end Behavioral;