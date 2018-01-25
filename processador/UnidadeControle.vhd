library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity UnidadeControle is
Generic(nBits : integer := 7); -- nBits - 1
port( opcode: in std_logic_vector(nBits-4 downto 0);
		escreg,escmem,lermem,dvc : out std_logic;
		ulafonte,mempreg : out std_logic_vector(nBits-6 downto 0);
		ulaop : out std_logic_vector(nBits-4 downto 0)
		);
end UnidadeControle;

architecture uc_behav of UnidadeControle is
begin
process(opcode)
	begin
	case opcode is
		when "0000" => -- add
			escreg <= '1';
			ulafonte <= "00";
			escmem <= '0';
			ulaop <= opcode;
			mempreg <= "01";
			lermem <= '0';
			dvc <= '0';
								
		when "0001" => -- sub 
			escreg <= '1';
			ulafonte <= "00";
			escmem <= '0';
			ulaop <= opcode;
			mempreg <= "01";
			lermem <= '0';
			dvc <= '0';
		
		when "0010" => -- addi 
			escreg <= '1';
			ulafonte <= "01";
			escmem <= '0';
			ulaop <= opcode;
			mempreg <= "01";
			lermem <= '0';
			dvc <= '0';
		
		when "0011" => -- mult 
			escreg <= '1';
			ulafonte <= "00";
			escmem <= '0';
			ulaop <= opcode;
			mempreg <= "01";
			lermem <= '0';
			dvc <= '0';
		
		when "0100" => -- and 
			escreg <= '1';
			ulafonte <= "00";
			escmem <= '0';
			ulaop <= opcode;
			mempreg <= "01";
			lermem <= '0';
			dvc <= '0';
		
		when "0101" => -- or 
			escreg <= '1';
			ulafonte <= "00";
			escmem <= '0';
			ulaop <= opcode;
			mempreg <= "01";
			lermem <= '0';
			dvc <= '0';
		
		when "0110" => -- not 
			escreg <= '1';
			ulafonte <= "00";
			escmem <= '0';
			ulaop <= opcode;
			mempreg <= "01";
			lermem <= '0';
			dvc <= '0';
		
		when "0111" => -- xor 
			escreg <= '1';
			ulafonte <= "00";
			escmem <= '0';
			ulaop <= opcode;
			mempreg <= "01";
			lermem <= '0';
			dvc <= '0';
		
		when "1000" => -- lw 
			escreg <= '1';
			ulafonte <= "00";
			escmem <= '0';
			ulaop <= opcode;
			mempreg <= "00";
			lermem <= '1';
			dvc <= '0';
		
		when "1001" => -- sw 
			escreg <= '0';
			ulafonte <= "00";
			escmem <= '1';
			ulaop <= opcode;
			mempreg <= "UU";
			lermem <= '0';
			dvc <= '0';
		
		when "1010" => -- li 
			escreg <= '1';
			ulafonte <= "01";
			escmem <= '0';
			ulaop <= opcode;
			mempreg <= "10";
			lermem <= '0';
			dvc <= '0';
		
		when "1011" => -- jmp 
			escreg <= '0';
			ulafonte <= "10";
			escmem <= '0';
			ulaop <= opcode;
			mempreg <= "01";
			lermem <= '0';
			dvc <= '1';
		
		when "1100" => -- jr 
			escreg <= '0';
			ulafonte <= "00";
			escmem <= '0';
			ulaop <= opcode;
			mempreg <= "UU";
			lermem <= '0';
			dvc <= '1';
			
		when others => 
			escreg <= '0';
			ulafonte <= "UU";
			escmem <= '0';
			ulaop <= opcode;
			mempreg <= "UU";
			lermem <= '0';
			dvc <= 'U';
		
	end case;
end process;
end uc_behav;