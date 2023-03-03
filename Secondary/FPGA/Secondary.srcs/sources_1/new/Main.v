`define CLK         sysclk
`define UART_Tx     uart_txd_out
`define UART_Rx     uart_txd_in
`define BUTTON      btn

module Main(

	input          `CLK,
	
	       [ 1:0 ] `BUTTON,
	
	               `UART_Rx,
	
	output         `UART_Tx


    );
    
/////////////Main parameteres/////////////////////////////////
   
   parameter FREQUENCY =        32'd50_000_000;
   parameter SPEED =            32'd9600;
   parameter FOLLOW_UP_PERIOD = 32'd1000;
    
   parameter PERIOD_PULSES =    FREQUENCY/FOLLOW_UP_PERIOD;
   parameter DIVIDER =          FREQUENCY/SPEED;
	
//////////////////////////////////////////////////////////////

	reg [ 7:0 ] FrameToSend;
	reg DataReadyTx;
	wire ReadyToSend;
	
	Transmitter #( FREQUENCY, SPEED ) Tx (
		
		.CLK_i        ( `CLK        ),
		.Reset_i      ( !`BUTTON    ),
		
		.data         ( FrameToSend ),
		.dataReady    ( DataReadyTx   ),
		.Tx           ( `UART_Tx    ),
		.ReadyToSend  ( ReadyToSend )
		
		
	);
	
	reg [ 7:0 ] RecievedFrame;
	reg DataReadyRx;
	
	Reciever #( FREQUENCY, SPEED ) Rx (
		
		.CLK_i            ( `CLK          ),
		.Reset_i          ( !`BUTTON      ),
		
		.Rx_i             ( `UART_Rx      ),
		
		.data_ready_o     ( DataReadyRx     ),
		.data_o           ( RecievedFrame )
		
	);
	
	reg WE;
	
	System_regs SR (
	
	   .WE_i( WE ),
	
	   .address_i( buffer[ 7:0 ] ),
	   .data_i( buffer[ 39:8 ] ),
	   
	   .data_o()
	
	);
	
	reg [ 39:0 ] buffer;
	reg [ 2:0 ] BitCount;
	
	initial begin
	
	   BitCount = 3'd0;
	   WE = 1'd0;
	
	end
	
	always @( posedge `CLK ) begin
	
	   if ( DataReadyRx ) begin
	   
	       case ( BitCount )
	       
	           3'd0: buffer[ 7:0 ] <= RecievedFrame;
	           3'd1: buffer[ 15:8 ] <= RecievedFrame;
	           3'd2: buffer[ 23:16 ] <= RecievedFrame;
	           3'd3: buffer[ 31:24 ] <= RecievedFrame;
	           3'd4: buffer[ 39:32 ] <= RecievedFrame;
	           
	           default: buffer <= buffer;
	           	       
	       endcase
	       
	       if ( BitCount < 3'd5 ) begin
	       
	           BitCount <= BitCount + 3'd1;
	           WE <= 1'd1;
	           
	       end else begin
	       
	           BitCount <= 3'd0;
	           WE <= 1'd1;
	       
	       end
    
	    end
	       	
	end
    
endmodule
