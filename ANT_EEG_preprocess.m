%Code : Anne-Lise Marais
%Protocol : Marie Anquetil

%This code extracts the data of a single subject of an Eprime version of the Child-ANT
%Then it preprocesses the EEG data
%3 data are extracted : %Accuracy to the stimulation (1 = good answer), %Validity of the cue (1 = valid), %Congruency of the stimulation (1 = congruent)
%3 experimental conditions : Fish, Pig, Tort
%Output is 4 matrices containing the preprocessed EEG data for Valid_Congruent ; Valid_Incongruent ; Invalid_Congruent and Invalid_Incongruent trials
%%
clear
%%
%First delete the first row of the xlsx (name of the proc)
Table_subjcode = readtable('...\subjcode.xlsx'); %open the table
%%
%%Extract the Accuracy of the subject

Accuracy_Fish_subjcode = Table_subjcode.StimDisplay_ACC(~any(isnan(Table_subjcode.StimDisplay_ACC),2),:); %if in the column of interest the data is not a Nan, extract it
%Repeat for Pig and Tort conditions
Accuracy_Pig_subjcode = Table_subjcode.StimDisplay2_ACC(~any(isnan(Table_subjcode.StimDisplay2_ACC),2),:); 
Accuracy_Tort_subjcode = Table_subjcode.StimDisplay3_ACC(~any(isnan(Table_subjcode.StimDisplay3_ACC),2),:);
%%
%%Find the position of the Cue for each trial

Cue_Fish_logical_subjcode = ~cellfun(@isempty,Table_subjcode.CuePos); %if the Cue column is empty == 0, if ~empty == 1
Cue_Fish_subjcode = Table_subjcode.CuePos(Cue_Fish_logical_subjcode); %if the logical is 1, extract the data
%repeat for the Pig and Tort condition
Cue_Pig_logical_subjcode = ~cellfun(@isempty,Table_subjcode.CuePos2);
Cue_Pig_subjcode = Table_subjcode.CuePos2(Cue_Pig_logical_subjcode);
Cue_Tort_logical_subjcode = ~cellfun(@isempty,Table_subjcode.CuePos3);
Cue_Tort_subjcode = Table_subjcode.CuePos3(Cue_Tort_logical_subjcode);
%%
%%Find the position of the stim for each trial

%Repeat for the stim
Stim_Fish_subjcode = ~cellfun(@isempty,Table_subjcode.StimPos);
Stim_Fish_subjcode = Table_subjcode.StimPos(Stim_Fish_subjcode);
Stim_Pig_subjcode = ~cellfun(@isempty,Table_subjcode.StimPos2);
Stim_Pig_subjcode = Table_subjcode.StimPos2(Stim_Pig_subjcode);
Stim_Tort_subjcode = ~cellfun(@isempty,Table_subjcode.StimPos3);
Stim_Tort_subjcode = Table_subjcode.StimPos3(Stim_Tort_subjcode);
%%
%%The validity of the cue depends on the position of the cue and the stim
%%if the cue and the stim are both the same ('bottom' or 'top'), the cue is valid, otherwise its invalid

Validity_Fish_subjcode = []; %create matrices for each condition
Validity_Pig_subjcode = [];
Validity_Tort_subjcode = [];

for i = 1:length(Cue_Fish_subjcode) %For as many cue
    if strcmp(Stim_Fish_subjcode(i,:),Cue_Fish_subjcode(i,:)) %If the cue and the stim are both top or both bottom
    Validity_Fish_subjcode = [Validity_Fish_subjcode ; 1]; %The trial is valid (==1), store it as 1 in the matrix
    else %otherwise
    Validity_Fish_subjcode = [Validity_Fish_subjcode ; 0]; %The trial is invalid (==0), store it as 0 in the matrix
    end
end
%Repeat for Pig and Tort condition
for i = 1:length(Cue_Pig_subjcode)
    if strcmp(Stim_Pig_subjcode(i,:),Cue_Pig_subjcode(i,:))
    Validity_Pig_subjcode = [Validity_Pig_subjcode ; 1];
    else
    Validity_Pig_subjcode = [Validity_Pig_subjcode ; 0];
    end
end

for i = 1:length(Cue_Tort_subjcode)
    if strcmp(Stim_Tort_subjcode(i,:),Cue_Tort_subjcode(i,:))
    Validity_Tort_subjcode = [Validity_Tort_subjcode ; 1];
    else
    Validity_Tort_subjcode = [Validity_Tort_subjcode ; 0];
    end
