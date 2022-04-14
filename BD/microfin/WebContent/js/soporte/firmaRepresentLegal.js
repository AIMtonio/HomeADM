var numeroDocumentos = 0;
$(document).ready(function() {
	//subirArchivos();
	var parametroBean = consultaParametrosSession();
	esTab = true;	 	
	
	var nomAr = "";	

	var divCajaLista = $('#cajaLista');  	
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	deshabilitaBoton('adjunta', 'submit');
  	
  	$(':text').focus(function() {	
	 	esTab = false;
	});
  	
	$('#representLegal').attr('readOnly',true);
	$('#razonSocial').attr('readOnly',true);
	$('#rfcRepresentLegal').attr('readOnly',true);
	$('#rfc').attr('readOnly',true);
	
  	consultaRepresentante('representLegal');
  	
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID');			
	  	}
	});	
	   
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#adjunta').click(function() {				
		subirArchivos();
	});	
	
	
	$('#file').blur(function(){
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
		$('#observacion').focus();
	});

	$('#observacion').focus(function() {	
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
	});

	rutaArchivos = parametroBean.rutaArchivos;
	$('#recurso').val(parametroBean.rutaArchivos);

	//------------ Validaciones de la Forma -------------------------------------//	
	$.validator.addMethod('filesize', function(value, element, param) {
	    // param = size (en bytes) 
	    // element = element to validate (<input>)
	    // value = value of the element (file name)
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({
		rules: {
			representLegal: {
				required: true
			},			
			observacion: {
				required: true
			},
			file: { required: true,filesize: 3145728  }
		},
		messages: {
			representLegal: {
				required: 'Especificar Nombre'
			},
			observacion: {
				required: 'Especificar Observación'
			}	,
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamaño máximo de 3MB' 
			}	 
		}			
	});
});

//------------ Validaciones de Controles -------------------------------------		
function consultaRepresentante(control){
	var evalRepresent =  eval("'#"+control+"'");
	var valRepre =  $(evalRepresent).val();	
	var tipoConsulta=8;
	parametrosBean={
			'nombreRepresentante':valRepre
	};		
	parametrosSisServicio.consulta(tipoConsulta,parametrosBean,function(parametros){
		if(parametros!=null){
			$('#razonSocial').val(parametros.razonSocial);
			$('#rfcRepresentLegal').val(parametros.RFCRepresentante);
			$('#representLegal').val(parametros.nombreRepresentante);
			$('#rfc').val(parametros.rfcInstitucion);			
			habilitaBoton('adjunta', 'submit');
			consultaGridFirmas(control);
		}else{
			alert('Ocurrio un Problema al Consultar el Representante Legal');
		}
	});	
}

function consultaGridFirmas(control){
	var evalRepresent =  eval("'#"+control+"'");		
	var params = {};
	params['tipoLista'] = 1;
	params['representLegal']=$(evalRepresent).val();	
	$.post("firmaRepresentLegalGrid.htm", params, function(data){		
		if(data.length >0) {
			$('#gridAdjuntaFirma').html(data);
			$('#gridAdjuntaFirma').show();
		}else{
			$('#gridAdjuntaFirma').html("");
			$('#gridAdjuntaFirma').show();
		}
	});	
}

var parametrosBean = consultaParametrosSession();
var rutaArchivos = parametrosBean.rutaArchivos;
var ventanaArchivosCliente ="";

function subirArchivos() {
	var url ="firmaRepresentLegalArchivo.htm?representanteLegal="+$('#representLegal').val();
	
	var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
	var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;
	ventanaArchivosfirmaLegal = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
									"left="+leftPosition+
									",top="+topPosition+
									",screenX="+leftPosition+
									",screenY="+topPosition);	
}

//funcion para eliminar el documento digitalizado
function  eliminaArchivo(numero){	
	var evalConsecutivo=eval("'#consecutivo"+numero+"'");
	var bajaArchivo = 2;
	var firmaArchivoBean = {
		'representLegal'	:$('#representLegal').val(),
		'consecutivo'		:$(evalConsecutivo).val()
	};
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
	$('#contenedorForma').block({
			message: $('#mensaje'),
		 	css: {border:		'none',
		 			background:	'none'}
	});
	firmaRepresentLegalServicio.bajaFirma(bajaArchivo, firmaArchivoBean, function(mensajeTransaccion) {
		if(mensajeTransaccion!=null){
			alert(mensajeTransaccion.descripcion);
			$('#contenedorForma').unblock(); 
			consultaGridFirmas('representLegal');
		}else{				
			alert("Existio un Error al Borrar el Documento");			
		}
	});
}

function verArchivoFirma(id) {	
	var recurso=eval("'#recursoInput"+id+"'");
	var valRecurso = $(recurso).val();
	var parametros = "?recurso="+valRecurso;
	var pagina="firmasVerArchivos.htm"+parametros;
	
	var extensionArchivo=  $(recurso).val().substring( $(recurso).val().lastIndexOf('.'));
	extensionArchivo = extensionArchivo.toLowerCase();
	if(extensionArchivo==".jpg" || extensionArchivo == ".jpeg"){		
		$('#imagenFirma').attr("src",pagina); 		
		$('#imagenFirm').html();
		  $.blockUI({message: $('#imagenFirm'),
			   css: { 
			           top:  ($(window).height() - 400) /2 + 'px', 
			           left: ($(window).width() - 400) /2 + 'px', 
			           width: '400px' 
			   	} });  
		  $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
	}else{
		window.location=pagina;
		$('#imagenFirm').hide();
	}	
}

function consultaArchivCliente(){	
	consultaRepresentante('representLegal');
}

