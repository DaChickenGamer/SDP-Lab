classdef Building < handle
    %BUILDING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x = 0;
        y = 0;
        set = Set.None;
        sprite = 0;
    end
    
    methods
        function obj = Building()
            %BUILDING Construct an instance of this class
            %   Detailed explanation goes here
            obj.x = 0;
            obj.y = 0;
            obj.sprite = 0;
            obj.set = Set.None;
        end

        function setBuildingSet(obj, set)
            obj.set = set;
            obj.sprite = obj.setBuildingTexture(set);
        end

        function setBuildingCoordinates(obj, x, y)
            obj.x = x;
            obj.y = y;
        end

        function showUI(obj, creature_list)
            
        end

        % Not the best way to do it but works for now
        function buildingTexture = setBuildingTexture(obj, buildingSet)
            textures = dictionary( ...
                Set.Medieval , 19 * 32 + 6 , ...
                Set.Dead     , 12 * 32 + 5 , ...
                Set.Water    , 19 * 32 + 12, ...
                Set.Evil     , 11 * 32 + 22, ...
                Set.Funny    , 15 * 32 + 6, ...
                Set.Citizen  , 19 * 32 + 2, ...
                Set.Animal   , 3 * 32 + 4 ...
            );

           if isKey(textures, buildingSet)
                buildingTexture = textures(buildingSet);
            else
                warning('Unknown building set');
                buildingTexture = -1; % Or some default
            end
        end
    end
end