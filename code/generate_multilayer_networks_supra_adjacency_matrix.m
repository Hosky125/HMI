% This function lays out the B matirx which can be fed to the Louvain algorithm to calculate Q. 
% It is programmed SPECIFICALLY for a a multilayer network with 2 bipartite layers connected via one common set of nodes (diagonal coupling).

%Step1:generate supra adjacency matrix
%The supra adjacency matrix represented by B must be both symmetric and square.
%Then matrix B implements a Louvain-like greedy community detection method.

% Modified by Haotian Zhang on March 6, 2025
function [B_multilayer,mm_multilayer] = generate_multilayer_networks_supra_adjacency_matrix(A1,A2,gamma,interlayer_link_strength,show_Bmax)
    mm_multilayer=0; % Initialize twomu
    %==== Set up the modularity matrix for layer 1: B_1ayer1
    % This is simply modularity for a bipartite single-layer network
    %====
    [m,n]=size(A1);
    N1=m+n;
    k=sum(A1,2);%Modified,for weight network,calculate degree
    d=sum(A1,1);%Modified,for weight network,calculate degree
    mm=sum(k);%Modified,total edge weight in layer
    B_bip=A1-gamma*k*d/mm;
    B=zeros(N1,N1);
    % One should be VERY careful in how the B matrix is composed. 
    B(1:m,m+1:N1)=B_bip;
    B(m+1:N1,1:m)=B_bip';
    B_layer1=B;
    mm_multilayer=mm_multilayer+2*mm;  %Motified,intralayer links have weight
   
    %==== Set up the modularity matrix for layer 2: B_1ayer2
    % This is simply modularity for a bipartite single-layer network
    %====
    [p,q]=size(A2);
    N2=p+q;
    k=sum(A2,2);
    d=sum(A2,1);
    mm=sum(k);
    B_bip=A2-gamma*k*d/mm;
    B=zeros(N2,N2);
    B(1:p,p+1:N2)=B_bip;
    B(p+1:N2,1:p)=B_bip';
    B_layer2=B;
    mm_multilayer=mm_multilayer+2*mm;       %Motified,intralayer links have weight

    %The second term in twomu should be the total weight of all interlayer edges, i.e.,since we only have interlayer edges between nodes in set1,
    %which is on the matrices rows, we use m:
    mm_multilayer=mm_multilayer+2*sum(interlayer_link_strength);%Motified,interlayer links have weight,total weight of all interlayer edges

    %==== Now set up the B matrix of the multilayer
    % by combining the individual B matrices
    %====
    B_multilayer=zeros(N1+N2,N1+N2); % create the matrix, filled with zeros
    B_multilayer(1:N1,1:N1)=B_layer1; % Modularity matrix of layer 1 (set1 and set2)
    B_multilayer(N1+1:N1+N2,N1+1:N1+N2)=B_layer2; % Modularity matrix of layer 2 (set1 and set3)
    B_multilayer(N1+1:N1+m,1:m)=diag(interlayer_link_strength); % Interlayer interactions between the nodes which are in the rows (and hence the use of m)
    B_multilayer(1:m,N1+1:N1+m)=diag(interlayer_link_strength);  % Interlayer interactions between the nodes which are in the rows (and hence the use of m)
    
    if ~issymmetric(B_multilayer)
        disp('The modularity matrix is NOT symmetric!!')
    end
    
    % The value above which there will be an abrupt drop in intra-layer merges (see Bazzi et al 2015, pg. 32):
    if show_Bmax==1
        m1=max(max(B_layer1));
        m2=max(max(B_layer2));
        disp(max(m1,m2));
    end
end