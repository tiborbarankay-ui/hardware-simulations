module simple_alu#(
	parameter SIZE = 8
)(
	input [2:0] opcode,
	input [SIZE-1:0] op1,
	input [SIZE-1:0] op2,
	output reg [SIZE-1:0] result,
	output reg carry_out,
	output zero
);

	assign zero = (result == 0);

	always@(*) begin

		result = 0;
		carry_out = 0;

		case(opcode)
			3'b000: begin
				result = op1 & op2;
			end

			3'b001: begin
				result = op1 | op2;
			end

			3'b010: begin
				{carry_out, result} = op1 + op2;
			end

			3'b011: begin
				result = op1 + 1;
			end

			3'b100: begin
				result = op1 & ~op2;
			end

			3'b101: begin
				result = op1 | ~op2;
			end

			3'b110: begin
				{carry_out, result} = op1 - op2;
			end

			3'b111: begin
				result = op1 < op2;
			end
			
			default: begin
				result = 0;
				carry_out = 0;
			end
		endcase
	end
endmodule
