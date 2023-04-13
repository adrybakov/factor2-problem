
aa = [1 1 0];
bb = [1 1 0];
cc = [0 1 1];

%for jj = 1:length(aa)
jj=3;
a = aa(jj)
b = bb(jj)
c = cc(jj)

csb = spinw;
csb.genlattice('lat_const',[3.5126 4.7457 7.9171],'angled',[90 90 90],'sym','P m m n');
csb.addatom('label','Cr3+','r',[1/4 3/4 0.37193],'S',3/2,'color','gray');
csb.gencoupling('maxDistance',10)


Jfile = readtable('SliceInfo/OptimizedJ_8.txt');
% Loop through and assign J values
for i = 1:height(Jfile)
    csb.addmatrix('value',table2array(Jfile(i,2)),'label',table2array(Jfile(i,1)))
    csb.addcoupling('mat',table2array(Jfile(i,1)),'bond',i)
end

%Add single ion anisotropy
csb.addmatrix('value',diag([0.0013 -0.0076 0.0]),'label','Aniso')
csb.addaniso('Aniso')

numunitcells = 5
csb.genmagstr('mode','direct','S',repmat([0 0; 1 1; 0 0], 1,numunitcells),'n',[0 0 1],'k',[0,0,1/2],'nExt',[1,1,numunitcells]);

csb.table('mat')

csbSpec = csb.spinwave({[-1 -1 0] [1 -1 0] [1 1 0] [0 0 0] 60});

figure
sw_plotspec(csbSpec,'mode',1,'colorbar',false,'colormap',[0,0,100], 'axLim',[0, 50]);




%%  Big unit cell, no periodic boundary along C

csb = spinw;

numunitcells = 4 %12

csb.genlattice('lat_const',[3.5126 4.7457 7.9171*(numunitcells+4)],'angled',[90 90 90],'sym',1);
for i = 1:numunitcells
   csb.addatom('label','Cr3+','r',[1/4 3/4 (0.37193+i)/(numunitcells+4)],'S',3/2,'color','gray');
   csb.addatom('label','Cr3+','r',[3/4 1/4 (1-0.37193+i)/(numunitcells+4)],'S',3/2,'color','gray');
end
csb.gencoupling('maxDistance',11)
csb.table('bond')

%

Jfile = readtable('/CrSBr/SliceInfo/OptimizedJ_8.txt');

n = numunitcells;
maxjs = [0 n*2 n*4 n*2 n*4 n*4 ...  %0-5
         n*4-4 n*2 n*4 ]   %

for i = 1:height(Jfile)
    for j = 1:maxjs(i+1)
        csb.addmatrix('value',table2array(Jfile(i,2)),'label',table2array(Jfile(i,1)))
        csb.addcoupling('mat',table2array(Jfile(i,1)),'bond',sum(maxjs(1:i))+j)
    end
end



%

% DMV = 0.0364  %0.0365
% for j = 1:maxjs(2+1)
%     jv = sum(maxjs(1:2))+j;
%     dl = gd.coupling.dl(1:3,jv);
%     mf = (-1)^rem(gd.coupling.atom1(jv),2);
%     
%     if dl == [1; 1; 0]
%         mf = mf*(-1);
%     end
%     if mf == 1
%         DMV*double(mf)
%         gd.addmatrix('value',[0 DMV*double(mf) 0; DMV*double(-mf) 0 0; 0 0 0],'label','DM2','color','blue')
%         gd.addcoupling('mat','DM2','bond',jv)
%     else
%         gd.addmatrix('value',[0 DMV*double(mf) 0; DMV*double(-mf) 0 0; 0 0 0],'label','DM1','color','blue')
%         gd.addcoupling('mat','DM1','bond',jv) 
%     end
% 
% end

%plot(gd,'range',[-2.5 2.5;-2.5 2.5;0 1.0])


csb.genmagstr('mode','direct','S', repmat([0 0 0 0; 1 1 -1 -1; 0 0 0 0], 1, numunitcells/2), ...
                  'n',[0 0 1],'k',[0,0,0]);
csb.table('mat')

plot(csb,'range',[4 2 1])
swplot.zoom(3)

csbSpec = csb.spinwave({[-1 -1 0] [1 -1 0] [1 1 0] [0 0 0] 150},'hermit',false);

