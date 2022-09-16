module cpu(
    input clock_50MHz,

    input [15:0]sw,
    input sw_code_edit,
    input sw_clk,
    input button_next,
    input button_rst,
    input button_run,
    input button_hlt,
    output [15:0]led,
    output [7:0]led_flag,
    output led_code,
    output led_clk,
    output led_clock,
    output [7:0]seg_0,
    output [7:0]seg_1,
    output [7:0]seg_2,
    output [7:0]seg_3
);

    reg [7:0]code_pointer=8'b0000_0000;
    reg [7:0]mem_code_addr=8'b0000_0000;
    reg [7:0]pc=8'b0000_0000;
    reg flag_hlt_ext=1'b0;
    
    reg [7:0]mem_data_addr;
    reg [7:0]mem_data_buf_w;

    reg [7:0]alu_a;
    reg [7:0]alu_b;

    reg [7:0]reg_buf_w1;
    reg [7:0]reg_buf_w2;

    reg [7:0]jmp_addr;

    wire reset;

    wire pc_rst;
    wire clk_rst;
    
    wire clock_en;
    wire clk;
	 wire clk_1Hz;
    wire mem_code_en;
    wire [15:0]code;

    wire flag_hlt;
    wire a_en;
    wire m_en;
    wire r_en_r;
    wire r_en_w;
    wire j_en;
    wire [2:0]a_op;
    wire [2:0]j_op;
    wire mem_rw;
    wire [2:0]reg1;
    wire [2:0]reg2;
    wire [2:0]regw1;
    wire [2:0]regw2;
    wire [7:0]num;
    wire [7:0]alub;
    wire [1:0]mem_data_addr_selector;
    wire [1:0]mem_data_buf_w_selector;
    wire alu_a_selector;
    wire [1:0]alu_b_selector;
    wire [1:0]reg_buf_w1_selector;
    wire [1:0]reg_buf_w2_selector;
    wire [1:0]jmp_addr_selector;

    wire [7:0]mem_data_buf_r;

    wire [7:0]flag;
    wire [7:0]jmp_pc_inc;
    wire [7:0]jmp_next_pc;

    wire [7:0]reg_buf_r1;
    wire [7:0]reg_buf_r2;
    
    wire [7:0]alu_e;



    reset reset1(
        clk_1Hz,
        button_rst,
        pc_rst,
        clk_rst
    );
    clock clock_main(
        sw_clk,
        clock_50MHz,
        clock_en,
        clk,
        clk_1Hz
    );
    mem_code mem_code1(
        mem_code_en,
        sw_code_edit,
        mem_code_addr,
        sw,
        code
    );
    decoder decoder1(
        code,
        flag_hlt,
        a_en,
        m_en,
        r_en_r,
        r_en_w,
        j_en,
        a_op,
        j_op,
        mem_rw,
        reg1,
        reg2,
        regw1,
        regw2,
        num,
        alub,
        mem_data_addr_selector,
        mem_data_buf_w_selector,
        alu_a_selector,
        alu_b_selector,
        reg_buf_w1_selector,
        reg_buf_w2_selector,
        jmp_addr_selector
    );
    mem_data mem_data1(
        clk,
        m_en,
        mem_rw,
        mem_data_addr,
        mem_data_buf_w,
        sw,
        led,
        mem_data_buf_r
    );
    jmp jmp1(
        clk,
        j_en,
        j_op,
        pc,
        jmp_addr,
        flag,
        jmp_pc_inc,
        jmp_next_pc
    );
    register register1(
        clk,
        reg_buf_w1,
        reg_buf_w2,
        r_en_r,
        r_en_w,
        reg1,
        reg2,
        regw1,
        regw2,
        reg_buf_r1,
        reg_buf_r2
    );
    alu alu1(
        clk,
        a_en,
        alu_a,
        alu_b,
        a_op,
        alu_e,
        flag
    );
    assign led_clock=clk;
    assign led_code=sw_code_edit;
    assign led_clk=sw_clk;
    assign led_flag=flag;
    assign clock_en=~flag_hlt_ext & ~clk_rst;
    assign mem_code_en=~button_next;

    always@(pc or code_pointer or sw_code_edit)
    begin
        if(sw_code_edit==1'b1)
            mem_code_addr<=code_pointer;
        else
            mem_code_addr<=pc;
    end

    always@(negedge button_next or negedge button_rst)
    begin
        if(button_rst==1'b0)
            code_pointer<=8'd0;
		  else if(button_next==1'b0)
            code_pointer<=code_pointer+8'd1;
    end

    always@(negedge button_run or negedge button_hlt or posedge sw_code_edit)
    begin
        if(button_run==1'b0 || sw_code_edit==1'b1)
            flag_hlt_ext<=1'b0;
        else if(button_hlt==1'b0)
            flag_hlt_ext<=1'b1;
    end

    always@(posedge clk,posedge pc_rst)
    begin
        if(pc_rst==1'b1)
            pc<=8'b0000_0000;
        else if(clk==1'b1 && flag_hlt==1'b0)
            pc<=jmp_next_pc;
    end

    always@(mem_data_addr_selector or reg_buf_r1 or reg_buf_r2 or num or alu_e)
    begin
        case(mem_data_addr_selector)
            2'b00:mem_data_addr=reg_buf_r1;
            2'b01:mem_data_addr=reg_buf_r2;
            2'b10:mem_data_addr=num;
            2'b11:mem_data_addr=alu_e;
        endcase
    end

    always@(mem_data_buf_w_selector or jmp_pc_inc or reg_buf_r1 or reg_buf_r2 or num)
    begin
        case(mem_data_buf_w_selector)
            2'b00:mem_data_buf_w=jmp_pc_inc;
            2'b01:mem_data_buf_w=reg_buf_r1;
            2'b10:mem_data_buf_w=reg_buf_r2;
            2'b11:mem_data_buf_w=num;
        endcase
    end

    always@(alu_a_selector or reg_buf_r1 or reg_buf_r2)
    begin
        case(alu_a_selector)
            1'b0:alu_a=reg_buf_r1;
            1'b1:alu_a=reg_buf_r2;
        endcase
    end

    always@(alu_b_selector or reg_buf_r1 or reg_buf_r2 or num or alub)
    begin
        case(alu_b_selector)
            2'b00:alu_b=reg_buf_r1;
            2'b01:alu_b=reg_buf_r2;
            2'b10:alu_b=num;
            2'b11:alu_b=alub;
        endcase
    end

    always@(reg_buf_w1_selector or mem_data_buf_r or num or alu_e or reg_buf_r1)
    begin
        case(reg_buf_w1_selector)
            2'b00:reg_buf_w1=mem_data_buf_r;
            2'b01:reg_buf_w1=num;
            2'b10:reg_buf_w1=alu_e;
            2'b11:reg_buf_w1=reg_buf_r1;
        endcase
    end

    always@(reg_buf_w2_selector or mem_data_buf_r or num or alu_e or reg_buf_r2)
    begin
        case(reg_buf_w2_selector)
            2'b00:reg_buf_w2=mem_data_buf_r;
            2'b01:reg_buf_w2=num;
            2'b10:reg_buf_w2=alu_e;
            2'b11:reg_buf_w2=reg_buf_r2;
        endcase
    end

    always@(jmp_addr_selector or mem_data_buf_r or num or reg_buf_r1 or reg_buf_r2)
    begin
        case(jmp_addr_selector)
            2'b00:jmp_addr=mem_data_buf_r;
            2'b01:jmp_addr=num;
            2'b10:jmp_addr=reg_buf_r1;
            2'b11:jmp_addr=reg_buf_r2;
        endcase
    end
endmodule
