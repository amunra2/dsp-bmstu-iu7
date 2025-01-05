function main()
    % Начальные параметры
    tt = 2.0;
    sigma = 1.0;
    mult = 5;
    t = -mult:0.05:mult;
    
    % Импульсы
    x_rect1 = [rect_impulse(t,1.0,tt) zeros(1,length(t))];
    x_gaus1 = [gaussian_impulse(t,tt,sigma) zeros(1,length(t))];
    x_rect2 = [rect_impulse(t,1,0.5) zeros(1,length(t))];
    x_gaus2 = [gaussian_impulse(t,0.5,sigma/2) zeros(1,length(t))];
    
    % Свертка
    y1 = ifft(fft(x_rect1).*fft(x_gaus1))*0.05; % Прямоугольный + Гаусс
    y2 = ifft(fft(x_rect1).*fft(x_rect2))*0.05; % Прямоугольный + Прямоугольный
    y3 = ifft(fft(x_gaus1).*fft(x_gaus2))*0.05; % Гаусс + Гаусс
    
    % Нормализация свертки
    start = fix((length(y1)-length(t))/2);
    y1 = y1(start+1:start+length(t));
    y2 = y2(start+1:start+length(t));
    y3 = y3(start+1:start+length(t));
    
    figure;
    
    subplot(3,1,1);
    title('Прямоугольный + Прямоугольный');
    hold on;
    grid on;
    plot(t, x_rect1(1:201), 'r');
    plot(t, x_rect2(1:201), 'b');
    plot(t, y2, 'k');
    legend('Прямоугольный', 'Прямоугольный', 'Свертка');
    
    subplot(3,1,2);
    title('Прямоугольный + Гаусс');
    hold on;
    grid on;
    plot(t, x_rect1(1:201), 'r');
    plot(t, x_gaus1(1:201), 'b');
    plot(t, y1, 'k');
    legend('Прямоугольный', 'Гаусс', 'Свертка');
    
    subplot(3,1,3);
    title('Гаусс + Гаусс');
    hold on;
    grid on;
    plot(t, x_gaus1(1:201), 'r');
    plot(t, x_gaus2(1:201), 'b');
    plot(t, y3, 'k');
    legend('Гаусс', 'Гаусс', 'Свертка');
end
    
% Прямоугольный импульс
function y = rect_impulse(x,T,A)
    y = zeros(size(x));
    y(abs(x) - T < 0) = A;
    y(abs(x) == T) = A/2;
end

% Импульс Гаусса
function y = gaussian_impulse(x,A,s)
    y = A * exp(-(x/s).^2);
end