#! /bin/bash

# this is a script to run a loop that will process all paired end read files in the specified directory

SAMPLE_PREFIX=$1

OUTPUT_FOLDER=/vol_b/kraken2_analysis
mkdir -p $OUTPUT_FOLDER

for R1 in $SAMPLE_PREFIX/*R1*.fastq.gz
do
	# Setup folders and pair filenames
	echo $R1
	R2=`echo $R1 | sed 's/_R1/_R2/'`
	bname=`echo $R1 | sed 's/_R1.\+//'`
	bname=`basename $bname`
	echo $R2
	echo $bname
	samplename=$(echo $bname | cut -d_ -f1)
	echo $samplename

	SAMPLE_FOLDER=$OUTPUT_FOLDER/$samplename
	mkdir -p $SAMPLE_FOLDER
	
	# Run Kraken2 Classify

	echo "Running Kraken2 on ${samplename}"

	kraken2 --paired \
		--gzip-compressed \
		--fastq-input \
		--threads 43 \
		--db /vol_b/kraken2_std \
		--output $SAMPLE_FOLDER/${bname}.kraken2-out.tsv \
		--report $SAMPLE_FOLDER/${bname}.kraken2-report.tsv \
		--classified-out $SAMPLE_FOLDER/${samplename}-classified# \
		--unclassified-out $SAMPLE_FOLDER/${samplename}-unclassified# \
		$R1 \
		$R2
done
