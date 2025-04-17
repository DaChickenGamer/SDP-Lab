clc
clear
close all


% Initialize scene
my_scene = simpleGameEngine('assets/retro_pack.png',16,16,4, [0,135,62]);

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

% Water generation

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
castle.setBuildingCoordinates(18, 2);
grave.setBuildingCoordinates(3, 7);
boat.setBuildingCoordinates(18, 18);
shrine.setBuildingCoordinates(3, 17);
candle.setBuildingCoordinates(10, 10);
house.setBuildingCoordinates(4, 12);
fence.setBuildingCoordinates(6, 4);

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


% Castle Generation

leftCastleWall = 14 * 32 + 17;
leftCornerCastleWall = 15 * 32 + 17;
bottomCastleWall = 15 * 32 + 18;

for x = 1:6
    for y = 1:4
        xPos = x + 14;

        if xPos == 15 && y ~= 4
            object_layer(y, xPos) = leftCastleWall;
        elseif y == 4 && xPos == 15
            object_layer(y, xPos) = leftCornerCastleWall;
        elseif y == 4 && x ~= 15
            object_layer(y, xPos) = bottomCastleWall;
        end
    end
end



% Diamond / Funny Area Generation
diamondTexture = 4 * 32 + 24;

% Fail safe if no diamonds generate
oneDiamondPlaced = false;

for x = 1:5
    for y = 1:5
        actualX = x + 7;
        actualY = y + 7;

        randomNum = randi(7);

        if randomNum == 1 && building_layer(actualY, actualX) == 1
            object_layer(actualY, actualX) = diamondTexture;
            oneDiamondPlaced = true;
        end
    end
end

% Makes a fail safe so if no diamonds get placed it puts one 
if oneDiamondPlaced == false
    randomX = randi(5) + 7;
    randomY = randi(5) + 7;
   
    % Makes sure the diamond isn't placed on the candle
    if building_layer(randomX, randomY) == 1
        object_layer(randomY, randomX) = diamondTexture;
    else
        object_layer(randomY, randomX - 1) = diamondTexture;
    end
end

% Generates village area
houseTexture = 20 * 32 + 5;

for x = 1:5
    for y = 1:5
        actualX = x + 1;
        actualY = y + 9;

        if mod(x, 2) == 0 && mod(y, 2) == 0
            object_layer(actualY, actualX) = houseTexture;
        end
    end
end

% Generate Shrine Area
fireTexture = 10 * 32 + 16;

% Fail safe if no fire generate
oneFirePlaced = false;

for x = 1:5
    for y = 1:5
        actualX = x;
        actualY = y + 14;

        randomNum = randi(5);

        if randomNum == 1 && building_layer(actualY, actualX) == 1
            object_layer(actualY, actualX) = fireTexture;
            oneFirePlaced = true;
        end
    end
end

% Makes a fail safe so if no fire get placed it puts one 
if oneFirePlaced == false
    randomX = randi(7);
    randomY = randi(7) + 14;
   
    % Makes sure the fire isn't placed on the candle
    if building_layer(randomX, randomY) == 1
        object_layer(randomY, randomX) = fireTexture;
    else
        object_layer(randomY, randomX - 1) = fireTexture;
    end
end

% Generate Grave Area
normalGrave = 14 * 32 + 1;
crossGrave = 14 * 32 + 2;
squareGrave = 14 * 32 + 3;

% Fail safe if no grave generates
oneGravePlaced = false;

% Area: 5x5 around grave building at (3, 7)
for x = 1:5
    for y = 1:5
        actualX = x + 1;  % Around column 3
        actualY = y + 5;  % Around row 7

        randomNum = randi(6); % Chance to spawn grave

        if randomNum == 1 && building_layer(actualY, actualX) == 1
            % Randomly choose one of the grave types
            graveType = randi(3);
            switch graveType
                case 1
                    object_layer(actualY, actualX) = normalGrave;
                case 2
                    object_layer(actualY, actualX) = crossGrave;
                case 3
                    object_layer(actualY, actualX) = squareGrave;
            end
            oneGravePlaced = true;
        end
    end
end

% Fail-safe grave if none placed
if ~oneGravePlaced
    fallbackX = randi(5) + 1;
    fallbackY = randi(5) + 5;

    if building_layer(fallbackY, fallbackX) == 1
        object_layer(fallbackY, fallbackX) = crossGrave;
    else
        object_layer(fallbackY, max(1, fallbackX - 1)) = crossGrave;
    end
end

% Generate Animal Area
fenceTexture = 3 * 32 + 3; 