end
%%
%%Find the congruency of the stim

Congruency_cell_Fish_subjcode = Table_subjcode.Congruency(Cue_Fish_logical_subjcode); %From the table, get the non empty congruency cells (using the previous logical matrix)
%repeat for Pig and Tort condition
Congruency_cell_Pig_subjcode = Table_subjcode.Congruency(Cue_Pig_logical_subjcode);
Congruency_cell_Tort_subjcode = Table_subjcode.Congruency(Cue_Tort_logical_subjcode);

Congruency_Fish_subjcode = cellfun(@(Congruency_cell_Fish_subjcode)(strcmp(Congruency_cell_Fish_subjcode,'congruent')), Congruency_cell_Fish_subjcode); %if the cell is 'congruent', store it as a 1, otherwise store it as a 0
%Repeat fort Pig and Tort conditions
Congruency_Pig_subjcode = cellfun(@(Congruency_cell_Pig_subjcode)(strcmp(Congruency_cell_Pig_subjcode,'congruent')), Congruency_cell_Pig_subjcode);
Congruency_Tort_subjcode = cellfun(@(Congruency_cell_Tort_subjcode)(strcmp(Congruency_cell_Tort_subjcode,'congruent')), Congruency_cell_Tort_subjcode);
%%
header = {'Accuracy', 'Congruency', 'Validity'}; %create a header to save the data
%%
%%Save the data

Fish_subjcode = [Accuracy_Fish_subjcode , Congruency_Fish_subjcode, Validity_Fish_subjcode]; %Store Accuracy, Congruency and Validity of the Fish condition in one matrix
ANT_Fish_subjcode = [header ; num2cell(Fish_subjcode)]; %Put the header on 
%Repeat for Pig end Tort condition
Pig_subjcode = [Accuracy_Pig_subjcode , Congruency_Pig_subjcode, Validity_Pig_subjcode];
ANT_Pig_subjcode = [header ; num2cell(Pig_subjcode)];
Tort_subjcode = [Accuracy_Tort_subjcode , Congruency_Tort_subjcode, Validity_Tort_subjcode];
ANT_Tort_subjcode = [header ; num2cell(Tort_subjcode)];
%%
save ...\subjcode_ANT_Info.mat 'Fish_subjcode' 'Pig_subjcode' 'Tort_subjcode'
%%
clear
disp('end with success')
%%

%%
clear

%Starting the preprocessing of the data
load '...\subjcode_ANT\subjcode_ANT_Filtered.mat' %load EEG filtered data
%%
subjcode_ANT_Raw = [a09Tant_20220209_150442_filmff1 a09Tant_20220209_150442_filmff2]; %create a single matrix
save '...\subjcode_ANT\subjcode_ANT_Raw.mat' 'subjcode_ANT_Raw' %save it
%%
%Offset measure
%Because of the recording material and filtering, there is a relative offset for each participant
%The offset has to be measured to get the proper segmentation
%The measure will be taken using the NetStation software segmentation and the raw data
%%Find the index of the first tag in the NS software segmented data

%Load the software segmented data
load '...\subjcode_ANT\subjcode_ANT_Segmented.mat'
load '...\subjcode_ANT_Info.mat'
%Find the measure at the first tag (in the softwar segmentation)
if Fish_subjcode(1,2) == 1
    Offset_ANT_NS = congruent_Segment_001(:,200)';
else
    Offset_ANT_NS = incongruent_Segment_001(:,200)';
end

%Get the raw data
Offset_ANT_Brut = (subjcode_ANT_Raw)';

%Find the measure of the first tag in the raw data. Will return the index off the first tag in raw data.
Offset_ANT_Idx = find(ismember(Offset_ANT_Brut,Offset_ANT_NS,'rows'));

%Get the Tag time and tag idex from the relative event table
subjcode_event=readtable('...\subjcode_ANT\subjcode_ANT_Event.xlsx');
subjcode_Relative_Tag_Idx = round(subjcode_event.Tag_time);
subjcode_Tag_Number = round(subjcode_event.Tag_number);

