function PsthPlot(duration, channel_plot, norm_spikes_per_trial, psth_fig_handle, subhandle, xy, x_sel, y_sel,  v_sel, o_sel, vo_cond)
	
% Histogram plot. Feb 9, 2015, Astra S. Bryant
%REALLY IMPORTANT: if this program is run in R2014b, histc may not work.
%replace with histcounts

%% Get data into plottable formation
binvals={[0:(duration/80):duration]};
binwidth=duration/80;
histbins=repmat(binvals, 1, size(norm_spikes_per_trial,2));

bincounts = cellfun(@histc, norm_spikes_per_trial, histbins, 'UniformOutput',false)';
for x=1:size(bincounts,1)
	if isempty (bincounts{x})
		bincounts{x}=zeros(1,size(binvals{1},2));
		
	end
end
bincounts = cell2mat(bincounts); %array with trials by binvals

%sumcounts = sum(bincounts,1);

%Separate into V_val and O_val conditions


%Separate into Y_val condition
[B,~,J] = unique(xy, 'rows'); % J contains indices that group by stimulus paramaters
ind=J(1:size(bincounts,1));
for x=1:size(B, 1)
 sumcounts(x,:)= mean(bincounts(find(ind==x),:),1);
end

%% Plotting
if vo_cond(1)<1
	vis_stat='No Vis Stim';
else
	vis_stat='Vis Stim On';
end
if vo_cond(2)<1
	opto_stat='No Opto Light';
else
	opto_stat='Opto Light On';
end
figure(psth_fig_handle)

 set(psth_fig_handle, 'Name',sprintf('Channel %d, %s, %s',channel_plot,vis_stat, opto_stat),'NumberTitle','off');
 suptitle(sprintf('Channel %d, %s, %s',channel_plot,vis_stat, opto_stat));
for x=1:size(B,1)
	hold off
	subplot(subhandle{x})
	bar(subhandle{x},binvals{1}, sumcounts(x,:), 'FaceColor', [.25, .25, .25]);
	hold on
	%axis tight;
	axis manual
	ylim([0 ceil(max(max(sumcounts)))]);
	xlim([-0.016 .8160]);
	plot([0.15 0.15], ylim, 'r');
	plot([0.15+(duration-.3) 0.15+(duration-.3)], ylim, 'r');
	%bar(binvals{1}, bincounts', 'stacked');
	%colormap(summer);
	

	%h=title( sprintf('%s : %.2g',y_sel,B(x)), 'FontSize', 12); %scientific
	%notation version of titles.
	h=title(strcat(y_sel,{': '},num2str(B(x))), 'FontSize', 10);
	set(h, 'interpreter','none') %removes tex interpretation rules
	xticklabels=num2str((str2num(get(subhandle{x}, 'XTickLabel')).*1000));
	set(subhandle{x},'XTickLabel',xticklabels, 'fontsize',8);
	xlabel('Time (ms)', 'FontSize', 8);
	ylabel('Spikes/Trial', 'FontSize', 8);

end




end
