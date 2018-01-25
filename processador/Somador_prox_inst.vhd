library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;		 
use ieee.std_logic_unsigned.all;

entity Somador_prox_inst is
Generic(nBits : integer := 7); -- nBits - 1
port(	endereco_inst : in std_logic_vector(nBits downto 0);
		prox_endereco : out std_logic_vector(nBits downto 0)
	);
end Somador_prox_inst;

architecture som_proxi_behav of Somador_prox_inst is
begin
	process(endereco_inst)
	variable mais1 : std_logic_vector(nBits downto 0) := "00000001";
	
	begin
		prox_endereco <= endereco_inst + mais1;
		
	end process;
	
end som_proxi_behav;