%Correct the relative event table by substracting the offset NS data
Offset_ANT = subjcode_Relative_Tag_Idx(1,1) - Offset_ANT_Idx(1,1);
subjcode_Tag_Idx = subjcode_Relative_Tag_Idx - Offset_ANT ;
%%
save '...\subjcode_ANT\subjcode_Event.mat' 'subjcode_Tag_Idx' 'subjcode_Tag_Number'
clear
%%
load ...\subjcode_ANT\subjcode_ANT_Raw.mat
load ...\subjcode_ANT\subjcode_Event.mat
%%
%Segmentation
%%
% Create an index matrix for each condition
Idx_Fish_subjcode = [];
Idx_Pig_subjcode = [];
Idx_Tort_subjcode = [];

%Segment the data for each condition (animals) 200ms before and 1100ms after marker
for i = 1:(length(subjcode_Tag_Number)) %For as many tags
    if subjcode_Tag_Number(i,1) == 1 %If the tag is one (fish)
        Idx_Segment_subjcode = ((subjcode_Tag_Idx(i,:))-199): ((subjcode_Tag_Idx(i,:))+1100)'; %Segment the data
        Idx_Fish_subjcode = [Idx_Fish_subjcode; Idx_Segment_subjcode]; %Store it in the fish matrix
    elseif subjcode_Tag_Number(i,1) == 2 %If the tag is 2 (pig)
        Idx_Segment_subjcode = ((subjcode_Tag_Idx(i,:))-199): ((subjcode_Tag_Idx(i,:))+1100)'; %Segment the data
        Idx_Pig_subjcode = [Idx_Pig_subjcode; Idx_Segment_subjcode]; %Store it in the pig matrix
    else %otherwise, if the tag is 3 (tort))
        Idx_Segment_subjcode = ((subjcode_Tag_Idx(i,:))-199): ((subjcode_Tag_Idx(i,:))+1100)'; %Segment the data
        Idx_Tort_subjcode = [Idx_Tort_subjcode; Idx_Segment_subjcode]; %Store it in the tort matrix
    end
end
%%
%Change the dimension of the indeces
Idx_Pig_subjcode = Idx_Pig_subjcode';
Idx_Fish_subjcode = Idx_Fish_subjcode';
Idx_Tort_subjcode = Idx_Tort_subjcode';
%%
%Get the amplitude (value) for each index.
%Store it in a 3D matrix and reshape it to get data*electrode*segment
Segments_Pig_subjcode = subjcode_ANT_Raw(:,Idx_Pig_subjcode); %From the raw datat, extract all the electrodes (rows) and the coloms (time series) corresponding to the index
Segments_Pig_subjcode = reshape(Segments_Pig_subjcode, 129, 1300, 48); %Reshape as a 3D matrix 129 electrodes * 1300 ms * 48 segments
Segments_Pig_subjcode = Segments_Pig_subjcode(1:128,:,:); %Get rid of the last electrode
%Repeat for every condition
Segments_Fish_subjcode = subjcode_ANT_Raw(:,Idx_Fish_subjcode);
Segments_Fish_subjcode = reshape(Segments_Fish_subjcode, 129, 1300, 48);
Segments_Fish_subjcode = Segments_Fish_subjcode(1:128,:,:);
Segments_Tort_subjcode = subjcode_ANT_Raw(:,Idx_Tort_subjcode);
Segments_Tort_subjcode = reshape(Segments_Tort_subjcode, 129, 1300, 48);
Segments_Tort_subjcode = Segments_Tort_subjcode(1:128,:,:);
%%
save '...\subjcode_ANT\subjcode_ANT_Segmented_ML.mat' 'Segments_Fish_subjcode' 'Segments_Pig_subjcode' 'Segments_Tort_subjcode'
clear
%%
load '...\subjcode_ANT\subjcode_ANT_Segmented_ML.mat'
%%
%ARTIFACT DETECTION
%%
%With Netstation
%I do the artifact rejection using Netstation and use the log file output as a logical to reject bad segments
%%
load ...\subjcode_ANT_Info.mat
%%
Fish_info_cong = []; %Create matrices for congruent and incongruent trials for each animal condition
Fish_info_incong = [];
Pig_info_cong = [];
Pig_info_incong = [];
Tort_info_cong = [];
Tort_info_incong = [];

