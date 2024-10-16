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
