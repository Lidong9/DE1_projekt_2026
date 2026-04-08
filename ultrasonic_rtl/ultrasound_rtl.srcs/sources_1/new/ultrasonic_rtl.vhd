----------------------------------------------------------------------------------
-- Module Name: ultrasonic_rtl - Behavioral
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity ultrasonic_rtl is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           echo : in STD_LOGIC;
           trigger : out STD_LOGIC;
           dist_cm : out STD_LOGIC_VECTOR (11 downto 0));
end ultrasonic_rtl;

architecture Behavioral of ultrasonic_rtl is

-- FSM State definitions
type state_type is (IDLE, TRIG, WAIT_FOR_ECHO, MEASURE, CALCULATE);
signal state_reg : state_type := IDLE;


signal echo_sync_reg : std_logic_vector(1 downto 0) := "00";


signal timer_reg : unsigned(23 downto 0) := (others => '0');
signal dist_cnt_reg : unsigned(11 downto 0) := (others => '0');

begin
------------------------------------------------------------------------------
    -- Process: Edge Detection & Synchronization
    -- Purpose: Synchronize the asynchronous 'echo' input to the clock domain 
    --          and keep history to detect rising ("01") and falling ("10") edges.
------------------------------------------------------------------------------   
process(clk)
  begin
    if rising_edge(clk) then
        echo_sync_reg <= echo_sync_reg(0) & echo;
    end if;
end process;

process(clk)
  begin
    if rst = '1' then
        state_reg <= IDLE;
        trigger <= '0';
        timer_reg <= (others => '0');
        dist_cnt_reg <= (others => '0');
        dist_cm <= (others => '0');
                   
    elsif rising_edge(clk) then       
        case state_reg is

            when IDLE =>
                trigger <= '0';
                
                if timer_reg < 6_000_000 then
                   timer_reg <= timer_reg + 1;
                else
                   timer_reg <= (others => '0');
                   dist_cnt_reg <= (others => '0');
                   state_reg <= TRIG;
                end if;
                
             when TRIG =>
                 trigger <= '1';
                 if timer_reg < 1_000 then
                     timer_reg <= timer_reg + 1;
                 else
                     trigger <= '0';
                     timer_reg <= (others => '0');
                     state_reg <= WAIT_FOR_ECHO;
                 end if;
              when WAIT_FOR_ECHO =>
                  if echo_sync_reg = "01" then
                      state_reg <= MEASURE;
                  end if;
                  
              when MEASURE =>
                  if timer_reg < 5_800 then
                      timer_reg <= timer_reg + 1;                  
                  else
                      timer_reg <= (others => '0');
                      dist_cnt_reg <= dist_cnt_reg + 1;
                  end if;
                  
                  if echo_sync_reg = "10" then
                      state_reg <= CALCULATE;
                  end if;
                     
              when CALCULATE => 
                  dist_cm <= std_logic_vector(dist_cnt_reg);
                  state_reg <= IDLE;


              when others =>
                  state_reg <= IDLE;
              end case;
          end if;
          
      end process;
end Behavioral;