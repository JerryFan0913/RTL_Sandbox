module clock_interface_div(
	input  wire clock,
	input  wire async_resetn,

	input  wire pwrite,
	input  wire psel,
	input  wire penable,
	input  wire [31:0] paddr,
	input  wire [31:0] pwdata,
	output wire [31:0] prdata,
	output wire pready,
	output wire pslverr
);


endmodule

