library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------

entity SEPA is
	generic(N : natural :=128);
	port(	CLK, SE, RESET: in std_logic;
		REG: out std_logic_vector(N-1 downto 0);
		READY : out std_logic;
		I_OUT : out std_logic_vector(7 downto 0)
	);
end SEPA;

---------------------------------------------------

architecture BEHAV of SEPA is
	signal INTREG: std_logic_vector(N-1 downto 0);
	signal SE_bit: std_logic;
		
begin
	P1: process(CLK, RESET)
	variable i : integer := 0;
	begin
		if RESET='1' then
			INTREG <= (others => '0');
		
		elsif (CLK='1' and CLK'event) then
			INTREG <= INTREG(N-2 downto 0) & SE;
			i:=i+1;
			if i=N then
				READY <='1';
				i:=0;
			else
				READY <='0';
			end if;
		end if;
		I_OUT<=std_logic_vector(to_unsigned(i,8));
	end process P1;

	REG<=INTREG;
	
end BEHAV;
