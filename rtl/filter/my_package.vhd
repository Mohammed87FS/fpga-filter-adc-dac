----------------------------------------------------------------------------------
-- Company:         FH Wiener Neustadt
-- Engineer:        HFK
--
-- Create Date:     2020
-- Module Name:     Package File Template
-- Project Name:    VHDL
--
-- Target Devices:  independent
-- Tool versions:   independent
--
-- Description:
-- Purpose: This package defines supplemental types, subtypes,
-- constants, and functions
--
-- Dependencies: None
-- Revision 1.0
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

package my_package is
  
    component filter
    Port ( 
        clk          : in  STD_LOGIC;
        res          : in  STD_LOGIC;
        EN           : in  STD_LOGIC;
        DataIn       : in  STD_LOGIC_VECTOR (15 downto 0);
        DataOut      : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
    component DSP48A1_MAD 
    Port ( 
        clk  : in  std_logic;
        res  : in  std_logic;
        EN   : in  std_logic;
        A    : in  STD_LOGIC_VECTOR (17 downto 0);
        B    : in  STD_LOGIC_VECTOR (17 downto 0);
        C    : in  STD_LOGIC_VECTOR (47 downto 0);
        P    : out STD_LOGIC_VECTOR (47 downto 0));
    end component;
  
  


end my_package;


