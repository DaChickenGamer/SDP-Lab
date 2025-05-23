classdef player < handle

    properties
        player_sprite;
        x;
        y;
        scene;
        layers;
        player_layer;
        last_floor_sprite;
        moveFrames;
        inventory = Creature.empty;
        didMovement = false;

    end

    methods
        function player_obj = player(player_sprite, x, y, scene, layers)
            player_obj.player_sprite = player_sprite;
            player_obj.x = x;
            player_obj.y = y;
            player_obj.scene = scene;
            player_obj.layers = layers;
            player_obj.last_floor_sprite = 0;
        
            % Add a new top layer filled with blank tiles (1s)
            player_obj.player_layer = length(layers) + 1;
            new_layer = ones(20, 20);
        
            % Put player sprite at initial position
            new_layer(y, x) = player_sprite;
        
            % Assign that as the new player layer
            player_obj.layers{player_obj.player_layer} = new_layer;

            player_obj.moveFrames = [...
                8 * 32 + 19, ...
                8 * 32 + 20, ...
                8 * 32 + 21, ...
                8 * 32 + 22, ...
                8 * 32 + 23 ...
            ];
        end

        %initalizes the character at the starting position
        function initalize_character(player_obj)
            player_obj.layers{player_obj.player_layer}(player_obj.y, player_obj.x) = player_obj.player_sprite;
            drawScene(player_obj.scene, player_obj.layers{:});
        end

        function move(player_obj, key)
            if player_obj.didMovement
                return
            end
            player_obj.didMovement = true;

            new_x = player_obj.x;
            new_y = player_obj.y;
        
            try
                if strcmp(key, 'w') && player_obj.y - 1 > 0
                    new_y = player_obj.y - 1;
                elseif strcmp(key, 's') && player_obj.y + 1 < 21
                    new_y = player_obj.y + 1;
                elseif strcmp(key, 'a') && player_obj.x - 1 > 0
                    new_x = player_obj.x - 1;
                elseif strcmp(key, 'd') && player_obj.x + 1 < 21
                    new_x = player_obj.x + 1;
                end
            catch
                warning("Error with movement.");
            end
        
            if new_x ~= player_obj.x || new_y ~= player_obj.y
                player_obj.update_position(new_x, new_y);
            end

            player_obj.didMovement = false;
        end

        function update_position(player_obj, new_x, new_y)
            if player_obj.last_floor_sprite <= 0
                player_obj.last_floor_sprite = 1;
            end
        
            % Save the tile that exists at the new location BEFORE placing frames
            underlying_tile = player_obj.layers{player_obj.player_layer}(new_y, new_x);
        
            % Clear the current position
            player_obj.layers{player_obj.player_layer}(player_obj.y, player_obj.x) = player_obj.last_floor_sprite;
        
            % Animate movement using moveFrames
            for i = 1:length(player_obj.moveFrames)
                frame = player_obj.moveFrames(i);
        
                % Temporarily place the frame at the new position
                player_obj.layers{player_obj.player_layer}(new_y, new_x) = frame;
        
                drawScene(player_obj.scene, player_obj.layers{:});
                pause(0.05);
            end
        
            % Set final sprite
            player_obj.layers{player_obj.player_layer}(new_y, new_x) = player_obj.player_sprite;
            drawScene(player_obj.scene, player_obj.layers{:});
        
            % Update internal state
            player_obj.last_floor_sprite = underlying_tile;
            player_obj.x = new_x;
            player_obj.y = new_y;
        end

        function add_creature_to_inventory(obj, creature)
            obj.inventory(end + 1) = creature;
        end
    end
end
