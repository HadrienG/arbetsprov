process make_report {
    label "R"
    cache false
    publishDir "${params.output}/", mode: "copy"
    input:
        path(rmd)
        path(css)
        path(fastqc_out)
        path(quast_out)
        tuple val(prefix_0), path(best_hit)
        tuple val(prefix_1), path(mlst)
    output:
        path("report.html"), emit: report
    script:
        """
        cp ${rmd} here.Rmd  # otherwise renders in assets/ directory
        Rscript -e "rmarkdown::render('here.Rmd', output_file = 'report.html')"
        """
}