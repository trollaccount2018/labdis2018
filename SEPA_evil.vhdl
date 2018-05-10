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
			LFSR <= "10101010";
		
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
	variable count_dracula, dracula : integer := 0;
	begin
	
	if (CLK='1' and CLK'event and EN='0') then
        count_dracula := count_dracula + 1;
	end if;
	
	if (EN='1' and EN'event) then
	dracula := count_dracula;
        count_dracula := 0;
	end if;
	
	--Trigger
	if(dracula > 3840) then --(128/100MHz) =Tsample. 30*Tsample / Tclk = (30*128/100MHz)/(1/100MHz) = 30*128 = 3840 - muss sicher länger sein als Samplen, Übertragen und Samplen im Testmode
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
