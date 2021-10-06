process hello_world {
    input:
        val(text)
    output:
        file("hello.txt")
    script:
        """
        echo $text > hello.txt
        """
    }