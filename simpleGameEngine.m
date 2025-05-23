classdef simpleGameEngine < handle
    properties
        sprites = {}; % color data of the sprites
        sprites_transparency = {}; % transparency data of the sprites
        sprite_width = 0;
        sprite_height = 0;
        background_color = [0, 0, 0];
        zoom = 1;
        my_figure; % figure identifier
        my_image;  % image data
    end
    
    methods
        function obj = simpleGameEngine(sprites_fname, sprite_height, sprite_width, zoom, background_color)
            % simpleGameEngine
            % Input: 
            %  1. File name of sprite sheet as a character array
            %  2. Height of the sprites in pixels
            %  3. Width of the sprites in pixels
            %  4. (Optional) Zoom factor to multiply image by in final figure (Default: 1)
            %  5. (Optional) Background color in RGB format as a 3 element vector (Default: [0,0,0] i.e. black)
            % Output: an SGE scene variable
            
            % load the input data into the object
            obj.sprite_width = sprite_width;
            obj.sprite_height = sprite_height;
            if nargin > 4
                obj.background_color = background_color;
            end
            if nargin > 3
                obj.zoom = zoom;
            end
            
            % read the sprites image data and transparency
            [sprites_image, ~, transparency] = imread(sprites_fname);
            
            % determine how many sprites there are based on the sprite size
            % and image size
            sprites_size = size(sprites_image);
            sprite_row_max = (sprites_size(1)+1)/(sprite_height+1);
            sprite_col_max = (sprites_size(2)+1)/(sprite_width+1);
            
            % Make a transparency layer if there is none (this happens when
            % there are no transparent pixels in the file).
            if isempty(transparency)
                transparency = 255*ones(sprites_size,'uint8');
            else
                % If there is a transparency layer, use repmat() to
                % replicate is to all three color channels
                transparency = repmat(transparency,1,1,3);
            end
            
            % loop over the image and load the individual sprite data into
            % the object
            for r=1:sprite_row_max
                for c=1:sprite_col_max
                    r_min = sprite_height*(r-1)+r;
                    r_max = sprite_height*r+r-1;
                    c_min = sprite_width*(c-1)+c;
                    c_max = sprite_width*c+c-1;
                    obj.sprites{end+1} = sprites_image(r_min:r_max,c_min:c_max,:);
                    obj.sprites_transparency{end+1} = transparency(r_min:r_max,c_min:c_max,:);
                end
            end
        end

        function drawScene(obj, varargin)
            % drawScene
            % Input: an arbitrary number of sprite ID matrices
            % Each argument after obj is a layer matrix of the same size
            % Layers are drawn from bottom to top
        
            num_layers = length(varargin);
            if num_layers < 1
                error('At least one layer must be provided.');
            end
        
            % Check that all layers have the same size
            scene_size = size(varargin{1});
            for i = 2:num_layers
                if ~isequal(scene_size, size(varargin{i}))
                    error('All layers must have the same size.');
                end
            end
        
            num_rows = scene_size(1);
            num_cols = scene_size(2);
        
            % initialize the scene_data array
            scene_data = zeros(obj.sprite_height*num_rows, obj.sprite_width*num_cols, 3, 'uint8');
        
            for tile_row = 1:num_rows
                for tile_col = 1:num_cols
                    % Start with a blank tile of background color
                    tile_data = zeros(obj.sprite_height, obj.sprite_width, 3, 'uint8');
                    for rgb_idx = 1:3
                        tile_data(:,:,rgb_idx) = obj.background_color(rgb_idx);
                    end
        
                    % Apply each layer in order
                    for layer_idx = 1:num_layers
                        sprite_id = varargin{layer_idx}(tile_row, tile_col);
                        if sprite_id ~= 0
                            sprite = obj.sprites{sprite_id};
                            trans = obj.sprites_transparency{sprite_id};
                            tile_data = sprite .* (trans / 255) + ...
                                        tile_data .* ((255 - trans) / 255);
                        end
                    end
        
                    % Determine where to put this tile in the scene
                    rmin = obj.sprite_height * (tile_row - 1);
                    cmin = obj.sprite_width * (tile_col - 1);
                    scene_data(rmin+1:rmin+obj.sprite_height, cmin+1:cmin+obj.sprite_width, :) = tile_data;
                end
            end
            % If figure doesn't exist, create it
            if isempty(obj.my_figure) || ~isvalid(obj.my_figure)
                obj.my_figure = figure( ...
                    'Name', 'TamerVille', ...
                    'NumberTitle', 'off', ...
                    'MenuBar', 'none', ...
                    'ToolBar', 'none', ...
                    'Visible', 'on');
                obj.my_image = imshow(scene_data, 'InitialMagnification', obj.zoom * 100);
            else
                set(obj.my_image, 'CData', scene_data);
            end
        end

        function key = getKeyboardInput(obj)
            % getKeyboardInput
            % Input: an SGE scene, which gains focus
            % Output: next key pressed while scene has focus
            % Note: the operation of the program pauses while it waits for input
            % Example:
            %     	k = getKeyboardInput(my_scene);

            
            % Bring this scene to focus
            figure(obj.my_figure);
            
            % Pause the program until the user hits a key on the keyboard,
            % then return the key pressed. The loop is required so that
            % we don't exit on a mouse click instead.
            keydown = 0;
            while ~keydown
            keydown = waitforbuttonpress;
            end
            key = get(obj.my_figure,'CurrentKey');
        end
        
        function [row,col,button] = getMouseInput(obj)
            % getMouseInput
            % Input: an SGE scene, which gains focus
            % Output:
            %  1. The row of the tile clicked by the user
            %  2. The column of the tile clicked by the user
            %  3. (Optional) the button of the mouse used to click (1,2, or 3 for left, middle, and right, respectively)
            % 
            % Notes: A set of �crosshairs� appear in the scene�s figure,
            % and the program will pause until the user clicks on the
            % figure. It is possible to click outside the area of the
            % scene, in which case, the closest row and/or column is
            % returned.
            % 
            % Example:
            %     	[row,col,button] = getMouseInput (my_scene);
            
            % Bring this scene to focus
            figure(obj.my_figure);
            
            % Get the user mouse input
            [X,Y,button] = ginput(1);
            
            % Convert this into the tile row/column
            row = ceil(Y/obj.sprite_height/obj.zoom);
            col = ceil(X/obj.sprite_width/obj.zoom);
            
            % Calculate the maximum possible row and column from the
            % dimensions of the current scene
            sceneSize = size(obj.my_image.CData);
            max_row = sceneSize(1)/obj.sprite_height/obj.zoom;
            max_col = sceneSize(2)/obj.sprite_width/obj.zoom;
            
            % If the user clicked outside the scene, return instead the
            % closest row and/or column
            if row < 1
                row = 1;
            elseif row > max_row
                row = max_row;
            end
            if col < 1
                col = 1;
            elseif col > max_col
                col = max_col;
            end
        end

        function uiPopup(obj, titleText, buttonLabel, titleColor, imageData)
            % uiPopup
            % Creates a UI popup overlay with a title, image, and button
            % with interaction sounds. The overlay disappears once the button
            % is clicked.
        
            % Get figure size
            screenSize = get(obj.my_figure, 'Position');
            panelWidth = screenSize(3);
            panelHeight = screenSize(4);
        
            % Load interaction sounds

            % BUG: Sounds only play once

            %{
            [hoverSound, hoverFs] = audioread('assets/InteractionMechanicA.wav');
            if size(hoverSound, 2) > 1
                hoverSound = mean(hoverSound, 2); % Convert to mono
            end
            hoverPlayer = audioplayer(hoverSound, hoverFs);
            
            [clickSound, clickFs] = audioread('assets/InteractionFasten.wav');
            if size(clickSound, 2) > 1
                clickSound = mean(clickSound, 2); % Convert to mono
            end
            clickPlayer = audioplayer(clickSound, clickFs);
            %}
        
            % Create the overlay panel
            overlayPanel = uipanel('Parent', obj.my_figure, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1], ...
                'BackgroundColor', [0.2 0.2 0.2 0.8], ...
                'Tag', 'gameUI', ...
                'BorderType', 'none', ...
                'BorderWidth', 0);

            % Set default value for titleColor if not provided
            if nargin < 4 || isempty(titleColor)
                titleColor = 'white';
            end
        
            % Set default value for imageData if not provided
            if nargin < 5
                imageData = [];
            end
            
            % Create title text
            uicontrol('Parent', overlayPanel, ...
                'Style', 'text', ...
                'String', titleText, ...
                'Units', 'normalized', ...
                'Position', [0.25 0.75 0.5 0.1], ...
                'FontSize', 20, ...
                'FontWeight', 'bold', ...
                'BackgroundColor', [0.2 0.2 0.2 0.8], ...
                'ForegroundColor', titleColor, ...
                'HorizontalAlignment', 'center');
        
            % Handle image (optional)
            imageHandle = [];
            if exist('imageData', 'var') && ~isempty(imageData)
                imageHandle = uiimage('Parent', overlayPanel, ...
                    'ImageSource', imageData, ...
                    'ScaleMethod', 'fit');
        
                % Resize image based on window size
                resizeImage();
                set(obj.my_figure, 'SizeChangedFcn', @resizeImage);
            end
        
            % Function to resize image when window size changes
            function resizeImage(~, ~)
                if ishandle(imageHandle) && ishandle(overlayPanel)
                    screenSize = get(obj.my_figure, 'Position');
                    panelWidth = screenSize(3);
                    panelHeight = screenSize(4);
        
                    imageWidth = 0.3 * panelWidth;
                    imageHeight = 0.3 * panelHeight;
                    xPos = (panelWidth - imageWidth) / 2;
                    yPos = (panelHeight - imageHeight) / 2;
        
                    imageHandle.Position = [xPos, yPos, imageWidth, imageHeight];
                end
            end
        
            % Create the button
            button = uicontrol('Parent', overlayPanel, ...
                'Style', 'pushbutton', ...
                'String', buttonLabel, ...
                'Units', 'normalized', ...
                'Position', [0.4 0.15 0.2 0.1], ...
                'FontSize', 14, ...
                'Callback', @(~,~) onClick());
        
            % Sounds broken atm 
            % Hover detection function
            %set(obj.my_figure, 'WindowButtonMotionFcn', @onHover);
        
            % Callback for button click
            function onClick()
                %play(clickPlayer);
                delete(overlayPanel);
                set(obj.my_figure, 'WindowButtonMotionFcn', []);
            end
        
            % Callback for hover over button
            %{
            function onHover(~, ~)
                cursorPos = get(obj.my_figure, 'CurrentPoint');
                btnPos = getpixelposition(button, true);
        
                if cursorPos(1) >= btnPos(1) && cursorPos(1) <= btnPos(1) + btnPos(3) && ...
                   cursorPos(2) >= btnPos(2) && cursorPos(2) <= btnPos(2) + btnPos(4)
                    persistent hoverPlayed;
                    if isempty(hoverPlayed) || ~hoverPlayed
                        play(hoverPlayer);
                        hoverPlayed = true;
                    end
                else
                    hoverPlayed = false;
                end
            end
            %}
        end
    end
end
