classdef ClassMatchingFilter < handle
    properties(SetAccess=private) 
%   Нужно ли выполнять формирование сигнала через импульс
       isTransparent;
%    Переменная управления ызком вывода информации
        LogLanguage;
%   Коэфф скругления
        Beta;
%   Коэфф ускорения
    Tau;
%  Количество тактовых интервалов на одну компоненту
    Nt;
%     Сам импульс
   Pulse;
    end
    
    methods
        function obj = ClassMatchingFilter(Params, LogLanguage)
            
            % Выделим поля Params, необходимые для инициализации
                MF  = Params.MF;
            % Инициализация значений переменных из параметров
                obj.isTransparent = MF.isTransparent;
            % Переменная LogLanguage
                obj.LogLanguage = LogLanguage;
                obj.Beta = MF.Beta;
                obj.Tau = MF.Tau;
                obj.Nt = MF.Nt;
                
                GenPulse(obj.Nt,obj.Beta,'RRC');
        end
        

        function OutData = StepTx(obj, InData)
            if obj.isTransparent
                OutData = InData;
                return
            end           
            
        end
        
        function Pulse = GenPulse(Nt, Beta, Type)
%             Количетство компонент
            L = 1;
            Tau = 1 ;
            FlagStop = false;
 
            while ~FlagStop
                dt = 1/Nt;
                
                t = -L/2 + dt/2 : dt : L/2 - dt/2;
                % Генерация ИХ
                PulseShape = GenRRCPulse(t, Beta, Type);
                % Суммирование энергии
                PartEnergy = sum(PulseShape.^2)*dt;
                % Проверка на концентрацию энергии в усеченном импульсе
                if PartEnergy > EConc/100
                    FlagStop = true;
                else
                    L = L + 1;
                end
            end 

            % Новое значение L в усеченном импульсе
            NewL = ceil(L/Tau);
            % Изменение dt
            dt = Tau*(1/Nt);
            % Новая ось времени
            N = dt * NewL * Nt;
            A = zeros( 1, length( t ) );
            t1 = -N/2 + dt/2 : dt : N/2 - dt/2;
 
            % Генерация импульса с МСИ
            Pulse = GenRRCPulse(t1, Beta, Type);
 
        end
    end
end
