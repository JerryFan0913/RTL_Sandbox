module clock_route_control_out(
	input  wire async_resetn,
	input  wire clock0,
	input  wire clock1,
	input  wire async_override,
	input  wire async_enable,
	input  wire sync_enable0,
	input  wire sync_enable1,
	output wire async_enable0_ack,
	output wire control_path_enable0,
	output wire control_path_enable1,
	input  wire async_test_en
);

wire clock0_inv = ~clock0;
wire enable;
wire override;

clock_logic_cross_sync_0  enable_sync(
	.clock(clock0_inv),
	.resetn(async_resetn),
	.data_in(async_enable),
	.data_out(enable)
);

clock_logic_cross_sync_0  override_sync(
	.clock(clock0_inv),
	.resetn(async_resetn),
	.data_in(async_override),
	.data_out(override)
);


reg enable_lockdown;
reg enable_lockup;

always @(posedge clock0 or async_resetn)
begin
	if(~async_resetn)
		enable_lockdown <= 1'b0;
	if(~enable)
		enable_lockdown <= 1'b1;
end

always @(posedge clock0 or async_resetn)
begin
	if(~async_resetn)
		enable_lockup <= 1'b0;
	if(enable)
		enable_lockup <= 1'b1;
end



assign control_path_enable0 = override ? enable : sync_enable0;

assign async_enable0_ack = control_path_enable0;

assign control_path_enable1 = sync_enable1;

endmodule

