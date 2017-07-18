module power_route_switch(
	input  wire clock,
	input  wire async_resetn,

	input  wire enable_req,
	output wire enable_ack,

	output wire switch_enb,
	input  wire switch_ack
);

parameter SWITCH_DELAY_CYCLES = 2;

reg enable;
always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		enable <= 1'b0;
	else
		enable <= enable_req;
end
assign switch_enb = ~enable;


wire switch_ack_sync;
power_logic_cross_sync_0  switch_ack_syncer(
	.clock(clock),
	.resetn(async_resetn),
	.data_in(~switch_ack),
	.data_out(switch_ack_sync)
);

reg enabled;
reg [5:0] switch_counter;
always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		switch_counter <= 6'b0;
	else if(switch_ack_sync && enable && (~enabled))
		switch_counter <= switch_counter + 6'b1;
	else
		switch_counter <= 6'b0;
end

always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		enabled <= 1'b0;
	else if((~enabled) && switch_ack_sync)
	begin
		if(switch_counter >= SWITCH_DELAY_CYCLES - 1)
			enabled <= switch_ack_sync;
	end
	else
		enabled <= switch_ack_sync;
end

assign enable_ack = enabled;

endmodule

/*
module testbench_power_route_switch();
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
	#78;
	enable_req <= 1;
	#1000;
	enable_req <= 0;
	#1000;

end

always
	#10 clock = ~clock;


power_route_switch dut(
	.clock(clock),
	.async_resetn(async_resetn),

	.enable_req(enable_req),
	.enable_ack(),

	.switch_enb(switch),
	.switch_ack(switch)
);

endmodule
*/

