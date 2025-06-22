function [B,mm]=generate_monolayer_networks_supra_adjacency_matrix(A,gamma) 
    %A is the weight of the intralayer edge between nodes i and j on layer s
    [m,n]=size(A);
    N=m+n;
    k=sum(A,2);%Modified
    d=sum(A,1);%Modified
    mm=sum(k);%Modified
    B1=A-gamma*k*d/mm;
    B=zeros(N,N);
    B(1:m,m+1:N)=B1;
    B(m+1:N,1:m)=B1';
end