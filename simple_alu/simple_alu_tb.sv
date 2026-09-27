module simple_alu_tb;
	
	logic [2:0] opcode;
	logic [7:0] op1, op2, result, expected;
	logic carry_out, zero, carry_out_exp;
	int successes, total;

	simple_alu dut (.opcode(opcode), .op1(op1), .op2(op2), .result(result), .carry_out(carry_out), .zero(zero));

	task check(string opname);
		total++;
		if (result === expected) successes++;
		else $display("[FAIL] %s: op1=%0d op2=%0d -> got %0d, expected %0d", opname, op1, op2, result, expected);
	endtask

	initial begin
		successes = 0;
		total = 0;	
		for(int pair = 0; pair < 20; pair++) begin
			op1 = $urandom_range(0,255);
			op2 = $urandom_range(0,255);

			#10
			opcode = 3'b000;
			#1
			expected = op1 & op2;
			$display("opcode = %d, op1 = %d, op2 = %d, result = %d, expected = %d carry_out = %d, zero = %d", opcode, op1, op2, result, expected, carry_out, zero);
			check("AND");

			#10
			opcode = 3'b001;
			#1
			expected = op1 | op2;
			$display("opcode = %d, op1 = %d, op2 = %d, result = %d, expected = %d carry_out = %d, zero = %d", opcode, op1, op2, result, expected, carry_out, zero);
			check("OR");

			#10
			opcode = 3'b010;
			#1
			{carry_out_exp, expected} = op1 + op2;
			$display("opcode = %d, op1 = %d, op2 = %d, result = %d, expected = %d carry_out = %d, carry_out_exp = %d zero = %d", opcode, op1, op2, result, expected, carry_out, carry_out_exp, zero);
			check("ADD");


			#10
			opcode = 3'b011;
			#1
			expected = op1 + 1;
			$display("opcode = %d, op1 = %d, op2 = %d, result = %d, expected = %d carry_out = %d, zero = %d", opcode, op1, op2, result, expected, carry_out, zero);
			check("INCREMENT");

			#10
			opcode = 3'b100;
			#1
			expected = op1 & ~op2;
			$display("opcode = %d, op1 = %d, op2 = %d, result = %d, expected = %d carry_out = %d, zero = %d", opcode, op1, op2, result, expected, carry_out, zero);
			check("AND-NOT");

			#10
			opcode = 3'b101;
			#1
			expected = op1 | ~op2;
			$display("opcode = %d, op1 = %d, op2 = %d, result = %d, expected = %d carry_out = %d, zero = %d", opcode, op1, op2, result, expected, carry_out, zero);
			check("OR-NOT");

			#10
			opcode = 3'b110;
			#1;
			{carry_out_exp, expected} = op1 - op2;
			$display("opcode = %d, op1 = %d, op2 = %d, result = %d, expected = %d carry_out = %d, carry_out_exp = %d zero = %d", opcode, op1, op2, result, expected, carry_out, carry_out_exp, zero);
			check("SUB");


			#10
			opcode = 3'b111;
			#1
			expected = op1 < op2;
			$display("opcode = %d, op1 = %d, op2 = %d, result = %d, expected = %d carry_out = %d, zero = %d", opcode, op1, op2, result, expected, carry_out, zero);
			check("LT");
		end
		$display("%0d / %0d passed", successes, total);
		$finish;
	end
endmodule
