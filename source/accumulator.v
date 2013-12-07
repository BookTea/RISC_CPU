module accumlator(accum,data,ena,clk,rst);
   output [7:0] accum;
   input [7:0] 	data;
   input 	ena,clk,rst;
   
   reg [7:0] 	accum;

   always @ (posedge clk)
     begin
	if(rst)
	  accum <= 8'h00;
	else if(ena)
	  accum <= data;
     end
endmodule // accumlator
