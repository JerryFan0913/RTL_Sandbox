module clock_route_path_sync(
	output wire clock_route_path_out,
	input  wire clock_route_path_syncer,
	input  wire clock_route_path_syncee,
	output wire control_path_clock,
	input  wire control_path_data0_or_gate,
	input  wire control_path_data1_and_gate,
	input  wire control_path_enable
);

wire clock_route_path_sync;

clock_cell_buf cross_buf(
	.in(clock_route_path_syncee),
	.out(control_path_clock)
);

clock_cell_mux sync_mux(
	.ina(control_path_data0_or_gate),
	.inb(control_path_data1_and_gate),
	.sel(clock_route_path_syncer),
	.out(clock_route_path_sync)
);

clock_cell_mux out_mux(
	.ina(clock_route_path_syncee),
	.inb(clock_route_path_sync),
	.sel(control_path_enable),
	.out(clock_route_path_out)
);

endmodule

