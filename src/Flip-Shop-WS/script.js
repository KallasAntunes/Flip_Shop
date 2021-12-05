const cherio = require('cherio');
const request = require('request');
const fs = require('fs');

var WriteStream  = fs.createWriteStream("srcImagensURL.txt", "UTF-8");

request('https://www.americanas.com.br/categoria/informatica/notebooks/m/lenovo', (err, resp, html)=>{

    if(!err && resp.statusCode == 200){
        console.log("Funcionou ");
        
        const $ = cherio.load(html);

        $("img").each((index, image)=>{
            var img = $(image).attr('src');
            var Links = img;
            WriteStream.write(Links);
            WriteStream.write("\n");
        });

    }else{
        console.log("Falhou " + resp.statusCode);
    }

});
