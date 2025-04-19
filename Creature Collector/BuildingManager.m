classdef BuildingManager < handle
    %BUILDINGMANAGER Summary of this class goes here
    %   Detailed explanation goes here

    properties
        buildings = Building.empty;
    end

    methods
        function obj = BuildingManager()
            %BUILDINGMANAGER Construct an instance of this class
            %   Detailed explanation goes here
            
            obj.buildings = Building.empty;
        end

        function make_building(obj, sprite, set, x, y)
            newBuilding = Building();
            
            newBuilding.setBuildingCoordinates(x, y);
            newBuilding.setBuildingTexture(sprite);
            newBuilding.setBuildingSet(set);
        
            obj.buildings(end+1) = newBuilding;
        end

        function add_building(obj, building)
            obj.buildings(end+1) = building;
        end
    end
end