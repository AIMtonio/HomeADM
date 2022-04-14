var parametroBean = consultaParametrosSession();

$(document).ready(function() {
	/******* DEFINICION DE CONSTANTES Y NUMEROS DE CONSULTAS *******/	
	esTab = false;
	
	var catTipoTransaccionIndice = {
		'alta' : 1,
		'modifica' : 2	
	};
	
	var catTipoConsultaIndice = {
		'principal':1
	};

	var Constantes = {
		'SI' : 'S',
		'CADENAVACIA' : ''
	};

	/******* FUNCIONES CARGA AL INICIAR PANTALLA *******/
	inicializaPantalla();
	$("#anio").focus();

    /******* VALIDACIONES DE LA FORMA *******/		
	$.validator.setDefaults({
	    submitHandler: function(event) { 
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','anio', 'funcionExito', 'funcionFallo');
	      }
	});

	$('#formaGenerica').validate({			
		rules: {			
			anio: {
				required: true
			},			
			mes: {
				required: true
			},						
			valorINPC: {
				required: true,
				number: true,
				numeroPositivo: true
			}
			
		},		
		messages: {
			anio: {
				required: 	'Especifique Año.'
			},	
			mes: {
				required: 	'Especifique Mes.'
			},								
			valorINPC: {
				required: 	'Especifique Valor del Mes.',
				number: 	'Solo Números',
				numeroPositivo: 'Solo Números Positivos.',
			}					
		}
	});

	/******* MANEJO DE EVENTOS *******/		
	$(':text').focus(function() {
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#grabar').click(function() {	
		if($('#existeValor').val() == 'N'){
			$('#tipoTransaccion').val(catTipoTransaccionIndice.alta);
		}else{
			$('#tipoTransaccion').val(catTipoTransaccionIndice.modifica);
		}
	});
	
	$('#anio').change(function() {
		anio = $('#anio').val();
		mes = $('#mes').val();

		if (anio != '' && mes != '') {
			consultaMesAnio();			
		}else{
			$('#valorINPC').val('');
			$('#existeValor').val('N');
		}
	});

	$('#mes').change(function() {
		var anio = $('#anio').val();
		var mes = $('#mes').val();

		if (anio != '' && mes != '') {
			consultaMesAnio();			
		}else{
			$('#valorINPC').val('');
			$('#existeValor').val('N');
		}
	});

	$('#valorINPC').blur(function() {
		validaLimite(this);
	});

	/*******  FUNCIONES PARA VALIDACIONES DE CONTROLES *******/	
	//FUNCION PARA CONSULTAR INDICE NACIONAL DE PRECIOS AL CONSUMIDOR
	function consultaMesAnio(){
		var anio = $('#anio').val();
		var mes = $('#mes').val();
		setTimeout("$('#cajaLista').hide();", 200);
		var consultaBean = {
			'anio':anio, 
			'mes':mes
		};

		$('#existeValor').val('N');
		if(anio != Constantes.CADENAVACIA && mes != Constantes.CADENAVACIA){
			indiceNaPreConsumidorServicio.consulta(catTipoConsultaIndice.principal,consultaBean, function(indice){
				if(indice != null){
					$('#anio').val(indice.anio);
					$('#mes').val(indice.mes);
					$('#valorINPC').val(indice.valorINPC);
					$('#existeValor').val('S');
				}
				else {
					$('#valorINPC').val('');
				}				
			});
		}
	}

	//FUNCION PARA VALIDAR EL VALOR DEL MES
	function validaLimite(control){
		var vacio = 0;
		var jqCtrl = eval("'#"+ control.id + "'");
		if (control.value >= 1000 ){
			mensajeSis('El Valor del Mes debe ser Menor o Igual a Tres Números Enteros.');
			$(jqCtrl).value = vacio;
			$(jqCtrl).focus();
			$(jqCtrl).val('0.000');
		}
	}

});//FIN DOCUMENT READY

//FUNCION INICIALIZA PANTALLA
function inicializaPantalla(){
	inicializaForma('formaGenerica','anio');
	agregaFormatoControles('formaGenerica');
	$('#mes').val('');
	$('#existeValor').val('N');
	llenaComboAnios(parametroBean.fechaAplicacion,5);
}
//FUNCION DE AYUDA PARA EL REGISTRO DE INDICE NACIONAL DE PRECIOS AL CONSUMIDOR
function ayudaRegistro(){	
	var data;			       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Descripción</legend>'+
			'<table id="tablaLista">'+
				'<tr>'+
					'<td id="contenidoAyuda" align="left"><b>Importante: Favor de registrar el valor del INPC que se publica en el Diario Oficial de la Federación en los primeros diez días del mes siguiente al que corresponda.</b></td>'+
				'</tr>'+
			'</table>'+
			'</div>'+ 
			'</fieldset>'; 
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '500px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}

//FUNCION LLENA COMBO DE ANIOS
function llenaComboAnios(fechaActual, numRango){
   var anioActual = fechaActual.substring(0, 4);
   var anioMax = anioActual;
  
   for(var i=0; i < numRango; i++){
	   $('#anio').append('<option value="'+anioMax+'">'+anioMax+'</option>');
	   anioMax = parseInt(anioMax) - 1;
   }
   $("#anio").val(anioActual);
}

//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	inicializaForma('formaGenerica','anio');
	agregaFormatoControles('formaGenerica');
	$('#mes').val('');
	$('#existeValor').val('N');
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionFallo() {
	$('#valorINPC').val('');
}