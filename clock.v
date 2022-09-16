module clock(
    input sw_clk,
    input clock_50MHz,
    input en,
    output reg clock_main,
    output reg clock_1Hz
);
    reg [31:0]conter_main;
    reg [31:0]conter_1Hz;
    initial 
    begin
        clock_1Hz=1'b0;
        clock_main=1'b1;
        conter_main=32'd0; 
        conter_1Hz=32'd0; 
    end
    always@(posedge clock_50MHz)
    begin
        if(en==1'b0)
        begin
            conter_main<=32'd0;
            clock_main<=1'b1;
        end
        else if((sw_clk==1'b0 && conter_main>=32'd25) || (sw_clk==1'b1 && conter_main>=32'd25000000))
        begin
            clock_main<=~clock_main;
            conter_main<=32'd0;
        end
        else
            conter_main<=conter_main+32'd1;
    end

    always@(posedge clock_50MHz) 
    begin
        if(conter_1Hz>=32'd25000000)
        begin
            conter_1Hz<=32'd0;
            clock_1Hz<=~clock_1Hz;
        end
        else
            conter_1Hz<=conter_1Hz+32'd1;
    end

endmodule