library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;		 
use ieee.std_logic_unsigned.all;

entity processador is
Generic(nBits : integer := 7); -- nBits - 1
port( clock : in std_logic;
		addr_instrucao: out std_logic_vector(nBits downto 0);
		opcode : out std_logic_vector(nBits-4 downto 0);
		in3_2, in1_0: out std_logic_vector(nBits-6 downto 0);
		v0, v1, v2, v3 : out std_logic_vector(nBits downto 0);
		v_reg1, v_reg2 : out std_logic_vector(nBits downto 0);
		rula, rmux2, rmuxi, rmuxdd : out std_logic_vector(nBits downto 0);
		instrucao: out std_logic_vector(nBits downto 0);
		q_clock: out std_logic_vector(nBits-5 downto 0)
	);
end processador;

architecture procss_behav of processador is

component Contador_clock is
Generic(nBits : integer := 7); -- nBits - 1
port(	clock : in std_logic;
		quant_clock, clock_ex_in : in std_logic_vector(nBits-5 downto 0);
		clock_ex_out : out std_logic_vector(nBits-5 downto 0)
	);
end component;

-- CRIAR AS SIGNALS PARA O CONTADOR DE CLOCKS

component PC is
Generic(nBits : integer := 7); -- nBits - 1
port( clock : in std_logic;
		clock_ex : in std_logic_vector(nBits-5 downto 0);
		inputPC : in std_logic_vector(nBits downto 0);
		outputPC: out std_logic_vector(nBits downto 0)
	);
end component;

component MemoriaROM is
Generic(nBits : integer := 7); -- nBits - 1
port(	addr	: in std_logic_vector(nBits downto 0);
		saida	: out std_logic_vector(nBits downto 0)
	);
end component;

component UnidadeControle is
Generic(nBits : integer := 7); -- nBits - 1
port( clock : in std_logic;
		clock_ex : in std_logic_vector(nBits-5 downto 0);
		opcode: in std_logic_vector(nBits-4 downto 0);
		rdbd_flag, wrbd_flag, rwram_flag, sel_salto : out std_logic;
		sel_ula, sel_clk : out std_logic_vector(nBits-6 downto 0);
		op_ula : out std_logic_vector(nBits-4 downto 0);
		quant_clock : out std_logic_vector(nBits-5 downto 0)
		);
end component;

component BRegistradores is
Generic(nBits : integer := 7); -- nBits - 1
port( quant_clock,clock_ex : in std_logic_vector(nBits-5 downto 0);
		rd_flag, wr_flag : in std_logic;
		reg1, reg2 : in std_logic_vector(nBits-6 downto 0);
		dado_escrito: in std_logic_vector(nBits downto 0);
		r0, r1, r2, r3 : out std_logic_vector(nBits downto 0);
		dado_lido1, dado_lido2 : out std_logic_vector(nBits downto 0)
	);
end component;

component ULA is
Generic(nBits : integer := 7); -- nBits - 1
port( clock : in std_logic;
		clock_ex : in std_logic_vector(nBits-5 downto 0);
		opcode: in std_logic_vector(nBits-4 downto 0);
		dado1, dado2 : in std_logic_vector(nBits downto 0);
		output : out std_logic_vector(nBits downto 0)
		);
end component;

component MemoriaRAM is
Generic(nBits : integer := 7); -- nBits - 1
port( clock : in std_logic;
		clock_ex : in std_logic_vector(nBits-5 downto 0);
		rw_flag : in std_logic;
		dado_esc, addr : in std_logic_vector(nBits downto 0);
		dado_lido : out std_logic_vector(nBits downto 0)
	);
end component;

component Extensor2_8 is
Generic(nBits : integer := 7); -- nBits - 1
port(	input		: in std_logic_vector(nBits-6 downto 0);
		output	: out std_logic_vector(nBits downto 0)
	);
end component;

component Extensor4_8 is
Generic(nBits : integer := 7); -- nBits - 1
port(	input		: in std_logic_vector(nBits-4 downto 0);
		output	: out std_logic_vector(nBits downto 0)
	);
end component;

component Somador_prox_inst is
Generic(nBits : integer := 7); -- nBits - 1
port(	input	: in std_logic_vector(nBits downto 0);
		cout	: out std_logic;
		output	: out std_logic_vector(nBits downto 0)
	);
end component;

component Mux_valor2 is
Generic(nBits : integer := 7); -- nBits - 1
port(	seletor: in std_logic_vector(nBits-6 downto 0);
		dado_lido2, reg2_extend, inst3_0	: in std_logic_vector(nBits downto 0);
		saida : out std_logic_vector(nBits downto 0)
		);
end component;

component Mux_escreve_dado is
Generic(nBits : integer := 7); -- nBits - 1
port(	
		seletor: in std_logic_vector(nBits-6 downto 0);
		out_ram, out_ula, out_mux	: in std_logic_vector(nBits downto 0);
		saida : out std_logic_vector(nBits downto 0)
		);
