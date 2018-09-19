function [RMSE_left,RMSE_right] = fn_ml_decoder (analyzed_trials, PV_at_t, x_est_range_trials, tol,Y, left_trials, right_trials, tuning_curves, hist_bins_centers)
left_trials=left_trials(analyzed_trials);
right_trials=right_trials(analyzed_trials);
Y=Y(analyzed_trials);
x_est_range_trials=x_est_range_trials(analyzed_trials',:);
PV_at_t=PV_at_t(analyzed_trials,:);

fns_tuning = cell(size(tuning_curves));
for ii = 1:numel(fns_tuning)
    fns_tuning{ii,1}=@(x)  interp1(hist_bins_centers,tuning_curves{ii,:},x,'linear','extrap');
end


xest=[];
for i_tr=1:1:numel(analyzed_trials)
    i_tr;
    fr_v=PV_at_t(i_tr,:);
    idx_nan=isnan(fr_v);
    fr_v(idx_nan)=[];
    fns_tuning_tr = fns_tuning(~idx_nan);
    
    if numel(fns_tuning_tr)<2
        xest(i_tr)=NaN;
        continue
    end
    %maximum likelihood function
    finalfun=[];
    finalfun =@(x) -fr_v(1)*log(fns_tuning_tr{1,1}(x))+fns_tuning_tr{1,1}(x);
    for ii = 2:size(fns_tuning_tr,1)
        finalfun =@(x) finalfun(x)-fr_v(ii)*log(fns_tuning_tr{ii,1}(x))+fns_tuning_tr{ii,1}(x);
    end
    
    finalfun2= @(x) real(finalfun(x)); % debug why there is sometimes a complex output
    %looking for the minimum of a 1D function with a tolerance (how small we allow the error to be)
    xest(i_tr) = fminbnd(finalfun2,x_est_range_trials(i_tr,1),x_est_range_trials(i_tr,2),optimset('TolX',tol)) ;
    %         xest(i_tr) = fminbnd(finalfun2,0,1,optimset('TolX',tol)) ;
end

RMSE_left= sqrt(nanmean((Y(left_trials)-xest(left_trials)').^2 )); % root mean square
RMSE_right= sqrt(nanmean((Y(right_trials)-xest(right_trials)').^2 ));

