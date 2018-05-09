library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------------

entity trigger is
	port (
		CLK 	: in std_logic;
		TRIGGER	: out std_logic
	);
end trigger;

---------------------------------------------------------------------------------

architecture DATAFLOW of trigger is

	signal TOGGLE : std_logic;
	signal LFSR_0 : std_logic_vector(5 downto 0) := "000001"; -- = 1
	signal LFSR_1 : std_logic_vector(5 downto 0) := "000010"; -- = 2
	signal SIGNAL_X_VEC : std_logic_vector(48 downto 0);
	signal SIGNAL_X : std_logic;
	signal SIGNAL_0 : std_logic;
	signal SIGNAL_1 : std_logic;
	signal TRIGGER_A : std_logic;
	signal TRIGGER_B : std_logic;

begin

	process(CLK)
	begin
		if(CLK'event and CLK = '1') then
			TOGGLE <= not TOGGLE;
			LFSR_0 <= LFSR_0(4 downto 0) & (LFSR_0(4) xor LFSR_0(5));
			LFSR_1 <= LFSR_1(4 downto 0) & (LFSR_1(4) xor LFSR_1(5));
		end if;
	end process;

	process(CLK)
	begin
		if(CLK'event and CLK = '1') then
			--SIGNAL_X <= xor (SIGNAL_X_VEC & TOGGLE);
		end if;
	end process;

	-- DSP part to be inserted
	SIGNAL_X_VEC(48) <= 'X';
	SIGNAL_X_VEC(47 downto 0) <= (others => '0');
	-- end DSP part

	SIGNAL_0 <= '1' when (LFSR_0(0) or LFSR_0(1) or LFSR_0(2) or LFSR_0(3) or LFSR_0(4) or LFSR_0(5)) = '0' else '0'; -- == 0
	SIGNAL_1 <= '1' when (LFSR_1(0) or LFSR_1(1) or LFSR_1(2) or LFSR_1(3) or LFSR_1(4) or LFSR_1(5)) = '1' else '0'; -- != 0
	-- to be replaced with reduction operators

	process(CLK)
	begin
		if(CLK'event and CLK = '1') then
			if (SIGNAL_X = '1') then
				TRIGGER_A <= SIGNAL_1;
			else
				TRIGGER_A <= SIGNAL_0;
			end if;
			TRIGGER_B <= TRIGGER_A;
		end if;
	end process;

	TRIGGER <= TRIGGER_A or TRIGGER_B;

end DATAFLOW;
