//BEAD_TRACKER: tracks lateral bead displacement 

//Instructions:
//1. USER INPUT (4): userDirectory, experiment, condition, series
//2. run script
//3. Trackmate 
//	a. input blob diameter (4.5 um) and threshold (5-12)manually 
// 	b. analyze spots, tracks, links
//	c. execute capture overlay
//	d. click OK
//	e. repeat for all ROIs

userDirectory ="/Volumes/Seagate/OMTC/experiments/" //USER INPUT 1/4
experiment = "DW_OMTC_LNCaP_25kPa_2022_04_04" //USER INPUT 2/4
condition = "TFM_LNCaP_25kPa" //USER INPUT 3/4
series = 1 //USER INPUT 4/4

directory_experiment = userDirectory + experiment
directory_condition = directory_experiment + "/"+condition
directory_series =directory_condition + "/series_" + series

roiCount = roiManager("count");
roi_array = newArray(0);

	for (i=1; i<=roiCount; i++) {

		bead_directory = directory_series+"/bead_"+ (i);
		File.makeDirectory(bead_directory);
		roiManager("select", i-1);  // select the ROI
        run("Duplicate...", "duplicate");
		run("Split Channels");
		
		//save C1 tiff
		selectWindow("C1-OMTC_"+ series + "-1.tif");
		C1_tiff = "C1_" + condition + "_series_" + series + "_bead_" + (i) + ".tif";
		print(C1_tiff);
		saveAs("Tiff", bead_directory + "/" + C1_tiff );
		close();
		
		run("Invert", "stack");
		run("Smooth", "stack");
		run("Enhance Contrast", "saturated=0.35");
		run("TrackMate");
		
		waitForUser("complete trackmate", "press OK once analysis is complete");
		
		close("TrackMatev6.0.2");

		//save all cvs data
		save_spots_links_tracks (bead_directory, condition, series, i, "Track statistics", "TRACKS");
		save_spots_links_tracks (bead_directory, condition, series, i, "Links in tracks statistics", "LINKS");
		save_spots_links_tracks (bead_directory, condition, series, i, "Spots in tracks statistics","SPOTS");
		
		// save C2 with traces
		selectWindow("TrackMate capture of C2-OMTC_" + series + "-1");
		saveAs("Tiff", bead_directory + "/C2_"+ condition +"_series_" + series + "_bead_" + (i) +".tif");
		close();
		close("C2_"+condition+"_OMTC_"+series+"_1.tif");
		close("C2-OMTC_"+series+"-1.tif");

		rename_roi (bead_directory, condition, series , i);

		selectWindow ("OMTC_" + series + ".tif");
}

Array.print(roi_array);
roiManager("Select", roi_array);
roiManager("Save", directory_series +"/RoiSet.zip");

close("*");

//saves the spots, links, and tracksarrays as excel files
function save_spots_links_tracks (bead_directory, condition, series_num, bead_num, old_file_name, file_type) {
	
	bead = condition+"_series_" + series_num + "_bead_"+ bead_num ;
	bead_file_type = bead+"_"+file_type+".csv" ;
	Table.rename(old_file_name, bead_file_type);
	
	directory_file_type = bead_directory + "/" + bead_file_type ;
	saveAs("Results", directory_file_type );
	
	close(bead_file_type);
	
	//without wait of 1 sec saving is unpredictable
	wait(1000);
}

// saves ROI overlay 
function rename_roi (bead_directory, condition, series_num, bead_num) {

	bead_name = condition +"_series_" + series_num + "_bead_"+ bead_num;
	
	roiManager("Rename", bead_name );

	roi_array= Array.concat(roi_array, series_num-1);
	
	
	
}



