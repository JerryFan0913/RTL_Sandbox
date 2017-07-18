module power_route_isolation(
	input  wire clock,
	input  wire async_resetn,

	input  wire enable_req,
	output wire enable_ack,

	output wire isolation
);

parameter ISOLATION_DELAY_CYCLES = 2;

reg enable;
always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		enable <= 1'b0;
	else
		enable <= enable_req;
end
assign isolation = ~enable;


reg enabled;
reg [5:0] isolation_counter;

always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		isolation_counter <= 6'b0;
	else if(enable_ack == enable)
		isolation_counter <= 6'b0;
	else
		isolation_counter <= isolation_counter + 6'b1;

end

always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		enabled <= 1'b0;
	else if(isolation_counter >= ISOLATION_DELAY_CYCLES)
		enabled <= enable;
end

assign enable_ack = enabled;

endmodule

/*
module testbench_power_route_isolation();
reg clock;
reg clock_root;
reg async_resetn;
reg enable_req;
initial
begin
	clock = 0;
	clock_root = 0;
	async_resetn = 0;
	enable_req = 0;
	# 10;
	async_resetn = 1;

	#100;
	enable_req <= 1;
	#1000;
	enable_req <= 0;
	#98;
	enable_req <= 1;
	#1000;
	enable_req <= 0;
	#1000;

end

always
	#10 clock = ~clock;


power_route_isolation dut(
	.clock(clock),
	.async_resetn(async_resetn),

	.enable_req(enable_req),
	.enable_ack(),

	.isolation()
);

endmodule
*/

