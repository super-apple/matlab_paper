function y = diffDP
%Calculate the difference between global DP and parallel composition of
%local DP

clc
clear;

%initialise
T = 1000000;
y = zeros(1, 3);
x = zeros(1, 4);


%For data set 1, we apply counting + summation function on the number of movies
%whatched by customers.
data = load('data-1-counting-movie.data');
U = 943;
M = 1682;
rate = zeros(M, U);
for i = 1 : 1 : 100000
    if data(i, 3) ~= 0
        rate(data(i, 2), data(i, 1)) = 1; %counting
        %rate(data(i, 2), data(i, 1)) = data(i, 3); %summation
    end
end

%For data set 2, we only apply summation
% data = load('LD2011-2014.txt');
% data(:, 1) = [];
% rate = data;
% U = size(rate, 2);
% M = size(rate, 1);

%Test data
% U = 3;
% M = 4;
% rate = zeros(M, U);
% rate = [1 1 1; 2 1 2; 4 1 3; 5 20 4];

epsilon = 100 * ones(1, U);

fprintf('Data Loaded\n');

%prepare
%Bottom-up
lambda = max(rate) ./ epsilon;
%lambda = 1 ./ epsilon;
mu = 2 .* lambda;

%McSherry
epsilonM = max(epsilon);
lambdaM = max(sum(rate)) ./ epsilonM;
%lambdaM = 1 ./ epsilonM;
muM = 2 .* lambdaM;

%Shi
epsilonS = sum(epsilon);
lambdaS = max(max(rate)) .* M ./ epsilonS;
%lambdaS = 1 ./ epsilonS;
muS = 2 .* lambdaS;

%Lu
epsilonL = U .* max((max(rate) ./ sum(rate)) .* epsilon);
lambdaL = max(sum(rate)) ./ epsilonL;
%lambdaL = 1 ./ epsilonL;
muL = 2 .* lambdaL;

fprintf('Loop Started\n');
%Loop for T times
for t = 1 : 1 : T
    %Generate Laplace noise for all users
    ns = 0.5 .* exprnd(mu);
    %ns = exprnd(lambda);
    
    noise = sign(rand(1, size(ns, 2)) - 0.5) .* ns;
    x(1) = x(1) + abs(sum(noise));
    %x(1) = x(1) + sum(ns);

    %Overall counting with DP at aggregator:
    %counting = sum(sum(rate) + noise);


    %McSherry
    nsM = 0.5 .* exprnd(muM);
    %nsM = exprnd(lambdaM);
    %noiseM = sign(rand(1, size(nsM, 2)) - 0.5) .* nsM;
    
    x(2) = x(2) + nsM;
    
    %countingM = sum(sum(rate)) + noiseM;

    %y(1) = abs(countingM - counting) + y(1);
    %MAE
    %y(1) = y(1) + abs(abs(noiseO) - abs(noiseM));

    %Shi
    nsS = 0.5 .* exprnd(muS);
    %nsS = exprnd(lambdaS);
    %noiseS = sign(rand(1, size(nsS, 2)) - 0.5) .* nsS;
    
    x(3) = x(3) + nsS;
    
    %countingS = sum(sum(rate)) + noiseS;
    
    %y(2) = abs(countingS - counting) + y(2);
    %MAE
    %y(2) = y(2) + abs(abs(noiseO) - abs(noiseS));

    %Lu
    nsL = 0.5 .* exprnd(muL);
    %nsL = exprnd(lambdaL);
    %noiseL = sign(rand(1, size(nsL, 2)) - 0.5) .* nsL;
    
    x(4) = x(4) + nsL;
    
    %countingL = sum(sum(rate)) + noiseL;

    %y(3) = abs(countingL - counting) + y(3);
    %MAE
    %y(3) = y(3) + abs(abs(noiseO) - abs(noiseL));

end

for k = 1 : 1 : 3
    y(k) = abs(x(k + 1) - x(1)) / T;
end


%y = y ./ T;

%sound(randn(4096, 1), 8192);

end
