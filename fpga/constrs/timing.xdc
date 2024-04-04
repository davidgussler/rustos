# CLocks
create_clock -period 10.000 -name clk_i -waveform {0.000 5.000} [get_ports clk] 

# Async inputs
set_false_path -from [get_ports sw[*]]
set_false_path -from [get_ports btnC]
set_false_path -from [get_ports RsRx]

# Async outputs
set_false_path -to [get_ports led[*]]
set_false_path -to [get_ports RsTx]
