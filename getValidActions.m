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

ACTIONS = cell(length(find(~G.Nodes.DataCompromised & G.Nodes.Infected))+ length(find(~G.Nodes.Infected))+length(find(~G.Nodes.Services)),2);
actionsIndex = 1;

if player == ATTACKER
    
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
                 reward = rewardFunc(G,G_Copy);
                 reward(3) = -service_cost;
                 ACTIONS{actionsIndex,2} = reward;
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
              
           
           ACTIONS{actionsIndex,1} = G_Copy;
           
           reward = rewardFunc(G,G_Copy);
           reward(3) = -virus_install_cost;
           ACTIONS{actionsIndex,2} = reward;
          end
          
           actionsIndex = actionsIndex + 1;
           
           G_Copy = G;
      
     end
    
    
      G_Copy = G;
    %get indices non infected nodes
    rows =  find(G.Nodes.Infected & ~G.Nodes.DataCompromised);
    %for each search services get the reward
     for n = 1:(length(rows(:,1)))
     
          if (points >= steal_data_cost)
              
           G_Copy.Nodes.DataCompromised(rows(n)) = 1;
           
           ACTIONS{actionsIndex,1} = G_Copy;
           
           reward = rewardFunc(G,G_Copy);
           reward(3) = -steal_data_cost;
           ACTIONS{actionsIndex,2} = reward;
           
          end
           actionsIndex = actionsIndex + 1;
           
            G_Copy = G;
      
    end
    
    
   
end





end

