% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
%   This script generates the performance profiles for resolution
%   32, 64, or 128, for IPM, Lemon and Cplex.
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



%% CHOOSE RESOLUTION
resolution = 128;


%% CREATE PERFORMANCE PROFILE

[IPMtime,Lemontime,Cplextime] = readresults(resolution);

Time1 = [IPMtime(:,1) Lemontime(:,1) Cplextime(:,1)];
Time2 = [IPMtime(:,2) Lemontime(:,2) Cplextime(:,2)];
Time3 = [IPMtime(:,end) Lemontime(:,end) Cplextime(:,3)];

subplot(1,3,1)
performance_profile_3(Time1);
title('dist-1')
legend('IPM','Lemon','Cplex','Location','southeast');
subplot(1,3,2)
performance_profile_3(Time2);
title('dist-2')
subplot(1,3,3);
performance_profile_3(Time3);
title('dist-Inf')

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% END OF SCRIPT perf_profile_dotmark
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
