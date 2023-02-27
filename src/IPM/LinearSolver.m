function [dy,iterpcg]=LinearSolver(in,Mat,rhs,tol)
% % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
%   OT_IPM: LinearSolver
%
%   Solves the normal equations linear system with
%    PCG or full factorization
%
%
%   Filippo Zanetti, 2022
%
% % % % % % % % % % % % % % % % % % % % % % % % % % %

switch in.method
    
    case 'iterative'    
        [dy,iterpcg] = mypcg(@(x)Mat.S*x,rhs,tol,in.CGmaxit,@(x)Mat.Lfactort\(Mat.Lfactor\x));
    
    case 'direct'
        dy = Mat.Lfactort\(Mat.Dfactor\(Mat.Lfactor\rhs(Mat.perm)));
        dy(Mat.perm) = dy;
        iterpcg = 0;
        
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% END OF FUNCTION LinearSolver
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    