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
// Project info  : 
//
////////////////////////////////////////////////////////////////////////////////


//`include "design_defines.v"

////////////////////////////////////////////////////////////////////////////////
// Object        : Module design.i2c
// Last modified :  
////////////////////////////////////////////////////////////////////////////////
//
//  i2c_v2 
// take sda_oe to port


//`include "DEFINE.v"

module i2c_v2 (sysclk, i2c_reset_n, scl, sda, port_csd1, offset_sel, dout, rd_wr, 
  add_ok, din_0, din_1, din_2, din_3, din_4, din_5, din_6, din_7, din_8, din_9, 
  din_a, din_b, din_c, din_d, din_e, din_f, fifo_prefetch, data2_prefetch,  sda_oe_out , 
  timer_ovflow, wr_en, state, i2c_address ) ;
  parameter  case_i2c_idle = 6'b01;
  parameter  case_i2c_add = 6'b010;
  parameter  case_i2c_loc = 6'b0100;
  parameter  case_i2c_data1 = 6'b01000;
  parameter  case_i2c_data2 = 6'b010000;
  parameter  case_i2c_end = 6'b100000;
//  parameter  timer_1s = 32'b01011111010111100001000000;
//  parameter  timer_5s = 32'b0111011100110101100101000000;
  input      sysclk;
  input      i2c_reset_n;
  input      scl;
 // inout      sda;
  input     sda ;
  output     [15:0]port_csd1;
  reg        [15:0]port_csd1;
  output     [15:0]offset_sel;
  output     [7:0]dout;
  reg        [7:0]dout;
  output     rd_wr;
  reg        rd_wr;
  output     add_ok;
  reg        add_ok;
  input      [7:0]din_0;
  input      [7:0]din_1;
  input      [7:0]din_2;
  input      [7:0]din_3;
  input      [7:0]din_4;
  input      [7:0]din_5;
  input      [7:0]din_6;
  input      [7:0]din_7;
  input      [7:0]din_8;
  input      [7:0]din_9;
  input      [7:0]din_a;
  input      [7:0]din_b;
  input      [7:0]din_c;
  input      [7:0]din_d;
  input      [7:0]din_e;
  input      [7:0]din_f;
  output     fifo_prefetch;
  output     data2_prefetch;
  output     timer_ovflow;
  reg        timer_ovflow;
  output     wr_en;
  reg        wr_en;
  output     [5:0]state;
  reg        [5:0]state;
  input      [6:0]i2c_address;
  // new
  output    sda_oe_out ; 

