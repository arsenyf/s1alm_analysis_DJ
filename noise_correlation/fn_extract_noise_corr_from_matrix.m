function [pairwise_corr,pairwise_cov]= fn_extract_noise_corr_from_matrix(key, k)
rel1=(ANL.NoiseCorrelation2 * EXP.SessionID *  EXP.SessionTraining * ANL.SessionPosition) & key & k;

corr_matrix = [fetchn(rel1, 'corr_matrix')];
cov_matrix = [fetchn(rel1, 'cov_matrix')];

pairwise_corr=[];
pairwise_cov=[];

for i=1:1:numel(corr_matrix)
    temp_m=corr_matrix{i};
    diagonal_idx = find(temp_m==diag(temp_m));
    temp_m(diagonal_idx)=NaN;
    temp_m=tril(temp_m);
    temp_m=temp_m(:);
    temp_m(temp_m==0)=NaN;
    temp_m(isnan(temp_m))=[];
    pairwise_corr = [pairwise_corr;temp_m];
    
    temp_m=cov_matrix{i};
    temp_m(diagonal_idx)=NaN;
    temp_m=tril(temp_m);
    temp_m=temp_m(:);
    temp_m(temp_m==0)=NaN;
    temp_m(isnan(temp_m))=[];
    pairwise_cov = [pairwise_cov;temp_m];
end

h=histogram(pairwise_corr,[-0.1:0.01:0.1])
m=mean(pairwise_corr);
title(sprintf('%s %s \n%s %s cells \n mean r = %.3f',k.outcome, k.time_interval_correlation_description, key.brain_area,key.cell_type,m))
xlabel('Pairwise correlations');
ylabel('Count');
ylim([0 max(h.Values)]);