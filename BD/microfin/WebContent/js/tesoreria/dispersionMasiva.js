/**
 * JS PARA LA PANTALLA DE CARGA DE DISPERSION MASIVA
 * Programador: LVICENTE
 * Version:1.76
 */
var parametroBean; 

var esTab = true;

var catTipoConsultaInstituciones = {
		'principal':1, 
		'foranea':2
};


$(document).ready(function() {
	parametroBean = consultaParametrosSession();
	
	agregaFormatoControles('formaGenerica');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
		esTab= true;
		}
	});
	
	deshabilitaBoton('procesar', 'submit');
	deshabilitaBoton('validar', 'submit');
	
	$('#institucionID').focus();
	$('#fechaDisp').val(parametroBean.fechaSucursal);
	
	$('#institucionID').bind('keyup',function(e){
		listaAlfanumerica('institucionID', '2', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#institucionID').blur(function() {
		if($('#institucionID').val() != ''  ){
			consultaInstitucion(this.id);
			var tipoAccionBoton = $('#tipoAccion').val(); 		

		}
	});
	
	
	
	$('#cuentaAhorro').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionID').val();

		camposLista[1] = "cuentaAhoID";			
		parametrosLista[1] = $('#cuentaAhorro').val();

		listaAlfanumerica('cuentaAhorro', '2', '2', camposLista, parametrosLista, 'tesoCargaMovLista.htm');	       
	});


	$('#cuentaAhorro').blur(function() {
		if($('#cuentaAhorro').val() != '' && !isNaN($('#cuentaAhorro').val()) ){
			validaCuentaAhorro();	
		}
		$('#numCtaInstit').val($('#cuentaAhorro').val());	

	});
	
	$('#fechaDisp').change(function(){
		var fechax=parametroBean.fechaSucursal;
		var fechaCons = $('#fechaDisp').val();
		if(fechaCons != '' && fechaCons != undefined){
			if(esFechaValida(fechaCons)){
				if(fechaCons > fechax){
					mensajeSis('La Fecha Especificada no puede ser Mayor a la Fecha Actual');
					$('#fechaDisp').focus();
					$('#fechaDisp').val(fechax);
				}else{
					var anio = fechax.substring(0,4);
					fechax = parametroBean.fechaSucursal;
					var mes = fechax.substring(5,7);
					var fechaIni = anio+"-"+mes+"-01";
					
					if(fechaCons < fechaIni){
						mensajeSis('La fecha no puede ser de un mes anterior');
						$('#fechaDisp').focus();
						$('#fechaDisp').val(fechax);
					}
					
				}	
			}else{
				$('#fechaDisp').focus();
				$('#fechaDisp').val(fechax);
			}
		}			
	});
	
	
	$('#subirArchivo').click(function() {
		titulo = "Carga archivo Dispersión Masiva";
		tipoUpload=5;
		deshabilitaBoton('procesar', 'submit');
		deshabilitaBoton('validar', 'submit');
		subirArchivos(titulo, tipoUpload);
	});
	
	
	$('#validar').click(function(){
		if($('#institucionID').val()==''){
			mensajeSis('La Institucion no debe estar vacia.');
			$('#institucionID').focus();
		}else{
			if($('#cuentaAhorro').val()==''){
				mensajeSis('La Cuenta Bancaria no debe estar vacia.');
				$('#cuentaAhorro').focus();
			}else{
				bloquearPantalla();
				pegaHtml();
			}
		}
		
	});
	
	$('#procesar').click(function(){
		$('#tipoTransaccion').val(2);
	})
	
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
						  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','numTransaccion',
									'exito','error');
					  
		 
	  	}
		
	});
	
	
	
	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			institucionID: 'required',
			cuentaAhorro		: 'required'
		},

		messages: {
			institucionID: 'Especifique Institución',
			cuentaAhorro		: 'Especifique Cuenta Bancaria'
		}		
	});
	
	
});//FIN DOCUMENT READY



function validaCuentaAhorro(){
	var tipoConsulta = 9;
	var institucion=$('#institucionID').val();
	var cuenta =$('#cuentaAhorro').val();
	if(institucion=='')institucion=0;
	if(cuenta=='')cuenta=0;

	var DispersionBeanCta = {
			'institucionID': institucion,
			'numCtaInstit': cuenta
	};
	setTimeout("$('#cajaLista').hide();", 200);	
	if(cuenta >0 && esTab){
		operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
			if(data!=null){
				$('#cuentaAhorro').val(data.numCtaInstit);
				$('#numCtaInstit').val(data.numCtaInstit);
				consultaSaldoCuentaTesoreria(data.numCtaInstit,$('#institucionID').val());					
			}else{
				mensajeSis("No existe el numero de Cuenta.");
				$('#cuentaAhorro').val('');
				$('#numCtaInstit').val('');
				$('#saldo').val('');
				$('#cuentaAhorro').focus();
			}
		});
	}
   
}




