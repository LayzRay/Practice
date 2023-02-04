module Reciever #(parameter FREQUENCY = 32'd50_000_000, SPEED = 32'd9600) (

    input CLK_i,
    input reset_i,
    
    input Rx_i,
    
    
    output reg data_ready_o,
    output reg [7:0] data_o    

);

    parameter Divider = FREQUENCY/SPEED;										  
    parameter Idle = 2'b00; 			
    parameter StartBit = 2'b01;		
    parameter DataBit = 2'b10;		
    parameter StopBit = 2'b11;      

////////////////////////////////////////
    
    reg [1:0] state;
    reg [3:0] bitCount; 
    reg [31:0] tickCount; 
    reg CLK_low; 
    reg [7:0] data_reg; 

////////////////////////////////////////
	 
    initial begin
    
        state <= Idle;
       
        bitCount <= 4'd0;
        tickCount <= 32'd0;
        
        data_ready_o <= 1'b0;
        data_o <= 8'd0;
        
    end
	 
////////////////////////////////////////

    always @( posedge CLK_i or posedge reset_i ) begin
    
        if ( reset_i ) begin
       
            state <= Idle;
       
            bitCount <= 4'd0;
            tickCount <= 32'd0;
            
            data_ready_o <= 1'b0;
            data_o <= 8'd0;
        
        end else begin
        
            if ( tickCount != Divider) tickCount <= tickCount + 32'd1;
			else tickCount <= 32'd0;
					  
			CLK_low <= (tickCount == 32'd0);
			
			
            case ( state )
            
                Idle: begin if ( Rx_i ) begin
                    
                        data_ready_o <= 1'b0;
                        data_o <= 8'd0;
                    
                    end else state <= StartBit;
                
                end
                
                StartBit: if ( CLK_low ) state <= DataBit;
                
                DataBit: if ( CLK_low ) begin
                    
                        data_reg[bitCount] <= Rx_i; 
                        bitCount <= bitCount + 4'd1;
                        
                        if ( bitCount == 4'd8 ) begin
                            
                            bitCount <= 4'd0;
                            state <= StopBit;
                        
                        end
                    
                    end
                
                StopBit: if ( CLK_low ) begin
                
                    data_o <= data_reg;
                    data_ready_o <= 1'b1;
                    
                    state <= Idle;
                    
                end
                
                default: state <= Idle;
                                
            endcase 
    
        end
    
    end

endmodule