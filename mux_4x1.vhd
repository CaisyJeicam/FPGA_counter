-----------------------------------------------------------------------
-- PUR lab1
-- mux struct test
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.gates_pkg.all;

entity mux_4x1 is
  port(wejscie: in std_logic_vector(3 downto 0);
      adres: in std_logic_vector(1 downto 0);
      wyjscie: out std_logic);
end entity;

architecture struct of mux_4x1 is
 signal adres_n: std_logic_vector(1 downto 0);
 signal and_out: std_logic_vector(3 downto 0);

begin
  
inst_not0: inverter port map(adres(0), adres_n(0));
inst_not1: inverter port map(in1=>adres(1), out1=>adres_n(1));

inst_and0: and3 port map(wejscie(0), adres_n(1), adres_n(0), and_out(0));
inst_and1: and3 port map(wejscie(1), adres_n(1),   adres(0), and_out(1));
inst_and2: and3 port map(wejscie(2),   adres(1), adres_n(0), and_out(2));
inst_and3: and3 port map(wejscie(3),   adres(1),   adres(0), and_out(3));

inst_or: or4 
    port map(in1=> and_out(0),
             in2=> and_out(1),
             in3=> and_out(2),
             in4=> and_out(3),
             out1=> wyjscie);

end architecture struct;    