setOption("JFileChooser", true);
run("Set Measurements...", "area mean standard min centroid center bounding shape integrated median display redirect=None decimal=3");
dir= getDirectory("Choose the folder containing the images");
setOption("JFileChooser", false);

imagenames=getFileList(dir); /// directorio de las células a analizar
nbimages=lengthOf(imagenames); /// nombre de las imagenes

		Dialog.create("Channels");
		Dialog.addNumber("Which is the first channel?",0);
		Dialog.addNumber("Which is the second channel?",0);
		Dialog.show();
		first = Dialog.getNumber(); ///canal de lisosomas
		second = Dialog.getNumber(); ///canal de lisosomas
		File.makeDirectory(dir+File.separator+"analysis2");
			imagenames=getFileList(dir); /// directorio de las células a analizar
			nbimages=lengthOf(imagenames); /// nombre de las imagenes
			for(image=0; image<nbimages; image++) { /// Loop de iteración de las imagenes a anlizar
				name=imagenames[image];
				totnamelength=lengthOf(name); /// extención del nombre
				namelength=totnamelength-4;
				name1=substring(name, 0, namelength);
				extension=substring(name, namelength, totnamelength);
					if(extension==".tif") {
					open(dir+File.separator+name);
					abierta = getTitle();
					run("Duplicate...", "title=channel1 duplicate channels="+first);
					selectWindow(abierta);
					run("Duplicate...", "title=channel2 duplicate channels="+second);
					run("Coloc 2", "channel_1=channel1 channel_2=channel2 roi_or_mask=<None> threshold_regression=Costes display_images_in_result li_histogram_channel_1 li_histogram_channel_2 li_icq spearman's_rank_correlation manders'_correlation kendall's_tau_rank_correlation 2d_intensity_histogram costes'_significance_test psf=3 costes_randomisations=10");
					selectWindow("Log");
					saveAs("Text", dir+File.separator+"analysis2"+File.separator+"maskoff_"+name+"_img_"+image+".txt");
					close("Log");
					close("channel1");
					close("channel2");
					close(abierta);
					}
			}
			image= 0;
			
			for(image=0; image<nbimages; image++) { /// Loop de iteración de las imagenes a anlizar
				name=imagenames[image];
				totnamelength=lengthOf(name); /// extención del nombre
				namelength=totnamelength-4;
				name1=substring(name, 0, namelength);
				extension=substring(name, namelength, totnamelength);
					if(extension==".tif") {
					open(dir+File.separator+name);
					abierta = getTitle();
					run("Duplicate...", "title=channel1 duplicate channels="+first);
					selectWindow(abierta);
					run("Duplicate...", "title=channel2 duplicate channels="+second);
					run("Coloc 2", "channel_1=channel1 channel_2=channel2 roi_or_mask=channel2 threshold_regression=Costes display_images_in_result li_histogram_channel_1 li_histogram_channel_2 li_icq spearman's_rank_correlation manders'_correlation kendall's_tau_rank_correlation 2d_intensity_histogram costes'_significance_test psf=3 costes_randomisations=10");
					selectWindow("Log");
					saveAs("Text", dir+File.separator+"analysis2"+File.separator+"maskon_"+name+"_img_"+image+".txt");
					close("Log");	
					close("channel1");
					close("channel2");
					close(abierta);
					}		
			}

