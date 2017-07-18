module reset_logic_delay_chain_1(
	input  wire clock,
	input  wire resetn,
	input  wire data_in,
	output wire data_delay_1,
	output wire data_delay_2,
	output wire data_delay_3,
	output wire data_delay_4
);

reg [4:1] delay;

assign data_delay_1 = delay[1];
assign data_delay_2 = delay[2];
assign data_delay_3 = delay[3];
assign data_delay_4 = delay[4];

always @(posedge clock or negedge resetn)
begin
	if(~resetn)
		delay <= 4'b1111;
	else
		delay <= {delay[3:1], data_in};
end

endmodule

