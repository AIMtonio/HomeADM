$(document).ready(function() {
	parametros = consultaParametrosSession();
	var esTab = true;
	// Declaración de constantes	
	var catTipoTranSolChecList = { 
		'actualiza'		: 1,
		
	};		
	
	var catTipoLista ={
			'checklist' : 4
	};	
	
	var catTipoConsulta = {
			'checkList': 4
		};
	
	var catStatusCede = {
			'alta':'INACTIVA',
			'vigente':'VIGENTE',
			'pagada' :'PAGADA',
			'cancelada':'CANCELADA',
			'vencida':'VENCIDA'
	}; 
	//------------ Metodos y Manejo de Eventos -----------------------------------------
   deshabilitaBoton('grabar', 'submit');
   deshabilitaBoton('expediente', 'submit');
   agregaFormatoControles('formaGenerica');	
   $('#cedeID').focus();
   
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
      submitHandler: function(event) {
    	   var validar = guardarCodigos();
    	      if(validar != 1){
    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoCuentaID',
    			  				'exitoCheckLisCredito', 'falloCheckLisCredito');
    	      }
      }
   });	
	

	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTipoTranSolChecList.actualiza);	
	});
	
	

	
	$('#cedeID').blur(function() {
		if(isNaN($('#cedeID').val()) & esTab == true ){
			$('#cedeID').val("");
			$('#cedeID').focus();
			inicializaForma('formaGenerica', 'cedeID');
			$('#gridSolicitudCheckList').hide(); 
		}else{
			validaCede(this.id);		
		}
	});
	
	$('#cedeID').bind('keyup',function(e){				
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "nombreCliente";		
		 parametrosLista[0] = $('#cedeID').val();			
		lista('cedeID', 2, catTipoLista.checklist, camposLista, parametrosLista, 'listaCedes.htm');		
	});

	$('#pdf').click(function() {
		if($('#cedeID').val()==''){
			alert("Debe de indicar un Número de CEDE");
			$('#enlace').removeAttr("href"); 
			$('#cedeID').focus();	
		}else{
			var cedeID = $('#cedeID').val();
			var nombre=$('#nombreCliente').val();			
			window.open('cedesFilePDF.htm?cedeID='+cedeID
					+'&nombreCliente='+nombre
					  ,'_blank' );
			
			
		}
	});
	
	$('#listaDocs').click(function() {
		if($('#cedeID').val()==''){
			alert("Debe de indicar un Numero de CEDE");
			$('#enlaceLista').removeAttr("href"); 
			$('#cedeID').focus();	
		}else{
			
			var tipocedeID = $('#cedeID').val();
			var nombreInst = parametroBean.nombreInstitucion;
			var sucursal = parametroBean.nombreSucursal;
			var fechaAplic = parametroBean.fechaAplicacion;
			var nomUsuario = parametroBean.claveUsuario;
			window.open('listaDocsCedesPDF.htm?cedeID='+tipocedeID
					+'&nombreInstit='+nombreInst+'&sucursal='+sucursal+'&fecha='+fechaAplic+'&usuario='+nomUsuario
					  ,'_blank' );
			
		}
	});
	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			cedeID: 'required',
		},		
		messages: {
			cedeID: 'Especificar el Número de CEDE',
		}		
	});
	
	

	//------------ Validaciones de Controles -------------------------------------
		
	function validaCede(idControl){
		var jqCede = eval("'#" + idControl + "'");
		var numCede = $(jqCede).val();			
		var cedeBean = {
			'cedeID' : numCede
		};
		if(numCede != '' && !isNaN(numCede)){
			cedesServicio.consulta(catTipoConsulta.checkList, cedeBean, function(cedesCon){
				if(cedesCon!=null){
				
				
					 $('#clienteID').val(cedesCon.clienteID);
					 $('#nombreCliente').val(cedesCon.nombreCliente);
					 $('#descripcion').val(cedesCon.descripcion);
					 $('#fechaInicio').val(cedesCon.fechaInicio);
					 $('#fechaVencimiento').val(cedesCon.fechaVencimiento);
					 $('#monto').val(cedesCon.monto);
					 $('#productoID').val(cedesCon.tipoCedeID);
					 $('#estatus').val(cedesCon.estatus);
					 $('#fechaRegistro').val(cedesCon.fechaInicio);
					
					consultaGridCheckList(cedesCon.estatus);	
					
					if(cedesCon.estatus == 'A'){
						$('#estatus').val('ALTA');
					
						
					}
		
					if(cedesCon.estatus == 'C'){	
						 $('#estatus').val('CANCELADO');
						alert("La CEDE tiene Estatus Cancelado su CheckList no puede ser Modificado");
					
					}
					if(cedesCon.estatus == 'N'){		
						 $('#estatus').val('VIGENTE');
						alert("La CEDE tiene Estatus Vigente su CheckList no puede ser Modificado");
					
					}					
					if(cedesCon.estatus == 'P'){
						 $('#estatus').val('PAGADO');
						alert("La CEDE tiene Estatus Pagado su CheckList no puede ser Modificado");
				
					}
			
					if(cedesCon.estatus == 'I'){
						 $('#estatus').val('INACTIVO');
						alert("La CEDE tiene Estatus Inactivo su CheckList no puede ser Modificado");
				
					}
			
			
						
				}else{
					alert('La CEDE no Existe');
					inicializaForma('formaGenerica','cedeID');
					$('#gridSolicitudCheckList').hide(); 
					$(jqCede).focus();
					$(jqCede).val('');
				}
			
			});				
		}
	}	

	
		

});

