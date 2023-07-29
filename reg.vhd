-----------------------------------------------------------------------
-- PUR lab2
-- rotate behav test
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
    Generic (Tpd: time := 3 ns);
    Port (clk : in std_logic; -- rising edge
            load : in std_logic; -- d load
            rot : in std_logic; -- rotate
            d : in std_logic_vector(7 downto 0);
            q : out std_logic_vector(7 downto 0));
end entity reg;

architecture behav of reg is
 signal q_i: std_logic_vector(7 downto 0);

begin

q <= q_i;

process(clk) begin
    if rising_edge(clk) then
        if load='1' then
            q_i <= d after Tpd;
        elsif rot='1' then 
            q_i <= q_i(6 downto 0) & q_i(7) after Tpd;
        end if;
    end if;	
end process;

end architecture behav;