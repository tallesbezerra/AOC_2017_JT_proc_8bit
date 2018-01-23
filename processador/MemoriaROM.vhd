library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;		 
use ieee.std_logic_unsigned.all;

entity MemoriaROM is
Generic(nBits : integer := 7); -- nBits - 1
port(	addr	: in std_logic_vector(nBits downto 0);
		saida	: out std_logic_vector(nBits downto 0)
	);
end MemoriaROM;


architecture mrom_behav of MemoriaROM is
	type memoria is array (0 to 6) of std_logic_vector(nBits downto 0);
	constant ROM: memoria := (
        0 => "10100001",
        1 => "00100010",
        2 => "10100101",
        3 => "00000001",
        4 => "10010001",
        5 => "10001101",
        6 => "00000010"
		  );

begin
	process(addr)
		begin
			saida <= ROM(conv_integer(unsigned(addr)));
		end process;
end mrom_behav;