function seleccionaFoco(){
	
	var numCodig = $('input[name=consecutivoID]').length;
	

	for(var i = 1; i <= numCodig; i++){
			var jstipoDocument = eval("'#tipoDocumentoID" +i+ "'");
			var jsobs = eval("'#observacion"+i+"'");
				if($(jsobs).val() == ''){
					
					$(jstipoDocument).focus();	
					$(jstipoDocument).select();	
					 break; 
				}	
				var doccheck = eval("'#docRecibido"+i+"'");
	
	}
		

}



	function consultaGridCheckList(estatus){	

		var params = {};
		params['tipoLista'] = 4;
		params['clasificaTipDocID'] = $('#clasificaTipDocID').val();
		params['productoID'] = $('#productoID').val();
		params['clienteID'] = $('#clienteID').val();
		params['cedeID'] = $('#cedeID').val();
		
		
		$.post("checkListCedesGrid.htm", params, function(data){
		
			if(data.length > 0) {	
				agregaFormatoControles('gridSolicitudCheckList');
				$('#gridSolicitudCheckList').html(data);
				$('#gridSolicitudCheckList').show();
				seleccionaFoco();
				
				habilitaBoton('pdf', 'submit');
				habilitaBoton('listaDocs', 'submit');
				if(estatus == "A"){
					habilitaBoton('grabar', 'submit');
				}else{
					deshabilitaBoton('grabar', 'submit');
				}

				
				if($('#numeroDocumento').val() == 0){
					$('#gridSolicitudCheckList').html("");
					$('#gridSolicitudCheckList').hide(); 
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('pdf', 'submit');
					deshabilitaBoton('listaDocs', 'submit');
				}			
			}else{				
				$('#gridSolicitudCheckList').html("");
				$('#gridSolicitudCheckList').hide(); 
			}
		});
	}
	
	
	function guardarCodigos(){		
 		var mandar = verificarvacios();
 		
 		if(mandar!=1){   
			var numCodigo = $('input[name=consecutivoID]').length;
			$('#datosGrid').val("");
			for(var i = 1; i <= numCodigo; i++){

				if(i == 1){
					
					$('#datosGrid').val($('#datosGrid').val() +
					document.getElementById("cedeID").value + ']' +
					document.getElementById("clasificaTipDocID"+i+"").value + ']' +
					document.getElementById("tipoDocumentoID"+i+"").value + ']' +
					document.getElementById("docRecibido"+i+"").value + ']' +
					document.getElementById("observacion"+i+"").value);
					
					
				}else{
					$('#datosGrid').val($('#datosGrid').val() + '[' +
							document.getElementById("cedeID").value + ']' +
							document.getElementById("clasificaTipDocID"+i+"").value + ']' +
							document.getElementById("tipoDocumentoID"+i+"").value + ']' +
							document.getElementById("docRecibido"+i+"").value + ']' +
							document.getElementById("observacion"+i+"").value);
				}	
		}
	}	
 		else{
			return 1;
		}
	}


	function verificarvacios(){	
		quitaFormatoControles('gridSolicitudCheckList');
		var numCodig = $('input[name=consecutivoID]').length;
		
		$('#datosGrid').val("");
		for(var i = 1; i <= numCodig; i++){
		
 			var idctd = document.getElementById("clasificaTipDocID"+i+"").value;
 			if (idctd ==""){
 				document.getElementById("clasificaTipDocID"+i+"").focus();				
				$(idctd).addClass("error");	
 				return 1; 
 			}
 			
 			var idDocOb = document.getElementById("observacion"+i+"").value;
 			var docRec = document.getElementById("docRecibido"+i+"").value;
 			var tipoDoc = document.getElementById("tipoDocumentoID"+i+"").value;
 			var jsDesCat = document.getElementById("clasificaTipDocID"+i+"").value;
 			
/* valida que el tipo de documento no este vacio*/
 			var existe = 0;
 			if(tipoDoc == '0'){
 			var contador = 1;	
 				$('input[name=clasificaTipDocID]').each(function() {
 					var jsDocAct = eval("'#tipoDocumentoID" +contador+ "'");
 					if(jsDesCat == this.value && $(jsDocAct).val() != '0'){
 						existe = 1;
 					}
 					contador ++;			
				});	
 			}else {
 				existe = 1;
 			}
 			
		if(existe == 0){
			document.getElementById("tipoDocumentoID"+i+"").focus();
			alert("Seleccionar Documento")
			return 1;
			
		}

/* valida que la observacion no este vacio*/		
		var existeObs = 0;
			if(tipoDoc != '0'){
			var contadorObs = 1;	
				$('input[name=clasificaTipDocID]').each(function() {
					var jsObsAct = eval("'#observacion" +contadorObs+ "'");
					if(jsDesCat == this.value && $(jsObsAct).val() != ''){
						existeObs = 1;
					}
					contadorObs ++;			
			});	
			}else {
				existeObs = 1;
			}
			
	if(existeObs == 0){
		document.getElementById("observacion"+i+"").focus();
		alert("Especificar Comentario")
		return 1;
		
	}
	
/*valida que se haya adjuntado un archivo*/
	var existeAdj = 0;
	if(tipoDoc != '0'){
	var contadorAdj = 1;	
		$('input[name=clasificaTipDocID]').each(function() {
			var jsObsAct = eval("'#recurso" +contadorAdj+ "'");
			if(jsDesCat == this.value && $(jsObsAct).val() != ''){
				existeAdj = 1;
			}
			contadorAdj ++;			
	});	
	}else {
		existeAdj = 1;
	}
	
if(existeAdj == 0){
document.getElementById("enviar"+i+"").focus();
alert("Adjuntar Archivo")
return 1;

}
	


/* valida que el tipo de el Check no este vacio*/
	var existeCheck = 0;
		if(tipoDoc != '0'){
		var contadorCheck = 1;	
			$('input[name=clasificaTipDocID]').each(function() {
				var jsCheckAct = eval("'#docRecibido" +contadorCheck+ "'");

				var jsRecurso = eval("'#recurso" +contadorCheck+ "'");
				if ($(jsRecurso).val() != ''){ 
				if(jsDesCat == this.value && $(jsCheckAct).val() != 'N'){
					existeCheck = 1;
				}
				contadorCheck ++;	
			}
				else {
					existeCheck = 1;
				}
		});	
		}else {
			existeCheck = 1;
		}
		
		if(existeCheck == 0){
			document.getElementById("docRecibido"+i+"").focus();
			alert("Debe Seleccionar Documento Recibido");
			return 1;
			
		}
	
		/* valida que el comentario no este vacio*/
		var existeReg = 0;
			if(tipoDoc != '0'){
			var contadorCheckReg = 1;	
				$('input[name=clasificaTipDocID]').each(function() {
					var jsCheckActReg = eval("'#docRecibido" +contadorCheckReg+ "'");
					var jsObsActReg = eval("'#observacion" +contadorCheckReg+ "'");
					var jstipoDocument = eval("'#tipoDocumentoID" +contadorCheckReg+ "'");
					
					if($(jsCheckActReg).val() != 'N' && $(jsObsActReg).val() == '' && $(jstipoDocument).val() != ''){
						 $(jsObsActReg).focus();
						existeReg = 2;
					}
					contadorCheckReg ++;			
			});	
			}else {
				existeReg = 1;
			}
			
			if(existeReg == 2){
				alert("Especificar Comentario");
				return 1;
				
			}
				
		}
	}
		

