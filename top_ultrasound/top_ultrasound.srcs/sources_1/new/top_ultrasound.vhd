library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_level is
    Port (
        clk       : in  STD_LOGIC;
        btn_rst   : in  STD_LOGIC;
        sw_enable : in  STD_LOGIC;
        echo      : in  STD_LOGIC;
        
        trigger   : out STD_LOGIC;
        an        : out STD_LOGIC_VECTOR(7 downto 0);
        seg       : out STD_LOGIC_VECTOR(6 downto 0)
    );
end top_level;

architecture Structural of top_level is

    -- ==========================================
    -- 1. Deklarace komponent
    -- ==========================================
    
    -- Tvoje přesná komponenta debounce
    component debounce is
        Port ( 
            clk       : in STD_LOGIC;
            rst       : in STD_LOGIC;
            btn_in    : in STD_LOGIC;
            btn_state : out STD_LOGIC;
            btn_press : out STD_LOGIC
        );
    end component;

    -- Tvoje komponenta Ultrasound_Measurer
    component Ultrasound_Measurer is
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
    end component;

    -- Tvoje komponenta display_driver
    component display_driver is
        Port ( 
            clk   : in  STD_LOGIC;
            rst   : in  STD_LOGIC;
            data  : in  STD_LOGIC_VECTOR (15 downto 0);
            seg   : out STD_LOGIC_VECTOR (6 downto 0);
            anode : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- ==========================================
    -- 2. Deklarace vnitřních signálů
    -- ==========================================
    signal sig_rst_clean  : STD_LOGIC;
    signal sig_distance   : STD_LOGIC_VECTOR(15 downto 0);
    signal sig_anode_4bit : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- ==========================================
    -- 3. Instancování komponent
    -- ==========================================

    -- Ošetření zákmů hlavního tlačítka Reset
    debouncer_inst : debounce
        port map (
            clk       => clk,
            rst       => '0',           
            btn_in    => btn_rst,       
            btn_state => sig_rst_clean, 
            btn_press => open           
        );

    -- Měřič ultrazvuku
    ultrasound_inst : Ultrasound_Measurer
        generic map (
            CLK_FREQ => 100_000_000 
        )
        port map (
            clk      => clk,
            reset    => sig_rst_clean,
            enable   => sw_enable, 
            echo     => echo,
            trigger  => trigger,
            distance => sig_distance
        );

    -- Ovladač sedmisegmentového displeje
    display_driver_inst : display_driver
        port map (
            clk   => clk,
            rst   => sig_rst_clean,
            data  => sig_distance,
            seg   => seg,
            anode => sig_anode_4bit 
        );

    
    an(3 downto 0) <= sig_anode_4bit;
    
   
    an(7 downto 4) <= "1111";

end Structural;