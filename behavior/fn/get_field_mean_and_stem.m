function [s_out] = get_field_mean_and_stem (dj_query1,dj_query2, dj_field,idx_enough_trials)

s = fetchn(dj_query1 & dj_query2, dj_field, 'ORDER BY session_uid');
s=s(idx_enough_trials);
s_out.mean = nanmedian(s);
s_out.stem = nanstd(s)/sqrt(sum(~isnan(s)));
s_out.values=s;
if dj_query2.trial_type_name(1) =='l'
    control = fetchn(dj_query1 & 'trial_type_name ="l"', dj_field, 'ORDER BY session_uid');
elseif dj_query2.trial_type_name(1) =='r'
    control = fetchn(dj_query1 & 'trial_type_name ="r"', dj_field, 'ORDER BY session_uid');
end

if sum(~isnan(s))
    %     if numel(s) == numel(control)
    %         %         [h,s_out.p] = ttest(s,control);
    %         s_out.p = signrank(s,control); % Wilcoxon signed rank test (paired-samples)
    %     else
    %         s_out.p = ranksum(s,control); %Wilcoxon rank sum test (non paired-samples)
    %     end
    s_out.p = ranksum(s,control); %Wilcoxon rank sum test (non paired-samples)
    
    if s_out.p<=0.001
        s_out.symbol='***';
    elseif s_out.p<=0.01
        s_out.symbol='**';
    elseif s_out.p<=0.05
        s_out.symbol='*  ';
    else
        s_out.symbol='';
    end
else
    s_out.p = NaN;
    s_out.symbol = NaN;
end
