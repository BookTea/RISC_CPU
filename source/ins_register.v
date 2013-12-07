`timescale 1ns/1ns
module register(opc_ir_addr,data,ena,clk,rst);
   output [15:0] opc_ir_addr;
   input [7:0] 	 data;
   input 	 ena,clk,rst;

   reg [15:0] 	 opc_ir_addr;
   reg 		 state

   always @ (posedge clk)
     begin
	if(rst)
	  begin
	     opc_ir_addr <= 16'h0000;
	     state       <= 1'b0;
	  end
	else
	  begin
	     if(ena)
	       begin
		  casex(state)
		    1'b0:
		      begin
			 opc_ir_addr[15:8] <= data;
			 state             <= 1;
		      end
		    1'b1:
		      begin
			 opc_ir_addr[7:0]  <= data;
			 state             <= 0;
		      end
		    default:
		      begin
			 opc_ir_addr[15:0] <= 16'hxxxx;
			 state             <= 1'bx;
		      end
		  endcase // casex (state)
	       end // if (ena)
	     else
	       state <= 1'b0;
	  end // else: !if(rst)
     end // always @ (posedge clk)
endmodule // register
