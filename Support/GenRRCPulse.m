function Pulse = GenRRCPulse(t, Beta, Type)
% ������������ �������� ���� RRC (root-raised cosine)
%
% ������� ���������
%   t - ������������� �����, �.�. ����� ������� �� ������������ ���������
%       ���������;
%   Beta - ����������� �����������.
%
% �������� ���������
%   Pulse - ������-������ � ��������� (������� ����� 1).

% ��� �������
    if isequal(Type, 'RRC')
        Pulse = ( sin(pi*t*(1-Beta)) + 4*Beta*t.*cos(pi*t*(1+Beta)) ) ...
            ./ (pi*t.*(1-(4*Beta*t).^2));
    elseif isequal(Type, 'RC')
        Pulse = sinc(t) .* cos(pi*Beta*t) ./ (1 - (2*Beta*t).^2);
    end

% ������ �����
    % ����� �������� ��� ������ �����: 0 � +-1/(4*Beta). � �����, ������� �
    % 0, ����� ���������� 0/0 = nan; � ������ ������� � +-1/(4*Beta) �����
    % ���������� 1/0 = inf.

    if isequal(Type, 'RRC')
    % ��������� �������� ������� ��� t = 0
%         Pulse(isnan(Pulse)) = (1 - Beta + 4*Beta/pi);
        Pulse(abs(t) < sqrt(eps)) = (1 - Beta + 4*Beta/pi);

    % ��������� �������� ������� ��� t = +-1/(4*Beta)
%         Pulse(isinf(Pulse)) = (Beta/sqrt(2)) * ...
%             ((1+2/pi)*sin(pi/(4*Beta)) + (1-2/pi)*cos(pi/(4*Beta)));
        Pulse((abs(t-1/(4*Beta)) < sqrt(eps)) | ...
            (abs(t+1/(4*Beta)) < sqrt(eps))) = (Beta/sqrt(2)) * ...
            ((1+2/pi)*sin(pi/(4*Beta)) + (1-2/pi)*cos(pi/(4*Beta)));        
    elseif isequal(Type, 'RC')
        Pulse((abs(t-1/(2*Beta)) < sqrt(eps)) | ...
            (abs(t+1/(2*Beta)) < sqrt(eps))) = (pi/4) * sinc(1/(2*Beta));
    end        