% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
  %
  % This is similar to OptimizeMEU except that we will have to account for
  % multiple utility factors.  We will do this by calculating the expected
  % utility factors and combining them, then optimizing with respect to that
  % combined expected utility factor.  
  MEU = [];
  OptimalDecisionRule = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  % A decision rule for D assigns, for each joint assignment to D's parents, 
  % probability 1 to the best option from the EUF for that joint assignment 
  % to D's parents, and 0 otherwise.  Note that when D has no parents, it is
  % a degenerate case we can handle separately for convenience.
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  EUF = CalculateExpectedUtilityFactor(I); %modified Calc
  F = EUF(1);
  for i = 2:length(EUF)
       F = FactorSum(F, EUF(i));
  end
  EUF = F;
  
  D = I.DecisionFactors(1);
  D.val = zeros(1,length(D.val));
  
  if length(D.var) < 2
      % empty parent set, 
      % we simply select the decision that maximize utility, 
      % and set the corresponding val to be 1
      [MEU, ind] = max(EUF.val);
      D.val(ind) = 1;
  else
      % got parents in making decisions
      % we slice EUF by each assignment of parents in D
      % within each slice we find the maximum utility value and record the action index in D
      MEU = 0;
      parentAssignment = IndexToAssignment(1:prod(D.card(2:end)),D.card(2:end));
      for parent = parentAssignment'
          decisions = (1:D.card(1))';
          % different actions wrt the same parent
          assignment = [decisions, repmat(parent, length(decisions), 1)];
          % arrange the columns in the order of variables in EUF
          [~, ord] = ismember(D.var, EUF.var);
          [MEUi, i] = max(GetValueOfAssignment(EUF, assignment(:,ord)));
          
          MEU = MEU + MEUi;
          D = SetValueOfAssignment(D,assignment(i,:),1);
      end
  end

  OptimalDecisionRule = D;


end
