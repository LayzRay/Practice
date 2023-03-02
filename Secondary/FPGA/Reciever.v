module Reciever #( parameter FREQUENCY = 32'd50_000_000, SPEED = 32'd9600 ) (

    input               CLK_i,
                        Reset_i,
    
                        Rx_i,
    
    output  reg         data_ready_o,
            reg [ 7:0 ] data_o    

);

    parameter DIVIDER = FREQUENCY/SPEED;
    										  
    parameter IDLE = 2'b00; 			
    parameter StartBit = 2'b01;		
    parameter DataBit = 2'b10;		
    parameter StopBit = 2'b11;      

////////////////////////////////////////
    
    reg CLK_low;
    
    reg [ 1:0 ] State;
    reg [ 3:0 ] BitCount; 
    reg [ 31:0 ] TickCount;  
    reg [ 7:0 ] data_reg; 

////////////////////////////////////////
	 
    initial begin
    
        State = IDLE;
       
        BitCount = 4'd0;
        TickCount = 32'd0;
        
        data_ready_o = 1'b0;
        data_o = 8'd0;
        
    end
	 
////////////////////////////////////////

    always @( posedge CLK_i or posedge Reset_i ) begin
    
        if ( Reset_i ) begin
       
            State <= IDLE;
       
            BitCount <= 4'd0;
            TickCount <= 32'd0;
            
            data_ready_o <= 1'b0;
            data_o <= 8'd0;
        
        end else begin
        
            TickCount <= ( TickCount < DIVIDER ) ? TickCount + 32'd1 : 32'd0;		  
			CLK_low <= ( TickCount == 32'd0 );	
			
            case ( State )
            
                IDLE: State <= !Rx_i ? StartBit : State;
                
                StartBit: State <= CLK_low ? DataBit : State;
                
                DataBit: 
                
                    if ( CLK_low ) begin
                        
                        data_reg[ BitCount ] <= Rx_i;
                         
                        BitCount <= BitCount + 4'd1;
                
                        if ( BitCount == 4'd8 ) begin
                    
                            BitCount <= 4'd0;
                            State <= StopBit;
                
                        end
                                   
                    end
                
                StopBit: 
                
                    if ( CLK_low ) begin
                    
                        data_o <= data_reg;
                        data_ready_o <= 1'b1;
                        
                        State <= IDLE;
                        
                    end
                
                default: State <= IDLE;
                                
            endcase 
    
        end
    
    end

endmodule