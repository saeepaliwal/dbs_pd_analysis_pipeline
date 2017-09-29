Exploring impulsivity using the HGF and the Slot-machine paradigm

This repository allows for the recreation and application of the results outlined in Paliwal, Petzschner et al, 2014, exploring impulsive behavior in a slot-machine gambling paradigm. 

The main script to run is: all_analysis_wrapper.m. The script is thoroughly commented and takes the user step-by-step through the analyses. The following variables will need to exist in your workspace before running all_analysis_wrapper:

       ANALYSIS_NAME := what you would like to call your analysis
       DATA_DIRECTORY := where your data is stored
       LIST_OF_SUBJECT_DIRECTORIES := where your subject-specific raw data is stored
       PATH_TO_RESULTS_FOLDER := where you would like to store your results
       QUESTIONNAIRE_STRUCT := full path to questionnaire struct

If your raw data has already been processed into a struct, you must speficy
       
       STATS_STRUCT := full path to stats struct

The questionnaire struct is subject-specific questionnaire values. The questionnaire struct must have a labels field, which should be the same as in the stats struct, to allow a robust concatenation of structures. stats{subject_type}.labels will instruct the order of the subjects/patients in each of the subfields.

