library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

------ SMA Receiver ------------------------
-- Kind of hard to make this when I have the XM105 once every week during the summer --
-- Another pain when I only have an osciliscope available if I break in the physics lab (rose emoji) --
-- This piece of code shows if any input forom the sma connectors are registered --
-- This code is weird however without any XM105, the LEDs will turn on (there was one instance where one was off and another was on but I digress) --
--  This may be based off of a floating input being registered when using the XM105 and taking it off --
-- I definitely won't have access to the XM105 unless I purchase it on my own so this project is a cold case -- 
--------------------------------------------

entity sma_receiver is
    Port (
        -- Clock and Reset
        clk_100mhz     : in  STD_LOGIC;  -- Bank 13, 3.3V
        reset          : in  STD_LOGIC;  -- Bank 34, 1.8V
        
        -- SMA Inputs from XM105
        sma_input1     : in  STD_LOGIC;  -- FMC_CLK1_P (Bank 35, 1.8V)
        sma_input2     : in  STD_LOGIC;  -- FMC_CLK1_N (Bank 35, 1.8V)
        
        -- LED outputs
        led0           : out STD_LOGIC;  -- Bank 33, 3.3V
        led1           : out STD_LOGIC   -- Bank 33, 3.3V
    );
end sma_receiver;

architecture Behavioral of sma_receiver is
    signal sma1_sync_reg : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal sma2_sync_reg : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal sma1_debounced : STD_LOGIC := '0';
    signal sma2_debounced : STD_LOGIC := '0';
    signal debounce_counter1 : unsigned(19 downto 0) := (others => '0');
    signal debounce_counter2 : unsigned(19 downto 0) := (others => '0');
    constant DEBOUNCE_LIMIT : unsigned(19 downto 0) := to_unsigned(1000000, 20);

begin

    sync_process : process(clk_100mhz)
    begin
        if rising_edge(clk_100mhz) then
            if reset = '1' then
                sma1_sync_reg <= (others => '0');
                sma2_sync_reg <= (others => '0');
                sma1_debounced <= '0';
                sma2_debounced <= '0';
                debounce_counter1 <= (others => '0');
                debounce_counter2 <= (others => '0');
            else
                -- Synchronize SMA inputs
                sma1_sync_reg <= sma1_sync_reg(1 downto 0) & sma_input1;
                sma2_sync_reg <= sma2_sync_reg(1 downto 0) & sma_input2;
                
                -- Debounce logic
                if sma1_sync_reg(2) /= sma1_debounced then
                    if debounce_counter1 < DEBOUNCE_LIMIT then
                        debounce_counter1 <= debounce_counter1 + 1;
                    else
                        sma1_debounced <= sma1_sync_reg(2);
                        debounce_counter1 <= (others => '0');
                    end if;
                else
                    debounce_counter1 <= (others => '0');
                end if;
                
                if sma2_sync_reg(2) /= sma2_debounced then
                    if debounce_counter2 < DEBOUNCE_LIMIT then
                        debounce_counter2 <= debounce_counter2 + 1;
                    else
                        sma2_debounced <= sma2_sync_reg(2);
                        debounce_counter2 <= (others => '0');
                    end if;
                else
                    debounce_counter2 <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    led0 <= sma1_debounced;
    led1 <= sma2_debounced;

end Behavioral;
