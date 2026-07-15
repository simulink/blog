% Interpolate trajectory for smooth animation
profile_t     = [0    120  1500 1620 2700 2880 3180 3480];
profile_depth = [0.5  18   18   12   12   5    5    0];

% Create a smooth time vector (every 5 seconds)
t_minutes = profile_t / 60;
t_smooth = linspace(t_minutes(1), t_minutes(end), 300);
depth_smooth = interp1(t_minutes, profile_depth, t_smooth, 'linear');

% Read the image to animate
img = imread('diver.png');

% Generate transparency mask (AlphaData)
% Find pixels where all RGB channels are nearly white (e.g., > 230) and make them transparent
is_white = (img(:,:,1) > 230) & (img(:,:,2) > 230) & (img(:,:,3) > 230);
alpha_data = ones(size(img, 1), size(img, 2));
alpha_data(is_white) = 0; % Make near-white pixels fully transparent

% Setup figure
% Set a fixed size: 800 pixels wide, 500 pixels high, and set background to white
fig = figure('Name', 'Dive Profile Animation', ...
             'NumberTitle', 'off', ...
             'Position', [100, 100, 800, 300], ...
             'Color', 'white');
ax = axes(fig);
plot(ax, t_minutes, profile_depth, 'b-', 'LineWidth', 2);
set(ax, 'YDir', 'reverse');
xlabel(ax, 'Time (minutes)');
ylabel(ax, 'Depth (m)');
grid(ax, 'on');
title(ax, '1-hour dive: 18 m \rightarrow 12 m \rightarrow 5 m safety stop \rightarrow surface');
hold(ax, 'on');

% Define the scale/size of the image in data units
% Time span is 58 minutes, depth is 18m. Let's make the image look like a reasonable-sized icon/avatar.
img_width = 12;   % 12 minutes wide in X-axis (scaled up 3x)
img_height = 6;  % 6 meters high in Y-axis (scaled up 3x)

% Initialize image object with placeholder position and transparency (AlphaData)
hImg = image(ax, 'CData', img, 'AlphaData', alpha_data);

% Set static axis limits to prevent dynamic resizing during animation
% The trajectory time ranges from 0 to 58 min, and depth from 0 to 18 m.
% We add a margin on all sides to accommodate the large diver image cleanly.
xlim(ax, [0 - img_width/2, t_minutes(end) + img_width/2]);
ylim(ax, [-img_height/2, max(profile_depth) + img_height/2]);

% Loop to animate
gif_filename = 'dive_trajectory.gif';
if isfile(gif_filename)
    delete(delete(gif_filename))
end

for k = 1:length(t_smooth)
    % Get current position
    cx = t_smooth(k);
    cy = depth_smooth(k);
    
    % Update image position (centered on the current point)
    set(hImg, 'XData', [cx - img_width/2, cx + img_width/2], ...
              'YData', [cy - img_height/2, cy + img_height/2]);
          
    % Update title or label if desired with elapsed time/depth
    title(ax, sprintf('Dive Profile Animation - Time: %.1f min, Depth: %.1f m', cx, cy));
    
    % Force drawing update
    drawnow;
    
    % Capture the plot as a frame for the GIF
    frame = getframe(fig);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    
    % Write to the GIF file
    if k == 1
        imwrite(imind, cm, gif_filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.04);
    else
        imwrite(imind, cm, gif_filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.04);
    end
    
    pause(0.01); % Adjust speed of live animation
end

hold(ax, 'off');
