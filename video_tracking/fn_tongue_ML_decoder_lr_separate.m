function [rmse_left, rmse_right, time_window_start, total_cells_used] = fn_tongue_ML_decoder_lr_separate(key)
rmse_left=[];
rmse_right=[];
time_window_start=[];
total_cells_used=[];

tol=0.01;
psth_t_vector=fetch1(ANL.Parameters & 'parameter_name="psth_t_vector"','parameter_value');
unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType * EXP.SessionID) & key, 'unit', 'ORDER BY unit_uid');

if isempty(unit_num)
    return
end
psth_t_u_tr = fetch1(ANL.PSTHMatrix * EXP.SessionID & key , 'psth_t_u_tr');


k_video.tongue_estimation_type='tip';
kk=key;
if strcmp(key.outcome_grouping,'all')
    kk=rmfield(kk,'outcome_grouping');
end

if kk.flag_use_basic_trials==1
    rel_video=(  (ANL.Video1stLickTrialNormalized&k_video)* (EXP.BehaviorTrial & 'early_lick="no early"') *   (EXP.TrialName & (ANL.TrialTypeGraphic & 'trialtype_left_and_right_no_distractors=1')) & kk);
else
    rel_video=(  (ANL.Video1stLickTrialNormalized&k_video)* (EXP.BehaviorTrial & 'early_lick="no early"') & kk);
end

TONGUE=struct2table(fetch(rel_video,'*','ORDER BY trial'));

analyzed_trials=  [TONGUE.trial];

time_window_start=unique(fetchn(ANL.UnitTongue1DTuning & key,'time_window_start'));
time_window_end=unique(fetchn(ANL.UnitTongue1DTuning & key ,'time_window_end'));


