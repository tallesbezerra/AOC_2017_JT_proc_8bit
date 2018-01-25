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
		instrucao: out std_logic_vector(nBits downto 0)
	);
end processador;

architecture procss_behav of processador is

component PC is
Generic(nBits : integer := 7); -- nBits - 1
port( clock : in std_logic;
		inputPC : in std_logic_vector(nBits downto 0);
		outputPC: out std_logic_vector(nBits downto 0)
	);
end component;

component MemoriaROM is
Generic(nBits : integer := 7); -- nBits - 1
port(	endereco	: in std_logic_vector(nBits downto 0);
		instrucao	: out std_logic_vector(nBits downto 0)
	);
end component;

component UnidadeControle is
Generic(nBits : integer := 7); -- nBits - 1
port( opcode: in std_logic_vector(nBits-4 downto 0);
		escreg,escmem,lermem,dvc : out std_logic;
		ulafonte,mempreg : out std_logic_vector(nBits-6 downto 0);
		ulaop : out std_logic_vector(nBits-4 downto 0)
		);
end component;

component BRegistradores is
Generic(nBits : integer := 7); -- nBits - 1
port( clock, escreg : in std_logic;
		reg1, reg2 : in std_logic_vector(nBits-6 downto 0);
		dado_escrito: in std_logic_vector(nBits downto 0);
		r0, r1, r2, r3 : out std_logic_vector(nBits downto 0);
		dado_lido1, dado_lido2 : out std_logic_vector(nBits downto 0)
	);
end component;

component ULA is
Generic(nBits : integer := 7); -- nBits - 1
port( ulaop: in std_logic_vector(nBits-4 downto 0);
		dado1, dado2 : in std_logic_vector(nBits downto 0);
		output : out std_logic_vector(nBits downto 0)
		);
end component;

component MemoriaRAM is
Generic(nBits : integer := 7); -- nBits - 1
port( escmem, lermem : in std_logic;
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
port(	endereco_inst : in std_logic_vector(nBits downto 0);
		prox_endereco : out std_logic_vector(nBits downto 0)
	);
end component;

component Mux_valor2 is
Generic(nBits : integer := 7); -- nBits - 1
port(	ulafonte: in std_logic_vector(nBits-6 downto 0);
		dado_lido2, reg2_extend, inst3_0	: in std_logic_vector(nBits downto 0);
		saida : out std_logic_vector(nBits downto 0)
		);
end component;

component Mux_escreve_dado is
Generic(nBits : integer := 7); -- nBits - 1
port(	mempreg: in std_logic_vector(nBits-6 downto 0);
		out_ram, out_ula, out_mux	: in std_logic_vector(nBits downto 0);
		saida : out std_logic_vector(nBits downto 0)
		);
end component;

component Mux_prox_addr is
Generic(nBits : integer := 7); -- nBits - 1
port(	dvc: in std_logic;
		addr_somador, addr_jmp	: in std_logic_vector(nBits downto 0);
		saida : out std_logic_vector(nBits downto 0)
		);
end component;
--PC
signal prox_inst : std_logic_vector(nBits downto 0);
signal out_mux,endereco_inst : std_logic_vector(nBits downto 0);

--ROM
signal inst : std_logic_vector(nBits downto 0);
signal inst7_4 : std_logic_vector(nBits-4 downto 0);
signal inst3_0 : std_logic_vector(nBits-4 downto 0);
signal inst3_2, inst1_0 : std_logic_vector(nBits-6 downto 0);

--Unidade de controle
signal escreg, escmem, lermem, dvc : std_logic;
signal ulafonte, mempreg : std_logic_vector(nBits-6 downto 0);
signal ulaop : std_logic_vector(nBits-4 downto 0);
signal tipo : std_logic_vector(nBits-5 downto 0);

--Banco de registradores
signal dado_lido1, dado_lido2 : std_logic_vector(nBits downto 0);
signal rg0,rg1,rg2,rg3 : std_logic_vector(nBits downto 0);

--Extensor de 2 para 8 bits
signal out_ex2_8 : std_logic_vector(nBits downto 0);

--Extensor de 4 para 8 bits
signal out_ex_4_8 : std_logic_vector(nBits downto 0);

--Multiplexador para o segundo valor para ula
signal out_mux_v2 : std_logic_vector(nBits downto 0);

--ULA
signal out_ula : std_logic_vector(nBits downto 0);

--RAM
signal out_ram : std_logic_vector(nBits downto 0);

--Multiplexador para escrever no registrador
signal out_mux_esdd : std_logic_vector(nBits downto 0);

--Somador para proxima instrucao
signal out_somador : std_logic_vector(nBits downto 0);


begin

	
	P1: PC port map(clock,prox_inst,endereco_inst);
	
	P2: MemoriaROM port map(endereco_inst,inst);
	
	addr_instrucao <= endereco_inst;
	inst7_4 <= inst(nBits downto 4);
	inst3_2 <= inst(nBits-4 downto 2);
	inst1_0 <= inst(nBits-6 downto 0);
	inst3_0 <= inst(nBits-4 downto 0);
	instrucao <= inst;
	opcode <= inst7_4;
	in3_2 <= inst3_2;
	in1_0 <= inst1_0;
	
	P3: UnidadeControle port map(inst7_4,escreg,escmem,lermem,dvc,
	ulafonte,mempreg,ulaop);
	
	P4: BRegistradores port map(clock,escreg,inst3_2,inst1_0,out_mux_esdd,
	rg0,rg1,rg2,rg3,dado_lido1,dado_lido2);
	
	P5: Extensor2_8 port map(inst1_0,out_ex2_8);
	
	P6: Extensor4_8 port map(inst3_0,out_ex_4_8);
	
	P7: Mux_valor2 port map(ulafonte,dado_lido2,out_ex2_8,out_ex_4_8,out_mux_v2);
	
	P8: ULA port map(ulaop,dado_lido1,out_mux_v2,out_ula);
	
	P9: MemoriaRAM port map(escmem,lermem,out_ula,out_mux_v2,out_ram);
	
	P10: Mux_escreve_dado port map(mempreg,out_ram,out_ula,out_mux_v2,out_mux_esdd);
		
	P11: Somador_prox_inst port map(endereco_inst,out_somador);
		
	P12: Mux_prox_addr port map(dvc,out_somador,out_ula,prox_inst);
	
	v0 <= rg0;
	v1 <= rg1;
	v2 <= rg2;
	v3 <= rg3;
	
end procss_behav;