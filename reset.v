module reset(
    input clk_1Hz,
    input button_rst,
    output reg pc_rst,
    output reg clk_rst
);
    reg [2:0]conter=2'd0;
    initial 
    begin
        conter<=2'd0;
        pc_rst<=1'b1;
        clk_rst<=1'b1; 
    end
    always@(posedge clk_1Hz or negedge button_rst) 
    begin
        if(button_rst==1'b0)
        begin
            conter<=2'd0;
            pc_rst<=1'b1;
            clk_rst<=1'b1;
        end
        else
        begin 
            if(conter>=2'd1)
                pc_rst<=1'b0;
            else
                pc_rst<=1'b1;
            if(conter>=2'd2)
                clk_rst<=1'b0;
            else
            begin
                clk_rst<=1'b1;
                conter<=conter+2'd1;
            end
        end
        

    end
endmodule