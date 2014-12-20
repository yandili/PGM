% MHUNIFORMTRANS
%
%  MCMC Metropolis-Hastings transition function that
%  utilizes the uniform proposal distribution.
%  A - The current joint assignment.  This should be
%      updated to be the next assignment
%  G - The network
%  F - List of all factors
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function A = MHUniformTrans(A, G, F)
% Draw proposed new state from uniform distribution
A_prop = ceil(rand(1, length(A)) .* G.card);

p_acceptance = 0.0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Compute acceptance probability
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stationary dist of assignment A_prop 
log_pi_prop = LogProbOfJointAssignment(F, A_prop); 
% stationary dist of assignment A 
log_pi = LogProbOfJointAssignment(F, A);
% we can omit Q(x->x') = Q(x'->x)
p_acceptance = min([1, exp(log_pi_prop - log_pi)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Accept or reject proposal
if rand() < p_acceptance
    % disp('Accepted');
    A = A_prop;
end
