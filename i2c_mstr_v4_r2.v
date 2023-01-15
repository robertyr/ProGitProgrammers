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
//    Lattice Semiconductor Corporation
//    5555 NE Moore Court
//    Hillsboro, OR 97124
//    U.S.A
//
//    TEL: 1-800-Lattice (USA and Canada)
//    503-268-8001 (other locations)
//
//    web: http://www.latticesemi.com/
//    email: techsupport@latticesemi.com
// 
//-------------------------------------------------------------------------
// 
//  Name:  i2c_mstr.v   
// 
//  Description: i2c master used to simulate the i2c slave module
// 		 random read/write, sequential read are simulated
// 
//-------------------------------------------------------------------------
// Code Revision History :
//-------------------------------------------------------------------------
// Ver: | Author	|Mod. Date	    |Changes Made:
// V1.0 | cm		  |2005           |Initial ver
// V1.1 | cm	    |6/2009         |update header 
//					                      |emulate master stops if slave is not ready
// V1.2 | cm	    |7/2010         |stop scl when no command
//-------------------------------------------------------------------------
//
// i2c_mstr_v4_r2.v
//
// 2022/12/5
// need to adjust clk_cycle ( large )if something wrong
// add burst_write task , random_burst_read
// sim ok
// 2023/1/12
// modify  burst_write , add burst_read for no one byte reg addr , burst_read_w_restart 
// sim ok

`timescale 1 ns /  100 ps

`define write_to_file

module i2c_mstr4( XRESET,  
                scl, 
                sda ,
                ready,
                scl_oe
                );

   //---------------------------------------------------------------------
   // port list

   output          XRESET;

   output          scl;
   inout           sda;
   input 	       ready;
   input 		 scl_oe;

   //---------------------------------------------------------------------
   // registers and wires

   reg             XRESET;                     // reset
   reg             scl_reg;                    // clock register
   reg             sda_reg;                    // SDA input stimulus
   reg             scl_enable; 			           // enable / disable the scl clock


   //---------------------------------------------------------------------
   // parameters   
