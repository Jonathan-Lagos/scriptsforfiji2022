setOption("JFileChooser", true);
run("Set Measurements...", "area mean standard min centroid center bounding shape integrated median display redirect=None decimal=3");
dir= getDirectory("Choose the folder containing the images");
setOption("JFileChooser", false);

imagenames=getFileList(dir); /// directorio de las células a analizar
nbimages=lengthOf(imagenames); /// nombre de las imagenes

	Dialog.create("Channel of lysosomes");
		Dialog.addNumber("Which is the first channel?",0);
		Dialog.addNumber("Which is the second channel?",0);
		Dialog.show();
		first = Dialog.getNumber(); ///canal de lisosomas
		second = Dialog.getNumber(); ///canal de lisosomas
	Dialog.create("Select the start and end of the analysis");
	Dialog.addNumber("Which stack do you want to start?", 1);
	Dialog.addNumber("How many stacks do you have in the .lif file?", 0);
	Dialog.show();
	start = Dialog.getNumber();
	end =Dialog.getNumber();
for(image=0; image<nbimages; image++) { /// Loop de iteración de las imagenes a anlizar
	
	name=imagenames[image];
	totnamelength=lengthOf(name); /// extención del nombre
	namelength=totnamelength-4;
	name1=substring(name, 0, namelength);
	extension=substring(name, namelength, totnamelength);
	
	
	if(extension==".lif") {
	 for(stack=start; stack<end; stack++) {
		run("Bio-Formats Importer", "open=["+dir+File.separator+name+"] color_mode=Colorized open_files rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_"+stack);
		savename = getTitle();
		newname ="stack_"+stack;
		rename(newname);
		File.makeDirectory(dir+File.separator+"Cortadas"+stack);
		getDimensions(width,height,channels,slices,frames);
			getPixelSize(unit,pw,ph);
			makeRectangle(0, 0, 20/pw, 20/ph);
			waitForUser ("Make a rectangle over the selected cells and press ctrl+t or just t");
			numROI=roiManager("count"); 
			for (i=0; i<numROI; i++){
				selectWindow(newname);
				roiManager("Select", i);
				run("Duplicate...", "title=["+name1+"_"+stack+"_"+i+"] duplicate");
			}
			selectWindow(newname);
			run("Close");
			openimages=nImages;
			for (ROIs=0; ROIs<openimages ; ROIs++) {
			    cutname=getTitle();
			    dircut = dir+File.separator+"Cortadas"+stack;
			    saveAs("Tiff", dircut+File.separator+cutname);    
			    run("Close");
			}
			selectWindow("ROI Manager");
			run("Close");
			File.makeDirectory(dir+File.separator+"results"+stack);
			imagenamesdc=getFileList(dircut); /// directorio de las células a analizar
			nbimagesdc=lengthOf(imagenamesdc); /// nombre de las imagenes
			for(imagedc=0; imagedc<nbimagesdc; imagedc++) { /// Loop de iteración de las imagenes a anlizar
				namedc=imagenamesdc[imagedc];
				totnamelengthdc=lengthOf(namedc); /// extención del nombre
				namelengthdc=totnamelengthdc-4;
				name1dc=substring(namedc, 0, namelengthdc);
				extensiondc=substring(namedc, namelengthdc, totnamelengthdc);
					if(extensiondc==".tif") {
					open(dircut+File.separator+namedc);
					abierta = getTitle();
					run("Duplicate...", "title=channel1 duplicate channels="+first);
					selectWindow(abierta);
					run("Duplicate...", "title=channel2 duplicate channels="+second);
					run("Coloc 2", "channel_1=channel1 channel_2=channel2 roi_or_mask=<None> threshold_regression=Costes display_images_in_result li_histogram_channel_1 li_histogram_channel_2 li_icq spearman's_rank_correlation manders'_correlation kendall's_tau_rank_correlation 2d_intensity_histogram costes'_significance_test psf=3 costes_randomisations=10");
					selectWindow("Log");
					saveAs("Text", dir+File.separator+"results"+stack+File.separator+"maskoff_"+newname+"_img_"+imagedc+".txt");
					close("Log");
					close("channel1");
					close("channel2");
					close(abierta);
					}
			}
			imagedc= 0;
			
			for(imagedc=0; imagedc<nbimagesdc; imagedc++) { /// Loop de iteración de las imagenes a anlizar
				namedc=imagenamesdc[imagedc];
				totnamelengthdc=lengthOf(namedc); /// extención del nombre
				namelengthdc=totnamelengthdc-4;
				name1dc=substring(namedc, 0, namelengthdc);
				extensiondc=substring(namedc, namelengthdc, totnamelengthdc);
					if(extensiondc==".tif") {
					open(dircut+File.separator+namedc);
					abierta = getTitle();
					run("Duplicate...", "title=channel1 duplicate channels="+first);
					selectWindow(abierta);
					run("Duplicate...", "title=channel2 duplicate channels="+second);
					run("Coloc 2", "channel_1=channel1 channel_2=channel2 roi_or_mask=channel2 threshold_regression=Costes display_images_in_result li_histogram_channel_1 li_histogram_channel_2 li_icq spearman's_rank_correlation manders'_correlation kendall's_tau_rank_correlation 2d_intensity_histogram costes'_significance_test psf=3 costes_randomisations=10");
					selectWindow("Log");
					saveAs("Text", dir+File.separator+"results"+stack+File.separator+"maskon_"+newname+"_img_"+imagedc+".txt");
					close("Log");	
					close("channel1");
					close("channel2");
					close(abierta);
					}		
			}
	
	}
	}
}