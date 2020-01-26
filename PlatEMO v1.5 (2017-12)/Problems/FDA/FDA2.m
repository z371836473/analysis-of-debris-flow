function varargout = FDA2(Operation,Global,input)
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
load('FDA2_data.mat','nt','rt','numOfx1','numOfx2','numOfx3');

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
            
            f1 = PopDec(:,1);
            t = 1/nt*floor(r/rt);
            H = 0.75 + 0.75*sin(0.5*pi*t);
            H2 = (H + sum(PopDec(:,end-numOfx3:end)-H.^2,2)).^(-1);
            g = 1 + sum(PopDec(:,2:2+numOfx2).^2,2);
            h = 1 - (f1./g).^(H2);
            
            PopObj(:,1) = f1;
            PopObj(:,2) = g.*h;            
            
            if rem(r,nt*rt)==0
                save(['..\platMaterialAnalysis\AMOPSO\AMOPSOdata\FDA2_tempPF_',num2str(r),'.mat'],'f1','H','PopObj');
            end
            
            PopCon = [];
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
            %             此处的f1,H还需改为动态的
            f1 = 5;
            H = 5;
            f(:,1)    = 1 - f1.^H;            
            varargout = {f};
    end
end