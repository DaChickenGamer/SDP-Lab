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

creature_manager.make_creature("Goblin", Rarities.Common, 20);
creature_manager.make_creature("Toilet", Rarities.Legendary, 10*32+13);
creature_manager.make_creature("Grave", Rarities.Rare, 14*32+2)
creature_manager.make_creature("Skull", Rarities.Uncommon, 15*32+2)
creature_manager.make_creature("Chicken", Rarities.Legendary, 7*32+27)
creature_manager.make_creature("Spider", Rarities.Epic, 5*32+29)
creature_manager.make_creature("King", Rarities.Legendary, 3*32+29)
creature_manager.make_creature("Sheriff", Rarities.Rare, 4*32+29)
creature_manager.make_creature("Ghost", Rarities.Rare, 6*32+28)
creature_manager.make_creature("Cow", Rarities.Common, 7*32+28)
creature_manager.make_creature("Horse", Rarities.Common, 7*32+29)
creature_manager.make_creature("Cat", Rarities.Uncommon, 7*32+31)
creature_manager.make_creature("Dog", Rarities.Rare, 7*32+32)
creature_manager.make_creature("Squid", Rarities.Rare, 8*32+26)
creature_manager.make_creature("Bat", Rarities.Epic, 8*32+27)
creature_manager.make_creature("Eel", Rarities.Rare, 8*32+29)
creature_manager.make_creature("Devil", Rarities.Epic, 2*32+28)
creature_manager.make_creature("Bandit", Rarities.Common, 2*32+29)
creature_manager.make_creature("Farmer", Rarities.Common, 2*32+32)
creature_manager.make_creature("Scorpion", Rarities.Rare, 5*32+25)
creature_manager.make_creature("Crab", Rarities.Uncommon, 5*32+26)
creature_manager.make_creature("Turtle", Rarities.Rare, 5*32+28)
creature_manager.make_creature("Gun", Rarities.Legendary, 31*32+6)
creature_manager.make_creature("Miner", Rarities.Common, 4*32+27)
creature_manager.make_creature("Queen", Rarities.Epic, 3*32+30)
creature_manager.make_creature("Happy", Rarities.Epic, 4*32+26)
creature_manager.make_creature("Bug", Rarities.Uncommon, 5*32+27)
creature_manager.make_creature("Wizard", Rarities.Rare, 1*32+25)
creature_manager.make_creature("Spearman", Rarities.Uncommon, 0*32+27)
creature_manager.make_creature("Knight", Rarities.Rare, 0*32+28)
creature_manager.make_creature("Gnome", Rarities.Legendary, 9*32+27)
creature_manager.make_creature("Mermaid", Rarities.Epic, 9*32+32)

randTest = creature_manager.roll_creature();
fprintf("Random creature name: %s", randTest.name);

%% Initalize Board
% Display empty board   
rooms_display = blank_sprite * ones(10,10);
drawScene(my_scene,rooms_display)

% Now set up A second layer with the game pieces
gameboard_display = ones(10, 10);

for x = 1:10
    for y = 1:10
        randomNum = randi(2);
        if (randomNum == 1)
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

my_scene.showCreaturePopup(randTest.name, randTest.creature_texture);
%% Update Loop

while gameRunning
    player.move();
end

