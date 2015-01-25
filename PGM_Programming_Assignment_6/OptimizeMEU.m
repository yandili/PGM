% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique OPTIMAL decision.
  D = I.DecisionFactors(1);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
  % calculate the utility factor
  EUF = CalculateExpectedUtilityFactor(I);
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
