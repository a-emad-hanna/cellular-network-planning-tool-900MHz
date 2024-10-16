%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% Inverse Erlang function %%%%%%%%%%%%%%%%%%%%%%%%%%

function A = inverlangb(c, gos)
    fun = @(A) gos - (A^c/factorial(c)) / sum(A.^((0:c))./factorial(0:c));
    A = fzero(fun, [0, 1000]);
end

%%%%%%%%%%%%%%%%%%%%%%%%% Hata function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function L = Hata(f,hm,hb,d)
    CH = 0.8 + (1.1 * log10(f) - 0.7) * hm - 1.5 * log10(f);
    L = 69.55 + 26.16 * log10(f) - 13.82 * log10(hb) ...
     - CH + (44.9 - 6.55 * log10(hb)) * log10(d);
end

%%%%%%%%%%%%%%%%%%%%%%% Valid N function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function N = valid_N(n)
    limit = 100; % limit of i & k
    i = 0:limit;
    valid = [];
    for k = 0:limit
        valid = [valid (i.^2 + k^2 + i.*k)];
    end
    valid = unique(sort(valid));
    while ~(ismember(n,valid))
        n = n + 1;
        if n > 30000
            print ('N is too large');
            break;
        end
    end
    N = n;
end

%%%%%%%%%%%%%%%%%%%%% Cluster Size function %%%%%%%%%%%%%%%%%%%%%%%%%%

function N = cluster_size(S, interference, SIR_dB, n)
    SIR = 10^(SIR_dB/10);
    N = ceil((1/3)*((interference*SIR)^(1/n) + 1)^2);
    N = valid_N(N);
end

%%%%%%%%%%%%%%%%%%%%%%%%% Acell function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Acell, Asector] = traffic_intensity(S, N, sectors, GOS)
    K = floor(S / (N * sectors));
    Asector = inverlangb(K, GOS);
    Acell = Asector * sectors;
end

%%%%%%%%%%%%%%%%%%%%%%% No. of Cells function %%%%%%%%%%%%%%%%%%%%%%%%

function Cells = no_of_cells(Area, User_Den, Acell, Au)
    Users_Per_cell = Acell / Au; % number of users per cell
    Total_Users = User_Den * Area; % total number of users
    Cells = ceil(Total_Users / Users_Per_cell); % total number of cells
end

%%%%%%%%%%%%%%%%%%%%%%%%% Radius function %%%%%%%%%%%%%%%%%%%%%%%%%%%%

function R = radius(Area, Cells)
    Area_Per_cell = Area / Cells;
    R = sqrt(Area_Per_cell / (3 * sqrt(3) / 2));
end

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

%%%%%%%%%%%%%%%%%%%%%%%% Asking for inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prompt = "What is the value of GOS ? \n";
GOS = input(prompt);

prompt= "What is the city Area ? \n";
Area = input(prompt);

prompt = "What is the user denisty ? \n";
User_Den = input(prompt);

prompt = "What is the minimum SIR_dB ? \n";
SIR_dB = input(prompt);

prompt = "Choose sectorization method (a-b-c).\na) omnidirectional\nb) 120 sectorization\nc) 60 sectorization \n" ;
sectorization = input(prompt, 's');
sf = 0; % flag for sectorization method check

while ~sf
    switch sectorization
        case 'a'
            sectors = 1;
            interference = 6;
            sf = 1;
        case 'b'
            sectors = 3;
            interference = 2;
            sf = 1;
        case 'c'
            sectors = 6;
            interference = 1;
            sf = 1;
        otherwise
            fprintf ('Incorrect input (options : a || b || c) \n');
            sectorization = input(prompt, 's');
    end
end

%%%5%%%%%%%%%%%%%%%%%%%%%%% Calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = cluster_size(S, interference, SIR_dB, n); % cluster size
[Acell, Asector] = traffic_intensity(S, N, sectors, GOS); % traffic intensity per cell
Cells = no_of_cells(Area, User_Den, Acell, Au); % number of cells
Cell_Radius = radius(Area, Cells); % cell radius

path_loss = Hata(freq, h_MS, h_BS, Cell_Radius);
P_tx = path_loss + sensitivity;

fprintf ('Cluster size = %d \n', N);
fprintf ('Number of cells = %d \n', Cells);
fprintf ('Cell radius = %d km\n', Cell_Radius);
fprintf ('Traffic intensity per cell = %d Erlang\n', Acell);
fprintf ('Traffic intensity per sector = %d Erlang\n', Asector);
fprintf ('Base station transmitted power = %d dBm\n', P_tx);

%%%%%%%%%%%%%%%%%%%%%%%%% Plot Prx vs distance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D = 0:0.01:Cell_Radius;
L = Hata(freq, h_MS, h_BS, D);
Prx = P_tx - L;
figure(1);
plot(D, Prx);
xlabel('Distance from BS (km)', 'FontSize', 14);
ylabel('Received Power (dBm)', 'FontSize', 14);
title('Received Power vs. Distance', 'FontSize', 16);
grid on


