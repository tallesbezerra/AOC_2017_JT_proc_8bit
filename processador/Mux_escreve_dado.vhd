library ieee;
use ieee.std_logic_1164.all;

entity Mux_escreve_dado is
Generic(nBits : integer := 7); -- nBits - 1
port(	
		seletor: in std_logic_vector(nBits-6 downto 0);
		out_ram, out_ula, out_mux	: in std_logic_vector(nBits downto 0);
		saida : out std_logic_vector(nBits downto 0)
		);
end Mux_escreve_dado;

architecture mux_esdd_behav of Mux_escreve_dado is
begin
	
			with seletor select
				saida <= out_ram when "00",
							out_ula when "01",
							out_mux when "10",
							"ZZZZZZZZ" when others;
			
		
end mux_esdd_behav;