for i = 1:length(Fish_subjcode) %For as many fish trials
    if Fish_subjcode(i,2) == 1 %if the congruency is 1 (congruent)
        Fish_info_cong = [Fish_info_cong ; Fish_subjcode(i,:)]; %Store it in the congruent matrix
    else %else if the congruency is 2 (incongruent)
        Fish_info_incong = [Fish_info_incong ; Fish_subjcode(i,:)]; %Store it in the incongruent matrix
    end
end
Fish_info_congruency = [Fish_info_cong ; Fish_info_incong]; %Merge the congruencies together

%Repeat for Pig and Tort condition
for i = 1:length(Pig_subjcode)
    if Pig_subjcode(i,2) == 1 
        Pig_info_cong = [Pig_info_cong ; Pig_subjcode(i,:)];
    else
        Pig_info_incong = [Pig_info_incong ; Pig_subjcode(i,:)];
    end
end
Pig_info_congruency = [Pig_info_cong ; Pig_info_incong];


for i = 1:length(Tort_subjcode)
    if Tort_subjcode(i,2) == 1 
        Tort_info_cong = [Tort_info_cong ; Tort_subjcode(i,:)];
    else
        Tort_info_incong = [Tort_info_incong ; Tort_subjcode(i,:)];
    end
end
Tort_info_congruency = [Tort_info_cong ; Tort_info_incong];
%%
%load the log file 
subjcode_ANT_log=readtable('...\subjcode_ANT\subjcode_ANT_log.xlsx')
%%
%Get the segment without artifact

Fish_state_congruency = [subjcode_ANT_log.SegmentGood(1:24,:) ; subjcode_ANT_log.SegmentGood(73:96,:)]; %Create a matrix containing the information of the fish condition about the state of the segment (good or bad)
Fish_state_congruency = strcmp(Fish_state_congruency,'true'); %If the segment is good (true), mark as 1, else mark as 0

%Repeat for pig and tort condition
Pig_state = [subjcode_ANT_log.SegmentGood(25:48,:) ; subjcode_ANT_log.SegmentGood(97:120,:)];
Pig_state = strcmp(Pig_state,'true');

Tort_state = [subjcode_ANT_log.SegmentGood(49:72,:) ; subjcode_ANT_log.SegmentGood(121:144,:)];
Tort_state = strcmp(Tort_state,'true');
%%
Good_Segment_Fish_subjcode = []; %Create matrices for the good segments
Good_info_Fish_subjcode = [];
BC_Fish_subjcode = [];
Good_Segment_Pig_subjcode = [];
Good_info_Pig_subjcode = [];
BC_Pig_subjcode = [];
Good_Segment_Tort_subjcode = [];
Good_info_Tort_subjcode = [];
BC_Tort_subjcode = [];

%A segment is accepted if it has no artifact and a good accuracy, else its rejected

for i = 1:length(Fish_state_congruency) %For as many fish trials
    if Fish_state_congruency(i,:) == 1 & Fish_info_congruency(i,1) == 1 %If the segment is good and has a good accuracy
        Good_Segment_Fish_subjcode = cat(3,Good_Segment_Fish_subjcode, Segments_Fish_subjcode(:,:,i)); %Store it in the good segments matrix
        Good_info_Fish_subjcode = [Good_info_Fish_subjcode ; Fish_info_congruency(i,:)]; %Store its informations about Accuracy, Congruency and Validity
            BC_Fish_subjcode = [BC_Fish_subjcode ; subjcode_ANT_log.BadChannels(i,:)]; %Store the Bad Channels of the segment
            else 
    end
end


%Repeat for Pig and Tort condition
for i = 1:length(Pig_state)
    if Pig_state(i,:) == 1 & Pig_info_congruency(i,1) == 1
        Good_Segment_Pig_subjcode = cat(3,Good_Segment_Pig_subjcode, Segments_Pig_subjcode(:,:,i));
        Good_info_Pig_subjcode = [Good_info_Pig_subjcode ; Pig_info_congruency(i,:)];
            BC_Pig_subjcode = [BC_Pig_subjcode ; subjcode_ANT_log.BadChannels(i,:)];
            else 
    end
end



for i = 1:length(Tort_state)
    if Tort_state(i,:) == 1 & Tort_info_congruency(i,1) == 1
        Good_Segment_Tort_subjcode = cat(3,Good_Segment_Tort_subjcode, Segments_Tort_subjcode(:,:,i));
        Good_info_Tort_subjcode = [Good_info_Tort_subjcode ; Tort_info_congruency(i,:)];
            BC_Tort_subjcode = [BC_Tort_subjcode ; subjcode_ANT_log.BadChannels(i,:)];
            else 
    end
