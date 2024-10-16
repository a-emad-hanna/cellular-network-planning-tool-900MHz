%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear;
clc;
pkg load communications;

S = 340;  % Total number of channels : S= N*K
freq = 900; % Frequency in MHz
sensitivity = -95; % in db
Au = 0.025; % in erlangs
n = 4; % path loss exponent
h_BS = 20; % Base Station height
h_MS = 1.5; % Mobile Station height
Area = 100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s_sweep = [1, 3, 6];    % sectorization sweep
i_sweep = [6, 2, 1];    % interference sweep

%%% 1) SIR Sweep

sir_sweep = 1:0.1:30;
N_sweep = [];
figure(2);
for j=1:3
    for i=1:length(sir_sweep)
        N_sweep(i) = cluster_size(S, i_sweep(j), sir_sweep(i), n);
    end
    hold on;
    plot(sir_sweep, N_sweep);
    xlabel('SIRmin (dB)', 'FontSize', 14);
    ylabel('Cluster Size (cells)', 'FontSize', 14);
    if j == 3
        legend('Omni-directional', '120° sectorization', '60° sectorization', 'FontSize', 12);
    end
    title('SIRmin vs Cluster Size', 'FontSize', 16);
    grid on;
end

%%%  2) 𝑆𝐼𝑅𝑚𝑖𝑛 = 19𝑑𝐵 & user density = 1400 𝑢𝑠𝑒𝑟𝑠/𝑘𝑚2


% Plot the number of cells & traffic intensity per cell versus GOS (1% to 30%).

gos_sweep = 1:0.1:30;
gos_sweep = gos_sweep / 100;
cells_sweep = [];
Acell_sweep = [];
Asector_sweep = [];
User_Den = 1400;

for j=1:3
    N = cluster_size(S, i_sweep(j), 19, n);
    for i=1:length(gos_sweep)
        [Acell_sweep(i), Asector_sweep(i)] = traffic_intensity(S, N, s_sweep(j), gos_sweep(i));
        cells_sweep(i) = no_of_cells(Area, User_Den, Acell_sweep(i), Au);
    end

    figure(3);
    hold on;
    plot(gos_sweep, cells_sweep);
    xlabel('GOS (%)', 'FontSize', 14);
    ylabel('Number of Cells (cells)', 'FontSize', 14);
    if j == 3
        legend('Omni-directional', '120° sectorization', '60° sectorization', 'FontSize', 12);
    end
    title('GOS vs Number of Cells (SIRmin = 19 dB)', 'FontSize', 16);
    grid on;

    figure(4);
    hold on;
    plot(gos_sweep, Acell_sweep);
    xlabel('GOS (%)', 'FontSize', 14);
    ylabel('Traffic Intensity per Cell (Erlang)', 'FontSize', 14);
    if j == 3
        legend('Omni-directional', '120° sectorization', '60° sectorization', 'FontSize', 12);
    end
    title('GOS vs Traffic Intensity per Cell (SIRmin = 19 dB)', 'FontSize', 16);
    grid on;

end


% 3) At 𝑆𝐼𝑅𝑚𝑖𝑛 = 14𝑑𝐵 & user density= 1400 𝑢𝑠𝑒𝑟𝑠/𝑘𝑚2

gos_sweep = 1:0.1:30;
gos_sweep = gos_sweep / 100;
cells_sweep = [];
Acell_sweep = [];
Asector_sweep = [];
User_Den = 1400;

