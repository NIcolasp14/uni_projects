module edge_dependant( clk, rst, eisodos, eksodos);

   input clk, rst, eisodos;
   output eksodos;

   reg [1:0] state;
   reg eksodos;
   parameter a = 2'b00, b = 2'b01, c = 2'b10, d = 2'b11;
   always @( posedge clk, posedge rst ) begin
   if( rst ) begin
       state <= 2'b00;
       eksodos <= 0;
   end
   else  begin
       case( state )
       a: begin
            if( eisodos ) begin
               state <= a;
               eksodos  <= 0;
            end
            else begin
                state <= d;
                eksodos <= 1;
            end
       end

       b: begin
            if( eisodos ) begin
                state <= a;
                eksodos  <= 0;
            end
            else  begin
               state <= c;
               eksodos <= 1;
            end

       end

       c: begin
            if( eisodos ) begin
                state <= b;
                eksodos  <= 0;
            end
            else begin
               state <= d;
               eksodos <= 1;
            end

       end
      d: begin
            if( eisodos ) begin
                state <=d;
                eksodos  <= 1;
            end
            else begin
               state <= c;
               eksodos <= 0;
            end

       end
       default: begin
            state <= 2'b00;
            eksodos <= 0;
       end
     endcase
   end
end

endmodule