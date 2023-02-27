function [index,pred,sred,coladd,colrem]=updateindexred_full(index,redcost,m,pred,sred,mu)
% % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
%   OT_IPM: updateindexred_full
%
%   Updates the basis indexes, based on the reduced 
%    costs and the primal variable
%
%
%   Filippo Zanetti, 2022
%
% % % % % % % % % % % % % % % % % % % % % % % % % % %

indadd = [];
indrem = [];
vec = find(redcost<-1e-3);
vec = setdiff(vec,index);

if ~isempty(vec)
    
    col = length(vec);
    col = min(col,m);
    [~,indadd] = mink(redcost(vec),col);
    indadd = vec(indadd);    
    
    index = [index;indadd];
    pred = [pred;sqrt(mu)*ones(length(indadd),1)];
    sred = [sred;sqrt(mu)*ones(length(indadd),1)];
    
    [index,ind] = sort(index);
    pred = pred(ind);
    sred = sred(ind);
end

vec = find((pred)<1e-6);
if ~isempty(vec)
    col = length(vec);
    col = min(col,m);
    [~,indrem] = mink(pred(vec),col);
    indrem = vec(indrem);
        
    index(indrem) = [];
    pred(indrem) = [];
    sred(indrem) = [];  
end

coladd = length(indadd);
colrem = length(indrem);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% END OF FUNCTION updateindexred_full
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
