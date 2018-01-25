library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Extensor2_8 is
Generic(nBits : integer := 7); -- nBits - 1
port(	input		: in std_logic_vector(nBits-6 downto 0);
		output	: out std_logic_vector(nBits downto 0)
	);
end Extensor2_8;

architecture ex8bits_behav of Extensor2_8 is
signal aux8b : std_logic_vector(nBits downto 0);
	
begin
	output <= std_logic_vector(resize(unsigned(input), aux8b'length));
end ex8bits_behav;