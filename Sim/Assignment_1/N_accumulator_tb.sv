`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Saliya Dinusha
// 
// Create Date: 03/23/2023 08:23:27 PM
// Design Name: 
// Module Name: N_accumulator_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

class Random_Num #(WIDTH=3);
rand bit signed [WIDTH-1:0] num;
rand bit signed num_1;
rand bit signed num_2;
rand bit signed num_3;

endclass
    
module N_accumulator_tb;

    localparam Width = 3;
    localparam N = 10;
    logic s_valid,m_ready;
    logic [Width-1:0] s_data;
    logic m_valid,s_ready;
    logic [6:0] HEX0;    
    logic [6:0] HEX1;
    logic [6:0] sum_1=0;
    
    localparam N_BITS_1 = $clog2(N);
    logic [N_BITS_1-1:0] count_1=0; // = 0; 

    reg [1:0][6:0] m_data;
     logic [1:0][6:0] m_data_1=0;
       
     N_accumulator #(.Width(Width),.N(N)) uut(.*);
     SSD uut1(.*);
     
     
     logic clk = 0, rstn = 0;
     localparam CLK_PERIOD = 10;
     initial forever
     #(CLK_PERIOD/2) 
     clk <= ~clk;
     
    initial 
    begin   
        Random_Num #(.WIDTH(Width)) s_data_r = new();
        
        
                
        repeat(2000) begin
        @(posedge clk) #1
        s_data <= s_data_r.num; rstn <= 1; s_valid <=  s_data_r.num_1; m_ready <=  s_data_r.num_2;
        s_data_r.randomize();
        end
 
        @(posedge clk)   s_data<= 4; rstn<= 1;s_valid<=0;m_ready<=1;
    end
    
    
/// Monitoring
           
    initial forever begin
        @(posedge clk) #1
        
        if(!rstn)
            begin
            count_1 = 0;
            sum_1 = 0;
            end
        else
            begin
            if (count_1 == N)
                begin
                if ( m_ready)
                begin
                count_1 = 0;
                m_data_1[0] = sum_1%10;  
                m_data_1[1] = sum_1/10;
                if(s_valid) 
                    begin
                    sum_1 = s_data;
                    end
                else
                    begin 
                    sum_1 = 0;
                    end
                end
                end
            
            else
                begin
                if(s_valid && s_ready && rstn )begin
               
                    count_1 = count_1 + 1;
                    sum_1 = sum_1+ s_data;

                end
                end
            end
        
        
        if (count_1 == N  && m_ready)
        begin
        assert ((m_data_1[0]==m_data[0]) && (m_data_1[1]==m_data[1])  ) begin
        $display("OK: m_data:%d%d m_data_1:%d%d", m_data[1], m_data[0], m_data_1[1], m_data_1[0]);
        end else $display("Error");
        end
        end

        

               
endmodule
