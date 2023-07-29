library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity licznik_tb is
end entity;

architecture test of licznik_tb is
    signal clock : std_logic := '1';
    signal rst : std_logic;
    signal ce : std_logic := '1';
    signal q_out : std_logic_vector(20 downto 0);
    signal tc_out : std_logic;

    procedure clk_process(signal s:out std_logic; period: delay_length) is
    begin loop
            s <= '0', '1' after period/2;
            wait for period; end loop;
    end procedure clk_process;

    procedure rst_process(siganl s:out std_logic;) is
    begin
        s <= '1', '0' after 200ns; 
    end procedure rst_process;

    procedure get_period(signal s:in std_logic) is
        variable t1, t2: delay_length:=0 ns;
    begin
        t1 := now;
        wait until s = '1';
        t2 := now - t1;
        report "period " & time'image(t2) severity Warning;
    end procedure get_period;

    procedure get_pulse(signal s:in std_logic) is
        variable t1, t2: delay_length:=0 ns;
    begin
        if rising_edge(s) then t1 := now;
        wait until s = '0';
        t2 := now - t1;
        report "signal " & time'image(t2) severity Warning;
        end if;
    end procedure get_pulse;

    procedure report_last(signal s:in std_logic) is
    begin
        if rising_edge(s) then report "Last state: " & integer'image(to_integer(q_out)) severity Warning;
        end if;
    end procedure report_last;

    procedure end_simulation(time: delay_length) is
    begin
        wait for time;
        assert false 
        report "End of simulation at time " & time'image(now);
        severity Failure;
    end procedure end_simulation;


begin
    UUT: entity work.licznik_144679(behav)
    port map(clock, rst, ce, q_out, tc_out);

    gen_clk: clk_process(clock, 100 ns);
    gen_rst: rst_process(rst);

    gen_period: get_period(rst);
    gen_pulse: get_pulse(tc_out);
    gen_last: report_last(q_out);
    gen_end: end_simulation(14467900ns);
   


end architecture;