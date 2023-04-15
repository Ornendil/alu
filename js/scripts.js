const xsltProcessor = new XSLTProcessor();

// Load the XML file
let myXMLHTTPRequest = new XMLHttpRequest();
myXMLHTTPRequest.open("GET", "oltesaurus.xml", false);
myXMLHTTPRequest.send(null);

let xmlDoc = myXMLHTTPRequest.responseXML;

const xslStylesheets = [
    'grunnlag',
    'systematisk',
    'alfabetisk'
];

for (const sheet of xslStylesheets){
    // Load the xslt file
    myXMLHTTPRequest = new XMLHttpRequest();
    myXMLHTTPRequest.open("GET", sheet + ".xsl", false);
    myXMLHTTPRequest.send(null);
    
    let xslStylesheet = myXMLHTTPRequest.responseXML;
    xsltProcessor.importStylesheet(xslStylesheet);
    
    const fragment = xsltProcessor.transformToFragment(xmlDoc, document);
    
    document.getElementById(sheet).appendChild(fragment);
}
