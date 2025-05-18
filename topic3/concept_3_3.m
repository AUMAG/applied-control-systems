
m = 1;
k = 5;
c = 2;

Aorig = [0 0 1 0;0 0 0 1;
  -2*k/m k/m -c/m 0;
  k/m -2*k/m 0 -c/m]

A1 = [0 1;-k/m -c/m]
A2 = [0 1;-3*k/m -c/m]
A = blkdiag(A1,A2)

eig(A1)
eig(A2)
eig(A)
eig(Aorig)