
var catTipoTransaccion = {
	'agregar' : 1,
	'modificar' : 2,
	'baja' : 3
};

var catTipoConsultaParametros = {
	'principal' : 1,
	'porFolio' : 3,
	'existeFolio' : 4
};

var catOrganosSupervisores = {
	'SHCP':'001001',
	'CNBV':'001002',
	'CNSF':'001003',
	'CONSAR':'001004',
	'CONDUSEF':'001005',
	'IPAB':'001006',
	'SAT':'001007'
};
var folioVigente =0;
var existeFolioVigente = 'N';
var esTab = false;

$(document).ready(function() {

	 var parametroBean = consultaParametrosSession();
     
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	agregaFormatoControles('formaGenerica');
	$('#historico').hide();
	deshabilitaBoton('historico','submit');
	
	$('#folioID').focus();
	 
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	consultaFolioVigente();	
	$.validator.setDefaults({
		submitHandler : function(event) {
			resultadoTransaccion =
				  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','folioID','funcionExito','funcionError'); 	
		}
	});
		
	$('#grabar').click(function() {
			$('#tipoTransaccion').val(catTipoTransaccion.agregar);		
	 });
		
	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.modificar);		
  	});
	
	$('#baja').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.baja);		
  	});
	
	$('#folioID').blur(function() {
		consultaFolio($('#folioID').val()); 
	});

	$('#claveOrgSupervisor').blur(function(){
		var clave = $('#claveOrgSupervisor').val().trim();
		if(clave!=''){
			var valido = validaOrganoSup(clave);
			if(!valido){
				alert('Clave Inválida. Revise el Botón de Ayuda para más Información.');
				$('#claveOrgSupervisor').focus();
				$('#claveOrgSupervisor').val('');
				$('#claveOrgSupervisorExt').val('');
			}
		}
		asignaExtension();
	});
	
	  //------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({					
		rules: {				
			claveEntCasfim: {
				required: true,
				maxlength: 6
			},
			claveOrgSupervisor: {
				required: true,
				minlength: 6,
				maxlength: 6
			},			
			claveOrgSupervisorExt: {
				required: true,
				minlength: 3,
				maxlength: 3
			}
		},		
		
		messages: {		
		
			claveEntCasfim: {
				required: 'Especifique la Clave de la Entidad Financiera.',
				maxlength: 'Máx. 6 caracteres.'
			},			
			claveOrgSupervisor: {
				required: 'Especifique la Clave del Órgano Supervisor.',
				minlength: 'Min. 6 caracteres.',
				maxlength: 'Máx. 6 caracteres.'
			},			
			claveOrgSupervisorExt: {
				required: 'Especifique la Clave de la Extensión del Órgano Supervisor.',
					minlength: 'Min. 3 caracteres.',
					maxlength: 'Máx. 3 caracteres.'
			}
		}		
	});
	
	
	/* ***********************************FUNCIONES******************************  */

	function consultaFolio(numFolio) {
		var bean = {
				folioID: numFolio
		};
		if(numFolio != '' && !isNaN(numFolio) && esTab){
			if(numFolio == '0' ) {
				consultaExisteFolioVig();
			    $('#fechaVigencia').val(parametroBean.fechaSucursal);
			 	$('#estatus').val('V');
				if(existeFolioVigente=="S"){
					alert("El Folio: "+folioVigente+" se Encuentra Vigente.");
					$('#folioID').val(folioVigente);
					$('#folioID').focus();
					funcionExito();
				} else {
					habilitaControlesParam();
					habilitaBoton('grabar','submit');
					deshabilitaBoton('modifica','submit');
					deshabilitaBoton('baja','submit');
					limpiaCampos();
				}
			} else {
				parametrosPLDServicio.consulta(bean, catTipoConsultaParametros.porFolio, function(datosParams){
					if (datosParams != null ){
						dwr.util.setValues(datosParams);
						if(datosParams.estatus == 'B'){
							deshabilitaControlesParam();
							deshabilitaBoton('grabar','submit');
							deshabilitaBoton('modifica','submit');
							deshabilitaBoton('baja','submit');
						} else {
							habilitaControlesParam();
							deshabilitaBoton('grabar','submit');
							habilitaBoton('modifica','submit');
							habilitaBoton('baja','submit');
						}
						agregaFormatoControles('contenedorForma');
					} else {
						alert("No existe el Folio Indicado.");				
						inicializaForma('formaGenerica','folioID');
						$('#folioID').val('');
						$('#folioID').focus();
						$('#estatus').val('');
						deshabilitaBoton('grabar','submit');
						deshabilitaBoton('modifica','submit');
						deshabilitaBoton('baja','submit');
					}
				});				
			}
		}
		
	}
	
	function consultaFolioVigente(){
		var numFolio = 0;
		var bean = {
				folioID: numFolio
		};

		parametrosPLDServicio.consulta(bean, catTipoConsultaParametros.principal, function(datos){
			if(datos != null){
				dwr.util.setValues(datos);
				if(datos.estatus == 'B'){
					deshabilitaControlesParam();
					deshabilitaBoton('grabar','submit');
					deshabilitaBoton('modifica','submit');
					deshabilitaBoton('baja','submit');
				} else {
					habilitaControlesParam();
					deshabilitaBoton('grabar','submit');
					habilitaBoton('modifica','submit');
					habilitaBoton('baja','submit');
				}
				agregaFormatoControles('contenedorForma');
			} else {	
				inicializaForma('formaGenerica','folioID');
				$('#folioID').val('');
				$('#folioID').focus();
				habilitaControlesParam();
				habilitaBoton('grabar','submit');
				deshabilitaBoton('modifica','submit');
				deshabilitaBoton('baja','submit');
			}
		});
	}

	function consultaExisteFolioVig(){
		var bean = {
				folioID: 0
		};
		parametrosPLDServicio.consulta(bean, catTipoConsultaParametros.existeFolio, { async: false, callback:function(datosParams){
			if (datosParams != null ){
				existeFolioVigente=datosParams.folioVigente;
				folioVigente=datosParams.folioID;
			} else {
				existeFolioVigente='N';
				folioVigente=0;
			}
		}});
	}
								
});