//funcion para consultar el saldo de la cuenta bancaria de Tesoreria
function consultaSaldoCuentaTesoreria(numCta, institucion){
	var tipoConsulta = 10;
	var cuentaTesoreria = {
			'institucionID': institucion,
			'numCtaInstit':numCta
	};	
	cuentaNostroServicio.consulta(tipoConsulta, cuentaTesoreria, function(cuentaTeso){
		if(cuentaTeso!=null){
			$('#saldo').val(cuentaTeso.saldo);
		}
	});   
}



//Método de consulta de Institución

function consultaInstitucion(idControl) {
	var jqInstituto = eval("'#" + idControl + "'");
	var numInstituto = $(jqInstituto).val();
	var cuenta = $('#cuentaAhorro').val();

	setTimeout("$('#cajaLista').hide();", 200);	
	var InstitutoBeanCon = {
			'institucionID':numInstituto
	};

	if(numInstituto != '' && !isNaN(numInstituto) ){
		institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
			if(instituto!=null){							
				$('#nombreInstitucion').val(instituto.nombre);
				if(cuenta != ''){
					validaCuentaAhorro();
				}
			}else{
				mensajeSis("No existe la Institución");
				$('#nombreInstitucion').val('');
				$('#institucionID').val('');
				$('#institucionID').focus();				
				if(cuenta != ''){
					validaCuentaAhorro();
				}
			}    						
		});
	}
	if(isNaN(numInstituto)){
		$('#nombreInstitucion').val('');


	}
}

function subirArchivos(titulo, tipoUpload){
	var url = "cargaArchPlano.htm?" +
			"fecha=" + fecha +
			"&t1="+encoding(titulo)+
			"&t2="+encoding(titulo)+
			"&tipo="+tipoUpload;
	var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
	var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;
	ventanaArchivos = window.open(url, "PopUpSubirArchivo", "width=980,height=340,scrollbars=yes,status=yes,location=false,addressbar=false,menubar=0,toolbar=0" + 
										"left=" + leftPosition + 
										",top=" + topPosition + 
										",screenX=" + leftPosition + 
										",screenY=" + topPosition);
}

function encoding(cadena){
	return btoa(cadena);
}

function decoding(cadena){
	return atob(cadena)
}
/*Este nombre es por la funcion que ejeucta la carga de archivo*/
function consultaGridDepositosRefe(consecutivo, numeroMensaje, rutaArchivo, controlID){
	$("#"+controlID).val(rutaArchivo);
	
	if(rutaArchivo!="" && rutaArchivo!=null){
		habilitaBoton('validar','submit');
	}
	else{
		deshabilitaBoton('validar','submit');
	}
}


function pegaHtml(pageValor){
	
		var params = {};	
		params['institucionID'] = $('#institucionID').val();
		params['numCtaInstit'] =  $('#numCtaInstit').val();
		params['fechaDisp'] =  $('#fechaDisp').val();
		params['rutaArchivo'] =  $('#rutaArchivo').val();
		params['tipoTransaccion'] = 1
		params['tipoLista'] = 1;
		params['pagina'] 	= pageValor;
		/*private String cuentaAhorro;
		 * 
		 * 
		private String saldo;*/
		
		$.post("dispersionMasivaGridVista.htm", params, function(data){
			if(data.length >0 ){
				$('#gridValidacion').html(data); 
				desbloquearPantalla();
				if($('#exitoError').val() == '0'){
					habilitaBoton('procesar', 'submit');
					deshabilitaBoton('validar', 'button');
					$('#numTransaccion').val($('#transaccion').val());
				}else{
					$('#rutaArchivo').val('');
					$('#extension').val('');
					deshabilitaBoton('procesar', 'submit');
					deshabilitaBoton('validar', 'button');
				}
			}
		}); 
			 
}

/*funcion valida fecha formato (yyyy-MM-dd)*/
function esFechaValida(fecha){
	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
			return false;
		}

		var mes=  fecha.substring(5, 7)*1;
		var dia= fecha.substring(8, 10)*1;
		var anio= fecha.substring(0,4)*1;

		switch(mes){
		case 1: case 3:  case 5: case 7:
		case 8: case 10:
		case 12:
			numDias=31;
			break;
		case 4: case 6: case 9: case 11:
			numDias=30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
			break;
		default:
			mensajeSis("Fecha introducida errónea.");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida errónea.");
			return false;
		}
		return true;
	}
}
function comprobarSiBisisesto(anio){
	if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
		return true;
	}
	else {
		return false;
	}
}

function inicializa(){
	$('#institucionID').val('');
	$('#nombreInstitucion').val('');
	$('#numCtaInstit').val('');
	$('#cuentaAhorro').val('');
	$('#saldo').val('');
	$('#fechaDisp').val(parametroBean.fechaSucursal);
	$('#rutaArchivo').val('');
	$('#extension').val('');
	deshabilitaBoton('procesar', 'submit');
	deshabilitaBoton('validar', 'button');
	$('#gridValidacion').html('');
	$('#numTransaccion').val('');
	$('#tipoTransaccion').val('');
}

function exito(){
	inicializa();
}

function error(){
	
}