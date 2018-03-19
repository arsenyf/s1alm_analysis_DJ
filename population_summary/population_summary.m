function population_summary()


q1=(EPHYS.Unit & 'unit_quality!="multi"') * (EPHYS.UnitCellType & 'cell_type="Pyr"') * (EXP.SessionTraining & 'training_type="regular + distractor"');
q2=(EPHYS.Unit & 'unit_quality!="multi"') * (EPHYS.UnitCellType & 'cell_type="FS"') * (EXP.SessionTraining & 'training_type="regular + distractor"');

total_cells.labels{1}='ALM left';
total_cells.Pyr(1) = numel(fetch(  q1 * (EPHYS.UnitPosition & 'brain_area="ALM"' & 'hemisphere="left"')  ));
total_cells.FS(1) =  numel(fetch(  q2 * (EPHYS.UnitPosition & 'brain_area="ALM"' & 'hemisphere="left"')  ));

total_cells.labels{2}='ALM right';
total_cells.Pyr(2) = numel(fetch(   q1 * (EPHYS.UnitPosition & 'brain_area="ALM"' & 'hemisphere="right"')  ));
total_cells.FS(2) = numel(fetch(    q2 * (EPHYS.UnitPosition & 'brain_area="ALM"' & 'hemisphere="right"')  ));

total_cells.labels{3}='vS1 left';
total_cells.Pyr(3) = numel(fetch(   q1  * (EPHYS.UnitPosition & 'brain_area="vS1"' & 'hemisphere="left"')  ));
total_cells.FS(3) = numel(fetch(    q2 * (EPHYS.UnitPosition & 'brain_area="vS1"' & 'hemisphere="left"')  ));

peak_fr_basic_trials = fetchn(ANL.UnitFiringRate,'peak_fr_basic_trials');
histogram(peak_fr_basic_trials,[0:0.1:10])

mean_fr = fetchn(ANL.UnitFiringRate,'mean_fr');
histogram(mean_fr,[0:0.1:5])

mean_fr_sample_delay = fetchn(ANL.UnitFiringRate,'mean_fr_sample_delay');
histogram(mean_fr_sample_delay,[0:0.1:5])