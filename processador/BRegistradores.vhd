library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;		 
use ieee.std_logic_unsigned.all;

entity BRegistradores is
Generic(nBits : integer := 7); -- nBits - 1
port( quant_clock,clock_ex : in std_logic_vector(nBits-5 downto 0);
		rd_flag, wr_flag : in std_logic;
		reg1, reg2 : in std_logic_vector(nBits-6 downto 0);
		dado_escrito: in std_logic_vector(nBits downto 0);
		r0, r1, r2, r3 : out std_logic_vector(nBits downto 0);
		dado_lido1, dado_lido2 : out std_logic_vector(nBits downto 0)
	);
end BRegistradores;

architecture bancoreg_behav of BRegistradores is
	type banco8bits is array (0 to 3) of std_logic_vector(nBits downto 0);
	signal bancoreg : banco8bits;
	
begin
	process(quant_clock, clock_ex, rd_flag, wr_flag, reg1, reg2, dado_escrito)
	begin
		if (rd_flag='1') then -- ler os registradores
			dado_lido1 <= bancoreg(conv_integer(unsigned(reg1)));
			dado_lido2 <= bancoreg(conv_integer(unsigned(reg2)));
		end if;
					
		if (wr_flag='1') then -- escreve no registrador destino
			bancoreg(conv_integer(unsigned(reg1))) <= "00000000";
			bancoreg(conv_integer(unsigned(reg1))) <= dado_escrito;
		end if;
				
		r0 <= bancoreg(0); r1 <= bancoreg(1); r2 <= bancoreg(2); r3 <= bancoreg(3);
	end process;
end bancoreg_behav;