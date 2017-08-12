function [ COMBINED_REWARD ] = getParetoFronts( ATTACK_ACTIONS,DEFENCE_ACTIONS, G )
%GETPARETOFRONTS Summary of this function goes here
%   Detailed explanation goes here


COMBINED_REWARD = cell(length(DEFENCE_ACTIONS),length(ATTACK_ACTIONS),1);
state_reward = getStateScore(G)
state_reward(3) = 0;

for n = 1: length(DEFENCE_ACTIONS)
    
    for m = 1: length(ATTACK_ACTIONS)
        
         temp_attack = ATTACK_ACTIONS{m,3};
         temp_def = DEFENCE_ACTIONS{n,3};
         if (~isempty(temp_attack) && ~isempty(temp_def));
         temp_reward = state_reward + temp_def + temp_attack;
         temp_reward(3) = temp_attack(3) - temp_def(3);
             
         COMBINED_REWARD{n,m, 1} = temp_reward;
         COMBINED_REWARD{n,m, 2} = 1;
         
         end
        

    end
end

for n = 1: length(DEFENCE_ACTIONS)
    
    for m = 1: length(ATTACK_ACTIONS)

        for o = 1: length(ATTACK_ACTIONS)

               current_reward = COMBINED_REWARD{n,m,1};
               alt_reward = COMBINED_REWARD{n,o,1};

               if (m ~= o && current_reward < alt_reward)
                   COMBINED_REWARD{n, m , 2} = 0;
                   break;
               end
        end
     end
 end

for d1 = 1: length(DEFENCE_ACTIONS)
    
    for d2 = 1: length(DEFENCE_ACTIONS)

        for a2 = 1: length(ATTACK_ACTIONS)
            
            if ( COMBINED_REWARD{d2, a2 , 2} == 1 )
               
                for a1 = 1: length(ATTACK_ACTIONS)
                    
                    
                end
            end
        end
     end
 end



end

