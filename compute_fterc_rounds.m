function [rcTotalRounds,mu] = compute_fterc_rounds(x_arxiv,y_arxiv,P,A,endItr)
 
%% FIND THE FINAL VALUES OF THE ITERATIONS without DELAYS
n = size(P,1); 

[xbar,twoDiameters] = compute_coefficient_vector(x_arxiv,endItr);
[ybar,twoDiameters] = compute_coefficient_vector(y_arxiv,endItr);
    
g=sprintf('%d ', twoDiameters);
fprintf('Number of steps needed to users to compute the average: %s\n', g)

mu=cell2mat(xbar)./cell2mat(ybar);

flag=zeros(n,1);
M=ones(n,1);
arxiv_M=M;
counter=zeros(n,1);
arxiv_counter=counter;

%% Termination methodology
i=1;
while i <= endItr
    if sum(flag)< n
        for j=1:n
            if i<twoDiameters(j)
                M(j)=M(j)+1;
            end
        end
        for j=1:n
            if flag(j)==0
                B1=A(j,:).*M';
                M(j)=max(B1);
            end
        end
        arxiv_M=[arxiv_M M];
        
        for j=1:n
            if flag(j)==0
                if M(j)==arxiv_M(j,i)
                    counter(j)=counter(j)+1;
                    if counter(j)>=twoDiameters(j)
                        flag(j)=1;
                        fprintf('Node %d at time step %d.\n',j,i)
                    end
                elseif M(j)< arxiv_M(j,i+1)
                    counter(j)=0;
                end
            end
        end
        arxiv_counter=[arxiv_counter counter];
        i=i+1;
    else
        fprintf('All nodes terminated their operation at time step %d.\n',i-1)
        rcTotalRounds = i-1;
        break
    end
end 