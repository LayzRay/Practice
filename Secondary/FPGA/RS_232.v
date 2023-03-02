`define CLK         sysclk
`define UART_Tx     uart_txd_out
`define UART_Rx     uart_txd_in
`define BUTTON      btn

module RS_232 (

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
	reg dataReady;
	wire ReadyToSend;
	
	Transmitter #( FREQUENCY, SPEED ) Tx (
		
		.CLK_i        ( `CLK        ),
		.Reset_i      ( !`BUTTON    ),
		
		.data         ( FrameToSend ),
		.dataReady    ( dataReady   ),
		.Tx           ( `UART_Tx    ),
		.ReadyToSend  ( ReadyToSend )
		
		
	);
	
	reg [ 7:0 ] RecievedFrame;
	
	Reciever #( FREQUENCY, SPEED ) Rx (
		
		.CLK_i            ( `CLK          ),
		.Reset_i          ( !`BUTTON      ),
		
		.Rx_i             ( `UART_Rx      ),
		
		.data_ready_o     ( dataReady     ),
		.data_o           ( RecievedFrame )
		
	);
	
///////Service VAR/////////////////////////////////////
	
	reg CLK_low;
    
    reg [ 2:0 ] state;
	//reg first_frame;
	
	reg [ 31:0 ] tickCount;
	
	reg KEY_presssed;
	reg [ 2:0 ] sync_reg;
	
///////////FSM Parameteres/////////////
	
	parameter IDLE = 3'b000;
	parameter DATA_READY = 2'b001;
	parameter TRANSFER = 2'b10;
	parameter READY_TO_SEND = 2'b11;
	
//////////Begining/////////////////////	
	
	initial begin
	   
	   state <= IDLE;
	   first_frame <= 1'b1;
	   
	   tickCount <= 32'd0;
	   KEY_presssed <= 1'b0;
	   sync_reg <= 3'd0;
	   
	end
	
	always @( posedge `CLK or negedge `BUTTON[0] ) begin
	
        if ( !`BUTTON[0] ) begin
       
			  state <= IDLE;
			  dataReady <= 1'b0; 
			  first_frame <= 1'b1; 
			  tickCount <= 32'd0;
			  KEY_presssed <= 1'b0;
			  sync_reg <= 3'd0;
        
      end else begin
		
		  if ( tickCount != Divider) tickCount <= tickCount + 32'd1;
          else tickCount <= 32'd0;
              
          CLK_low <= (tickCount == 32'd0);
		  
		  sync_reg[2] <= !`BUTTON[1];
		  sync_reg[1] <= sync_reg[2];
		  sync_reg[0] <= sync_reg[1];
		
		  KEY_presssed <= sync_reg[1] & ( !sync_reg[0] );
			
			//if ( KEY_presssed && (data_counter == 4'd0) ) begin
					
				//data_to_code <= Read_data;
				//data_counter <= data_counter + 1;
				
				dataReady <= 1'b1;
				state <= DATA_READY;
				
		   //end
			
			if ( CLK_low ) begin

            case ( state )
        
            IDLE: begin
                
                     if ( 
                            
            end
            
            DATA_READY: begin
            
                //if ( first_frame ) frame <= package[15:8];
               // else if (data_counter != 4'd2) frame <= package[7:0];
				//	 else frame <= package[7:0] ^ error;
                
                dataReady <= 1'b0;
                state <= Transfer;
                        
            end
            
            Transfer: begin
            
                if ( ReadyToSend ) state <= READY_TO_SEND;
             
            end
            
            READY_TO_SEND: begin

                     if ( first_frame ) begin
                     
                         first_frame <= 1'b0;
                         dataReady <= 1'b1;
                         state <= DATA_READY;
                         
                     end else state <= IDLE;
                     
                end
        
            endcase
			end	
		end
		end
	
endmodule