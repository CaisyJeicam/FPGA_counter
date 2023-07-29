-----------------------------------------------------------------------
-- PUR lab2
-- rotate behav tb test
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_tb is
end entity reg_tb;

architecture behav of reg_tb is
 constant Tpd: time:= 2 ns;
 signal clock, load_data, rotate : std_logic := '0';
 signal q_out : std_logic_vector(7 downto 0);
 signal data : std_logic_vector(7 downto 0):=(others=>'0');

begin
  -- instantiation of unit under test 
  UUT: entity work.reg(behav)
       generic map(Tpd)
       port map (
         clk => clock,
         load => load_data,
         rot => rotate,
         d => data,
         q => q_out);
       
  -- stimuli for clock
  clk_process: process begin
    wait for 10 ns;    
    clock <= not clock;
  end process clk_process;
  
  -- data control
  p1_proc: process begin
    wait for 5 ns;
    data <= b"0000_0001";
    load_data <= '1', '0' after 10 ns;
    wait for 120 ns;
    data <= x"11";
    load_data <= '1', '0' after 10 ns;
    wait;
  end process p1_proc;

  rotate <= '0', '1' after 15 ns, '0' after 95 ns, '1' after 185 ns;
  
  -- end of simulation 
  sim_end_process: process begin
    wait for 350 ns;
    assert false
      report "End of simulation at time " & time'image(now)
      severity Failure;
  end process sim_end_process;
  
end architecture behav;
--------------------------------------------------