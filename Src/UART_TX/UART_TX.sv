module UART_TX #(parameter CLOCKS_PER_PULSE=4,
                           W_OUT = 16,
                           BITS_PER_WORD = 8)
                (input logic clk,rstn,s_valid,
                input logic [W_OUT/BITS_PER_WORD-1:0][BITS_PER_WORD-1:0] s_data,
                output logic tx, s_ready);


                

endmodule