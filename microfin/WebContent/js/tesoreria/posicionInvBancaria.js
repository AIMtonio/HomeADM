$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	deshabilitaBoton('generar', 'submit');
	var catTipoConsultaInstituciones = {
	  		'principal':1, 
	  		'foranea':2
	};
	var catTipoReporte = {
		'pdf' : 2,
		'excel':3
	};
	
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	agregaFormatoControles('formaGenerica');
	$('#tipoReporte').val(catTipoReporte.pdf);
	$('#fechaInicio').val(parametros.fechaSucursal);
	//------------ Metodos y Manejo de Eventos ----------
	$("input[name='presenta']").click(function(){
		var val = $("input[name='presenta']:checked").val();
		if (val == 1){
			$('#tipoReporte').val(catTipoReporte.pdf);
		}else if (val == 2){
			$('#tipoReporte').val(catTipoReporte.excel);
		}
	});
	// se consulta la lista de Instituciones al escribir en la caja
	$('#institucionID').bind('keyup',function(e){
    	lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
    });
    
	// si pierde el foco se consulta el nombre de la institucion
    $('#institucionID').blur(function() {
    	consultaInstitucion(this.id);
    });
    
    // se obtiene la lista de las cuentas bancarias
    $('#numCtaInstit').bind('keyup',function(e){
    	var camposLista = new Array();
		var parametrosLista = new Array();
			camposLista[0] = "institucionID";
            parametrosLista[0] = $('#institucionID').val();
            camposLista[1] = "cuentaAhoID";
            parametrosLista[1] = $('#numCtaInstit').val();
                    
		lista('numCtaInstit', '2', '2', camposLista,parametrosLista, 'tesoCargaMovLista.htm');	       
    });
    
    // se consulta 
    $('#numCtaInstit').blur(function() {
    		consultaCuentaBan(this.id);
    });
    $('#fechaInicio').blur(function(){
		esFechaValida(this.id);
    });
    $('#fechaInicio').change(function(){
    	habilitaBoton('generar','submit');
    });
    
	$('#generar').click(function() {
			quitaFormatoControles('formaGenerica');
			$('#nombreInstitucion').removeAttr('disabled');
			var tipoReporte	= $('#tipoReporte').val();
			var institucionID	= $('#institucionID').val();
			var numCtaInstit	= $('#numCtaInstit').val();
			var fechaInicio		= $('#fechaInicio').val();
			$('#ligaPDF').attr('href','RepPosicionInvBancaria.htm?institucionID='+institucionID+'&numCtaInstit='+numCtaInstit+
					'&fechaInicio='+fechaInicio+'&nomInstitucion='+parametros.nombreInstitucion+
					'&nomUsuario='+parametros.nombreUsuario+"&tipoReporte="+tipoReporte+"&nombreInstitucion="+$('#nombreInstitucion').val());		
	});
		
	$('#formaGenerica').validate({
		rules: {
			insitucionID: {
				required: true
			},
			numCtaInstit: {
				required: true
			},
			fechaInicio: {
				required: true
			},
			presenta: {
				required: true
			}
		},
		messages: {
			insitucionID: {
				required: 'Capture el No. de Institución'
			},
			numCtaInstit: {
				required: 'Capture el No. de Cuenta Bancaria'
			},
			fechaInicio: {
				required: 'Seleccione la Fecha'
			},
			presenta: {
				required: 'Seleccione el tipo de Presentación'
			}
			
		}
	});
	
	  //Método de consulta de Institución
    function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
				'institucionID':numInstituto
		};
 
		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea, InstitutoBeanCon, function(instituto){
				if(instituto!=null){
					$('#nombreInstitucion').val(instituto.nombre);
					$('#nombreCortoInstitucion').val(instituto.nombreCorto);
					$('#numCtaInstit').val('');
					deshabilitaBoton('generar','submit');
				}else{ 
					alert("No Existe la Institución");
					$('#nombreInstitucion').val('');
					$(jqInstituto).focus();
				}    						
			});
		}else{
			$('#institucionID').val('');
			$('#nombreInstitucion').val('');
			$('#numCtaInstit').val('');
			deshabilitaBoton('generar','submit');		
		}
	}
    
    // se consulta el nombre del banco de la cuenta bancaria 
    function consultaCuentaBan(idControl) {
		var jqCuentaBan= eval("'#" + idControl + "'");
		var numCuenta = $(jqCuentaBan).val();
		setTimeout("$('#cajaLista').hide();", 200);	

		var tipoConsulta = 9;
		var DispersionBeanCta = {
			'institucionID': $('#institucionID').val(),
			'numCtaInstit': numCuenta
			};
		if (numCuenta != '' && !isNaN(numCuenta) ){
		operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
			if(data!=null){
				$('#nombreBanco').val(data.nombreCuentaInst);
				if ($('#fechaInicio').val() != "" ){
						habilitaBoton('generar', 'submit');
				}				
			}else{
				alert("No existe la cuenta indicada ");
				$('#numCtaInstit').val('');
				$('#numCtaInstit').focus();
			}
		});
		}else{
			$('#numCtaInstit').val('');
			if ($('#fechaInicio').val() != "" ){
				deshabilitaBoton('generar', 'submit');
			}		
		}
	}

function esFechaValida(idControl){
var jqFecha = eval("'#" + idControl + "'");
var fecha =	$(jqFecha).val();
if (fecha != undefined && fecha != "" ){
if (/^\d{4}\/\d{2}\/\d{2}$/.test(fecha)){
alert("formato de fecha no valido (aaaa-mm-dd)");
return false;
}
var dia=parseInt(fecha.substring(8),10);
var mes=parseInt(fecha.substring(5,7),10);
var anio=parseInt(fecha.substring(0,4),10);
switch(mes){
case 1:
case 3:
case 5:
case 7:
case 8:
case 10:
case 12:
numDias=31;
break;
case 4: case 6: case 9: case 11:
numDias=30;
break;
case 2:
if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
break;
default:
alert("Fecha introducida erranea");
$(jqFecha).val('');
$(jqFecha).focus();
deshabilitaBoton('generar', 'submit');
return false;
}
if (dia>numDias || dia==0){
alert("Fecha introducida erronea");
$(jqFecha).val('');
$(jqFecha).focus();
deshabilitaBoton('generar', 'submit');
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

});