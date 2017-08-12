%%
% This is the main RL entry

%% Game initialization
clear all;
numberOfNodes = 5;

AttackerPoints = 100;
DeffenderPoints = 50;

gamePoints = 0;

services_lable = {'http', 'ftp', 'dns','ntp', 'telnet'};
% service_cost = (1:length(services_lable));


service_state = ones(size(services_lable));

link_state = 0 ; %a cell containing all unique combination of nodes not including itself, sum of services/2

dataState = 1;
virusState = 1;

points = (1:3);


points(1,1) = AttackerPoints;
points(1,2) = DeffenderPoints;
points(1,3) = gamePoints;

% node = linspace(1,nServices,nServices);

nodeState = ones(size(services_lable)+dataState+virusState)
nodeState = ones(size(nodeState(1,:)))

%  nodes = ones(numberOfNodes,length(nodeState(1,:)));
 nodes = ones(numberOfNodes);

A = nodes - diag(nodes(1,:));
G = graph(A~=0);
% G = graph(nodes)
p = plot(G);
%axis equal


%  for k=1:height(G.Nodes)
 G.Nodes.Services = zeros(height(G.Nodes), length(services_lable));
 G.Nodes.Infected = zeros(height(G.Nodes),1);
 G.Nodes.DataCompromised = ones(height(G.Nodes),1);

 
 G.Edges.Links = zeros(height(G.Edges),1);
%  end

XXSON = getValidActions(G,1,50);


% gstate = ones(numberOfNodes, size(nodeState(1,:)))


learnRate = 0.99;


%%% Exploration vs. exploitation
% Probability of picking random action vs estimated best action
epsilon = 0.5; % Initial value
epsilonDecay = 0.98; % Decay factor per iteration.

%%% Future vs present value
discount = 0.9; % When assessing the value of a state & action, how important is the value of the future states?

%%% Inject some noise?
successRate = 1; % How often do we do what we intend to do?
% E.g. What if I'm trying to turn left, but noise causes
% me to turn right instead. This probability (0-1) lets us
% try to learn policies robust to "accidentally" doing the
% wrong action sometimes.

winBonus = 100;  % Option to give a very large bonus when the system reaches the desired state (pendulum upright).




% states = {nodeState, points}

% R = rewardFunc(states(:,1),states(:,2));
% Q = repmat(R,[1,3]); % Q is length(x1) x length(x2) x length(actions) - IE a bin for every action-state combination.




%clear all;
%% test graph

[B,V] = bucky;
G = graph(B);
p = plot(G);
axis equal

%% Generate a state list
graph;

states=zeros(length(x1)*length(x2),2); % 2 Column matrix of all possible combinations of the discretized state.
index=1;
for j=1:length(x1)
    for k = 1:length(x2)
        states(index,1)=x1(j);
        states(index,2)=x2(k);
        index=index+1;
    end
end

%% Actoin list

 XXSONATT = getValidActions(G,1,400);
 XXSONDEF = getValidActions(G,2,400);
%% Pareto Calculation
XXXXCOMBINEDREWARD = getCombinedRewards(XXSONATT,XXSONDEF, G);
XXXXCPartoDEFENDER = getParetoFronts(XXSONATT,XXSONDEF, G,2);
XXXXCPartoATTACKER = getParetoFronts(XXSONDEF,XXSONATT, G,1);
% XXXXCPartoCOMBINEDREWARD = XXXXCParto(:,:,2)