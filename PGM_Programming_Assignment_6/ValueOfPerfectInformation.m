% Script for Question 7, Value of Perfect Information
clear TestI0;
load('TestI0.mat');

% Before we link from Test node to the Decision node
[MEU0, OptimalDecisionRule0] = OptimizeWithJointUtility(TestI0)
pause;

% Next up, we link Test node 11 to the decision node
D = TestI0.DecisionFactors; 
D.var = [D.var, 11];
D.card = [D.card, 2];
D.val = zeros(1, prod(D.card));
TestI0.DecisionFactors = D;
answers = zeros(1,3);

% We modify factor(edge) 10 from ARVD node 1 to Test node 11
F = struct('var',[1,11], 'card',[2,2], 'val', [0.75, 0.001, 0.25, 0.999]);
TestI0.RandomFactors(10) = F;
[MEU, OptimalDecisionRule] = OptimizeWithJointUtility(TestI0)
d = exp((MEU-MEU0)/100) - 1;
answers(1) = d;
pause;

% We modify factor(edge) 10 from ARVD node 1 to Test node 11
F = struct('var',[1,11], 'card',[2,2], 'val', [0.999, 0.25, 0.001, 0.75]);
TestI0.RandomFactors(10) = F;
[MEU, OptimalDecisionRule] = OptimizeWithJointUtility(TestI0)
d = exp((MEU-MEU0)/100) - 1;
answers(2) = d;
pause;

% We modify factor(edge) 10 from ARVD node 1 to Test node 11
F = struct('var',[1,11], 'card',[2,2], 'val', [0.999, 0.001, 0.001, 0.999]);
TestI0.RandomFactors(10) = F;
[MEU, OptimalDecisionRule] = OptimizeWithJointUtility(TestI0)
d = exp((MEU-MEU0)/100) - 1;
answers(3) = d;
pause;

answers
