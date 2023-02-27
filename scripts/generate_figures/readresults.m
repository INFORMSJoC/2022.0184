function [I,L,C] = readresults(res)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
%   Function to read the OT results
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

I=[];
for i=1:10
    T1=readtable(sprintf('../../results/original_results/results_IPM/dist1/ResultsClass%dRes%d_dist1.txt',i,res));
    T2=readtable(sprintf('../../results/original_results/results_IPM/dist2/ResultsClass%dRes%d_dist2.txt',i,res));
    T3=readtable(sprintf('../../results/original_results/results_IPM/distInf/ResultsClass%dRes%d_distInf.txt',i,res));
    I=[I;T1{:,'time'} T2{:,'time'} T3{:,'time'}];  
end

%Lemon time
L1=readtable(sprintf('../../results/original_results/results_lemon/results_resolution_%d_dist1.txt',res));
L2=readtable(sprintf('../../results/original_results/results_lemon/results_resolution_%d_dist2.txt',res));
L3=readtable(sprintf('../../results/original_results/results_lemon/results_resolution_%d_dist3.txt',res));
L = [L1{:,"Var1"} L2{:,"Var1"} L3{:,"Var1"}]/1000;

%Cplex time
C1=readtable(sprintf('../../results/original_results/results_cplex/results_cplex_res_%d_dist_1.txt',res));
C2=readtable(sprintf('../../results/original_results/results_cplex/results_cplex_res_%d_dist_2.txt',res));
C3=readtable(sprintf('../../results/original_results/results_cplex/results_cplex_res_%d_dist_3.txt',res));
C = [C1{:,'Time'} C2{:,'Time'} C3{:,'Time'}];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% END OF FUNCTION readresults
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
