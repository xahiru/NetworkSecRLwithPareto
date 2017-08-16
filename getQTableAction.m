function [ action_and_qvalue_indices ] = getQTableAction(G, ACTIONS, player, QTABLE, qTableSize, epsilon )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% QValVactor = zeros(40,1);

% State = table2array(G.Nodes);
% State_size = size(State);
% State = reshape(State,[State_size(1)*State_size(2),1]);


% epsilon = 0.3;
random_qvalue_reward_index = randi([1 3], 1);
action_qvalue_index = nan(length(ACTIONS),2);
action_and_qvalue_indices = [0,0];

% length(ACTIONS)


if (rand() >= epsilon)

    for n = 1 : size(ACTIONS,1) 

%        for m = 1: size(QTABLE,1)
        for m = 1: qTableSize

            if(isempty(QTABLE{m,1} ))
              break;
            end

            % save the Q-value of the find state-action pair 
            if (isequal(QTABLE{m,1},G)  & isequal(QTABLE{m,2},[ACTIONS{n},ACTIONS{n,2}]) & QTABLE{m,3}  == player)
               action_qvalue_index(n,1) = m;
               action_qvalue_index(n,2) = QTABLE{m,4}(random_qvalue_reward_index);
               break;
            end

        end

    end

    if(~isempty(find(~isnan(action_qvalue_index(:,1))))) 
        chosen_action_index = datasample(find(action_qvalue_index(:,2) == max(action_qvalue_index(:,2))),1);
        action_and_qvalue_indices = [chosen_action_index , action_qvalue_index(chosen_action_index,1)];
    else 
        action_and_qvalue_indices = [randi(size(ACTIONS,1)), 0]; 
    end 

else
    
    chosen_action_index = randi(size(ACTIONS,1));
    chosen_qvalue_index = 0;
    
%    for o = 1: size(QTABLE,1)
    for o = 1: qTableSize

            if(isempty(QTABLE{o,1} ))
              break;
            end

            if (isequal(QTABLE{o,1},G)  & isequal(QTABLE{o,2},[ACTIONS{chosen_action_index},ACTIONS{chosen_action_index,2}]) & QTABLE{o,3}  == player)
               chosen_qvalue_index = o;
               break;
            end

    end
        
    action_and_qvalue_indices = [chosen_action_index, chosen_qvalue_index]; 
end



 
end

