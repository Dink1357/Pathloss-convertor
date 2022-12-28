%%%%% Converts linkloss and environment data from WinProp v.13 to a format suitable
%%%%% for further matlab investigation %%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% This also converts for HetNets: MC + LPN 
%%%%% Author: Dinkisa A.  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

number_cells=40;  % number of cell

for cell_counter=1:number_cells
   
        filename=['cell_' num2str(cell_counter) '_pathloss.txt'];
    if cell_counter <= 12
        temp=importdata(filename,' ', 16);%for directional site data-include pattern path, horizontal &vertical gain angles
    else
        temp=importdata(filename,' ', 13);%for omni-directional site data
    end
    
    %lossD.totloss=temp.data;
    fid=fopen(filename);
    header1=textscan(fid,' %s %s  %d %s  %d%c',1);
    header2=textscan(fid,' %s %f %f %f',1);
    lossD.tx_location=[header2{2}, header2{3}]; %location of the transmitter [x, y]
    lossD.tx_height=header2{4};                 %height of the transmitter
    header3=textscan(fid,' %s %f',1);
    lossD.frequency=header3{2};                %frequency for the link loss computation
    header4=textscan(fid,' %s %f %s %s',1);
    lossD.tx_power=header4{2};     %transmission power of the transmitter
    header5=textscan(fid,' %s %s',1);
    if cell_counter <= 12
        header6=textscan(fid,' %s %q',1);
        header6_1=textscan(fid,' %s %f',1);         %this will be there only if we have directional antenna:horizontal max. gain angle
        lossD.HMG=header6_1{2};
        header6_2=textscan(fid,' %s %f',1);         %this will be there only if we have directional antenna:vertical max. gain angle
        lossD.VMG=header6_2{2};
    end
    header7=textscan(fid,' %s %f %f',1);
    header8=textscan(fid,' %s %f %f',1);
    lossD.area=[header7{2}, header8{2}, header7{3},header8{3}];
    header9=textscan(fid,' %s %f',1);
    lossD.prediction_height=header9{2};   %height of the points for link loss computation.
    %
    header12=textscan(fid,' %s %f',1); %time-step and not used here -- new WinProp from Altair
    %
    header10=textscan(fid,' %s %f',1);
    lossD.resolution=header10{2}; %resolution of the computation area
    header11=textscan(fid,' %s %f',1);
    
    %formatted pathloss data
    lossD.totloss = PLformat( temp.data,lossD.resolution, lossD.area,-99999 );%temp.data
    ans=fclose(fid);
   
    lossD.number_cells=number_cells;
    lossD.LPN = 28;%number of lTE small cells
    kilo45_lossData(cell_counter)=lossD;
end

save('D:/Matlab_Simulations/Mtool/UDS/PropName_03/kilo45_lossDataEx1.mat', 'kilo45_lossData');
clear lossD header1 header2 header3 header4 header5 header6_1 header6_2 header7 header8 header9 header10 header11 fid temp ans cell_counter filename number_cell;


