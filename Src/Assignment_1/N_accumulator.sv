`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Saliya Dinusha
// 
// Create Date: 03/23/2023 07:56:48 PM
// Design Name: 
// Module Name: N_accumulator
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
module N_accumulator #(Width= 3, N=10)(

    input logic clk, rstn, s_valid,m_ready,
    input logic [Width-1:0] s_data,
    output logic m_valid,s_ready,
    output reg [1:0][6:0] m_data
    
    );
    
    localparam N_BITS = $clog2(N);
    enum logic {RX=0, TX=1} next_state, state; //= RX
    logic [N_BITS-1:0] count; // = 0; 
    
    reg [Width+$clog2(N):0] temp_data = 0;

    reg [Width-1:0] data_reg;


    assign s_ready =!((m_valid)&&(!m_ready));
    

    always_comb unique case (state)
    RX: next_state =  s_valid && count==N-1 ? TX : RX;
    TX: next_state = m_ready               ? RX : TX;
    endcase
    
    always_ff @(posedge clk or negedge rstn)
    state <= !rstn ? RX : next_state;
    
    always_ff @(posedge clk or negedge rstn)
    if (!rstn)
        begin 
        temp_data <= 0;

        count <= 0;
        m_data<= 0;
        end
    else 
        unique case (state)
        RX: begin
        m_valid <= 0; 
        if(s_valid && s_ready)begin

                
                temp_data <= temp_data + s_data;
                count <= count + 1'd1;
            end
        end
        TX: begin
            m_valid <= 1;
            if (m_ready) begin
            m_data[0] <= temp_data%10;  
            m_data[1] <= temp_data/10;
            
            if (s_valid)
                begin
                temp_data <= temp_data + (s_data-temp_data);//avoid missing of one value in the axi input stream during output enabling and reset sum to 0
                end
            else
                begin
                temp_data<= 0;
                end
     
            count <= 0;
        end
        end

        endcase

            
endmodule
