function [ COMBINED_REWARD ] = getCombinedRewards(  ATTACK_ACTIONS,DEFENCE_ACTIONS, G  )
%GETCOMBINEDREWARDS Summary of this function goes here
%   Detailed explanation goes here

COMBINED_REWARD = cell(length(DEFENCE_ACTIONS),length(ATTACK_ACTIONS));
state_reward = getStateScore(G)
state_reward(3) = 0;

for n = 1: length(DEFENCE_ACTIONS)
    
    for m = 1: length(ATTACK_ACTIONS)
        
         temp_attack = ATTACK_ACTIONS{m,3};
         temp_def = DEFENCE_ACTIONS{n,3};
         if (~isempty(temp_attack) && ~isempty(temp_def));
         temp_reward = state_reward + temp_def + temp_attack;
         temp_reward(3) = temp_attack(3) - temp_def(3);
             
         COMBINED_REWARD{n,m} = temp_reward;
      
         
         end
        

    end
end

end

