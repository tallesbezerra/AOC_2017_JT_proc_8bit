library ieee;
use ieee.std_logic_1164.all;

entity Mux_prox_addr is
Generic(nBits : integer := 7); -- nBits - 1
port(	seletor: in std_logic;
		quant_clock, clock_ex : in std_logic_vector(nBits-5 downto 0);
		addr_somador, addr_jmp	: in std_logic_vector(nBits downto 0);
		saida : out std_logic_vector(nBits downto 0)
		);
end Mux_prox_addr;

architecture muxprox_behav of Mux_prox_addr is
begin
	process(quant_clock, clock_ex, seletor)
	begin
		--if(clock_ex > quant_clock) then
		case seletor is
				when '0' => saida <= addr_somador;
				when '1' => saida <= addr_jmp;
		end case;
		--end if;
	end process;
end muxprox_behav;