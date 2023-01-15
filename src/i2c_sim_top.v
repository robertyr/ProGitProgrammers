//
// 2019/8/6
// i2c_sim_top.v
//
//  2022/12/4
// 
// compile ok


module i2c_sim_top (  
	input CPLD_25M_CLK ,
	input  rst ,
	input  i2c_scl ,
	inout  i2c_sda 
 
) ;

  wire      i2c_scl_in ;
  wire      i2c_sda_in ;  
  wire      rd_wr_1;
  wire      [15:0]port_cs_1;
  wire      [15:0]offset_sel_1;
  wire      [7:0]din_0_1;
  wire      [7:0]din_1_1;  
  wire      [7:0]i2c_dout_1;
  wire    sda_oe_out ;
  wire [6:0] i2c_address_1 ;
  
  assign i2c_scl_in = i2c_scl ;
  assign i2c_sda_in = i2c_sda ;  
  
assign i2c_sda = sda_oe_out ? 1'b0 :  1'bz ;

assign i2c_address_1 = 7'b1100_000 ; 

 i2c_v2 #(
    .case_i2c_idle(6'b01),    .case_i2c_add(6'b010),    .case_i2c_loc(6'b0100),    .case_i2c_data1(6'b01000),
    .case_i2c_data2(6'b010000),
    .case_i2c_end(6'b100000))
 //   .timer_1s(32'b01011111010111100001000000),
 //   .timer_5s(32'b0111011100110101100101000000))
    i2c_ins_1(
      .sysclk(CPLD_25M_CLK),
      .i2c_reset_n(~rst),
      .scl(i2c_scl_in),
      .sda(i2c_sda_in),
	//  .scl( 0 ),
    //  .sda(ttmp ),
      .port_csd1(port_cs_1),
      .offset_sel(offset_sel_1),
      .dout(i2c_dout_1),
      .rd_wr(rd_wr_1),
      .add_ok(),
      .din_0(din_0_1),       .din_1(din_1_1),      .din_2( 8'h0),      .din_3( 8'h0),
      .din_4( 8'h0),      .din_5( 8'h0),      .din_6( 8'h0),      .din_7( 8'h0),
      .din_8( 8'h0),      .din_9( 8'h0),      .din_a( 8'h0),      .din_b( 8'h0),
      .din_c( 8'h0),      .din_d( 8'h0),      .din_e(8'h0),      .din_f(8'h0),
      .fifo_prefetch(),      .data2_prefetch(),      .timer_ovflow(),      .wr_en(),
      .state(),
	  .sda_oe_out ( sda_oe_out) ,	  
      .i2c_address(i2c_address_1));
	  	  

//--
 I2C1_reg_0X  I2C1_Port0X_ins(
      .sysclk(CPLD_25M_CLK),
      .reset_n(~rst),
      .rd_wr1(rd_wr_1),
      .port_cs1(port_cs_1),
      .offset_sel1(offset_sel_1),
      .din1(i2c_dout_1),
      .dout1(din_0_1),
      .rd_wr_lpc(),
      .port_cs_lpc(),
      .offset_sel_lpc(),
      .dout_lpc(),
      .din_0_lpc(),
  //    .r08_Interference_Error_R(r08_Interference_Error_R),
      .r01_Multi_Master_Arbitrator_R(1'b1));
 //---
   I2C1_reg_1X  I2C1_Port1X_ins(
       .sysclk(CPLD_25M_CLK),
       .reset_n(~rst),
       .rd_wr1(rd_wr_1),
       .port_cs1(port_cs_1),
       .offset_sel1(offset_sel_1),
       .din1(i2c_dout_1),
       .dout1(din_1_1),
       .rd_wr_lpc(),
       .port_cs_lpc(),
       .offset_sel_lpc(),
       .dout_lpc(),
       .din_0_lpc(),
//	  .drv_prsnt_n(DRV_PRSNT_L_db) , 
//	  .drv_ifdet_n(DRV_IFDET_L_db) ,
//	  .drv_sas_prsnt(drv_sas_prsnt) , 
//	  .drv_nvme_prsnt(drv_nvme_prsnt_t) , 
//	  .drv_pwr_disable(drv_pwr_disable) , 
      .r01_Multi_Master_Arbitrator_R(1'b1));


	  
	  
endmodule

	  