end    
%%
Valid_Congruent_Fish_subjcode = []; %For every animal condition, create matrices for Valid_Congruent trials, Valid_Incongruent, Invalid_Congruent and Invalid_Incongruent trials
Valid_Incongruent_Fish_subjcode = [];
Invalid_Congruent_Fish_subjcode = [];
Invalid_Incongruent_Fish_subjcode = [];
BC_Valid_Congruent_Fish_subjcode = [];
BC_Valid_Incongruent_Fish_subjcode = [];
BC_Invalid_Congruent_Fish_subjcode = [];
BC_Invalid_Incongruent_Fish_subjcode = [];
Valid_Congruent_Pig_subjcode = [];
Valid_Incongruent_Pig_subjcode = [];
Invalid_Congruent_Pig_subjcode = [];
Invalid_Incongruent_Pig_subjcode = [];
BC_Valid_Congruent_Pig_subjcode = [];
BC_Valid_Incongruent_Pig_subjcode = [];
BC_Invalid_Congruent_Pig_subjcode = [];
BC_Invalid_Incongruent_Pig_subjcode = [];
Valid_Congruent_Tort_subjcode = [];
Valid_Incongruent_Tort_subjcode = [];
Invalid_Congruent_Tort_subjcode = [];
Invalid_Incongruent_Tort_subjcode = [];
BC_Valid_Congruent_Tort_subjcode = [];
BC_Valid_Incongruent_Tort_subjcode = [];
BC_Invalid_Congruent_Tort_subjcode = [];
BC_Invalid_Incongruent_Tort_subjcode = [];

for i = 1:length(Good_info_Fish_subjcode) %For as many accepted segments
    if Good_info_Fish_subjcode(i,3) == 1 & Good_info_Fish_subjcode(i,2) == 1 %If the validity and the congruency are 1
        Valid_Congruent_Fish_subjcode = cat(3,Valid_Congruent_Fish_subjcode, Good_Segment_Fish_subjcode(:,:,i)); %Store the segment as a Valid_Congruent
        BC_Valid_Congruent_Fish_subjcode = [BC_Valid_Congruent_Fish_subjcode ; BC_Fish_subjcode(i,:)]; %Store its BC
    elseif Good_info_Fish_subjcode(i,3) == 1 & Good_info_Fish_subjcode(i,2) == 0 %If the validity is 1 and the congruency is 0
        Valid_Incongruent_Fish_subjcode = cat(3,Valid_Incongruent_Fish_subjcode, Good_Segment_Fish_subjcode(:,:,i)); %Store the segment as a Valid_Incongruent
        BC_Valid_Incongruent_Fish_subjcode = [BC_Valid_Incongruent_Fish_subjcode ; BC_Fish_subjcode(i,:)]; %Store its BC
    elseif Good_info_Fish_subjcode(i,3) == 0 & Good_info_Fish_subjcode(i,2) == 1 %If the validity is 0 and the congruency is 1
        Invalid_Congruent_Fish_subjcode = cat(3,Invalid_Congruent_Fish_subjcode, Good_Segment_Fish_subjcode(:,:,i)); %Store the segment as a Invalid_Congruent
        BC_Invalid_Congruent_Fish_subjcode = [BC_Invalid_Congruent_Fish_subjcode ; BC_Fish_subjcode(i,:)]; %Store its BC
    else %Otherwise if the validity and the congruency are 0
        Invalid_Incongruent_Fish_subjcode = cat(3,Invalid_Incongruent_Fish_subjcode, Good_Segment_Fish_subjcode(:,:,i)); %Store the segment as a Invalid_Incongruent
        BC_Invalid_Incongruent_Fish_subjcode = [BC_Invalid_Incongruent_Fish_subjcode ; BC_Fish_subjcode(i,:)]; %Store its BC
    end
end

