
// SERIES_SORTER: sorts the image and video captures from the experiment...
//only works if captures were saved with the naming scheme: OMTC_1, TFM_1, Cell_1, Null_1...


run("Bio-Formats Macro Extensions");

// USER INPUT 1/5: userDirectory requires the string of file directory name under which the experiemnt folder exists
userDirectory = "/Volumes/Seagate/OMTC/experiments/"

// USER INPUT 2/5: experiment requires a string of the name of raw data folder from confocal
experiment = "DW_OMTC_LNCaP_25kPa_2022_04_04"

// USER INPUT 3/5: condition requires the name of folder for subexperiment 
condition = "TFM_LNCaP_25kPa"

directory_experiment = userDirectory + experiment

directory_condition = directory_experiment + "/" + condition

lif_file = directory_experiment +"/"+ experiment+ ".lif"

File.makeDirectory(directory_condition)

//USER INPUT 4/5: series_start requires the number corresponding to the FIRST series in condition
series_start =1
//USER INPUT 5/5: series_start requires the number corresponding to the LAST series in condition
series_end =7
//eg: in input examples above, positions 1-7 in the experiemnt were of LNCaP on 25 kPa


for (series = series_start; series <= series_end; series++) {

	File.makeDirectory(directory_condition + "/series_" + series);
	save_tif (experiment,directory_condition, "OMTC", series);
	save_tif (experiment,directory_condition, "TFM", series);
	save_tif (experiment,directory_condition, "Cell", series);
	save_tif (experiment,directory_condition, "Null", series);	
	

}

function save_tif (experiment, directory_condition, tif_type, series) {

	
	selectWindow(experiment + ".lif - " + tif_type + "_" + series);
		
	saveAs("Tiff", directory_condition + "/series_" + series + "/" + tif_type + "_" + series + ".tif");

	close(tif_type + "_" + series + ".tif" );
	
}	

