classdef ClassMatchingFilter < handle
    properties(SetAccess=private) 
%   ����� �� ��������� ������������ ������� ����� �������
       isTransparent;
%    ���������� ���������� ����� ������ ����������
        LogLanguage;
%   ����� ����������
        Beta;
%   ����� ���������
    Tau;
%  ���������� �������� ���������� �� ���� ����������
    Nt;
%     ��� �������
   Pulse;
    end
    
    methods
        function obj = ClassMatchingFilter(Params, LogLanguage)
            
            % ������� ���� Params, ����������� ��� �������������
                MF  = Params.MF;
            % ������������� �������� ���������� �� ����������
                obj.isTransparent = MF.isTransparent;
            % ���������� LogLanguage
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
%             ����������� ���������
            L = 1;
            Tau = 1 ;
            FlagStop = false;
 
            while ~FlagStop
                dt = 1/Nt;
                
                t = -L/2 + dt/2 : dt : L/2 - dt/2;
                % ��������� ��
                PulseShape = GenRRCPulse(t, Beta, Type);
                % ������������ �������
                PartEnergy = sum(PulseShape.^2)*dt;
                % �������� �� ������������ ������� � ��������� ��������
                if PartEnergy > EConc/100
                    FlagStop = true;
                else
                    L = L + 1;
                end
            end 

            % ����� �������� L � ��������� ��������
            NewL = ceil(L/Tau);
            % ��������� dt
            dt = Tau*(1/Nt);
            % ����� ��� �������
            N = dt * NewL * Nt;
            A = zeros( 1, length( t ) );
            t1 = -N/2 + dt/2 : dt : N/2 - dt/2;
 
            % ��������� �������� � ���
            Pulse = GenRRCPulse(t1, Beta, Type);
 
        end
    end
end
