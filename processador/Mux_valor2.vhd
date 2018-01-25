library ieee;
use ieee.std_logic_1164.all;

entity Mux_valor2 is
Generic(nBits : integer := 7); -- nBits - 1
port(	ulafonte: in std_logic_vector(nBits-6 downto 0);
		dado_lido2, reg2_extend, inst3_0	: in std_logic_vector(nBits downto 0);
		saida : out std_logic_vector(nBits downto 0)
		);
end Mux_valor2;

architecture muxv2_behav of Mux_valor2 is
begin
	with ulafonte select
		Saida <=	dado_lido2 	when "00",
					reg2_extend when "01",
					inst3_0 		when "10",
					"UUUUUUUU" 	when others;
end muxv2_behav;