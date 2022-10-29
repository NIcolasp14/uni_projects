axis([1 4000 1 4000])
x=1:1:4000;

t1 = (20000 + 20*x)./x;
plot(x, t1, 'r'); 
hold on;
 
t2= (10000 + 40*x)./x; 
plot(x, t2, 'g'); 
hold on;

t3 = (100000 + 4*x)./x; 
plot(x, t3, ’b');
hold on; 

t4 = (200000 + 2*x)./x;
plot(x, t4, ’k'); 
