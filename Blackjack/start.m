function blackjack_gui()
   % Initial player data
   playerMoney = 100;
   playerName = 'Player';
   % Create the game window
   fig = uifigure('Name', 'Blackjack Game', 'Position', [100 100 420 400]);
   % UI Elements
   playerLabel = uilabel(fig, 'Position', [20 290 380 30], 'Text', '', 'FontSize', 14);
   dealerLabel = uilabel(fig, 'Position', [20 250 380 30], 'Text', '', 'FontSize', 14);
   statusLabel = uilabel(fig, 'Position', [20 210 380 30], 'Text', '', 'FontSize', 14);
   moneyLabel = uilabel(fig, 'Position', [20 170 380 30], 'Text', '', 'FontSize', 14);
   btnHit = uibutton(fig, 'Text', 'Hit', 'Position', [40 80 100 40]);
   btnStand = uibutton(fig, 'Text', 'Stand', 'Position', [160 80 100 40]);
   btnRetry = uibutton(fig, 'Text', 'Try Again', 'Position', [280 80 100 40], 'Enable', 'off');
   btnShop = uibutton(fig, 'Text', 'Shop', 'Position', [160 30 100 30]);
   % Start the game
   startNewGame();
   function startNewGame()
       % Shuffle deck and deal
       deck = repmat(1:13, 1, 4);
       deck = deck(randperm(length(deck)));
       idx = 1;
       playerHand = deck(idx:idx+1); idx = idx + 2;
       dealerHand = deck(idx:idx+1); idx = idx + 2;
       % Assign button callbacks
       btnHit.Enable = 'on';
       btnStand.Enable = 'on';
       btnRetry.Enable = 'off';
       btnHit.ButtonPushedFcn = @(~,~) hitCard();
       btnStand.ButtonPushedFcn = @(~,~) standPlay();
       btnRetry.ButtonPushedFcn = @(~,~) startNewGame();
       btnShop.ButtonPushedFcn = @(~,~) openShop();
       updateDisplay(false);
       statusLabel.Text = 'Your move...';
       function hitCard()
           playerHand(end+1) = deck(idx); idx = idx + 1;
           updateDisplay(false);
           score = calcScore(playerHand);
           if score > 21
               statusLabel.Text = sprintf('You busted with %d. Dealer wins!', score);
               endGame();
           end
       end
       function standPlay()
           updateDisplay(true);
           while calcScore(dealerHand) < 17
               dealerHand(end+1) = deck(idx); idx = idx + 1;
               updateDisplay(true);
               pause(0.5);
           end
           p = calcScore(playerHand);
           d = calcScore(dealerHand);
           if d > 21
               statusLabel.Text = sprintf('Dealer busted with %d. You win!', d);
               playerMoney = playerMoney + 10;
           elseif d > p
               statusLabel.Text = sprintf('Dealer wins: %d to %d.', d, p);
               playerMoney = max(0, playerMoney - 10);
           elseif p > d
               statusLabel.Text = sprintf('You win: %d to %d.', p, d);
               playerMoney = playerMoney + 10;
           else
               statusLabel.Text = sprintf('It''s a tie at %d!', p);
           end
           endGame();
       end
       function updateDisplay(showDealer)
           if nargin < 1
               showDealer = false;
           end
           playerLabel.Text = [playerName ' Hand: ' handToString(playerHand)];
           if showDealer
               dealerLabel.Text = ['Dealer Hand: ' handToString(dealerHand)];
           else
               dealerLabel.Text = ['Dealer Shows: ' cardToString(dealerHand(1)) ' ?'];
           end
           moneyLabel.Text = sprintf('Money: $%d', playerMoney);
       end
       function endGame()
           btnHit.Enable = 'off';
           btnStand.Enable = 'off';
           btnRetry.Enable = 'on';
           updateDisplay(true);
       end
       function openShop()
           shopFig = uifigure('Name', 'Shop', 'Position', [600 100 300 200]);
           uilabel(shopFig, 'Position', [20 140 260 30], 'Text', 'Change Name - $20', 'FontSize', 14);
           uibutton(shopFig, 'Text', 'Buy', 'Position', [20 100 80 30], ...
               'ButtonPushedFcn', @(~,~) buyNameChange(shopFig));
       end
       function buyNameChange(shopFig)
           if playerMoney >= 20
               nameDlg = inputdlg('Enter new player name:');
               if ~isempty(nameDlg)
                   playerName = nameDlg{1};
                   playerMoney = playerMoney - 20;
                   updateDisplay(false);
               end
           else
               uialert(shopFig, 'Not enough money!', 'Error');
           end
           close(shopFig);
       end
   end
   function score = calcScore(hand)
       values = hand;
       values(values > 10) = 10;
       aces = sum(values == 1);
       values(values == 1) = 11;
       score = sum(values);
       while score > 21 && aces > 0
           score = score - 10;
           aces = aces - 1;
       end
   end
   function str = handToString(hand)
       str = '';
       for i = 1:length(hand)
           str = [str cardToString(hand(i)) ' ']; %#ok<AGROW>
       end
   end
   function str = cardToString(v)
       names = {'A','2','3','4','5','6','7','8','9','10','J','Q','K'};
       str = names{v};
   end
end

