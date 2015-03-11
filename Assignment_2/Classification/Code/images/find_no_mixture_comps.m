function num_comps = find_no_mixture_comps(data,MaxComp,iters)

num_comp_best = zeros(MaxComp,1);
for iter = 1:iters
    BIC = zeros(MaxComp,1);
    GMModels = cell(MaxComp,1);
    options = statset('MaxIter',200);
    for k = 1:MaxComp
        GMModels{k} = fitgmdist(data,k,'Regularize',0.1, 'CovType','diagonal','Options', options);
        BIC(k)= GMModels{k}.BIC;
    end
    [minBIC,numComponents] = min(BIC);
    num_comp_best(numComponents) = num_comp_best(numComponents) + 1;
end

num_comp_best
[~,num_comps] = max(num_comp_best);
