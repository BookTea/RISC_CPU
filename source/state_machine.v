`timescale 1ns/1ns

module machine(inc_pc,
	       load_acc,
	       load_pc,
	       rd,
	       wr,
	       load_ir,
	       halt,
	       datactl_ena,                    //output
	       clk,zero,ena,opcode);           //input

   output      inc_pc,
	       load_acc,
	       load_pc,
	       rd,
	       wr,
	       load_ir,
	       halt,
	       datactl_ena;
   
   input       clk,zero,ena;
   input [2:0] opcode;
   
   reg 	       inc_pc,
	       load_acc,
	       load_pc,
	       rd,
	       wr,
	       load_ir,
	       halt,
	       datactl_ena;
   reg [2:0]   state;
   
   parameter   HLT  = 3'b000,
	       SKZ  = 3'b001,
               ADD  = 3'b010,
               ANDD = 3'b011,
               XORR = 3'b100,
               LDA  = 3'b101,
               STO  = 3'b110,
               JMP  = 3'b111;

   always @ (negedge clk)
     begin
	if(!ena)
	  begin
	     state <= 3'b000;
	     {inc_pc,
	      load_acc,
	      load_pc,
	      rd,
	      wr,
	      load_ir,
	      halt,
	      datactl_ena} <= 8'h00;
	  end // if (!ena)
	else
	  ctl_cycle;
//----------------------begin of task ctl_cycle-------------------------   
	task ctl_style;
	   begin
	      casex(state)
		3'b000:                        //load high 8 bits in struction
		  begin
		     {inc_pc,
		      load_acc,
		      load_pc,
		      rd}          <= 4'b0001;
		     {wr,
		      load_ir,
		      halt,
		      datactl_ena} <= 4'b0100;
		     state         <= 3'b001;
	          end // case: 3'b000
		3'b001:                       //pc increased by one then loads low 8 bits instructions
		  begin
		     {inc_pc,
		      load_acc,
		      load_pc,
		      rd}          <= 4'b1001;
		     {wr,
		      load_ir,
		      halt,
		      datactl_ena} <= 4'b0100;
		     state         <= 3'b010;
		  end // case: 3'b001
		3'b010:                       //idle
		  begin
		     {inc_pc,
		      load_acc,
		      load_pc,
		      rd}          <= 4'b0000;
		     {wr,
		      load_ir,
		      halt,
		      datactl_ena} <= 4'b0000;
		     state         <= 3'b011;
		  end // case: 3'b010
		3'b011:                      //next instruction address setup
		  begin
		     if(opcode == HLT)
		       begin
			  {inc_pc,
			   load_acc,
			   load_pc,
			   rd}          <= 4'b0000;
			  {wr,
			   load_ir,
			   halt,
			   datactl_ena} <= 4'b0010;
		       end // if (opcode == HLT)
		     else
		       begin
			  {inc_pc,
			   load_acc,
			   load_pc,
			   rd}          <= 4'b1000;
			  {wr,
			   load_ir,
			   halt,
			   datactl_ena} <= 4'b0000;			  
		       end // else: !if(opcode == HLT)
		     state <= 3'b100;
		  end // case: 3'b011
		3'b100:
		  begin
		     if(opcode == JMP)
		       begin
			  {inc_pc,
			   load_acc,
			   load_pc,
			   rd}          <= 4'b0010;
			  {wr,
			   load_ir,
			   halt,
			   datactl_ena} <= 4'b0000;			  
		       end // if (opcode == JMP)
		     else
		       if(opcode == ADD || opcode == ANDD || opcode == XORR || opcode == LDA)
			 begin
			    {inc_pc,
			     load_acc,
			     load_pc,
			     rd}          <= 4'b0001;
			    {wr,
			     load_ir,
			     halt,
			     datactl_ena} <= 4'b0000;
			 end // if (opcode == ADD || opcode == ANDD || opcode == XORR || opcode == LDA)
		       else
			 if(opcode == STO)
			   begin
			      {inc_pc,
			       load_acc,
			       load_pc,
			       rd}          <= 4'b0000;
			      {wr,
			       load_ir,
			       halt,
			       datactl_ena} <= 4'b0001;
			   end // if (opcode == STO)
			 else
			   begin
			      {inc_pc,
			       load_acc,
			       load_pc,
			       rd}          <= 4'b0000;
			      {wr,
			       load_ir,
			       halt,
			       datactl_ena} <= 4'b0000;
			   end // else: !if(opcode == STO)
		     state <= 3'b101;
		  end // case: 3'b100
		3'b101:
		  begin
		     if(opcode == ADD || opcode == ANDD || opcode == XORR || opcode == LDA)
		       begin
			  {inc_pc,
			   load_acc,
			   load_pc,
			   rd}          <= 4'b0101;
			  {wr,
			   load_ir,
			   halt,
			   datactl_ena} <= 4'b0000;
		       end // if (opcode == ADD || opcode == ANDD || opcode == XORR || opcode == LDA)
		     else
		       if(opcode == SKZ && zero == 1)
			 begin
			    {inc_pc,
			     load_acc,
			     load_pc,
			     rd}          <= 4'b1000;
			    {wr,
			     load_ir,
			     halt,
			     datactl_ena} <= 4'b0000;
			 end // if (opcode == SKZ && zero == 1)
		       else
			 if(opcode == JMP)
			   begin
			      {inc_pc,
			       load_acc,
			       load_pc,
			       rd}          <= 4'b1010;
			      {wr,
			       load_ir,
			       halt,
			       datactl_ena} <= 4'b0000;
			   end // if (opcode == JMP)
			 else
			   if(opcode == STO)
			     begin
				{inc_pc,
				 load_acc,
				 load_pc,
				 rd}          <= 4'b0000;
				{wr,
				 load_ir,
				 halt,
				 datactl_ena} <= 4'b1001;
			     end // if (opcode == STO)
			   else
			     begin
				{inc_pc,
				 load_acc,
				 load_pc,
				 rd}          <= 4'b0000;
				{wr,
				 load_ir,
				 halt,
				 datactl_ena} <= 4'b1010;
			     end // else: !if(opcode == STO)
		     state <= 3'b110;
		  end // case: 3'b101
		3'b110:
		  begin
		     if(opcode == STO)
		       begin
			  {inc_pc,
			   load_acc,
			   load_pc,
			   rd}          <= 4'b0000;
			  {wr,
			   load_ir,
			   halt,
			   datactl_ena} <= 4'b0001;
		       end // if (opcode == STO)
		     else
		       if(opcode == ADD || opcode == ANDD || opcode == XORR || opcode == LDA)
			 begin
			    {inc_pc,
			     load_acc,
			     load_pc,
			     rd}          <= 4'b0001;
			    {wr,
			     load_ir,
			     halt,
			     datactl_ena} <= 4'b0000;
			 end // if (opcode == ADD || opcode == ANDD || opcode == XORR || opcode == LDA)
		       else
			 begin
			    {inc_pc,
			     load_acc,
			     load_pc,
			     rd}          <= 4'b0000;
			    {wr,
			     load_ir,
			     halt,
			     datactl_ena} <= 4'b0000;
			 end // else: !if(opcode == ADD || opcode == ANDD || opcode == XORR || opcode == LDA)
		     state <= 3'b111;
		  end // case: 3'b110
		3'b111:
		  begin
		     if(opcode == SKZ && zero == 1)
		       begin
			  {inc_pc,
			   load_acc,
			   load_pc,
			   rd}          <= 4'b1000;
			  {wr,
			   load_ir,
			   halt,
			   datactl_ena} <= 4'b0000;
		       end // if (opcode == SKZ && zero == 1)
		     else
		       begin
			  {inc_pc,
			   load_acc,
			   load_pc,
			   rd}          <= 4'b0000;
			  {wr,
			   load_ir,
			   halt,
			   datactl_ena} <= 4'b0000;			  
		       end // else: !if(opcode == SKZ && zero == 1)
		     state <= 3'b000;
		  end // case: 3'b111
		default:
		  begin
		     {inc_pc,
		      load_acc,
		      load_pc,
		      rd}          <= 4'b0000;
		     {wr,
		      load_ir,
		      halt,
		      datactl_ena} <= 4'b0000;		     
		  end // case: default
	      endcase // casex (state)
	   end
	endtask // ctl_style
endmodule // machine

     
   