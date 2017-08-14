function [ action_and_qvalue_indices ] = getQTableAction(G, ACTIONS, player, QTABLE )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


 X_RAND = rand();
 epsilon = 0.3;



% QValVactor = zeros(40,1);

% State = table2array(G.Nodes);
% State_size = size(State);
% State = reshape(State,[State_size(1)*State_size(2),1]);



random_qvalue_reward_index = randi([1 3],1);
action_qvalue_index = nan(length(ACTIONS),2);

action_and_qvalue_indices = [0,0];

if (X_RAND > epsilon)

    for n = 1 : length(ACTIONS)

        for m = 1: length(QTABLE)

            if(isempty(QTABLE{m,1} ))
              break;
            end

            if (isequal(QTABLE{m,1},G)  & isequal(QTABLE{m,2},[ACTIONS{n},ACTIONS{n,2}]) & QTABLE{m,3}  == player)
               action_qvalue_index(n,1) = m;
               %random va
               action_qvalue_index(n,2) = QTABLE{m,4}(random_qvalue_reward_index);

               break;
            end

        end

    end

    if(~isempty(find(~isnan(action_qvalue_index(:,1))))) 
        chosen_action_index = datasample(find(action_qvalue_index(:,2) == max(action_qvalue_index(:,2))),1)
        action_and_qvalue_indices = [chosen_action_index , action_qvalue_index(chosen_action_index,1)];
    else 
        action_and_qvalue_indices = [randi(length(ACTIONS)), 0]; 
    end 

else
    chosen_action_index = randi(length(ACTIONS));
    chosen_qvalue_index = 0;
    
    for o = 1: length(QTABLE)

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
%  action_and_qvalue_indices = [find(action_qvalue_index(randi(length(find(action_qvalue_index(:,2) == max(action_qvalue_index(:,2))))))) , action_qvalue_index(randi(length(find(action_qvalue_index(:,2) == max(action_qvalue_index(:,2))))))];


% maxqval = datasample(find(CCC2(:,2) == max(CCC2(:,2))),1)

% QTABLE{index, 6}

% QTABLE{find(isequal(QTABLE{1,1,1,1,1,1,1},G)),:,1,1,1,1,1}


%    ABC(find(ABC(:, 1) == 1 & ABC(:, 2) ==1),:,:)
    
   





%     if X_RAND > epsilon
%         
%         temp_reward = zeros(length(ACTIONS),2);
% 
%         for n =1 :length(ACTIONS)
% 
%            temp_reward(n,:) = ACTIONS{n,3};
% 
%         end
% 
%         random_reward_coloumn = randi([1 3],1);
% 
%         temp_reward (find(temp_reward(:,random_reward_coloumn) < max(temp_reward(:,random_reward_coloumn))), :, :) = [];
% 
%         random_reward = randi([1 3],1);
% 
%         temp_reward(random_reward,:)
% 
%     
%         
%     end
 
end

