----------------------------------------------------------------------------------
-- Company:         FH Wiener Neustadt
-- Engineer:        HFK
--
-- Create Date:     2020
-- Design Name:
-- Module Name:     MCP4821
-- Project Name:
-- Target Devices:
-- Tool versions:
--
-- Description:
-- SPI Module for DAC MCP4821, 12 Data Bits, 4 Control Bits
-- Transmitter with own prescaler.
--
-- SPI Clock Frequency settable via Generic Constant for Prescaler.
--   Clk_Divisor = fclk / fclk_SPI;
-- fclk = 50MHz, fclk_SPI = 1MHz, Clk_Divisor = 50
--
-- Control Bits:
-- bit15 bit14 bit13 bit12 of SPI Data
-- bit 15
--  0 = Write to DAC register
--  1 = Ignore this command
-- bit 14     Dont Care
-- bit 13 GA: Output Gain Selection bit
--  1 = 1x (VOUT = VREF * D/4096)
--  0 = 2x (VOUT = 2 * VREF * D/4096),  where internal VREF = 2.048V.
-- bit 12 SHDN: Output Shutdown Control bit
--  1 = Active mode operation. VOUT is available.
--  0 = Shutdown the device. Analog output is not available. Vout pin is connected to 500k typical)
--
-- Dependencies:    none
--
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.00 - MCP4821 tested
-- Revision 1.10 - MCP4821 generic gain changed to 1x
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MCP4821 is
  generic (
    Clk_Divisor: integer := 50;
    Control: std_logic_vector(3 downto 0) := "0011"
  );
  port (
    clk         : in  std_logic;
    res         : in  std_logic;
    Data        : in  std_logic_vector(11 downto 0);
    Start_Conv  : in  std_logic;
    DAC_ready   : out std_logic;
    DAC_CS      : out std_logic;
    DAC_SCK     : out std_logic;
    DAC_SDI     : out std_logic
  );
end MCP4821;

architecture Behavioral of MCP4821 is
  type   state_type     is (idle, work);
  signal state          : state_type;
  signal shift_reg      : std_logic_vector(15 downto 0) := (others =>'0');
  signal bit_cnt        : integer range 0 to 15;
  signal pre_scaler_cnt : integer range 0 to 255;
  signal pre_scaler_TC  : std_logic := '0';
  signal pre_scaled_clk : std_logic := '0';


begin
  DAC_SCK <= pre_scaled_clk;
  DAC_SDI <= shift_reg(15);


  MCP4821_SPI: process(clk)
  begin
    if rising_edge(clk) then
      if res = '1' then
        state     <= idle;
        DAC_CS    <= '1';
        DAC_ready <= '1';
      else
        case state is

          when idle =>
            if Start_Conv = '1' then
              shift_reg <= Control & Data;
              state     <= work;
              bit_cnt   <= 0;
              DAC_ready <= '0';
              DAC_CS    <= '0';
            end if;

          when work =>
            if (pre_scaler_TC = '1') and (pre_scaled_clk = '1')then
              shift_reg <= shift_reg(14 downto 0) & '0';
              if bit_cnt = 15 then
                state     <= idle;
                DAC_CS    <= '1';
                DAC_ready <= '1';
              else
                bit_cnt   <= bit_cnt + 1;
              end if;
            end if;

          when others =>
             state <= idle;

        end case; -- state
      end if; -- res
    end if; -- rising_edge
  end process; -- SPI


  toggle_clk : process(clk)
  begin
    if rising_edge(clk) then
      if state = idle then
        pre_scaled_clk <= '0';
      else
        if pre_scaler_TC = '1' then
          pre_scaled_clk <= not pre_scaled_clk;
        end if;
      end if;
    end if;
  end process;


  pre_scaler: process(clk)
  begin
    if rising_edge(clk) then
      if state = idle then
        pre_scaler_cnt <= Clk_Divisor / 2;
        pre_scaler_TC  <= '0';
      else
        if pre_scaler_cnt = 1 then
          pre_scaler_cnt <= Clk_Divisor / 2;
          pre_scaler_TC  <= '1';
        else
          pre_scaler_cnt <= pre_scaler_cnt - 1;
          pre_scaler_TC  <= '0';
        end if;
      end if;
    end if;
  end process;


end Behavioral;


