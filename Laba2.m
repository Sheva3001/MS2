clear
clc

%Выборка нормального распределения
N = 10000;
mu = 1;
sigma = 2;
X = random('Normal',mu,sigma,N,1);

%Выборочное среднее, дисперсия и среднеквадратичное отклонение
Mean = mean(X);
Var = var(X);
SrOtkl = sqrt(Var);

%Среднее
X_mean_array = 0:1:1000;
X_var_array = 0:1:1000;

for i=1:1000
    X = random('Normal',mu,sigma,N,1);
    X_mean = mean(X);
    X_var = var(X);
    X_mean_array(i) = X_mean;
    X_var_array(i) = X_var;
end
clear X_mean;
clear X_var;

%Кол-во интервалов
r=floor(log2(N))+1;

%Min и Max значения выборки
X_max = max(X);
X_min = min(X);

%Ширина каждого интервала групировки
h=(X_max-X_min)/r;

%Создание интервалов
for i=0:r
    Z(i+1)=X_min+i*h;
end
clear 'i'


for i=1:r
    Zmean(i) = Z(i+1)-h/2;
end
clear 'i';
%Построение гистограмы
U= hist(X,Zmean);
H=U/(h*N);

% Найдём sigma по методу моментов. В нормальном распределении sigma это среднеквадратичному
% отклонению
SIGMA1 = SrOtkl;
FirstInaccuracy = SIGMA1 - sigma;

% Найдём sigma по ММП.

likex = [1:0.001:5];
for i=1:4001
    likey(i) = likelihood(likex(i),X);
end

[likeMax,likeIndex] = max(likey);
SIGMA2 = likex(likeIndex);

%Набор точек для вычисления и плотность вероятности
x = [-6:0.001:7];
pdf_uni = pdf('Normal',x,mu,sigma);
pdf_uni2 = pdf('Normal',x,mu,SIGMA2);

%Эмпирическая функция распределения
%Несгруппированные данные
X_sort = sort(X);
T=1/N:1/N:1;
%C оцен sigma
y = [-4:0.001:6];
uni_cdf = cdf('Normal',y,mu,SIGMA2);

%Вывод
figure;
subplot(3,1,1);
bar(Zmean,H,1);
hold on;
plot(x,pdf_uni);
hold on;
plot(x,pdf_uni2);
hold off;
subplot(3,1,2);
plot(likex,likey);
subplot(3,1,3);
stairs(X_sort,T);
hold on;
plot(y,uni_cdf)