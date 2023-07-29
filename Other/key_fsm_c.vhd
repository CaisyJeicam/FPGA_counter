-- Create Date: 18.05.2022
-- Author: Stefan Zbaszyniak and Helena Maslowska
------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity key_fsm_c is
	port (clk: in std_logic;
	rst: in std_logic; -- synch, high
	left, right, up, down, center: in std_logic; -- keys
	data_out: out std_logic_vector(31 downto 0):= std_logic_vector(to_unsigned(0, 32));
	cntr_en: out std_logic; -- clock enable
	cntr_rst: out std_logic; -- clock reset
	cntr_load: out std_logic;
	edit_en_out: out std_logic
);
end entity;

architecture beh1 of key_fsm_c is
	type state_type is (idle, stop, start, reset, load, edit, decpos, incpos, decval, incval);
	signal c_state, n_state: state_type;
	signal data_stop : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(0, 32));
begin 

	proc_fsm: process(c_state, left, right, up, down, center) begin
		case c_state is
			when idle => 
                    if left='1' then n_state <= stop;
                    elsif right='1' then n_state <= start;
                    elsif up='1' then n_state <= load;
                    elsif down='1' then n_state <= reset;
                    elsif center='1' then n_state <= edit;
                    else n_state <= idle;
                    end if;
			when edit =>
                    if left='1' then n_state <= incpos;
                    elsif right='1' then n_state <= decpos;
                    elsif up='1' then n_state <= incval;
                    elsif down='1' then n_state <= decval;
                    elsif center='1' then n_state <= load;
                    else n_state <= edit;
                    end if;
			when stop => n_state <= idle;
			when start => n_state <= idle;
			when reset => n_state <= idle;
			when load => n_state <= idle;

			when decpos => n_state <= edit;
			when incpos => n_state <= edit;
			when decval => n_state <= edit;
			when incval => n_state <= edit;
			when others => n_state <= idle;
			end case;
	end process;
	
	proc_memory: process(clk) 

		variable position: integer := 0;

	begin
		if rising_edge(clk) then
			if (rst='1') then 
				cntr_load <= '0';
				edit_en_out <= '0';
				cntr_en <= '0';
				cntr_rst <= '1';
			else 
			cntr_rst <= '0';
			c_state <= n_state;
			cntr_load <= '0';
			cntr_rst <= '0';
			if (c_state = stop) then
				cntr_en <= '0'; 
			elsif (c_state = start) then
				cntr_en <= '1';
			elsif (c_state = reset) then
				cntr_rst <= '1';
			elsif (c_state = load) then
				cntr_load <= '1';
				edit_en_out <= '0';
			elsif (c_state = edit) then
				cntr_en <= '0';
				edit_en_out <= '1';
			elsif (c_state = decpos) then
				if (position>0) then
					position := position - 1;
				else position := 7;
				end if;
			elsif (c_state = incpos) then
				if (position<7) then
					position := position + 1;
				else position := 0;
				end if;
			elsif (c_state = decval) then
				if unsigned(data_stop((position+1)*4-1 downto position*4)) > 0 then
					data_stop((position+1)*4-1 downto position*4) <= std_logic_vector(unsigned(data_stop((position+1)*4-1 downto position*4)) - 1);
				else
					data_stop((position+1)*4-1 downto position*4) <= std_logic_vector(to_unsigned(9, 4));
		    		end if;
			elsif (c_state = incval) then
				if unsigned(data_stop((position+1)*4-1 downto position*4)) < 9 then
					data_stop((position+1)*4-1 downto position*4) <= std_logic_vector(unsigned(data_stop((position+1)*4-1 downto position*4)) + 1);
				else
					data_stop((position+1)*4-1 downto position*4) <= std_logic_vector(to_unsigned(0, 4));
		    		end if;
			end if;
			data_out <= data_stop;
		end if;
		end if;
	end process;
	
end beh1;
