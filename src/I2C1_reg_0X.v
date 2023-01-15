////////////////////////////////////////////////////////////////////////////////
//
// www.jabil.com
//
// Verilog library  : IEEE Standard
// VHDL library   : IEEE Standard
// Host name     :  
// User name     :  
// Time stamp    :  
//
// Designed by   :   
// Company       : 
// Project info  : 
// 
////////////////////////////////////////////////////////////////////////////////

//`include "design_defines.v"

////////////////////////////////////////////////////////////////////////////////
// Object        : Module design.I2C1_Port0X
// Last modified :  
////////////////////////////////////////////////////////////////////////////////
// 2021/10/7 , modify CHIP_ID to 4-bit , add CHIP_ID_2

 //`include "DEFINE.v"

`define DEVICE_ID_1 	8'h20	
`define DEVICE_ID_2 	8'h23	
`define CHIP_ID 		4'h2	//  2022/10/11  1= MB , = SCM CPLD , 3 = MP , 4 = PFR CPLD , 
`define CHIP_ID_2		4'h10    //  
//`define REVERSION   	8'b000_00001
//`define TEST_BUILD_VER 	8'h01	//  


module I2C1_reg_0X  #(parameter MAJOR_VER = 8'h1 , MINOR_VER = 8'h02 ) 
  (
  input      sysclk ,
  input      reset_n ,
  input      rd_wr1 ,
  input      [15:0]port_cs1 ,
  input      [15:0]offset_sel1 ,
  input      [7:0]din1 ,
  output reg    [7:0]dout1 ,
 // reg        [7:0]dout1 ,
  input      rd_wr_lpc ,
  input      [15:0]port_cs_lpc ,
  input      [15:0]offset_sel_lpc ,
  input      [7:0]dout_lpc ,
  output reg    [7:0]din_0_lpc ,
//  reg        [7:0]din_0_lpc ,
//---- input   

//  input     [1:0] board_id ,
//  input     [1:0] board_ver  , 
 // input     [7:0] test_ver  ,
//  input 	[39:0] debug_msg ,
 //  input           tp1 
  input      r01_Multi_Master_Arbitrator_R 
   ) ;
 //---  debug 
 
 //---- output 
//  output    [7:0]  port_80 ) ;

 
reg [7:0] r08_Reserved_00 ; 
reg [7:0] r08_Reserved_01 ; 
reg [7:0] r08_Reserved_02 ; 
reg [7:0] r08_Reserved_03 ; 
reg [7:0] r08_Reserved_04 ; 
reg [7:0] r08_Reserved_05 ; 
reg [7:0] r08_Reserved_06 ; 
reg [7:0] r08_Reserved_07 ; 
reg [7:0] r08_Reserved_08 ; 
reg [7:0] r08_Reserved_09 ; 
reg [7:0] r08_Reserved_0a ; 
reg [7:0] r08_Reserved_0b ; 
reg [7:0] r08_Reserved_0c ; 
reg [7:0] r08_Reserved_0d ; 
reg [7:0] r08_Reserved_0e ; 
reg [7:0] r08_Reserved_0f ; 
reg [7:0] r08_Temp ; 
 //======================================
// assign port_80 = r08_Reserved_0a ;
 
 //====================================== 
