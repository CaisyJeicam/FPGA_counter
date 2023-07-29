-- zaprojektował Karol Wesołowski
-- projekt komponentów: Marek Kropidłowski
-- projekt komponentu mux: Karol Wesołowski
-- projekt komponentu key_fsm_c: Stefan Zbąszyniak & Helena Masłowska
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.All;

entity top is
port(
BTN: in std_logic_vector(5 downto 1);
Clk_sys: in std_logic;
Rst: in std_logic;
Sseg: out std_logic_vector(6 downto 0);
An: out std_logic_vector(7 downto 0);
F_out: out std_logic
);
end entity;

architecture struct of top is
signal clk_slow_sig, clk_sys_sig, clk_sig, cntr_en_sig, cntr_load_sig, cntr_rst_sig, cntr_edit_sig: std_logic;
signal tr_sig, edg_sig: std_logic_vector(4 downto 0);
signal cntr_data, q_sig, m_sig: std_logic_vector(31 downto 0);

component debounceN is
   generic(RE_DETECTOR: boolean:=False);
   port(clk_sys: in std_logic; -- system clock
        clk_slow: in std_logic; -- debounce clock (100Hz)
        button: in std_logic_vector(4 downto 0);
        trigger_out: out std_logic_vector(4 downto 0)
        );
end component debounceN;
component clk_gen_1Hz_v6 is
    generic ( Simulation : boolean := true);
    Port (  clk_in : in  STD_LOGIC;
            rst : in STD_LOGIC; -- async high
            f_100Hz, f_1kHz, f_1MHz : out std_logic;
            t_1sec, t_1ms, t_1us : out  STD_LOGIC);
end component clk_gen_1Hz_v6;
component edge_detector is
   generic(N: positive:=5;
           RisingEdge: boolean:=True); -- rising or falling edge
   port(clk_sys: in std_logic; -- system clock
        async_in: in std_logic_vector(N-1 downto 0);
        edge_flag: out std_logic_vector(N-1 downto 0)
        );
end component edge_detector;
component cntr_Nbcd_load is
    generic (DIGIT: positive:=8); -- counter length in 4-bit digit 
    Port ( clk : in  STD_LOGIC; 
           rst : in  STD_LOGIC; -- sync, high
           ce : in  STD_LOGIC; -- high
           load : in STD_LOGIC; -- sync, high
           din : in  STD_LOGIC_VECTOR (4*DIGIT -1 downto 0);
           q : out  STD_LOGIC_VECTOR (4*DIGIT -1 downto 0);
           ceo : out  STD_LOGIC);
end component cntr_Nbcd_load;
component mux is
port( in1: in std_logic_vector(31 downto 0);
	in2: in std_logic_vector(31 downto 0);
	sel: in std_logic;
	m_out: out std_logic_vector(31 downto 0)
);
end component mux;
component key_fsm_c is
	port (clk: in std_logic;
	rst: in std_logic; -- synch, high
	left, right, up, down, center: in std_logic; -- keys
	data_out: out std_logic_vector(31 downto 0);
	cntr_en: out std_logic; -- clock enable
	cntr_rst: out std_logic; -- clock reset
	cntr_load: out std_logic;
	edit_en_out: out std_logic
);
end component key_fsm_c;
component led8_drv is
    Generic ( MAIN_CLK: natural:=100E6;                 -- main frequency in Hz
              CLKDIV_INTERNAL: boolean:=True);          -- 
    Port ( a : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN0
           b : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN1
           c : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN2
           d : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN3 
           e : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN4
           f : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN5
           g : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN6
           h : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN7 
           clk_in : in  STD_LOGIC;                      -- main_clk or slow_clk (external)
           sseg : out  STD_LOGIC_VECTOR (6 downto 0);   -- active Low
           an : out  STD_LOGIC_VECTOR (7 downto 0)
           );    -- active Low
    end component;

begin

dbN: debounceN port map(
	button => BTN,
	clk_slow=>clk_slow_sig,
	clk_sys=>clk_sys_sig,
	trigger_out=>tr_sig);
clk_gen: clk_gen_1Hz_v6 port map(
	clk_in => Clk_sys,
	rst => Rst,
	f_100Hz=>clk_slow_sig,
	f_1MHz=>clk_sys_sig,
	f_1kHz=>clk_sig
);
edg: edge_detector port map(
	async_in =>tr_sig,
	clk_sys=>clk_sys_sig,
	edge_flag => edg_sig
);
cntr: cntr_Nbcd_load port map(
	clk=>clk_sys_sig,
	rst=>cntr_rst_sig,
	ce =>cntr_en_sig,
	load => cntr_load_sig,
	din =>cntr_data,
	q=>q_sig,
	ceo=>F_out
);
mx: mux port map(
	in1 =>cntr_data,
	in2=>q_sig,
	sel =>cntr_edit_sig,
	m_out => m_sig
);
led: led8_drv port map(
	a=>m_sig(31 downto 28),
	b=>m_sig(27 downto 24),
	c=>m_sig(23 downto 20),
	d=>m_sig(19 downto 16),
	e=>m_sig(15 downto 12),
	f=>m_sig(11 downto 8),
	g=>m_sig(7 downto 4),
	h=>m_sig(3 downto 0),
	clk_in=>clk_sig,
	Sseg => sseg,
	An => an
);
key_f: key_fsm_c port map(
	clk =>clk_sys_sig,
	rst => Rst,
	left =>edg_sig(4),
	right=>edg_sig(3),
	up=>edg_sig(2),
	down=>edg_sig(1),
	center=>edg_sig(0),
	data_out=>cntr_data,
	cntr_en=> cntr_en_sig,
	cntr_rst => cntr_rst_sig,
	cntr_load=>cntr_load_sig,
	edit_en_out=>cntr_edit_sig
);

end architecture;