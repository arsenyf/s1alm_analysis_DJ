function proj = fn_compute_proj_avg_and_statistics (proj, time, tidx)

 if isempty(proj.proj)
        proj.mean =  time + NaN;
        proj.bin_before_stim_mean =  NaN;
        proj.bin_before_stim_std =  NaN;
    else
        proj.mean =  nanmean(proj.proj,1);
        proj.bin_before_stim_mean =  mean(nanmean(proj.proj(:,tidx),1));
        proj.bin_before_stim_std =  std(nanmean(proj.proj(:,tidx),1));
    end