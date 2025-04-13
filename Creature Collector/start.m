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

%% Initalize Board
% Display empty board   
rooms_display = blank_sprite * ones(20,20);
drawScene(my_scene,rooms_display)

% Now set up A second layer with the game pieces
gameboard_display = ones(20, 20);

%% Initalize Buildings

% Define buildings
castle = Building();
grave = Building();
boat = Building();
shrine = Building();
candle = Building();
house = Building();
fence = Building();

% Set Sprites
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
rooms_display(castle.y, castle.x) = castle.sprite;
rooms_display(grave.y, grave.x) = grave.sprite;
rooms_display(boat.y, boat.x) = boat.sprite;
rooms_display(shrine.y, shrine.x) = shrine.sprite;
rooms_display(candle.y, candle.x) = candle.sprite;
rooms_display(house.y, house.x) = house.sprite;
rooms_display(fence.y, fence.x) = fence.sprite;

for x = 1:20
    for y = 1:20
        randomNum = randi(2);
        if (randomNum == 1 && rooms_display(y, x) == 1)
            gameboard_display(y, x) = grass_sprite;
        else
            gameboard_display(y, x) = blank_sprite;
        end
    end
end

drawScene(my_scene,rooms_display,gameboard_display)



%% Initalize Player
player = player(player_sprite, 2, 2, my_scene, rooms_display, gameboard_display);
player.initalize_character()

%my_scene.showCreaturePopup(randTest.name, randTest.creature_texture);
%% Update Loop

while gameRunning
    player.move();
end

