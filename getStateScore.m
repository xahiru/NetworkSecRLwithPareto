function [ score ] = getStateScore( state )
%GETSTATESCORE Summary of this function goes here
%   Detailed explanation goes here

service_weight = [15,10,5,5,15];
data_weight = [0, 0];
cols = state.Nodes.Services;
maintanance_cost =0;
service_links2 = 0;
  for n = 1:(length(cols(1,:)))
        % get the maintenance cost for services  
        maintanance_cost = maintanance_cost + length(find(~cols(:,n)));

          %get the number of running services 
          ns = length(find(cols(:,n)));
          link = (ns * (ns-1))/2 ;
          
          if(link)
%              link = link * service_weight(n);
             linkweight = link * service_weight(n);
            
%            total_service1_cost = total_service1_cost + service_cost(n)
            service_links2 = service_links2 + linkweight;
          end
  end
    
    maintanance_cost = maintanance_cost + length(find(state.Nodes.Infected));
    
    secure1 = length(find(~state.Nodes.Infected));    
    secure2 = length(find(state.Nodes.DataCompromised));
    secure = secure1 * data_weight(1) + secure2 * data_weight (2); 
    
    score = [service_links2,secure,maintanance_cost];
    

end

