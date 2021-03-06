close all

I = 200;    % Number of monte-carlo simulations
N = 100;    % Number of values in y
K = 1000;   % Number of parameters in the prior

a_mean_hat = 2;
a_std_hat = 0.5;

b_mean_hat = 5;
b_std_hat = 1;

a_mean = 2;
a_std = 0.5;

b_mean = 5;
b_std = 0.5;

x = linspace(1,10, N);%.^2;
x1 = x.^2;
x2 = x;

prior = random("Normal", a_mean_hat, a_std_hat, [1, K]);
R = random("Normal", 0, 2, [1, N]);

a = random("Normal", a_mean, a_std);
y = a*x1;
y_err = y + R;

thetas = (a_mean - 1 * a_mean):2*a_mean/(K-1):(a_mean + 1 * a_mean);

pdf_prior = 1 / (a_std_hat * sqrt(2*pi)) * exp(-(thetas - a_mean_hat).^2 / (2 * a_std_hat^2));
pdf_prior = pdf_prior / sum(pdf_prior);

p_thetas = [pdf_prior; thetas];

err = zeros(1,K);
for i=1:K
    y_dist = x1 * thetas(i);
    err(i) = 1 / mean((y_err - y_dist).^2) / (max(y_err) - min(y_err));
end
err_sum = sum(err);
err = err / err_sum;

theta = thetas(randperm(numel(thetas),1));
theta_t = thetas(randperm(numel(thetas),1));

p = randperm(size(p_thetas,2),2);
current = p_thetas(:,p);

posteriors = zeros(2, I);
m_posteriors = zeros(2, 1);

fontSize = 20;
figure('Renderer', 'painters', 'Position', [10 10 1400 800]);

for i=1:I
    alpha = current(1,2) / current(1,1);
    u = rand(1);
    while alpha < u
        p = randi(size(p_thetas,2));
        current(:,2) = p_thetas(:,p);
        alpha = current(1,2) / current(1,1);
        u = rand(1);
    end
    
    [~,ib] = ismember(current(:,2).',p_thetas.','rows');
    p_thetas(:,ib) = [];
    
    y_sim = current(2,2) * x1;
    posteriors(1,i) = current(2,2);
    posteriors(2,i) = 1 / mean((y_err - y_sim).^2) / (max(y_err) - min(y_err));
    
    m_posteriors(1,i) = posteriors(1,i);
    m_posteriors(2,i) = posteriors(2,i);
    
    current(:,1) = current(:,2);
    p = randi(size(p_thetas,2));
    current(:,2) = p_thetas(:,p);
    
    
    if i > 1
        [temp, order] = sort(m_posteriors(1,:));
        movie_sorted = m_posteriors(:,order);
        movie = interp1(movie_sorted(1,:),movie_sorted(2,:),thetas);
        movie(isnan(movie)) = 0;
        dots = m_posteriors(2,:) / err_sum;
        movie = movie / sum(movie);
        
        [M, index] = max(movie_sorted(2,:));
        theta_max = movie_sorted(1,index);
        
        if i <= 25
            h1 = subplot(2,2,1);
            hold on
            plot(thetas, err)
            plot(thetas, pdf_prior)
            plot(thetas, movie)
            plot(m_posteriors(1,:), dots, '.')
            hold off
            title(["Number of iterations: " + i, "a = " + a + ", $$\hat{a}$$ = " + theta_max], 'interpreter', 'latex')
        end
        
        if i <= 50
            h2 = subplot(2,2,2);
            hold on
            plot(thetas, err)
            plot(thetas, pdf_prior)
            plot(thetas, movie)
            plot(m_posteriors(1,:), dots, '.')
            hold off
            title(["Number of iterations: " + i, "a = " + a + ", $$\hat{a}$$ = " + theta_max], 'interpreter', 'latex')
        end
        
        if i <= 100
            h3 = subplot(2,2,3);
            hold on
            plot(thetas, err)
            plot(thetas, pdf_prior)
            plot(thetas, movie)
            plot(m_posteriors(1,:), dots, '.')
            hold off
            title(["Number of iterations: " + i, "a = " + a + ", $$\hat{a}$$ = " + theta_max], 'interpreter', 'latex')
        end
        
        h4 = subplot(2,2,4);
        hold on
        plot(thetas, err)
        plot(thetas, pdf_prior)
        plot(thetas, movie)
        plot(m_posteriors(1,:), dots, '.')
        hold off
        title(["Number of iterations: " + i, "a = " + a + ", $$\hat{a}$$ = " + theta_max], 'interpreter', 'latex')
        
        pause(0.01)
        if i < 25
            cla(h1)
        end
        if i < 50
            cla(h2)
        end
        if i < 100
            cla(h3)
        end
        if i < 200
            cla(h4)
        end
    end
end

[temp, order] = sort(posteriors(1,:));
post_sorted = posteriors(:,order);

vq1 = interp1(post_sorted(1,:),post_sorted(2,:),thetas);
vq1(isnan(vq1)) = 0;
vq1 = vq1 / sum(vq1);

post_sorted(2,:) = post_sorted(2,:) / sum(post_sorted(2,:));
posteriors(2,:) = posteriors(2,:) / sum(posteriors(2,:));

[M, index] = max(post_sorted(2,:));
theta_max = post_sorted(1,index);

% figure();
% hold on
% plot(y_err)
% hold off
% 
% figure();
% hold on
% plot(thetas, err)
% plot(thetas, pdf_prior)
% plot(thetas, vq1)
% comet(posteriors(1,:), posteriors(2,:))
% hold off
% title(["Number of iterations: " + I, "a = " + a + ", $$\hat{a}$$ = " + theta_max], 'interpreter', 'latex')
% legend(["Actual distribution", "Prior distribution", "Estimated distribution", "interp1"])


