cub = spinw;
cub.genlattice('lat_const',[1 1 1],'angled',[90 90 90])
cub.addatom('r', [0 0 0],'S', 1,'label','Ni','color','blue')
cub.plot('range',[1 1 1])

cub.gencoupling('maxDistance',7)

% list the 1st and 2nd neighbor bonds
cub.table('bond',1:1)

cub.addmatrix('value',-eye(3),'label','J','color','green')
cub.addcoupling('mat','J','bond',1);
plot(cub,'range',[2 2 2],'cellMode','none','baseMode','none')

cub.genmagstr('mode','direct', 'k',[0 0 0],'n',[0 0 1],'S',[0; 0; 1]);

disp('Magnetic structure:')
cub.table('mag')
plot(cub,'range',[2 2 2],'baseMode','none','cellMode','none')

cub.energy


Qlist = {[0.5 0 0] [0 0 0] [0 0.5 0] [0.5 0.5 0] [0 0 0] [0.5 0.5 0.5] [0 0.5 0] [0.5 0.5 0] [0.5 0.5 0.5]};
Qlab  = {'Y', '\Gamma', 'X', 'M', '\Gamma', 'R', 'X', 'M', 'R'};


cubspec = cub.spinwave(Qlist,'hermit',true, 'saveH',true);
cubspec = sw_neutron(cubspec);
cubspec = sw_egrid(cubspec,'component','Sperp');

figure;
subplot(1,1,1)
sw_plotspec(cubspec,'mode',1,'colorbar',false,'legend',false, 'dashed',true,'qlabel',Qlab)
yticks([-12 -8 -4 0 4 8 12])
yline([-12 -8 -4 0 4 8 12], "--")

datatxt=fopen('spinw-cub.txt', 'w');
fprintf(datatxt,'%g %g\n', cubspec.omega(:,:));
fclose(datatxt);

datatxt11=fopen('spinw-cub-11.txt', 'w');
fprintf(datatxt11,'%g\n', cubspec.H(1,1,:));
fclose(datatxt11);

datatxt22=fopen('spinw-cub-22.txt', 'w');
fprintf(datatxt22,'%g\n', cubspec.H(2,2,:));
fclose(datatxt22);
