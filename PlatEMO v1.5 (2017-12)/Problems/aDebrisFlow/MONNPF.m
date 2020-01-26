function varargout = MONNPF(Operation,Global,input)
% <problem> <TEST>
% Biased Multiobjective Optimization and Decomposition Algorithm
% operator --- EAreal

%--------------------------------------------------------------------------
% Copyright (c) 2016-2017 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB Platform
% for Evolutionary Multi-Objective Optimization [Educational Forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

load('..\data\NNInfo_Find_IO\NNInfo_I+D.mat','Wopt','Bopt','obj','dec','N_max','N_min','N_mid','N_m25','N_m75','choice','minOrMax');
if isempty(minOrMax)
    minOrMax = 'min';
end

    switch Operation
        case 'init'
            Global.M        = 2;
            Global.M        = size(Wopt{1,2},1);
            Global.D        = 3;
            Global.D        = size(Wopt{1,1},2);
            Global.lower    = -ones(1,Global.D);
            Global.upper    = ones(1,Global.D);
            Global.operator = @EAreal;
            
            PopDec = rand(input,Global.D);
            varargout = {PopDec};
            
        case 'value'
            PopDec = input;
            N = eval(['N_',choice]);
            W1 = Wopt{N,1};
            W2 = Wopt{N,2};
            B1 = Bopt{N,1};
            B2 = Bopt{N,2};
            
            sampleInput = PopDec';
            testHiddenOutput = sigmoid(dlarray(W1 * sampleInput + B1));
            testNetworkOutput = extractdata(W2 * testHiddenOutput + B2);
            
            switch minOrMax
                case 'min'
                    PopObj(:,1) = -testNetworkOutput(1,:)';
                    PopObj(:,2) = -testNetworkOutput(2,:)';
                case 'max'
                    PopObj(:,1) = testNetworkOutput(1,:)';
                    PopObj(:,2) = testNetworkOutput(2,:)';
            end
%             PopObj(:,3) = testNetworkOutput(3,:)';
            
            PopCon = [];
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
            f(:,1)    = (0:1/(input-1):1)';
            f(:,2)    = 1-f(:,1).^0.5;
            varargout = {f};
    end
end