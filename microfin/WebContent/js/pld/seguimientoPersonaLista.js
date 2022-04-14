/**
 * JS para la pantalla Seguimiento de personas en listas
 */

var esTab = true;
var parametrosBean;

$(document).ready(function() {
	
	agregaFormatoControles('formaGenerica');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	parametrosBean =  consultaParametrosSession();
	
	inicializa();
	$('#opeInusualID').focus();
	
	$.validator.setDefaults({
        submitHandler: function(event) { 
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','opeInusualID', 'exito', 'fallo');
        }
    });
	
	
	$('#opeInusualID').bind('keyup',function() {  		  
		lista('opeInusualID', '2', '1', 'nombre',$('#opeInusualID').val(),'listaSeguimientoPersona.htm');
	});
	
	$('#opeInusualID').blur(function() { 
		consultaSeguimietoPersona(this.id);
	});
	
	$('#agrega').click(function(){
		opeInusual = $('#opeInusualID').val();
		copyOpeInusual = $('#copyOpeInusualID').val();
		if(!isNaN(opeInusual)){
			if(opeInusual == copyOpeInusual){
				$('#tipoTransaccion').val("2");
			}else{
				mensajeSis('El folio de operación cambio presione TAB en el campo para consultar el folio actual');
				$('#opeInusualID').focus();
			}
		}else{
			mensajeSis('El folio debe ser numérico');
			$('#opeInusualID').focus();
		}
		
	});
	
	$('#formaGenerica').validate({					
		rules: {				
			comentario : {
				required:true
			}
		},		
		messages: {
			comentario :{
				required : 'El comentario es requerido',
			}
		}
	});
});//Fin del documento ready


function consultaSeguimietoPersona(idControl){
	var jqOpeInusual = eval("'#" + idControl + "'");
	var numOpe = $(jqOpeInusual).val();
	var numConsulta = 1;
	bean ={
			'opeInusualID':numOpe
	}
	setTimeout("$('#cajaLista').hide();", 200);
	if (numOpe != '' && !isNaN(numOpe) && esTab) {
		seguimientoPersonaListaServicio.consulta(numConsulta,bean,function(data){
			
			if(data != null){
				$('#opeInusualID').val(data.opeInusualID);
				$('#copyOpeInusualID').val(data.opeInusualID);
				$('#tipoPersona').val(data.tipoPersona);
				$('#numRegistro').val(data.numRegistro);
				$('#nombre').val(data.nombre);
				$('#fechaDeteccion').val(data.fechaDeteccion);
				$('#listaDeteccion').val(data.listaDeteccion);
				$('#nombreDet').val(data.nombreDet);
				$('#apellidoDet').val(data.apellidoDet);
				$('#fechaNacimientoDet').val(data.fechaNacimientoDet);
				$('#rfcDet').val(data.rfcDet);
				$('#paisDetID').val(data.paisDetID);
				if(data.permiteOperacion == 'S'){
					$('#permiteSI').attr('checked',true);
					$('#permiteNO').attr('checked',false);
				}else{
					$('#permiteSI').attr('checked',false);
					$('#permiteNO').attr('checked',true);
				}
				$('#comentario').val(data.comentario);
				$('#listaID').val(data.listaID);
				$('#tipoLista').val(data.tipoLista);
				$('#nombreCompleto').val(data.nombreCompleto);
				$('#fechaNacimientoCon').val(data.fechaNacimientoCon);
				$('#paisConID').val(data.paisConID);
				$('#estadoConID').val(data.estadoConID);
				$('#razonSocial').val(data.razonSocial);
				$('#rfcCon').val(data.rfcCon);
				consultaPaisDet('paisDetID');
				consultaPaisCon('paisConID');
				consultaEstado('estadoConID');
				habilitaBoton('agrega','submit');
			}
		}
			
		);
	}else{
		if(esTab){
			inicializa();
		}
	}
}