function ayuda(){	
	var data;
	
	data = '<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
	'<div id="ContenedorAyuda">'+ 
	'<legend class="ui-widget ui-widget-header ui-corner-all">Claves &Oacute;rganos Supervisores</legend>'+
	'<table border="1" id="tablaLista" width="100%" style="margin-top:10px">'+
		'<tr>'+
			'<td id="encabezadoAyuda"><b>Clave</b></td>'+ 
			'<td id="encabezadoAyuda"><b>Descripci&oacute;n</b></td>'+ 
			'<td id="encabezadoAyuda"><b>Siglas</b></td>'+ 
		'</tr>'+
		'<tr>'+
			'<td colspan="0" id="contenidoAyuda"><b>001001</b></td>'+ 
			'<td colspan="0" id="contenidoAyuda" style="text-align: left;"><b>Secretar&iacute;a de Hacienda y Cr&eacute;dito P&uacute;blico</b></td>'+
			'<td colspan="0" id="contenidoAyuda"><b>SHCP</b></td>'+
		'</tr>'+
		'<tr>'+
			'<td colspan="0" id="contenidoAyuda"><b>001002</b></td>'+ 
			'<td colspan="0" id="contenidoAyuda" style="white-space:nowrap; text-align: left;"><b>Comisi&oacute;n Nacional Bancaria y de Valores</b></td>'+
			'<td colspan="0" id="contenidoAyuda"><b>CNBV</b></td>'+
		'</tr>'+
		'<tr>'+
			'<td colspan="0" id="contenidoAyuda"><b>001003</b></td>'+ 
			'<td colspan="0" id="contenidoAyuda" style="text-align: left"><b>Comisi&oacute;n Nacional de Seguros y Fianzas</b></td>'+
			'<td colspan="0" id="contenidoAyuda"><b>CNSF</b></td>'+
		'</tr>'+
		'<tr>'+
			'<td colspan="0" id="contenidoAyuda"><b>001004</b></td>'+ 
			'<td colspan="0" id="contenidoAyuda" style="text-align: left"><b>Comisi&oacute;n Nacional de Sistemas de Ahorro para el Retiro </b></td>'+
			'<td colspan="0" id="contenidoAyuda"><b>CONSAR</b></td>'+
		'</tr>'+
		'<tr>'+
			'<td colspan="0" id="contenidoAyuda"><b>001005</b></td>'+ 
			'<td colspan="0" id="contenidoAyuda" style="text-align: left"><b>Comisi&oacute;n Nacional para la Protecci&oacute;n y Defensa de los Usuarios de Servicios Financieros</b></td>'+
			'<td colspan="0" id="contenidoAyuda"><b>CONDUSEF</b></td>'+
		'</tr>'+
		'<tr>'+
			'<td colspan="0" id="contenidoAyuda"><b>001006</b></td>'+ 
			'<td colspan="0" id="contenidoAyuda" style="text-align: left"><b>Instituto para la Protecci&oacute;n al Ahorro Bancario</b></td>'+
			'<td colspan="0" id="contenidoAyuda"><b>IPAB</b></td>'+
		'</tr>'+
		'<tr>'+
			'<td colspan="0" id="contenidoAyuda"><b>001007</b></td>'+ 
			'<td colspan="0" id="contenidoAyuda" style="text-align: left"><b>Servicio de Administraci&oacute;n Tributaria</b></td>'+
			'<td colspan="0" id="contenidoAyuda"><b>SAT</b></td>'+
		'</tr>'+
	'</table>'+
	'</div>'+ 
	'</fieldset>';
	
	$('#ContenedorAyuda').html(data); 

	$.blockUI({
		message : $('#ContenedorAyuda'),
		css : {
			 left: '50%',
			 top: '50%',
			 margin: '-200px 0 0 -200px',
			 border: '0',
			 'background-color': 'transparent'
		}
	});  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}

