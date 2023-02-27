function [index,pred,sred,coladd,colrem]=updateindexred_heuristic(index,redcostred,vec,m,pred,sred,mu)
% % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
%   OT_IPM: Update Index
%
%   Updates basis indexes based on estimated reduced
%    costs and the primal variable.
%   Heuristic version
%
%
%   Filippo Zanetti, 2022
%
% % % % % % % % % % % % % % % % % % % % % % % % % % %

indadd = [];
indrem = [];

if ~isempty(vec)
    
    col = length(vec);
    col = min(col,m);
    [~,ind] = mink(redcostred,col);
    indadd = vec(ind);
    
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



coladd=length(indadd);
colrem=length(indrem);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% END OF FUNCTION updateindexred_heuristic
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
