#############################################################################################
### Script para download todos os artigos da Revista Brasileira de Ciências Sociais (RBCS)### 
### On-line version ISSN 1806-9053                                                        ###
### Autor: Leonardo F. Nascimento - @leofn3                                               ### 
### Carthago delenda est. Big data social science is the future                           ### 
#############################################################################################

rm(list=ls())
options(warn=-1)
options(show.error.messages = T)
library(XML)
dados <- data.frame()
url.scielo <- "http://www.scielo.br/scielo.php?script=sci_issues&pid=0102-6909&lng=en&nrm=iso"
pagina <- xmlRoot(htmlParse(readLines(url.scielo)))
links <- getNodeSet(pagina,"//font/a")
links <- xmlSApply(links, xmlGetAttr, name = "href")
dados <- cbind(links) 
links <- dados[3:(length(links)),] 
dados.pdf <- data.frame()
for (i in links){
  print(i)
  links.pdf <- xmlRoot(htmlParse(readLines(i)))
  links.pdf <- getNodeSet(links.pdf, "//a") 
  links.pdf <- xmlSApply(links.pdf, xmlGetAttr, name = "href")
  dados.pdf <- rbind(dados.pdf, cbind(links.pdf))
} 
### pegando todos os links para download
lista.links.final <- dados.pdf[grep("/pdf/rbcsoc/",dados.pdf$links.pdf),]
lista.links.final <- data.frame(sapply(lista.links.final, as.character), stringsAsFactors=FALSE)
frango <- "http://www.scielo.br/"
listafinal <- with(lista.links.final, paste(frango,lista.links.final[,1], sep=""))
## download em massa
for (url in listafinal) {
  newName <- paste(format(Sys.time(), "%Y%m%d%H%M%S"), "-", basename(url), sep =" ")
  download.file(url, destfile = newName,  mode="wb")
}

