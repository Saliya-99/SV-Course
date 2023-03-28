`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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


module N_accumulator_tb;
    
    localparam Width = 3;

    logic s_valid,m_ready;
    logic [Width-1:0] s_data;
    logic m_valid,s_ready;
    logic [6:0] HEX0;    
    logic [6:0] HEX1;


    reg [1:0][6:0] m_data;
       
     N_accumulator #(.Width(Width)) uut(.*);
     SSD uut1(.*);
     
     
     logic clk = 0, rstn = 0;
     localparam CLK_PERIOD = 10;
     initial forever
     #(CLK_PERIOD/2) 
     clk <= ~clk;
     
     initial begin 
       
     @(posedge clk)   s_data<= 7; rstn<= 1;s_valid<=1;m_ready<=1;

     @(posedge clk)   s_data<= 4; rstn<= 1;s_valid<=0;m_ready<=1;

     @(posedge clk)   s_data<= 5; rstn<= 1;s_valid<=1;m_ready<=1;
     @(posedge clk)   s_data<= 6; rstn<= 1;s_valid<=1;m_ready<=1;
     @(posedge clk)   s_data<= 2; rstn<= 1;s_valid<=1;m_ready<=1;
     @(posedge clk)   s_data<= 5; rstn<= 1;s_valid<=1;m_ready<=1;
     @(posedge clk)   s_data<= 5; rstn<= 1;s_valid<=1;m_ready<=0;
     @(posedge clk)   s_data<= 5; rstn<= 1;s_valid<=1;m_ready<=0;
     @(posedge clk)   s_data<= 5; rstn<= 1;s_valid<=1;m_ready<=1;
     @(posedge clk)   s_data<= 5; rstn<= 1;s_valid<=1;m_ready<=1;

     @(posedge clk)   s_data<= 1; rstn<= 1;s_valid<=1;m_ready<=1;
     @(posedge clk)   rstn<= 0;
     @(posedge clk)   s_data<= 4; rstn<= 1;s_valid<=0;m_ready<=1;


      end
           
           
endmodule
