module System_regs(

    input            WE_i,
    
           [ 7:0  ]  address,
           [ 31:0 ]  data_i,
           
    output reg [ 31:0 ]  data_o
            
    );
    
    reg [ 31:0 ] Speed_Reg,
                 Period_Reg,
                 Data_Reg;         
                 
    always @( * )
    
        case ( address )
        
            8'h00: begin
            
                Speed_Reg <= WE_i ? data_i : Speed_Reg;
                data_o <= Speed_Reg;
             
            end
            
            8'h01: begin
            
                Speed_Reg <= WE_i ? data_i : Period_Reg;
                data_o <= Period_Reg;
             
            end
            
            8'h02: begin
            
                Data_Reg <= WE_i ? data_i : Data_Reg;
                data_o <= Data_Reg;
             
            end
            
            default: begin
            
                Speed_Reg <= Speed_Reg;
                Period_Reg <= Period_Reg;
                data_o <= 32'dZ;
                
            end
        
        endcase
       
endmodule
