function [coefficientVector, twoDiameters] = compute_coefficient_vector(stateArxiv,endItr)

n = size(stateArxiv,1);

for r = 1:n
    for i = 2:(endItr/2-1)
        % Build the Hankel matrix based on the measurements
        hankelFirstCol_curr = stateArxiv(r,1:i);
        hankelLastRow_curr = stateArxiv(r,i:(2*i-1));
        hankel_curr{r,i} = hankel(hankelFirstCol_curr,hankelLastRow_curr);
        
        % Build the Hankel matrix based on the +1 measurements
        hankelFirstCol_next = stateArxiv(r,(1+1):(i+1));
        hankelLastRow_next = stateArxiv(r,(i+1):((2*i-1)+1));
        hankel_next{r,i} = hankel(hankelFirstCol_next,hankelLastRow_next);
        
        % Subtract the two Hankel matrices
        hankel_final{r,i} = hankel_curr{r,i} - hankel_next{r,i};
        % Find the rank
        RankAnswer{r,i} = rank(hankel_final{r,i});
        % if the rank is smaller than the measurement i (i.e., there is a
        % loss of rank) then stop.
        if(RankAnswer{r,i} < i)
            break;
        end
    end
    % find the orthonormal basis for the null space of SubstructionHankel1{r,i}
    % i.e., \beta_j
    beta{r} = null(hankel_final{r,i});
    % find its size
    [beta_row{r},beta_col{r}]=size(beta{r});
    % find vector \phi
    coefficientVector{r} = (stateArxiv(r,1:beta_row{r})*beta{r})/(ones(1,beta_row{r})*beta{r});
    
    twoDiameters(r)=2*(cell2mat(beta_row(r))+1);
end