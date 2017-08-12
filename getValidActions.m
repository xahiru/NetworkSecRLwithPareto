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
    
    ACTIONS = cell(length(find(G.Nodes.Infected & G.Nodes.DataCompromised))+ length(find(G.Nodes.Infected))+length(find(~G.Nodes.Services))+1,2);
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
     
%            if (points >= service_cost(s_actionIndex(p)))
             if (points >= service_cost)
               
                G_Copy.Nodes.Services(n,s_actionIndex(p)) = 0;
                
                 reward = rewardFunc(G,G_Copy,player);
                 reward(3) = reward(3) -service_cost;
                
%                  rewCost = (reward(3)*-1)
                 
                 if (points >= (reward(3)*-1))
                    ACTIONS{actionsIndex,1} = G_Copy;
                    reward(3) = reward(3) + points;
                    ACTIONS{actionsIndex,2} = reward;
                 end
             end

           actionsIndex = actionsIndex + 1;
           
            G_Copy = G;
        
         end
    
    end
    
    
    G_Copy = G;
    %get indices non infected nodes
%     rows = G.Nodes.Infected == 0;
   rows = find(~G.Nodes.Infected)
    
    %for each search services get the reward
     for n = 1:(length(rows(:,1)))
     
          if (points >= virus_install_cost)
           
              G_Copy.Nodes.Infected(rows(n)) = 1;
              
           reward = rewardFunc(G,G_Copy,player);
           
           reward(3) = reward(3) -virus_install_cost;
%            rewCost = (reward(3)*-1)
           
            if (points >= (reward(3)*-1))
                    ACTIONS{actionsIndex,1} = G_Copy;
                    reward(3) = reward(3) + points;
                    ACTIONS{actionsIndex,2} = reward;
             end
           
          
          end
          
           actionsIndex = actionsIndex + 1;
           
           G_Copy = G;
      
     end
    
    
      G_Copy = G;
    %get indices non infected nodes
    rows =  find(G.Nodes.Infected & G.Nodes.DataCompromised);
    %for each search services get the reward
     for n = 1:(length(rows(:,1)))
     
          if (points >= steal_data_cost)
              
           G_Copy.Nodes.DataCompromised(rows(n)) = 0;
           
           reward = rewardFunc(G,G_Copy,player);
           reward(3) = reward(3) -steal_data_cost;
           
%            rewCost = (reward(3)*-1)
           
            if (points >= (reward(3)*-1))
                    ACTIONS{actionsIndex,1} = G_Copy;
                    reward(3) = reward(3) + points;
                    ACTIONS{actionsIndex,2} = reward;
             end
           
          end
           actionsIndex = actionsIndex + 1;
           
            G_Copy = G;
      
    end
    
    
   
end


if player == DEFENDER
    
    ACTIONS = cell(length(find(~G.Nodes.Infected))+length(find(~G.Nodes.Services))+1,2);
    actionsIndex = 1;
    
    
    
     G_Copy = G;
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
               
                G_Copy.Nodes.Services(n,s_actionIndex(p)) = 1;
                ACTIONS{actionsIndex,1} = G_Copy;
                 reward = rewardFunc(G,G_Copy,player);
                 reward(3) = -service_cost;
                 reward(3) = reward(3) + points;
                 ACTIONS{actionsIndex,2} = reward;
             end

           actionsIndex = actionsIndex + 1;
           
            G_Copy = G;
        
         end
    
    end
    
    
    G_Copy = G;
    %get indices non infected nodes
%     rows = G.Nodes.Infected == 0;
   rows = find(G.Nodes.Infected)
    
    %for each search services get the reward
     for n = 1:(length(rows(:,1)))
     
          if (points >= virus_removal_cost)
           
              G_Copy.Nodes.Infected(rows(n)) = 0;
              
           
           ACTIONS{actionsIndex,1} = G_Copy;
           
          reward = rewardFunc(G,G_Copy,player);
           reward(3) = -virus_removal_cost;
           reward(3) = reward(3) + points;
           ACTIONS{actionsIndex,2} = reward;
          end
          
           actionsIndex = actionsIndex + 1;
           
           G_Copy = G;
      
     end
    
 %Do nothing
 
 
    
end



end