%Repeat for Pig and Tort condition
for i = 1:length(Good_info_Pig_subjcode)
    if Good_info_Pig_subjcode(i,3) == 1 & Good_info_Pig_subjcode(i,2) == 1
        Valid_Congruent_Pig_subjcode = cat(3,Valid_Congruent_Pig_subjcode, Good_Segment_Pig_subjcode(:,:,i));
        BC_Valid_Congruent_Pig_subjcode = [BC_Valid_Congruent_Pig_subjcode ; BC_Pig_subjcode(i,:)];
    elseif Good_info_Pig_subjcode(i,3) == 1 & Good_info_Pig_subjcode(i,2) == 0
        Valid_Incongruent_Pig_subjcode = cat(3,Valid_Incongruent_Pig_subjcode, Good_Segment_Pig_subjcode(:,:,i));
        BC_Valid_Incongruent_Pig_subjcode = [BC_Valid_Incongruent_Pig_subjcode ; BC_Pig_subjcode(i,:)];
    elseif Good_info_Pig_subjcode(i,3) == 0 & Good_info_Pig_subjcode(i,2) == 1
        Invalid_Congruent_Pig_subjcode = cat(3,Invalid_Congruent_Pig_subjcode, Good_Segment_Pig_subjcode(:,:,i));
        BC_Invalid_Congruent_Pig_subjcode = [BC_Invalid_Congruent_Pig_subjcode ; BC_Pig_subjcode(i,:)];
    else
        Invalid_Incongruent_Pig_subjcode = cat(3,Invalid_Incongruent_Pig_subjcode, Good_Segment_Pig_subjcode(:,:,i));
        BC_Invalid_Incongruent_Pig_subjcode = [BC_Invalid_Incongruent_Pig_subjcode ; BC_Pig_subjcode(i,:)];
    end
end



for i = 1:length(Good_info_Tort_subjcode)
    if Good_info_Tort_subjcode(i,3) == 1 & Good_info_Tort_subjcode(i,2) == 1
        Valid_Congruent_Tort_subjcode = cat(3,Valid_Congruent_Tort_subjcode, Good_Segment_Tort_subjcode(:,:,i));
        BC_Valid_Congruent_Tort_subjcode = [BC_Valid_Congruent_Tort_subjcode ; BC_Tort_subjcode(i,:)];
    elseif Good_info_Tort_subjcode(i,3) == 1 & Good_info_Tort_subjcode(i,2) == 0
        Valid_Incongruent_Tort_subjcode = cat(3,Valid_Incongruent_Tort_subjcode, Good_Segment_Tort_subjcode(:,:,i));
        BC_Valid_Incongruent_Tort_subjcode = [BC_Valid_Incongruent_Tort_subjcode ; BC_Tort_subjcode(i,:)];
    elseif Good_info_Tort_subjcode(i,3) == 0 & Good_info_Tort_subjcode(i,2) == 1
        Invalid_Congruent_Tort_subjcode = cat(3,Invalid_Congruent_Tort_subjcode, Good_Segment_Tort_subjcode(:,:,i));
        BC_Invalid_Congruent_Tort_subjcode = [BC_Invalid_Congruent_Tort_subjcode ; BC_Tort_subjcode(i,:)];
    else
        Invalid_Incongruent_Tort_subjcode = cat(3,Invalid_Incongruent_Tort_subjcode, Good_Segment_Tort_subjcode(:,:,i));
        BC_Invalid_Incongruent_Tort_subjcode = [BC_Invalid_Incongruent_Tort_subjcode ; BC_Tort_subjcode(i,:)];
    end
