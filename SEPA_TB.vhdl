library ieee;
use ieee.std_logic_1164.all;

entity SEPA_TB is
	generic ( N : natural := 128);
end SEPA_TB;

architecture TESTBENCH of SEPA_TB is
	component SEPA is
		generic(N : natural :=128);
		port(	CLK, SE, RESET: in std_logic;
			REG: out std_logic_vector(N-1 downto 0);
			READY : out std_logic;
			I_OUT : out std_logic_vector(7 downto 0)
		);
	end component;

	signal CLK : std_logic := '0'; 
	signal SE : std_logic := '0';
	signal RESET : std_logic := '0';
	signal READY : std_logic;
	signal REG : std_logic_vector(127 downto 0);
	signal I_OUT : std_logic_vector(7 downto 0);
begin
	CLK <= not CLK after 10 ns;
	SE <= not SE after 20 ns;

	DUT: SEPA generic map (N) port map(CLK,SE,RESET,REG,READY,I_OUT);
end TESTBENCH;
