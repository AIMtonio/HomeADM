$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
  		'enviar':4,
  		'modificar':5,
  		'eliminar':6
  	}; 
	
	var catTipoLista ={
			'principal' : 5
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
	
	var nomAr = "";	
  		
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('pdf', 'submit');
	deshabilitaBoton('adjuntar', 'button');
	$('#cedeID').focus();
  	
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) { 	
		grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cedeID');
	 	}
	});		   			
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#adjuntar').click(function() {
		if($('#cedeID').val()==null || $('#cedeID').val()==''){
			alert("Especifique Numero de CEDE");
			$('#cedeID').focus();
		}else{
			if ($('#tipoDocumento').val()==null || $('#tipoDocumento').val()==''){
				alert("Seleccione un tipo de Documento");
				$('#tipoDocumento').focus();
			}else{
				subirArchivos();
			}
		}
	});
	
	$('#pdf').click(function() {
		if($('#tipoDocumento').val()==''){
			alert("Seleccione un Tipo de documento");
			$('#tipoDocumento').focus();			
			return false;
		}else{
			var cedeID = $('#cedeID').val();
			var nombre=$('#nombreCliente').val();
			
			window.open('cedesFilePDF.htm?cedeID='+cedeID
					+'&nombreCliente='+nombre
					  ,'_blank' );
			
		}
	});
		
	
	$('#cedeID').blur(function() {
		//$('#tipoDocumento').val('');
	//	$('#gridArchivosCta').hide();
		
		if(!isNaN($('#cedeID').val()) & esTab == true){
			validaCede(this.id);		
		}
	});
	
	$('#cedeID').bind('keyup',function(e){				
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "nombreCliente";		
		 parametrosLista[0] = $('#cedeID').val();			
		lista('cedeID', 2, catTipoLista.principal, camposLista, parametrosLista, 'listaCedes.htm');		
	});


	
	
	$('#file').change(function(){
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
		$('#observacion').focus();
	});
	
	$('#tipoDocumento').blur(function() {
		if(esTab == true){
			consultaArchivCliente();
		}
	});	
	$('#tipoDocumento').change(function() {
		consultaArchivCliente();
	});
	
	$('#observacion').change(function() {	
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
	});
	
	var parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	$('#recurso').val(parametroBean.rutaArchivos);	
	
	//------------ Validaciones de la Forma -------------------------------------
	$.validator.addMethod('filesize', function(value, element, param) {
	    // param = size (en bytes) 
	    // element = element to validate (<input>)
	    // value = value of the element (file name)
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({
		rules: {
			cedeID: {
				required: true
			},
			tipoDocumento: {
				required: true
			},
			observacion: {
				required: true
			},
			file: { required: true,filesize: 3145728  }		
			
		},
		messages: {
			cedeID: {
				required: 'Especificar Numero de CEDE'
			},
			tipoDocumento: {
				required: 'Especificar Tipo de Documento' 
			},
			observacion: {
				required: 'Especificar Observacion'
			}	,
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamanio maximo de 3MB' 
			}	 
		}		
	});
	
//------------ Validaciones de Controles -------------------------------------

	function validaCede(idControl){
		var jqCede = eval("'#" + idControl + "'");
		var numCede = $(jqCede).val();			
		var cedeBean = {
			'cedeID' : numCede
		};
		if(numCede != 0 && numCede != '' && !isNaN(numCede)){
			cedesServicio.consulta(catTipoConsulta.checkList, cedeBean, function(cedesCon){
				if(cedesCon!=null){			
					$('#nombreCliente').val(cedesCon.nombreCliente);
					var tipoCede = cedesCon.tipoCedeID;
					var cedeID = cedesCon.cedeID;

					comboTiposDocumento(); 
						
				}else{
					alert('La Cede no Existe');
					inicializaForma('formaGenerica','cedeID');
					$(jqCede).focus();
					$(jqCede).val("");					
					$('#nombreCliente').val("");
					deshabilitaBoton('enviar', 'submit');		
					deshabilitaBoton('pdf', 'button');	
			
				}
			
			});				
		}
	}
	
	
		
});

