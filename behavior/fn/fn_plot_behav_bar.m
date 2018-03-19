function  fn_plot_behav_bar (x, R_trials, L_trials, trial_type_names)
hold on;
bar(R_trials,[x(R_trials).mean], 'FaceColor', [0 0 1])
errorbar_myown( R_trials, [x(R_trials).mean] ,R_trials*0, [x(R_trials).stem], '.b', 0.1 );
bar(L_trials,[x(L_trials).mean], 'FaceColor', [1 0 0])
errorbar_myown( L_trials, [x(L_trials).mean] ,L_trials*0, [x(L_trials).stem], '.r', 0.1 );
xlim([0 numel(trial_type_names)+1]);
set(gca, 'Xtick', 1:numel(trial_type_names), 'XtickLabel', trial_type_names, 'TickLabelInterpreter', 'None', 'FontSize', 12, 'XTickLabelRotation', 90);
box off;

