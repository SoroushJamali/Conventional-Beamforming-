clc; clear; close all;

%% Initialization

fc = 28e9; % carrier frequency

c = physconst('LightSpeed'); % lightSpeed

lambda = c/fc; % wavelength

antennaArrangement = [2 8]; % two rows of eight antennas

l=prod(antennaArrangement); % number of elements

angularResolutionOfOurAntenna = 64 ; % 64 diffrent angel points, depends on your antenna

lookDirection = 108; % our antenna look direction is between [-54 54]

angularResolution = lookDirection/angularResolutionOfOurAntenna ; % 1.6875 is  each degree step

sv=zeros(l,angularResolutionOfOurAntenna); % building empty space for steering vector

bf_codebook=zeros(angularResolutionOfOurAntenna,1);

w_out=zeros(prod(antennaArrangement),angularResolutionOfOurAntenna);

quantized=zeros(prod(antennaArrangement),angularResolutionOfOurAntenna);

w_angle=zeros(prod(antennaArrangement),angularResolutionOfOurAntenna);

test=phased.URA( antennaArrangement ,0.5*lambda); % using phased.URA to position the antennas considering half of the wavelength

pos=getElementPosition(test); % here we pass the positions to getElementPosition and receive the dimension in #D coordinates first row X, 2nd row for Y, and 3rd for Z

for i=1:angularResolutionOfOurAntenna

    degree=i*angularResolution-lookDirection/2;
    sv(:,i) = steervec(pos/lambda,(degree)); %example Azim 30° elev 10°

end


%% Implementing BF

for i=1:angularResolutionOfOurAntenna

    [w,bf_out]= conv_BF(l,sv(:,i));
    bf_codebook(i)=bf_out;
    w_out(:,i)=w;
    w_angle(:,i)=rad2deg(angle(w)); %% step 3-atan2(img(bf_codebook(1)),real(bf_codebook(1)))  phase angle
    [index,quantized(:,i)] = quantize_beams(w_angle(:,i)); %%quantizing- step 4
    index;

end

quantizedShift=quantized;
quantizedShift(2,:)=quantized(2,:)-90;
quantizedShift(5,:)=quantized(5,:)-180;
quantizedShift(6,:)=quantized(6,:)+90;
quantizedShift(8,:)=quantized(8,:)-90;
quantizedShift(9,:)=quantized(9,:)-90;
quantizedShift(11,:)=quantized(11,:)+90;
quantizedShift(12,:)=quantized(12,:)-90;
quantizedShift(14,:)=quantized(14,:)+90;
quantizedShift(15,:)=quantized(15,:)-90;
quantizedShift(16,:)=quantized(16,:)+90;

temp_mat=quantizedShift;

map_vect=[16,15,14,13,12,11,10,9,7,8,5,6,3,4,1,2];

for i=1:prod(antennaArrangement)

    quantizedShift(i,:)=temp_mat(map_vect(i),:);

end

quantized_shift=deg2rad(quantizedShift-2);
%% Step 5,6

w_quant=cos(quantized_shift)+1i*sin(quantized_shift);

writematrix(w_quant,'temp.csv');

%% Array patterns
figure,

pattern(test,fc,'Weights',w_out(:,33),...  % fig3
    'CoordinateSystem','polar','EL',0);
hold on

pattern(test,fc,'Weights',w_quant(:,33),...  % fig3
    'CoordinateSystem','polar','EL',0);
%legend('Ideal','quantized')

[pat,az,el]=pattern(test,fc,'Weights',w_out(:,33),...  % fig3
    'CoordinateSystem','polar','EL',0);

[value,index]=max(pat);

beam_dir=az(index);

%% Function
function [index,quantized] = quantize_beams(an)
%this function quantize the sample.
step=11.25;
partition =(-180+(step/2):step:180);
quantized_out=(-180+(step/2):step:180+(step/2));

[index,quantized] = quantiz(an,partition,quantized_out);

end

function [w,bf_out] = conv_BF(l,sv)

%this function give weghts to the steering vectors.
w=sv/l; %array weights of the conventional beam former 
w_h=w';
bf_out=w_h*w;

end

