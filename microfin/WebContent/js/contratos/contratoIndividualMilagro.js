var documento;

var contratoIndividual;
var datosCRedito = [];
var parametroBean = consultaParametrosSession();
var dia = null;
var mes = null;
var anio = null;

function generarContratoMicrocreditoConfiadora(creditoID, clienteID) {
	
	var documentoLegal = {
		'creditNumber' : creditoID + '',
		'customerNumber' : clienteID + '',
		'documentType' : 'MERGE-01'
	};
	
	creditosServicio.documentoLegal(documentoLegal, function(documento) {
		if(documento != null){
			
			if(documento.codigoRespuesta == "000000"){
				var byteCharacters = atob(documento.documento);
				var byteNumbers = new Array(byteCharacters.length);
				
				for (var i = 0; i < byteCharacters.length; i++) {
				  byteNumbers[i] = byteCharacters.charCodeAt(i);
				}
				
				var byteArray = new Uint8Array(byteNumbers);
				var file = new Blob([byteArray], { type: 'application/pdf;base64' });
				var fileURL = URL.createObjectURL(file);
				window.open(fileURL);
			}else{
				mensajeSis(documento.mensajeRespuesta);
			}
		
			
		}else{
			mensajeSis("Ocurrio un problema al generar el PDF");
		}
	});
	
}

