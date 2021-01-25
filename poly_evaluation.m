N = 1000;
deg = 1;

a = 2;


X = rand(N,2);
x = sort(X(:,1));
c = (X(:,2) > a*X(:,1).^2);

scatter(X(:,1), X(:,2), [], c)
hold on
plot(x, a*x.^2)
ylim([0, 1]);
hold off