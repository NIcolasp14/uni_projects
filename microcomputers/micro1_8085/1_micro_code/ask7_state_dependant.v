
module 
  state_dependant(s_in, clk, rst, d_out);
input clk; 
input rst; 
input s_in;
output reg d_out; 
parameter
  a=2'b00, b=2'b01, c=2'b10, d=2'b11;
reg [2:0] current_state, next_state;  

always @(posedge clk, posedge rst)
begin
 if(rst==1) 
 current_state <= a;
  
 else
 current_state <= next_state; 
end 

always @(current_state,s_in)
begin
 case(current_state) 
 a:begin
  if(s_in==1)
   next_state = a;
  else
   next_state = d;
 end
 b:begin
  if(s_in==0)
   next_state = c;
  else
   next_state = a;
 end
 c:begin
  if(s_in==0)
   next_state = b;
  else
   next_state = d;
 end 
 d:begin
  if(s_in==0)
   next_state = c;
  else
   next_state = d;
 end
 default:next_state = a;
 endcase
end

  
always @(current_state)
begin 
 case(current_state) 
 a:   d_out = 0;
 b:   d_out = 1;
 c:  d_out = 1;
 d:  d_out = 0;
 default:  d_out = 0;
 endcase
end 
endmodule