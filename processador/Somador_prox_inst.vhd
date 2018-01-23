library ieee;
use ieee.std_logic_1164.all;

entity Somador_prox_inst is
Generic(nBits : integer := 7); -- nBits - 1
port(	input	: in std_logic_vector(nBits downto 0);
		cout	: out std_logic;
		output	: out std_logic_vector(nBits downto 0)
	);
end Somador_prox_inst;

architecture som_proxi_behav of Somador_prox_inst is
begin
	process(input)
		variable soma : std_logic_vector(nBits downto 0);
		variable B : std_logic_vector(nBits downto 0);
		variable cin : std_logic;
		begin
			B  := "00000001";
			cin := '0';
			for i in 0 to nBits loop
				soma(i) := input(i) xor B(i) xor cin;
				cin := (input(i) and B(i)) or ((input(i) xor B(i)) and cin);
			end loop;
			cout <= cin;
			output <= soma;
	end process;
end som_proxi_behav;