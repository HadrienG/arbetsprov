run:
	nextflow run main.nf -profile docker,local

clean:
	rm -rf work/
	rm -rf .nextflow.log*