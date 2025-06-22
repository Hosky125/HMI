function [B_multilayer,mm_multilayer] = generate_multilayer_modularity_matrix(A,p,q,gamma,networktype,interlayer_links_type,interlayer_links_weight)
%A:每层数据转换为supra-matrix后的数据,Bipartite networks have to be transformed to unipartite (square matrix).
%p,q:size(monolayer data),行数和列数。比如：hosts-parasites network,p表示hosts的物种数，q表示parasites的物种数
%gamma:默认为1
%networktype:bipartite or unipartite,这决定了使用bipartite multilayer modularity or unipartite multilayer modularity
%interlayer_links_type:层间连接方式是diagonal coupling(只有某一营养级物种起到连接作用)还是multiplex（所有物种都起到连接作用）
%interlayer_links_weight:矩阵，维度由connector species和layers决定
%输出：B_multilayer表示modularity matrix,用于genlouvain()
%      mm_multilayer表示2mu,根据genlouvain()的结果，计算multilayer modularity时用到

N=length(A{1}); % Number of nodes (p+q)
L=length(A); % Number of layers

B_multilayer=spalloc(N*L,N*L,N*N*L+2*N*L); % create an empty modularity matrix
mm_multilayer=0;

%-------------------------------------------------------------------------%
for s=1:L
    % In the unipartite case, the probability P is k_is*d_js/(2*m_s)
    % In the bipartite case, the probability P is k_is*d_js/m_s and the division is over the number of edges m (see Barber 2007, eq. 15 for reasoning).
    
    k=sum(A{s}); % this is the sum of degrees of the nodes in the two sets
    k=k(1:p); % i.e., k_is
    d=sum(A{s}); % this is the sum of degrees of the nodes in the two sets
    d=d((p+1):N); % i.e., d_js
    if "bipartite"==networktype
        m=sum(k); % Note the m instead of twom as in unipartite
    end
    
    if "unipartite"==networktype
        m=sum(k)*2; % Note the m instead of twom as in unipartite
    end
    mm_multilayer=mm_multilayer+m; % Note that we add m and not 2m to the mu(mm_multilayer). In the unipartite version this is twomu=twomu+twom
    indx=[1:N]+(s-1)*N;
    
    % This calculates the matrix of probabilities accroding to eq. 15 in Barber 2007
    P_ij=zeros(p,q);
    for i=1:p
        for j=1:q
            P_ij(i,j)=k(i)*d(j);
        end
    end
    
    % Here again we have to create a smymetric adjacency matrix
    onemode=zeros(N,N);
    onemode(1:p, (p+1):N)=P_ij;
    onemode((p+1):N, 1:p)=P_ij';
    P_ij=onemode;
    B_multilayer(indx,indx)=A{s}-gamma*P_ij/m; % Note the P_ij instead of k*k' as in the unipartite version. also the m instead of 2m
end
%-------------------------------------------------------------------------%
% added interlayer links weight
if size(interlayer_links_weight,1)==1
    mm_multilayer=mm_multilayer+2*sum(interlayer_links_weight);
else
    mm_multilayer=mm_multilayer+2*sum(sum(interlayer_links_weight));
end

if "diagonal_coupling"==interlayer_links_type
    interlayer_links_weight_matrix=zeros(N*L,N*L);
    if size(interlayer_links_weight,2)==p
        for s=1:(L-1)
            interlayer_links_weight_matrix((1:p)+s*N,(1:p)+(s-1)*N)=diag(interlayer_links_weight(s,:));
            interlayer_links_weight_matrix((1:p)+(s-1)*N,(1:p)+s*N)=diag(interlayer_links_weight(s,:));
        end
    end
    
    if size(interlayer_links_weight,2)==q
        for s=1:(L-1)
            interlayer_links_weight_matrix(((p+1):N)+s*N,((p+1):N)+(s-1)*N)=diag(interlayer_links_weight(s,:));
            interlayer_links_weight_matrix(((p+1):N)+(s-1)*N,((p+1):N)+s*N)=diag(interlayer_links_weight(s,:));
        end
    end
    
end

if "multiplex"==interlayer_links_type
    interlayer_links_weight_matrix=zeros(N*L,N*L);
    for s=1:(L-1)
        interlayer_links_weight_matrix((1:N)+s*N,(1:N)+(s-1)*N)=diag(interlayer_links_weight(s,:));
        interlayer_links_weight_matrix((1:N)+(s-1)*N,(1:N)+s*N)=diag(interlayer_links_weight(s,:));
    end
end

B_multilayer = B_multilayer + interlayer_links_weight_matrix;

end