/* funcion para adjuntar el archivo*/

function adjuntarArchivos(numero){ 
	if($('#cedeID').val()==null || $.trim($('#cedeID').val())=='') {
		alert("Especificar un Numero de CEDE");
		$('#cedeID').focus();
	}else{
		var jsDesID = document.getElementById("tipoDocumentoID"+numero+"").value;
		var jsCometario = document.getElementById("observacion"+numero+"").value;
		if (jsDesID == 0){
				alert("Seleccionar un tipo de Documento");
				$('#tipoDocumentoID'+numero).focus();
			 }else if(jsCometario == ''){
				 alert("Especificar Comentario");
					$('#observacion'+numero).focus();
			 }
		else{
			subirArchivos(jsDesID, jsCometario);
		}
		
	}
}

/* funcion para cargar el archivo del cuenta */
var parametrosBean = consultaParametrosSession();
var rutaArchivos = parametrosBean.rutaArchivos;
var ventanaArchivosCliente ="";
function subirArchivos(tipoDoc, comentario) {
	var url ="cedesFileUploadVista.htm?cede="+$('#cedeID').val()+"&td="+tipoDoc+"&coment="+comentario;
	var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
	var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

	ventanaArchivosCuenta = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
									"left="+leftPosition+
									",top="+topPosition+
									",screenX="+leftPosition+
									",screenY="+topPosition);	


}

