


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display_top is
    Port ( clk : in STD_LOGIC;
           btnu : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (7 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           dp : out STD_LOGIC);
end display_top;

architecture Behavioral of display_top is

    component display_driver is
        port (
            clk : in STD_LOGIC;
            rst : in  std_logic;
            data  : in STD_LOGIC_VECTOR (7 downto 0);
            seg : out STD_LOGIC_VECTOR (6 downto 0);
            anode : out STD_LOGIC_VECTOR (1 downto 0)
        );
        -- TODO: Add component declaration of `display_driver`

    end component display_driver;

begin

    ------------------------------------------------------------------------
    -- 7-segment display driver
    ------------------------------------------------------------------------
    display_0 : display_driver
        port map (
           data => sw,
           clk => clk,
           rst => btnu,
           seg => seg,
           anode => an(1 downto 0)
        );

    -- Disable other digits and decimal points
    an(7 downto 2) <= b"11_1111";
    dp <= '1';

end Behavioral;
