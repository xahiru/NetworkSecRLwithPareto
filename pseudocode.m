% 
% // Suggestion: Create a config struct to hold all the game variables 
% 
% ----------------------------------
% Game()
% ----------------------------------
% loadConfig();
% loadQValues();
% 
% ----------------------------------
% Game.playGame()
% ----------------------------------
% 
% // Graph
% graph = new Graph(config);
% 
% // Object to keep track of points
% points = new Points(config);
% 
% // Players
% attacker = new Attacker(config);
% defender = new Defender(config);
% 
% 
% while ( !gameOver ) {
%     
%     points.startNewRound(graph);
% 
%     while ( !roundOver && !gameOver) {
% 	    
% 		// Shift to a new state (note that the state is just the graph and the points)
% 		state = new State(graph, points);
% 		
% 		// Get a map of valid actions for the given state
% 		// The key is the action, the value is the reward vector
% 		ATTactionsMap <Action, reward> = attacker.getActions(state);
% 		DEFactionsMap <Action, reward> = defender.getActions(state);
% 		
% 		// Get the Non-Dominated Pareto Fronts
% 		ATTactionsMap <Action, reward> = paretoFrontsForAttacker(ATTactionsMap, DEFactionsMap, state);
% 		DEFactionsMap <Action, reward> = paretoFrontsForDefender(ATTactionsMap, DEFactionsMap, state);
% 		
% 		// Perform the Q-learning using the Non-Dominated Pareto Fronts
% 		// Q-values are saved with a "state-action pair" as key.
% 		if(rand() > epsilon){
% 		    // Exploit the Q value for Attacker (use softmax)
% 		    ATTaction = pickLearnedAction(state, ATTactionsMap);
% 		} else {
% 		    // Explore the available actions for Attacker
% 			ATTaction = pickRandomAction(state, ATTactionsMap);
% 		}
% 		if(rand() > epsilon){
% 		    // Exploit the Q value for Defender (use softmax)
% 		    DEFaction = pickLearnedAction(state, DEFactionsMap);
% 		} else {
% 		    // Explore the available actions for Attacker
% 			DEFaction = pickRandomAction(state, DEFactionsMap);
% 		}
% 		
% 		// Update the Q-values
% 		updateQvalues(state, ATTaction, DEFaction);
% 		
% 		// Update the graph and points objects
% 		// Note that a player can perform a Game ending action
% 		gameOver = attacker.performAction(ATTaction, graph, points);
% 		gameOver = defender.performAction(DEFaction, graph, points) || gameOver;
% 
% 		// The round ends if neither the attacker nor the defender can make any more moves this round
% 		roundOver = points.isRoundOver(attacker, defender);
%     }
% 	
% 	// The game ends if neither the attacker nor the defender can make any more moves this game
%     roundOver = points.isGameOver(attacker, defender);
% 
% }
% 
% ----------------------------------
% Game.paretoFrontForDefender(ATTactionsMap, DEFactionsMap, state) 
% ----------------------------------
% 
% // For Defender, we will assume minimization. For Attackers, you can use the same logic, except in that case we will need to maximize
% 
% paretoDEFfrontMap <Action, Hashtable> = new HashTable();
% 
% // Group the actions by defence
% foreach (defenseAction in DEFactionsMap){
%     
% 	// Create an empty front
% 	paretoDEFfrontMap.add(defenseAction, new HashTable());
% 	
% 	// Loop through the attacks and find the best attacks
% 	foreach (currentAttack in ATTactionsMap) {
% 	    
% 		// Assume that the current attack is NOT dominated (i.e. should be added to the Pareto front)
% 		bool addToFront = true;
% 		
% 		// Check if the current attack is dominated by an alternative Attack
% 		foreach (altAttack in ATTactionMap){
% 			// Note that this is a vector comparison. the method graph.calculateReward() will return Reward objects (i.e. vectors)
% 			// For vector_a <= vector_b, all the elements of vector_a should be less than or equal to the corresponding element of vector_b AND at least one element should be less than.
% 		    if(currentAttack != altAttack && graph.calculateReward(currentAttack, defenseAction) <= graph.calculateReward(altAttack,defenseAction)){
% 			    // The current Attack is dominated, thus we should NOT add it to the front.
% 				addToFront = false;
% 			}			 
% 		}
% 		
% 		// If the current attack is not dominated, it is part of the attacker's Pareto front for this defence
% 		if(addToFront){
% 			paretoDEFfrontMap[defenseAction].add(currentAction, graph.calculateReward(currentAttack, defenseAction));
% 		}
% 
% 	}
% }
% 
% // Remove the defence actions with dominated Pareto fronts
% foreach (currentDefense in paretoDEFfrontMap) {
% 	
% 	// Compare the current defence to the alternative defences
% 	foreach(altDefense in paretoDEFfrontMap){
% 		
% 		// Look at all the attacks made on the alternative defence
% 		foreach(altAttack in paretoDEFfrontMap[altDefense]){
% 			
% 			// Assume that the results of this Attack made on your altDefense is preferable to any attack made on your currentDefense
% 			// i.e. Assume that (altAttack, altDefense) dominates (anyAttack, currentDefense)
% 			bool dominant = true;
% 			
% 			// Check to see if the above is true
% 			foreach(anyAttack in paretoDEFfrontMap[currentDefense]){
% 				if(!(paretoDEFfrontMap[altDefense][altAttack] <= paretoDEFfrontMap[currentDefense][anyAttack]){
% 					dominant = false;
% 				}
% 			}
% 			
% 			// If the altAttack,altDefense actually dominates (anyAttack, currentDefense), remove it from the list of viable defence actions 
% 			if(dominant){
% 				DEFactionsMap.remove(currentDefense);
% 			}
% 		} 
% 	}
% }
% 
% return DEFactionsMap;
% 
% -----------------------------
% Attacker.performAction(action, graph, points)
% -----------------------------
% 
% // Update the graph
% switch(action.type){
%     case "compromiseService":
% 	    graph.updateServices(action.nodeID, action.serviceID, false);
% 		break;
% 	case "installVirus":
% 	    graph.updateVirus(action.nodeID, true);
% 		break;
% 	case "stealData":
% 		graph.updateData(action.nodeID, true);
% 		break;
% }
% 
% // Update the points
% points.updateRoundPoints(action);
% 
% return graph.isGameOver();
% 
% -----------------------------
% Attacker.getActions(state)
% -----------------------------
%     // Create an empty hash map
%     actionsMap <Action, Reward> = new HashTable();
% 	
% 	// Get the available points
% 	availablePoints = state.points.getAvailableRoundPointsForAttacker();
% 	
% 	foreach (node in state.graph.nodes) {
% 	    
% 		// Possible Action 1: Compromise a service (May need to split it if you want different services to have different costs)
% 	    if(availablePoints => costOfCompromisingAService) {
% 		    foreach(service in node) {
% 			    if(!service.isCompromised){
% 				    rewardForServices = graph.calculateRewardForCompromisingAService(node, service);
% 				    rewardForCost = 0 - costOfCompromisingAService;
%      			    actionsMap.add(new Action ("compromiseService", node.ID, service.ID, costOfCompromisingAService), new Reward(rewardForServices, rewardForCost, 0));
% 				}
% 			}
% 		}
% 		
% 		// Possible Action 2: Install a virus
% 	    if(availablePoints => costOfInstallingAVirus) {
% 			if(!node.hasVirus){
% 				rewardForServices = graph.calculateRewardForInstallingVirus(node);
% 				rewardForCost = 0 - costOfInstallingAVirus;			
% 				actionsMap.add(new Action ("installVirus", node.ID, costOfInstallingAVirus), new Reward(rewardForServices, rewardForCost, 0));
% 			}
% 		}
% 		
% 		// Possible Action 3: Steal data
% 	    if(availablePoints => costOfstealingData) {
% 			if(!node.hasVirus && !node.dataStolen){
% 				rewardForData = graph.calculateRewardForStealingData(node);
% 				rewardForCost = 0 - costOfInstallingAVirus;			
% 				actionsMap.add(new Action ("stealData", node.ID, costOfStealingData), new Reward(0, rewardForCost, rewardForData));
% 			}
% 		}
% 	}
% 	
% 	// Possible Action 4: Do Nothing
% 	actionsMap.add(new Action ("donothing"), new Reward(0, 0, 0));
% 	
% 
% 	
% 	return actionsMap;
% 	
% 
% -----------------------------
% Defender.getActions(state)
% -----------------------------
%     // Create an empty hash map
%     actionsMap <Action, Reward> = new HashTable();
% 	
% 	// Get the available points
% 	availablePoints = state.points.getAvailableRoundPointsforDefender();
% 	
% 	foreach (node in state.graph.nodes) {
% 	    
% 		// Possible Action 1: Restore a service (May need to split it if you want different services to have different costs)
% 	    if(availablePoints => costOfRestoringAService) {
% 		    foreach(service in node) {
% 			    if(service.isCompromised){
% 				    rewardForServices = graph.calculateRewardForRestoringService(node, service);
% 				    rewardForCost = 0 - costOfRestoringAService;
%      			    actionsMap.add(new Action ("restoreService", node.ID, service.ID, costOfRestoringAService), new Reward(rewardForServices, rewardForCost, 0));
% 				}
% 			}
% 		}
% 		
% 		// Possible Action 2: Uninstall a virus
% 	    if(availablePoints => costOfUnInstallingAVirus) {
% 			if(!node.hasVirus){
% 				rewardForServices = graph.calculateRewardForUninstallingVirus(node);
% 				rewardForCost = 0 - costOfUninstallingAVirus;			
% 				actionsMap.add(new Action ("uninstallVirus", node.ID, costOfInstallingAVirus), new Reward(rewardForServices, rewardForCost, 0));
% 			}
% 		}
% 	}
% 	
% 	// Possible Action 3: Do Nothing
% 	actionsMap.add(new Action ("donothing"), new Reward(0, 0, 0));
% 	
% 	return actionsMap;
% 	
% -----------------------------
% Defender.performAction(action, graph, points)
% -----------------------------
% 
% // Update the graph
% switch(action.type){
%     case "restoreService":
% 	    graph.updateServices(action.nodeID, action.serviceID, true);
% 		break;
% 	case "uninstallVirus":
% 	    graph.updateVirus(action.nodeID, false);
% 		break;
% }
% 
% // Update the points
% points.updateRoundPoints(action);
% 
% return graph.isGameOver();
% 
% 
% -----------------------------
% points
% -----------------------------
% 
% // Points an object that keeps track of the points.
% totalATTpointsRemaining;
% totalDEFpointsRemaining;
% roundATTpointsRemaining;
% roundDEFpointsRemaining;
% 
% -----------------------------
% points.isRoundOver()
% -----------------------------
% 
% // The round is over if both players can no longer perform any moves in this round.
% return (attacker.getLowestCostAction > roundATTpointsRemaining && defender.getLowestCostAction > roundDEFpointsRemaining)
% 
% 
% -----------------------------
% points.isRoundOver()
% -----------------------------
% 
% // The game is over if both players can no longer perform any moves in this game.
% return (attacker.getLowestCostAction > totalATTpointsRemaining && defender.getLowestCostAction > totalDEFpointsRemaining)
% 
% -----------------------------
% points.updateRoundPoints(action)
% -----------------------------
% 
% // Update the round points
% switch(action.type){
%     case "compromiseService":
% 	case "installVirus":
% 	case "stealData":
% 	    roundATTpointsRemaining -= action.cost;
% 		break;
%     case "restoreService":
% 	case "uninstallVirus":
% 	    roundDEFpointsRemaining -= action.cost;
% 		break;
% }
% 
% 
% -----------------------------
% points.startNewRound()
% -----------------------------
% 
% // Add the left over round points back 
% totalATTpointsRemaining += roundATTpointsRemaining;
% totalDEFpointsRemaining += roundDEFpointsRemaining;
% 
% // Allocate points to the round
% roundATTpointsRemaining = totalATTpointsRemaining > defaultRoundPoints ? defaultRoundPoints : totalATTpointsRemaining;
% roundDEFpointsRemaining = totalDEFpointsRemaining > defaultRoundPoints ? defaultRoundPoints : totalDEFpointsRemaining;
% 
% // Subtract the allocated points from the total.
% totalATTpointsRemaining -= roundATTpointsRemaining;
% totalDEFpointsRemaining -= roundDEFpointsRemaining;
%  
% pseudocode.txt
% Displaying game1.jpg.