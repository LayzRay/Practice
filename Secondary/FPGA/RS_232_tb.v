`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2022 14:25:54
// Design Name: 
// Module Name: RS_232_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RS_232_tb();

    reg CLK;
    parameter PERIOD = 20;

   always begin
      CLK = 1'b0;
      #(PERIOD/2) CLK = 1'b1;
      #(PERIOD/2);
   end
   
   reg [1:0] KEY;
   wire tx;
   
   RS_232 RS (.CLOCK_50(CLK),.KEY(KEY),.UART_TXD(tx));
   
   initial begin
   
        KEY <= 2'b10;
        #100;
        KEY <=2'b01;
        #30;
        KEY <= 2'b11;
   
   end

endmodule
