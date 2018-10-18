function relSignif = fn_fetch_significant_cells(key)


if strcmp(key.lick_direction,'all')
    rel1= (ANL.UnitTongue1DTuning *ANL.UnitTongue1DTuningSignificanceGo & key   & 'number_of_trials>100' & 'total_number_of_spikes_window>100' & 'pvalue_si_1d<=0.05' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
elseif strcmp(key.lick_direction,'left')
    rel1= (ANL.UnitTongue1DTuning *ANL.UnitTongue1DTuningSignificanceGo & key    & 'number_of_trials>50' & 'total_number_of_spikes_window>50' & 'pvalue_si_1d<=0.05' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
elseif strcmp(key.lick_direction,'right')
    rel1= (ANL.UnitTongue1DTuning *ANL.UnitTongue1DTuningSignificanceGo & key    & 'number_of_trials>50' & 'total_number_of_spikes_window>50' & 'pvalue_si_1d<=0.05' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
end
relSignif=(EPHYS.Unit & 'unit_quality!="multi"') & rel1;
