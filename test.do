vcom -2008 licznik144679.vhd devices.vhd gates.vhd
vsim work.licznik_144679
view wave
add wave CK
add wave RST
add wave CE
add wave Q
add wave Tc
add wave cntr_0
add wave cntr_1
add wave cntr_2
add wave cntr_3
add wave cntr_4
add wave cntr_5
force CK 1 0, 0 {50 ns} -r 100ns
force RST 1 0, 0 100ns
force CE 1
run 14467900ns