figure
sw_plotspec(csbSpec,'mode',1,'colorbar',false,'colormap',[0,0,100], 'axLim',[0, 60]);


% Save


%%  Big unit cell, no periodic boundary along A

csb = spinw;

numunitcells = 6 %12

csb.genlattice('lat_const',[3.5126*(numunitcells+4) 4.7457 7.9171*2],'angled',[90 90 90],'sym',1);
for i = 1:numunitcells
    for j =0:1
       csb.addatom('label','Cr3+','r',[(1/4+i)/(numunitcells+4) 3/4 (0.37193+j)/2],'S',3/2,'color','gray');
       csb.addatom('label','Cr3+','r',[(3/4+i)/(numunitcells+4) 1/4 (1-0.37193+j)/2],'S',3/2,'color','gray');
    end
end
csb.gencoupling('maxDistance',11)
csb.table('bond')

%

Jfile = readtable('SliceInfo/OptimizedJ_8.txt');

n = numunitcells;
maxjs = [0 n*4-4 n*8-4 n*4 n*8-8 n*8-12 ...  %0-5
         n*8-4 n*4-8 n*8-4 ]   %

for i = 1:height(Jfile)
    for j = 1:maxjs(i+1)
        csb.addmatrix('value',table2array(Jfile(i,2)),'label',table2array(Jfile(i,1)))
        csb.addcoupling('mat',table2array(Jfile(i,1)),'bond',sum(maxjs(1:i))+j)
    end
end


%

DMV = 1;
for j = 1:maxjs(1+1)
    jv = sum(maxjs(1:1))+j;
    csb.addmatrix('value',[0 0 -DMV; 0 0 0; DMV 0 0],'label','DM2','color','blue')
    csb.addcoupling('mat','DM2','bond',jv)
end


csb.genmagstr('mode','direct','S', repmat([0 0 0 0; 1 1 -1 -1; 0 0 0 0], 1, numunitcells), ...
                  'n',[0 0 1],'k',[0,0,0]);
csb.table('mat')

plot(csb,'range',[1 3 1])
swplot.zoom(3)

csbSpec = csb.spinwave({[1 -1 0] [1 1 0] 60},'hermit',false);

figure
sw_plotspec(csbSpec,'mode',1,'colorbar',false,'colormap',[0,0,100], 'axLim',[0, 60]);

%% Big cell, periodic boundary conditions

csb = spinw;

csb.genlattice('lat_const',[3.5126*(numunitcells) 4.7457 7.9171*2],'angled',[90 90 90],'sym',1);
for i = 1:numunitcells
    for j =0:1
       csb.addatom('label','Cr3+','r',[(1/4+i)/(numunitcells) 3/4 (0.37193+j)/2],'S',3/2,'color','gray');
       csb.addatom('label','Cr3+','r',[(3/4+i)/(numunitcells) 1/4 (1-0.37193+j)/2],'S',3/2,'color','gray');
    end
end
csb.gencoupling('maxDistance',11)
csb.table('bond')

n = numunitcells;
maxjs = [0 n*4 n*8 n*4 n*8 n*8 ...  %0-5
         n*8 n*4 n*8 ]   %

for i = 1:height(Jfile)
    for j = 1:maxjs(i+1)
        csb.addmatrix('value',table2array(Jfile(i,2)),'label',table2array(Jfile(i,1)))
        csb.addcoupling('mat',table2array(Jfile(i,1)),'bond',sum(maxjs(1:i))+j)
    end
end

for j = 1:maxjs(1+1)
    jv = sum(maxjs(1:1))+j;
    csb.addmatrix('value',[0 0 -DMV; 0 0 0; DMV 0 0],'label','DM2','color','blue')
    csb.addcoupling('mat','DM2','bond',jv)
end

plot(csb,'range',[1 3 1])
swplot.zoom(3)



csb.genmagstr('mode','direct','S', repmat([0 0 0 0; 1 1 -1 -1; 0 0 0 0], 1, numunitcells), ...
                  'n',[0 0 1],'k',[0,0,0]);
csb.table('mat')

plot(csb,'range',[1 3 1])
swplot.zoom(3)

csbSpec = csb.spinwave({[1 -1 0] [1 1 0] 60},'hermit',false);

figure
sw_plotspec(csbSpec,'mode',1,'colorbar',false,'colormap',[0,0,100], 'axLim',[0, 60]);
