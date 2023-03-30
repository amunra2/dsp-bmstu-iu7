function main()
    % Начальные параметры
    A = 1.0;
    sigma = 0.5;
    mult = 5;
    step = 0.005;
    t = -mult:step:mult;
    
    % Импульс
    u = gaussian_impulse(t,A,sigma);
    
    % Гауссова помеха
    NA = 0;
    NS = 0.05;
    xi_gauss = normrnd(NA,NS,[1 length(u)]);
    u_gauss = u+xi_gauss;
    
    % Импульсная помеха
    count = 7;
    M = 0.4;
    xi_impulse = impulsive_noise(length(u),count,M);
    u_impulse = u+xi_impulse;
    
    % 1. Фильтр Винера
    wiener_gauss = wiener_filter(fft(u_gauss), fft(xi_gauss))
    wiener_impulse = wiener_filter(fft(u_impulse), fft(xi_impulse))

    figure("name", "Фильтр Винера");
    
    subplot(2,1,1);
    title('Фильтрованный сигнал с Гауссовой помехой');
    hold on;
    grid on;
    plot(t, u_gauss, 'r');
    plot(t, ifft(fft(u_gauss).*wiener_gauss), 'g');
    legend('С помехой', 'Чистый');
    
    subplot(2,1,2);
    title('Фильтрованный сигнал с импульсной помехой');
    hold on;
    grid on;
    plot(t, u_impulse, 'r');
    plot(t, ifft(fft(u_impulse).*wiener_impulse), 'g');
    legend('С помехой', 'Чистый');

    % 2. Режекторный фильтр
    rejection_gauss = rejection_filter(fft(u_gauss), fft(xi_gauss));
    rejection_impulse = rejection_filter(fft(u_impulse), fft(xi_impulse));

    figure("name", "Режекторный фильтр");
    
    subplot(2,1,1);
    title('Фильтрованный сигнал с Гауссовой помехой');
    hold on;
    grid on;
    plot(t, u_gauss, 'r');
    plot(t, ifft(fft(u_gauss).*rejection_gauss), 'g');
    legend('С помехой', 'Чистый');
    
    subplot(2,1,2);
    title('Фильтрованный сигнал с импульсной помехой');
    hold on;
    grid on;
    plot(t, u_impulse, 'r');
    plot(t, ifft(fft(u_impulse).*rejection_impulse), 'g');
    legend('С помехой', 'Чистый');
end
    
% Гауссов импульс
function y = gaussian_impulse(x,A,s)
    y = A * exp(-(x/s).^2);
end
    
% Импульсная помеха
function y = impulsive_noise(size,N,mult)
    step = floor(size/N);
    y = zeros(1,size);
    for i = 1:floor(N/2)
        y(round(size/2)+i*step) = mult*(0.5+rand);
        y(round(size/2)-i*step) = mult*(0.5+rand);
    end
end
    
% Фильтр Виенера
function y = wiener_filter(x,n)
    y = 1 - (n./x).^2;
end

% Режекторный фильтр
function y = rejection_filter(u, xi)
    y = zeros(size(u));
    for i = 1:length(u)
        if abs(u(i)) - abs(xi(i)) > 1
            y(i) = 1;
        else
            y(i) = 0;
        endif
    endfor
end
