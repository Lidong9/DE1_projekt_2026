library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_ultrasound_tb is
-- Entita testbenche je vždy prázdná
end top_ultrasound_tb;

architecture Behavioral of top_ultrasound_tb is

    -- 1. Deklarace testovaného Top modulu
    component top_level
    Port (
        clk       : in  STD_LOGIC;
        btn_rst   : in  STD_LOGIC;
        sw_enable : in  STD_LOGIC;
        echo      : in  STD_LOGIC;
        
        trigger   : out STD_LOGIC;
        an        : out STD_LOGIC_VECTOR(7 downto 0);
        seg       : out STD_LOGIC_VECTOR(6 downto 0)
    );
    end component;

    -- 2. Vnitřní signály pro propojení
    signal clk       : std_logic := '0';
    signal btn_rst   : std_logic := '0';
    signal sw_enable : std_logic := '0';
    signal echo      : std_logic := '0';
    
    signal trigger   : std_logic;
    signal an        : std_logic_vector(7 downto 0);
    signal seg       : std_logic_vector(6 downto 0);

    -- 100 MHz hodiny = perioda 10 ns
    constant clk_period : time := 10 ns;

begin

    -- 3. Instancování testovaného modulu (UUT)
    -- Ujisti se, že název "top_level" přesně odpovídá názvu tvé hlavní entity
    uut: top_level 
    PORT MAP (
        clk       => clk,
        btn_rst   => btn_rst,
        sw_enable => sw_enable,
        echo      => echo,
        trigger   => trigger,
        an        => an,
        seg       => seg
    );

    -- 4. Proces pro neustálé generování hodin
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- 5. Hlavní stimulační proces (simulace hardwaru a fyziky)
    stim_proc: process
    begin
        -- ====================================================
        -- FÁZE 1: Reset (dlouhý kvůli debounceru)
        -- ====================================================
        btn_rst <= '1';
        sw_enable <= '0';
        echo <= '0';
        wait for 20 ms; 
        
        btn_rst <= '0';
        wait for 5 ms; 

        -- ====================================================
        -- FÁZE 2: Zapnutí měření přepínačem
        -- ====================================================
        sw_enable <= '1';

        -- ====================================================
        -- FÁZE 3: Simulace senzoru (čekáme na trigger, pošleme echo)
        -- ====================================================
        wait until trigger = '1';
        wait until trigger = '0'; 

        -- Chvíli počkáme, než zvuk doletí k překážce
        wait for 500 us;

        -- Pošleme zpět Echo. 
        -- Ve tvém kódu je 1 mm = 580 tiků (5.8 us).
        -- Simulujeme vzdálenost 50 mm (50 * 5.8 us = 290 us).
        echo <= '1';
        wait for 290 us; 
        echo <= '0';

        -- ====================================================
        -- FÁZE 4: Zobrazení na displeji
        -- ====================================================
        -- Necháme to běžet dalších 20 ms, ať vidíš krásně blikat anody
        wait for 20 ms;

        -- Natvrdo zastavíme simulaci
        assert false report "=== TEST DOKONCEN ===" severity failure;
        
    end process;

end Behavioral;