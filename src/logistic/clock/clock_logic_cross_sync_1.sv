module clock_logic_cross_sync_1(
	input  wire clock,
	input  wire resetn,
	input  wire data_in,
	output wire data_out
);

wire data_metastable;
wire clock_inv = ~clock;

clock_cell_dffs clock_domain_cross_sync(
	.ck(clock_inv),
	.sn(resetn),
	.d(data_in),
	.out(data_metastable)
);

clock_cell_dffs meta_stable_remover(
	.ck(clock),
	.sn(resetn),
	.d(data_metastable),
	.out(data_out)
);

endmodule

