% Create a window
if ~exist('win','var'); win = [2,1];  end

% initialize the constant
if ~exist('Theta','var');Theta = pi/6;end
if ~exist('Rf','var');   Rf = 0.015;    end% 10mm wihch corresponds to the midrain
if ~exist('dt','var');    dt = 0.005;   end
if ~exist('v_car','var'); v_car = 8;   end% 32 km/h
if ~exist('r','var');   r = 1e-3;          end% size of the rainfall
if ~exist('r_a','var');   r_a = 5e-3;  end % size of the rainfall after falling on the glasses
if ~exist('T','var');    T = 5;            end% Time you want to simulate
if ~exist('mu','var');   mu = 0.47; end     % (fraction coefficient for glasses)

raindata = {};
Ns = [];
rain_list = [];     % initialy no rain

% Start simulation
for i = 1 : T/dt
    rain_list = rainer(rain_list, r,Theta,win,Rf,dt,v_car);
    rain_list = mover(rain_list,dt,Theta, v_car,mu,r_a);
    N = 0;
    ind_list = find(max([rain_list(2,:)>win(2); rain_list(2,:)<0])==1);
    if ind_list ~= 0
        rain_list(:,ind_list) = [];
    end
    
    for j = 1: length(rain_list(1,:))
        radi = sqrt(rain_list(1,j)^2+rain_list(2,j)^2);
        if radi<=min(win(1)/2,win(2))
            N = N+1;
        end
    end
      
    Ns(i) = N;
    raindata{i} = rain_list;
end

save('rain_info.mat','raindata','Ns')               