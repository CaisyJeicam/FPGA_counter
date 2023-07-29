----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:26:52 04/12/2022 
-- Design Name: 
-- Module Name:    key_fsm_c - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_fsm_c is
	port (clk: in std_logic;
		rst: in std_logic; -- synch, high
		left, right, up, down, center: in std_logic; -- keys
		data_out: out std_logic_vector(31 downto 0);
		cntr_en: out std_logic;
		cntr_rst: out std_logic;
		cntr_load: out std_logic;
		edit_en_out: out std_logic
	);
end key_fsm_c;

architecture Behavioral of key_fsm_c is
	type state_type is (idle, start, stop, reset, load, edit, inc_v, dec_v, inc_p, dec_p);
	signal c_state, n_state : state_type;
	signal value : std_logic_vector(31 downto 0);
	signal add : std_logic_vector(31 downto 0);

begin
	proc_fsm: process(c_state, left, right, up, down, center) begin
		data_out <= value;
		cntr_en <= '0';
		case c_state is 
			when idle =>
				cntr_load <= '0';
				cntr_rst <= '0';
				edit_en_out <= '0';
				if left = '1' then
					n_state <= stop;
				elsif right = '1' then
					n_state <= start;
					elsif down = '1' then
					n_state <= reset;
				elsif up = '1' then
					n_state <= load;
				elsif center = '1' then
					n_state <= edit;
				else 
					n_state <= idle;
				end if;
			when start =>
				cntr_en <= '1';
				n_state <= idle;
			when stop =>
				cntr_en <= '0';
				n_state <= idle;
			when reset =>
				cntr_rst <= '1';
				n_state <= idle;
			when load =>
				data_out <= value;
				cntr_load <= '1';
				n_state <= idle;
			when edit =>
				cntr_en <= '0';	
				edit_en_out <= '1';
				if left = '1' then
					n_state <= inc_p;
				elsif right = '1' then
					n_state <= dec_p;
				elsif down = '1' then
					n_state <= dec_v;
				elsif up = '1' then
					n_state <= inc_v;
				elsif center = '1' then
					n_state <= load;
				else 
					n_state <= edit;
				end if;
			when inc_p =>
				add <= std_logic_vector(to_unsigned(to_integer(unsigned(add)) * 16, 31)); 
				n_state <= edit;
			when dec_p =>
				add <= std_logic_vector(to_unsigned(to_integer(unsigned(add)) / 16, 31)); 
				n_state <= edit;
			when inc_v =>
				value <= std_logic_vector(to_unsigned(to_integer(unsigned(value) + unsigned(add)), 31));
				n_state <= edit;
			when dec_v =>
				value <= std_logic_vector(to_unsigned(to_integer(unsigned(value) - unsigned(add)), 31));
				n_state <= edit;
		end case;
	end process;

	proc_memory: process (clk, rst)
 	begin
 		if (rst ='1') then
 			c_state <= idle;
 		elsif rising_edge(clk) then
 			c_state <= n_state;
 		end if;
 	end process;
			
end Behavioral;

