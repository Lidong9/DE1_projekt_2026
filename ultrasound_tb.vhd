library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Ultrasound_Measurer is
-- Empty testbench entity
end tb_Ultrasound_Measurer;

architecture behavior of tb_Ultrasound_Measurer is

    -- Signals for connecting to UUT (Unit Under Test)
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal enable   : std_logic := '0';
    signal echo     : std_logic := '0';
    
    signal trigger  : std_logic;
    signal distance : std_logic_vector(15 downto 0);

    -- Clock period for 100 MHz
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.Ultrasound_Measurer
        generic map (
            CLK_FREQ => 100_000_000
        )
        port map (
            clk      => clk,
            reset    => reset,
            enable   => enable,
            echo     => echo,
            trigger  => trigger,
            distance => distance
        );

    -- Clock generation process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Main stimulus process
    stim_proc: process
    begin
        -- 1. System Reset
        reset <= '1';
        enable <= '0';
        echo <= '0';
        wait for 100 ns;
        
        reset <= '0';
        wait for 100 ns;

        -- 2. Enable measurement
        enable <= '1';

        -- ========================================================
        -- FIRST MEASUREMENT: Simulate object at 150 mm (15 cm)
        -- ========================================================
        wait until trigger = '1'; 
        wait until trigger = '0'; -- Wait for the 10us trigger to finish

        wait for 50 us; -- Sound travels through the air...
        
        -- Echo pin goes HIGH
        echo <= '1';    
        wait for 870 us; -- 870 us corresponds exactly to 150 mm (87000 cycles / 580)
        echo <= '0';

        -- EXPECTED RESULT: 'distance' should show 150 (0x0096)

        -- ========================================================
        -- SECOND MEASUREMENT: Simulate object at 45 mm (4.5 cm)
        -- ========================================================
        -- FSM has a 10ms cooldown. The testbench waits for the next trigger automatically.
        wait until trigger = '1';
        wait until trigger = '0';

        wait for 20 us; -- Different sound travel delay
        
        -- Echo pin goes HIGH
        echo <= '1';
        wait for 261 us; -- 261 us corresponds exactly to 45 mm (26100 cycles / 580)
        echo <= '0';

        -- EXPECTED RESULT: 'distance' should show 45 (0x002D)

        -- 3. End simulation
        wait for 10 ms;
        enable <= '0';
        wait;
    end process;

end behavior;