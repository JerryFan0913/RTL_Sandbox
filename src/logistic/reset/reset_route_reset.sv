module reset_route_reset(
	input  wire clock,
	input  wire async_resetn,

	input  wire enable_req,
	output wire enable_ack,

	output wire reset_resetn,
	output wire reset_clock
);

parameter RESET_SYNC_CYCLES = 32;
parameter RESET_GAP_CYCLES = 2;


reg enable;
reg enabled;
reg [5:0] reset_counter;
always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		reset_counter <= 6'b0;
	else if(enable_req && (~enable))
		reset_counter <= reset_counter + 6'b1;
	else
		reset_counter <= 6'b0;
end

always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		enabled <= 1'b0;
	else if((~enabled) && enable_req)
	begin
		if(reset_counter > (RESET_SYNC_CYCLES + RESET_GAP_CYCLES))
			enabled <= enable_req;
	end
	else
		enabled <= enable_req;
end

always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		enable <= 1'b0;
	else if(reset_counter >= (RESET_SYNC_CYCLES + RESET_GAP_CYCLES) || ~enable_req)
		enable <= enable_req;
end

assign reset_resetn = enable;
assign enable_ack = enabled;

reset_cell_gate reset_clock_gate(
	.ck(clock),
	.en(reset_counter < RESET_SYNC_CYCLES && ~enabled && enable_req),
	.out(reset_clock)
);

endmodule

/*
module testbench_reset_route_switch();
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
	#41;
	enable_req <= 1;
	#1000;
	enable_req <= 0;
	#1000;

end

always
	#10 clock = ~clock;


reset_route_switch dut(
	.clock(clock),
	.async_resetn(async_resetn),

	.enable_req(enable_req),
	.enable_ack(),

	.reset_resetn(),
	.reset_clock()
);

endmodule
*/

