classdef CreatureManager < handle
    %CREATUREMANAGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        creature_list = Creature.empty;
    end
    
    methods
        function obj = CreatureManager()

        end

        function random_creature = roll_creature(obj, creatures)
            weights = zeros(1, length(creatures));
        
            % Assign weights based on rarity
            for i = 1:length(creatures)
                switch creatures(i).rarity
                    case Rarities.Common
                        weights(i) = 500;
                    case Rarities.Uncommon
                        weights(i) = 250;
                    case Rarities.Rare
                        weights(i) = 100;
                    case Rarities.Epic
                        weights(i) = 20;
                    case Rarities.Legendary
                        weights(i) = 1;
                    otherwise
                        warning("Invalid rarity for creature: %s", creatures(i).name);
                        weights(i) = 0;
                end
            end
        
            % Compute cumulative sum and draw random index
            totalWeight = sum(weights);
            if totalWeight == 0
                error("No valid creatures to choose from.");
            end
        
            r = rand() * totalWeight;
            cumulativeWeight = 0;
            for i = 1:length(creatures)
                cumulativeWeight = cumulativeWeight + weights(i);
                if r <= cumulativeWeight
                    random_creature = creatures(i);
                    return;
                end
            end
        end

        function make_creature(obj, name, rarity, set, texture)
            new_creature = Creature(name, rarity, set, texture);
            obj.creature_list(end + 1) = new_creature;
        end

        function sortedCreatures = getCreaturesSortedByRarity(creatureList)

        end

        function sortedCreatures = getCreaturesOfSet(obj, set)
            
        end
    end
end

