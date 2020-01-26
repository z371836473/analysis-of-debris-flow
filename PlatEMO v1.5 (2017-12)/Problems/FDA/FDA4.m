function varargout = FDA4(Operation,Global,input)
% <problem> <FDA>
% Comparison of Multiobjective Evolutionary Algorithms: Empirical Results
% operator --- EAreal

%--------------------------------------------------------------------------
% Copyright (c) 2016-2017 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB Platform
% for Evolutionary Multi-Objective Optimization [Educational Forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
load('FDA4_data.mat','nt','rt','numOfx1','numOfx2','M','k');

    switch Operation
        case 'init'
            Global.M        = 2;
            Global.D        = 30;
            Global.lower    = zeros(1,Global.D);
            Global.upper    = ones(1,Global.D);
            Global.operator = @EAreal;
            
            PopDec    = rand(input,Global.D);
            varargout = {PopDec};
        case 'value'          
            r = Global.gen;
            PopDec = input;
            
            t = 1/nt*floor(r/rt);
            G = abs(sin(0.5*pi*t));
            g = 1 + sum((PopDec(:,M:end) - G).^2,2);
            
            PopObj(:,1) = (1+g) .* prod(cos(PopDec(:,1:M-1)*pi/2),2);  
            for i = 2:M-1
                PopObj(:,i) = (1+g) .* prod(cos(PopDec(:,1:M-1)*pi/2),2) .* sin((M-i+1)*pi/2);
            end
            
            PopCon = [];
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
            %             此处的f1还需改为动态的
            f1 = 5;
            f2 = 5;
            f3 = 5;
            f(:,1)    = f1.^2+f2.^2+f3.^2;            
            varargout = {f};
    end
end