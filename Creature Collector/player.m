classdef player < handle

    properties
        player_sprite;
        x;
        y;
        scene;
        layers;
        player_layer;
        last_floor_sprite;
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
        end

        %initalizes the character at the starting position
        function initalize_character(player_obj)
            player_obj.layers{player_obj.player_layer}(player_obj.y, player_obj.x) = player_obj.player_sprite;
            drawScene(player_obj.scene, player_obj.layers{:});
        end

        %handles movement using wasd
        function move(player_obj)

            k = getKeyboardInput(player_obj.scene);

            new_x = player_obj.x;
            new_y = player_obj.y;

            try
                if k == 'w'  && player_obj.y - 1 > 0
                    new_y = player_obj.y - 1;
                elseif k == 's' && player_obj.y + 1 < 21
                    new_y = player_obj.y + 1;
                elseif k == 'a' && player_obj.x - 1 > 0
                    new_x = player_obj.x - 1;
                elseif k == 'd' && player_obj.x + 1 < 21
                    new_x = player_obj.x + 1;
                end
            catch
                warning("Error with movement.");
            end

            if new_x ~= player_obj.x || new_y ~= player_obj.y
                player_obj.update_position(new_x, new_y);
            end
        end

        function update_position(player_obj, new_x, new_y)

            if player_obj.last_floor_sprite <= 0
                player_obj.last_floor_sprite = 1;
            end
        
            player_obj.layers{player_obj.player_layer}(player_obj.y, player_obj.x) = player_obj.last_floor_sprite;

            player_obj.last_floor_sprite = player_obj.layers{player_obj.player_layer}(new_y, new_x);

            player_obj.layers{player_obj.player_layer}(new_y, new_x) = player_obj.player_sprite;

            drawScene(player_obj.scene, player_obj.layers{:});

            player_obj.x = new_x;
            player_obj.y = new_y;
        end
    end
end
