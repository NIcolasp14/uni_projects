module Circuit (input A, B, C, D, E,  output F1, F2, F3, F4); 
wire A’, B’, C’, D’; 
not (A’, A); 
not (B’, B); 
not (C’, C); 
not (D’, D); 

// F1 = A(BC +D) + B'C'D 
wire w1, w2, w3, w4; 
and (w1, B, C); 
or    (w2, w1, D); 
and (w3, A, w2); 
and (w4, B’, C’, D); 
or    (F1, w3, w4)

// F2 (A, B, C, D) = Σ (0, 2, 3, 5, 7, 9, 10, 11, 13, 14) 
wire r0, r2, r3, r5, r7, r9, r10, r11, r13, r14; 
and (r0, A’, B’, C’, D’); 
and (r2, A’, B’, C, D’); 
and (r3, A’, B’, C, D); 
and (r5, A’, B, C’, D); 
and (r7, A’, B, C, D); 
and (r9, A, B’, C’, D); 
and (r10, A, B’, C, D’); 
and (r11, A, B’, C, D); 
and (r13, A, B, C’, D); 
and (r14, A, B, C, D’); 
or    (F2, r0, r2, r3, r5, r7, r9, r10, r11, r13, r14); 

// F3 = ABC + (A + BC)D + (B + C)DE 
wire w5, w6, w7, w8, w9, w10; 
and (w5, A, B, C); 
or    (w6, A, w1); 
and (w7, w6, D); 
and (w8, D, E); 
or    (w9, B, C); 
and (w10, w9, w8); 
or    (F3, w5, w7, w10); 

// F4 = A(B + CD + E) + BCDE 
wire w11, w12, w13, w14; 
and (w11, C, D); 
or    (w12, B, w11, E); 
and (w13, A, w12); 
and (w14, B, C, D, E); 
or    (F4, w13, w14); 
endmodule 

module Circuit (input A, B, C, D, E,  output F1, F2, F3, F4); 
assign 
// F1 = A(BC + D) + B'C'D 
F1 = (A & ((B & C) | D)) | (~B, ~C, D), 

// F2 (A, B, C, D) = Σ (0, 2, 3, 5, 7, 9, 10, 11, 13, 14) 
F2 = (~A & ~B & ~C & ~D) | (~A & ~B & C & ~D)|(~A & ~B & C & D) | (~A & B & ~C & D) 
| (~A & B & C & D) | (A & ~B & ~C & D) | (A & ~B & C & ~D) | (A & ~B & C & D)(A & B & ~C & D) 
|(A & B & C & ~D), 

// F3 = ABC + (A + BC)D + (B+ C)DE 
F3 = (A & B & C) | ((A | (B & C)) & D) | ((B | C) & D & E), 

// F4 = A(B + CD + E) + BCDE 
F4 = (A & (B | (C & D) | E)) | (B & C & D & E); 
endmodule 
