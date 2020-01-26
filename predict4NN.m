function varargout = predict4NN(Wopt,Bopt,N,sampleInput)

W1 = Wopt{N,1};
W2 = Wopt{N,2};
B1 = Bopt{N,1};
B2 = Bopt{N,2};
testHiddenOutput = sigmoid(dlarray(W1 * sampleInput + B1));
testNetworkOutput = extractdata(W2 * testHiddenOutput + B2);

varargout = {testNetworkOutput};