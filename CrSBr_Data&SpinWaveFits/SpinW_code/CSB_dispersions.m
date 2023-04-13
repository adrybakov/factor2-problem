csb = spinw;
csb.genlattice('lat_const',[3.5126 4.7457 7.9171],'angled',[90 90 90],'sym','P m m n');
csb.addatom('label','Cr3+','r',[1/4 3/4 0.37193],'S',3/2,'color','gray');
csb.gencoupling('maxDistance',10)

csb2 = spinw;
csb2.genlattice('lat_const',[3.5126 4.7457 7.9171],'angled',[90 90 90],'sym','P m m n');
csb2.addatom('label','Cr3+','r',[1/4 3/4 0.37193],'S',3/2,'color','gray');
csb2.gencoupling('maxDistance',10)
%csb.table('bond')

Jfile = readtable('SliceInfo/OptimizedJ_8.txt');
% Loop through and assign J values
for i = 1:height(Jfile)
    csb.addmatrix('value',table2array(Jfile(i,2)),'label',table2array(Jfile(i,1)))
    csb.addcoupling('mat',table2array(Jfile(i,1)),'bond',i)
    csb2.addmatrix('value',table2array(Jfile(i,2)),'label',table2array(Jfile(i,1)))
    csb2.addcoupling('mat',table2array(Jfile(i,1)),'bond',i)
end

% anisotropy
csb.addmatrix('value',diag([0.0013 -0.0076 0.0]),'label','Aniso')
csb.addaniso('Aniso')
csb2.addmatrix('value',diag([0.0013 -0.0076 0.0]),'label','Aniso')
csb2.addaniso('Aniso')

% DM exchang
csb.addmatrix('label','DM1','value',1,'color','b')
csb.addcoupling('mat','DM1','bond',1)
csb.setmatrix('mat','DM1','pref',{[0.867 0 0]});
%csb.setmatrix('mat','DM1','pref',{[0.4372 0 0]});

%csb.addmatrix('label','DM2','value',2,'color','b')
%csb.addcoupling('mat','DM2','bond',3)
%csb.setmatrix('mat','DM2','pref',{[3 0 0]});


csb.genmagstr('mode','direct','S',[0 0; 1 1; 0 0],'n',[0 0 1],'k',[0,0,1/2]);
csb2.genmagstr('mode','direct','S',[0 0; 1 1; 0 0],'n',[0 0 1],'k',[0,0,1/2]);

csb.table('mat')
plot(csb,'range',[4 2 2])
swplot.zoom(1.2)

%
%% Spinwave spectrum
%

%csbSpec = csb.spinwave({[1 -1 0] [1 1 0] [-1 1 0] [0 0 0] 50}, 'hermit',false,'formfact',true);
% csbSpec = csb.spinwave({[-2 0 0] [0 2 0] 100}, 'hermit',false);
figure('position',[20 20 1100 900])

j = 1
for i=0:0.25:1
    %QQ = {[-2 i 0] [2 i 0] 300}
    QQ = {[i -2 0.5] [i 2 0.5] 300};
    
    csbSpec = csb.spinwave(QQ, 'hermit',false);
    subplot(5,2,2*j-1)
    csbSpec = sw_neutron(csbSpec);
    %sw_plotspec(csbSpec,'axLim',[0 50],'mode','disp','colorbar',false)
    csbSpec = sw_egrid(csbSpec,'Evect',linspace(0,60,240),'component','Sperp');
    sw_plotspec(csbSpec,'axLim',[0 50],'mode',3,'dE',2,'colorbar',false,'legend',false)
    
    csbSpec2 = csb2.spinwave(QQ, 'hermit',false);
    subplot(5,2,2*j)
    csbSpec2 = sw_neutron(csbSpec2);
    %sw_plotspec(csbSpec2,'axLim',[0 50],'mode','disp','colorbar',false)
    csbSpec2 = sw_egrid(csbSpec2,'Evect',linspace(0,60,240),'component','Sperp');
    sw_plotspec(csbSpec2,'axLim',[0 50],'mode',3,'dE',2,'colorbar',false,'legend',false)
    
    j = j+1
end

%csbSpec = sw_egrid(csbSpec,'Evect',linspace(0,50,240),'component','Sperp');
%sw_plotspec(csbSpec,'axLim',[0 50],'mode',3,'dE',1,'colorbar',false,'legend',false);


%%
% Save

QQ = {[0.75 0 0.5] [0.75 3 0.5] 300};

csbSpec = csb.spinwave(QQ,'formfact',true)
csbSpec = sw_neutron(csbSpec);
csbSpec = sw_egrid(csbSpec,'Evect',linspace(0,60,240),'component','Sperp');

% Save results to file
SpinWaveOutFile = 'CalculatedSlices/0p75K0_slice_withDM.txt'
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




csbSpec = csb2.spinwave(QQ,'formfact',true)
csbSpec = sw_neutron(csbSpec);
csbSpec = sw_egrid(csbSpec,'Evect',linspace(0,60,240),'component','Sperp');

% Save results to file
SpinWaveOutFile = 'CalculatedSlices/0p75K0_slice_withoutDM.txt'
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


