----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2026 08:50:44 AM
-- Design Name: 
-- Module Name: debounce_counter_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce_counter_top is
    Port ( clk : in STD_LOGIC;
           btnu : in STD_LOGIC;
           btnd : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (7 downto 0);
           led16_b : out STD_LOGIC);
end debounce_counter_top;

architecture Behavioral of debounce_counter_top is

    component debounce is
        Port ( clk       : in  STD_LOGIC;
               rst       : in  STD_LOGIC;
               btn_in    : in  STD_LOGIC;
               btn_state : out STD_LOGIC;
               btn_press : out STD_LOGIC);
    end component debounce;

    component counter is
    generic ( G_BITS : integer := 8 );
        Port ( clk       : in  STD_LOGIC;
               rst       : in  STD_LOGIC;
               en        : in  STD_LOGIC;
               cnt       : out std_logic_vector(G_BITS-1 downto 0)
             );
        -- TODO: Add component declaration of `counter`

    end component counter;

    -- Internal signal(s)
    signal sig_cnt_en : std_logic;

begin

    ------------------------------------------------------------------------
    -- Button debouncer
    ------------------------------------------------------------------------
    debounce_0 : debounce
        port map (
            clk       => clk,
            rst       => btnu,
            btn_in    => btnd,
            btn_press => sig_cnt_en,
            btn_state => led16_b
        );

    ------------------------------------------------------------------------
    -- Binary counter
    ------------------------------------------------------------------------
    counter_0 : counter
        generic map ( G_BITS => 8 )
        port map (
        clk       => clk,
        rst       => btnu,
        en        => sig_cnt_en,
        cnt       => led
            -- TODO: Add component instantiation of `counter`

        );

end Behavioral;
