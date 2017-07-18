
module clock_cell_buf(
	input wire in,
	output wire out
);

assign out = in;

endmodule

module clock_cell_mux(
	input wire ina,
	input wire inb,
	input wire sel,
	output wire out
);

assign out = sel ? inb : ina;

endmodule

module clock_cell_and(
	input wire ina,
	input wire inb,
	output wire out
);

assign out = inb & ina;

endmodule

module clock_cell_or(
	input wire ina,
	input wire inb,
	output wire out
);

assign out = inb | ina;

endmodule

module clock_cell_nand(
	input wire ina,
	input wire inb,
	output wire out
);

assign out = !(inb & ina);

endmodule

module clock_cell_nor(
	input wire ina,
	input wire inb,
	output wire out
);

assign out = !(inb | ina);

endmodule

module clock_cell_gate(
	input wire ck,
	input wire en,
	output wire out
);

reg enable;

always @(ck or en)
begin
	if(~ck)
		enable = en;
end

assign out = enable & ck;

endmodule

module clock_cell_dffs(
	input wire ck,
	input wire sn,
	input wire d,
	output wire out
);

reg out_reg;

assign out = out_reg;

always @(posedge ck or negedge sn)
begin
	if(!sn)
		out_reg <= 1'b1;
	else
		out_reg <= d;
end

endmodule

module clock_cell_dffr(
	input wire ck,
	input wire rn,
	input wire d,
	output wire out
);

reg out_reg;

assign out = out_reg;

always @(posedge ck or negedge rn)
begin
	if(!rn)
		out_reg <= 1'b0;
	else
		out_reg <= d;
end

endmodule

