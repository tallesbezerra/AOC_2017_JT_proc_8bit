 library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;		 
use ieee.std_logic_unsigned.all;

entity PC is
Generic(nBits : integer := 7); -- nBits - 1
port( clock : in std_logic;
		clock_ex : in std_logic_vector(nBits-5 downto 0);
		inputPC : in std_logic_vector(nBits downto 0);
		outputPC: out std_logic_vector(nBits downto 0)
	);
end PC;

architecture pc_behav of PC is
begin
	process(clock, clock_ex, inputPC)
	begin
		if (rising_edge(clock) and clock_ex="001") then
			outputPC <= inputPC;
		end if;
	end process;
end pc_behav;