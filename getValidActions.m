function [ ACTIONS ] = getValidActions( G, player, points )
%For a given Graph state valid action and rewards pairs are returned
%   Detailed explanation goes here


% service_cost = [15,10,5,5,15];
service_cost = 2;
virus_install_cost = 4;
virus_removal_cost = 11; %cost of removal should be the opposite of stealing data + installing virus
steal_data_cost = 7;


%store node sevice index
ATTACKER = 1;
DEFENDER = 2;

if player == ATTACKER
    
    ACTIONS = cell(length(find(G.Nodes.Infected & G.Nodes.DataCompromised))+ length(find(G.Nodes.Infected))+length(find(~G.Nodes.Services)),3);
    actionsIndex = 1;

    
    G_Copy = G;
    %get indices of available services for all the nodes
    rows = G.Nodes.Services == 1;
    
%   x =  find(~G.Nodes.Services)
    
    %get node specfic available services
    for n = 1:(length(rows(:,1)))
        
        s_actionIndex = find(rows(n,:));
        
        %for each search services get the reward
         for p = 1:(length(s_actionIndex))
     
             if (points >= service_cost)
               
                 reward = rewardFunc(G,n,[1,s_actionIndex(p)], service_cost,player);
                
                 if (points >= reward(3))
                    
                    % new matrix
                    ACTIONS{actionsIndex,1} = n;
                    ACTIONS{actionsIndex,2} = [1,s_actionIndex(p)];
                    ACTIONS{actionsIndex,3} = reward;
                 end
             end

           actionsIndex = actionsIndex + 1;
        
         end
    
    end
    
   
    %get indices non infected nodes
%     rows = G.Nodes.Infected == 0;
   rows = find(~G.Nodes.Infected)
    
    %for each search services get the reward
     for n = 1:(length(rows(:,1)))
     
          if (points >= virus_install_cost)
           
            reward = rewardFunc(G,rows(n),[2,1], virus_install_cost,player);
            
               if (points >= reward(3))

                        % new matrix
                        ACTIONS{actionsIndex,1} = rows(n);
                        ACTIONS{actionsIndex,2} = [2,1];
                        ACTIONS{actionsIndex,3} = reward;
               end
          
          end
          
           actionsIndex = actionsIndex + 1;
           
       
      
     end
     
     %get indices non infected nodes
    rows =  find(G.Nodes.Infected & G.Nodes.DataCompromised);
    %for each search services get the reward
     for n = 1:(length(rows(:,1)))
     
          if (points >= steal_data_cost)
              
          
            reward = rewardFunc(G,rows(n),[3,1], steal_data_cost,player);
           
            if (points >= reward(3))

                        % new matrix
                        ACTIONS{actionsIndex,1} = rows(n);
                        ACTIONS{actionsIndex,2} = [3,1];
                        ACTIONS{actionsIndex,3} = reward;
               end
           
          end
           actionsIndex = actionsIndex + 1;
           
          
     end
    
   
    ToRemove = find(cellfun(@isempty,ACTIONS));
    ACTIONS(ToRemove) = [];
    sizeI = size(ACTIONS);
    ACTIONS = reshape(ACTIONS, [sizeI(2) / 3, 3]);
   
end


if player == DEFENDER
    
    ACTIONS = cell(length(find(~G.Nodes.Infected))+length(find(~G.Nodes.Services))+1,2);
    actionsIndex = 1;
    
    
    %get indices of available services for all the nodes
    rows = G.Nodes.Services == 0;
    
%   x =  find(~G.Nodes.Services)
    
    %get node specfic available services
    for n = 1:(length(rows(:,1)))
        
        s_actionIndex = find(rows(n,:));
        
        %for each search services get the reward
         for p = 1:(length(s_actionIndex))
     
%            if (points >= service_cost(s_actionIndex(p)))
             if (points >= service_cost)
               
                 reward = rewardFunc(G,n,[1,s_actionIndex(p)], service_cost,player);
                
                 if (points >= reward(3))
                     % new matrix
                    ACTIONS{actionsIndex,1} = n;
                    ACTIONS{actionsIndex,2} = [1,s_actionIndex(p)];
                    ACTIONS{actionsIndex,3} = reward;
                 end
                 
             end

           actionsIndex = actionsIndex + 1;
           
           
        
         end
    
    end
    
  
    %get indices non infected nodes
%     rows = G.Nodes.Infected == 0;
   rows = find(G.Nodes.Infected)
    
    %for each search services get the reward
     for n = 1:(length(rows(:,1)))
     
          if (points >= virus_removal_cost)
           
              reward = rewardFunc(G,rows(n),[2,1], virus_removal_cost,player);
           
             if (points >= reward(3))
                     % new matrix
                    ACTIONS{actionsIndex,1} = rows(n);
                    ACTIONS{actionsIndex,2} = [2,1];
                    ACTIONS{actionsIndex,3} = reward;
             end
                 
          end
          
           actionsIndex = actionsIndex + 1;
      
     end
  
    ToRemove = find(cellfun(@isempty,ACTIONS));
    ACTIONS(ToRemove) = [];
    sizeI = size(ACTIONS);
    ACTIONS = reshape(ACTIONS, [sizeI(2) / 3, 3]);
    
    
end

 

end