for j=1:3
    N = cluster_size(S, i_sweep(j), 14, n);
    for i=1:length(gos_sweep)
        [Acell_sweep(i), Asector_sweep(i)] = traffic_intensity(S, N, s_sweep(j), gos_sweep(i));
        cells_sweep(i) = no_of_cells(Area, User_Den, Acell_sweep(i), Au);
    end

    figure(5);
    hold on;
    plot(gos_sweep, cells_sweep);
    if j == 3
        legend('Omni-directional', '120° sectorization', '60° sectorization', 'FontSize', 12);
    end
    xlabel('GOS (%)', 'FontSize', 14);
    ylabel('Number of Cells (cells)', 'FontSize', 14);
    title('GOS vs Number of Cells (SIRmin = 14 dB)', 'FontSize', 16);
    grid on;

    figure(6);
    hold on;
    plot(gos_sweep, Acell_sweep);
    if j == 3
        legend('Omni-directional', '120° sectorization', '60° sectorization', 'FontSize', 12);
    end
    xlabel('GOS (%)', 'FontSize', 14);
    ylabel('Traffic Intensity per Cell (Erlang)', 'FontSize', 14);
    title('GOS vs Traffic Intensity per Cell (SIRmin = 14 dB)', 'FontSize', 16);
    grid on;
end

% 4) At 𝑆𝐼𝑅𝑚𝑖𝑛 = 14𝑑𝐵 & GOS= 2%

User_Den_sweep = 100:100:2000;
GOS = 2/100;
cells_sweep = [];
Acell_sweep = [];
Asector_sweep = [];
radius_sweep = [];


for j=1:3
    N = cluster_size(S, i_sweep(j), 14, n);
    for i=1:length(User_Den_sweep)
        [Acell_sweep(i), Asector_sweep(i)] = traffic_intensity(S, N, s_sweep(j), GOS);
        cells_sweep(i) = no_of_cells(Area, User_Den_sweep(i), Acell_sweep(i), Au);
        radius_sweep(i) = radius(Area, cells_sweep(i));
    end

    figure(7);
    hold on;
    plot(User_Den_sweep, cells_sweep);
    if j == 3
        legend('Omni-directional', '120° sectorization', '60° sectorization', 'FontSize', 12);
    end
    xlabel('User Density (users/km^2)', 'FontSize', 14);
    ylabel('Number of Cells (cells)', 'FontSize', 14);
    title('User Density vs Number of Cells (SIRmin = 14 dB)', 'FontSize', 16);
    grid on;

    figure(8);
    hold on;
    plot(User_Den_sweep, radius_sweep);
    if j == 3
        legend('Omni-directional', '120° sectorization', '60° sectorization', 'FontSize', 12);
    end
    xlabel('User Density (users/km^2)', 'FontSize', 14);
    ylabel('Cell Radius (km)', 'FontSize', 14);
    title('User Density vs Cell Radius (SIRmin = 14 dB)', 'FontSize', 16);
    grid on;
end

% 5) At 𝑆𝐼𝑅𝑚𝑖𝑛 = 19𝑑𝐵 & GOS= 2%

User_Den_sweep = 100:100:2000;
GOS = 2/100;
cells_sweep = [];
Acell_sweep = [];
Asector_sweep = [];
radius_sweep = [];


for j=1:3
    N = cluster_size(S, i_sweep(j), 19, n);
    for i=1:length(User_Den_sweep)
        [Acell_sweep(i), Asector_sweep(i)] = traffic_intensity(S, N, s_sweep(j), GOS);
        cells_sweep(i) = no_of_cells(Area, User_Den_sweep(i), Acell_sweep(i), Au);
        radius_sweep(i) = radius(Area, cells_sweep(i));
    end

    figure(9);
    hold on;
    plot(User_Den_sweep, cells_sweep);
    if j == 3
        legend('Omni-directional', '120° sectorization', '60° sectorization', 'FontSize', 12);
    end
    xlabel('User Density (users/km^2)', 'FontSize', 14);
    ylabel('Number of Cells (cells)', 'FontSize', 14);
    title('User Density vs Number of Cells (SIRmin = 19 dB)', 'FontSize', 16);
    grid on;

    figure(10);
    hold on;
    plot(User_Den_sweep, radius_sweep);
    if j == 3
        legend('Omni-directional', '120° sectorization', '60° sectorization', 'FontSize', 12);
    end
    xlabel('User Density (users/km^2)', 'FontSize', 14);
    ylabel('Cell Radius (km)', 'FontSize', 14);
    title('User Density vs Cell Radius (SIRmin = 19 dB)', 'FontSize', 16);
    grid on;
end