key_time.time_window_start=round(-0.6,4);
rel1= (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance & key & key_time  & 'number_of_trials>100' & 'total_number_of_spikes_window>100' & 'pvalue_si_1d<=0.01' & 'mean_fr_window>=2' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
key_time.time_window_start=0;
rel2=(ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance & key & key_time & 'number_of_trials>100' & 'total_number_of_spikes_window>100' & 'pvalue_si_1d<=0.01' & 'mean_fr_window>=2' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
relSignif=(EPHYS.Unit & 'unit_quality!="multi"') & (rel1 | rel2);

unit_num=fetchn(relSignif, 'unit', 'ORDER BY unit');
if numel(unit_num)<2
    return
end
psth_t_u_tr = psth_t_u_tr(:,unit_num,analyzed_trials);
time_window_wo_NANs= psth_t_vector>-3 & psth_t_vector<2;
cells_trials=squeeze(mean(psth_t_u_tr(time_window_wo_NANs,:,:),1));
num_analyzed_trials = numel(analyzed_trials);
stable_cells = sum(isnan(cells_trials),2)<=num_analyzed_trials/3;
if sum(stable_cells)<2
    return
end
psth_t_u_tr = psth_t_u_tr(:,stable_cells,:);
total_cells_used=sum(stable_cells);

hist_bins_centers=fetchn(ANL.UnitTongue1DTuning & key, 'hist_bins_centers');
hist_bins_centers=hist_bins_centers{1};

VariableNames=TONGUE.Properties.VariableNames';
Y=table2array(TONGUE(:,strcmp(VariableNames,key.tuning_param_name)'));

% finding left/right trials
lick_horizoffset_relative=TONGUE.lick_horizoffset_relative;
left_trials=lick_horizoffset_relative<0.5;
right_trials=lick_horizoffset_relative>=0.5;

if strcmp(kk.tuning_param_name,'lick_horizoffset_relative')
    % We set a different range for decoding left or right trials. This is to ensure that we don't decode the binary identity of the trial-type (i.e. trial went left, vs trial went right) but the actual offset value on each side
    x_est_range_trials=zeros(size(Y,1),2);
    x_est_range_trials(left_trials,1)=0;
    x_est_range_trials(left_trials,2)=0.5;
    
    x_est_range_trials(right_trials,1)=0.5;
    x_est_range_trials(right_trials,2)=1;
else
    x_est_range_trials=zeros(size(Y,1),2);
    x_est_range_trials(:,1)=0;
    x_est_range_trials(:,2)=1;
end
odd_trials=1:2:numel(analyzed_trials);
even_trials=2:2:numel(analyzed_trials);

for i_t=1:1:numel(time_window_start)
    i_t;
    ix_t = psth_t_vector >=time_window_start(i_t) & psth_t_vector < time_window_end(i_t);
    t_wnd=time_window_end(i_t)-time_window_start(i_t);
    
    PV_at_t= squeeze(nanmean(psth_t_u_tr( ix_t,:,:), 1))';
    
    key_time.time_window_start=round(time_window_start(i_t),4);
    
    % estimating odd trials from even tuning curve
    tuning_curves=fetchn(ANL.UnitTongue1DTuning & key  & key_time & relSignif, 'tongue_tuning_1d_even', 'ORDER BY unit');
    tuning_curves=tuning_curves(stable_cells);
    [error_left(1),error_right(1)] = fn_ml_decoder (odd_trials, PV_at_t, x_est_range_trials, tol,Y, left_trials, right_trials, tuning_curves, hist_bins_centers);
    
     % estimating even trials from odd tuning curve
    tuning_curves=fetchn(ANL.UnitTongue1DTuning & key  & key_time & relSignif, 'tongue_tuning_1d_odd', 'ORDER BY unit');
    tuning_curves=tuning_curves(stable_cells);
    [error_left(2),error_right(2)] = fn_ml_decoder (even_trials, PV_at_t, x_est_range_trials, tol,Y, left_trials, right_trials, tuning_curves, hist_bins_centers);

    
    rmse_left(i_t)=nanmean(error_left);
    rmse_right(i_t)=nanmean(error_right);
    %     figure %debug tuning curves
    %     for iii=1:1:numel(tuning_curves_all)
    %         hold on
    %         plot ([0:0.05:1], interp1(hist_bins_centers,tuning_curves_all{iii,:},[0:0.05:1],'linear','extrap'),'-r')
    %         plot(hist_bins_centers,tuning_curves_all{iii,:},'-b')
    % %        clf
    %     end
    
    %     xest=[];
    %     for i_tr=1:1:numel(analyzed_trials)
    %         i_tr;
    %         fr_v=PV_at_t(i_tr,:);%'*t_wnd;
    %         idx_nan=isnan(fr_v);
    %         fr_v(idx_nan)=[];
    %         fns_tuning_tr = fns_tuning(~idx_nan);
    %
    %         if numel(fns_tuning_tr)<1
    %             xest(i_tr)=NaN;
    %             continue
    %         end
    %         %maximum likelihood function
    %         finalfun=[];
    %         finalfun =@(x) -fr_v(1)*log(fns_tuning_tr{1,1}(x))+fns_tuning_tr{1,1}(x);
    %         for ii = 2:size(fns_tuning_tr,1)
    %             finalfun =@(x) finalfun(x)-fr_v(ii)*log(fns_tuning_tr{ii,1}(x))+fns_tuning_tr{ii,1}(x);
    %         end
    %
    %         finalfun2= @(x) real(finalfun(x)); % debug why there is sometimes a complex output
    %         %looking for the minimum of a 1D function with a tolerance (how
    %         %small we allow the error to be)
    %         tol=0.01;
    %         xest(i_tr) = fminbnd(finalfun2,x_est_range_trials(i_tr,1),x_est_range_trials(i_tr,2),optimset('TolX',tol)) ;
    % %         xest(i_tr) = fminbnd(finalfun2,0,1,optimset('TolX',tol)) ;
    %
    %     end
    
    %     x=[-0.2:0.1:1.2];
    %     y=finalfun(x);
    
    %
    %     plot(x,y)
    
    %
    %     decoder_error_left(i_t)= nanmean(abs(Y(left_trials)-xest(left_trials)') );
    %     decoder_error_right(i_t)= nanmean(abs(Y(right_trials)-xest(right_trials)'));
    
    
end