for x = 1:9
    actualX = x + 1;
    actualY = 4;

    if building_layer(actualY, actualX) == 1
        object_layer(actualY, actualX) = fenceTexture;
    end
end


% Updates the screen with the current scene
drawScene(my_scene, terrarian_layer, object_layer, building_layer);

%% Initalize Player
player = player(8 * 32 + 19, 2, 2, my_scene, {terrarian_layer, object_layer, building_layer});
player.initalize_character()

% Instructions
% UI System isn't the best but it's all I got to work with

my_scene.uiPopup("Controls: Use WASD to move, E to search for creatures.", "Begin");

my_scene.uiPopup("Tip: Track progress at unique buildings.", "Next");

my_scene.uiPopup("4. Escape as quickly as possible once your rocket is ready!", "Next");

my_scene.uiPopup("3. Finish building your village to unlock the rocket ship.", "Next");

my_scene.uiPopup("2. Discover all unique creatures to complete special buildings.", "Next");

my_scene.uiPopup("1. Search for creatures hidden in random blocks around the map.", "Next");

my_scene.uiPopup("TamerVille", "Start");

%% Helper Function to get Textures
function textures = getTextures()
    textures.leftCastleWall = 14 * 32 + 17;
    textures.leftCornerCastleWall = 15 * 32 + 17;
    textures.bottomCastleWall = 15 * 32 + 18;
    textures.diamond = 4 * 32 + 24;
    textures.fullWater = 5 * 32 + 9;
    textures.rightEdgeWater = 5 * 32 + 10;
    textures.upEdgeWater = 32 * 32 + 1;
    textures.cornerWater = 5 * 32 + 11;
    textures.normalGrave = 14 * 32 + 1;
    textures.crossGrave = 14 * 32 + 2;
    textures.squareGrave = 14 * 32 + 3;
    textures.fire = 10 * 32 + 16;
    textures.house = 20 * 32 + 5;
    textures.fence = 3 * 32 + 3;
end

% Define the textures
textures = getTextures();

% When clicking E it searches for a creatures
function searchForCreature(scene, player, key, object_layer, textures, creature_manager)
    if key ~= 'e' 
        return 
    end

    currentBlock = object_layer(player.y, player.x);
    randomChance = randi(100);

    % For testing
    %fprintf("Searching at (%d, %d) - Chance: %d\n", player.x, player.y, randomChance);  % Debug

    if randomChance > 20
        scene.uiPopup("You search the area but find nothing...", "Keep looking");
        return;
    end

    % Initialize empty rolled creature
    rolled = [];

    % Use the textures directly for the current block
    switch(currentBlock)
        case {textures.leftCornerCastleWall, textures.leftCastleWall, textures.bottomCastleWall}
            rolled = creature_manager.roll_creature(Set.Medieval);
        case textures.diamond
            rolled = creature_manager.roll_creature(Set.Funny);
        case {textures.fullWater, textures.rightEdgeWater, textures.upEdgeWater, textures.cornerWater}
            rolled = creature_manager.roll_creature(Set.Water);
        case {textures.normalGrave, textures.crossGrave, textures.squareGrave}
            rolled = creature_manager.roll_creature(Set.Dead);
        case textures.fire
            rolled = creature_manager.roll_creature(Set.Evil);
        case textures.house
            rolled = creature_manager.roll_creature(Set.Citizen);
        case textures.fence
            rolled = creature_manager.roll_creature(Set.Animal);
        otherwise
            scene.uiPopup("There doesn't seem to be anything interesting here...", "Try somewhere else");
            return;
    end

    % If a creature was successfully rolled, show it with the texture
    if ~isempty(rolled)
        % Check if the texture index is valid
        if rolled.creature_texture > 0 && rolled.creature_texture <= length(scene.sprites)
            scene.uiPopup(rolled.name, "Catch", scene.sprites{rolled.creature_texture});
            player.add_creature_to_inventory(rolled)
        else
            scene.uiPopup("Error: Invalid texture index for creature.", "Error");
        end
    else
        scene.uiPopup("You searched carefully, but nothing showed up...", "Unlucky");
    end
    
    % Prints inventory for testing

    %{
    fprintf("Inventory: ");
    for i = 1:length(player.inventory)
        fprintf("%s ", player.inventory(i).name);
    end
    fprintf("\n");
    %}
end

while gameRunning
    key = getKeyboardInput(my_scene);
    player.move(key);
    searchForCreature(my_scene, player, key, object_layer, textures, creature_manager);
end

