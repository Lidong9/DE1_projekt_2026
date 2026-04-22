library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Ultrasound_Measurer is
    Generic (
        CLK_FREQ : integer := 100_000_000 
    );
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        enable   : in  STD_LOGIC; 
        echo     : in  STD_LOGIC;
        trigger  : out STD_LOGIC;
        distance : out STD_LOGIC_VECTOR(15 downto 0) 
    );
end Ultrasound_Measurer;

architecture Behavioral of Ultrasound_Measurer is

    -- FSM States
    type state_type is (IDLE, SEND_TRIG, WAIT_ECHO_START, MEASURE_ECHO, SAVE_DATA, COOLDOWN);
    signal state : state_type := IDLE;

    -- Timing constants
    constant TRIG_TIME : integer := 1000;      
    constant WAIT_TIME : integer := 1_000_000; 
    constant MM_TICKS  : integer := 580;       

    signal timer     : integer := 0;
    signal mm_timer  : integer := 0; 
    
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

          
                when IDLE =>
                    trigger <= '0';
                    timer <= 0;
                    mm_timer <= 0;
                    if enable = '1' then
                        state <= SEND_TRIG;
                    end if;

                
                when SEND_TRIG =>
                    trigger <= '1';
                    if timer < TRIG_TIME then
                        timer <= timer + 1;
                    else
                        trigger <= '0';
                        timer <= 0;
                        state <= WAIT_ECHO_START;
                    end if;

               
                when WAIT_ECHO_START =>
                    if echo = '1' then
                        dist_cnt <= (others => '0');
                        mm_timer <= 0; 
                        state <= MEASURE_ECHO;
                    end if;

        
                when MEASURE_ECHO =>
                    if echo = '1' then
                        if mm_timer < (MM_TICKS - 1) then
                            mm_timer <= mm_timer + 1;
                        else
                            mm_timer <= 0;
                            dist_cnt <= dist_cnt + 1; 
                        end if;
                    else
                        state <= SAVE_DATA;
                    end if;

              
                when SAVE_DATA =>
                    last_dist <= std_logic_vector(dist_cnt);
                    state <= COOLDOWN;
                    timer <= 0;

               
                when COOLDOWN =>
                    if timer < WAIT_TIME then
                        timer <= timer + 1;
                    else
                       
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
