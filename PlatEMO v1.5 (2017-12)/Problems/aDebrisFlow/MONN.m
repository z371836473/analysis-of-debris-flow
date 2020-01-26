function varargout = MONN(Operation,Global,input)
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

load('..\data\NNInfo_Find_WB\NNInfo.mat','W','B','trainingSampleInput','trainingSampleOutput_temp','numberOfTrainingSample','order');

    switch Operation
        case 'init'
            Global.M        = 2;
            Global.M        = 2;
            temp            = 0;
            for i = 1:numel(W)
                temp    = temp + numel(W{i}) + numel(B{i});
            end
            Global.D        = temp;
            Global.D        = temp;
            Global.lower    = -ones(1,Global.D);
            Global.upper    = ones(1,Global.D);
            Global.operator = @EAreal;
            
            PopDec = rand(input,Global.D);
            varargout = {PopDec};
            
        case 'value'
            PopDec = input;
            
            for i = 1:size(input,1)
                W1 = W{1};
                for j = 1:numel(W{1})
                    W1(j) = PopDec(i,j);
                end
                W2 = W{2};
                for j = 1:numel(W{2})
                    W2(j) = PopDec(i,j);
                end
                
                B1 = B{1};
                for j = 1:numel(B{1})
                    B1(j) = PopDec(i,j);
                end
                B2 = B{2};
                for j = 1:numel(B{2})
                    B2(j) = PopDec(i,j);
                end
                
%                 hiddenOutput = logsig(dlarray(W1 * trainingSampleInput + B1));
                hiddenOutput = sigmoid(dlarray(W1 * trainingSampleInput + B1));
%                 hiddenOutput = leakyrelu(dlarray(W1 * trainingSampleInput + B1));
%                 hiddenOutput = relu(dlarray(W1 * trainingSampleInput + B1));
                networkOutput = extractdata(W2 * hiddenOutput + B2);
                error = -trainingSampleOutput_temp + networkOutput;
                
                PopObj(i,1) = sumsqr(error)/size(error,2);
                PopObj(i,2) = sum(sum(W1.^order)) + sum(sum(W2.^order));
%                 PopObj(i,2) = 1;
            end
            PopCon = [];
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
            f(:,1)    = (0:1/(input-1):1)';
            f(:,2)    = 1-f(:,1).^0.5;
            varargout = {f};
    end
end