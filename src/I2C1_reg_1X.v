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


////////////////////////////////////////////////////////////////////////////////
// Object        :  
// Last modified :  
////////////////////////////////////////////////////////////////////////////////
//  ESG MB I2C slave register 10h-1Fh
//
 

module I2C1_reg_1X ( 
 
  input      sysclk,
  input      reset_n,
  input      rd_wr1,
  input      [15:0]port_cs1,
  input      [15:0]offset_sel1,
  input      [7:0]din1,
  output  reg   [7:0]dout1,
//  reg        [7:0]dout1,
  input      rd_wr_lpc,
  input      [15:0]port_cs_lpc,
  input      [15:0]offset_sel_lpc,
  input      [7:0]dout_lpc,
  output  reg   [7:0]din_0_lpc,
//  reg        [7:0]din_0_lpc,
//input
//  input      [7:0] reg_10 ;
//  input      [7:0] reg_14 ; 
//  input      [7:0] reg_18 ;  // it is high active
//  input      [7:0] reg_19 ;  // it is high active , 11/6 change to 8-bit
//  input			   pltrst_falling ;
//  input				sys_pwrok ;
  input  [7:0] reg_18h ,
 // input  [1:0] psu_prsnt  ,
//  output  reg	 fan_en ,
//  input	 [1:0]	 cpu_prsnt ,
//  output  		fm_lom_disable_n , 	
//  input  [1:0] psu_ac_status ,   
  input      r01_Multi_Master_Arbitrator_R
  ) ;

// wire [1:0] psu_ac_loss ;
// assign fan_en = r08_Reserved_01[0] ;
// 
//wire [7:0] reg18_db ;
//wire [2:0] reg19_db ;
// assign fm_lom_disable_n = r08_Reserved_02[0] ; 
 
// assign psu_ac_loss[0] = ~psu_ac_status[0] ; 
// assign psu_ac_loss[1] = ~psu_ac_status[1] ; 
//--------- 
  
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

