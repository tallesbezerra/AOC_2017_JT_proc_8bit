library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MemoriaROM is
Generic(nBits : integer := 7); -- nBits - 1
port(	endereco	: in std_logic_vector(nBits downto 0);
		instrucao	: out std_logic_vector(nBits downto 0)
	);
end MemoriaROM;


architecture mrom_behav of MemoriaROM is
	type memoria is array (0 to 5) of std_logic_vector(nBits downto 0);
	constant ROM: memoria := (
        0 => "10100011", --li reg0,3 -> reg0 = 00000011 = 3
        1 => "10100111", --li reg1,3 -> reg1 = 00000011 = 3
        2 => "00000001", --add reg0,reg1 -> reg0 = 00000110 = 6
        3 => "00010001", --sub reg0,reg1 -> reg0 = 00000011 = 3
        4 => "00101010", --addi reg2,2 -> reg2 = 00000010 = 2
        5 => "00110001" --mult reg0,reg1 -> reg0 = 00001001 = 9
		  );

begin
	instrucao <= ROM(conv_integer(unsigned(endereco)));
end mrom_behav;