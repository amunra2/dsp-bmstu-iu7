function main()
% Начальное состояние
tt = 2.0;
sigma = 0.5;
mult = 5;
t = -mult:0.05:mult;

% Импульсы
x1 = zeros(size(t));
x1(abs(t) - tt < 0) = 1;
x1(abs(t) == tt) = 0.5;
x2 = exp(-(t/sigma).^2);

% FFT (Быстрое Преобразование Фурье)
disp('Время БПФ');
tic();
rectFFTy = fft(x1);
toc();
gaussFFTy = fft(x2);

rectFixedFFTy = fftshift(rectFFTy);
gaussFixedFFTy = fftshift(gaussFFTy);

% DFT (Дискретное Преобразование Фурье)
disp('Время ДПФ');
tic();
rectDFTy = dft(x1);
toc();
gaussDFTy = dft(x2);

rectFixedDFTy = fftshift(rectDFTy);
gaussFixedDFTy = fftshift(gaussDFTy);

M = 0:length(t)-1;

figure;

subplot(2,2,1);
title('FFT: прямоугольный сигнал');
hold on;
grid on;
plot(M, abs(rectFFTy)/length(M), 'r');
plot(M, abs(rectFixedFFTy)/length(M),'k');
legend('С эффектом близнецов', 'Без эффекта близнецов');

subplot(2,2,2);
title('FFT: сигнал Гаусса');
hold on;
grid on;
plot(M, abs(gaussFFTy)/length(M), 'r');
plot(M, abs(gaussFixedFFTy)/length(M), 'k');
legend('С эффектом близнецов', 'Без эффекта близнецов');

subplot(2,2,3);
title('DFT: прямоугольный сигнал');
hold on;
grid on;
plot(M, abs(rectDFTy)/length(M), 'r');
plot(M, abs(rectFixedDFTy)/length(M), 'k');
legend('С эффектом близнецов', 'Без эффекта близнецов');

subplot(2,2,4);
title('DFT: сигнал Гаусса');
hold on;
grid on;
plot(M, abs(gaussDFTy)/length(M), 'r');
plot(M, abs(gaussFixedDFTy)/length(M), 'k');
legend('С эффектом близнецов', 'Без эффекта близнецов');
end

% Дискретное преобразование Фурье
function y = dft(x)
a = 0:length(x)-1;
b = -2 * pi * sqrt(-1) * a / length(x);
for i = 1:length(a)
    a(i) = 0;
    for j = 1:length(x)
        a(i) = a(i) + x(j) * exp(b(i) * j);
    end
end
y = a;
end

