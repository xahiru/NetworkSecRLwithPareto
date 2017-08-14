function [ actionCost ] = getActionCost( ACTION, PlayerTYPE,cost_vector)
  
    ActionType = ACTION{2}(1);
        
      actionCost = 0;
   if(PlayerTYPE == 2)
       switch ActionType
        case 1
            % service up 
            actionCost =  cost_vector(1);
        case 3
            % disinfected 
             actionCost = cost_vector(3);
             
       end
   else
       
       switch ActionType
 
        case 1
            % service up 
             actionCost = cost_vector(1);
        case 2
            % infected 
             actionCost = cost_vector(2);
             
        case 4
            % steal data 
             actionCost = cost_vector(4);
    end
       
   end
        
    
        
    
        

end

