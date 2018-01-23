library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;		 
use ieee.std_logic_unsigned.all;

entity UnidadeControle is
Generic(nBits : integer := 7); -- nBits - 1
port( clock : in std_logic;
		clock_ex : in std_logic_vector(nBits-5 downto 0);
		opcode: in std_logic_vector(nBits-4 downto 0);
		rdbd_flag, wrbd_flag, rwram_flag, sel_salto : out std_logic;
		sel_ula, sel_clk : out std_logic_vector(nBits-6 downto 0);
		op_ula : out std_logic_vector(nBits-4 downto 0);
		quant_clock : out std_logic_vector(nBits-5 downto 0)
		);
end UnidadeControle;

architecture uc_behav of UnidadeControle is
begin
	process(clock,clock_ex,opcode)
	begin
		if (rising_edge(clock)) then
			case opcode is
				when "0000" => -- add
					rdbd_flag <= '1';
					wrbd_flag <= '1';
					sel_ula <= "00";
					op_ula <= opcode;
					rwram_flag <= 'Z';
					sel_salto <= '0';
					sel_clk <= "01";
					quant_clock <= "100";
					
				when "0001" => -- sub 
					rdbd_flag <= '1';
					wrbd_flag <= '1';
					sel_ula <= "00";
					op_ula <= opcode;
					rwram_flag <= 'Z';
					sel_salto <= '0';
					sel_clk <= "01";
					quant_clock <= "100";
					
				when "0010" => -- addi 
					rdbd_flag <= '1';
					wrbd_flag <= '1';
					sel_ula <= "01";
					op_ula <= opcode;
					rwram_flag <= 'Z';
					sel_salto <= '0';
					sel_clk <= "01";
					quant_clock <= "100";
					
				when "0011" => -- mult 
					rdbd_flag <= '1';
					wrbd_flag <= '1';
					sel_ula <= "00";
					op_ula <= opcode;
					rwram_flag <= 'Z';
					sel_salto <= '0';
					sel_clk <= "01";
					quant_clock <= "100";
					
				when "0100" => -- and 
					rdbd_flag <= '1';
					wrbd_flag <= '1';
					sel_ula <= "00";
					op_ula <= opcode;
					rwram_flag <= 'Z';
					sel_salto <= '0';
					sel_clk <= "01";
					quant_clock <= "100";
					
				when "0101" => -- or 
					rdbd_flag <= '1';
					wrbd_flag <= '1';
					sel_ula <= "00";
					op_ula <= opcode;
					rwram_flag <= 'Z';
					sel_salto <= '0';
					sel_clk <= "01";
					quant_clock <= "100";
					
				when "0110" => -- not 
					rdbd_flag <= '1';
					wrbd_flag <= '1';
					sel_ula <= "00";
					op_ula <= opcode;
					rwram_flag <= 'Z';
					sel_salto <= '0';
					sel_clk <= "01";
					quant_clock <= "100";
					
				when "0111" => -- xor 
					rdbd_flag <= '1';
					wrbd_flag <= '1';
					sel_ula <= "00";
					op_ula <= opcode;
					rwram_flag <= 'Z';
					sel_salto <= '0';
					sel_clk <= "01";
					quant_clock <= "100";
					
				when "1000" => -- lw 
					rdbd_flag <= '1';
					wrbd_flag <= '1';
					sel_ula <= "00";
					op_ula <= opcode;
					rwram_flag <= '1';
					sel_salto <= '0';
					sel_clk <= "00";
					quant_clock <= "101";
					
				when "1001" => -- sw 
					rdbd_flag <= '1';
					wrbd_flag <= '0';
					sel_ula <= "00";
					op_ula <= opcode;
					rwram_flag <= '0';
					sel_salto <= '0';
					sel_clk <= "ZZ";
					quant_clock <= "100";
					
				when "1010" => -- li 
					rdbd_flag <= '1';
					wrbd_flag <= '1';
					sel_ula <= "01";
					op_ula <= opcode;
					rwram_flag <= 'Z';
					sel_salto <= '0';
					sel_clk <= "10";
					quant_clock <= "100";
					
				when "1011" => -- jmp 
					rdbd_flag <= '0';
					wrbd_flag <= '0';
					sel_ula <= "10";
					op_ula <= opcode;
					rwram_flag <= 'Z';
					sel_salto <= '1';
					sel_clk <= "ZZ";
					quant_clock <= "011";
					
				when "1100" => -- jr 
					rdbd_flag <= '1';
					wrbd_flag <= '0';
					sel_ula <= "00";
					op_ula <= opcode;
					rwram_flag <= 'Z';
					sel_salto <= '1';
					sel_clk <= "ZZ";
					quant_clock <= "011";
					
				when others => 
					rdbd_flag <= '0';
					wrbd_flag <= '0';
					sel_ula <= "ZZ";
					op_ula <= "ZZZZ";
					rwram_flag <= 'Z';
					sel_salto <= '0';
					sel_clk <= "ZZ";
					quant_clock <= "ZZZ";
					
			end case;
		end if;
	end process;
end uc_behav;