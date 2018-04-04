entity main is
	generic (m : natural :=128);
	port (
		CLK		: out std_logic;
		--tx_data		: out std_logic_vector(8 downto 0);
		--ready		: in std_logic;
		--tx_ready	: in std_logic;
		--r		: in std_logic_vector(m downto 0)
	);
end main;

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

   	component NOISE is
	    	generic (N: integer:=733);
		port (
			NOISE_clk : in std_logic;
			NOISE_enRO : in std_logic;
			NOISE_out : out std_logic);
		);

	signal sig_send : std_logic;
	signal sig_rst : std_logic;
	signal sig_enable : std_logic;
	signal sig_noise : std_logic;

begin
	process (clk)
	variable state: std_logic := '0'; -- 0: sample, 1: send;
	begin
		-- instantiate UART
            	usart: uart_tx generic map( 100E6, 9600) port map (clk, sig_rst, sig_send, x_data, rdy => tx_ready);

		-- instantiate noise generation
	    	nois1: noise generic map(733) port map (CLK,sig_enable,sig_noise);

           	if (clk'event and clk='1') then
                	if(state='0') then
				-- 0: sample,
                    		sig_enable <= '1';
                
                    		if(ready = '1') then
                    	    		enable <= '0';
                    	    		state := 1;
                   		end if;
               		end if;
                
                	if(state='1') then
			--  1: send
                   		if(rdy='1') then
                       			data <= r(8*(i)-1 downto 8*(i)-8);
					i := i+1;
                    		end if;
                    
                    		i(i = m/8) then
                        	state := 0;
                    	end if;
                end if;
            end if;
	end process;
end behaviour;