end
%%
%Merge the Fish, Pig and Tort condition for validity and congruency
Valid_Congruent_subjcode = cat(3,Valid_Congruent_Fish_subjcode, Valid_Congruent_Pig_subjcode, Valid_Congruent_Tort_subjcode);
Valid_Incongruent_subjcode = cat(3, Valid_Incongruent_Fish_subjcode, Valid_Incongruent_Pig_subjcode, Valid_Incongruent_Tort_subjcode);
Invalid_Congruent_subjcode = cat(3, Invalid_Congruent_Fish_subjcode, Invalid_Congruent_Pig_subjcode, Invalid_Congruent_Tort_subjcode);
Invalid_Incongruent_subjcode = cat(3,Invalid_Incongruent_Fish_subjcode, Invalid_Incongruent_Pig_subjcode, Invalid_Incongruent_Tort_subjcode);
%%
%Merge the Fish, Pig and Tort condition for BC
BC_Valid_Congruent_subjcode = string([BC_Valid_Congruent_Fish_subjcode ; BC_Valid_Congruent_Pig_subjcode ; BC_Valid_Congruent_Tort_subjcode]);
BC_Valid_Incongruent_subjcode = string([BC_Valid_Incongruent_Fish_subjcode ; BC_Valid_Incongruent_Pig_subjcode ; BC_Valid_Incongruent_Tort_subjcode]);
BC_Invalid_Congruent_subjcode = string([BC_Invalid_Congruent_Fish_subjcode ; BC_Invalid_Congruent_Pig_subjcode ; BC_Invalid_Congruent_Tort_subjcode]);
BC_Invalid_Incongruent_subjcode = string([BC_Invalid_Incongruent_Fish_subjcode ; BC_Invalid_Incongruent_Pig_subjcode ; BC_Invalid_Incongruent_Tort_subjcode]);
%%
%Without netstation
%Make Matlab learn what an artifact is and automatically reject it
%Coming soon
%%
save '...\subjcode_ANT\subjcode_Good_Segments.mat' 'Valid_Congruent_subjcode' 'Valid_Incongruent_subjcode' 'Invalid_Congruent_subjcode' 'Invalid_Incongruent_subjcode'
save '...\subjcode_ANT\subjcode_Bad_Channels.mat' 'BC_Valid_Congruent_subjcode' 'BC_Valid_Incongruent_subjcode' 'BC_Invalid_Congruent_subjcode' 'BC_Invalid_Incongruent_subjcode' 
%%
clear
%%
load ...\subjcode_ANT\subjcode_Good_Segments.mat
load ...\subjcode_ANT\subjcode_Bad_Channels.mat
%%
%RE REFERENCING TO AVERAGE (each data point is substracted by the average of the electrode)
%%
RR_Valid_Congruent_subjcode = []; %create a matrix to get the output

for i = 1:length(BC_Valid_Congruent_subjcode) %for each segment
    str = BC_Valid_Congruent_subjcode(i,:); %extract the bad chan of segment i as string
    nb = sscanf(str,'%f, '); %convert string to double
    Seg_Valid_Congruent_less_BC = Valid_Congruent_subjcode(:,:,i); %select the i matrix of the condition
    Seg_Valid_Congruent_less_BC([nb],:,:) = []; %remove the bad channels from the i matrix
    mean_RR_Valid_Congruent_subjcode = mean(Seg_Valid_Congruent_less_BC,1); %mean the average activation of the electrodes (without the BC)
    RR_seg_Valid_Congruent_subjcode = Valid_Congruent_subjcode(:,:,i) - mean_RR_Valid_Congruent_subjcode; %substract mean activation from the matrix for segment i
    RR_Valid_Congruent_subjcode = cat(3, RR_Valid_Congruent_subjcode , RR_seg_Valid_Congruent_subjcode); %store the result in matrix
end

%Repeat for every condition

RR_Valid_Incongruent_subjcode = []; %create a matrix to get the output

for i = 1:length(BC_Valid_Incongruent_subjcode) %for each segment
    str = BC_Valid_Incongruent_subjcode(i,:); %extract the bad chan of segment i as string
    nb = sscanf(str,'%f, '); %convert string to double
    Seg_Valid_Incongruent_less_BC = Valid_Incongruent_subjcode(:,:,i); %select the i matrix of the condition
    Seg_Valid_Incongruent_less_BC([nb],:,:) = []; %remove the bad channels from the i matrix
    mean_RR_Valid_Incongruent_subjcode = mean(Seg_Valid_Incongruent_less_BC,1); %mean the average activation of the electrodes (without the BC)
    RR_seg_Valid_Incongruent_subjcode = Valid_Incongruent_subjcode(:,:,i) - mean_RR_Valid_Incongruent_subjcode; %substract mean activation from the matrix for segment i
    RR_Valid_Incongruent_subjcode = cat(3, RR_Valid_Incongruent_subjcode , RR_seg_Valid_Incongruent_subjcode); %store the result in matrix
end

RR_Invalid_Congruent_subjcode = []; %create a matrix to get the output