localparam file_name = "display_out.txt" ;   
integer f_handle = 0 ; 

   parameter       clk_cycle   = 100;  // org = 50
   parameter       delay       = 10; 
   parameter       reset_delay = 100;
   parameter       cycle_end   = 50;

   parameter       dev_add   = 4'b1100; 
   parameter       rd        = 1'b1;
   parameter       wr        = 1'b0;

   parameter       upper_addra = 3'b000,  
	                 upper_addrb = 3'h0, 
	                 upper_addrc = 3'h0,
	                 upper_addrd = 3'h0;
   
   
   parameter       rd_a_addr = {dev_add, upper_addra, rd};
   parameter       rd_b_addr = {dev_add, upper_addrb, rd};
   parameter       rd_c_addr = {dev_add, upper_addrc, rd};
   parameter       rd_d_addr = {dev_add, upper_addrd, rd};

   parameter       wr_a_addr = {dev_add, upper_addra, wr};
   parameter       wr_b_addr = {dev_add, upper_addrb, wr};
   parameter       wr_c_addr = {dev_add, upper_addrc, wr};
   parameter       wr_d_addr = {dev_add, upper_addrd, wr};
   
  parameter    		i2c_reg0 = 8'h0 ;
  parameter    		i2c_reg1 = 8'h1 ;
  parameter    		i2c_reg2 = 8'h2 ;  
  parameter    		i2c_reg3 = 8'h3 ; 
  parameter    		i2c_reg4 = 8'h4 ;
  parameter    		i2c_reg5 = 8'h5 ;
  parameter    		i2c_reg6 = 8'h6 ;
  parameter    		i2c_reg7 = 8'h7 ;
  parameter    		i2c_reg8 = 8'h8 ;
  
  parameter    		i2c_reg22 = 8'h22 ; 
   parameter    	i2c_reg10 = 8'h10 ;
   parameter    	i2c_reg12 = 8'h12 ;   
  parameter    		i2c_reg50 = 8'h50 ;  
  parameter    		i2c_reg34 = 8'h34 ; 
   
   parameter       wr_a_addrl = 8'h01;
   parameter       wr_b_addrl = 8'h02;
   parameter       wr_c_addrl = 8'h03;
   parameter       wr_d_addrl = 8'h04;

   parameter       wr_a_data = 8'h31;
   parameter       wr_b_data = 8'h02;
   parameter       wr_c_data = 8'hc0;
   parameter       wr_d_data = 8'h01; 
   parameter       wr_e_data = 8'h04; 
   parameter       wr_f_data = 8'h00; 
   parameter       wr_g_data = 8'h77; 
   parameter       wr_h_data = 8'h88; 

 reg [143:0] data_in_v ;
 reg [7:0] reg_addr ; 
   //---------------------------------------------------------------------
   // assignments

   assign          sda   = (sda_reg) ? 1'bz : 1'b0;
   assign          scl   = (scl_reg) ? 1'bz : 1'b0;

   //---------------------------------------------------------------------
   // initial block

   initial begin
   
   `ifdef write_to_file
      f_handle = $fopen( file_name , "w") ;
	  if (!f_handle ) 
	   begin 
	    $display ( " Could not open file \r" ) ;
		$stop ;
	   end
	  else begin
	  $fdisplay( f_handle) ;
      $fdisplay(f_handle,  $time, ": Starting I2C Slave Simulation ");
      $fdisplay(f_handle , $time, ": Initializing Test Bench \n");
      end	   
   `endif  
      
      $display($time,": Starting I2C Slave Simulation");
      $display();
      $display($time,": Initializing Test Bench");
      $display();
      init_chip;
      #50;
      // for lattice i2c slave
    data_in_v = { 8'h0 , 8'h0 , 8'h0 ,8'h0 , 8'h0, 8'h0, 8'h99, 8'h88 ,
				  8'h78 , 8'h66 ,  8'h55,  8'h44,  8'h33,  8'h022, 8'h11, 8'h8} ;
    
     burst_write( 8'hc0 , 6 , data_in_v) ;
 #600 	 
    reg_addr = 8'h0 ;
	burst_write( 8'hc0 , 1 , reg_addr) ;
 #600 	
    burst_read (8'hc0 ,  10)  ;
 //	 random_burst_read (8'hc0 , 8'h8,  5)  ;
 
	//random write
 //    $display($time,": Writing I2C Register at %h", i2c_reg3);
 //    start_proc;						
 //    write_i2c_nostop(wr_a_addr,i2c_reg3);
 //    write_i2c_repeat(wr_a_data);
 //    write_i2c_repeat(wr_b_data);	  
 //    stop_proc;
//	#600 ;
//    $display($time,": Writing I2C Register at %h", i2c_reg0);
//       start_proc;						
//       write_i2c_nostop(wr_a_addr,i2c_reg0);
//       write_i2c_repeat(wr_c_data);
//       write_i2c_repeat(wr_d_data);	  
//       stop_proc;
//
	#600 ;	
	reg_addr = 8'h8 ;	
	burst_write( 8'hc0 , 1 , reg_addr) ;
	#300 
	  burst_read (8'hc0 ,  5)  ;
	#600 ;		 
	reg_addr = 8'h9 ;	
	burst_write( 8'hc0 , 1 , reg_addr) ;    
    burst_read_w_restart (8'hc0 , 4)  ;	
	# 300 ;
//-----------------------
//     // burst write (sequential write)
//     $display($time,": Writing I2C Register starting at %h", wr_a_addrl);
//     start_proc;
//     write_i2c_nostop(wr_a_addr,wr_a_addrl);		 // write address
//     $display($time,": Wait for slave to release scl");
//     scl_ready;
//     write_i2c(wr_a_data);
//    write_i2c_repeat(wr_b_data);
//    write_i2c_repeat(wr_c_data);
//    write_i2c_repeat(wr_d_data);
//     stop_proc;
//------------------------
  //------- burst read (sequential read)
 //     $display($time,": Reading I2C Register");		// use current address pointer, no stop until the last read
 //     start_proc;						
 //     read_i2c_nostop(rd_a_addr);
 //     read_i2c_ack;
 //     read_i2c_repeat;
 //     read_i2c_ack;
 //     read_i2c_repeat;
 //     stop_proc;
  //-----------------------
  
 //   random_read (i2c_reg50) ; 
// 	#200
// 	 $display( "=================  "   );
// 	 #100 ;
// 	#600 ;	
// 	random_read (i2c_reg4) ; 	
// 	#600 ;	
//     //random read (change direction) one data
//       $display($time,": Writing I2C Register to read from %h", i2c_reg1);	  
//       start_proc;
//       write_i2c_nostop(wr_a_addr,i2c_reg1);			// write address
//   //    $display();
//       $display($time,": Reading I2C Register starting at %h", i2c_reg1); 
//       wr_i2c_ack;
//       #(clk_cycle);
//       start_proc;						                      // read back with Repeat Start
//       read_i2c_nostop(rd_a_addr);
//   //  read_i2c_nack ;
// 	   stop_proc;
  //   random_read (i2c_reg10) ; 

  //    random_read (i2c_reg22) ; 
  //   random_write( 8'h12 , 8'h30 , 8'h01 ) ; 
 //	 random_write( 8'h22 , 8'h01 , 8'h00 ) ; 
 //     random_read (i2c_reg22) ; 	 
 //     $display($time,": Writing I2C Register at %h", i2c_reg3);
 //     start_proc;						
 //     write_i2c_nostop(wr_a_addr,i2c_reg3);
 //     write_i2c_repeat(wr_a_data);
 //     write_i2c_repeat(wr_b_data);	  
 //     stop_proc;
 //-------------------------------------
  //    start_proc;
  //    $display($time,": Writing I2C Register to read from %h", wr_c_addrl);
  //    write_i2c_nostop(wr_a_addr,wr_c_addrl);			// write address
  //    $display();
  //    $display($time,": Reading I2C Register starting at %h", wr_c_addrl);		
  //    wr_i2c_ack;
  //    #(clk_cycle);
  //    start_proc;						   // read back with Repeat Start
  //    read_i2c_nostop(rd_a_addr);
  //    read_i2c_ack;
  //    read_i2c_repeat;
  //    stop_proc;
     
 //     $display();
  
      
 //    //random write
 //    $display($time,": Writing I2C Register at %h", wr_c_addrl);
 //    start_proc;						
 //    write_i2c_nostop(wr_a_addr,wr_c_addrl);
 //    write_i2c_repeat(wr_e_data);
 //    stop_proc;
 //    $display();
 //    $display($time,": Writing I2C Register at %h", wr_d_addrl);
 //    start_proc;						
 //    write_i2c_nostop(wr_a_addr,wr_d_addrl);
 //    write_i2c_repeat(wr_f_data); 
 //    stop_proc;
 //    $display();
 //    $display($time,": Writing I2C Register at %h", wr_c_addrl);
 //    start_proc;						
 //    write_i2c_nostop(wr_a_addr,wr_c_addrl);
 //    write_i2c_repeat(wr_g_data); 
 //    stop_proc;
 //    $display();
 //    $display($time,": Writing I2C Register at %h", wr_d_addrl);
 //    start_proc;						
 //    write_i2c_nostop(wr_a_addr,wr_d_addrl);
 //    write_i2c_repeat(wr_h_data); 
 //    stop_proc;
 //    $display();
      
         #300
   `ifdef write_to_file
       $fdisplay(f_handle) ;
      $fdisplay(f_handle,  $time, ": I2C Simulation Complete \n ");
	  $fclose (f_handle) ;
   `endif 		 
	   $display() ; 
      $display($time,": I2C Simulation Complete");
	  $display() ; 
      # delay
      $stop;
	  
   end  

   //---------------------------------------------------------------------
   // clock generation
   always #(clk_cycle/2) scl_reg = scl_enable ? ~scl_reg : (ready ? 1'b1 : 1'b0) ;

   //---------------------------------------------------------------------
   //

task burst_write ;
	 input [7:0] salve_addr ;
//	 input [7:0] i2c_reg ;	 
     input [4:0] data_len ;  // max 18
	 input [143 :0] data_vector ; 
	 integer i ; 

     begin
//	  j =0 ;	 
    #200 ;
	   `ifdef write_to_file
      $fdisplay(f_handle) ;
      $fdisplay(f_handle,  $time, ": I2C addr(8-bit) writing Burst at 0x%h", salve_addr);	
	//  $fdisplay(f_handle,  $time, ": Writing I2C Register at 0x%h", i2c_reg);
   `endif 	
     $display() ;
     $display($time,": I2C addr(8-bit) writing Burst at 0x%h", salve_addr);	
 //    $display($time,": Writing I2C Register at 0x%h", i2c_reg);
      start_proc;						
  //    write_i2c_nostop(salve_addr, i2c_reg);
       write_i2c_nostop2(salve_addr );
	  for ( i = 0 ; i < data_len ; i = i +1 ) 
	   begin 
		case (i) 
          0:  write_i2c_repeat(data_vector[7:0] );
          1:  write_i2c_repeat(data_vector[15:8] );			  
          2:  write_i2c_repeat(data_vector[23:16] );
          3:  write_i2c_repeat(data_vector[31:24] );	
          4:  write_i2c_repeat(data_vector[39:32] );
          5:  write_i2c_repeat(data_vector[47:40] );	
          6:  write_i2c_repeat(data_vector[55:48] );
          7:  write_i2c_repeat(data_vector[63:56] );
          8:  write_i2c_repeat(data_vector[71:64] );
          9:  write_i2c_repeat(data_vector[77:72] ) ;		  
          10:  write_i2c_repeat(data_vector[85:78]);
          11:  write_i2c_repeat(data_vector[93:86]);
          12:  write_i2c_repeat(data_vector[101:94] );
          13:  write_i2c_repeat(data_vector[109:102]);
          14:  write_i2c_repeat(data_vector[117:110]);	 
          15:  write_i2c_repeat(data_vector[127:118]);	
          16:  write_i2c_repeat(data_vector[135:128]);
          17:  write_i2c_repeat(data_vector[143:136]);  
        default: 	 write_i2c_repeat(data_vector[7:0]) 	;  
        endcase    
	//    j = j+8 ;
	   end 
	  
    //  write_i2c_repeat(wr_1_data);
   //   write_i2c_repeat(wr_2_data);	  
      stop_proc;
   `ifdef write_to_file
 	 $fdisplay( f_handle," task - burst_write end ") ; 
   `endif 	 
 	 $display( " task - burst_write end ") ;    
    end
    endtask
 //-------------------------

 task  burst_read ;
	 input [7:0] salve_addr ;
//	 input [7:0] i2c_reg ;	 
     input [4:0] data_len ;  // max 17
	 integer i ;
	 
	begin
   `ifdef write_to_file
      $fdisplay(f_handle) ;
      $fdisplay(f_handle,  $time,": I2C addr(8-bit) random burst read at Addr 0x%h", salve_addr);
	//  $fdisplay(f_handle,  $time,": Reading I2C Register starting at 0x%h", i2c_reg); 
   `endif 	
	
	$display() ;
   $display($time,": I2C addr(8-bit) random burst read at Addr 0x%h", salve_addr);
  //   start_proc;
  //   write_i2c_nostop(salve_addr,i2c_reg);	
 //  $display($time,": Reading I2C Register starting at 0x%h", i2c_reg); 
 //    wr_i2c_ack;
 //     #(clk_cycle);
      start_proc;	
      read_i2c_nostop( {salve_addr[7:1], 1'b1}  );
      for ( i = 1 ; i < data_len ; i = i +1 ) 
	      begin 
			read_i2c_ack; 
			read_i2c_repeat;
		  end
	   stop_proc;	 
   `ifdef write_to_file
 	 $fdisplay( f_handle," task - burst_read end ") ; 
   `endif 		   
      $display( " task - burst_read end ")  ; 		   
	  end
    endtask	

 task  burst_read_w_restart ;   
	 input [7:0] salve_addr ;
//	 input [7:0] i2c_reg ;	 
     input [4:0] data_len ;  // max 17
	 integer i ;
	 
	begin
   `ifdef write_to_file
      $fdisplay(f_handle) ;
      $fdisplay(f_handle,  $time,": I2C addr(8-bit) random burst read at Addr 0x%h", salve_addr);
	//  $fdisplay(f_handle,  $time,": Reading I2C Register starting at 0x%h", i2c_reg); 
   `endif 	
	
	$display() ;
   $display($time,": I2C addr(8-bit) random burst read at Addr 0x%h", salve_addr);
     start_proc;
     write_i2c_nostop2(salve_addr );	
 //  $display($time,": Reading I2C Register starting at 0x%h", i2c_reg); 
    wr_i2c_ack;
      #(clk_cycle);
      start_proc;	
      read_i2c_nostop( {salve_addr[7:1], 1'b1}  );
      for ( i = 1 ; i < data_len ; i = i +1 ) 
	      begin 
			read_i2c_ack; 
			read_i2c_repeat;
		  end
	   stop_proc;
   `ifdef write_to_file
 	 $fdisplay( f_handle," task - burst_read_w_restart end ") ; 
   `endif 		   
      $display(" task - burst_read_w_restart end ") ; 	   
	  end
    endtask		
	
  //------------------------- 
  //-------------------------
   task random_write ;
    input [7:0] i2c_reg ; 
	input [7:0] wr_1_data ;
	input [7:0] wr_2_data ;
     begin
    #200 ;
	`ifdef write_to_file
      $fdisplay(f_handle) ;
      $fdisplay(f_handle,  $time, ": Writing I2C Register at %h", i2c_reg);	 
   `endif 
	
     $display($time,": Writing I2C Register at %h", i2c_reg);
      start_proc;						
      write_i2c_nostop(wr_a_addr,i2c_reg);
      write_i2c_repeat(wr_1_data);
      write_i2c_repeat(wr_2_data);	  
      stop_proc;
    end
    endtask
	
   task random_read ;
    input [7:0] i2c_reg ; 
     begin
    #200 ;
   `ifdef write_to_file
      $fdisplay(f_handle) ;
      $fdisplay(f_handle,  $time, ": Writing I2C Register to read from %h", i2c_reg);	 
	  $fdisplay(f_handle,  $time, ": Reading I2C Register starting at %h", i2c_reg); 
   `endif 
	
      //random read (change direction) one data
      $display($time,": Writing I2C Register to read from %h", i2c_reg);	  
      start_proc;
      write_i2c_nostop(wr_a_addr,i2c_reg);			// write address
  //    $display();
      $display($time,": Reading I2C Register starting at %h", i2c_reg); 
      wr_i2c_ack;
      #(clk_cycle);
      start_proc;						                      // read back with Repeat Start
      read_i2c_nostop(rd_a_addr );
       read_i2c_ack;   // read second data
       read_i2c_repeat;
      stop_proc;
    end
    endtask	
//-------
 task  random_burst_read ;
	 input [7:0] salve_addr ;
	 input [7:0] i2c_reg ;	 
     input [4:0] data_len ;  // max 17
	 integer i ;
	 
	begin
   `ifdef write_to_file
      $fdisplay(f_handle) ;
      $fdisplay(f_handle,  $time,": I2C addr(8-bit) random burst read at Addr 0x%h", salve_addr);
	  $fdisplay(f_handle,  $time,": Reading I2C Register starting at 0x%h", i2c_reg); 
   `endif 	
	
	$display() ;
   $display($time,": I2C addr(8-bit) random burst read at Addr 0x%h", salve_addr);
     start_proc;
     write_i2c_nostop(salve_addr,i2c_reg);	
   $display($time,": Reading I2C Register starting at 0x%h", i2c_reg); 
     wr_i2c_ack;
      #(clk_cycle);
      start_proc;	
      read_i2c_nostop( {salve_addr[7:1], 1'b1}  );
      for ( i = 1 ; i < data_len ; i = i +1 ) 
	      begin 
			read_i2c_ack; 
			read_i2c_repeat;
		  end
	   stop_proc;	 
      $display( " task - random_burst_read end ")  ; 	   
	  end
    endtask	
//--------------------
   // Reset the chip

   task init_chip;                
      begin
         XRESET    <= #1 1'b1;
         sda_reg   <= #1 1'b1;
         scl_reg   <= #1 1'b1;
         scl_enable <= #1 1'b0;
         #reset_delay;
         XRESET    <= #1 1'b0;
      end

   endtask

   //---------------------------------------------------------------------
   // start process
   task start_proc;
      begin
         #(clk_cycle/4);                         // middle of clock
         sda_reg    <= #1 1'b0;	                 // start 
         scl_enable <= #1 1'b1;                  // start scl clock
      end
   endtask    

   //--------------------------------------------------------------------
   // stop process
   task stop_proc;                	
      begin         
         @(negedge scl_reg);                     // nack           
         @(negedge scl_reg);                     // stop
         #(clk_cycle/4);                         // middle of clock
         sda_reg <= #1 1'b0;
         @(posedge scl_reg);                     // stop
         #(clk_cycle/4);                         // middle of clock
         sda_reg <= #1 1'b1;
         scl_enable <= #1 1'b0;                  // stop the scl clock
         #(cycle_end);                            
      end			
   endtask
   
   //--------------------------------------------------------------------
//  task scl_ready;
//     begin
//       @(posedge scl_oe);
//     	scl_enable <= 1'b0;   	
//       @(negedge scl_oe);
//     end
//  endtask  
      
   //--------------------------------------------------------------------
   task read_i2c_ack;
      begin
         @(negedge scl_reg);                     // ack      
         #(clk_cycle/4);  
         sda_reg <= 1'b0;                        // tri-state    
         @(posedge scl_reg);                     // ack   
         @(negedge scl_reg);   
         #(clk_cycle/4);
         sda_reg <= 1'b1;
      end
   endtask      

   //--------------------------------------------------------------------
   task read_i2c_nack;
      begin
         @(negedge scl_reg);                     // ack       
         sda_reg <= #1 1'b1;                     // tri-state    
         @(posedge scl_reg);                     // ack   
      end
   endtask    

   // -------------------------------------------------------------------
   task wr_i2c_ack;
      begin
         @(negedge scl_reg);                     // ack 
         #(clk_cycle/4); 
         sda_reg <= #1 1'b1;                     // tri-state
         @(posedge scl_reg);                     // ack        
      end 
   endtask    

   //--------------------------------------------------------------------
   // i2c read tasks
   
   task read_i2c_nostop;

      input   [7:0]   address;
      reg     [7:0]   rd_reg;
      integer         i;

      begin
         
         for (i = 7; i >= 0; i = i - 1) begin     // address
            @(negedge scl_reg);
            #(clk_cycle/4);                       // middle of clock
            sda_reg <= #1 address[i];
         end                               
         
         sda_reg <= #1 1'b1;                      // tri-state        
         @(negedge scl_reg);                      // ack           
         @(posedge scl_reg);                      // ack           
         
         for (i = 7; i >= 0; i = i - 1) begin     // data
    	    @(posedge scl_reg);
            rd_reg[i] <= #1 sda;
         end                               
    `ifdef write_to_file
     #2  $fdisplay(f_handle,  $time, ": Data Read = %h",rd_reg);	 
   `endif      
         #2 $display($time,": Data Read = %h",rd_reg);
      end 
      
   endtask  


   task read_i2c_repeat;
      reg     [7:0]   rd_reg;
      integer         i;

      begin

         sda_reg<= #1 1'b1; 
         for (i = 7; i >= 0; i = i - 1) begin     // data
            @(posedge scl_reg);
            rd_reg[i] <= #1 sda;
         end                               
    `ifdef write_to_file
     #2  $fdisplay(f_handle,  $time, ": Data Read = %h",rd_reg);	 
   `endif        
         #2 $display($time,": Data Read = %h",rd_reg);
      end 
      
   endtask    


   //---------------------------------------------------------------------
   // i2c write tasks
   
   task write_i2c;                    
    input   [7:0]   data;
    integer         j;   
    begin
    
    #(clk_cycle/4);
    sda_reg <= #1 data[7];
    #(clk_cycle/4);
    scl_enable <= 1'b1;
    for (j = 6; j >= 0; j = j - 1) begin     // data
    @(negedge scl_reg)
    #(clk_cycle/4);                          // middle of clock
    sda_reg <= #1 data[j];
    end 
	
    `ifdef write_to_file
     #2  $fdisplay(f_handle,  $time, ": Data Write = %h",data);	 
   `endif    
    #2 $display($time,": Data Write = %h",data);	
    end    
   endtask                           

   task write_i2c_nostop;                     
      input   [7:0]   address;
      input   [7:0]   data;
      integer         i,j;

      begin
         for (i = 7; i >= 0; i = i - 1) begin    // address
            @(negedge scl_reg);
            #(clk_cycle/4);                      // middle of clock
            sda_reg <= #1 address[i];
         end                               

         @(negedge scl_reg);                     // ack       
         #(clk_cycle/4)                          // added to avoid timing simulation glitch
         
         sda_reg <= #1 1'b1;                     // tri-state
         @(posedge scl_reg);                     // ack           
         
         for (j = 7; j >= 0; j = j - 1) begin    // data
            @(negedge scl_reg)
              #(clk_cycle/8);                     // middle of clock
            sda_reg <= #1 data[j];
         end  
      end 		
   endtask
   
    task write_i2c_nostop2;                     
      input   [7:0]   address;
  //    input   [7:0]   data;
      integer         i,j;

      begin
         for (i = 7; i >= 0; i = i - 1) begin    // address
            @(negedge scl_reg);
            #(clk_cycle/4);                      // middle of clock
            sda_reg <= #1 address[i];
         end                               

   //      @(negedge scl_reg);                     // ack       
   //      #(clk_cycle/4)                          // added to avoid timing simulation glitch
         
   //      sda_reg <= #1 1'b1;                     // tri-state
   //      @(posedge scl_reg);                     // ack           
         
  //       for (j = 7; j >= 0; j = j - 1) begin    // data
  //          @(negedge scl_reg)
  //            #(clk_cycle/8);                     // middle of clock
  //          sda_reg <= #1 data[j];
  //       end  
      end 		
   endtask  

   task write_i2c_repeat;                
      input   [7:0]   data;
      integer         i,j;

      begin
         @(negedge scl_reg);                      // ack   
         #(clk_cycle/4);     
         sda_reg <= #1 1'b1;                      // tri-state
         @(posedge scl_reg);                      // ack          
         
         for (j = 7; j >= 0; j = j - 1) begin     // data
            @(negedge scl_reg)
             #(clk_cycle/8);
            sda_reg <= #1 data[j];
         end 
    `ifdef write_to_file
     #2  $fdisplay(f_handle,  $time, ": Data Write = %h",data);	 
   `endif		 
	    #2 $display($time,": Data Write = %h",data);	                                     
      end 		
   endtask


endmodule





