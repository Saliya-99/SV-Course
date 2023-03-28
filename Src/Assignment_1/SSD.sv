



module SSD(

	input [1:0][6:0] m_data,

	output		     [6:0]		HEX0,

	output		     [6:0]		HEX1


);


wire [6:0] out_ssd;
wire [6:0] out_ssd1;

SevenSeg s0(m_data[0],out_ssd);
SevenSeg s1(m_data[1],out_ssd1);


assign HEX0 = out_ssd;
assign HEX1 = out_ssd1;


endmodule
