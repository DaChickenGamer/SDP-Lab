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
player_sprite = 27;
empty_room_sprite = 17;
grass_sprite = 65;

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

%% Update Loop

while gameRunning
    player.move();
end

