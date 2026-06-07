----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:56:26 04/17/2026 
-- Design Name: 
-- Module Name:    Filter_ADC_DAC - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.all;
use work.FHWN_package.all;
use work.my_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Filter_ADC_DAC is
    Port (clk       : in  std_logic;
          res       : in  std_logic;
          EN        : in  std_logic;
          ADC_CS    : out std_logic;
          ADC_SCK   : out std_logic;
          ADC_SDO   : in  std_logic;
          DAC_CS    : out std_logic;
          DAC_SCK   : out std_logic;
          DAC_SDI   : out std_logic);
end Filter_ADC_DAC;

architecture Behavioral of Filter_ADC_DAC is
    signal sig_adc_to_filter : std_logic_vector(15 downto 0) := (others => '0');
    signal sig_filter_to_dac : std_logic_vector(15 downto 0) := (others => '0');
    signal sig_adc_raw       : std_logic_vector(11 downto 0);
    signal sig_dac_raw       : std_logic_vector(11 downto 0);
    signal sig_presc_clock   : std_logic;
begin
    
    sig_adc_to_filter <= not sig_adc_raw(11) & sig_adc_raw(10 downto 0) & "0000"; 
    sig_dac_raw <= not sig_filter_to_dac(15) & sig_filter_to_dac(14 downto 4);
    
   
    
    prescaler: pre_scaler
    generic map(Divider => 80)   --fclk = 8MHz -> fsig = 100kHz; Prescaler: 80
    port map(
        clk => clk,
        res => res,
        CE  => EN,
        TC  => sig_presc_clock
    );
    
    filt: filter
    port map(
        clk     => clk,
        res     => res,
        EN      => sig_presc_clock,
        DataIn  => sig_adc_to_filter,
        DataOut => sig_filter_to_dac
    );

    ADC: MCP3201 -- 12Bit ADC
    generic map(
        Clk_Divisor => 8
    )
    port map(
        clk         => clk,
        res         => res,
        Start_Conv  => sig_presc_clock,
        Data        => sig_adc_raw,
        ADC_DV      => open,
        ADC_CS      => ADC_CS,
        ADC_SCK     => ADC_SCK,
        ADC_SDO     => ADC_SDO
    );
    
    DAC: MCP4821 --12Bit DAC
    generic map(
        Clk_Divisor => 8
    )
    port map(
        clk        => clk,
        res        => res,
        Data       => sig_dac_raw,
        Start_Conv => sig_presc_clock,
        DAC_ready  => open,
        DAC_CS     => DAC_CS,
        DAC_SCK    => DAC_SCK,
        DAC_SDI    => DAC_SDI
    );


end Behavioral;

