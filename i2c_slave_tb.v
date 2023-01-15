//-------------------------------------------------------------------------
//  >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
//-------------------------------------------------------------------------
//  Copyright (c) 2005 - 2010 by Lattice Semiconductor Corporation      
// 
//-------------------------------------------------------------------------
// Permission:
//
//   Lattice Semiconductor grants permission to use this code for use
//   in synthesis for any Lattice programmable logic product.  Other
//   use of this code, including the selling or duplication of any
//   portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL or Verilog source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Lattice Semiconductor provides no warranty
//   regarding the use or functionality of this code.
//-------------------------------------------------------------------------
// 
//-------------------------------------------------------------------------
// Name:  i2c_per_tb.v   
// 
// Description: This is the top-level test bench for the i2c peripheral 
//-------------------------------------------------------------------------
// Code Revision History :
// 2022/12/4 
// 
//  i2c_sim_top read data not correct

`timescale 1 ns /  100 ps
//`include "i2c_mstr.v"

module i2c_slave_tb;

//---------------------------------------------------------------------
// interconnect wires

reg   rst;
 //wire   start;

reg ready;
 wire scl ;
 wire sda ;

reg scl_oe ;
reg sclk;

pullup (sda) ;
pullup (scl) ;
//---
 
 
//reg [addr_width-1:0]  byte_cnt;
// address pointer for both read / write operations
//reg [addr_width-1:0]  i2c_addr;
//--------------------------------------------------------------------
// initiate memory
//reg [data_width-1:0] mem [addr_width-1:0]; // initiate memory
//reg [addr_width-1:0] mem_adr;

//---------------------------------------------------------------------
// instantiated modules

i2c_sim_top  i2c_s_u(  
	.CPLD_25M_CLK  (sclk) ,
	.rst (rst) ,
	.i2c_scl (scl) ,
	.i2c_sda (sda) 
) ;
// assign sda = !sda_oe_n ? 1'b0 : 1'bz;
//assign scl = scl_oe ? 1'b0 : 1'bz;

i2c_mstr4 MST(   .XRESET(), 
                .scl(scl), 
                .sda(sda),
                .scl_oe(scl_oe),
                .ready(ready)
			
                );
		
//reg 	psu1_prent_n ;
//reg 	psu2_prent_n ;		
		
initial begin
	#0 ready = 1'b1;
	scl_oe = 1 ;
	//  tx_ack = 1 ;
	   rst = 1 ;
	   sclk = 0'b0;
	   //$readmemh("../../../testbench/verilog/i2c.mem", mem);
	//   $readmemh("i2c.mem", mem);
	#150  rst = 0 ;
	#2800 
	#3000
	# 14000 ;
	
        end
//----------------------------------------
// follwong code for gpio data
always 
	#3 sclk = ~sclk;   // under 10 for scl = 50 
//==================================================

	
endmodule
