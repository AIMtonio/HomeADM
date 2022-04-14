$(document).ready(function() {
	esTab = false;

	//Definicion de Constantes y Enums  
	var catTipoTransaccionParam = {
  		'alta'	:'1',
  		'modificar'	:'2'
  	};
	
	var catTipoConsultaParamEscala = {
  		'principal'	: 1,
  		'comboBox' 	: 2
	};		
		//------------ Metodos y Manejo de Eventos -----------------------------------------
		
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('historico', 'submit');

	consultaMoneda();
	consultaTiposInstrumentos();
	$('#tipoPersona').focus();
	
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
            		controlQuitaFormatoMoneda('totalRecibir');
                    grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoPersona','funcionExito','funcionFallo'); 
            }
    });	
	
	
	$('#nacMoneda').blur(function() {
		validaParamEscalamiento();
	});	
	$('#limiteInferior').blur(function() {
		$('#limiteInferior').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
	});	
	$('#rolTitular').bind('keyup',function(e){
		lista('rolTitular', '1', '2', 'nombreRol', $('#rolTitular').val(), 'listaRoles.htm');
	});
	
	$('#rolTitular').blur(function() {
		consultaTitular();
	});		
	
	$('#rolSuplente').bind('keyup',function(e){
		lista('rolSuplente', '1', '2', 'nombreRol', $('#rolSuplente').val(), 'listaRoles.htm');
	});
	
	$('#rolSuplente').blur(function() {
		consultaSuplente();
	});

	$('#agregar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionParam.alta);		
  	});
	
	$('#modificar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionParam.modificar);		
  	});
	
	$('#historico').click(function(event) {
		event.preventDefault();
		generaReporteHistorico();
	});

	$('#tipoPersona').change(function() {
		inicializaForma('formaGenerica', 'tipoPersona');
		$('#tipoInstrumento').val(1);
		$('#nacMoneda').val(0);
		$('#monedaComp').val(1);
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('agregar', 'submit');
		deshabilitaBoton('historico', 'submit');		
	});

	$('#tipoInstrumento').change(function() {
		$('#nacMoneda').val(0);
		$('#monedaComp').val(1);
		limpiaInputs();
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('agregar', 'submit');
		deshabilitaBoton('historico', 'submit');		
	});

	$('#nacMoneda').change(function() {
		$('#monedaComp').val(1);
		limpiaInputs();
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('agregar', 'submit');
		deshabilitaBoton('historico', 'submit');		
	});
	
	$('#formaGenerica').validate({					
		rules: {				
			tipoPersona: {
				required: true
			},
	
			nacMoneda: {
				required: true
			},
			
			tipoInstrumento: {
				required: true
			},
			
			limiteInferior: {
				required: true,
				maxlength:18,
				number : true					
			},
			
			monedaComp: {
				required: true
			},
			
			rolTitular: {
				required: true,
				number : true
			},
			
			rolSuplente: {
				required: true,
				number : true
			},
			
		},		
		
		messages: {		
		
			tipoPersona: {
				required: 'Especifique el Tipo de Persona.',
			},
			
			nacMoneda: {
				required: 'Especifique Nacionalidad Moneda.'
			},
			
			tipoInstrumento: {
				required: 'Especifique Tipo Instrumento.'
			},
			
			limiteInferior: {
				required: 'Especifique Monto Lím Inferior.',
				maxlength: 'Máximo 18 Caractareres.',
				number : 'Sólo Números.'
			},
			
			monedaComp: {
				required: 'Especifique Moneda Comparación.'
			},
			
			rolTitular: {
				required: 'Especifique Titular.',
				number : 'Sólo Números.'
			},
			
			rolSuplente: {
				required: 'Especifique Suplente.',
				number : 'Sólo Números.'
			},
			
		}		
	});
	
	
	//------------ Validaciones de Controles -------------------------------------
	
		function validaParamEscalamiento() {
			setTimeout("$('#cajaLista').hide();", 200);
			var tipoPerson = $('#tipoPersona').val();
			var tipoInstrum = $('#tipoInstrumento').val();
			var nacMoneda = $('#nacMoneda').val();
			esTab=true;
			if(tipoPerson != '' && tipoPerson != '0' && esTab && Number(tipoInstrum) > 0 && nacMoneda != '' && nacMoneda != '0'){
				var paramsParEscala = {
				    'tipoPersona' :  tipoPerson,
				    'tipoInstrumento' :tipoInstrum,
				    'nacMoneda' :nacMoneda
				};
				paramEscalaServicio.consulta(1,paramsParEscala,function(paramsEscala) {
						if(paramsEscala!=null){
							dwr.util.setValues(paramsEscala);	
							$('#monedaComp').val(paramsEscala.monedaComp).selected = true;
							$('#tipoPersona').val(paramsEscala.tipoPersona).selected = true;
							$('#tipoInstrumento').val(paramsEscala.tipoInstrumento).selected = true;
							$('#nacMoneda').val(paramsEscala.nacMoneda).selected = true;
							esTab=true; // es true por que al perder el foco no se produce el evento keydown en un combo
							consultaTitular();
							consultaSuplente();
							esTab=false; // se regresa a false
							$('#limiteInferior').val(paramsEscala.limiteInferior);
							deshabilitaBoton('agregar', 'submit');		
							habilitaBoton('modificar', 'submit');
							habilitaBoton('historico', 'submit');
						
						}else{
							habilitaBoton('agregar', 'submit');
							deshabilitaBoton('modificar', 'submit');
							deshabilitaBoton('historico', 'submit');
						}
				});		
			}
	}
		
		
	function consultaTitular(){
		var numRol = $('#rolTitular').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numRol != '' && !isNaN(numRol) && esTab){
			var bean = {
					rolTitular: $('#rolTitular').val()
			};
			
			escalaSolServicio.consultaRol(1,bean, function(escalamiento){
				if (escalamiento != null ){
					$('#desTitular').val(escalamiento.rolTitularDescripcion);
				}
			});
		}
	}


					
	function consultaSuplente() {
		var numRol = $('#rolSuplente').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numRol != '' && !isNaN(numRol) && esTab){
			var bean = {
				rolTitular : $('#rolSuplente').val()
			};
	
			escalaSolServicio.consultaRol(1, bean, function(escalamiento) {
				if (escalamiento != null) {
					$('#desSuplente').val(escalamiento.rolTitularDescripcion);
				}
			});
		}
	}
		
		
		

});

