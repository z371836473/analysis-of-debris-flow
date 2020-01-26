function varargout = MO4WB(W,B)

main_optimize('-algorithm',@MOPSO,'-problem',@MONN,'-operator',@EAreal,'-N',500,'-M',2,'-D',2,'-evaluation',50000,'-mode',2);
load('Data\MOPSO\MOPSO_MONN_M2_1.mat','Population');

    for i = 1:numel(Population)
        dec(i,:) = Population(i).dec;
        obj(i,:) = Population(i).obj;
    end
    
    for i = 1:size(dec,1)
                W1 = W{1};
                for j = 1:numel(W{1})
                    W1(j) = dec(i,j);
                end
                W2 = W{2};
                for j = 1:numel(W{2})
                    W2(j) = dec(i,j);
                end
                Wopt(i,:) = {W1,W2};
                
                B1 = B{1};
                for j = 1:numel(B{1})
                    B1(j) = dec(i,j);
                end
                B2 = B{2};
                for j = 1:numel(B{2})
                    B2(j) = dec(i,j);
                end
                Bopt(i,:) = {B1,B2};
    end


varargout = {Wopt,Bopt,obj,dec};