reg [15:0] offset_sel1_dly1, offset_sel1_dly2, offset_sel1_dly3 ; 
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((!reset_n)) 
            begin
                {offset_sel1_dly3,offset_sel1_dly2,offset_sel1_dly1} <=  {16'b0,16'b0,16'b0} ;
            end
        else
            begin
                {offset_sel1_dly3,offset_sel1_dly2,offset_sel1_dly1} <=  {offset_sel1_dly2,offset_sel1_dly1,offset_sel1} ;
            end
    end
	

always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                r08_Reserved_00 <=  8'h12 ;
                r08_Reserved_01 <=  8'b0 ;
                r08_Reserved_02 <=  8'b0 ;
                r08_Reserved_03 <=  8'b0 ;
                r08_Reserved_04 <=  8'b0 ;
                r08_Reserved_05 <=  8'b0 ;
                r08_Reserved_06 <=  8'b0 ;
                r08_Reserved_07 <=  8'b0 ;
                r08_Reserved_08 <=  8'h00 ;   
                r08_Reserved_09 <=  8'b0 ;
                r08_Reserved_0a <=  8'b0 ;
                r08_Reserved_0b <=  8'b0 ;
                r08_Reserved_0c <=  8'b0 ;
                r08_Reserved_0d <=  8'b0 ;
                r08_Reserved_0e <=  8'b0 ;
                r08_Reserved_0f <=  8'b0 ;
                r08_Temp <=  8'b0 ;
            end
        else
            begin
                if (r01_Multi_Master_Arbitrator_R) 
                    begin
                        if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[0]) && (r08_Temp == 8'b0))) 
                            begin
                                r08_Reserved_00 <=  din1 ;
                            end
                        else
                            if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[1]) && (r08_Temp == 8'b0))) 
                                begin
                                    r08_Reserved_01 <=  din1 ;
                                end
                            else
                                if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[2]) && (r08_Temp == 8'b0))) 
                                    begin
                                        r08_Reserved_02 <=  din1 ;
                                    end
                                else
                                    if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[3]) && (r08_Temp == 8'b0))) 
                                        begin
                                            r08_Reserved_03 <=  din1 ;
                                        end
                                    else
                                        if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[4]) && (r08_Temp == 8'b0))) 
                                            begin
                                                r08_Reserved_04 <=  din1 ;
                                            end
                                        else
                                            if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[5]) && (r08_Temp == 8'b0))) 
                                                begin
                                                    r08_Reserved_05 <=  din1 ;
                                                end
                                            else
                                                if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[6]) && (r08_Temp == 8'b0))) 
                                                    begin
                                                        r08_Reserved_06 <=  din1 ;
                                                    end
                                                else
                                                    if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[7]) && (r08_Temp == 8'b0))) 
                                                        begin
                                                            r08_Reserved_07 <=  din1 ;
                                                        end
                                                    else
                                                        if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[8]) && (r08_Temp == 8'b0))) 
                                                            begin
                                                                r08_Reserved_08 <=  din1 ;
                                                            end
                                                        else
                                                            if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[9]) && (r08_Temp == 8'b0))) 
                                                                begin
                                                                    r08_Reserved_09 <=  din1 ;
                                                                end
                                                            else
                                                                if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[10]) && (r08_Temp == 8'b0))) 
                                                                    begin
                                                                        r08_Reserved_0a <=  din1 ;
                                                                    end
                                                                else
                                                                    if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[11]) && (r08_Temp == 8'b0))) 
                                                                        begin
                                                                            r08_Reserved_0b <=  din1 ;
                                                                        end
                                                                    else
                                                                        if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[12]) && (r08_Temp == 8'b0))) 
                                                                            begin
                                                                                r08_Reserved_0c <=  din1 ;
                                                                            end
                                                                        else
                                                                            if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[13]) && (r08_Temp == 8'b0))) 
                                                                                begin
																					r08_Reserved_0d <=  din1 ;
                                                                                end
                                                                            else
                                                                                if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[14]) && (r08_Temp == 8'b0))) 
																					begin
																						r08_Reserved_0e <=  din1 ;
																					end
                                                                                else
																					if (((((!rd_wr1) & port_cs1[0]) & offset_sel1_dly2[15]) && (r08_Temp == 8'b0))) 
																						begin
																							r08_Reserved_0f <=  din1 ;
																						end
                    end
            end
    end
	
                                                                                                                                                                                                                                                                                                                                                                                                                                
always@(posedge sysclk or negedge reset_n)begin                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
	if(reset_n == 1'b0)begin                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
		dout1 		<= 8'h0;    
		din_0_lpc	<= 8'h0;
	end else begin         
		if (r01_Multi_Master_Arbitrator_R) begin
		
			if 			( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[00]) )begin dout1 <=  MAJOR_VER;		//Offset 00h                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
			end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[01]) )begin dout1 <=  MINOR_VER;		//Offset 01h                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
			end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[02]) )begin dout1 <= `DEVICE_ID_1;			//Offset 02h                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
			end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[03]) )begin dout1 <= `DEVICE_ID_2;		//Offset 03h                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
			end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[04]) )begin dout1 <= {4'b0 ,`CHIP_ID} ;			 //Offset 04h                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
			end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[05]) )begin dout1 <= {4'b0 ,`CHIP_ID_2} ; //Offeset 05h                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        																																																																																																																																																																																																				  
			end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[06]) )begin dout1 <= r08_Reserved_06 ;   //Offset06h								                                                                                                                                                                                                                                                                                                                                                                                                                       
			end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[07]) )begin dout1 <= r08_Reserved_07 ;  //Offset07h                                                                                                                                                                                                                                                                                                                                                                                                                                      
			end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[08]) )begin dout1 <= r08_Reserved_08;   //Offset08h                                                                                                                                                                                                                                                                                                                                                                                                                                      
			end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[09]) )begin dout1 <= r08_Reserved_09;   //Offset09h       
			end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[10]) )begin dout1 <= r08_Reserved_0a ;   //Offset0ah								                                                                                                                                                                                                                                                                                                                                                                                                                       
		 	end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[11]) )begin dout1 <= r08_Reserved_0b ;   //Offset0bh                                                                                                                                                                                                                                                                                                                                                                                                                                      
		  	end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[12]) )begin dout1 <= r08_Reserved_0c  ; //Offset0ch                                                                                                                                                                                                                                                                                                                                                                                                                                      
		  	end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[13]) )begin dout1 <= r08_Reserved_0d  ;   // r08_Reserved_0d;   //Offset0dh   
		  	end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[14]) )begin dout1 <= r08_Reserved_0e ;   //Offset0eh                                                                                                                                                                                                                                                                                                                                                                                                                                      
		  	end else if ( (rd_wr1) & (port_cs1[00]) & (offset_sel1_dly2[15]) )begin dout1 <= r08_Reserved_0f ;   //Offset0fh 
			end   
		    else dout1 <= 8'h0 ;
		 // end
	
		end
	end																																													                                                                                                                                                                                                                                                                                                                                                                                                                                                     
end      
  

endmodule // I2C1_Port0X
