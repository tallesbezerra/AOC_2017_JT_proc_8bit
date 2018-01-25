library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;		 
use ieee.std_logic_unsigned.all;

entity ULA is
Generic(nBits : integer := 7); -- nBits - 1
port( ulaop: in std_logic_vector(nBits-4 downto 0);
		dado1, dado2 : in std_logic_vector(nBits downto 0);
		output : out std_logic_vector(nBits downto 0)
		);
end ULA;

architecture ula_behav of ULA is

component Multiplicacao is
Generic(nBits : integer := 7); -- nBits - 1
port( input : in std_logic_vector(nBits+8 downto 0);
		output : out std_logic_vector(nBits downto 0)
		);
end component;

signal mult : std_logic_vector(nBits+8 downto 0);
signal result : std_logic_vector(nBits downto 0);

begin
	P1: Multiplicacao port map(mult,result);
	process(ulaop)
	begin
		case ulaop is
			when "0000" => -- add
				output <= dado1 + dado2;
				
			when "0001" => -- sub
				output <= dado1 - dado2;
				
			when "0010" => -- addi
				output <= dado1 + dado2;
				
			when "0011" => -- mult
				mult <= dado1 * dado2;
				output <= result;
				
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
				output <= "UUUUUUUU";
						
			when "1011" => -- jmp
				output <= dado2;
			
			when "1100" => -- jr
				output <= dado1;
					
			when others => -- exit
				output <= "UUUUUUUU";						
		end case;
	end process;
end ula_behav;