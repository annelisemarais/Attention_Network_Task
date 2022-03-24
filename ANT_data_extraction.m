%Code : Anne-Lise Marais
%Protocol : Marie Anquetil

%This code extracts the data of a single subject of an Eprime version of the Child-ANT
%3 data are extracted : %Accuracy to the stimulation (1 = good answer), %Validity of the cue (1 = valid), %Congruency of the stimulation (1 = congruent)
%3 experimental conditions : Fish, Pig, Tort
%%
Table_subjcode = readtable('...\subjcode.xlsx') %open the table
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

Validity_Fish_subjcode = [] %create matrices for each condition
Validity_Pig_subjcode = []
Validity_Tort_subjcode = []

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
save ('...\subjcode_ANT_Info.mat' 'Fish_subjcode' 'Pig_subjcode' 'Tort_subjcode')