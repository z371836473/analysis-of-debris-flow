function varargout = MO4NNPF

main_optimize('-algorithm',@MOPSO,'-problem',@MONNPF,'-operator',@EAreal,'-N',500,'-M',2,'-D',2,'-evaluation',500000,'-mode',2);
load('..\data\NNInfo_Find_IO\NNInfo_I+D.mat','Wopt');
if (size(Wopt{1,2},1)==2)
    load('Data\MOPSO\MOPSO_MONNPF_M2_1.mat','Population');
end

if (size(Wopt{1,2},1)==3)
    load('Data\MOPSO\MOPSO_MONNPF_M3_1.mat','Population');
end

    for i = 1:numel(Population)
        dec(i,:) = Population(i).dec;
        obj(i,:) = Population(i).obj;
    end

varargout = {obj,dec};