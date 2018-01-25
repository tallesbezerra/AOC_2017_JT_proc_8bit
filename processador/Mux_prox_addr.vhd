library ieee;
use ieee.std_logic_1164.all;

entity Mux_prox_addr is
Generic(nBits : integer := 7); -- nBits - 1
port(	dvc: in std_logic;
		addr_somador, addr_jmp	: in std_logic_vector(nBits downto 0);
		saida : out std_logic_vector(nBits downto 0)
		);
end Mux_prox_addr;

architecture muxprox_behav of Mux_prox_addr is
begin
	process(dvc)
	begin
		case dvc is
				when '0' => saida <= addr_somador;
				when '1' => saida <= addr_jmp;
		end case;
	end process;
end muxprox_behav;