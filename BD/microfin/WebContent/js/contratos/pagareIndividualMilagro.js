var contratoIndividual;
var datosCRedito = [];

function generarPagareMicrocreditoConfiadora(creditoID, clienteID) {
	
	/**
	 * 	String Firma_Contrato  = "47";
		String Firma_FirmaSolicitud  = "73";
		String Firma_FirmaPagare  = "45";
		String Firma_Caratula  = "46";
		String Merge_Caratula_Contrato = "MERGE-01";
		
		------------------
		"creditNumber" : "10200005673",
	    "customerNumber" : "1633",
	    "documentType" : "MERGE-01"
		
	 */
		
	var documentoLegal = {
		'creditNumber' : creditoID + '',
		'customerNumber' : clienteID + '',
		'documentType' : '45'
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


