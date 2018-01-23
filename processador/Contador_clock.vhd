library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;		 
use ieee.std_logic_unsigned.all;

entity Contador_clock is
Generic(nBits : integer := 7); -- nBits - 1
port(	clock : in std_logic;
		quant_clock, clock_ex_in : in std_logic_vector(nBits-5 downto 0);
		clock_ex_out : out std_logic_vector(nBits-5 downto 0)
	);
end Contador_clock;

architecture clock_behav of Contador_clock is
begin
	process(clock,quant_clock,clock_ex_in)
	variable zero : std_logic_vector(nBits-5 downto 0) := "000";
	begin
		if(rising_edge(clock) and clock_ex_in > "001") then
			clock_ex_out <= zero;
		elsif rising_edge(clock) then
			clock_ex_out <= clock_ex_in + "001";
		end if;			
	end process;
end clock_behav;