module clock_interface_logic_base(
	input  wire clock,
	input  wire async_resetn,

	input  wire pwrite,
	input  wire psel,
	input  wire penable,
	input  wire [31:0] paddr,
	input  wire [31:0] pwdata,
	output wire [31:0] prdata,
	output wire pready,
	output wire pslverr,

	input  wire [31:0] node_type,
	input  wire [31:0] node_name,
	input  wire [31:0] node_frequency,
	input  wire [31:0] node_frequency_setting,
	input  wire [31:0] node_mindrift,
	input  wire [31:0] node_maxdrift,
	input  wire [31:0] node_minfrequency,
	input  wire [31:0] node_maxfrequency,
	input  wire [31:0] node_parent,
	input  wire [31:0] node_child,
	input  wire [31:0] node_prev,
	input  wire [31:0] node_next,

	output reg  [31:0] node_setting,
	output reg  [31:0] node_frequency_override,
	output reg  [31:0] node_mindrift_override,
	output reg  [31:0] node_maxdrift_override,

	output wire tran_pwrite,
	output wire tran_psel,
	output wire tran_penable,
	output wire [31:0] tran_paddr,
	output wire [31:0] tran_pwdata,
	input  wire [31:0] tran_prdata,
	input  wire tran_pready,
	input  wire tran_pslverr
);

wire base_pwrite;
wire base_psel;
wire base_penable;
wire [31:0] base_paddr;
wire [31:0] base_pwdata;
reg [31:0] base_prdata;
wire base_pready;
wire base_pslverr;

assign base_pwrite	= pwrite;
assign base_psel	= psel;
assign base_penable	= penable;
assign base_paddr	= paddr;
assign base_pwdata	= pwdata;

assign tran_pwrite	= pwrite;
assign tran_psel	= psel;
assign tran_penable	= penable;
assign tran_paddr	= paddr;
assign tran_pwdata	= pwdata;

assign select_submod	= paddr[6];

assign prdata		= select_submod ? tran_prdata : base_prdata;
assign pready		= select_submod ? tran_pready : base_pready;
assign pslverr		= select_submod ? tran_pslverr : base_pslverr;

assign base_pready	=  base_penable;
assign base_pslverr	=  1'b0;

always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		node_setting <= 32'h0;
	else if(base_psel & base_penable & base_pready & (base_paddr[5:2] == 4'hC))
		node_setting <= base_pwdata;
end

always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		node_frequency_override <= 32'h0;
	else if(base_psel & base_penable & base_pready & (base_paddr[5:2] == 4'hD))
		node_frequency_override <= base_pwdata;
end

always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		node_mindrift_override <= 32'h0;
	else if(base_psel & base_penable & base_pready & (base_paddr[5:2] == 4'hE))
		node_mindrift_override <= base_pwdata;
end

always @(posedge clock or negedge async_resetn)
begin
	if(~async_resetn)
		node_maxdrift_override <= 32'h0;
	else if(base_psel & base_penable & base_pready & (base_paddr[5:2] == 4'hF))
		node_maxdrift_override <= base_pwdata;
end

always @(*)
begin
	case(base_paddr[5:2])
		4'h0: base_prdata = node_type;
		4'h1: base_prdata = node_name;
		4'h2: base_prdata = node_frequency;
		4'h3: base_prdata = node_frequency_setting;
		4'h4: base_prdata = node_mindrift;
		4'h5: base_prdata = node_maxdrift;
		4'h6: base_prdata = node_minfrequency;
		4'h7: base_prdata = node_maxfrequency;
		4'h8: base_prdata = node_parent;
		4'h9: base_prdata = node_child;
		4'hA: base_prdata = node_prev;
		4'hB: base_prdata = node_next;
		4'hC: base_prdata = node_setting;
		4'hD: base_prdata = node_frequency_override;
		4'hE: base_prdata = node_mindrift_override;
		4'hF: base_prdata = node_maxdrift_override;
	endcase
end

endmodule

