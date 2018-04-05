library ieee;
use ieee.std_logic_1164.all;

entity SEPA_TB is
	generic ( N : natural := 128);
end SEPA_TB;

architecture TESTBENCH of SEPA_TB is
	component SEPA is
		generic(N : natural :=128);
		port(	CLK, RESET, ENABLE : in std_logic;
			REG: out std_logic_vector(N-1 downto 0);
			READY : out std_logic
		);
	end component;

	signal CLK : std_logic := '0'; 
	signal ENABLE : std_logic := '0';
	signal RESET : std_logic := '0';
	signal READY : std_logic;
	signal REG : std_logic_vector(127 downto 0);
begin
	CLK <= not CLK after 10 ns;
	RESET <= '1', '0' after 20 ns;
	ENABLE <= '1';

	DUT: SEPA generic map (N) port map(CLK,RESET,ENABLE,REG,READY);
end TESTBENCH;