//timer overflow
wire clk_5mhz = sysclk ; //5mhz clock for timer
reg timer_clr_n ; 
reg scl_d1, scl_d2, scl_pclk, scl_nclk, scl_pclkd1, scl_pclkd2, scl_pclkd3, sda_d1, sda_d2, sda_pclk, sda_nclk ; 
reg sda_out, sda_oe ; 
reg next_state, next_state_d1, next_state_d2 ; 
reg [3:0] cnt ; 
reg cnt8, cnt9 ; 
reg [7:0] loc ; 
reg rd_en, rd_end1, rd_end2, rd_end3 ; 
reg [15:0] port_cs, port_csd2 ; 
reg [7:0] shift_din ; 
reg [7:0] reg_din ; 
reg [7:0] shift_dout ; 
reg master_rd_nack ; 
reg i2c_nack ; 
reg fifo_rd, info_rd ; 
wire reset_n = i2c_reset_n ; // (i2c_reset_n & (~timer_ovflow)) ; //when i2c watchdog overflow, i2c machine will be reset
//sampling rising or falling edge of scl&sda
wire scl_pclk_w = ((~scl_d2) & scl_d1) ; //rising edge of scl
wire scl_nclk_w = (scl_d2 & (~scl_d1)) ; //falling edge of scl
wire sda_pclk_w = ((~sda_d2) & sda_d1) ; //rising edge of sda
wire sda_nclk_w = (sda_d2 & (~sda_d1)) ; //falling edge of sda
wire cnt0_w = ((cnt == 4'b0) ? 1'b1 : 1'b0) ; //first bit
wire cnt7_w = ((cnt == 4'b0111) ? 1'b1 : 1'b0) ; //set cnt7_w
wire cnt8_w = ((cnt == 4'b1000) ? 1'b1 : 1'b0) ; //set cnt8_w, when cnt=8, it means i2c machine has sampled 8-bits
wire cnt9_w = ((cnt == 4'b1001) ? 1'b1 : 1'b0) ; //last bit, acknowledge bit
assign fifo_prefetch = (((((state[2] | state[4]) & rd_wr) & (loc == 8'b11111110)) & (cnt9_w & scl_pclkd2)) & (~master_rd_nack)) ; //access first fifo byte
assign data2_prefetch = ((((state[3] & rd_wr) & (loc == 8'b11111110)) & (cnt9_w & scl_pclkd2)) & (~master_rd_nack)) ; //access second fifo byte
wire next_state_w = ((cnt9_w & scl_nclk_w) ? 1'b1 : 1'b0) ; //when this signal asserted, i2c machine will go to next state
wire start_w = (scl & sda_nclk_w) ; //a high to low transition on the sda line while scl is high is start transition
wire stop_w = (scl & sda_pclk_w) ; //a low to high transition on the sda line while scl is high is stop transition
//port and offset
wire [15:0] port_w ; 
assign port_w = {(loc[7:4] == 4'b1111),(loc[7:4] == 4'b1110),(loc[7:4] == 4'b1101),(loc[7:4] == 4'b1100),(loc[7:4] == 4'b1011),(loc[7:4] == 4'b1010),(loc[7:4] == 4'b1001),(loc[7:4] == 4'b1000),(loc[7:4] == 4'b0111),(loc[7:4] == 4'b0110),(loc[7:4] == 4'b0101),(loc[7:4] == 4'b0100),(loc[7:4] == 4'b011),(loc[7:4] == 4'b010),(loc[7:4] == 4'b01),
            (loc[7:4] == 4'b0)} ; 
assign offset_sel = {(loc[3:0] == 4'b1111),(loc[3:0] == 4'b1110),(loc[3:0] == 4'b1101),(loc[3:0] == 4'b1100),(loc[3:0] == 4'b1011),(loc[3:0] == 4'b1010),(loc[3:0] == 4'b1001),(loc[3:0] == 4'b1000),(loc[3:0] == 4'b0111),(loc[3:0] == 4'b0110),(loc[3:0] == 4'b0101),(loc[3:0] == 4'b0100),(loc[3:0] == 4'b011),(loc[3:0] == 4'b010),(loc[3:0] == 4'b01),
            (loc[3:0] == 4'b0)} ; 
wire sda_tp = sda ; 
wire sda_oe_tp = sda_oe ; 
wire sda_out_tp = sda_out ; 
//i2c		    
// assign sda = (sda_oe ? (sda_out ? 1'b1 : 0) : 1'bz) ; 
assign sda_oe_out = sda_oe & !sda_out ;  // when sda_oe_out = 0 , sda = Hi-Z ,  = 1 , sda = 0 ;

reg scl_nclk_d1, scl_nclk_d2 ; 
//log scl and sda state for positive&negative edge detection
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                {scl_d1,scl_d2,sda_d1,sda_d2} <=  4'b0 ;
                scl_pclkd1 <=  1'b0 ;
                scl_pclkd2 <=  1'b0 ;
                scl_pclkd3 <=  1'b0 ;
                {scl_nclk_d1,scl_nclk_d2} <=  2'b0 ;
            end
        else
            begin
                {scl_d2,scl_d1} <=  {scl_d1,scl} ;
                {sda_d2,sda_d1} <=  {sda_d1,sda} ;
                scl_nclk <=  scl_nclk_w ;
                sda_nclk <=  sda_nclk_w ;
                scl_nclk_d1 <=  scl_nclk ;
                scl_nclk_d2 <=  scl_nclk_d1 ;
                {scl_pclkd3,scl_pclkd2,scl_pclkd1,scl_pclk} <=  {scl_pclkd2,scl_pclkd1,scl_pclk,scl_pclk_w} ;
                sda_pclk <=  sda_pclk_w ;
            end
    end
reg next_state_d3 ; 
//cnt and next_state
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                cnt <=  4'b0 ;
                cnt8 <=  1'b0 ;
                cnt9 <=  1'b0 ;
                next_state <=  1'b0 ;
                next_state_d1 <=  1'b0 ;
                next_state_d2 <=  1'b0 ;
                next_state_d3 <=  1'b0 ;
            end
        else
            begin
                cnt <=  (((start_w | next_state_d2) | stop_w) ? 4'b0 : (((~state[0]) & scl_pclk) ? (cnt + 1) : cnt)) ;
                cnt8 <=  cnt8_w ;
                cnt9 <=  cnt9_w ;
                next_state <=  next_state_w ;
                next_state_d1 <=  next_state ;
                next_state_d2 <=  next_state_d1 ;
                next_state_d3 <=  next_state_d2 ;
            end
    end
//shift_din,shift the data from sda into shift_din
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                shift_din <=  8'b0 ;
            end
        else
            begin
                shift_din <=  ((state[0] | state[5]) ? 8'b0 : (scl_pclk ? {shift_din[6:0],sda} : shift_din)) ;
            end
    end
//rd_wr & add_ok,address state, in this state: 1.rd_wr will be set, read=1 write=0. 2.add_ok will be set
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                rd_wr <=  1'b0 ;
                add_ok <=  1'b0 ;
            end
        else
            begin
                rd_wr <=  (stop_w ? 1'b0 : ((cnt8_w & state[1]) ? shift_din[0] : rd_wr)) ;
                add_ok <=  (stop_w ? 0 : ((cnt8_w & state[1]) ? ((shift_din[7:1] == i2c_address) ? 1'b1 : 1'b0) : add_ok)) ;
            end
    end
//loc,register location state
//when the end of first transition, loc added by 1  
wire cnt8_nclk_wr = ((cnt8 & scl_nclk) & (~rd_wr)) ; 
wire cnt9_w_pclk = (scl_pclkd2 & cnt9_w) ; 
reg wr_byte = 0 ; 
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                loc <=  8'b0 ;
                wr_byte <=  0 ;
            end
        else
            begin
                loc <=  ((cnt8_nclk_wr & state[2]) ? shift_din : ((((state[4] & rd_wr) | (state[3] & (~rd_wr))) & cnt9_w_pclk) ? (loc + 1'b1) : ((wr_byte & stop_w) ? (loc - 1'b1) : loc))) ;//delete"rd_wr" hudson support when continous write action
                wr_byte <=  (stop_w ? 0 : (((state[3] & (~rd_wr)) & cnt9_w_pclk) ? 1 : wr_byte)) ;
            end
    end
//receive or transmit data state, in this state, the data will be save in dout
//wire cnt8_nclk_wr =cnt8  & scl_nclk & ~rd_wr;
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                dout <=  8'b0 ;
            end
        else
            begin
                dout <=  ((cnt8_nclk_wr & state[3]) ? shift_din : dout) ;//latch the loc when falling edge of scl
            end
    end
//rd_en,wr_en,port_cs,send the data to register,trigger the port_cs, post_cs trigger by wr_en&rd_en
//wire wr_forbid_cond = ( (port_w[1]& ~( offset_sel[0]| offset_sel[1])) | (port_w[2] & offset_sel[11]) | port_w[5] | port_w[6] | port_w[7] )  & (shift_din[7] | shift_din[3]);
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                {rd_end3,rd_end2,rd_end1,rd_en} <=  4'b0 ;
                wr_en <=  0 ;
                {port_csd2,port_csd1,port_cs} <=  48'b0 ;
            end
        else
            begin
                rd_en <=  (rd_wr & ((state[4] & (~master_rd_nack)) | (state[1] & add_ok))) ;
                wr_en <=  (cnt8_nclk_wr & state[3]) ;
                port_cs <=  ({16{(wr_en | rd_en)}} & port_w) ;
                {rd_end3,rd_end2,rd_end1} <=  {rd_end2,rd_end1,rd_en} ;
                {port_csd2,port_csd1} <=  {port_csd1,port_cs} ;
            end
    end
//sda_oe
//when read operation, oe will active at date transition phase from bit0-bit7
//when write operation, oe will active at ninth bit transition phase for acknoledge
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                sda_oe <=  1'b0 ;
            end
        else
            begin
                sda_oe <=  ((state[0] | state[5]) ? 1'b0 : (scl_nclk_w ? ((cnt8_w & i2c_nack) ? 1'b0 : (rd_wr ? (~(((state[0] | ((state[3] | state[4]) & cnt8_w)) | state[5]) | ((state[3] | state[4]) & master_rd_nack))) : cnt8_w)) : sda_oe)) ;
            end
    end
//reg_din,latch data at rising edge of 9th scl, this register is for prepare data in read operation, this data is for output.
//always@(posedge sysclk or negedge reset_n)
always
    @(negedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                reg_din <=  8'b0 ;
            end
        else
            begin
                reg_din <=  (next_state_w ? (((((((((((((((({8{port_csd1[0]}} & din_0) | ({8{port_csd1[8]}} & din_8)) | ({8{port_csd1[1]}} & din_1)) | ({8{port_csd1[9]}} & din_9)) | ({8{port_csd1[2]}} & din_2)) | ({8{port_csd1[10]}} & din_a)) | ({8{port_csd1[3]}} & din_3)) | ({8{port_csd1[11]}} & din_b)) | ({8{port_csd1[4]}} & din_4)) | ({8{port_csd1[12]}} & din_c)) | ({8{port_csd1[5]}} & din_5)) | ({8{port_csd1[13]}} & din_d)) | ({8{port_csd1[6]}} & din_6)) | ({8{port_csd1[14]}} & din_e)) | ({8{port_csd1[7]}} & din_7)) | ({8{port_csd1[15]}} & din_f)) : reg_din) ;
            end
    end
//sda_out and shift_dout for read operate
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                shift_dout <=  8'b0 ;
                sda_out <=  1'b0 ;
            end
        else
            begin
                shift_dout <=  (scl_nclk ? (cnt9_w ? ({8{((state[1] & add_ok) | state[4])}} & reg_din) : {shift_dout[6:0],1'b0}) : (state[0] ? 8'b0 : shift_dout)) ;
                sda_out <=  (scl_nclk_d2 ? shift_dout[7] : sda_out) ;
            end
    end
//nack
//ack explanation: transmitter release SDA of i2c bus at the 9st pulse period of SCL after complete one transition of 8bits, receiver send one ACK(pull down SDA) to indicate succeeding in receiving data.
//nack explanation: receiver DON'T send one ACK(NOT pull down SDA) at the 9st pulse period of SCL,that is NACK; 
//                  NACK have two usages: 1. generally indicate receiver don't succeed in recevering data;
//										  2. As master is receiver, master should send one NACK signal after receive one last byte(last 8bits), 
//											that is to info slave(also transmitter) to end data tansmittion and to release the SDA bus, in order that master could send STOP signal.  
//That: when bit W/R state followed by low(read datat) is read process, with and data to be read; when bit W/R state followed by high(write data) is write process, with offset point reg and data to be written;
//during read cycle, master should not generate ack to slave after last byte(nack)
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                i2c_nack <=  0 ;
                master_rd_nack <=  0 ;
            end
        else
            begin
                i2c_nack <=  (scl_pclkd2 ? ((state[0] | (state[1] & (~add_ok))) | state[5]) : i2c_nack) ;//for sda_oe
                master_rd_nack <=  (((state[2] | state[4]) | state[3]) ? ((cnt9_w & scl_pclkd1) ? sda : master_rd_nack) : 0) ;//detect nack when read
            end
    end
//fifo_rd & info_rd
//if read fifo or agent information,fifo addr is 0xfe, agent information addr is 0xc0
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                info_rd <=  0 ;
                fifo_rd <=  0 ;
            end
        else
            begin
                info_rd <=  ((((state[1] | state[3]) & next_state_w) & rd_wr) ? 1'b1 : ((state[0] | state[5]) ? 1'b0 : info_rd)) ;
                fifo_rd <=  (((state[1] & next_state_w) & rd_wr) ? (loc == 8'b11111110) : (((state[0] | state[1]) | state[5]) ? 1'b0 : fifo_rd)) ;
            end
    end
//i2c machine
// three read mode: A-  
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                state <=  case_i2c_idle ;
            end
        else
            begin
                case (state)
                case_i2c_idle : 
                    state <=  (start_w ? case_i2c_add : case_i2c_idle) ;
                case_i2c_add : 
                    //start
                    state <=  (start_w ? case_i2c_add : (stop_w ? case_i2c_idle : (next_state_d2 ? (add_ok ? (rd_wr ? case_i2c_data2 : case_i2c_loc) : case_i2c_idle) : case_i2c_add))) ;
                case_i2c_loc : 
                    state <=  (start_w ? case_i2c_add : (stop_w ? case_i2c_idle : (next_state_d2 ? (master_rd_nack ? case_i2c_idle : case_i2c_data1) : case_i2c_loc))) ;
                case_i2c_data1 : 
                    state <=  (start_w ? case_i2c_add : (stop_w ? case_i2c_idle : (next_state_d2 ? (master_rd_nack ? case_i2c_idle : case_i2c_data1) : case_i2c_data1))) ;
                case_i2c_data2 : 
                    state <=  (start_w ? case_i2c_add : (stop_w ? case_i2c_idle : (next_state_d2 ? (master_rd_nack ? case_i2c_end : case_i2c_data2) : case_i2c_data2))) ;
                case_i2c_end : 
                    // preliminarily use master_rd_nack to select data1 or data2 
                    state <=  (start_w ? case_i2c_add : (stop_w ? case_i2c_idle : (next_state_d2 ? case_i2c_idle : case_i2c_end))) ;
                default : 
                    state <=  case_i2c_idle ;
                endcase 
            end
    end
//timer overflow
//only when sda_oe=1 and sda_out=0, the timer begin to count
//tbd
always
    @(posedge sysclk or negedge reset_n)
    begin
        if ((reset_n == 1'b0)) 
            begin
                timer_clr_n <=  0 ;
            end
        else
            begin
                timer_clr_n <=  (sda_oe ? 1'b1 : 0) ;
            end
    end


endmodule // i2c
