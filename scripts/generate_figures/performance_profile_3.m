function [t_t,perf_func_t] = performance_profile_3(Time)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
%   Function to produce the performance profile of three
%    series of data.
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    num_of_probs = size(Time,1);  
    num_solvers = size(Time,2);
    
    c_min_t = zeros(num_of_probs,1);
    
    for i = 1:num_of_probs
        c_min_t(i) = min(Time(i,:));
    end
    
    r_t = zeros(num_of_probs,num_solvers);
    
    for j = 1:num_solvers
        for i = 1:num_of_probs
            r_t(i,j) = Time(i,j)/c_min_t(i);
        end
    end
    
    numpoints=100;
    t_t = linspace(1,5,numpoints);
    perf_func_t = zeros(numpoints,num_solvers);
    for k = 1:numpoints
        for j = 1:num_solvers
            perf_func_t(k,j) = sum(r_t(:,j) <= t_t(k))/num_of_probs;
        end
    end
    
    plot(t_t,perf_func_t(:,1),'r-','MarkerSize',5,'LineWidth',2);hold on
    plot(t_t,perf_func_t(:,2),'b--','MarkerSize',5,'LineWidth',2);
    plot(t_t,perf_func_t(:,3),'g:','MarkerSize',5,'LineWidth',2);hold off
    xlabel('Performance ratio (time)');
    ylabel('Problems solved');
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% END OF FUNCTION performance_profile_3
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
