function [performance,time_window_start] = fn_tongue_ML_decoder(key)
perf_t=[];
t=[];
smallest_set_num=0;

% rel = (EXP.Session  & EPHYS.Unit & ANL.IncludeUnit) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good"') * EXP.SessionID * (EPHYS.UnitPosition & "brain_area='ALM'");

psth_t_vector=fetch1(ANL.Parameters & 'parameter_name="psth_t_vector"','parameter_value');

%
% session_uid = fetchn(rel,'session_uid');
% key.session_uid=session_uid(1);
% unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType * EXP.SessionID) & key & 'unit_quality="ok" or unit_quality="good"', 'unit', 'ORDER BY unit_uid');
unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType * EXP.SessionID) & key, 'unit', 'ORDER BY unit_uid');

if isempty(unit_num)
    return
end
psth_t_u_tr = fetch1(ANL.PSTHMatrix * EXP.SessionID & key , 'psth_t_u_tr');
% psth_t_u_tr =psth_t_u_tr(:,unit_num,:);
psth_t_u_tr =psth_t_u_tr(:,:,:);



k_video.tongue_estimation_type='tip';
rel_video=(  (ANL.Video1stLickTrialNormalized&k_video)* (EXP.BehaviorTrial & 'early_lick="no early"') & key);
TONGUE=struct2table(fetch(rel_video,'*','ORDER BY trial'));

analyzed_trials=  [TONGUE.trial];

%
% if key.flag_include_distractor_trials ==1
%     tr_left_hit = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_instruction ="left"' & 'outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');
%     tr_right_hit = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_instruction ="right"' & 'outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');
%
%     tr_left_miss = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_instruction ="left"' & 'outcome="miss"' & 'early_lick="no early"','trial', 'ORDER BY trial');
%     tr_right_miss = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_instruction ="right"' & 'outcome="miss"' & 'early_lick="no early"','trial', 'ORDER BY trial');
% elseif key.flag_include_distractor_trials ==0
%     tr_left_hit = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_type_name ="l"' & 'outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');
%     tr_right_hit = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_type_name ="r"' & 'outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');
%
%     tr_left_miss = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_type_name ="l"' & 'outcome="miss"' & 'early_lick="no early"','trial', 'ORDER BY trial');
%     tr_right_miss = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_type_name ="r"' & 'outcome="miss"' & 'early_lick="no early"','trial', 'ORDER BY trial');
% end

time_window_start=unique(fetchn(ANL.UnitTongue1DTuningML & key &  'smooth_flag=1' & 'outcome="all"','time_window_start'));
time_window_end=unique(fetchn(ANL.UnitTongue1DTuningML & key &  'smooth_flag=1' & 'outcome="all"','time_window_end'));


% tuning(1,:)=[0:1:5];
% tuning(2,:)=[5:-1:0];
% tuning(3,:)=[1,2,3,2,1,0];
%
% bins=linspace(0,1,6);
%
% fr_v=[4,1,1]';
%
% %tuning functions
% fns_tuning = cell(3,1);
% for ii = 1:3
%     fns_tuning{ii,1}=@(x)  interp1(bins,tuning(ii,:),x,'linear','extrap');
% end
%
% %maximum likelihood function
% finalfun =@(x) -fr_v(1)*log(fns_tuning{1,1}(x))+fns_tuning{1,1}(x);
% for ii = 2:3
%     finalfun =@(x) finalfun(x)-fr_v(ii)*log(fns_tuning{ii,1}(x))+fns_tuning{ii,1}(x);
% end
% x=[-0.2:0.1:1.2];
% y=finalfun(x);
%
% plot(x,y)
%






% time_window_wo_NANs= psth_t_vector>-2.5 & psth_t_vector<2;
% cells_trials=squeeze(mean(psth_t_u_tr(time_window_wo_NANs,:,analyzed_trials),1));
% num_analyzed_trials = numel(analyzed_trials);

% stable_cells = sum(isnan(cells_trials),2)<=num_analyzed_trials/4;
% psth_t_u_tr = psth_t_u_tr(:,stable_cells,analyzed_trials);
% if sum(stable_cells)<5
%     return
% end
psth_t_u_tr = psth_t_u_tr(:,:,analyzed_trials);

hist_bins_centers=fetchn(ANL.UnitTongue1DTuningML & key &  'smooth_flag=1' & 'outcome="all"', 'hist_bins_centers');
hist_bins_centers=hist_bins_centers{1};

t_include = time_window_start>=-2.5 & time_window_start<=1;
time_window_start=time_window_start(t_include);
time_window_end=time_window_end(t_include);



for i_t=1:1:numel(time_window_start)
    i_t;
    ix_t = psth_t_vector >=time_window_start(i_t) & psth_t_vector < time_window_end(i_t);
    t_wnd=time_window_end(i_t)-time_window_start(i_t);
    
    key_time.time_window_start=time_window_start(i_t);
    tuning_curves_all=fetchn(ANL.UnitTongue1DTuningML & key &  'smooth_flag=1' & 'outcome="all"' & key_time, 'tongue_tuning_1d', 'ORDER BY unit');
    unit_num=fetchn(ANL.UnitTongue1DTuningML & key &  'smooth_flag=1' & 'outcome="all"' & key_time, 'unit', 'ORDER BY unit');
    
    PV_at_t= squeeze(nanmean(psth_t_u_tr( ix_t,unit_num,:), 1))';
    
    fns_tuning = cell(size(tuning_curves_all));
    fr_v = zeros(size(tuning_curves_all));
    
    for ii = 1:numel(fns_tuning)
        fns_tuning{ii,1}=@(x)  interp1(hist_bins_centers,tuning_curves_all{ii,:},x,'linear','extrap');
    end
    
    
    
    
    for i_tr=1:1:numel(analyzed_trials)
        i_tr;
        fr_v=PV_at_t(i_tr,:);%'*t_wnd;
        idx_nan=isnan(fr_v);
        fr_v(idx_nan)=[];
        fns_tuning_tr = fns_tuning(~idx_nan);
        
        if numel(fns_tuning_tr)<5
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
        %looking for the minimum of a 1D function with a tolerance (how
        %small we allow the error to be)
        tol=0.05;
        xest(i_tr) = fminbnd(finalfun2,0,1,optimset('TolX',tol)) ;
    end
    
    %     x=[-0.2:0.1:1.2];
    %     y=finalfun(x);
    %
    %     plot(x,y)
    
    
    performance(i_t)= nanmean(1-abs(TONGUE.lick_horizoffset_relative-xest'))
    
    
    
end
performance