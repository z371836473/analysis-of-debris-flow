% ���ܣ�     ��ȡ�������˵��һ���յ��2���ķ�λ��
% ����ֵ��   ���˵�͹յ�����

function varargout = getFivePoints(varargin)

obj = varargin{1};

num = numel(obj(:,1));
[A,index] = sort(obj(:,1),1); % ��Ŀ�꺯��ֵ�еĵ�һ����������,��С��������
sortedObj = [obj(index,1),obj(index,2)];
N_max = index(1);
N_min = index(num);

if (numel(varargin)<2)
    N_mid = index(ceil((1+num)/2));
else
    N_mid = varargin{2};
end

% offset = 2;
% for i=1:floor(num/offset)-5
%     k(i) = abs((sortedObj(i+offset,2) - sortedObj(i,2))/(sortedObj(i+offset,1) - sortedObj(i,1)));
% end
% 
% [~,maxkNumber] = max(k);
% N_mid = index(floor(maxkNumber*offset));

distance75 = obj(N_mid,2) + (obj(N_max,2) - obj(N_mid,2))/2;
distance25 = obj(N_mid,1) + (obj(N_min,1) - obj(N_mid,1))/2;
offset1 = 0.1;
offset2 = 0.1;
[~,N_m75] = find((obj(:,2)'>distance75-offset1) & (obj(:,2)'<distance75+offset1),1);
[~,N_m25] = find((obj(:,1)'>distance25-offset2) & (obj(:,1)'<distance25+offset2),1);

% N_m25 = index(ceil(prctile(index,25)));
% N_m75 = index(floor(prctile(index,75)));

varargout = {N_max,N_mid,N_min,N_m25,N_m75};