for i = 1:length(BC_Invalid_Congruent_subjcode) %for each segment
    str = BC_Invalid_Congruent_subjcode(i,:); %extract the bad chan of segment i as string
    nb = sscanf(str,'%f, '); %convert string to double
    Seg_Invalid_Congruent_less_BC = Invalid_Congruent_subjcode(:,:,i); %select the i matrix of the condition
    Seg_Invalid_Congruent_less_BC([nb],:,:) = []; %remove the bad channels from the i matrix
    mean_RR_Invalid_Congruent_subjcode = mean(Seg_Invalid_Congruent_less_BC,1); %mean the average activation of the electrodes (without the BC)
    RR_seg_Invalid_Congruent_subjcode = Invalid_Congruent_subjcode(:,:,i) - mean_RR_Invalid_Congruent_subjcode; %substract mean activation from the matrix for segment i
    RR_Invalid_Congruent_subjcode = cat(3, RR_Invalid_Congruent_subjcode , RR_seg_Invalid_Congruent_subjcode); %store the result in matrix
end

%Repeat for every condition

RR_Invalid_Incongruent_subjcode = []; %create a matrix to get the output

for i = 1:length(BC_Invalid_Incongruent_subjcode) %for each segment
    str = BC_Invalid_Incongruent_subjcode(i,:); %extract the bad chan of segment i as string
    nb = sscanf(str,'%f, '); %convert string to double
    Seg_Invalid_Incongruent_less_BC = Invalid_Incongruent_subjcode(:,:,i); %select the i matrix of the condition
    Seg_Invalid_Incongruent_less_BC([nb],:,:) = []; %remove the bad channels from the i matrix
    mean_RR_Invalid_Incongruent_subjcode = mean(Seg_Invalid_Incongruent_less_BC,1); %mean the average activation of the electrodes (without the BC)
    RR_seg_Invalid_Incongruent_subjcode = Invalid_Incongruent_subjcode(:,:,i) - mean_RR_Invalid_Incongruent_subjcode; %substract mean activation from the matrix for segment i
    RR_Invalid_Incongruent_subjcode = cat(3, RR_Invalid_Incongruent_subjcode , RR_seg_Invalid_Incongruent_subjcode); %store the result in matrix
end
%%
save '...\subjcode_ANT\subjcode_RR' 'RR_Valid_Congruent_subjcode' 'RR_Valid_Incongruent_subjcode' 'RR_Invalid_Congruent_subjcode' 'RR_Invalid_Incongruent_subjcode'
%%
clear
load '...\subjcode_ANT\subjcode_RR'
%%
%BASELINE CORRECTION
%For each channel, the average of all the samples within the baseline interval (100ms) 
%is subtracted from every sample in the segment 
%%
mean_Baseline_Valid_Congruent_subjcode = mean(RR_Valid_Congruent_subjcode(:,1:199,:),2);
Valid_Congruent_3D_subjcode = RR_Valid_Congruent_subjcode - mean_Baseline_Valid_Congruent_subjcode;
mean_Baseline_Valid_Incongruent_subjcode = mean(RR_Valid_Incongruent_subjcode(:,1:199,:),2); 
Valid_Incongruent_3D_subjcode = RR_Valid_Incongruent_subjcode - mean_Baseline_Valid_Incongruent_subjcode;
mean_Baseline_Invalid_Congruent_subjcode = mean(RR_Invalid_Congruent_subjcode(:,1:199,:),2); 
Invalid_Congruent_3D_subjcode = RR_Invalid_Congruent_subjcode - mean_Baseline_Invalid_Congruent_subjcode;
mean_Baseline_Invalid_Incongruent_subjcode = mean(RR_Invalid_Incongruent_subjcode(:,1:199,:),2); 
Invalid_Incongruent_3D_subjcode = RR_Invalid_Incongruent_subjcode - mean_Baseline_Invalid_Incongruent_subjcode;
%%
N_Valid_Congruent_subjcode = size(Valid_Congruent_3D_subjcode,3);
N_Valid_Incongruent_subjcode = size(Valid_Incongruent_3D_subjcode,3);
N_Invalid_Congruent_subjcode = size(Invalid_Congruent_3D_subjcode,3);
N_Invalid_Incongruent_subjcode = size(Invalid_Incongruent_3D_subjcode,3);
%%
save ...\subjcode_ANT\subjcode_Nb_segment_per_condition 'N_Valid_Congruent_subjcode' 'N_Valid_Incongruent_subjcode' 'N_Invalid_Congruent_subjcode' 'N_Invalid_Incongruent_subjcode'
save ...\subjcode_ANT\subjcode_3D_data_ML 'Valid_Congruent_3D_subjcode' 'Valid_Incongruent_3D_subjcode' 'Invalid_Congruent_3D_subjcode' 'Invalid_Incongruent_3D_subjcode'
clear
%%
disp('end with success')