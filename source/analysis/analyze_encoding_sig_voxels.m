%% Load in path data
load('proj.mat');

%% Initialize log section
logger(['************************************************'],proj.path.logfile);
logger([' Compare CTER Encoding to INCA and HR (Sig. Voxels) '],proj.path.logfile);
logger(['************************************************'],proj.path.logfile);

try

    %% Load encoding
    Nperm = proj.param.haufe.Npermute;

    % CTER valence
    cter_v_nii = load_untouch_nii([proj.path.haufe.cter,'mu_perm_haufe_v_N=',num2str(Nperm),'_05.nii']);
    cter_v_img = vec_img_2d_nii(cter_v_nii);
    ids_cter_v_img = find(abs(cter_v_img)>0);
    logger(['CTER v voxels, n=',num2str(numel(ids_cter_v_img))],proj.path.logfile);

    % CTER arousal
    cter_a_nii = load_untouch_nii([proj.path.haufe.cter,'mu_perm_haufe_a_N=',num2str(Nperm),'_05.nii']);
    cter_a_img = vec_img_2d_nii(cter_a_nii);
    ids_cter_a_img = find(abs(cter_a_img)>0);
    logger(['CTER a voxels, n=',num2str(numel(ids_cter_a_img))],proj.path.logfile);

    % HR (valence validation via HR)
    hr_nii = load_untouch_nii([proj.path.haufe.hr,'mu_perm_haufe_v_N=',num2str(Nperm),'_05.nii']);
    hr_img = vec_img_2d_nii(hr_nii);
    ids_hr_img = find(abs(hr_img)>0);
    logger(['HR v voxels, n=',num2str(numel(ids_hr_img))],proj.path.logfile);

    % INCA (arousal validation)
    inca_nii = load_untouch_nii([proj.path.haufe.inca,'mu_perm_haufe_a_N=',num2str(Nperm),'_05.nii']);
    inca_img = vec_img_2d_nii(inca_nii);
    ids_inca_img = find(abs(inca_img)>0);
    logger(['INCA a voxels, n=',num2str(numel(ids_inca_img))],proj.path.logfile);

    logger(' ',proj.path.logfile);

    %% ------------------------------------------------------------
    %% Compare CTER to HR (valence validation)
    %% ------------------------------------------------------------

    %% Find joint space
    ids_cter_hr_img = intersect(ids_hr_img,ids_cter_v_img);
    logger(['VAL Joint voxels, n=',num2str(numel(ids_cter_hr_img))],proj.path.logfile);

    %% Variables
    m_hr = double(hr_img(ids_cter_hr_img));
    m_cter = double(cter_v_img(ids_cter_hr_img));

    %%  Primary Test: 
    tbl = table(m_hr,m_cter,'VariableNames',{'trg','pred'});    
    mdl_fe = fitlme(tbl,['trg ~ 1 + pred']);
    mdl = mdl_fe;
    logger(' ',proj.path.logfile);

    save([proj.path.analysis.cmp,'hr_cter_sig_vox_mdl.mat'],'mdl');

    out_tbl = table(m_hr,m_cter,'VariableNames',{'hr','cter'});    
    writetable(out_tbl,'supp_fig_1_C_all_voxels.txt','Delimiter','\t');



    
    %% Examine Main Effect
    [~,~,FE] = fixedEffects(mdl);
    if(FE.pValue(2)<0.05)
        logger('Fixed Effects are significant',proj.path.logfile);
        logger(['  FE(1)=',num2str(FE.Estimate(1))],proj.path.logfile);
        logger(['     p=',num2str(FE.pValue(1))],proj.path.logfile);
        logger(['  FE(2)=',num2str(FE.Estimate(2))],proj.path.logfile);
        logger(['     p=',num2str(FE.pValue(2))],proj.path.logfile);
    else
        logger('Fixed Effects are **NOT** significant',proj.path.logfile);
        logger(['  FE(1)=',num2str(FE.Estimate(1))],proj.path.logfile);
        logger(['     p=',num2str(FE.pValue(1))],proj.path.logfile);
        logger(['  FE(2)=',num2str(FE.Estimate(2))],proj.path.logfile);
        logger(['     p=',num2str(FE.pValue(2))],proj.path.logfile);
    end
    
    %% Effect size
    Rsqr = mdl.Rsquared.Ordinary;
    Fsqr = Rsqr/(1-Rsqr);
    logger(['  All Rsqr=',num2str(Rsqr)],proj.path.logfile);
    logger(['  Fsqr=',num2str(Fsqr)],proj.path.logfile);
    logger(' ',proj.path.logfile);
    
    figure(1)
    set(gcf,'color','w');
    scatter(m_cter,m_hr,10,'MarkerFaceColor', ...
            proj.param.plot.white,'MarkerEdgeColor', ...
            proj.param.plot.dark_grey);
    hold on;

    xseq = linspace(min(m_cter),max(m_cter));
    plot(xseq,xseq*FE.Estimate(2)+FE.Estimate(1),'r-','LineWidth',3);

    xlim([min(m_cter)-0.5,max(m_cter)+0.5])

    hold off;
    fig = gcf;
    ax = fig.CurrentAxes;
    ax.FontSize = proj.param.plot.axisLabelFontSize;
    
    xlabel('Valence Encoding (CTER)');
    ylabel('Valence Encoding (Wilson et al., 2020)');

    export_fig 'CTER_HR_encoding_v_sig_cmp.png' -r300  
    eval(['! mv ',proj.path.code,'CTER_HR_encoding_v_sig_cmp.png ',proj.path.fig]);
 
    %% ------------------------------------------------------------
    %% Compare CTER to INCA (arousal validation)
    %% ------------------------------------------------------------

    %% Find joint space
    ids_cter_inca_img = intersect(ids_inca_img,ids_cter_a_img);
    logger(['ARO Joint voxels, n=',num2str(numel(ids_cter_inca_img))],proj.path.logfile);

    %% Variables
    m_inca = double(inca_img(ids_cter_inca_img));
    m_cter = double(cter_a_img(ids_cter_inca_img));

    %%  Primary Test: 
    tbl = table(m_inca,m_cter,'VariableNames',{'trg','pred'});    
    mdl_fe = fitlme(tbl,['trg ~ 1 + pred']);
    mdl = mdl_fe;
    logger(' ',proj.path.logfile);

    save([proj.path.analysis.cmp,'inca_cter_sig_vox_mdl.mat'],'mdl');

    out_tbl = table(m_inca,m_cter,'VariableNames',{'inca','cter'});    
    writetable(out_tbl,'supp_fig_1_D_all_voxels.txt','Delimiter','\t');

    
    %% Examine Main Effect
    [~,~,FE] = fixedEffects(mdl);
    if(FE.pValue(2)<0.05)
        logger('Fixed Effects are significant',proj.path.logfile);
        logger(['  FE(1)=',num2str(FE.Estimate(1))],proj.path.logfile);
        logger(['     p=',num2str(FE.pValue(1))],proj.path.logfile);
        logger(['  FE(2)=',num2str(FE.Estimate(2))],proj.path.logfile);
        logger(['     p=',num2str(FE.pValue(2))],proj.path.logfile);
    else
        logger('Fixed Effects are **NOT** significant',proj.path.logfile);
        logger(['  FE(1)=',num2str(FE.Estimate(1))],proj.path.logfile);
        logger(['     p=',num2str(FE.pValue(1))],proj.path.logfile);
        logger(['  FE(2)=',num2str(FE.Estimate(2))],proj.path.logfile);
        logger(['     p=',num2str(FE.pValue(2))],proj.path.logfile);
    end
    
    %% Effect size
    Rsqr = mdl.Rsquared.Ordinary;
    Fsqr = Rsqr/(1-Rsqr);
    logger(['  All Rsqr=',num2str(Rsqr)],proj.path.logfile);
    logger(['  Fsqr=',num2str(Fsqr)],proj.path.logfile);
    logger(' ',proj.path.logfile);
    
    figure(2)
    set(gcf,'color','w');
    scatter(m_cter,m_inca,10,'MarkerFaceColor', ...
            proj.param.plot.white,'MarkerEdgeColor', ...
            proj.param.plot.dark_grey);
    hold on;

    xseq = linspace(min(m_cter),max(m_cter));
    plot(xseq,xseq*FE.Estimate(2)+FE.Estimate(1),'r-','LineWidth',3);

    xlim([min(m_cter)-0.5,max(m_cter)+0.5])

    hold off;
    fig = gcf;
    ax = fig.CurrentAxes;
    ax.FontSize = proj.param.plot.axisLabelFontSize;
    
    xlabel('Arousal Encoding (CTER)');
    ylabel('Arousal Encoding (Bush et al., 2018)');

    export_fig 'CTER_INCA_encoding_a_sig_cmp.png' -r300  
    eval(['! mv ',proj.path.code,'CTER_INCA_encoding_a_sig_cmp.png ',proj.path.fig]);

catch
    logger(['  -Encoding Load Error'],proj.path.logfile);
end
