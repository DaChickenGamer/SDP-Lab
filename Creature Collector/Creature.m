classdef Creature
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       name;
       rarity;
       set;
       creature_texture;
    end
    
    methods
        function obj = Creature(name, rarity, set, creature_texture)
            obj.name = name;
            obj.rarity = rarity;
            obj.set = set;
            obj.creature_texture = creature_texture;
        end
    end
end

