library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Extensor4_8 is
Generic(nBits : integer := 7); -- nBits - 1
port(	input		: in std_logic_vector(nBits-4 downto 0);
		output	: out std_logic_vector(nBits downto 0)
	);
end Extensor4_8;

architecture ex8bits_behav of Extensor4_8 is
	signal aux8b : std_logic_vector(nBits downto 0);
begin
	process(input)
		begin
			output <= std_logic_vector(resize(unsigned(input), aux8b'length));
	end process;
end ex8bits_behav;