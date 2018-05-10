library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------------

entity trigger_tb is
	-- TBs don't have ports
end trigger_tb;

---------------------------------------------------------------------------------

architecture DATAFLOW of trigger_tb is

	component trigger is
		port(CLK : in std_logic; TRIGGER : out std_logic);
	end component;

	signal CLK : std_logic := '0';
	signal TRIGGER_OUT : std_logic;

begin

	process
	begin
		CLK <= '1';
		wait for 10 ns;
		CLK <= '0';
		wait for 10 ns;
		CLK <= '1';
		wait for 10 ns;
		CLK <= '0';
		wait for 10 ns;
		CLK <= '1';
        wait for 10 ns;
        CLK <= '0';
        wait for 10 ns;
        CLK <= '1';
        wait for 10 ns;
        CLK <= '0';
        wait;
	end process;

	DUT: trigger port map (CLK, TRIGGER_OUT);

end DATAFLOW;
