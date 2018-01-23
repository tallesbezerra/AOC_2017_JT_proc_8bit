library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;		 
use ieee.std_logic_unsigned.all;

entity ULA is
Generic(nBits : integer := 7); -- nBits - 1
port( clock : in std_logic;
		clock_ex : in std_logic_vector(nBits-5 downto 0);
		opcode: in std_logic_vector(nBits-4 downto 0);
		dado1, dado2 : in std_logic_vector(nBits downto 0);
		output : out std_logic_vector(nBits downto 0)
		);
end ULA;

architecture ula_behav of ULA is
begin
	process(clock, clock_ex, opcode, dado1, dado2)
	begin
		if (rising_edge(clock)) then
			case opcode is
				when "0000" => -- add
					output <= dado1 + dado2;
						
				when "0001" => -- sub
					output <= dado1 - dado2;
						
				when "0010" => -- addi
					output <= dado1 + dado2;
						
				when "0011" => -- mult
					output <= dado1;
						
				when "0100" => -- and
					output <= dado1 and dado2;
						
				when "0101" => -- or
					output <= dado1 or dado2;
					
				when "0110" => -- not
					output <= not dado1;
					
				when "0111" => -- xor
					output <= dado1 xor dado2;
					
				when "1000" => -- lw
					output <= dado1;
					
				when "1001" => -- sw
					output <= dado1;
					
				when "1010" => -- li
					output <= "ZZZZZZZZ";
							
				when "1011" => -- jmp
					output <= dado2;
					
				when "1100" => -- jr
					output <= dado1;
						
				when others => -- exit
					output <= "ZZZZZZZZ";						
			end case;
		end if;
	end process;
end ula_behav;