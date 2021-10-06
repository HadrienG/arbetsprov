run:
	nextflow run main.nf -resume -profile docker

clean:
	rm -rf work/
	rm -rf .nextflow.log*