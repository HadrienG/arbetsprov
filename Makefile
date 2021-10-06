run:
	nextflow run main.nf -profile docker,local

ci:
	nextflow run main.nf -profile docker,ci

clean:
	rm -rf work/
	rm -rf .nextflow.log*