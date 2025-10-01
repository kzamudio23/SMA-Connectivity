set_property PACKAGE_PIN Y9 [get_ports clk_100mhz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100mhz]

create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk_100mhz]


set_property PACKAGE_PIN P16 [get_ports reset]
set_property IOSTANDARD LVCMOS18 [get_ports reset]

set_property PACKAGE_PIN T22 [get_ports {led0}]
set_property IOSTANDARD LVCMOS33 [get_ports {led0}]

set_property PACKAGE_PIN T21 [get_ports {led1}]
set_property IOSTANDARD LVCMOS33 [get_ports {led1}]


# SMA Input 1 - From XM105 SMA J9 (CLK1_M2C_P)
# FMC_CLK1_P is on Bank 35, Pin D18
set_property PACKAGE_PIN D18 [get_ports {sma_input1}]
set_property IOSTANDARD LVCMOS18 [get_ports {sma_input1}]

# SMA Input 2 - From XM105 SMA J10 (CLK1_M2C_N)  
# FMC_CLK1_N is on Bank 35, Pin C19
set_property PACKAGE_PIN C19 [get_ports {sma_input2}]
set_property IOSTANDARD LVCMOS18 [get_ports {sma_input2}]

set_input_delay -clock [get_clocks sys_clk_pin] -min -add_delay 0.000 [get_ports sma_input1]
set_input_delay -clock [get_clocks sys_clk_pin] -max -add_delay 2.000 [get_ports sma_input1]
set_input_delay -clock [get_clocks sys_clk_pin] -min -add_delay 0.000 [get_ports sma_input2]
set_input_delay -clock [get_clocks sys_clk_pin] -max -add_delay 2.000 [get_ports sma_input2]

set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay 0.000 [get_ports {led0 led1}]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 2.000 [get_ports {led0 led1}]