function consultaMoneda() {
	var tipoCon = 3;
	dwr.util.removeAllOptions('monedaComp');
	monedasServicio.listaCombo(tipoCon, function(monedas) {
		dwr.util.addOptions('monedaComp', monedas, 'monedaID',
				'descripcion');
	});
}

function consultaTiposInstrumentos() {
	var tipoCon = 2;
	dwr.util.removeAllOptions('tipoInstrumento');
	tipoInstrumServicio.listaCombo(tipoCon, function(tiposInstrum) {
		dwr.util.addOptions('tipoInstrumento', tiposInstrum, 'tipoInstruMonID',
				'descripcion');
	});
}

function generaReporteHistorico(){
	var tipoPersona=$('#tipoPersona').val();
	var tipoInstrumento=$('#tipoInstrumento').val();
	var nacMoneda=$('#nacMoneda').val();
	var tipoReporte = 1;

	var pagina ='ReporteEscalamientoHist.htm?tipoPersona='+tipoPersona+
	'&tipoInstrumento='+tipoInstrumento+
	'&nacMoneda='+nacMoneda+
	'&tipoReporte='+tipoReporte;
	window.open(pagina,'_blank');
}

function limpiaInputs(){
	$('#limiteInferior').val('');
	$('#rolTitular').val('');
	$('#desTitular').val('');
	$('#rolSuplente').val('');
	$('#desSuplente').val('');
}

function funcionExito(){
	inicializaForma('formaGenerica', 'tipoPersona');
	$('#tipoPersona').val(0);
	$('#tipoInstrumento').val(1);
	$('#nacMoneda').val(0);
	$('#monedaComp').val(1);
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('historico', 'submit');
}

function funcionFallo(){
	
}