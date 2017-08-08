function [ ACTIONS ] = getValidActions( G, player )
%For a given Graph state valid action and rewards pairs are returned
%   Detailed explanation goes here

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
        
        s_actionIndex = find(rows(n,:))
        
        %for each search services get the reward
         for p = 1:(length(s_actionIndex))
     
       
           G_Copy.Nodes.Services(n,s_actionIndex(p)) = 1;
           ACTIONS{actionsIndex,1} = G_Copy;
           actionsIndex = actionsIndex + 1;
           
          %  G_Copy = G;
        
         end
    
    end
    
    
    G_Copy = G;
    %get indices non infected nodes
    rows = G.Nodes.Infected == 0;
    
    %for each search services get the reward
     for n = 1:(length(rows(:,1)))
     
           G_Copy.Nodes.Infected(n) = 1;
           
           ACTIONS{actionsIndex,1} = G_Copy;
           actionsIndex = actionsIndex + 1;
           
          %  G_Copy = G;
      
     end
    
    
      G_Copy = G;
    %get indices non infected nodes
    rows = G.Nodes.Infected  & G.Nodes.DataCompromised  == 0;
    
    %for each search services get the reward
     for n = 1:(length(rows(:,1)))
     
           G_Copy.Nodes.DataCompromised(n) = 1;
           
           ACTIONS{actionsIndex,1} = G_Copy;
           actionsIndex = actionsIndex + 1;
           
          %  G_Copy = G;
      
    end
    
    
   
end





end

