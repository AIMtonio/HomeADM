esTab = true;

//Definicion de Constantes y Enums	
var parametroBean = consultaParametrosSession(); 
var Enum_TipoLista_PLD = {
		listasNegras :'LN',
		listasPersBloq :'LPB',
		numlisNegras :1,
		numlisPersBloq :2
};

$(document).ready(function() {
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('adjuntar', 'submit');
	agregaFormatoControles('formaGenerica');
	habilitaBoton('consultar', 'submit');
	
	$('#fechaCarga').val(parametroBean.fechaSucursal);

	$.validator.setDefaults({
	      submitHandler: function(event) {
	    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','institNominaID', 
	    			  'funcionExito','funcionError');
	      }
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
		
	$('#adjuntar').click(function() {
		deshabilitaBoton('adjuntar','submit');
		muestraDatosArchivo(false);
		subirListasPLD();
	});
	
	$('#consultar').click(function(event) {
		ejemploArchivo();
		event.preventDefault();
	});
	
	$('#procesar').click(function(event) {
		var nombrear=$('#nombreArchivo').val().trim();
		var rutaarch=$('#rutaArchivoSubido').val().trim();
		if(nombrear.length<=0 && rutaarch.length<=0){
			event.preventDefault();
			deshabilitaBoton('procesar','submit');
		}
	});
	
	$('input[name="tipoLista"]').change(function (event){
	});
	
	// VALIDACION DE LA FORMA
	$('#formaGenerica').validate({
		rules: {			 
			fechaCarga	: {
				required	: true,
				date 		: true
			}
			
		},
		
		messages: {
			fechaCarga	: {
				required	: 'Especifique una Fecha de Carga.',
				date		: 'Fecha de Carga no válida.'
			}
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	
	// Subir archivos excel para la carga de listas PLD
	function subirListasPLD() {
		var tipoLista = $('#tipoLista:checked').val();
		var descLista = $('#tipoLista:checked').next().text();
 		var url ="cargaListasFileUpload.htm?tipoLista="+tipoLista+"&descLista="+descLista;
 		var leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
 		var topPosition = (screen.height) ? (screen.height-500)/2 : 0;
 		ventanaArchivosLista = window.open(url,
 				"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no," +
 				"addressbar=0,menubar=0,toolbar=0"+
 				"left="+leftPosition+
 				",top="+topPosition+
 				",screenX="+leftPosition+
 				",screenY="+topPosition);
 		
 		$('#gridCargaArchivoLista').html("");
		$('#gridCargaArchivoLista').hide(500); 	
	}
	 
}); // Fin del Document Ready

// Muestra el formato en el que debe de venir el archivo excel
function ejemploArchivo(){	
	var data;
	var tipoLista = $('input[name=tipoLista]:checked').next().text();
	
	data = '<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Descripci&oacute;n:</legend>'+
			
			'<table id="tablaLista">'+
				'<tr>'+
					'<td id="contenidoAyuda" align="left"><b>El siguiente formato corresponde a la estructura oficial del cat&aacute;logo '+
					'que maneja Qui&eacute;n es Qui&eacute;n.</br>'+
					'El nombre de los 24 encabezados (columnas) del archivo debe corresponder exactamente como se muestra a continuaci&oacute;n.</b></td>'+
				'</tr>'+
			'</table>'+
			'<br>'+
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo del Formato del Archivo para Carga de '+tipoLista+'</legend>'+
			'<table border="1" id="tablaLista" width="100%">'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>idqeq</b></td>'+ 
					'<td id="encabezadoAyuda"><b>nombre</b></td>'+ 
					'<td id="encabezadoAyuda"><b>paterno</b></td>'+ 
					'<td id="encabezadoAyuda"><b>materno</b></td>'+ 
					'<td id="encabezadoAyuda"><b>curp</b></td>'+ 
					'<td id="encabezadoAyuda"><b>rfc</b></td>'+ 
					'<td id="encabezadoAyuda"><b>fecnac</b></td>'+ 
					'<td id="encabezadoAyuda"><b>lista</b></td>'+ 
				'</tr>'+
				'<tr>'+
					'<td colspan="0" id="contenidoAyuda"><b>QEQ102029</b></td>'+ 
					'<td colspan="0" id="contenidoAyuda" style="white-space:nowrap"><b>Kelly Anne</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>Trainor</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>De Oceguera</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>GULJ750325MDGZRQ07</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>GULJ7503252W8</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>19750503</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>FUNC</b></td>'+
				'</tr>'+
			'</table>'+
			'<br>'+
			'<table border="1" id="tablaLista" width="100%">'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>estatus</b></td>'+ 
					'<td id="encabezadoAyuda"><b>dependencia</b></td>'+ 
					'<td id="encabezadoAyuda"><b>puesto</b></td>'+ 
					'<td id="encabezadoAyuda"><b>iddispo</b></td>'+ 
					'<td id="encabezadoAyuda"><b>curpok</b></td>'+ 
					'<td id="encabezadoAyuda"><b>idrel</b></td>'+ 
					'<td id="encabezadoAyuda"><b>parentesco</b></td>'+ 
					'<td id="encabezadoAyuda"><b>razonsoc</b></td>'+ 
				'</tr>'+
				'<tr>'+
					'<td colspan="0" id="contenidoAyuda"><b>Activo</b></td>'+ 
					'<td colspan="0" id="contenidoAyuda" style="white-space:nowrap"><b>ESTADOS UNIDOS DE AMERICA</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>Agente Cónsular</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>0</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>0</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b></b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b></b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b></b></td>'+
				'</tr>'+
			'</table>'+
			'<br>'+
			'<table border="1" id="tablaLista" width="100%">'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>rfcmoral</b></td>'+ 
					'<td id="encabezadoAyuda"><b>issste</b></td>'+ 
					'<td id="encabezadoAyuda"><b>imss</b></td>'+ 
					'<td id="encabezadoAyuda"><b>ingresos</b></td>'+ 
					'<td id="encabezadoAyuda"><b>nomcomp</b></td>'+ 
					'<td id="encabezadoAyuda"><b>apellidos</b></td>'+ 
					'<td id="encabezadoAyuda"><b>entidad</b></td>'+ 
					'<td id="encabezadoAyuda"><b>genero</b></td>'+ 
				'</tr>'+
				'<tr>'+
					'<td colspan="0" id="contenidoAyuda"><b></b></td>'+ 
					'<td colspan="0" id="contenidoAyuda" style="white-space:nowrap"><b></b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b></b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b></b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>Kelly Anne Trainor De Oceguera</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>Trainor De Oceguera</b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b></b></td>'+
					'<td colspan="0" id="contenidoAyuda"><b>F</b></td>'+
				'</tr>'+
			'</table>'+
			'</div></div>'+ 
			'</fieldset>'; 
	
	$('#ejemploArchivo').html(data); 

	$.blockUI({
		message : $('#ejemploArchivo'),
		css : {
			 left: '50%',
			 top: '50%',
			 margin: '-200px 0 0 -400px',
			 border: '0',
			 'background-color': 'transparent'
		}
	});  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}	

// Funcion que muestra los datos del archivo pendiente
function consultaArchivoPendiente(){
	var bean = {
			cargaListasID: 0
	};
	
	var tipoLista = $('#tipoLista:checked').val();
	
	if(tipoLista===Enum_TipoLista_PLD.listasNegras){
		tipoLista=Enum_TipoLista_PLD.numlisNegras;
	} else if(tipoLista===Enum_TipoLista_PLD.listasPersBloq){
		tipoLista=Enum_TipoLista_PLD.numlisPersBloq;
	}
	
	cargaListasPLDServicio.consulta(bean, tipoLista, function(data){
		if (data != null ){
			var rutaArchivo = data.rutaArchivoSubido;
			var nombreArchivo = data.rutaArchivoSubido;
			$('#cargaListasID').val(data.cargaListasID);
			$('#nombreArchivo').val(nombreArchivo.substring(nombreArchivo.lastIndexOf('PLD/')).replace('PLD/',''));
			$('#rutaArchivoSubido').val(rutaArchivo);
		} else {
			$('#cargaListasID').val('');
			$('#nombreArchivo').val('');
			$('#rutaArchivoSubido').val('');
		}
	});
}

// Funcion que se ejecuta desde la ventanita de adjuntar
function resultadoPopUp(){
	var folio = $('#numError').asNumber();
	if(folio==0){
		consultaArchivoPendiente();
		muestraDatosArchivo(true);
	} else {
		muestraDatosArchivo(false);
	}
}

// Funcion que muestra/ocuta los campos con los datos
function muestraDatosArchivo(muestra){
	if(muestra){
		$('#labelNombreArchivo').show();
		$('#nombreArchivo').show();
		$('#procesar').show();
	} else {
		$('#nombreArchivo').val('');
		$('#rutaArchivoSubido').val('');
		$('#labelNombreArchivo').hide();
		$('#nombreArchivo').hide();
		$('#procesar').hide();
	}
}

function funcionExito(){
}

function funcionError(){
}
function ayuda() {
	
	var data = '<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
		'<legend class="ui-widget ui-widget-header ui-corner-all">Incluye Encabezado</legend>'+
		'<div>'+
			'<p>Indica si incluye o no el primer registro del archivo a cargar (encabezado).</p>'+
		'</div>'
	'</fieldset>'; 
	$('#ContenedorAyuda').html(data); 
	$.blockUI({
	message : $('#ContenedorAyuda'),
	css : {
	top : ($(window).height() - 400) / 2 + 'px',
	left : ($(window).width() - 400) / 2 + 'px',
	width : '400px'
	}
	});
	$('.blockOverlay').attr('title', 'Clic para Desbloquear').click(function() {
		$.unblockUI();
	});
}