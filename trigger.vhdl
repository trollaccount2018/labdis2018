library ieee;
use ieee.std_logic_1164.all;
Library UNISIM;
use UNISIM.vcomponents.all;

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
	signal INTERCON : std_logic_vector(48 downto 0);

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
			SIGNAL_X <= xor (SIGNAL_X_VEC & TOGGLE);
		end if;
	end process;

	-- DSP part to be inserted
	--SIGNAL_X_VEC(48) <= 'X';
	--SIGNAL_X_VEC(47 downto 0) <= (others => '0');
	-- end DSP part

	SIGNAL_0 <= nor LFSR_0; -- == 0
	SIGNAL_1 <= or LFSR_1;  -- != 0

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
	
	------------------------------------------------------------------------------------------------
	-- DSP instantiation ---------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------
	
	DSP48E1_inst : DSP48E1
       generic map (
          -- Feature Control Attributes: Data Path Selection
          A_INPUT => "DIRECT",               -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
          B_INPUT => "DIRECT",               -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
          USE_DPORT => FALSE,                -- Select D port usage (TRUE or FALSE)
          USE_MULT => "MULTIPLY",            -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
          USE_SIMD => "ONE48",               -- SIMD selection ("ONE48", "TWO24", "FOUR12")
          -- Pattern Detector Attributes: Pattern Detection Configuration
          AUTORESET_PATDET => "NO_RESET",    -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
          MASK => X"3fffffffffff",           -- 48-bit mask value for pattern detect (1=ignore)
          PATTERN => X"000000000000",        -- 48-bit pattern match for pattern detect
          SEL_MASK => "MASK",                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
          SEL_PATTERN => "PATTERN",          -- Select pattern value ("PATTERN" or "C")
          USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect ("PATDET" or "NO_PATDET")
          -- Register Control Attributes: Pipeline Register Configuration
          ACASCREG => 0,                     -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
          ADREG => 1,                        -- Number of pipeline stages for pre-adder (0 or 1)
          ALUMODEREG => 0,                   -- Number of pipeline stages for ALUMODE (0 or 1)
          AREG => 0,                         -- Number of pipeline stages for A (0, 1 or 2)
          BCASCREG => 0,                     -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
          BREG => 0,                         -- Number of pipeline stages for B (0, 1 or 2)
          CARRYINREG => 0,                   -- Number of pipeline stages for CARRYIN (0 or 1)
          CARRYINSELREG => 0,                -- Number of pipeline stages for CARRYINSEL (0 or 1)
          CREG => 1,                         -- Number of pipeline stages for C (0 or 1)
          DREG => 1,                         -- Number of pipeline stages for D (0 or 1)
          INMODEREG => 0,                    -- Number of pipeline stages for INMODE (0 or 1)
          MREG => 1,                         -- Number of multiplier pipeline stages (0 or 1)
          OPMODEREG => 0,                    -- Number of pipeline stages for OPMODE (0 or 1)
          PREG => 0                          -- Number of pipeline stages for P (0 or 1)
       )
       port map (
          -- Cascade: 30-bit (each) output: Cascade Ports
          --ACOUT => ACOUT,                   -- 30-bit output: A port cascade output
          --BCOUT => BCOUT,                   -- 18-bit output: B port cascade output
          --CARRYCASCOUT => CARRYCASCOUT,     -- 1-bit output: Cascade carry output
          --MULTSIGNOUT => MULTSIGNOUT,       -- 1-bit output: Multiplier sign cascade output
          --PCOUT => PCOUT,                   -- 48-bit output: Cascade output
          -- Control: 1-bit (each) output: Control Inputs/Status Bits
          OVERFLOW => SIGNAL_X_VEC(48),     -- 1-bit output: Overflow in add/acc output
          --PATTERNBDETECT => PATTERNBDETECT, -- 1-bit output: Pattern bar detect output
          --PATTERNDETECT => PATTERNDETECT,   -- 1-bit output: Pattern detect output
          --UNDERFLOW => UNDERFLOW,           -- 1-bit output: Underflow in add/acc output
          -- Data: 4-bit (each) output: Data Ports
          --CARRYOUT => CARRYOUT,             -- 4-bit output: Carry output
          P => SIGNAL_X_VEC(47 downto 0),     -- 48-bit output: Primary data output
          -- Cascade: 30-bit (each) input: Cascade Ports
          ACIN => (others => '0'),          -- 30-bit input: A cascade data input
          BCIN => (others => '0'),          -- 18-bit input: B cascade input
          CARRYCASCIN => '0',   -- 1-bit input: Cascade carry input
          MULTSIGNIN => '0',    -- 1-bit input: Multiplier sign input
          PCIN => (others => '0'),          -- 48-bit input: P cascade input
          -- Control: 4-bit (each) input: Control Inputs/Status Bits
          ALUMODE => (others => '0'),       -- 4-bit input: ALU control input
          CARRYINSEL => (others => '0'),    -- 3-bit input: Carry select input
          CLK => CLK,                       -- 1-bit input: Clock input
          INMODE => (others => '0'),        -- 5-bit input: INMODE control input
          OPMODE => (others => '0'),        -- 7-bit input: Operation mode input
          -- Data: 30-bit (each) input: Data Ports
          A => LFSR_0 & LFSR_0 & LFSR_0 & LFSR_0 & LFSR_0, -- 30-bit input: A data input
          B => LFSR_1 & LFSR_1 & LFSR_1,    -- 18-bit input: B data input
          C => (0 => '1', others => '0'),   -- 48-bit input: C data input
          CARRYIN => '0',                   -- 1-bit input: Carry input signal
          D => (others => '0'),             -- 25-bit input: D data input
          -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
          CEA1 => '0',                      -- 1-bit input: Clock enable input for 1st stage AREG
          CEA2 => '0',                      -- 1-bit input: Clock enable input for 2nd stage AREG
          CEAD => '0',                      -- 1-bit input: Clock enable input for ADREG
          CEALUMODE => '0',                 -- 1-bit input: Clock enable input for ALUMODE
          CEB1 => '0',                      -- 1-bit input: Clock enable input for 1st stage BREG
          CEB2 => '0',                      -- 1-bit input: Clock enable input for 2nd stage BREG
          CEC => '0',                       -- 1-bit input: Clock enable input for CREG
          CECARRYIN => '0',                 -- 1-bit input: Clock enable input for CARRYINREG
          CECTRL => '0',                    -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
          CED => '0',                       -- 1-bit input: Clock enable input for DREG
          CEINMODE => '0',                  -- 1-bit input: Clock enable input for INMODEREG
          CEM => '0',                       -- 1-bit input: Clock enable input for MREG
          CEP => '0',                       -- 1-bit input: Clock enable input for PREG
          RSTA => '0',                      -- 1-bit input: Reset input for AREG
          RSTALLCARRYIN => '0',             -- 1-bit input: Reset input for CARRYINREG
          RSTALUMODE => '0',                -- 1-bit input: Reset input for ALUMODEREG
          RSTB => '0',                      -- 1-bit input: Reset input for BREG
          RSTC => '0',                      -- 1-bit input: Reset input for CREG
          RSTCTRL => '0',                   -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
          RSTD => '0',                      -- 1-bit input: Reset input for DREG and ADREG
          RSTINMODE => '0',                 -- 1-bit input: Reset input for INMODEREG
          RSTM => '0',                      -- 1-bit input: Reset input for MREG
          RSTP => '0'                       -- 1-bit input: Reset input for PREG
       );
    
       -- End of DSP48E1_inst instantiation
	
	------------------------------------------------------------------------------------------------
	-- end DSP -------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------

end DATAFLOW;
