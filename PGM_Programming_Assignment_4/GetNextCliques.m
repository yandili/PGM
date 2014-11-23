%GETNEXTCLIQUES Find a pair of cliques ready for message passing
%   [i, j] = GETNEXTCLIQUES(P, messages) finds ready cliques in a given
%   clique tree, P, and a matrix of current messages. Returns indices i and j
%   such that clique i is ready to transmit a message to clique j.
%
%   We are doing clique tree message passing, so
%   do not return (i,j) if clique i has already passed a message to clique j.
%
%	 messages is a n x n matrix of passed messages, where messages(i,j)
% 	 represents the message going from clique i to clique j. 
%   This matrix is initialized in CliqueTreeCalibrate as such:
%      MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);
%
%   If more than one message is ready to be transmitted, return 
%   the pair (i,j) that is numerically smallest. If you use an outer
%   for loop over i and an inner for loop over j, breaking when you find a 
%   ready pair of cliques, you will get the right answer.
%
%   If no such cliques exist, returns i = j = 0.
%
%   See also CLIQUETREECALIBRATE
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function [i, j] = GetNextCliques(P, messages)

% initialization
% you should set them to the correct values in your code
i = 0;
j = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For debugging the code, use GetNextC.INPUT1 as the clique tree
% and GetNextC.INPUT2 as the message matrix. 
% The output should be [GetNextC.RESULT1, GetNextC.RESULT2]

% The edge of the clique tree is considered as directed, where one 
% can pick either (i,j) or (j,i) to be one, and choose a node to be 
% the root, thus turning it into a directd tree. 
% The complement order is used later for the reverse message passing.
% Assume that we simply select the lower triangle to be 
% the first pass order.

% TARGET CHANGED:
% Instead of precribing an order, we check by searching smallest node
% that is activated to pass msg. A node is activated if 
%   -- it has received msgs from all its neighbors (in edge); or
%   -- all but one msgs from its neighbors. 
% In the first case, the receipt can be any neighbor;
% in the second case, the receipt has to be the one without sending msg,
% cause otherwise, it has to await for its msg to pass to others.
% So, in this schema, the two pass phase are interwined, 
% and algorithm works like an automata.

N = length(P.cliqueList);
for i = 1:N
  tmp = 1:N;
  neighbors = tmp(logical(P.edges(i,:))); %e.g. 1->8, neighbors = [8]
  
  % nodes who has sent their msg to i
  inbox = []; 
  for k = neighbors
    if ~isempty(messages(k,i).var)
      inbox = [inbox, k];
    end
  end

  inboxShort = setdiff(neighbors,inbox);
  % the number of branches awaiting msgs
  inboxShortSize = length(inboxShort);

  if inboxShortSize >= 2
    % if more than two incoming msg is missing, the node i cannot be activated
    continue;
  end

  % nodes to whom i has sent its msg 
  outbox = []; 
  for k = neighbors
    if ~isempty(messages(i,k).var)
      outbox = [outbox, k];
    end
  end
  
  receipts = setdiff(neighbors, outbox); % sorted from small to large 
  % neighbors still awaiting msg from i = neighbors\(those i has sent a msg)
  if isempty(receipts)
    % if all receipts has already got the msg from i, then next
    continue;
  end

  % By far, node i has received either all or all but one msgs,
  % In the first case, we output the smallest neighbor
  % In the second case, we need to find out which of the receipts hasn't sent yet
  if inboxShortSize == 0
    j = min(receipts); % pick the smallest current receipt
    return; % output i,j
  elseif ismember(inboxShort,receipts) 
    % inboxShortSize == 1 and msg not sent yet
    j = inboxShort;
    return; % output i,j
  else 
    % inboxShortSize == 1 and msg sent already
    continue;
  end

end

i = 0; j = 0;
return;