function seleccionaFoco(){
	$('input[name=archivoCuentaID]').each(function () {
	
	});
		$('#verArchivoCta1').focus();
	$('#verArchivoCta1').select();
}

function consultaArchivCliente(){
	var tipoDoc = $('#tipoDocumento').val();
	if($('#cedeID').val()==null || $('#cedeID').val()==''){
		
	}else{
		if (tipoDoc != '' ){
			var params = {};
			
			params['tipoLista'] = 4;
			params['cedeID'] = $('#cedeID').val();
			params['tipoDocumento'] = $('#tipoDocumento').val();
			$.post("gridCedesFileUpload.htm", params, function(data){	
				
					if(data.length >0) {
						$('#gridArchivosCta').html(data);
						$('#gridArchivosCta').show();
						habilitaBoton('pdf', 'button');	
						habilitaBoton('adjuntar', 'button');

						seleccionaFoco();
					}else{
						$('#gridArchivosCta').html("");
						$('#gridArchivosCta').show();
					}
				
					
			});
		}else{
			$('#gridArchivosCta').html("");
			$('#gridArchivosCta').hide();

		}
	}
	
}	


//funcion para llenar el combo de procesos de escalamiento
function comboTiposDocumento() {	
	var tiposDoc = {
		'requeridoEn':'E'			
	};
	dwr.util.removeAllOptions('tipoDocumento'); 
	dwr.util.addOptions('tipoDocumento', {'':'SELECCIONAR'}); 
	tiposDocumentosServicio.listaCombo(1,tiposDoc, function(tiposDocumentos){
		dwr.util.addOptions('tipoDocumento', tiposDocumentos, 'tipoDocumentoID', 'descripcion');
	});
}

function eliminaArchivo(idControl) { 
	$('#tipoTransaccion').val('6');
	$('#archivoCuentaID').val(idControl);
	confirmarEliminar(idControl) ;
}

function confirmarEliminar(idControl) {		
	$('#tipoTransaccion').val('6');
	var tipoTrans = 6; 
	confirmar=confirm("¿Deseas eliminar el archivo?"); 
	if (confirmar) {
		var cedesArchivoBean ={
				'cedeID': $('#cedeID').val(),
				'tipoDocumento': $('#tipoDocumento').val(),
				'archivoCuentaID':idControl
		};
		
		cedesFileServicio.bajaArchivosCta(cedesArchivoBean, function(mensaje){
			if(mensaje != null){
				alert(mensaje.descripcion);
				consultaArchivCliente(); 
				}
		});
	}				
	else {
	
	} 		
}


var parametrosBean = consultaParametrosSession();
var rutaArchivos = parametrosBean.rutaArchivos;
var ventanaArchivosCliente ="";

function subirArchivos() {
	var url ="cedesFileUploadVista.htm?cede="+$('#cedeID').val()+"&td="+$('#tipoDocumento').val();
	var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
	var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

	ventanaArchivosCuenta = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
									"left="+leftPosition+
									",top="+topPosition+
									",screenX="+leftPosition+
									",screenY="+topPosition);	
	
	//$.blockUI({message: "Favor de terminar el proceso"});

}


function verArchivosCta(id, idTipoDoc, idarchivo) { 
	
	var varCuentaVerArchivo = $('#cedeID').val();
	var varTipoDocVerArchivo = idTipoDoc;
	var varArchivoCtaVerArchivo = idarchivo;
	var varTipoConVerArchivo = 11;
	var parametros = "?cedeID="+varCuentaVerArchivo+"&tipoDocumento="+
		varTipoDocVerArchivo+"&tipoConsulta="+varTipoConVerArchivo+"&archivoCuentaID="+varArchivoCtaVerArchivo;

	var pagina="cedesVerArchivos.htm"+parametros;
	
	var idrecurso = eval("'#recursoCteInput"+ id+"'");
	var extensionArchivo=  $(idrecurso).val().substring( $(idrecurso).val().lastIndexOf('.'));
	
	if(extensionArchivo ==".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg"){
		$('#imgCliente').attr("src",pagina); 				
		$('#imagenCte').html(); 
		  //$.blockUI({message: $('#imagenCte')});
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