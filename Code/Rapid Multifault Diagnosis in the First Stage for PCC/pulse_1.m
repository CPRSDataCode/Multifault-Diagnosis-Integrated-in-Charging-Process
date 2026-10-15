%% 1. Environment Setup & File Definitions
clear; clc; close all;

% Define the 8 file names (Processing original 8 files)
fileNames = {'PCC_20.xlsx', 'PCC_27.xlsx', 'PCC_39.xlsx', ...
             'PCC_47.xlsx', 'PCC_57.xlsx', 'PCC_71.xlsx', 'PCC_80.xlsx'};

% Initialize storage matrices
diffMatrix = zeros(length(fileNames), 8); 
R_values = zeros(length(fileNames), 1);   

%% 2. Data Processing Loop
for i = 1:length(fileNames)
    fName = fullfile( pwd, '..', '..', 'data',fileNames{i});
    if exist(fName, 'file')
        data = readmatrix(fName);
        [rows, ~] = size(data);
        if rows >= 271
            current_diffs = data(271, 1:8) - data(270, 1:8);
            diffMatrix(i, :) = current_diffs;
            maxVal = max(current_diffs);
            meanOthers = (sum(current_diffs) - maxVal) / 7;
            R_values(i) = (maxVal - meanOthers) / 0.5;
        end
    end
end

plotDiffMatrix = diffMatrix;
plotR = R_values;

%% 4. Visualization: Bold Styling & Shifted X-Axis
figure('Color', 'w', 'Position', [100, 100, 1000, 720]);
hold on;

% Styling Parameters
fn = 'Times New Roman'; 
fs = 20;                
lw_box = 3.0;           
lw_plot = 2.5;
blueColor = [0.3010 0.7450 0.9330];
redColor = [0.9290 0.6940 0.1250];

% --- Left Y-Axis: Delta V Distribution ---
yyaxis left
h1 = []; h2 = []; % Handles for legend
for i = 1:length(fileNames)
    % Columns 1-7: Hollow Blue Circles
    h1 = scatter(ones(1,7)*i, plotDiffMatrix(i, 1:7), 140, ...
        'MarkerEdgeColor', blueColor, 'LineWidth', 2);
    
    % Column 8: SOLID Blue Circles
    h2 = scatter(i, plotDiffMatrix(i, 8), 140, ...
        'MarkerEdgeColor', blueColor, 'MarkerFaceColor', blueColor, 'LineWidth', 2);
end
ylabel('\DeltaV(V)', 'FontName', fn, 'FontSize', fs+2, 'FontWeight', 'bold');
set(gca, 'YColor', blueColor);

% --- Right Y-Axis: R Variable ---
yyaxis right
h3 = plot(1:length(fileNames), plotR, '--', 'Color', redColor, 'LineWidth', lw_plot); 
h4 = scatter(1:length(fileNames), plotR, 140, 'MarkerFaceColor', redColor, ...
    'MarkerEdgeColor', redColor, 'LineWidth', 2); 
ylabel('R(Ω)', 'FontName', fn, 'FontSize', fs+2, 'FontWeight', 'bold', 'Color', redColor);
set(gca, 'YColor', redColor);

set(gca, 'LineWidth', lw_box, 'FontName', fn, 'FontSize', fs, 'FontWeight', 'bold', 'Box', 'on');
xlim([0.5, length(fileNames) + 0.5]); xticks(1:length(fileNames));
xticklabels({'G1', 'G2', 'G3', 'G4', 'G5', 'G6', 'G7'}); 
xlabel('PCC Experimental groups', 'FontName', fn, 'FontSize', fs+6, 'FontWeight', 'bold');

yyaxis left
h1_legend = plot(NaN, NaN, 'o', 'MarkerSize', 15, 'MarkerEdgeColor', blueColor, ...
                 'LineWidth', 2.5, 'LineStyle', 'none', 'MarkerFaceColor', 'none');
h2_legend = plot(NaN, NaN, 'o', 'MarkerSize', 15, 'MarkerEdgeColor', blueColor, ...
                 'LineWidth', 2.5, 'LineStyle', 'none', 'MarkerFaceColor', blueColor);

yyaxis right
h4_legend = plot(NaN, NaN, 'o', 'MarkerSize', 15, ...
                 'MarkerEdgeColor', redColor, 'LineWidth', 2.5, 'LineStyle', 'none','MarkerFaceColor', redColor);

lgd = legend([h1_legend, h2_legend, h4_legend], {'Cell 1-7', 'Cell 8', 'R'}, 'Location', 'northwest');

set(lgd, 'FontName', fn, 'FontSize', fs-1, 'FontWeight', 'bold');

lgd.Box = 'off'; 
lgd.Color = 'none'; 
lgd.ItemTokenSize = [80, 35]; 

%title('Battery Anomaly Feature Distribution', 'FontName', fn, 'FontSize', fs+8, 'FontWeight', 'bold');
hold off;