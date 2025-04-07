classdef player < handle
    % Defines the player object in the game
    
    properties
        player_sprite;
        x;
        y;
        scene; 
        rooms_display; 
        gameboard_display;
        last_floor_sprite;
    end
    
    methods
        function player_obj = player(player_sprite, x, y, scene, rooms_display, gameboard_display)
            %PLAYER Construct an instance of this class
            %   Detailed explanation goes here
            
            player_obj.player_sprite = player_sprite;
            player_obj.x = x;
            player_obj.y = y;
            player_obj.scene = scene;
            player_obj.rooms_display = rooms_display;
            player_obj.gameboard_display = gameboard_display;
            player_obj.last_floor_sprite = 0;
        end

        %% Initalizes the character w/ things like it's starting position
        function initalize_character(player_obj)
            player_obj.gameboard_display(player_obj.x, player_obj.y) = player_obj.player_sprite;
            drawScene(player_obj.scene, player_obj.rooms_display, player_obj.gameboard_display)
        end

        %% Function to Move Player
        function move(player_obj)
            % Get input from the user
            k = getKeyboardInput(player_obj.scene);
            
            new_x = player_obj.x;
            new_y = player_obj.y;
        
            % Handle movement
            try
                if k == 'w' && player_obj.y > 1
                    new_y = player_obj.y - 1; % Move up
                elseif k == 's' && player_obj.y < 10
                    new_y = player_obj.y + 1; % Move down
                elseif k == 'a' && player_obj.x > 1
                    new_x = player_obj.x - 1; % Move left
                elseif k == 'd' && player_obj.x < 10
                    new_x = player_obj.x + 1; % Move right
                end
            catch exception
                warning("Something went wrong with movement input!")
            end
        
            % Checks to make sure the new input is not the same has the old
            if new_x ~= player_obj.x || new_y ~= player_obj.y
                player_obj.update_position(new_x, new_y);
            end
        end
        
        % Update player position
        function update_position(player_obj, new_x, new_y)
            % Could not hardset in future more flexability but it's fine
            % for now

            if player_obj.last_floor_sprite <= 0
                player_obj.last_floor_sprite = 1;
            end


            player_obj.gameboard_display(player_obj.y, player_obj.x) = player_obj.last_floor_sprite;
            player_obj.last_floor_sprite = player_obj.gameboard_display(new_y, new_x);
            player_obj.gameboard_display(new_y, new_x) = player_obj.player_sprite;

            drawScene(player_obj.scene, player_obj.rooms_display, player_obj.gameboard_display)
                
            player_obj.x = new_x;
            player_obj.y = new_y;
        end
    end
end