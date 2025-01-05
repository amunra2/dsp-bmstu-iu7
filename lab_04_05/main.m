function main()
    % Начальные параметры
    A = 1.0;
    sigma = 0.5;
    mult = 5;
    step = 0.005;
    t = -mult:step:mult;

    % Импульс
    x0 = gaussian_impulse(t,A,sigma);

    % Гауссова помеха
    NA = 0;
    NS = 0.05;
    n1 = normrnd(NA,NS,[1 length(x0)]);
    x1 = x0+n1;

    % Испульсная помеха
    count = 7;
    M = 0.4;
    n2 = impulsive_noise(length(x0),count,M);
    x2 = x0+n2;

    % Вычисление фильтров
    GH = gaussian_filter(4,20,'high');
    GL = gaussian_filter(4,20,'low');
    BBH = butterworth_filter(6,20,'high');
    BBL = butterworth_filter(6,20,'low');


    % Высоких частот
    figure;

    subplot(3,1,1);
    title('Исходные сигналы');
    hold on;
    grid on;
    plot(t, x0, 'r');
    plot(t, x1, 'g');
    plot(t, x2, 'b');
    legend('Без помех', 'Гауссова помеха', 'Импульсная помеха');

    subplot(3,1,2);
    title('Гауссов фильтр (высоких частот)');
    hold on;
    grid on;
    plot(t, x0, 'r');
    plot(t, x1-filtfilt(GH,1,x1), 'g');
    plot(t, x2-filtfilt(GH,1,x2), 'b');
    legend('Без помех', 'Гауссова помеха', 'Импульсная помеха');

    subplot(3,1,3);
    title('Фильтр Баттеруорта (высоких частот)');
    hold on;
    grid on;
    plot(t, x0, 'r');
    plot(t, x1-filtfilt(BBH,1,x1), 'g');
    plot(t, x2-filtfilt(BBH,1,x2), 'b');
    legend('Без помех', 'Гауссова помеха', 'Импульсная помеха');

    % Низких частот
    figure;

    subplot(3,1,1);
    title('Исходные сигналы');
    hold on;
    grid on;
    plot(t, x0, 'r');
    plot(t, x1, 'g');
    plot(t, x2, 'b');
    legend('Без помех', 'Гауссова помеха', 'Импульсная помеха');

    subplot(3,1,2);
    title('Гауссов фильтр (низких частот)');
    hold on;
    grid on;
    plot(t, x0, 'r');
    plot(t, filtfilt(GL,1,x1), 'g');
    plot(t, filtfilt(GL,1,x2), 'b');
    legend('Без помех', 'Гауссова помеха', 'Импульсная помеха');

    subplot(3,1,3);
    title('Фильтр Баттеруорта (низких частот)');
    hold on;
    grid on;
    plot(t, x0, 'r');
    plot(t, filtfilt(BBL,1,x1), 'g');
    plot(t, filtfilt(BBL,1,x2), 'b');
    legend('Без помех', 'Гауссова помеха', 'Импульсная помеха');
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

% Фильтр Баттеруорта
function y = butterworth_filter(D,size,type)
    x = linspace(-size/2,size/2,size);
    if (strcmp(type,'low'))
        y = 1./(1+(x./D).^4);
    elseif (strcmp(type,'high'))
        y = 1./(1+(D./x).^4);
    else
        y = x*sum(x);
    end
    y = y/sum(y);
end

% Гауссов фильтр
function y = gaussian_filter(sigma,size,type)
    x = linspace(-size/2,size/2,size);
    if (strcmp(type,'low'))
        y = exp(-x.^2/(2*sigma^2));
    elseif (strcmp(type,'high'))
        y = 1 - exp(-x.^2/(2*sigma^2));
    else
        y = x*sum(x);
    end
    y = y/sum(y);
end
