process make_report {
    label "R"
    cache false
    publishDir "${params.output}/", mode: "copy"
    input:
        path(rmd)
        path(css)
        path(fastqc_out)
    output:
        path("report.html"), emit: report
    script:
        """
        cp ${rmd} here.Rmd  # otherwise renders in assets/ directory
        Rscript -e "rmarkdown::render('here.Rmd', output_file = 'report.html')"
        """
}