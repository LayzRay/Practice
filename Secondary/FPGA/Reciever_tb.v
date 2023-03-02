`timescale 1ns / 1ps

module Reciever_tb();

   reg CLK;
   
   parameter PERIOD = 20;

   always begin
      CLK = 1'b0;
      #(PERIOD/2) CLK = 1'b1;
      #(PERIOD/2);
   end
   
    wire [7:0] data;
    wire data_ready;
    reg Rx;
    reg reset;
    
    Reciever R (
    
        .CLK_i(CLK),
        .data_o(data),
        .data_ready_o(data_ready),
        .reset_i(reset),
        .Rx_i(Rx)
    );
    
    
    initial begin
    
        Rx <= 1;
        
        reset <= 1'b1;
        @( posedge CLK ); #1;
        reset <= 1'b0;
        #20;
        
        Rx = 0; #104210; //start
        
        Rx = 0; #104210;
        Rx = 1; #104210;
        Rx = 0; #104210;
        Rx = 1; #104210;
        
        Rx = 0; #104210;
        Rx = 1; #104210;
        Rx = 1; #104210;
        Rx = 0; #104210;
        
        Rx = 1; // Stop
        
    end
   
endmodule
