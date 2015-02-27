function num_comps = find_no_mixture_comps(data,MaxComp,iters)

num_comp_best = zeros(MaxComp,1);
for iter = 1:iters
    AIC = zeros(MaxComp,1);
    GMModels = cell(MaxComp,1);
    options = statset('MaxIter',100);
    for k = 1:MaxComp
        GMModels{k} = fitgmdist(data,k,'Options',options);
        AIC(k)= GMModels{k}.AIC;
    end
    [minAIC,numComponents] = min(AIC);
    num_comp_best(numComponents) = num_comp_best(numComponents) + 1;
end

num_comp_best
[~,num_comps] = max(num_comp_best);
