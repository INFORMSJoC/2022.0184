% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
%   This script generates the plot of the computational times
%    for each class and each problem, at resolution 128.
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


%% CHOOSE COST FUNCTION

cost_function=2;


%% GENERATE PLOT

upper_axis = 2000;
res=128;

TimeIPM=[];

C=readtable(sprintf('../../results/original_results/results_cplex/results_cplex_res_%d_dist_%d.txt',res,cost_function));
TimeCplex = C{:,'Time'};

L=readtable(sprintf('../../results/original_results/results_lemon/results_resolution_%d_dist%d.txt',res,cost_function));
TimeLemon = L{:,'Var1'}/1000;

for classid=1:10
    if cost_function==1||cost_function==2
        T=readtable(sprintf('../../results/original_results/results_IPM/dist%d/ResultsClass%dRes%d_dist%d.txt',cost_function,classid,res,cost_function)); 
    elseif cost_function==3
        T=readtable(sprintf('../../results/original_results/results_IPM/distInf/ResultsClass%dRes%d_distInf.txt',classid,res)); 
    end
    TimeIPM=[TimeIPM;T{:,'time'}];
    
    
    figure(101)
    plot((classid)*ones(45,1)-.1,T{:,'time'},'rs','MarkerSize',10);hold on
    plot((classid)*ones(45,1),TimeCplex(45*(classid-1)+1:45*classid),'gx','MarkerSize',10);
    plot((classid)*ones(45,1)+.1,TimeLemon(45*(classid-1)+1:45*classid),'bo','MarkerSize',10);
    
    
    
end

figure(101)
hold off
xlabel('Class')
ylabel('Time')
%title(sprintf('Resolution %d',res))
legend('IPM','Cplex','Lemon','Location','northwest')
axis([0 11 0 upper_axis])



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% END OF SCRIPT time_spread_128
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


