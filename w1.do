  
 # add wave 	 -radix hexadecimal	/uut/tx_u1/sgpio_clk

 # add wave 	-color Yellow 	/uut/tx_u1/sgpio_sload
 
 # set projp  D:/project/Martinsville/MV_CPLD_tmp_proj/MV_Main_CPLD_EVT_simu/source
#---------------------
vlog -vlog01compat -work work $projp/i2c_slave_tb.v

vlog -vlog01compat -work work $projp/i2c_mstr_v4_r2.v

#vsim +altera -do spi_s1_run_msim_rtl_verilog.do -l msim_transcript -gui work.spi_slave_r_vlg_tst
 vsim  -L rtl_work -L work -voptargs="+acc" i2c_slave_tb
 
  add wave -radix hexadecimal /i2c_slave_tb/*
 add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/sda_oe_out
   add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/r08_Reserved_03
   add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/r08_Reserved_04
   add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/r08_Reserved_08
   add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/r08_Reserved_09
   add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/r08_Reserved_0a
   add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/r08_Reserved_0b
   add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/r08_Reserved_0c
   add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/r08_Reserved_0d  
   add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/r08_Reserved_0e
   add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/r08_Reserved_0f    
   add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/rd_wr1
   add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/port_cs1
    add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/offset_sel1_dly2
	 add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/din1
	 add wave -radix hexadecimal /i2c_slave_tb/i2c_s_u/I2C1_Port0X_ins/dout1	 
  
#   add wave  -divider  master_in_sig
#	add wave -radix hexadecimal  /i2c_slave_tb2/u1/mem_do	
#	add wave -radix hexadecimal  /i2c_slave_tb2/u1/parity_check_data_t
#  add wave -radix hexadecimal {/i2c_slave_tb2/reg_g[1] }
# add wave -radix hexadecimal {/i2c_slave_tb2/reg_g[2] }
# add wave -radix hexadecimal  {/i2c_slave_tb2/reg_g[3] } 
 
 # add wave -radix hexadecimal /i2c_master_tb/u_master/bit_controller/*
# add wave -radix hexadecimal /i2c_master_tb/
# add wave -radix hexadecimal /i2c_master_tb/ 

  run 50 us
 
 #=============================================