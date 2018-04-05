library ieee;
use ieee.std_logic_1164.all;

entity noise_TB is
end noise_TB;

architecture TESTBENCH of noise_TB is

	component NOISE is
		generic (N: integer:=733);
		port (
			NOISE_clk : in std_logic;
			NOISE_enRO : in std_logic;
			NOISE_out : out std_logic
		);
	end component;

	signal CLK : std_logic := '0';
	signal EN : std_logic;
	signal NOUT : std_logic;

begin
	CLK <= not CLK after 5 ns;
	EN <= '1';

	DUT: NOISE generic map (733) port map (CLK,EN,NOUT);
end TESTBENCH;
