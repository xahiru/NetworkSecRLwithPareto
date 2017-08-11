function [ rew ] = rewardFunc(G_State1, G_State2)
%Given the state returns the reward


service_weight = [15,10,5,5,15];
ATTACKER = 1;
DEFENDER = 2;


%get all services 
     cols1 = G_State1.Nodes.Services;
    
%      service_links1 = 0;
    
%      total_service1_cost = 0;

    total_downlinks = 0;
    
    for n = 1:(length(cols1(1,:)))
      
        %get the number of running services 
%           ns = length(find(cols1(:,n)));
          ns = length(find(~cols1(:,n))); %downlinks
          link = (ns * (ns-1))/2 ;
          
          if(link)
%              linkweight = link * service_weight(n);
% %            total_service1_cost = total_service1_cost + service_weight(n)
%             service_links1 = service_links1 + linkweight  ;
            total_downlinks = total_downlinks + link; %total downlinks
            
          end
          
        
      
    end
    
    
       
        %to maintain a service requires [1] points
        %to calculate service attack maintanance 
        %subtract  the number of total runninglinks from
        %totallinkcombintions and multiply by [1]
        total_downlinks 
        
%     compromised1 = length(find(G_State1.Nodes.DataCompromised));
    
    virust_infected = length(find(G_State1.Nodes.Infected));
    
    maintanance_cost = total_downlinks + virust_infected; 
    
    cols2 = G_State2.Nodes.Services;
    
     service_links2 = 0;
    
    for n = 1:(length(cols2(1,:)))
         %get the number of running services 
          ns = length(find(cols2(:,n)));
          link = (ns * (ns-1))/2 ;
          
          if(link)
             link = link * service_weight(n);
             linkweight = link * service_weight(n);
%            total_service1_cost = total_service1_cost + service_cost(n)
            service_links2 = service_links2 + linkweight  ;
          end
          
          
         %if you want to add weights to links
        %get weight for n (column reflects service) from weight vector
        % service_links * weight
        
    end
    
    compromised2 = length(find(~G_State2.Nodes.DataCompromised));
    
    
    %point difference is the difference of points for the actions taken
    %since it is associated with the action, it can be assigned from the
    %calling action function
%      pointDifferece = 0;


% rew = [service_links1-service_links2,infected2 - infected1,pointDifferece];


rew = [service_links2,compromised2,-maintanance_cost];



end

