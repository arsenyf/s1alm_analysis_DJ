function p_norm = fn_compute_proj_binning (proj,all_proj,  tidx)

if isempty(proj.proj)
    p_norm.edges=[25:1:100]+NaN;
    p_norm.bin_percent=p_norm.edges+NaN;
else
    
    if sum(contains(proj.outcome,'miss'))<5 || sum(contains(proj.outcome,'hit'))<5
        p_norm.edges=[25:1:100]+NaN;
        p_norm.bin_percent=p_norm.edges+NaN;
        return;
    end
    
    all_projs=all_proj.proj;
    all_projs=nanmean(all_projs(:,tidx),2);
    all_max =  nanmax(all_projs);
    all_min =  nanmin(all_projs);
    all_projs_norm=(all_projs-all_min)./(all_max-all_min);
    
    analyzed_projs=nanmean(proj.proj(:,tidx),2);
    analyzed_projs_norm=(analyzed_projs-all_min)./(all_max-all_min);
    
    edges_left = [prctile(all_projs_norm,[0:1:75])];
    edges_right = [prctile(all_projs_norm,[25:1:100])];
    %     edges_left = [prctile(analyzed_projs_norm,[0:1:75])];
    %     edges_right = [prctile(analyzed_projs_norm,[25:1:100])];
    
    p_norm.edges=mean([edges_left;edges_right],1);
    for i=1:1:(numel(edges_right))
        [row,~,~]=find(analyzed_projs_norm>=edges_left(i) & analyzed_projs_norm<edges_right(i));
        if numel(row)>0
%             p_norm.bin_percent(i)=sum(contains(proj.outcome(row),'miss'))/numel(row);
            p_norm.bin_percent(i)=sum(contains(proj.outcome(row),'miss'))/sum(contains(proj.outcome,'miss'));

        else
            p_norm.bin_percent(i)=NaN;
        end
    end
end