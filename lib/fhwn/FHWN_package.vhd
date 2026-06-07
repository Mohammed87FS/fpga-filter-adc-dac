----------------------------------------------------------------------------------
-- Company:         FH Wiener Neustadt
-- Engineer:        HFK
--
-- Create Date:     2025
-- Module Name:     Package Library File
-- Project Name:    VHDL
--
-- Target Devices:  independent
-- Tool versions:   independent
--
-- Description:
-- Purpose: This package defines supplemental types, subtypes,
-- constants, and functions
--
-- Dependencies:    none
-- Revision 1.0
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

package FHWN_package is

  component RS_FF
    port (
      clk   : in  std_logic;
      R     : in  std_logic;
      S     : in  std_logic;
      Q     : out std_logic
    );
  end component;

  component D_FF
    port (
      clk   : in  std_logic;
      res   : in  std_logic;
      D     : in  std_logic;
      Q     : out std_logic
    );
  end component;

  component T_FF
    port (
      clk   : in  std_logic;
      res   : in  std_logic;
      D     : in  std_logic;
      Q     : out std_logic
    );
  end component;

  component pre_scaler
    generic (divider: integer:=1000);
    port (
      clk   : in  std_logic;
      res   : in  std_logic;
      CE    : in  std_logic;
      TC    : out std_logic
    );
  end component;

  component counter_4bit
    port (
      clk   : in  std_logic;
      res   : in  std_logic;
      CE    : in  std_logic;
      Q     : out std_logic_vector(3 downto 0);
      TC    : out std_logic
    );
  end component;

  component counter_modulo_N
    port (
      clk     : in  std_logic;
      res     : in  std_logic;
      CE      : in  std_logic;
      CNTmax  : in  std_logic_vector(3 downto 0);
      Q       : out std_logic_vector(3 downto 0);
      TC      : out std_logic
    );
  end component;

  component counter_N_bit
  generic (Data_Width : natural := 8);
    port (
      clk   : in  std_logic;
      res   : in  std_logic;
      CE    : in  std_logic;
      Q     : out std_logic_vector(Data_Width-1 downto 0);
      TC    : out std_logic
    );
  end component;

  component decoder_7_segment
    port (
      EN    : in  std_logic;
      d     : in  std_logic_vector(3 downto 0);
      y     : out std_logic_vector(6 downto 0)
    );
  end component;

  component MCP3201
    generic (
      Clk_Divisor: integer := 50
    );
    port (
      clk         : in  std_logic;
      res         : in  std_logic;
      Start_Conv  : in  std_logic;
      Data        : out std_logic_vector(11 downto 0);
      ADC_DV      : out std_logic;
      ADC_CS      : out std_logic;
      ADC_SCK     : out std_logic;
      ADC_SDO     : in  std_logic
    );
  end component;

  component MCP3201_Model
    generic (
      Vref  : real := 3.3
    );
    port (
      Vin   : in  real;
      CS    : in  std_logic;
      CLK   : in  std_logic;
      Dout  : out std_logic
    );
  end component;

  component MCP4821
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
  end component;

  component MCP4821_Model
    generic (
      Vdd: real := 3.3
    );
    port (
      CS    : in  std_logic;
      SCK   : in  std_logic;
      SDI   : in  std_logic;
      Vout  : out real
    );
  end component;

  component UART_Rx
    generic (Clk_Divisor: integer := 2604);
    port (
      clk       : in  std_logic;
      res       : in  std_logic;
      Rx        : in  std_logic;
      Data      : out std_logic_vector(7 downto 0);
      Rx_DV     : out std_logic
    );
  end component;

  component UART_Tx
    generic (Clk_Divisor: integer := 2604);
    port (
      clk       : in  std_logic;
      res       : in  std_logic;
      Data      : in  std_logic_vector(7 downto 0);
      Start_Tx  : in  std_logic;
      Tx_ready  : out std_logic;
      Tx        : out std_logic
    );
  end component;

  component Read_from_File
    generic (
      FileName  : string  := "src/input_file.dat";
      DataWidth : natural := 16;
      Format    : string  := "int"    -- int, uint implemented
    );
    port (
      clk       : in  std_logic;
      FileOpen  : in  std_logic;
      RD        : in  std_logic;
      EOF       : out std_logic;
      Data      : out std_logic_vector(DataWidth-1 downto 0)
    );
  end component;

  component Write_to_File
  generic (
      FileName  : string  := "src/output_file.dat";
      DataWidth : natural := 16;
      Format    : string  := "int"    -- int, uint implemented
    );
    port (
      clk       : in std_logic;
      FileOpen  : in std_logic;
      WR        : in std_logic;
      Data      : in std_logic_vector(DataWidth-1 downto 0)
    );
  end component;

  component Read_from_File_real
    generic (
      FileName  : string  := "src/input_file.dat"
    );
    port (
      clk       : in  std_logic;
      FileOpen  : in  std_logic;
      RD        : in  std_logic;
      EOF       : out std_logic;
      Data      : out real
    );
  end component;

  component Write_to_File_real
  generic (
      FileName  : string  := "src/output_file.dat"
    );
    port (
      clk       : in std_logic;
      FileOpen  : in std_logic;
      WR        : in std_logic;
      Data      : in real
    );
  end component;

end FHWN_package;


