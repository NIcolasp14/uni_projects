//Βοηθητικά modules
module half_adder (output S, C, input x, y); 
              xor (S, x, y);
              and (C, x, y);
endmodule



module full_adder (output S, C, input x, y, z); 
              wire S1, C1, C2;
              half_adder HA1 (S1, C1, x, y); //Instantiate HAs
              half_adder HA2 (S, C2, S1, z);
              or G1 (C, C2, C1);
endmodule

//Module αθροιστή-αφαιρέτη 4bit
module adder_subtractor(output [3:0] S, output C4, V, input M, input [3:0] A, B);

              wire C1, C2, C3;
              wire b0, b1, b2, b3;
    
              xor G1 (b0, B[0], M);
              xor G2 (b1, B[1], M);
              xor G3 (b2, B[2], M);
              xor G4 (b3, B[3], M);

              full_adder FA_0 (S[0], C1, A[0], b0, M);
              full_adder FA_1 (S[1], C2, A[1], b1, C1);
              full_adder FA_2 (S[2], C3, A[2], b2, C2);
              full_adder FA_3 (S[3], C4, A[3], b3, C3);

              xor G5 (V, C4, C3);

end module

module adder_subtractor(output [3:0] S, output C4, V, input M, input [3:0] A, B);
              assign {S, C4} = M ? A - B : A + B;
endmodule