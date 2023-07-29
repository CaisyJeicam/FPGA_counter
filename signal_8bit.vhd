library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity zad0 is
Port (Ck : in STD_LOGIC;
	O : out STD_LOGIC_VECTOR(7 downto 0));
end zad0;

architecture Behavioral of zad0 is
	signal mem : STD_LOGIC_VECTOR(7 downto 0);
begin
	process (CK)
	begin
		if CK = '0' then null;
		elsif (CK'event and CK = '1') then
			mem <= std_logic_vector(to_unsigned(to_integer(unsigned(mem)) + 1, 8));
		end if;
	end process;
	O <= mem;
end Behavioral;
