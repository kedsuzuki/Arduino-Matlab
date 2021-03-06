%% Arduino - Flex Sensor Plot (angle vs time)
% Author: Kensei Suzuki
% Date: 02/15/2021
% Description: Plots the bend angle of the flex sensor (from 0-90 degrees) over time
% Modified from: https://www.mathworks.com/matlabcentral/answers/333946-how-to-plot-the-real-time-data-from-arduino-in-matlab


clear; close all; clc;

a = arduino('Com3');                % define the Arduino Communication port

% Plot Variables
plotTitle = 'Arduino Flex Sensor';  % plot title
xLabel = 'Elapsed Time (s)';        % x-axis label
yLabel = 'Angle (degrees)';         % y-axis label

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

% Calculation Constants
VCC = 4.98;                         % measured voltage of Arduino 5V
R_DIV = 10000.0;                    % measured voltage of 10 kilo-Ohm resistor
STRAIGHT_R = 9321.0;                % resistance of sensor when straight
BENT_R = 16320.0;                   % resistor or sensor when bent 90 degrees

%Set up Plot
plotGraph = plot(time,data,'-r' );  % every AnalogRead needs to be on its own Plotgraph
hold on                             % hold on makes sure all of the channels are plotted
title(plotTitle,'FontSize',15);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
axis([min max yMin yMax]);
grid(plotGrid);

%Measuring the angle
tic                                 % start the stopwatch

while ishandle(plotGraph)           % Loop when Plot is Active will run until plot is closed
    dat = readVoltage(a, 'A0');     % read the analog data from the arduino in Volts 
    count = count + 1;              % increment count
    time(count) = toc;              % record time
    dat = R_DIV * (VCC / dat - 1.0); % computing the resistance of sensor given voltage
    angle = interp1([STRAIGHT_R, BENT_R], [-1.0, 91.0], dat); % computing bend angle from resistance
    data(count) = angle;            % store angle (in degrees)
    
    set(plotGraph,'XData',time,'YData',data);
    axis([0 time(count) yMin yMax]);
        
    %Update the graph
    pause(delay);
end

disp('Plot Closed and arduino object has been deleted');
