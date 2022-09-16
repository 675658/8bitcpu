module alu(
    input clk,
    input en,
    input[7:0]a,
    input[7:0]b,
    input[2:0]op,
    output [7:0]e,
    output reg[7:0]flag
);
    reg [8:0]y;
    assign e=y[7:0];
    always@(a or b or op)
    begin
        case(op)
        3'b000:begin y=a+b+9'b0;end//add	
        3'b001:begin y=a-b+9'b0;end//sub
        3'b010:begin y=a&b+9'b0;end//and
        3'b011:begin y=a|b+9'b0;end//or
        3'b100:begin y=~a;end//not
        3'b101:begin y=a^b+9'b0;end//xor
        3'b110:begin y=a<<b+9'b0;end//shl
        3'b111:begin y=a>>b+9'b0;end//shr
        endcase
    end
    always@(negedge clk) 
    begin
        if(en==1'b1)
        begin
            flag[0]<=(y==9'b0)?1'b1:1'b0;
            flag[1]<=y[7];
            flag[2]<=y[8];
        end
    end
endmodule