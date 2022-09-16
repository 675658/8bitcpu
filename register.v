module register(
    input clk,
    input [7:0]buf_w1,
    input [7:0]buf_w2,
    input r_En,
    input w_En,
    input [2:0]addr_r1,
    input [2:0]addr_r2,
    input [2:0]addr_w1,
    input [2:0]addr_w2,
    output [7:0]buf_r1,
    output [7:0]buf_r2
);
    reg [7:0]registers[8];
	 
	integer i;
	 
    initial 
    begin
       for(i=0;i<8;i=i+1)
           registers[i]<=8'd0;    
    end
    always@(negedge clk)
    begin
		  if(clk==1'b0 && w_En==1'b1)
		  begin
				registers[addr_w1]<=buf_w1;
				registers[addr_w2]<=buf_w2;
		  end
    end
	 assign buf_r1=(r_En==1'b1)?registers[addr_r1]:8'd0;
	 assign buf_r2=(r_En==1'b1)?registers[addr_r2]:8'd0;

endmodule