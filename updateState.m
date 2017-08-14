function [ G_COPY ] = updateState(G, ACTION, player  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

G_COPY  = G;

flipbit = 1;

ACTION{1}
X = ACTION{2}(1)

if player == 1 %ATTACKER
    flipbit = ~flipbit;
end
    switch X
        case 1
            % service up = 1
             G_COPY.Nodes.Services(ACTION{1},ACTION{2}(2)) = flipbit;
        case 2
            % disinfected = 0
             G_COPY.Nodes.Infected(ACTION{1}) = ~flipbit;
        case 3
            %this case will only be executed for attacker
            % datacompromise 
             G_COPY.Nodes.DataCompromised(ACTION{1}) = flipbit;
        otherwise

    end

end

