--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:08:09 04/20/2026
-- Design Name:   
-- Module Name:   /media/sf_XILINX/10_Filter_ADC_DAC/Filter_ADC_DAC/src/Filter_ADC_DAC_tb.vhd
-- Project Name:  Filter_ADC_DAC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Filter_ADC_DAC
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.FHWN_package.all;
use work.my_package.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Filter_ADC_DAC_tb IS
END Filter_ADC_DAC_tb;
 
ARCHITECTURE behavior OF Filter_ADC_DAC_tb IS 
    constant ReadFileName   : string    := "sim/data/input_file.dat";
    constant WriteFileName  : string    := "sim/data/output_file.dat";
    constant Format         : string    := "uint";
    constant Vref           : real      := 3.3;
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Filter_ADC_DAC
    PORT(
        clk         : IN  std_logic;
        res         : IN  std_logic;
        EN          : IN  std_logic;
        ADC_CS      : OUT std_logic;
        ADC_SCK     : OUT std_logic;
        ADC_SDO     : IN  std_logic;
        DAC_CS      : OUT std_logic;
        DAC_SCK     : OUT std_logic;
        DAC_SDI     : OUT std_logic
    );
    END COMPONENT;
    

    --Inputs
    signal clk          : std_logic := '0';
    signal res          : std_logic := '0';
    signal EN           : std_logic := '0';
    signal FileOpen     : std_logic := '0';
    signal EOF          : std_logic := '0';
    signal ADC_SDO      : std_logic := '0';
    signal file_input   : real;
    signal adc_model_in : real;
    --Outputs
    signal dac_model_out_real  : real;
    signal ADC_CS              : std_logic;
    signal ADC_SCK             : std_logic;
    signal DAC_CS              : std_logic;
    signal DAC_SCK             : std_logic;
    signal DAC_SDI             : std_logic;
    signal sig_presc_clock     : std_logic;

    -- Clock period definitions
    constant clk_period : time := 125 ns;
 
BEGIN

    prescaler: pre_scaler
    generic map(Divider => 80)   --fclk = 8MHz -> fsig = 100kHz; Prescaler: 80
    port map(
        clk => clk,
        res => res,
        CE  => EN,
        TC  => sig_presc_clock
    );
    
    -- Instantiate the Unit Under Test (UUT)
    -- Read from File
    U_Read: Read_from_File_real
    generic map(
        FileName  => ReadFileName
    )
    port map(
        clk      => clk,
        FileOpen => FileOpen,
        RD       => sig_presc_clock,
        EOF      => EOF,
        Data     => file_input
    );
    
    u_adc: MCP3201_Model
    generic map(
        Vref  => Vref
    )
    port map(
        Vin   => file_input,-- in real adc_model_in
        CS    => ADC_CS,-- in
        CLK   => ADC_SCK,-- in
        Dout  => ADC_SDO-- out
    );
   
    uut: Filter_ADC_DAC 
    port map(
        clk     => clk,
        res     => res,
        EN      => EN,
        ADC_CS  => ADC_CS,
        ADC_SCK => ADC_SCK,
        ADC_SDO => ADC_SDO,
        DAC_CS  => DAC_CS,
        DAC_SCK => DAC_SCK,
        DAC_SDI => DAC_SDI
    );
    
    u_dac: MCP4821_Model
    generic map(
        Vdd     => Vref
    )
    port map(
        CS      =>  DAC_CS, -- in
        SCK     =>  DAC_SCK, -- in
        SDI     =>  DAC_SDI,-- in
        Vout    =>  dac_model_out_real-- out real
    );
  
  
    u_write: Write_to_File_real
    generic map(
        FileName  => WriteFileName
    )
    port map(
        clk         =>  clk, -- in
        FileOpen    =>  FileOpen, -- in
        WR          =>  sig_presc_clock, -- in
        Data        =>  dac_model_out_real-- in real
    );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
	 	wait for clk_period/2;
	 	clk <= '1';
	 	wait for clk_period/2;
    end process;
 

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset aktiv
        res <= '1';
        EN <= '0';
        FileOpen <= '0';
        wait for clk_period * 5;
        
        -- Reset freigeben
        res <= '0';
        -- Datei öffnen
        FileOpen <= '1';
        wait for clk_period * 2;
        
        -- Filter/ADC/DAC aktivieren
        EN <= '1';
        wait for clk_period * 3;
        
        
        -- Warten bis Datei fertig gelesen 
        wait until EOF = '1';
        FileOpen <= '0';
        
        -- Stop
        EN <= '0';
        
        wait;
    end process;

END;
