function Pulse = GenRRCPulse(t, Beta, Type)
% Формирование импульса типа RRC (root-raised cosine)
%
% Входные параметры
%   t - нормированное время, т.е. время делённое на длительность тактового
%       интервала;
%   Beta - коэффициент сглаживания.
%
% Выходные параметры
%   Pulse - массив-строка с импульсом (энергия равна 1).

% Сам импульс
    if isequal(Type, 'RRC')
        Pulse = ( sin(pi*t*(1-Beta)) + 4*Beta*t.*cos(pi*t*(1+Beta)) ) ...
            ./ (pi*t.*(1-(4*Beta*t).^2));
    elseif isequal(Type, 'RC')
        Pulse = sinc(t) .* cos(pi*Beta*t) ./ (1 - (2*Beta*t).^2);
    end

% Особые точки
    % Всего возможны три особые точки: 0 и +-1/(4*Beta). В точке, близкой к
    % 0, будет получаться 0/0 = nan; в точках близких к +-1/(4*Beta) будет
    % получаться 1/0 = inf.

    if isequal(Type, 'RRC')
    % Подставим значения предела для t = 0
%         Pulse(isnan(Pulse)) = (1 - Beta + 4*Beta/pi);
        Pulse(abs(t) < sqrt(eps)) = (1 - Beta + 4*Beta/pi);

    % Подставим значения предела для t = +-1/(4*Beta)
%         Pulse(isinf(Pulse)) = (Beta/sqrt(2)) * ...
%             ((1+2/pi)*sin(pi/(4*Beta)) + (1-2/pi)*cos(pi/(4*Beta)));
        Pulse((abs(t-1/(4*Beta)) < sqrt(eps)) | ...
            (abs(t+1/(4*Beta)) < sqrt(eps))) = (Beta/sqrt(2)) * ...
            ((1+2/pi)*sin(pi/(4*Beta)) + (1-2/pi)*cos(pi/(4*Beta)));        
    elseif isequal(Type, 'RC')
        Pulse((abs(t-1/(2*Beta)) < sqrt(eps)) | ...
            (abs(t+1/(2*Beta)) < sqrt(eps))) = (pi/4) * sinc(1/(2*Beta));
    end        