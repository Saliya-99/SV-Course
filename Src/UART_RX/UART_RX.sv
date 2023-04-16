module UART_RX #(parameter clocks_per_pulse = 4,
                           bits_per_word = 8,
                           w_out = 16)
                (input logic rx,clk,rstn,
                output logic m_valid,
                output logic [w_out-1:0] m_data);

                localparam NUM_WORDS = w_out/bits_per_word;
                enum {IDLE, START, DATA, END} state;
                // Counters
                logic [$clog2(clocks_per_pulse) -1:0] c_clocks;
                logic [$clog2(bits_per_word) -1:0] c_bits ;
                logic [$clog2(NUM_WORDS) -1:0] c_words ;

                always_ff @(posedge clk or negedge rstn) begin

                    if (!rstn) begin
                        {c_bits,c_clocks,c_words,m_valid,m_data} = '0;
                        state <= IDLE;
                        end
                    else begin
                        m_valid <= 0;
                        case (state)

                        IDLE:begin

                            if(rx==0)begin
                                state <= START;
                            end

                        end

                        START:begin
                            if (c_clocks == clocks_per_pulse/2-1)begin
                                state <= DATA;
                                c_clocks <= 0;
                                end
                            else begin
                                c_clocks <= c_clocks + 1;
                            end
                        end

                        DATA:begin
                            if (c_clocks == clocks_per_pulse-1)begin
                                c_clocks <= 0;
                                m_data <= {rx, m_data[w_out -1:1]};

                                if (c_bits == bits_per_word-1)begin
                                    c_bits <= 0;
                                    state <= END;

                                    if (c_words == NUM_WORDS-1)begin
                                        c_words <= 0;
                                        m_valid <= 1;
                                    end else c_words <= c_words+ 1;
                                end else c_bits <= c_bits + 1;
                            end else c_clocks <= c_clocks+1;
                            end

                        END: if(c_clocks == clocks_per_pulse-1)begin
                            state <= IDLE;
                            c_clocks <= 0;
                        end
                        else begin 
                            c_clocks <= c_clocks + 1;
                        end
                        endcase
                    end
                end
        endmodule





                            
                








