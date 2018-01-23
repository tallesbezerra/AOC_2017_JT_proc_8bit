library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;		 
use ieee.std_logic_unsigned.all;

entity MemoriaRAM is
Generic(nBits : integer := 7); -- nBits - 1
port( clock : in std_logic;
		clock_ex : in std_logic_vector(nBits-5 downto 0);
		rw_flag : in std_logic;
		dado_esc, addr : in std_logic_vector(nBits downto 0);
		dado_lido : out std_logic_vector(nBits downto 0)
	);
end MemoriaRAM;

architecture mram_behav of MemoriaRAM is
	type memoria is array (0 to 255) of std_logic_vector(nBits downto 0);
	signal RAM : memoria;
	
begin
	process(clock, clock_ex, rw_flag, dado_esc, addr)
	begin
		if (rising_edge(clock)) then
			if rw_flag = '1' then -- lw
				dado_lido <= RAM(conv_integer(unsigned(addr)));
			
			else -- sw
				RAM(conv_integer(unsigned(addr))) <= dado_esc;
			end if;
		end if;	
	end process;
end mram_behav;