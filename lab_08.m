function main()
    % Начальные значения
    A = 1.0;
    sigma = 1.0;
    a = 0.25;
    epsv = 0.05;
    mult = 3;
    step = 0.05;
    t = -mult:step:mult;

    yx = gaussian_impulse(t,A,sigma);
    N = length(yx);

    px = a .* rand(1, 7);
    pos = [25, 35, 40, 54, 67, 75, 95];
    pxx = length(pos);

    uxbase1 = gaussian_impulse(t,A,sigma);
    ux1 = gaussian_impulse(t,A,sigma);

    for i = 1 : 1 : pxx
      ux1(pos(i)) = ux1(pos(i)) + px(i);
      uxbase1(pos(i)) = uxbase1(pos(i)) + px(i);
    end

    for i = 1 : 1 : N
      smthm = mean(uxbase1, i);
      if (abs(ux1(i) - smthm) > epsv)
        ux1(i) = smthm;
      end
    end

    uxbase2 = gaussian_impulse(t,A,sigma);
    ux2 = gaussian_impulse(t,A,sigma);

    for i = 1 : 1 : pxx
      ux2(pos(i)) = ux2(pos(i)) + px(i);
      uxbase2(pos(i)) = uxbase2(pos(i)) + px(i);
    end

    for i = 1 : 1 : N
      smthm = med(uxbase2, i);
      if (abs(ux2(i) - smthm) > epsv)
        ux2(i) = smthm;
      end
    end

    figure;

    subplot(2,1,1);
    title('Mean-функция фильтрации');
    hold on;
    grid on;
    plot(t, uxbase1, 'r');
    plot(t, ux1, 'g');
    legend('Исходный сигнал', 'Сглаженный сигнал');

    subplot(2,1,2);
    title('Med-функция фильтрации');
    hold on;
    grid on;
    plot(t, uxbase2, 'r');
    plot(t, ux2, 'g');
    legend('Исходный сигнал', 'Сглаженный сигнал');
end

function y = mean(ux, i)
    r = 0;
    imin = i - 2;
    imax = i + 2;
    for j = imin : 1 : imax
      if (j > 0 && j < (length(ux) + 1))
        r = r + ux(j);
      end
    end
    r = r / 5;
    y = r;
end

function y = med(ux, i)
    imin = i - 1;
    imax = i + 1;
    ir = 0;

    if (imin < 1)
        ir = ux(imax);
    else
        if (imax > length(ux))
            ir = ux(imin);
        else
            if (ux(imax) > ux(imin))
                ir = ux(imin);
            else
            ir = ux(imax);
            end
        end
    end
    y = ir;
end

% Gaussian impulse
function y = gaussian_impulse(x,A,s)
    y = A * exp(-(x/s).^2);
end
