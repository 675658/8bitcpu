module decoder(
    input [15:0]code,
    output reg flag_hlt,
    output reg a_en,
    output reg m_en,
    output reg r_en_r,
    output reg r_en_w,
    output reg j_en,
    output reg [2:0]a_op,
    output reg [2:0]j_op,
    output reg mem_rw,
    output reg [2:0]reg1,
    output reg [2:0]reg2,
    output reg [2:0]regw1,
    output reg [2:0]regw2,
    output reg [7:0]num,
    output reg [7:0]alub,
    output reg [1:0]mem_data_addr_selector,
    output reg [1:0]mem_data_buf_w_selector,
    output reg alu_a_selector,
    output reg [1:0]alu_b_selector,
    output reg [1:0]reg_buf_w1_selector,
    output reg [1:0]reg_buf_w2_selector,
    output reg [1:0]jmp_addr_selector
);

    always@(code) 
    begin
        flag_hlt=1'b0;
        a_en=1'b0;
        m_en=1'b0;
        r_en_r=1'b0;
        r_en_w=1'b0;
        j_en=1'b0;
        a_op=3'b000;
        j_op=3'b000;
        mem_rw=1'b0;
        reg1=3'b111;
        reg2=3'b111;
        regw1=3'b111;
        regw2=3'b111;
        num=8'b00000000;
        alub=8'b00000000;
        mem_data_addr_selector=2'b00;
        mem_data_buf_w_selector=2'b00;
        alu_a_selector=1'b0;
        alu_b_selector=2'b00;
        reg_buf_w1_selector=2'b00;
        reg_buf_w2_selector=2'b00;
        jmp_addr_selector=2'b00;
        if(code[15]==1'b1)
        begin
            flag_hlt=1'b0;
            a_en=1'b1;
            m_en=1'b0;
            r_en_r=1'b1;
            r_en_w=1'b1;
            j_en=1'b0;
            a_op=code[13:11];
            reg1=code[10:8];
            regw1=code[10:8];
            regw2=3'b111;
            alu_a_selector=1'b0;
            reg_buf_w1_selector=2'b10;
            if(code[14]==1'b1)
            begin
                reg2=code[7:5];
                alu_b_selector=2'b01;
            end
            else
            begin
                reg2=3'b111;
                num=code[7:0];
                alu_b_selector=2'b10;
            end
        end
        else
        begin
            if(code[14]==1'b1)
            begin
                flag_hlt=1'b0;
                j_en=1'b0;
                regw2=3'b111;
                case(code[13:11])
                    3'b000:
                    begin
                        m_en=1'b0;
                        r_en_r=1'b0;
                        r_en_w=1'b1;
                        reg1=3'b111;
                        reg2=3'b111;
                        regw1=code[10:8];
                        regw2=3'b111;
                        num=code[7:0];
                        reg_buf_w1_selector=2'b01;
                    end
                    3'b001:
                    begin
                        m_en=1'b0;
                        r_en_r=1'b1;
                        r_en_w=1'b1;
                        reg1=code[7:5];
                        reg2=3'b111;
                        regw1=code[10:8];
                        regw2=3'b111;
                        reg_buf_w1_selector=2'b11;
                    end
                    3'b010:
                    begin
                        m_en=1'b1;
                        r_en_r=1'b0;
                        r_en_w=1'b1;
                        mem_rw=1'b0;
                        reg1=3'b111;
                        reg2=3'b111;
                        regw1=code[10:8];
                        regw2=3'b111;
                        num=code[7:0];
                        mem_data_addr_selector=2'b10;
                        mem_data_buf_w_selector=2'b00;
                        reg_buf_w1_selector=2'b00;
                    end
                    3'b011:
                    begin
                        m_en=1'b1;
                        r_en_r=1'b1;
                        r_en_w=1'b1;
                        mem_rw=1'b0;
                        reg1=code[7:5];
                        reg2=3'b111;
                        regw1=code[10:8];
                        regw2=3'b111;
                        mem_data_addr_selector=2'b00;
                        mem_data_buf_w_selector=2'b00;
                        reg_buf_w1_selector=2'b00;
                    end
                    3'b110:
                    begin
                        m_en=1'b1;
                        r_en_r=1'b1;
                        r_en_w=1'b0;
                        mem_rw=1'b1;
                        reg1=code[10:8];
                        reg2=3'b111;
                        regw1=3'b111;
                        regw2=3'b111;
                        num=code[7:0];
                        mem_data_addr_selector=2'b10;
                        mem_data_buf_w_selector=2'b01;
                    end
                    3'b111:
                    begin
                        m_en=1'b1;
                        r_en_r=1'b1;
                        r_en_w=1'b0;
                        mem_rw=1'b1;
                        reg1=code[10:8];
                        reg2=code[7:5];
                        regw1=3'b111;
                        regw2=3'b111;
                        mem_data_addr_selector=2'b00;
                        mem_data_buf_w_selector=2'b10;
                    end
                endcase
            end
            else
            begin
                case(code[13:12])
                    2'b00:
                    begin
                        m_en=1'b0;
                        r_en_r=1'b0;
                        r_en_w=1'b0;
                        j_en=1'b0;
                        reg1=3'b111;
                        reg2=3'b111;
                        regw1=3'b111;
                        regw2=3'b111;
                        if(code[9]==1'b1)
                            flag_hlt=1'b1;
                        else
                            flag_hlt=1'b0;
                    end
                    2'b01:
                    begin
                        flag_hlt=1'b0;
                        m_en=1'b1;
                        r_en_r=1'b1;
                        r_en_w=1'b1;
                        j_en=1'b0;
                        reg1=3'b110;
                        regw1=3'b110;
                        alub=8'b0000_0001;
                        alu_a_selector=1'b0;
                        alu_b_selector=2'b11;
                        reg_buf_w1_selector=2'b10;
                        if(code[11:9]==3'b000)
                        begin
                            if(code[8]==1'b0)
                            begin
                                a_op=3'b001;
                                mem_rw=1'b1;
                                reg2=3'b111;
                                regw2=3'b111;
                                num=code[7:0];
                                mem_data_addr_selector=2'b11;
                                mem_data_buf_w_selector=2'b11;
                            end
                            else if(code[8]==1'b1)
                            begin
                                a_op=3'b001;
                                mem_rw=1'b1;
                                reg2=code[7:5];
                                regw2=3'b111;
                                mem_data_addr_selector=2'b11;
                                mem_data_buf_w_selector=2'b10;
                            end
                        end
                        else if(code[11:9]==3'b001)
                        begin
                            a_op=3'b000;
                            mem_rw=1'b0;
                            reg2=3'b111;
                            regw2=code[7:5];
                            mem_data_addr_selector=2'b00;
                            reg_buf_w2_selector=00;
                        end
                    end
                    2'b10:
                    begin
                        flag_hlt=1'b0;
                        m_en=1'b1;
                        r_en_r=1'b1;
                        r_en_w=1'b1;
                        j_en=1'b1;
                        j_op=3'b000;
                        reg1=3'b110;
                        regw1=3'b110;
                        regw2=3'b111;
                        alub=8'b0000_0001;
                        mem_data_buf_w_selector=2'b00;
                        alu_a_selector=1'b0;
                        alu_b_selector=2'b11;
                        reg_buf_w1_selector=2'b10;
                        reg_buf_w2_selector=2'b00;
                        if(code[11:9]==3'b000)
                        begin
                            a_op=3'b001;
                            mem_rw=1'b1;
                            mem_data_addr_selector=2'b11;
                            if(code[8]==1'b1)
                            begin
                                reg2=code[7:5];
                                jmp_addr_selector=2'b11;
                            end
                            else
                            begin
                                reg2=3'b111;
                                num=code[7:0];
                                jmp_addr_selector=2'b01;
                            end
                        end
                        else if(code[11:9]==3'b001)
                        begin
                            a_op=3'b000;
                            mem_rw=1'b0;
                            reg2=3'b111;
                            mem_data_addr_selector=2'b00;
                            jmp_addr_selector=2'b00;
                        end
                    end
                    2'b11:
                    begin
                        flag_hlt=1'b0;
                        m_en=1'b0;
                        r_en_w=1'b0;
                        j_en=1'b1;
                        j_op=code[11:9];
                        reg2=3'b111;
                        regw1=3'b111;
                        regw2=3'b111;
                        if(code[8]==1'b1)
                        begin
                            r_en_r=1'b1;
                            reg1=code[7:5];
                            jmp_addr_selector=2'b10;
                        end
                        else
                        begin
                            r_en_r=1'b0;
                            reg1=3'b111;
                            num=code[7:0];
                            jmp_addr_selector=2'b01;
                        end
                    end
                endcase
            end
        end
    end

    
endmodule