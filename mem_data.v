module mem_data(
    input clk,
    input en,
    input sign_rw,
    input [7:0]addr,
    input [7:0]buf_w,
    input [15:0]sw,
    output [15:0]led,
    output [7:0]buf_r
);
    integer i;
    reg [7:0]mem[256];
    initial 
    begin
        for(i=0;i<256;i=i+1)
            mem[i]<=8'd0;
    end
    always@(negedge clk)
    begin
        if(en==1'b1)
        begin
            if(clk==1'b0 && sign_rw==1'b1)
            begin
                mem[addr]<=buf_w;
            end
        end
        mem[252]<=sw[7:0];
        mem[253]<=sw[15:8];
        
    end
    assign buf_r= (sign_rw==1'b0 && en==1'b1)?mem[addr]:8'd0;
    assign led[15:8]=mem[255];
    assign led[7:0]=mem[254];
endmodule