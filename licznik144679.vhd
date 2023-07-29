library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.gates_pkg.all;
use work.devices_pkg.all;

entity licznik_144679 is
    port (
        CK : in std_logic;
        RST : in std_logic;
        CE : in std_logic;
        Q : out std_logic_vector(20 downto 0);
        Tc : out std_logic
    );
end entity;

architecture behav of licznik_144679 is
    signal cntr_0 : std_logic_vector(3 downto 0);
    signal cntr_1 : std_logic_vector(3 downto 0);
    signal cntr_2 : std_logic_vector(3 downto 0);
    signal cntr_3 : std_logic_vector(3 downto 0);
    signal cntr_4 : std_logic_vector(3 downto 0);
    signal cntr_5 : std_logic_vector(3 downto 0);
    signal and_vector : std_logic_vector(7 downto 0);
    signal inv_vector : std_logic_vector(14 downto 0);
    signal ce_vector : std_logic_vector(5 downto 0);
    signal reset : std_logic; 

begin
    inst_cntr0 : cntr_u port map(reset, CE, CK, ce_vector(0), cntr_0);
    inst_cntr1 : cntr_u port map(reset, ce_vector(0), CK, ce_vector(1), cntr_1);
    inst_cntr2 : cntr_u port map(reset, ce_vector(1), CK, ce_vector(2), cntr_2);
    inst_cntr3 : cntr_u port map(reset, ce_vector(2), CK, ce_vector(3), cntr_3);
    inst_cntr4 : cntr_u port map(reset, ce_vector(3), CK, ce_vector(4), cntr_4);
    inst_cntr5 : cntr_u port map(reset, ce_vector(4), CK, ce_vector(5), cntr_5);

    inst_not0 : inverter port map(cntr_0(2),inv_vector(0));
    inst_not1 : inverter port map(cntr_0(1),inv_vector(1));
    inst_not2 : inverter port map(cntr_0(0),inv_vector(2));
    inst_not3 : inverter port map(cntr_1(3),inv_vector(3));
    inst_not4 : inverter port map(cntr_2(3),inv_vector(4));
    inst_not5 : inverter port map(cntr_2(0),inv_vector(5));
    inst_not6 : inverter port map(cntr_3(3),inv_vector(6));
    inst_not7 : inverter port map(cntr_3(1),inv_vector(7));
    inst_not8 : inverter port map(cntr_3(0),inv_vector(8));
    inst_not9 : inverter port map(cntr_4(3),inv_vector(9));
    inst_not10 : inverter port map(cntr_4(1),inv_vector(10));
    inst_not11 : inverter port map(cntr_4(0),inv_vector(11));
    inst_not12 : inverter port map(cntr_5(3),inv_vector(12));
    inst_not13 : inverter port map(cntr_5(2),inv_vector(13));
    inst_not14 : inverter port map(cntr_5(1),inv_vector(14));

    inst_and0 : and4 port map(cntr_0(3), inv_vector(0), inv_vector(1), inv_vector(2), and_vector(0));
    inst_and1 : and4 port map(inv_vector(3), cntr_1(2), cntr_1(1), cntr_1(0), and_vector(1));
    inst_and2 : and4 port map(inv_vector(4), cntr_2(2), cntr_2(1), inv_vector(5), and_vector(2));
    inst_and3 : and4 port map(inv_vector(6), cntr_3(2), inv_vector(7), inv_vector(8), and_vector(3));
    inst_and4 : and4 port map(inv_vector(9), cntr_4(2), inv_vector(10), inv_vector(11), and_vector(4));
    inst_and5 : and4 port map(inv_vector(12), inv_vector(13), inv_vector(14), cntr_5(0), and_vector(5));

    inst_and6 : and4 port map(and_vector(0), and_vector(1), and_vector(2), and_vector(3), and_vector(6));
    inst_and7 : and3 port map(and_vector(4), and_vector(5), and_vector(6), and_vector(7));

    inst_or0 : or2 port map(RST, and_vector(7), reset);

    Tc <= reset;
    Q <= std_logic_vector(to_unsigned(to_integer(unsigned(cntr_0) + 
    unsigned(cntr_1) * 10 +
    unsigned(cntr_2) * 100 +
    unsigned(cntr_3) * 1000 +
    unsigned(cntr_4) * 10000 +
    unsigned(cntr_5) * 100000), 21));

end architecture behav;