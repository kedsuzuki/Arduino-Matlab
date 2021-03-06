%% Arduino - Plots for IR sensor (Voltage vs time)
% Author: Kensei Suzuki
% Date: 02/15/2021
% Description: Plots the measured distance of an object from IR sensor over time
% Modified from: https://www.mathworks.com/matlabcentral/answers/333946-how-to-plot-the-real-time-data-from-arduino-in-matlab

clear; close all; clc;
 
a = arduino('COM3', 'Uno');         % define the Arduino Communication port

% Plot Variables
plotTitle = 'Arduino IR Sensor';
xLabel = 'Elapsed Time (s)';        % x-axis label
yLabel = 'Distance (cm)';             % y-axis label for the IR sensor

yMax = 80;                          % y-axis maximum value
yMin = 0;                           % y-axis minimum value
plotGrid = 'on';                    % 'off' to turn off grid
min = 0;                            % x-axis min value
max = 10;                           % x-axis max value
delay = 0.1;                        % make sure sample faster than resolution 

% Instance variables
time = 0; 
data = 0;
count = 0;

plotGraph = plot(time,data,'-r' );  % every AnalogRead needs to be on its own Plotgraph
hold on                             % hold on makes sure all of the channels are plotted
title(plotTitle,'FontSize',15);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
axis([yMin yMax min max]);
grid(plotGrid);

%Measuring the angle
tic                                 % start the stopwatch

while ishandle(plotGraph)           % Loop when Plot is Active will run until plot is closed
    dat = readVoltage(a, 'A0');     % read the analog data from the arduino in Volts 
    distance = 23.0 * dat^(-1);     % computes the distance from voltage based on experimental observations
    count = count + 1;              % increment count
    time(count) = toc;              % record time
    data(count) = distance;         % store distance 
    
    set(plotGraph,'XData',time,'YData',data);
    axis([0 time(count) yMin yMax]);
        
    %Update the graph
    pause(delay);
end

disp('Plot Closed and arduino object has been deleted');