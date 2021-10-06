run:
	nextflow run main.nf -profile docker

clean:
	rm -rf work/
	rm -rf .nextflow.log*