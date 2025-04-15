clc
clear
close all


% Initialize scene
my_scene = simpleGameEngine('assets/retro_pack.png',16,16,4, [109, 76, 65]);

%% Initialize Variables
gameRunning = true;

%% Define Sprites
% Set up variables to name the various sprites
% The formula here is: (row-1)*32 + column
%% Define Sprites
% Set up variables to name the various sprites
% The formula here is: (row-1)*32 + column
blank_sprite = 1;
player_sprite = 26;
empty_room_sprite = 17;
grass_sprite = 65;

%% Creatures
creature_manager = CreatureManager();

creature_manager.make_creature("Goblin", Rarities.Common, Set.Evil, 2*32+30);
creature_manager.make_creature("Toilet", Rarities.Legendary, Set.Funny, 10*32+13);

% Will probably use grave as building so commented for now
%creature_manager.make_creature("Grave", Rarities.Rare, Set.Dead 14*32+2)

creature_manager.make_creature("Skull", Rarities.Uncommon, Set.Dead, 15*32+2)
creature_manager.make_creature("Chicken", Rarities.Legendary, Set.Animal, 7*32+27)
creature_manager.make_creature("Spider", Rarities.Epic, Set.Evil, 5*32+29)
creature_manager.make_creature("King", Rarities.Legendary, Set.Medieval, 3*32+29)
creature_manager.make_creature("Sheriff", Rarities.Rare, Set.Citizen, 4*32+29)
creature_manager.make_creature("Ghost", Rarities.Rare, Set.Dead, 6*32+28)
creature_manager.make_creature("Cow", Rarities.Common, Set.Animal, 7*32+28)
creature_manager.make_creature("Horse", Rarities.Common, Set.Animal, 7*32+29)
creature_manager.make_creature("Cat", Rarities.Uncommon, Set.Animal, 7*32+31)
creature_manager.make_creature("Dog", Rarities.Rare, Set.Animal, 7*32+32)
creature_manager.make_creature("Squid", Rarities.Rare, Set.Water, 8*32+26)
creature_manager.make_creature("Bat", Rarities.Epic, Set.Animal, 8*32+27)
creature_manager.make_creature("Eel", Rarities.Rare, Set.Water, 8*32+29)
creature_manager.make_creature("Devil", Rarities.Epic, Set.Evil, 2*32+28)
creature_manager.make_creature("Bandit", Rarities.Common, Set.Evil, 2*32+29)
creature_manager.make_creature("Farmer", Rarities.Common, Set.Citizen, 2*32+32)
creature_manager.make_creature("Scorpion", Rarities.Rare, Set.Evil, 5*32+25)
creature_manager.make_creature("Crab", Rarities.Uncommon, Set.Water, 5*32+26)
creature_manager.make_creature("Turtle", Rarities.Rare, Set.Water, 5*32+28)
creature_manager.make_creature("Gun", Rarities.Legendary, Set.Funny, 31*32+6)
creature_manager.make_creature("Miner", Rarities.Common, Set.Citizen, 4*32+27)
creature_manager.make_creature("Queen", Rarities.Epic, Set.Medieval, 3*32+30)
creature_manager.make_creature("Happy", Rarities.Epic, Set.Funny, 4*32+26)
creature_manager.make_creature("Bug", Rarities.Uncommon, Set.Animal, 5*32+27)
creature_manager.make_creature("Wizard", Rarities.Rare, Set.Medieval,1*32+25)
creature_manager.make_creature("Spearman", Rarities.Uncommon, Set.Citizen, 0*32+27)
creature_manager.make_creature("Knight", Rarities.Rare, Set.Medieval, 0*32+28)
creature_manager.make_creature("Gnome", Rarities.Legendary, Set.Funny, 9*32+27)
creature_manager.make_creature("Mermaid", Rarities.Epic, Set.Water, 9*32+32)

% Test to see if the creature roll works
%randTest = creature_manager.roll_creature(creature_manager.creature_list);
%fprintf("Random creature name: %s", randTest.name);

%% Build Board

% Define layers
terrarian_layer = blank_sprite * ones(20, 20);
building_layer = blank_sprite * ones(20,20);
object_layer = ones(20, 20);

% Now set up A second layer with the game pieces
object_layer = ones(20, 20);

% Water Region
fullWater = 5 * 32 + 9;
rightEdgeWater = 5 * 32 + 10;
upEdgeWater = 32 * 32 + 1;
cornerWater = 5 * 32 + 11;

terrarian_layer(15, 15) = fullWater;

for x = 1:6
    for y = 1:6
        currentX = x + 14;
        currentY = y + 14;

        if (currentX == 15 && currentY ~= 15)
            terrarian_layer(currentY, currentX) = rightEdgeWater;
        elseif(currentY == 15 && currentX ~= 15)
            terrarian_layer(currentY, currentX) = upEdgeWater;
        elseif(currentY == 15 && currentX == 15)
            terrarian_layer(currentY, currentX) = cornerWater;
        else
            terrarian_layer(currentY, currentX) = fullWater;
        end
    end
end

% Define buildings
castle = Building();
grave = Building();
boat = Building();
shrine = Building();
candle = Building();
house = Building();
fence = Building();

% Set Sprite Sets
castle.setBuildingSet(Set.Medieval);
grave.setBuildingSet(Set.Dead);
boat.setBuildingSet(Set.Water);
shrine.setBuildingSet(Set.Evil);
candle.setBuildingSet(Set.Funny);
house.setBuildingSet(Set.Citizen);
fence.setBuildingSet(Set.Animal)

% Set Coordinates
castle.setBuildingCoordinates(16, 2);
grave.setBuildingCoordinates(3, 7);
boat.setBuildingCoordinates(18, 18);
shrine.setBuildingCoordinates(3, 15);
candle.setBuildingCoordinates(10, 10);
house.setBuildingCoordinates(5, 12);
fence.setBuildingCoordinates(12, 5);

% Place Buildings
building_layer(castle.y, castle.x) = castle.sprite;
building_layer(grave.y, grave.x) = grave.sprite;
building_layer(boat.y, boat.x) = boat.sprite;
building_layer(shrine.y, shrine.x) = shrine.sprite;
building_layer(candle.y, candle.x) = candle.sprite;
building_layer(house.y, house.x) = house.sprite;
building_layer(fence.y, fence.x) = fence.sprite;

% Grass Generation

for x = 1:20
    for y = 1:20
        randomNum = randi(2);
        if (randomNum == 1 && building_layer(y, x) == 1 && terrarian_layer(y, x) == 1)
            object_layer(y, x) = grass_sprite;
        else
            object_layer(y, x) = blank_sprite;
        end
    end
end

% Updates the screen with the current scene
drawScene(my_scene, terrarian_layer, object_layer, building_layer);


%% Initalize Player
player = player(player_sprite, 2, 2, my_scene, {terrarian_layer, object_layer, building_layer});
player.initalize_character()

%my_scene.showCreaturePopup(randTest.name, randTest.creature_texture);
%% Update Loop

while gameRunning
    player.move();
end

