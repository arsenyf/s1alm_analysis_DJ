function p_norm = fn_compute_proj_binning (proj,all_proj,  tidx, time)

if isempty(proj.proj) || size(proj.outcome,1) <10
    p_norm.edges=[33:1:100]+NaN;
    %     p_norm.edges=[25:1:100]+NaN;
    p_norm.bin_percent=p_norm.edges+NaN;
else
    
    %     if size(proj.outcome,1) <5
    % %     if sum(contains(proj.outcome,'miss'))<3 || sum(contains(proj.outcome,'hit'))<3
    %         p_norm.edges=[33:1:100]+NaN;
    %         p_norm.bin_percent=p_norm.edges+NaN;
    %         return;
    %     end
    average_error_prob_all_trials = sum(contains(all_proj.outcome,'miss'))/numel(all_proj.outcome);
    all_projs=all_proj.proj;
%     baseline=nanmean(all_projs(:,time>=-4 & time<-3),2);
%     all_projs=all_projs-baseline;
    
    all_projs=nanmean(all_projs(:,tidx),2);
    all_max =  nanmax(all_projs);
    all_min =  nanmin(all_projs);
    all_projs_norm=(all_projs-all_min)./(all_max-all_min);
    
    analyzed_projs=nanmean(proj.proj(:,tidx),2);
    analyzed_projs_norm=(analyzed_projs-all_min)./(all_max-all_min);
    edges_left = [prctile(all_projs_norm,[0:1:67])];
    edges_right = [prctile(all_projs_norm,[33:1:100])];
    %         edges_left = [prctile(analyzed_projs_norm,[0:1:75])];
    %         edges_right = [prctile(analyzed_projs_norm,[25:1:100])];
    
    p_norm.edges=mean([edges_left;edges_right],1);
    for i=1:1:(numel(edges_right))
        [row,~,~]=find(analyzed_projs_norm>=edges_left(i) & analyzed_projs_norm<edges_right(i));
        if numel(row)>0
            %                         p_norm.bin_percent(i)=sum(contains(proj.outcome(row),'miss'))/numel(row)-average_error_prob_all_trials;
            p_norm.bin_percent(i)=sum(contains(proj.outcome(row),'miss'))/numel(row);
            
        else
            p_norm.bin_percent(i)=NaN;
        end
    end
end