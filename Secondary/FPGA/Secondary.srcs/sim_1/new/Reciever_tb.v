`timescale 1ns / 1ps

module Reciever_tb (  );

    reg CLK_tb;
    
    parameter PERIOD = 20;

    always begin
    
      CLK_tb = 1'b0;
      #(PERIOD/2) CLK_tb = 1'b1;
      #(PERIOD/2);
      
    end
    
    parameter FREQUENCY = $pow( PERIOD, -1 ) * $pow( 10, 9 );
    parameter SPEED = 32'd9600;
    
    parameter DIVIDER = FREQUENCY/SPEED;
    
    reg BUTTON_tb,
        UART_Rx_tb;
        
    wire dataReady_tb,
         RecievedFrame_tb;

    Reciever #( FREQUENCY, SPEED ) Rx (
		
		.CLK_i            ( CLK_tb           ),
		.Reset_i          ( !BUTTON_tb       ),
		
		.Rx_i             ( UART_Rx_tb       ),
		
		.data_ready_o     ( dataReady_tb     ),
		.data_o           ( RecievedFrame_tb )
		
	);
	
	
	task Transfer;
	
	   input [ 7:0 ] frame_tb;
	   
	   integer i, j;
	   
	   begin
	   
	       @( posedge CLK_tb );
	       $display( "Начало отправки стартового бита: %0t ns", $realtime/1000 );
	       
	       UART_Rx_tb = 1'b0;
	       
	       i = 0;
	       while ( i <= DIVIDER ) begin
	       
	           i = i + 1;
	           @( posedge CLK_tb );
	           
	       end
	           
	       $display("Отправлен стартовый бит в момент времени %0t ns", $realtime/1000 );
	       
	       for ( j = 0; j < 8; j = j + 1 ) begin
	       
	           UART_Rx_tb = frame_tb[ j ];
	           
	           i = 0;
	           while ( i <= DIVIDER ) begin
	       
	               i = i + 1;
	               @( posedge CLK_tb );
	           
	           end
	           
	       end
	       
	       $display("Отправлен кадр момент времени %0t ns", $realtime/1000 );
	       
	       UART_Rx_tb = 1'b1;
	       
	   end
	
	endtask
	
	initial begin
	
	   UART_Rx_tb = 1'b1;
	
	   BUTTON_tb = 1'b0; 
	   #100;
	   
	   BUTTON_tb = 1'b1; 
	   #100;
	   
	   Transfer( 8'hA7 );
	   #100;
	   
	   Transfer( 8'h30 );
	   
	   $finish;
	
	end

endmodule
