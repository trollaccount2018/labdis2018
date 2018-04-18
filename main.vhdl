library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

entity main is
	generic (m : natural :=128; p : natural := 733); --word width, number of rings
	port (
		CLK		: in std_logic;
		UART_TX_PIN	: out std_logic;
		LED		: out std_logic_vector(7 downto 0);
		RST		: in std_logic;
		BTNR		: in std_logic;
		SW0		: in std_logic;
		AN		: out std_logic_vector(7 downto 0);
		CA		: out std_logic_vector(7 downto 0)
	);
end main;

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

architecture behaviour of main is
	component uart_tx is
       		generic (
            		CLK_FREQ : integer; -- in Hz
    			BAUDRATE : integer  -- in bit/s
        	);	
        	port (
            		clk   : in std_logic;
    			rst   : in std_logic;
    			send  : in std_logic;
    			data  : in std_logic_vector(7 downto 0);
    			rdy   : out std_logic;
    			tx    : out std_logic
       	 	);
    	end component;

   	component SEPA is
		generic(N : natural := m; r : natural := p);
		port(	CLK, RESET, ENABLE: in std_logic;
			REG: out std_logic_vector(N-1 downto 0);
			READY : out std_logic
		);
	end component;

	component postprocessor is
		generic ( o : integer := m );
		port (
			clk : in std_logic;
			s   : in std_logic_vector(m-1 downto 0);
			r   : out std_logic_vector(m-1 downto 0)
	);
	end component;

	component sevendisp is
		port (
			CLK	: in std_logic;
			INPUT	: in std_logic_vector(31 downto 0);
			AN	: out std_logic_vector(7 downto 0); -- common anodes
			CA	: out std_logic_vector(7 downto 0)  -- cathodes
		);
	end component;


	signal sig_UART_send : std_logic;
	signal sig_UART_rst : std_logic;
	signal sig_NOISE_enable : std_logic;
	signal sig_noise : std_logic;
	signal sig_UART_ready : std_logic;
	signal sig_NOISE_REG : std_logic_vector(m-1 downto 0);
	signal sig_PROCESSED : std_logic_vector(m-1 downto 0);
	signal sig_NOISE_ready : std_logic;
	signal sig_data :std_logic_vector(7 downto 0);
	signal sig_DIAG : std_logic;
	signal sig_DISPLAYBUFFER : std_logic_vector(31 downto 0);


begin
	-- instantiate UART
        usart: uart_tx
		generic map( 100E6, 921600)
		port map (clk, sig_UART_rst, sig_UART_send, sig_data, sig_UART_ready, UART_TX_PIN);

	-- instantiate noise generation
	serpar:SEPA
		generic map (m,p)
		port map (CLK, sig_UART_rst, sig_NOISE_enable, sig_PROCESSED, sig_NOISE_ready);

	-- instantiate post-processor
	pproc:POSTPROCESSOR
		generic map (m)
		port map (CLK, sig_NOISE_REG, sig_DISPLAYBUFFER);

	-- instantiate 7seg display
	sevs:sevendisp
		port map (CLK, sig_DISPLAYBUFFER, AN, CA);

	process (clk)
	variable state: integer := 2; -- 0: sample, 1: send, 2: wait
	variable i: integer := 0;
	variable wait1: std_logic := '0';
	variable wait2: std_logic := '0';
	variable SIG_BTNR: std_logic :='0';
	begin
           	if (clk'event and clk='1') then

			--debounce:
			if(BTNR = '1' and SIG_BTNR = '0') then
				SIG_BTNR := '1';
			end if;
				
			if(BTNR = '0' and SIG_BTNR = '1') then
				state:=0; -- sample!
				SIG_BTNR := '0';
			end if;

			if(state=0 and wait1 = '0' and wait2 = '0') then
				-- 0: sample,
                    		sig_NOISE_enable <= '1'; -- enable noise generation
				sig_UART_send <= '0'; 
                
                    		if(sig_NOISE_ready = '1') then -- number ready
					sig_NOISE_enable <= '0'; -- disable noise generation
					sig_DISPLAYBUFFER <= sig_PROCESSED(31 downto 0);
                    	    		state := 1;
					i := 1;
                   		end if;
               		end if;
                
                	if(state=1 and wait1 = '0' and wait2 = '0') then
				--  1: send
				if(sig_UART_ready = '0') then -- UART busy
					sig_UART_send <= '0';
				end if;

                   		if(sig_UART_ready = '1') then -- UART ready, send next byte
					--sig_data <= sig_NOISE_REG(8*(i)-1 downto 8*(i)-8);
					sig_data <= sig_PROCESSED(8*(i)-1 downto 8*(i)-8);
					sig_UART_send <= '1';
					wait1 := '1';
					wait2 := '1';
                    		end if;
                    
				if (i = m/8+1) then -- number fully transmitted
					if (SW0 = '1') then 	-- test mode
						state := 0;
					else			-- productive mode
						state := 2;
					end if;
                    		end if;
                	end if;
			
			-- Give UART a chance to signal 'busy'
			if(wait1 = '1') then
				wait1 := '0';
				--LED(4) <= '1';
			else
				if(wait2 = '1') then
					wait2 := '0';
					--LED(4) <= '0';
					i := i+1;
				end if;
			end if;
            	end if;
	end process;

	--debugging:
	--NBIT: for I in 1 to 732 generate
	--	INTERCON(I) <= not INTERCON(I-1);
	--end generate NBIT;
	--INTERCON(0) <= not INTERCON(732);

	sig_UART_rst <= RST;
	
	-- LEDs for debugging
	--LED(0) <= sig_DIAG;
	--LED(0) <= sig_NOISE_ready;
	--LED(1) <= sig_NOISE_enable;
	--LED(2) <= sig_UART_ready;
	--LED(3) <= sig_UART_send;

end behaviour;
