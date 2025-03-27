clc
clear
close all


% Initialize scene
my_scene = simpleGameEngine('assets/retro_pack.png',16,16,4);

%% Initialize Variables
gameRunning = true;

%% Define Sprites
% Set up variables to name the various sprites
% The formula here is: (row-1)*32 + column
%% Define Sprites
% Set up variables to name the various sprites
% The formula here is: (row-1)*32 + column
blank_sprite = 1;
sword_sprite = 28*32 + 3;
boots_sprite = 23*32 + 9;
shield_sprite = 26*32 + 9;
potion_sprite = 23*32 + 27;
monster_sprite = 9*32 + 19;
player_sprite = 27;
door_sprite = 9*32 + 11;
empty_room_sprite = 17;

%% Initalize Board
% Display empty board   
rooms_display = empty_room_sprite * ones(10,10);
drawScene(my_scene,rooms_display)

% Now set up A second layer with the game pieces
gameboard_display = blank_sprite * ones(10,10);
gameboard_display(10,10) = door_sprite;
gameboard_display(5,5) = sword_sprite;
gameboard_display(3,4) = shield_sprite;
gameboard_display(6,9) = boots_sprite;
gameboard_display(2,8) = potion_sprite;

gameboard_display(3,7) = monster_sprite;
gameboard_display(8,8) = monster_sprite;
gameboard_display(7,3) = monster_sprite;

drawScene(my_scene,rooms_display,gameboard_display)

%% Initalize Player
player = player(player_sprite, 2, 2, my_scene, rooms_display, gameboard_display);

%% Update Loop

while gameRunning
    player.move();
end

