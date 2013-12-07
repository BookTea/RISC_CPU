module pro_count(pc_addr,ir_addr,load,clk,rst);
   output [12:0] pc_addr;
   input [12:0]  ir_addr;
   input 	 load,clk,rst;

   reg [12:0] 	 pc_addr;

   always @ (posedge clock or posedge rst)
     begin
	if(rst)
	  pc_addr <= 13'h000;
	else
	  if(load)
	    pc_addr <= ir_addr;
	  else
	    pc_addr <= pc_addr + 1;
     end
endmodule // pro_count

   