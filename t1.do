
# # 
# open Modiesim
# CD to this do file folder
# run do this do file.
#

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

# set projp   D:/Jabil/work_tmp/i2c_simu
 # set projp   E:/tmp/i2c_simu_2022_1205
   set projp  F:/tmp/i2c_simu_2023_0111 
#vcom  -work work   $projp/debounce_2r.vhd

vlog -vlog01compat -work work $projp/src/i2c_v2.v 
vlog -vlog01compat -work work $projp/src/i2c1_reg_0X.v 
vlog -vlog01compat -work work $projp/src/i2c1_reg_1X.v 
vlog -vlog01compat -work work $projp/src/i2c_sim_top.v 


#vlog -vlog01compat -work work $projp/src/ .v 
#vlog -vlog01compat -work work $projp/src/ .v 

# vlog -vlog01compat -work work $projp/i2c_mstr_2.v
# vlog -vlog01compat -work work $projp/i2c_slave_tb2.v

 #do w2.do
#=============================================

