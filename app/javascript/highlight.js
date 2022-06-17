function highlight(){
    document.querySelector("#content").querySelectorAll( "*" ).forEach(elem => {
        var highlight = document.querySelector("#highlight").value;
        var text = elem.innerHTML;
        var pattern = new RegExp(highlight, "g");

        var matches = text.match(pattern);
        if(matches != null){
            matches.forEach( match => {
                elem.innerHTML = text.replaceAll(match, "<mark>"+match+"</mark>")
            })
        }
    });
}