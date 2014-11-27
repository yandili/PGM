%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1). 
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the 
%   network where M(i) represents the ith variable and M(i).val represents 
%   the marginals of the ith variable. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
% you should set it to the correct value in your code
M = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Implement Exact and MAP Inference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We need first to construct the clique tree P from F
P = CreateCliqueTree(F, E);
% Calibrate the clique tree
P = CliqueTreeCalibrate(P, isMax);
 
N = length(P.cliqueList); % number of cliques
varInClique = [];
% Find the clique that contains each variable
for i = 1:N
  for j = P.cliqueList(i).var
    if j > length(varInClique) || varInClique(j) == 0
      % the variable j hasn't found a clique number yet
      varInClique(j) = i; 
      continue;
    end
  end
end


M = repmat(struct('var',[],'card',[],'val',[]), length(varInClique), 1);
% Compute marginals
for i = 1:length(varInClique)
  c = varInClique(i); % clique for variable i
  % marginalize all variables other than i
  F = P.cliqueList(c);
  if isMax == 0
    M(i) = FactorMarginalization(F, setdiff(F.var, i));
    % normalization
    tot = sum(M(i).val);
    M(i).val = M(i).val ./ tot;
  else
    M(i) = FactorMaxMarginalization(F, setdiff(F.var, i));
  end
end

%% For debugging
% load('PA4Sample.mat', 'SixPersonPedigree');
% ComputeExactMarginalsBP(SixPersonPedigree, [], 0);
% ComputeMarginal(1, SixPersonPedigree, []); % compute the marginal of var=1
% % they agree on the first variable
end
