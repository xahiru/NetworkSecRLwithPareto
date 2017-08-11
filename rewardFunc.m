function [ rew ] = rewardFunc(G_State1, G_State2)
%Given the state returns the reward



%get all services 
    cols1 = G_State1.Nodes.Services;
    
    service_links1 = 0;
    
    for n = 1:(length(cols1(1,:)))
      
        %get the number of running services 
          ns = length(find(cols1(:,n)));
          link = (ns * (ns-1))/2 ;
          
          if(~link)
          service_links1 = service_links1 + link  ;
          end
          
          
         %if you want to add weights to links
        %get weight for n (column reflects service) from weight vector
        % service_links * weight
      
    end
    
    infected1 = length(find(G_State1.Nodes.DataCompromised));
    
    
    cols2 = G_State2.Nodes.Services;
    
    service_links2 = 0;
    
    for n = 1:(length(cols2(1,:)))
      
        %get the number of running services 
          ns = length(find(cols2(:,n)));
          
          service_links1 = service_links1 + (ns * (ns-1))/2 ;
          
         %if you want to add weights to links
        %get weight for n (column reflects service) from weight vector
        % service_links * weight
      
        
    end
    
    infected2 = length(find(G_State2.Nodes.DataCompromised));
    
    
    
    
    %point difference is the difference of points for the actions taken
    %since it is associated with the action, it can be assigned from the
    %calling action function
     pointDifferece = 0;


rew = [service_links1-service_links2,infected2 - infected1,pointDifferece];

end

