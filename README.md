# fpga-filter-adc-dac

FPGA design: 12-bit ADC (MCP3201) -> IIR filter (DSP48) -> 12-bit DAC (MCP4821).

Master project, Design integrierter Schaltungen, FH Wiener Neustadt.

## Hardware

- Xilinx Spartan-3E (8 MHz clock)
- MCP3201 ADC, MCP4821 DAC (SPI)
- Sample rate: 100 kHz (prescaler 80)

## Filter

2nd-order IIR, direct form II, fixed-point on DSP48A1.

## Project layout

```
src/              Top-level Filter_ADC_DAC
rtl/filter/       IIR filter + DSP48 wrapper
lib/fhwn/         Course VHDL library (ADC/DAC drivers, prescaler, file I/O)
sim/              Testbench + input data
constraints/      Pin constraints (UCF)
matlab/           Input generation and result plotting
```

## Simulation

1. Open project in Xilinx ISE, add all `.vhd` under `src/`, `rtl/`, `lib/`.
2. Set top for sim: `Filter_ADC_DAC_tb`.
3. Run ISim. Output: `sim/data/output_file.dat`.
4. In MATLAB: `generate_input.m` then `analyze_output.m`.
