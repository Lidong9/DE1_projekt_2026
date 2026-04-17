library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Ultrasound_Measurer is
    Generic (
        CLK_FREQ : integer := 100_000_000 -- 100 MHz for Nexys A7
    );
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        enable   : in  STD_LOGIC; -- Switch to start/stop measurement
        echo     : in  STD_LOGIC;
        trigger  : out STD_LOGIC;
        distance : out STD_LOGIC_VECTOR(15 downto 0) -- Result DIRECTLY in millimeters
    );
end Ultrasound_Measurer;

architecture Behavioral of Ultrasound_Measurer is

    -- FSM States
    type state_type is (IDLE, SEND_TRIG, WAIT_ECHO_START, MEASURE_ECHO, SAVE_DATA, COOLDOWN);
    signal state : state_type := IDLE;

    -- Timing constants (for 100 MHz clock)
    constant TRIG_TIME : integer := 1000;      -- 10 us = 1000 clock cycles
    constant WAIT_TIME : integer := 1_000_000; -- Pause between measurements (approx 10ms)
    constant MM_TICKS  : integer := 580;       -- Clock cycles for 1 mm distance

    signal timer     : integer := 0;
    signal mm_timer  : integer := 0; -- Timer for counting millimeters
    
    signal dist_cnt  : unsigned(15 downto 0) := (others => '0');
    signal last_dist : std_logic_vector(15 downto 0) := (others => '0');

begin

    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            trigger <= '0';
            timer <= 0;
            mm_timer <= 0;
            dist_cnt <= (others => '0');
            last_dist <= (others => '0');
        elsif rising_edge(clk) then
            case state is

                -- Wait for measurement to be enabled
                when IDLE =>
                    trigger <= '0';
                    timer <= 0;
                    mm_timer <= 0;
                    if enable = '1' then
                        state <= SEND_TRIG;
                    end if;

                -- Generate 10us trigger pulse
                when SEND_TRIG =>
                    trigger <= '1';
                    if timer < TRIG_TIME then
                        timer <= timer + 1;
                    else
                        trigger <= '0';
                        timer <= 0;
                        state <= WAIT_ECHO_START;
                    end if;

                -- Wait for Echo pin to go HIGH
                when WAIT_ECHO_START =>
                    if echo = '1' then
                        dist_cnt <= (others => '0');
                        mm_timer <= 0; -- Reset millimeter timer
                        state <= MEASURE_ECHO;
                    end if;

                -- Measure Echo pulse width and count millimeters directly
                when MEASURE_ECHO =>
                    if echo = '1' then
                        if mm_timer < (MM_TICKS - 1) then
                            mm_timer <= mm_timer + 1;
                        else
                            mm_timer <= 0;
                            dist_cnt <= dist_cnt + 1; -- Increment distance by 1 mm
                        end if;
                    else
                        state <= SAVE_DATA;
                    end if;

                -- Save data to output register
                when SAVE_DATA =>
                    last_dist <= std_logic_vector(dist_cnt);
                    state <= COOLDOWN;
                    timer <= 0;

                -- Cooldown before next measurement to prevent room echo
                when COOLDOWN =>
                    if timer < WAIT_TIME then
                        timer <= timer + 1;
                    else
                        -- Auto-restart measurement if enable is still HIGH
                        if enable = '1' then
                            state <= SEND_TRIG;
                        else
                            state <= IDLE;
                        end if;
                    end if;

                when others => state <= IDLE;
            end case;
        end if;
    end process;

    distance <= last_dist;

end Behavioral;