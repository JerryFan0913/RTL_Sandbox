module clock_logic_cross_sync_0(
	input  wire clock,
	input  wire resetn,
	input  wire data_in,
	output wire data_out
);

wire data_metastable;
wire clock_inv = ~clock;

clock_cell_dffr clock_domain_cross_sync(
	.ck(clock_inv),
	.rn(resetn),
	.d(data_in),
	.out(data_metastable)
);

clock_cell_dffr meta_stable_remover(
	.ck(clock),
	.rn(resetn),
	.d(data_metastable),
	.out(data_out)
);

endmodule

