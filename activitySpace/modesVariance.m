function modesVariance(dim, psth, tt, time,  nums, tint)

Nsessions = numel(psth);

ix1 = find(time>tint(1), 1, 'first');
ix2 = find(time>tint(2), 1, 'first');

U = 1;

varExplained = cell(Nsessions, 1);
residual     = cell(Nsessions, 1);
meanRate     = cell(Nsessions, 1);
projection   = cell(Nsessions, 1);
allmodes     = cell(Nsessions, 1);
for i = 1:Nsessions
    
    fnames = fieldnames(tt{i});
    for j = 1:numel(fnames)
        eval([fnames{j} ' = tt{i}.' fnames{j} ';']);
    end
    
    Nunits = size(psth{i}, 2);
    Ntypes = numel(trialtypenames);
    
    units = U:U+Nunits-1;
    
    avgpsth = getAvgPSTHbyTrialType(psth{i}, tt{i}, '~lickearly&hit');
    avgpsth = avgpsth(ix1:ix2, :, :);
    
    
%     tmppsth(:,:,1) = mean(avgpsth(:, :, 1:5), 3);
%     tmppsth(:,:,2) = mean(avgpsth(:, :, 6:10), 3);    
%     avgpsth = tmppsth;
%     Ntypes = 2;
%     
    tmppsth(:,:,1) = mean(avgpsth(:, :, 1:5), 3) - mean(avgpsth(:, :, 6:10), 3);
    tmppsth(:,:,2) = 0;
    avgpsth = tmppsth;
    Ntypes = 2;
    
    
    Ntpts = size(avgpsth, 1);
    
    
    meanRate{i} = zeros(1, Nunits);
    for j = 1:Nunits
        tmp = squeeze(avgpsth(:, j, :));
        meanRate{i}(j) = nanmean(tmp(:));
        tmp = tmp - meanRate{i}(j);
        avgpsth(:, j,:) = tmp;

    end
    avgpsth(isnan(avgpsth)) = 0;
    
    residual{i} = avgpsth;
    
%     unitToShow = 14;
    for j = 1:numel(nums)
        vec = dim(nums(j)).vec(units);
        vec(isnan(vec)) = 0;
        
        tr = zeros(Ntpts, Ntypes);
        for k = 1:size(residual{i}, 3)
            tr(:, k) = vec*squeeze(residual{i}(:,:,k))';
        end
        dat = reshape(permute(residual{i}, [1 3 2]), Ntpts*Ntypes, Nunits);
        
%         hold on; plot(dat(:, unitToShow));
%         var(dat(:,unitToShow))
        
        mode = tr(:);
%         allmodes{i} = mode;
        modenorm = norm(mode);
        mode = mode./modenorm;
        
        projection{i} = zeros(numel(mode), Nunits);
        residual{i} = zeros(size(dat));
        for k = 1:Nunits
            projection{i}(:, k) = dot(dat(:,k),mode)*mode;
            residual{i}(:, k) = dat(:,k)-projection{i}(:, k);
        end
        
        varExplained{i} = 1 - var(residual{i}, [], 1)./var(reshape(permute(avgpsth, [1 3 2]), Ntpts*Ntypes, Nunits), [], 1);
        
        mean(varExplained{i})
       
        
        projection{i} = permute(reshape(projection{i}, Ntpts, Ntypes, Nunits), [1 3 2]);
        residual{i}   = permute(reshape(residual{i}, Ntpts, Ntypes, Nunits), [1 3 2]);
        allmodes{i}(:,:,j)   = reshape(mode*modenorm, Ntpts, Ntypes);
        
        
    end
    
    
    
%     a = reshape(permute(residual{i}, [1 3 2]), Ntpts*Ntypes, Nunits);
%      hold on; plot(a(:, unitToShow));
     
%      figure; hold on;
%      for j = 1:numel(nums)
%          plot(reshape(allmodes{i}(:,:,j), Ntpts*Ntypes, 1))
%      end
residual{i} = avgpsth;
dat = reshape(permute(residual{i}, [1 3 2]), Ntpts*Ntypes, Nunits);
    [coeff, score, latent] = pca(dat);
    U = U+Nunits;
end