end component;

component Mux_prox_addr is
Generic(nBits : integer := 7); -- nBits - 1
port(	seletor: in std_logic;
		quant_clock, clock_ex : in std_logic_vector(nBits-5 downto 0);
		addr_somador, addr_jmp	: in std_logic_vector(nBits downto 0);
		saida : out std_logic_vector(nBits downto 0)
		);
end component;

--clock
signal clock_ex_in : std_logic_vector(nBits-5 downto 0) := "000";
signal clock_ex, clock_ex_final : std_logic_vector(nBits-5 downto 0);
signal quant_clock : std_logic_vector(nBits-5 downto 0);

--PC
signal prox_inst : std_logic_vector(nBits downto 0) := "00000000";
signal endereco_inst : std_logic_vector(nBits downto 0);

--ROM
signal inst : std_logic_vector(nBits downto 0);
signal inst7_4 : std_logic_vector(nBits-4 downto 0);
signal inst3_0 : std_logic_vector(nBits-4 downto 0);
signal inst3_2, inst1_0 : std_logic_vector(nBits-6 downto 0);

--Unidade de controle
signal rdbd_flag, wrbd_flag, rwram_flag, sel_prox_inst : std_logic;
signal sel_valor2, sel_esdd : std_logic_vector(nBits-6 downto 0);
signal op_ula : std_logic_vector(nBits-4 downto 0);

--Banco de registradores
signal dado_lido1, dado_lido2 : std_logic_vector(nBits downto 0);
signal rb0,rb1,rb2,rb3 : std_logic_vector(nBits downto 0);

--ULA
signal out_ula : std_logic_vector(nBits downto 0);

--RAM
signal out_ram : std_logic_vector(nBits downto 0);

--Extensor de 2 para 8 bits
signal out_ex2_8 : std_logic_vector(nBits downto 0);

--Extensor de 4 para 8 bits
signal out_ex_4_8 : std_logic_vector(nBits downto 0);

--Somador para proxima instrucao
signal out_somador : std_logic_vector(nBits downto 0);
signal c_out : std_logic;

--Multiplexador para o segundo valor para ula
signal out_mux_v2 : std_logic_vector(nBits downto 0);

--Multiplexador para escrever no registrador
signal out_mux_esdd : std_logic_vector(nBits downto 0);


begin

	PA: Contador_clock port map(clock,quant_clock,clock_ex_in,clock_ex);
	
	P1: PC port map(clock,clock_ex,prox_inst,endereco_inst);
	
	P2: MemoriaROM port map(endereco_inst,inst);
	
	addr_instrucao <= endereco_inst;
	inst7_4 <= inst(nBits downto 4);
	inst3_2 <= inst(nBits-4 downto 2);
	inst1_0 <= inst(nBits-6 downto 0);
	inst3_0 <= inst(nBits-4 downto 0);
	
	P3: UnidadeControle port map(clock,clock_ex,inst7_4,rdbd_flag,wrbd_flag,rwram_flag,sel_prox_inst,
	sel_valor2,sel_esdd,op_ula,quant_clock);
	q_clock <= clock_ex;
	
	P4: BRegistradores port map(quant_clock,clock_ex,rdbd_flag,wrbd_flag,inst3_2,inst1_0,out_mux_esdd,
	rb0,rb1,rb2,rb3,dado_lido1,dado_lido2);
	
	v_reg1 <= dado_lido1; v_reg2 <= dado_lido2;
	
	P5: Extensor2_8 port map(inst1_0,out_ex2_8);
	
	P6: Extensor4_8 port map(inst3_0,out_ex_4_8);
	
	P7: Mux_valor2 port map(sel_valor2,dado_lido2,out_ex2_8,out_ex_4_8,out_mux_v2);
	rmux2 <= out_mux_v2;
	
	P8: ULA port map(clock,clock_ex,op_ula,dado_lido1,out_mux_v2,out_ula);
	rula <= out_ula;
	
	P9: MemoriaRAM port map(clock,clock_ex,rwram_flag,out_ula,out_mux_v2,out_ram);
	
	P10: Mux_escreve_dado port map(sel_esdd,out_ram,out_ula,out_mux_v2,out_mux_esdd);
	rmuxdd <= out_mux_esdd;
		
	P11: Somador_prox_inst port map(endereco_inst,c_out,out_somador);
		
	P12: Mux_prox_addr port map(sel_prox_inst,quant_clock,clock_ex,out_somador,out_ula,prox_inst);	
	rmuxi <= prox_inst;
	
	instrucao <= inst;
	opcode <= inst7_4;
	in3_2 <= inst3_2;
	in1_0 <= inst1_0;
	v0 <= rb0;
	v1 <= rb1;
	v2 <= rb2;
	v3 <= rb3;
	clock_ex_in <= clock_ex;



end procss_behav;