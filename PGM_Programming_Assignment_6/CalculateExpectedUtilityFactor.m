% Copyright (C) Daphne Koller, Stanford University, 2012

function EUF = CalculateExpectedUtilityFactor( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: A factor over the scope of the decision rule D from I that
  % gives the conditional utility given each assignment for D.var
  %
  % Note - We assume I has a single decision node and utility node.
  EUF = []; % the miu factor in the instruction
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  % Different from the way we compute SimpleCalcExpectedUtility
  % , where we group first the RandomFactors and DecisionFactors
  % , now we seperate decision from others
  F = [I.RandomFactors, I.UtilityFactors];
  D = I.DecisionFactors;

  % List of variables but for those in the decision factor
  V = setdiff(unique([F(:).var]),D.var);

  % Eliminate all variables results the expected utility
  EUF_L = VariableElimination(F,V);
  
  EUF = EUF_L(1);
  for i = 2:length(EUF_L)
    EUF = FactorProduct(EUF,EUF_L(i));
  end

  
end  
