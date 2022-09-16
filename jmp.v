module jmp(
    input clk,
    input en,
    input [2:0]op,
    input [7:0]pc,
    input [7:0]addr,
    input [7:0]flag,
    output reg [7:0]pc_inc,
    output reg [7:0]next_pc
);
    always@(pc)
    begin
        pc_inc<=pc+8'b1;
    end
    always@(negedge clk)
    begin
        next_pc<=pc+8'b1;
        if(en==1'b1)
        begin
            case(op)
                3'b000:next_pc<=addr;//jmp
                3'b001:begin if(flag[0]==1'b1 && flag[2]==1'b0) next_pc<=addr;end//je
                3'b010:begin if(flag[0]==1'b0) next_pc<=addr;end//jne
                3'b011:begin if(flag[0]==1'b0 && flag[2]==1'b0) next_pc<=addr;end//ja
                3'b100:begin if(flag[0]==1'b0 && flag[2]==1'b1) next_pc<=addr;end//jb
                3'b101:begin if(flag[0]==1'b1) next_pc<=addr;end//jc
                3'b110:begin if(flag[0]==1'b0) next_pc<=addr;end//jnc
            endcase
        end
    end
endmodule