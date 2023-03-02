% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
%   This script generates a logarithmic plot of computational times for
%   -IPM
%   -Lemon
%   -Cplex
%   (Figure 6 in the paper).
%
%   To run it, select a cost function (1, 2 or 3)
%
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %




%% CHOOSE COST FUNCTION
%1: 1-norm, 2: 2-norm or 3: \infty-norm 

cost_function = 3;


%% GENERATE PLOT

meantime = zeros(4,3);

for classid=1:3

    res=32;
    for j=1:4
        
        switch cost_function
            case 1
                T=readtable(sprintf('../../results/original_results/results_IPM/dist1/ResultsClass%dRes%d_dist1',classid,res));
            case 3
                T=readtable(sprintf('../../results/original_results/results_IPM/distInf/ResultsClass%dRes%d_distInf',classid,res));
        end
        meantime(j,classid) = mean(T{:,'time'});

        res=res*2;
    end
end

[~,L32,C32] = readresults(32);
[~,L64,C64] = readresults(64);
[~,L128,C128] = readresults(128);

meanC_1(1,1) = mean(C32(1:45,cost_function));
meanC_1(2,1) = mean(C64(1:45,cost_function));
meanC_1(3,1) = mean(C128(1:45,cost_function));
meanC_1(1,2) = mean(C32(46:90,cost_function));
meanC_1(2,2) = mean(C64(46:90,cost_function));
meanC_1(3,2) = mean(C128(46:90,cost_function));
meanC_1(1,3) = mean(C32(91:135,cost_function));
meanC_1(2,3) = mean(C64(91:135,cost_function));
meanC_1(3,3) = mean(C128(91:135,cost_function));

meanL_1(1,1) = mean(L32(1:45,cost_function));
meanL_1(2,1) = mean(L64(1:45,cost_function));
meanL_1(3,1) = mean(L128(1:45,cost_function));
meanL_1(1,2) = mean(L32(46:90,cost_function));
meanL_1(2,2) = mean(L64(46:90,cost_function));
meanL_1(3,2) = mean(L128(46:90,cost_function));
meanL_1(1,3) = mean(L32(91:135,cost_function));
meanL_1(2,3) = mean(L64(91:135,cost_function));
meanL_1(3,3) = mean(L128(91:135,cost_function));

subplot(1,3,1)
loglog([32 64 128].^4,meanC_1(:,1),'k^','MarkerSize',10,'MarkerFaceColor','k');hold on
loglog([32 64 128].^4,meanL_1(:,1),'bo','MarkerSize',10,'MarkerFaceColor','blue')
loglog([32 64 128 256].^4,meantime(:,1),'rs','MarkerSize',10,'MarkerFaceColor','red')
loglog([32 64 128 256].^4,[32 64 128 256].^4/32^4*meantime(1,1),'k:','LineWidth',1)
hold off
legend('Cplex','Lemon','IPM','location','southeast')
title('Class 1')

subplot(1,3,2)
loglog([32 64 128].^4,meanC_1(:,2),'k^','MarkerSize',10,'MarkerFaceColor','k');hold on
loglog([32 64 128].^4,meanL_1(:,2),'bo','MarkerSize',10,'MarkerFaceColor','b')
loglog([32 64 128 256].^4,meantime(:,2),'rs','MarkerSize',10,'MarkerFaceColor','r')
loglog([32 64 128 256].^4,[32 64 128 256].^4/32^4*meantime(1,2),'k:','LineWidth',1)
hold off
title('Class 2')

subplot(1,3,3)
loglog([32 64 128].^4,meanC_1(:,3),'k^','MarkerSize',10,'MarkerFaceColor','k');hold on
loglog([32 64 128].^4,meanL_1(:,3),'bo','MarkerSize',10,'MarkerFaceColor','b')
loglog([32 64 128 256].^4,meantime(:,3),'rs','MarkerSize',10,'MarkerFaceColor','r')
loglog([32 64 128 256].^4,[32 64 128 256].^4/32^4*meantime(1,3),'k:','LineWidth',1)
hold off
title('Class 3')



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% END OF SCRIPT logplot_large_scale
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
