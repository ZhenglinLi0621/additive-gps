% Make figures of additive kernels in 3 dimensions
%
% April 2011
% =================

addpath(genpath([pwd '/../']))
addpath('../../utils/');
clear all
close all

dpi = 100;

% generate a grid
range = -4:0.1:4;
[a,b] = meshgrid(range, range);
xstar = [a(:) b(:)];


% Plot a sqexp kernel
% ==========================
covfunc = {'covSEiso'};
hyp.cov = log([1,1]);
K = feval(covfunc{:}, hyp.cov, xstar, [0,0]);
figure;
h = surf(a,b,reshape(K, length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
save2pdf('sqexp_kernel.pdf', gcf, dpi, true );
% Plot a draw from a that prior
% ================================================

seed=0;
randn('state',seed);
rand('state',seed);

K = feval(covfunc{:}, hyp.cov, xstar);
%imagesc(reshape(K, length(xstar), length(xstar)));
n = length( xstar);
K = K + diag(ones(n,1)).*0.000001;
%mu = feval(meanfunc{:}, hyp.mean, x);
y = chol(K)'*gpml_randn(rand, n, 1);% + mu;% + exp(hyp.lik)*gpml_randn(0.2, n, 1);
figure;
h = surf(a,b,reshape(y, length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
save2pdf('sqexp_draw.pdf', gcf, dpi, true );




% Plot an additive kernel
% ==========================
covfunc = {'covADD',{1,'covSEiso'}};
hyp.cov = log([1,1,1,1,sqrt(2)/2]);
K = feval(covfunc{:}, hyp.cov, xstar, [0,0]);
%imagesc(K)
figure;
h = surf(a,b,reshape(K, length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
zlim([0 1])
save2pdf('additive_kernel.pdf', gcf, dpi, true );
% Plot a draw from that prior
% ================================================
seed=0;
randn('state',seed);
rand('state',seed);

K = feval(covfunc{:}, hyp.cov, xstar);
%imagesc(reshape(K, length(xstar), length(xstar)))
n = length( xstar);
K = K + diag(ones(n,1)).*0.000001;
%mu = feval(meanfunc{:}, hyp.mean, x);
y = chol(K)'*gpml_randn(rand, n, 1);% + mu;% + exp(hyp.lik)*gpml_randn(0.2, n, 1);
figure;
h = surf(a,b,reshape(y, length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
save2pdf('additive_draw.pdf', gcf, dpi, true );
%plot(x, y, '-')


% Plot an additive kernel with 2nd order interactions
% ==========================
covfunc = {'covADD',{[1,2],'covSEiso'}};
hyp.cov = log([1,1,1,1,1,1]);
K = feval(covfunc{:}, hyp.cov, xstar, [0,0]);
figure;
h = surf(a,b,reshape(K, length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
save2pdf('additive_kernel_2nd_order.pdf', gcf, dpi, true );



% Plot an additive prior as the sum of two 1d kernels
% ===================================================
covfunc = {'covADD',{1,'covSEiso'}};
hyp.cov = log([1,1,sqrt(1/2)]);

xstar1 = [zeros(length(a(:)), 1) b(:)];
xstar2 = [a(:) zeros(length(b(:)), 1)];

K1 = feval(covfunc{:}, hyp.cov, a(:), [0]);
K2 = feval(covfunc{:}, hyp.cov, b(:), [0]);
%imagesc(K1)
figure; h = surf(a,b,reshape(K1, length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong');
zlim([0 1])
caxis([0 1])

save2pdf('additive_kernel_sum_p1.pdf', gcf, dpi, true );

figure; h = surf(a,b,reshape(K2, length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
zlim([0 1])
caxis([0 1])
save2pdf('additive_kernel_sum_p2.pdf', gcf, dpi, true );

figure; h = surf(a,b,reshape(K1 + K2, length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
zlim([0 1])
caxis([0 1])
% Plot a draw from those priors
% ================================================

covfunc = {'covADD',{1,'covSEiso'}};
hyp.cov = log([1,1,1,1,sqrt(1/2)]);

seed=5;  % 5 is pretty good
randn('state',seed);
rand('state',seed);

n = length( xstar1);
K1 = feval(covfunc{:}, hyp.cov, xstar1);
K2 = feval(covfunc{:}, hyp.cov, xstar2);
K1 = K1 + diag(ones(n,1)).*0.000001;
K2 = K2 + diag(ones(n,1)).*0.000001;

y1 = chol(K1)'*gpml_randn(rand, n, 1);
y2 = chol(K2)'*gpml_randn(rand, n, 1);
figure;
h = surf(a,b,reshape(y1 + 0.7, length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
zlim([-1 4]);
save2pdf('additive_kernel_draw_sum_p1.pdf', gcf, dpi, true );

figure;
h = surf(a,b,reshape(y2 - 0.7, length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
zlim([-1 4]);
save2pdf('additive_kernel_draw_sum_p2.pdf', gcf, dpi, true );

figure;
h = surf(a,b,reshape(y1+y2, length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
save2pdf('additive_kernel_draw_sum.pdf', gcf, dpi, true );
