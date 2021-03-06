%% Arduino - PING Sensor Plot (distance vs time)
% Author: Kensei Suzuki
% Date: 02/15/2021
% Description: Plots the bend angle of the flex sensor (from 0-90 degrees) over time
% Modified from: https://www.mathworks.com/matlabcentral/answers/333946-how-to-plot-the-real-time-data-from-arduino-in-matlab

clear; close all; clc;

a = arduino('COM3', 'Uno', 'Libraries', 'Ultrasonic');                % define the Arduino Communication port
u = ultrasonic(a, 'D8');             % create an ultrasonic sensor object that is connected to pin7 on arduino

% Plot Variables
plotTitle = 'Arduino PING Sensor';  % plot title
xLabel = 'Elapsed Time (s)';        % x-axis label
yLabel = 'Distance (cm)';      % y-axis label

yMax = 100;                         % y-axis maximum value
yMin = 0;                           % y-axis minimum value
plotGrid = 'on';                    % 'off' to turn off grid
min = 0;                            % x-axis min value
max = 10;                           % x-axis max value
delay = 0.1;                        % make sure sample faster than resolution 

% Instance variables
time = 0; 
data = 0;
count = 0;

%Set up Plot
plotGraph = plot(time,data,'-r' );  % every AnalogRead needs to be on its own Plotgraph
hold on                             % hold on makes sure all of the channels are plotted
title(plotTitle,'FontSize',15);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
axis([min max yMin yMax]);
grid(plotGrid);

tic                                 % start the stopwatch

while ishandle(plotGraph)           % Loop when Plot is Active will run until plot is closed
    distance = readDistance(u);     % measure the distance from the ultrasonic sensor to an object (meters)
    count = count + 1;              % increment count
    time(count) = toc;              % record time
    data(count) = distance * 100.0; % store distance (in centimeters)
    
    set(plotGraph,'XData',time,'YData',data);
    axis([0 time(count) yMin yMax]);
        
    %Update the graph
    pause(delay);
end

disp('Plot Closed and arduino object has been deleted');