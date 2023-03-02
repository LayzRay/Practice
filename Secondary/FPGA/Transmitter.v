module Transmitter #( parameter FREQUENCY = 32'd50_000_000, SPEED = 32'd15_000_00 ) (

    input CLK_i,
    
    input Reset_i,
    
    input dataReady, 
    input [7:0] data, 
    
    output reg Tx, 
    output reg ReadyToSend

);

    //////////Parameters//////////////////////
    
    parameter Divider = FREQUENCY/SPEED;                                               
    parameter Idle = 2'b00; 			
    parameter StartBit = 2'b01;		
    parameter DataBit = 2'b10;		
    parameter StopBit = 2'b11;      
    
    //////////////////////
    
    reg [1:0] state;
    reg [3:0] bitCount; 
    reg [31:0] tickCount; 
    reg CLK_low;  
       
    ////////////////////////////////////////
    
    initial begin
    
        state <= Idle;
        
        ReadyToSend <= 1'b1;
        
        bitCount <= 4'd0;
        tickCount <= 32'd0;
    
    end
    
    ////////////////////////////////////////
    
    always @( posedge CLK_i or posedge Reset_i ) begin
    
        if ( Reset_i ) begin 
        
            state <= Idle;
            
            ReadyToSend <= 1'b1;
            
            bitCount <= 4'd0;
            tickCount <= 32'd0;
        
        end else begin
        
            if ( tickCount < Divider) tickCount <= tickCount + 32'd1;
            else tickCount <= 32'd0;
            
            CLK_low <= (tickCount == 32'd0);
            
            if ( CLK_low )
            
                case ( state )
                
                    Idle: begin
                    
                        Tx <= 1'b1;
                         
                        if ( dataReady ) begin
                        
                            ReadyToSend <= 1'b0;
                            state <= StartBit;
                        
                        end else begin
                        
                            ReadyToSend <= 1'b1;
                            state <= state;		
                        
                        end
                    end
                    
                    StartBit: begin
                    
                        Tx <= 1'b0;         
                        state <= DataBit;
                    
                    end
                    
                    DataBit: begin
                    
                        bitCount <= bitCount + 1;
                        
                        if (bitCount == 4'b1000) begin
                        
                        bitCount <= 4'd0;
                        state <= StopBit;
                                
                        end else Tx <= data[bitCount];
                    
                    end
                    
                    StopBit: begin
                    
                    Tx <= 1'b1;
                    ReadyToSend <= 1'b1;
                    
                    state <= Idle;
                          
                    end
                    
                    default: state <= Idle;
                
                endcase
        end
    end

endmodule