function ayudaClaveEntidad(){	
	var data;
	
	data = '<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
	'<div id="ContenedorAyuda">'+ 
	'<legend class="ui-widget ui-widget-header ui-corner-all">Clave para la Entidad Financiera</legend>'+
	'<table border="0" id="tablaLista" width="100%" style="margin-top:10px">'+
		'<tr>'+
			'<td colspan="0" id="contenidoAyuda"><b>La Clave debe ser de acuerdo al Cat&aacute;logo del Sistema Financiero Mexicano para Entidades Financieras.</br>Debe ir sin el gui&oacute;n (-) intermedio y anteponiendo un 0 (cero) al inicio de la clave.</b></td>'+
		'</tr>'+
	'</table>'+
	'<br>'+
	'<div id="ContenedorAyuda">'+ 
	'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo:</legend>'+
	'<table border="1" id="tablaLista" width="100%">'+
		'<tr>'+
			'<td id="encabezadoAyuda"><b>Clave Entidad Financiera</b></td>'+ 
			'<td id="encabezadoAyuda"><b>Clave Resultante</b></td>'+
		'</tr>'+
		'<tr>'+
			'<td colspan="0" id="contenidoAyuda"><b>13-005</b></td>'+ 
			'<td colspan="0" id="contenidoAyuda"><b>013005</b></td>'+
		'</tr>'+
	'</table>'+
	'</div></div>'+ 
	'</fieldset>';
	
	$('#ContenedorAyuda').html(data); 

	$.blockUI({
		message : $('#ContenedorAyuda'),
		css : {
			 left: '50%',
			 top: '50%',
			 margin: '-200px 0 0 -200px',
			 border: '0',
			 'background-color': 'transparent'
		}
	});  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}

function deshabilitaControlesParam(){
	deshabilitaControl('claveEntCasfim');
	deshabilitaControl('claveOrgSupervisor');
	deshabilitaControl('claveOrgSupervisorExt');
}

function habilitaControlesParam(){
	habilitaControl('claveEntCasfim');
	habilitaControl('claveOrgSupervisor');
}

function limpiaCampos(){
	inicializaForma('formaGenerica','folioID');
	$('#fechaVigencia').val(parametroBean.fechaAplicacion);
	$('#estatus').val('V');
	habilitaBoton('grabar','submit');
	deshabilitaBoton('modifica','submit');
	deshabilitaBoton('baja','submit');
}

function asignaExtension(){
	var claveOrgSupervisor = $('#claveOrgSupervisor').val();
	if(claveOrgSupervisor.length>0){
		var extension = claveOrgSupervisor.substr(-3);
		$('#claveOrgSupervisorExt').val(extension);
	} else {
		$('#claveOrgSupervisorExt').val('');
	}
}

function validaOrganoSup(clave){
	var claveOrgSupervisor = clave;
	for (var index in catOrganosSupervisores) {
		if(catOrganosSupervisores[index]===claveOrgSupervisor)
			return true;
    }
	return false;
}

function funcionExito(){
	limpiaCampos();
	deshabilitaBoton('grabar','submit');
}

function funcionError(){
}