/* funcion para visualizar el documento de la cuenta */

function verArchivosCta(numero) { 

	
	var jsTipoDoc = document.getElementById("tipoDocumentoID"+numero+"").value;
	var varTipoDocVerArchivo = document.getElementById("archivoCuentaID"+numero+"").value;
	var varCedeVerArchivo = $('#cedeID').val();
	var varTipoConVerArchivo = 11;
	var parametros = "?cedeID="+varCedeVerArchivo+"&tipoDocumento="+
	jsTipoDoc+"&tipoConsulta="+varTipoConVerArchivo+"&archivoCuentaID="+varTipoDocVerArchivo;

	var pagina="cedesVerArchivos.htm"+parametros;
	
	var idrecurso = eval("'#recursoCteInput"+numero+"'");
	var extensionArchivo=  $(idrecurso).val().substring( $(idrecurso).val().lastIndexOf('.'));
	
	if(extensionArchivo ==".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg"){
		$('#imgCliente').attr("src",pagina); 				
		$('#imagenCte').html(); 
		 $.blockUI({message: $('#imagenCte'),
			   css: { 
         top:  ($(window).height() - 400) /2 + 'px', 
         left: ($(window).width() - 400) /2 + 'px', 
         width: '400px' 
     } });  
		  $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
		

	}else{
		window.open(pagina,'_blank');	
		$('#imagenCte').hide();
	}		
}




//Funcion para consultar el numero de documentos por cuenta. y generar reporte
function consultaNumeroDocumentosPorCliente() { 
	var  clienteArchivosBean={
		'prospectoID' :$('#prospectoID').val(),
		'clienteID' : $('#clienteID').val() 
	};			
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true; 
	if( $('#clienteID').val() != '' || !isNaN( $('#clienteID').val()) && esTab){
		clienteArchivosServicio.consulta(3,clienteArchivosBean,function(clienteArchivos) { 
			if(clienteArchivos!=null){
				numeroDocumentos = 	clienteArchivos.numeroDocumentos;				
				if(numeroDocumentos > 0 ){						var parametrosBean = consultaParametrosSession();
					var fechaEmision = parametrosBean.fechaAplicacion;
					var nombreUsuario = parametrosBean.claveUsuario;
					var nombreInstitucion = parametrosBean.nombreInstitucion;
					var clienteID = $('#clienteID').val();
					var nombre=$('#nombreCliente').val();
					var prospectoID = $('#prospectoID').val();
					var nombreProspecto=$('#nombreProspecto').val();
					var pagina='clientesFilePDF.htm?clienteID='+clienteID+'&nombreCliente='+nombre+
						'&prospectoID='+prospectoID+'&nombreProspecto='+nombreProspecto+
						'&nombreUsuario='+nombreUsuario+'&fechaEmision='+fechaEmision+'&nombreInstitucion='	+nombreInstitucion;

				window.open(pagina);

				} else{
					alert("El cliente no tiene documentos digitalizados.");
				}
			}else{
				alert("El cliente no tiene documentos digitalizados.");
			}
		});																										
	}
}


function consultaArchivCliente(){
	 var estatus = 'A';
	  consultaGridCheckList(estatus);

}

function consultaDocumento(numero){
	var jsDesID = document.getElementById(numero).value;
	var jqDocuemnto  = eval("'#" + numero + "'");

	$('tr[name=renglon]').each(function() {
		var num= this.id.substr(7,this.id.length);
		var jsDes = eval("'tipoDocumentoID" + num+ "'");	
		var jsDocRec = eval("'docRecibido" + num+ "'");	
		var valorjsDes = document.getElementById(jsDes).value;
		
		if(jsDesID == valorjsDes && $('#'+jsDocRec).attr('checked')==true){
			alert("El tipo de Documento Seleccionado ya fue Registrado");
			$(jqDocuemnto).val("0").selected = true;
	
			}
		});

	}

// -- FUNCIONES ---------------------- 

	// Funcion que se ejecuta cuando el resultado del submit es exitoso
	function exitoCheckLisCredito() {	
	  	 deshabilitaBoton('grabar', 'submit');
	     deshabilitaBoton('expediente', 'submit');
	     $('#gridSolicitudCheckList').html("");
		 $('#gridSolicitudCheckList').hide(); 
	     limpiaForm('formaGenerica');
	     inicializaForma('formaGenerica', 'cedeID');
	}
	
	// funcion que se ejecuta cuando el resultado del submit falla	
	function falloCheckLisCredito() {
		//alert("CheckList Con Errores");  
	}

	