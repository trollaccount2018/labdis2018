-- SEPA gets bitstream noise from NOISE and puts
-- out vectors of N random bits.
-- CLK		: in  - clock input
-- RESET 	: in  - flush register, active high
-- ENABLE 	: in  - enable NOISE 
-- READY	: out - new word ready, active high
-- (I_OUT	: out - debug signal)

----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

----------------------------------------------------

entity SEPA is
	generic(N : natural :=128; R : natural := 733 );
	port(	CLK, RESET, ENABLE: in std_logic;
		REG: out std_logic_vector(N-1 downto 0);
		READY : out std_logic
		--DIAG : out std_logic
	);
end SEPA;

----------------------------------------------------

architecture BEHAV of SEPA is

signal INTREG: std_logic_vector(N-1 downto 0);
signal SIG_NOISE : std_logic;

--debuggin:
--signal INTERCON: std_logic_vector(733 downto 0);

component NOISE is
	generic (M: integer:=733);
	port (
		NOISE_clk : in std_logic;
		NOISE_enRO : in std_logic;
		NOISE_out : out std_logic
		--diag : out std_logic
		);
end component;

begin
	NOISE1: NOISE generic map(R) port map (CLK,ENABLE,SIG_NOISE);
	P1: process(CLK, RESET)
	variable i : integer := 0;
	begin
		--debugging:
		--if(INTERCON(0) = '1') then
		--	DIAG <= '1';
		--end if;
		
		if RESET='1' then
			INTREG <= (others => '0');
		
		elsif (CLK='1' and CLK'event) then
			INTREG <= INTREG(N-2 downto 0) & SIG_NOISE;
			--debugging:
			--INTREG <= INTREG(N-2 downto 0) & '1';
			i:=i+1;
			if i=N then
				READY <='1';
				i:=0;
			else
				READY <='0';
			end if;
		end if;
		--I_OUT<=std_logic_vector(to_unsigned(i,8));
	end process P1;

	REG<=INTREG;

	--debugging:
	--NBIT: for I in 1 to 733 generate
	--	INTERCON(I) <= not INTERCON(I-1);
	--end generate NBIT;
	--INTERCON(0) <= not INTERCON(733);
	--SIG_NOISE <= INTERCON(0);


	--debugging:
	--REG <= "01000001010000100100001101000100010001010100011001000111010010000100100101001010010010110100110001001101010011100100111101010000";
	
end BEHAV;
