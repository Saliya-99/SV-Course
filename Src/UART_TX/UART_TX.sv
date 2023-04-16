module UART_TX #(parameter CLOCKS_PER_PULSE=4, W_OUT = 16,BITS_PER_WORD = 8)(
                input logic clk,rstn,s_valid,
                input logic [W_OUT/BITS_PER_WORD-1:0][BITS_PER_WORD-1:0] s_data,
                output logic tx, s_ready);
                
                localparam NUM_OF_WORDS = W_OUT/BITS_PER_WORD;
                logic [W_OUT/BITS_PER_WORD-1:0][BITS_PER_WORD + 5-1:0] temp_data_packets;
                logic [NUM_OF_WORDS*(BITS_PER_WORD+5)     -1:0] m_packets;
                
                genvar i;
                for ( i=0; i<NUM_OF_WORDS ; i= i+ 1)begin
                
                     assign temp_data_packets[i] = { 1'b1,1'b1,1'b1,1'b1, s_data[i], 1'b0};
                
                end
                
                assign tx = m_packets[0];
                  // Counters
                logic [$clog2(NUM_OF_WORDS*(BITS_PER_WORD + 5))-1:0] c_pulses;
                logic [$clog2(CLOCKS_PER_PULSE)     -1:0] c_clocks;
              
                // State Machine
              
                enum {IDLE, SEND} state;
                
                always_ff @(posedge clk or negedge rstn) begin
                
                    if (!rstn) begin
                      state     <= IDLE;
                      m_packets <= '1;
                      {c_pulses, c_clocks} <= 0;
                    end else
                      case (state)
                        IDLE :  if (s_valid) begin                  
                                  state      <= SEND;
                                  m_packets  <= temp_data_packets;
                                end
                
                        SEND :  if (c_clocks == CLOCKS_PER_PULSE-1) begin
                                  c_clocks <= 0;
                
                                  if (c_pulses == NUM_OF_WORDS*(BITS_PER_WORD + 5)-1) begin
                                    c_pulses  <= 0;
                                    m_packets <= '1;
                                    state     <= IDLE;
                
                                  end else begin
                                    c_pulses <= c_pulses + 1;
                                    m_packets <= (m_packets >> 1);
                                  end
                
                                end else c_clocks <= c_clocks + 1;
                      endcase
                  end
                
                  assign s_ready = (state == IDLE);
                
                
                
                


                

endmodule