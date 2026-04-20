library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_driver is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (15 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           anode : out STD_LOGIC_VECTOR (3 downto 0));
end display_driver;

architecture Behavioral of display_driver is

    -- Component declaration for clock enable
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;
 
    -- Component declaration for binary counter
    component counter is
        generic ( G_BITS : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component counter;
 
    component bin2seg is

        -- TODO: Add component declaration of `bin2seg`
        Port ( bin : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
    end component bin2seg;
 
    -- Internal signals
    signal sig_en : std_logic;
    -- TODO: Add other needed signals
    signal sig_digit : std_logic_vector (1 downto 0);
    signal sig_bin : std_logic_vector (3 downto 0);
begin

    ------------------------------------------------------------------------
    -- Clock enable generator for refresh timing
    ------------------------------------------------------------------------
    clock_0 : clk_en
        generic map ( G_MAX => 8 )  -- Adjust for flicker-free multiplexing
        port map (                  -- For simulation: 8
            clk => clk,             -- For implementation: 80_000_000
            rst => rst,
            ce  => sig_en
        );

    counter_0 : counter
        generic map ( G_BITS => 2 )
        port map (
            clk => clk,
            rst => rst,
            en => sig_en,
            cnt => sig_digit
        );

    ------------------------------------------------------------------------
    -- Digit select
    ------------------------------------------------------------------------
p_digit_select : process(sig_digit, data)
begin
    sig_bin <= (others => '0');  -- 👈 důležité!

    case sig_digit is
        when "00" => sig_bin <= data(3 downto 0);
        when "01" => sig_bin <= data(7 downto 4);
        when "10" => sig_bin <= data(11 downto 8);
        when "11" => sig_bin <= data(15 downto 12);
        when others => null;
    end case;
end process;
    ------------------------------------------------------------------------
    -- 7-segment decoder
    ------------------------------------------------------------------------
    decoder_0 : bin2seg
        port map (
            bin => sig_bin,
            seg => seg
            -- TODO: Add component instantiation of `bin2seg`

        );

    ------------------------------------------------------------------------
    -- Anode select process
    ------------------------------------------------------------------------

p_anode_select : process(sig_digit)
begin
    anode <= "1111";

    case sig_digit is
        when "00" => anode <= "1110";
        when "01" => anode <= "1101";
        when "10" => anode <= "1011";
        when "11" => anode <= "0111";
        when others => null;
    end case;
end process;

end Behavioral;