function consultaPaisDet(idControl) {
	var jqPais = eval("'#" + idControl + "'");
	var numPais = $(jqPais).val();
	var conPais = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numPais != '' && !isNaN(numPais)) {
		paisesServicio.consultaPaises(conPais, numPais,function(pais) {
			if (pais != null) {	
				$('#paisDetID').val(pais.paisID);
				$('#nombrePaisDet').val(pais.nombre);				
			} else {
				mensajeSis("No Existe el País");
				$('#nombrePaisDet').val('');
				$('#paisDetID').val();
			}
		});
	}
}

function consultaPaisCon(idControl) {
	var jqPais = eval("'#" + idControl + "'");
	var numPais = $(jqPais).val();
	var conPais = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numPais != '' && !isNaN(numPais)) {
		paisesServicio.consultaPaises(conPais, numPais,function(pais) {
			if (pais != null) {	
				$('#paisConID').val(pais.paisID);
				$('#nombrePaisCon').val(pais.nombre);				
				if (pais.paisID != 700) {
					$('#estadoConID').hide(0);
					$('#lblEstado').hide();
					$('#nombreEstadoCon').hide();
					$('#nombreEstadoCon').val("");
					$('#estadoConID').val("");
					
				}else if(pais.paisID == 700){
					$('#estadoConID').show(0);
					$('#lblEstado').show();
					$('#nombreEstadoCon').show();						
				}
			} else {
				mensajeSis("No Existe el País");
				$('#nombrePaisCon').val('');
				$('#paisConID').val('');
			}
		});
	}
}

function consultaEstado(idControl) {		
	var jqEstado = eval("'#" + idControl + "'");
	var numEstado = $(jqEstado).val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numEstado != '' && !isNaN(numEstado)) {
		estadosServicio.consulta(tipConForanea, numEstado,function(estado) {
			if (estado != null) {
				$('#estadoConID').val(estado.estadoID);
				$('#nombreEstadoCon').val(estado.nombre);
			} else {
				mensajeSis("No Existe el Estado");
				$('#estadoConID').val('');
				$('#nombreEstadoCon').val('');
			}
		});
	}
}

function exito(){
	$('#tipoPersona').val('');
	$('#numRegistro').val('');
	$('#nombre').val('');
	$('#fechaDeteccion').val('');
	$('#listaDeteccion').val('');
	$('#nombreDet').val('');
	$('#apellidoDet').val('');
	$('#fechaNacimientoDet').val('');
	$('#rfcDet').val('');
	$('#paisDetID').val('');
	$('#nombrePaisDet').val('');

	$('#permiteSI').attr('checked',false);
	$('#permiteNO').attr('checked',true);
	
	$('#comentario').val('');
	$('#listaID').val('');
	$('#tipoLista').val('');
	$('#nombreCompleto').val('');
	$('#fechaNacimientoCon').val('');
	$('#paisConID').val('');
	$('#nombrePaisCon').val('');
	$('#estadoConID').val('');
	$('#nombreEstadoCon').val('');
	$('#razonSocial').val('');
	$('#rfcCon').val('');
	deshabilitaBoton('agrega', 'submit');
}

function fallo(){
	
}

function inicializa(){
	$('#opeInusualID').val('');
	$('#tipoPersona').val('');
	$('#numRegistro').val('');
	$('#nombre').val('');
	$('#fechaDeteccion').val('');
	$('#listaDeteccion').val('');
	$('#nombreDet').val('');
	$('#apellidoDet').val('');
	$('#fechaNacimientoDet').val('');
	$('#rfcDet').val('');
	$('#paisDetID').val('');
	$('#nombrePaisDet').val('');

	$('#permiteSI').attr('checked',false);
	$('#permiteNO').attr('checked',true);
	
	$('#comentario').val('');
	$('#listaID').val('');
	$('#tipoLista').val('');
	$('#nombreCompleto').val('');
	$('#fechaNacimientoCon').val('');
	$('#paisConID').val('');
	$('#nombrePaisCon').val('');
	$('#estadoConID').val('');
	$('#nombreEstadoCon').val('');
	$('#razonSocial').val('');
	$('#rfcCon').val('');
	deshabilitaBoton('agrega', 'submit');
}