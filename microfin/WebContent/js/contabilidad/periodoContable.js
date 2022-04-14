$(document).ready(function() {
	// Definicion de Constantes y Enums	
	esTab = true;
	varEjercicio = 0;
	var catTipoListaPeriodoConta = {
		'principal':1
	};
	var catTipoConsultaPeriodoConta = {
		'vigente':1
	};
	var catTipoPeriodo = {
		'mensual': 'M',
		'bimestral': 'B',
		'trimestral': 'T'
	};
	var catTipoEjercicio = {
		'semestral': 'S',
		'anual': 'A',
		'bienal': 'B',
		'trienal': 'T'
	};
	
	var parametroBean = consultaParametrosSession();	
	deshabilitaBoton('Graba', 'submit');
   agregaFormatoControles('formaGenerica');
   $('#tipoEjercicio').val(catTipoEjercicio.anual);   
   consultaEjercicio();	
   
	//------------ Metodos y Manejo de Eventos -----------------------------------------
			
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
         	// grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','inicioEjercicio'); 
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','inicioEjercicio', 'funcionExito', 'funcionFallo');
			}
    });			

	
	$('#inicioEjercicio').change(function() {
		var fecha= $('#inicioEjercicio').val(); 	
	     esFechaValida(fecha);

	});
	
	$('#finEjercicio').change(function() {
		var fecha= $('#finEjercicio').val(); 	
	     esFechaValida(fecha);

	});
	
	
	$('#Periodos').click(function() {
		// Si el ejercicio no existe entonces es aun Alta de Periodos 
		
		if($('#inicioEjercicio').val() != '' && $('#finEjercicio').val() != ''){
			
		
		if(varEjercicio==0){
		
			var numPeriodos = diferenciaDias($('#inicioEjercicio').val(),
														$('#finEjercicio').val());
					
			var diasPeriodo = 0;
			var tipoPeriodo = $('#tipoPeriodo').val();
			var mesSumar =0;		
			if(tipoPeriodo==catTipoPeriodo.mensual){
				diasPeriodo = 30;
				mesSumar = 1;
			} 
			if(tipoPeriodo==catTipoPeriodo.bimestral){
				diasPeriodo = 60;
				mesSumar = 2;
			} 
			if(tipoPeriodo==catTipoPeriodo.trimestral){
				diasPeriodo = 90;
				mesSumar = 3;
			} 		
			numPeriodos = Math.round(numPeriodos/diasPeriodo);
			var tds = '';
			$("#miTabla").html(tds);
			var fechaPerIni = '';
			var fechaPerFin = '';				
			var mes = parseInt(($('#inicioEjercicio').val()).substring(5, 7));
			var anio = parseInt(($('#inicioEjercicio').val()).substring(0, 4));		
			var mesStr = String(mes);
			//La Primer Fecha de Inicio del Periodo
			if(mes<=9){
				mesStr = '0'+String(mes);
			}else{
				mesStr = String(mes);
			}
			fechaPerIni = String(anio) + '-' + String(mesStr) + '-' + '01';
					
			tds ='<table border="0"><tbody><tr><td class="label" align="center"><label for="plaInferior">' + 
					'Inicio del Periodo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
					'</label></td><td>' + 
					'<label for="plaSuperior" align="center">Fin del Periodo</label></td></tr>';
			for (i=1; i<=numPeriodos; i++){
							
				if(i==1){
					mes = mes+mesSumar-1;
				}else{
					mes = mes+mesSumar;
				}
				if (mes>12){
					anio = anio+1;
					mes = mes-12;
				}			
				mesStr = completaCerosMes(mes)
							
				fechaPerFin = String(anio) + '-' + String(mesStr) + '-' + ultimoDiaDelMes(mes, anio);
				
				tds += '<tr>';	
				tds += '<td align="center"><input type="text" size="12" name="periodoIni" id="periodoIni'+i+'" value="'+fechaPerIni+'" readOnly /></td>';
				tds += '<td align="center"><input type="text" size="12" name="periodoFin" id="periodoFin'+i+'" value="'+fechaPerFin+'" readOnly /></td>';
				tds += '</tr>';
				if (mes<12){
					fechaPerIni = String(anio) + '-' + completaCerosMes(mes+1) + '-' + '01';
				}else{
					fechaPerIni = String(anio+1) + '-' + '01' + '-' + '01';
				}			
			}
			tds += '</tbody></table>';
			$("#miTabla").html(tds);
		}else{ // Los Periodos Ya Existen
			consultaPeriodos();
		}
		
		}else{ 
			alert("Favor de Revisar los Periodos del Ejercicio");
		}
		
	});
		         
	function alCambiarEjercicio(){
		var mesesEjercicio = 0;
		var fechaFinEjer = '';
		var tipoEjercicio = $('#tipoEjercicio').val();		
		if(tipoEjercicio==catTipoEjercicio.semestral){
			mesesEjercicio = 6;
		} 
		if(tipoEjercicio==catTipoEjercicio.anual){
			mesesEjercicio = 12;
		} 
		if(tipoEjercicio==catTipoEjercicio.bienal){
			mesesEjercicio = 24;
		}
		if(tipoEjercicio==catTipoEjercicio.trienal){
			mesesEjercicio = 36;
		}
		var mes = parseInt(($('#inicioEjercicio').val()).substring(5, 7));
		var anio = parseInt(($('#inicioEjercicio').val()).substring(0, 4));
		for(i=1;i<mesesEjercicio;i++){
			if (mes<=11){
				mes = mes+1; 
			}else{
				anio = anio+1;
				mes = 1;
			}				
		}
		var mesStr = "";
		if(mes<=9){
			mesStr = '0' + String(mes); 
		}else{
			mesStr = String(mes);
		}
		fechaPerFin = String(anio) + '-' + String(mesStr) + '-' + ultimoDiaDelMes(mes, anio);
		$('#finEjercicio').val(fechaPerFin);
	}
	
	$('#tipoEjercicio').change(function(){		
		alCambiarEjercicio();
	});

	$('#Graba').click(function(event) {
		creaPeriodosConta();
		if($('#listPeriodoIni').val()==''){
			alert("Favor de Revisar los Periodos del Ejercicio");
			$('#Periodos').focus();
			event.preventDefault();
		}
		
	});
	
	$('#formaGenerica').validate({
		rules: {
			inicioEjercicio: { 
				required : true,
			  
			   	
			},
			finEjercicio: { 
				required : true,
			
			
	}
		},
		messages: { 			
			inicioEjercicio: {
				required : 'Especifique Fecha Inicio del Ejercicio',
				
			},
			finEjercicio: {
				required : 'Especifique Fecha Fin del Ejercicio',
			
		}
		}		
	});
			
			
	function consultaEjercicio(){
		var tipoConsulta = catTipoConsultaPeriodoConta.vigente;		
		var ejercicioContableBean = {
      	'tipoEjercicio':0,
      	'inicioEjercicio':'1900-01-01',
      	'finEjercicio':'1900-01-01'
      };				
		ejercicioContableServicio.consulta(tipoConsulta, ejercicioContableBean, function(ejercicioContable){				
			if(ejercicioContable!=null){
				$('#inicioEjercicio').val(ejercicioContable.inicioEjercicio);							
				$('#finEjercicio').val(ejercicioContable.finEjercicio);
				varEjercicio = ejercicioContable.numeroEjercicio;
				deshabilitaBoton('Graba', 'submit');
			}else{
				$('#inicioEjercicio').val('');							
				$('#finEjercicio').val('');
				varEjercicio = 0;				
				habilitaBoton('Graba', 'submit');				
				//Consulta el Inicio del Periodo Default				
				$('#inicioEjercicio').val(parametroBean.fechaAplicacion.substring(0, 4) + '-' + '01' + '-' + '01');						
			}
			alCambiarEjercicio();
		});	
	}
	
	function consultaPeriodos(){
		var params = {};
		params['tipoLista'] = catTipoListaPeriodoConta.principal;
		params['numeroEjercicio'] = varEjercicio;
		
		$.post("listaPeriodosContables.htm", params, function(data){
				if(data.length >0) {
					$('#miTabla').html(data);
					$('#miTabla').show();
				}else{
					$('#miTabla').html("");
					$('#miTabla').show();
				}
		});
	}
	
	function completaCerosMes(mes){
		var mesString = '';
		if(mes<=9){
			mesString = '0' + String(mes); 
		}else{
			mesString = String(mes);
		}
		return mesString;
	}

	function creaPeriodosConta(){		
		var contador = 1;	
		$('#listPeriodoIni').val("");
		$('#listPeriodoFin').val("");		
		
		$('input[name=periodoIni]').each(function() {					
			if (contador != 1){
				$('#listPeriodoIni').val($('#listPeriodoIni').val() + ','  + this.value);
				
			}else{
				$('#listPeriodoIni').val(this.value);
				
			}
			contador = contador + 1;
			
		});
		contador = 1;
		$('input[name=periodoFin]').each(function() {
			if (contador != 1){
				$('#listPeriodoFin').val($('#listPeriodoFin').val() + ','  + this.value);
			
			}else{
				$('#listPeriodoFin').val(this.value);
				
			}
			contador = contador + 1;
			
		});
		
	}
	
	function esFechaValida(fecha){
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("Formato de Fecha No Válido (aaaa-mm-dd)");
				consultaEjercicio();
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
				alert("Fecha introducida errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea.");
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

function funcionExito(){
	deshabilitaBoton('Graba', 'submit');		
	
}

