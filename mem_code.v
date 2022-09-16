module mem_code(
    input en,
    input sign_rw,//chose
    input [7:0]addr,//pc
    input [15:0]buf_w,//write cache
    output [15:0]buf_r//read cache
);
    integer i;
    reg [15:0]mem[256];//procedure
    initial 
    begin
        $readmemb("code.bin",mem); 
    end
    always@(posedge en)
    begin
        if(en==1'b1)
        begin
            if(sign_rw==1'b1)
                mem[addr]<=buf_w;
        end
    end
    assign buf_r=(sign_rw==1'b0)?mem[addr]:16'd0;
endmodule