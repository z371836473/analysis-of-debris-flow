clear;

% please input data here or from a file
I = [];
D = [];
E = [];
Imax = [];

choice = 'max';
choice_all = char('max','m75','mid','m25','min');
place = 'wenChuan';
fileName = 'main.m';
switchToCurrentFile(fileName);

numberOfSample = numel(I);
numberOfTrainingSample = floor(numel(I)*0.8); 
numberOfForcastSample = ceil(numel(I)*0.2);
numberOfHiddenNeure = 10;
inputDimension = 2;
outputDimension = 2;
order = 2; % order of Regularization Term

input = [E;Imax];
output = [I;D];

% normalization from -1 to 1
[tempInput,ps1] = mapminmax(input);
[tempOutput,ps2] = mapminmax(output);

trainingSampleInput = tempInput(:,1:numberOfTrainingSample);
trainingSampleOutput = tempOutput(:,1:numberOfTrainingSample);
forcastSampleInput = tempInput(:,numberOfTrainingSample + 1:numberOfSample);
forcastSampleOutput = tempOutput(:,numberOfTrainingSample + 1:numberOfSample);

W1 = 0.5 * randn(numberOfHiddenNeure, inputDimension);
B1 = 0.5 * randn(numberOfHiddenNeure, 1);
W2 = 0.5 * randn(outputDimension, numberOfHiddenNeure);
B2 = 0.5 * randn(outputDimension, 1);
W = {W1,W2};
B = {B1,B2};

%% MOPSO
trainingSampleOutput_temp = trainingSampleOutput;
save('.\data\NNInfo_Find_WB\NNInfo.mat','W','B','trainingSampleInput','trainingSampleOutput_temp','numberOfTrainingSample','order','lamda');
[Wopt,Bopt,obj,dec] = MO4WB(W,B);
switchToCurrentFile(fileName);

%% save data
% load(['.\data\debrisFlow\',place,'\WBopt_I+D.mat'],'Wopt','Bopt','obj','dec');
[N_max,N_mid,N_min,N_m25,N_m75] = getFivePoints(obj,200);
save(['.\data\debrisFlow\',place,'\WBopt_I+D.mat'],'Wopt','Bopt','obj','dec','N_max','N_min','N_mid','N_m25','N_m75');

%% predict
load(['.\data\debrisFlow\',place,'\WBopt_I+D.mat'],'Wopt','Bopt','obj','dec','N_max','N_min','N_mid','N_m25','N_m75');
for i = 1:size(choice_all,1)
    choice = choice_all(i,:);
    [testNetworkOutput] = predict4NN(Wopt,Bopt,eval(['N_',choice]),[trainingSampleInput,forcastSampleInput],numberOfSample);

    testOutput = mapminmax('reverse',testNetworkOutput,ps2);
    
    % MSE
    errorWithSquared_r = (testOutput(:,numberOfTrainingSample + 1:numberOfSample) - ...
                        output(:,numberOfTrainingSample + 1:numberOfSample)).^2;
    MSE_r = sum(sum(errorWithSquared_r))/(numberOfSample);
    save(['.\data\debrisFlow\',place,'\MSE_N',choice,'.mat'],'errorWithSquared','sumErrorWithSquared','MSE','errorWithSquared_r','MSE_r','testOutput');
end

%% find PF for NN
choice = 'max';
minOrMax = 'min';
load(['.\data\debrisFlow\',place,'\WBopt_I+D.mat'],'Wopt','Bopt','obj','dec','N_max','N_min','N_mid','N_m25','N_m75');
save('.\data\NNInfo_Find_IO\NNInfo_I+D.mat','Wopt','Bopt','obj','dec','N_max','N_min','N_mid','N_m25','N_m75','choice','minOrMax');
[PF,PS] = MO4NNPF;
switchToCurrentFile(fileName);

% reverse data
switch minOrMax
    case 'min'
        PF = PF;
    case 'max'
        PF = -PF;
    otherwise
        disp('Please input min or max for the parameter');
end
PS_r = mapminmax('reverse',PS',ps1)';
PF_r = mapminmax('reverse',PF',ps2)';
save(['.\data\debrisFlow\',place,'\PSPF_I','_N',choice,'_PF',minOrMax,'.mat'],'PF','PS','PS_r','PF_r');