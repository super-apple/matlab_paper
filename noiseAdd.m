function y = noiseAdd
%Calculate the difference between global DP and parallel composition of
%local DP

clear;
clc
clear;

%initialise
U = 943;
M = 1682;
rate = zeros(M, U);
T = 100000;
epsilon = 10;
y = zeros(1, 2);


%For data set 1, we apply counting + summation function on the number of movies
%whatched by customers.
data = load('data-1-counting-movie.data');
for i = 1 : 1 : 100000
    if data(i, 3) ~= 0
        %rate(data(i, 2), data(i, 1)) = 1;
        rate(data(i, 2), data(i, 1)) = data(i, 3);
    end
end

%For data set 2, we only apply summation
% data = load('LD2011-2014.txt');
% data(:, 1) = [];
% rate = data;
% U = size(rate, 2);
% M = size(rate, 1);


fprintf('Data Loaded\n');

%prepare
%Local sensitivity
lambdaL = max(rate) ./ epsilon;
muL = 2 .* lambdaL;


%Global sensitivity
lambdaG = repmat((max(max(rate)) .* M ./ epsilon), 1, U);
muG = 2 .* lambdaG;

fprintf('Loop Started\n');
%Loop for T times
for t = 1 : 1 : T
    %Generate Laplace noise for all users - Local sensitivity
    nsL = 0.5 .* exprnd(muL);
    noiseLO = sign(rand(1, size(nsL, 2)) - 0.5) .* nsL;
    
    noiseL = sum(noiseLO);
    
    y(1) = y(1) + abs(noiseL);

    
    %Generate Laplace noise for all users - Global sensitivity
    nsG = 0.5 .* exprnd(muG);
    noiseGO = sign(rand(1, size(nsG, 2)) - 0.5) .* nsG;
    
    noiseG = sum(noiseGO);
    
    y(2) = y(2) + abs(noiseG);


end




y = y ./ T;

sound(randn(4096, 1), 8192);

end
