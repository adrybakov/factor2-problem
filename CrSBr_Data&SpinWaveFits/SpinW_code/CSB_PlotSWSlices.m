csb = spinw;
csb.genlattice('lat_const',[3.5126 4.7457 7.9171],'angled',[90 90 90],'sym','P m m n');
csb.addatom('label','Cr3+','r',[1/4 3/4 0.37193],'S',3/2,'color','gray');
csb.gencoupling('maxDistance',10)
%gd.table('bond')

Jfile = readtable('SliceInfo/OptimizedJ_8.txt');
% Loop through and assign J values
for i = 1:height(Jfile)
    csb.addmatrix('value',table2array(Jfile(i,2)),'label',table2array(Jfile(i,1)))
    csb.addcoupling('mat',table2array(Jfile(i,1)),'bond',i)
end

%Add single ion anisotropy
csb.addmatrix('value',diag([0.0013 -0.0076 0.0]),'label','Aniso')
csb.addaniso('Aniso')

%%

csb.genmagstr('mode','direct','S',[0 0; 1 1; 0 0],'n',[0 0 1],'k',[0,0,1/2]);
%csb.genmagstr('mode','random','nExt',[1,1,2])
%csb.optmagstr()
%csb.optmagsteep('nRun',400)

plot(csb,'range',[4 2 2])
swplot.zoom(1.2)

%%

FileCutLimits = readtable('SliceInfo/FileCutLimits.txt');
filenames = table2array(FileCutLimits(:,1));
StartingQ = table2array(FileCutLimits(:,2:4));
EndingQ = table2array(FileCutLimits(:,5:7));


%%
for i = 1:size(filenames)
    Q = {StartingQ(i,:) EndingQ(i,:) 400}
    %if i == 58
    %    Q = {[0.6 0 0] [0.6 0 4] 200}
    %end
    % Add 0.5 to the c axis
    Q{1}(3) = 0.5
    Q{2}(3) = 0.5
    
    %csb.genmagstr('mode','direct','S',[0 0; 1 1; 0 0],'n',[0 0 1],'k',[0,0,1/2]);
    csbSpec = csb.spinwave(Q,'formfact',true)
    csbSpec = sw_neutron(csbSpec);
    csbSpec = sw_egrid(csbSpec,'Evect',linspace(0,60,500),'component','Sperp');
        
    % Save results to file
    fnm = sprintf('%s_calculated.txt',char(filenames(i)))
    SpinWaveOutFile = fullfile('CalculatedSlices',fnm)
    fid = fopen(SpinWaveOutFile, 'wt');
    fprintf(fid, '# Calculated spin wave spectrum for fitted CrSBr parameters\n');
    fprintf(fid, '# Allen Scheie, Jan 2022\n\n');
    fclose(fid);
    
    % Save results to file 
    fid = fopen(SpinWaveOutFile, 'at');
    fprintf(fid, '# hkl\n');
    fclose(fid);
    dlmwrite(SpinWaveOutFile, csbSpec.hkl,'delimiter',',','-append');
    fid = fopen(SpinWaveOutFile, 'at');
    fprintf(fid, '# omega\n');
    fclose(fid);
    dlmwrite(SpinWaveOutFile, csbSpec.omega,'delimiter',',','-append');
    fid = fopen(SpinWaveOutFile, 'at');
    fprintf(fid, '# Evect\n');
    fclose(fid);
    dlmwrite(SpinWaveOutFile, csbSpec.Evect,'delimiter',',','-append');
    fid = fopen(SpinWaveOutFile, 'at');
    fprintf(fid, '# swConv\n');
    fclose(fid);
    dlmwrite(SpinWaveOutFile, real(csbSpec.swConv),'delimiter',',','-append');
    fid = fopen(SpinWaveOutFile, 'at');
    fprintf(fid, '\n');
    fclose(fid);
    
end

