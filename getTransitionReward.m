function [ state2Score ] = getTransitionReward(G2,ATTACK_ACTION, DEFENCE_ACTION, cost_vector )

%         state1Score = getStateScore(G1);
        state2Score = getStateScore(G2);
        state2Score(3) = state2Score(3) + getActionCost(ATTACK_ACTION, 1, cost_vector) - getActionCost(DEFENCE_ACTION, 2, cost_vector);
        
      
end