always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                r08_Reserved_00 <=  8'b0 ;
                r08_Reserved_01 <=  8'h00 ;
                r08_Reserved_02 <=  8'h0 ;    
                r08_Reserved_03 <=  8'b0 ;
                r08_Reserved_04 <=  8'b0 ;
                r08_Reserved_05 <=  8'b0 ;
                r08_Reserved_06 <=  8'b0 ;
                r08_Reserved_07 <=  8'b0 ;
                r08_Reserved_08 <=  8'b0 ;
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
                        if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[0]) && (r08_Temp == 8'b0))) 
                            begin
                                r08_Reserved_00 <=  din1 ;
                            end
                        else
                            if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[1]) && (r08_Temp == 8'b0))) 
                                begin
                                    r08_Reserved_01 <=  din1 ;
                                end
                            else
                                if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[2]) && (r08_Temp == 8'b0))) 
                                    begin
                                        r08_Reserved_02 <=  din1 ;
                                    end
                                else
                                    if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[3]) && (r08_Temp == 8'b0))) 
                                        begin
                                            r08_Reserved_03 <=  din1 ;
                                        end
                                    else
                                        if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[4]) && (r08_Temp == 8'b0))) 
                                            begin
                                                r08_Reserved_04 <=  din1 ;
                                            end
                                        else
                                            if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[5]) && (r08_Temp == 8'b0))) 
                                                begin
                                                    r08_Reserved_05 <=  din1 ;
                                                end
                                            else
                                                if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[6]) && (r08_Temp == 8'b0))) 
                                                    begin
                                                        r08_Reserved_06 <=  din1 ;
                                                    end
                                                else
                                                    if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[7]) && (r08_Temp == 8'b0))) 
                                                        begin
                                                            r08_Reserved_07 <=  din1 ;
                                                        end
                                                    else
                                                        if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[8]) && (r08_Temp == 8'b0))) 
                                                            begin
                                                                r08_Reserved_08 <=  din1 ;
                                                            end
                                                        else
                                                            if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[9]) && (r08_Temp == 8'b0))) 
                                                                begin
                                                                    r08_Reserved_09 <=  din1 ;
                                                                end
                                                            else
                                                                if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[10]) && (r08_Temp == 8'b0))) 
                                                                    begin
                                                                        r08_Reserved_0a <=  din1 ;
                                                                    end
                                                                else
                                                                    if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[11]) && (r08_Temp == 8'b0))) 
                                                                        begin
                                                                            r08_Reserved_0b <=  din1 ;
                                                                        end
                                                                    else
                                                                        if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[12]) && (r08_Temp == 8'b0))) 
                                                                            begin
                                                                                r08_Reserved_0c <=  din1 ;
                                                                            end
                                                                        else
                                                                            if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[13]) && (r08_Temp == 8'b0))) 
                                                                                begin
																					r08_Reserved_0d <=  din1 ;
                                                                                end
                                                                            else
                                                                                if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[14]) && (r08_Temp == 8'b0))) 
																					begin
																						r08_Reserved_0e <=  din1 ;
																					end
                                                                                else
																					if (((((!rd_wr1) & port_cs1[01]) & offset_sel1_dly2[15]) && (r08_Temp == 8'b0))) 
																						begin
																							r08_Reserved_0f <=  din1 ;
																						end
                    end
         
            end
    end
//-----------------------
//  always@(posedge sysclk or negedge reset_n)begin                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
// 	if(reset_n == 1'b0)  	 
// 	  fan_en <= 1'b0 ;
// //	 else if (pltrst_falling)
// //	  fan_en <= 1'b0 ;
// 	 else if (~rd_wr1 & port_cs1[01] & offset_sel1_dly2[1]) 
// 	  fan_en <= din1[0] ; 
//   end	     
//---------------  
always@(posedge sysclk or negedge reset_n)begin                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
	if(reset_n == 1'b0)begin                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
		dout1 		<= 8'h0;   
		din_0_lpc	<= 8'h0;   
	end else begin             
		if (r01_Multi_Master_Arbitrator_R) begin  //  
			if 			( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[00]) )begin dout1 <=  r08_Reserved_00 ;		 //Offset 00h    			
			end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[01]) )begin dout1 <=  r08_Reserved_01 ; //{7'b0, fan_en} ;  // {7'b0, r08_Reserved_01[0] }  ;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
			end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[02]) )begin dout1 <=  r08_Reserved_02 ; //{7'b0, r08_Reserved_02[0] } ;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
	//		end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[03]) )begin dout1 <= Offset_03h                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
	//		end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[04]) )begin dout1 <= {2'b0,cpu_prsnt, psu_ac_loss , psu_prsnt } ;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
	//		end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[05]) )begin dout1 <= Offeset_05h                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        																																																																																																																																																																																																				  
	//		end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[06]) )begin dout1 <= Offset_06h								                                                                                                                                                                                                                                                                                                                                                                                                                       
	//		end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[07]) )begin dout1 <= Offset0_7h  
			end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[08]) )begin dout1 <= reg_18h  ;                                                                                                                                                                                                                                                                                                                                                                                                                                     
	//		end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[09]) )begin dout1 <= reg_19  ;  	
	//		end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[10]) )begin dout1 <= reg18_latch	;							                                                                                                                                                                                                                                                                                                                                                                                                                       
	//		end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[11]) )begin dout1 <= reg19_latch  ;                                                                                                                                                                                                                                                                                                                                                                                                                                     
	//		end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[12]) )begin dout1 <= trig_cnt ; // r08_Reserved_0c;   //Offset0ch                                                                                                                                                                                                                                                                                                                                                                                                                                      
	//	 	end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[13]) )begin dout1 <= {6'b0 , alert19 ,alert18} ; //r08_Reserved_0d;   //Offset0dh   
		 //	end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[14]) )begin dout1 <= trig_cnt[2] ; //r08_Reserved_0e;   //Offset0eh                                                                                                                                                                                                                                                                                                                                                                                                                                      
		 //	end else if ( (rd_wr1) & (port_cs1[01]) & (offset_sel1_dly2[15]) )begin dout1 <= trig_cnt[3] ; //r08_Reserved_0f;   //Offset0fh 
			end  
			else dout1 <= 8'h0 ; 
		end
	end																																													                                                                                                                                                                                                                                                                                                                                                                                                                                                     
end       
  
endmodule // I2C1_Port1X
