transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/projects/p0/Adder-ParasJain {H:/projects/p0/Adder-ParasJain/AdderSubtractor.v}
vlog -vlog01compat -work work +incdir+H:/projects/p0/Adder-ParasJain {H:/projects/p0/Adder-ParasJain/FullAdder.v}
vlog -vlog01compat -work work +incdir+H:/projects/p0/Adder-ParasJain {H:/projects/p0/Adder-ParasJain/FourBitFullAdder.v}
vlog -vlog01compat -work work +incdir+H:/projects/p0/Adder-ParasJain {H:/projects/p0/Adder-ParasJain/hex27seg.v}

vlog -vlog01compat -work work +incdir+H:/projects/p0/Adder-ParasJain {H:/projects/p0/Adder-ParasJain/TestAdderSubtractor.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  TestAdderSubtractor

add wave *
view structure
view signals
run -all
