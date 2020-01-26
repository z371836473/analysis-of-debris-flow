function varargout = FDA1(Operation,Global,input)
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
load('FDA1_data.mat','nt','rt','numOfx1','numOfx2');

    switch Operation
        case 'init'
            Global.M        = 2;
            Global.M        = 2;
            Global.D        = 30;
            Global.lower    = [0,-ones(1,Global.D-1)];
            Global.upper    = ones(1,Global.D);
            Global.operator = @EAreal;
            
            PopDec    = rand(input,Global.D);
            varargout = {PopDec};
        case 'value'
            r = Global.gen;
            PopDec = input;
            
%             PF是固定的，如何生成动态的？PF中需要用到前面的f1的值，如何处理？            
            f1 = PopDec(:,1);
            t = 1/nt*floor(r/rt);            
            G = sin(0.5*pi*t);
            g = 1 + sum((PopDec(:,2:end) - G).^2,2);
            h = 1 - (f1./g).^(-0.5);
            
            PopObj(:,1) = f1;
            PopObj(:,2) = g.*h;            
            
            PopCon = [];
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
%             此处的f1还需改为动态的
            f1 = 5;
            f(:,1)    = 1-f1.^0.5;
            varargout = {f};
    end
end