close all

I = 100;    % Number of monte-carlo simulations
N = 100;    % Number of values in y
K = 1000;   % Number of parameters in the prior

x = linspace(1,10, N);
R = random("Normal", 0, 2, [1, N]);

sq = random("Normal", 2,0.3);
y = sq*x;

x_err = linspace(1,3,21);
err = zeros(1,21);
for i=1:21
    y_dist = x * (sq-1+(i-1)/10);
    err(i) = mean((y - y_dist).^2) / (max(y) - min(y));
end


figure();
hold on
plot(y)
plot(y+R)
hold off

figure();
plot(x_err, err)

prior = random("Normal", 2, 1, [1, K]);
