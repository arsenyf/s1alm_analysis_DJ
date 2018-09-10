clear all;
close all;



% Enables using several cores and parfor loops

dir_root = 'D:\Arseny\PROJECTS\';
dir_data = [dir_root 'Conjunctive_coding\Results\ML_decoder_simulations\DATA_SIMULATIONS\'];
dir_save_data= [dir_root 'Conjunctive_coding\Results\ML_decoder_simulations\DATA_SIMULATIONS\'];
file_name_save='full__sim_p1.4____norm_to_equal_FI_with_separate_errors.mat';

N = [10, 200] ;
N= sort(N);
nN = length(N) ; 
nt = 50 ;
t = logspace(-2,2,nt) ;

% N = unique(2*round(logspace(0,3.699,100))) ;
% nN = length(N) ; 
% nt = 100 ;
% t = logspace(-1.7,3,nt) ;

rep = 5000 ;
tol = 2*pi/360/100 ;
r_c = @(r0,k,x,y) r0*exp(k*(cos(x)+cos(y)-2)) ;
r_p = @(r0,k,x) r0*exp(k*(cos(x)-1)) ;
r_a = @(r0,k,y) r0*exp(k*(cos(y)-1)) ;



s = pi ;

k_pure = 2.37 ;
k_conj = 2.37 ;
r0_pure = 1 ;
% r0_conj = 2.5921; %normalization to Eq F.I.
r0_conj = r0_pure * (exp(2*k_conj)/exp(k_pure)) * (besseli(0,k_pure)/(besseli(0,k_conj)^2)); %normalization to mean

err_conj = zeros(length(t),length(N),rep) ;
err_pure = zeros(length(t),length(N),rep) ;

err_azim_pure = zeros(length(t),length(N),rep) ;
err_pitch_pure = zeros(length(t),length(N),rep) ;
err_azim_conj = zeros(length(t),length(N),rep) ;
err_pitch_conj = zeros(length(t),length(N),rep) ;

TotSpike_a = zeros(length(t),length(N),rep) ;
TotSpike_p = zeros(length(t),length(N),rep) ;
TotSpike_c = zeros(length(t),length(N),rep) ;

%%
tic ;
for it = 1:length(t)
    for iN = 1:1:length(N)
        for ir = 1:1:rep
            
            %preferred orientation
            xi_a = 2*pi*rand(N(iN)/2,1) ;
            xi_p = 2*pi*rand(N(iN)/2,1) ;
            xi_c = 2*pi*rand(N(iN),2) ;
            
            %firing rates
            ri_a = r_a(r0_pure,k_pure,xi_a-s) ;
            ri_p = r_p(r0_pure,k_pure,xi_p-s) ;
            ri_c = r_c(r0_conj,k_conj,xi_c(:,1)-s,xi_c(:,2)-s) ;
            
            %spike trains
            ni_a = poissrnd(t(it)*ri_a) ;
            ni_p = poissrnd(t(it)*ri_p) ;
            ni_c = poissrnd(t(it)*ri_c) ;

            %total spikes over all cells together
            TotSpike_a(it,iN,ir) = sum(ni_a) ;
            TotSpike_p(it,iN,ir) = sum(ni_p) ;
            TotSpike_c(it,iN,ir) = sum(ni_c) ;
            
            % solving for err_a, err_p, err_c
            %we want to find the maximum of the Likelihood function
            %(because the fminbnd finds the min we put a minus sign before
            %the Likelihood expression)
            L_a = @(x)      -sum(ni_a.*log(r_a(r0_pure,k_pure,x-xi_a)) - t(it)*r_a(r0_pure,k_pure,x-xi_a)) ;
            L_p = @(x)      -sum(ni_p.*log(r_p(r0_pure,k_pure,x-xi_p)) - t(it)*r_p(r0_pure,k_pure,x-xi_p)) ;
            L_c = @(x)      -sum(ni_c.*log(r_c(r0_conj,k_conj,x(1)-xi_c(:,1),x(2)-xi_c(:,2))) - t(it)*r_c(r0_conj,k_conj,x(1)-xi_c(:,1),x(2)-xi_c(:,2))) ;
            
           L_a = @(x) -sum(ni_a.*log(fun1(x)) - t(it)*fun1(x)) ;

            fun = @(x,xdata) [fun1(x,xdata(:,1))+  fun2(x,xdata(:,2))];            

% Composite Function



            %looking for the minimum of a 1D function with a tolerance (how
            %small we allow the error to be)
            xest_a = fminbnd(L_a,0,2*pi,optimset('TolX',tol)) ;
            xest_p = fminbnd(L_p,0,2*pi,optimset('TolX',tol)) ;
            
            %population vector for the conjunctive cells
            popv = [mean(ni_c.*xi_c(:,1)) , mean(ni_c.*xi_c(:,2))]/mean(ni_c) ;
            if isnan(popv(1))
            popv=[pi,pi]; % if it is NaN we set it to be [pi,pi] as the stimulus
            end;
            %Looking for the minimum of a 2D function with a tolerance (how
            %small we allow the error to be). We use the popv value as a
            %starting point. [0,0],[2*pi,2*pi] - upper and low bounds
%             xest_c = fmincon(L_c,popv,[],[],[],[],[0,0],[2*pi,2*pi],[],optimset('TolX',tol,'Display','off','algorithm','active-set')) ;
            xest_c = fmincon(L_c,popv,[],[],[],[],[0,0],[2*pi,2*pi],[],optimset('TolX',tol,'Display','off','algorithm','active-set')) ;


            err_pure(it,iN,ir) = norm([xest_a,xest_p]-[s,s]) ;
            err_conj(it,iN,ir) = norm(xest_c-[s,s]) ;
            
            % for i = 1:1000 
            %     dx_a(i) = dxL_a(xplot(i)) ; 
            %     dx_p(i) = dxL_p(xplot(i)) ; 
            % end
            % plot(xplot,dx_a,xplot,dx_p)
            
            % for testing coincidence detection hypothesis : err in azim
            % and pitch are estimated separately for both populations
            err_azim_pure  (it,iN,ir)  = xest_a - s ;
            err_pitch_pure (it,iN,ir)  = xest_p - s ;
            err_azim_conj  (it,iN,ir)  = xest_c(1) - s ;
            err_pitch_conj (it,iN,ir)  = xest_c(2) - s ;

        end
        disp([num2str(it) ' ' num2str(iN)]) ;        
    end
end
toc
HD_simulation_results.N_vector = N;
HD_simulation_results.t = t;
HD_simulation_results.err_pure = err_pure;
HD_simulation_results.err_conj = err_conj;
HD_simulation_results.err_azim_pure    = err_azim_pure ;
HD_simulation_results.err_pitch_pure   = err_pitch_pure ;
HD_simulation_results.err_azim_conj    = err_azim_conj ;
HD_simulation_results.err_pitch_conj   = err_pitch_conj ;
HD_simulation_results.TotSpike_a = TotSpike_a;
HD_simulation_results.TotSpike_p = TotSpike_p;
HD_simulation_results.TotSpike_c = TotSpike_c;
HD_simulation_results.tolerance = tol;
HD_simulation_results.k_pure = k_pure;
HD_simulation_results.k_conj = k_conj;
HD_simulation_results.r0_pure = r0_pure ;
HD_simulation_results.r0_conj = r0_conj ;

if isempty(dir(dir_save_data))
    mkdir (dir_save_data)
end;
save([dir_save_data file_name_save], '-struct', 'HD_simulation_results');