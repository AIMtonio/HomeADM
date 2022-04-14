	$(document).ready(function() {	
		esTab = true;
		agregaFormatoControles('formaGenerica');
		var parametroBean = consultaParametrosSession();
		
		var catTipoReporte = { 
				'Excel'	: 1
		};	
		
	   llenaComboAnios(parametroBean.fechaAplicacion);
	   $('#mes').focus();
	   consultaMayorSaldo3PorcGrid();
		
		deshabilitaBoton('generar', 'submit');
	   
	   $('#generar').click(function() {		
		   generaExcel();
	   });
	   
	   
	   $('#mes').change(function (){
		   consultaMayorSaldo3PorcGrid();
		   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
		   var anioSeleccionado = $('#anio').val();
		   
		   if((parseInt(this.value) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
			   alert("El Mes Indicado es Mayor al Mes Actual del Sistema.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
			   $('#capitalNetoMensual').val('');
			   $('#parametroPorcentaje').val('');
			   $('#resultadoPorcentual').val('');
		   }
	   });
	   
	   $('#anio').change(function (){
		   consultaMayorSaldo3PorcGrid();
		   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
		   var anioSeleccionado = $('#anio').val();
		   var mesSeleccionado = $('#mes').val();
		   
		   if((parseInt(mesSeleccionado) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
			   alert("El Año Indicado es Incorrecto.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
			   $('#capitalNetoMensual').val('');
			   $('#parametroPorcentaje').val('');
			   $('#resultadoPorcentual').val('');
		   }
	   });
	   
	  
		// Validaciones de la forma
	   $('#formaGenerica').validate({
		   rules: {
			   anio: 'required',
			   mes: 'required',
		   },	
		   messages: {
			   anio: 'Especifique Año.',
			   mes: 'Especifique Mes.',
		   }		
	   });  
	   
	   
	   // Funcion que genera el reporte en Excel de mayor saldo insoluto del 3.5 %
	   function generaExcel(){
		   var tr= catTipoReporte.Excel; 
		   var anio = $('#anio').val();
		   var mes = $('#mes').val();
		   
		   var nombreInstitucion =  parametroBean.nombreInstitucion; 
		   
		   $('#ligaGenerar').attr('href','credMayorInsoluto3Rep.htm?tipoReporte=' + tr + '&anio='+anio+ '&mes=' + mes+
		   		'&nombreInstitucion='+nombreInstitucion
		   );
	   };
	
	   function llenaComboAnios(fechaActual){
		   var anioActual = fechaActual.substring(0, 4);
		   var mesActual = parseInt(fechaActual.substring(5, 7));
		   var numOption = 6;
		  
		   for(var i=0; i<numOption; i++){
			   $("#anio").append('<option value="'+anioActual+'">' + anioActual + '</option>');
			   anioActual = parseInt(anioActual) - 1;
		   }
		   
		   $("#mes option[value="+ mesActual +"]").attr("selected",true);
	   }
	   
		//Funcion para Consultar el mayor saldo insoluto 3.5 %
		function consultaMayorSaldo3PorcGrid(){
			$('#divCredMayorInsoluto3Porc').val('');
			var params = {};		
		
			params['tipoLista'] = 1;
			params['anio'] = $('#anio').val();
			params['mes'] = $('#mes').val();
			
			bloquearPantallaCarga();
			
			$.post("credMayorInsoluto3Grid.htm", params, function(data){
				if(data.length >0) { 
					$('#divCredMayorInsoluto3Porc').html(data);
					$('#divCredMayorInsoluto3Porc').show();
					agregaFormatoControles('divCredMayorInsoluto3Porc');
					consultaParametro();   
				}else{
					$('#divCredMayorInsoluto3Porc').html("");
					$('#divCredMayorInsoluto3Porc').show();
				}		
				$('#contenedorForma').unblock();
			}); 
		}
		
		// Consulta Parametro Mayor Saldo Insoluto 3.5 %
		function consultaParametro() {
			var consultaParametro = 2;
			var RiesgosBeanCon = {
					'anio' : $('#anio').val(),
					'mes' : $('#mes').val()
			};
			setTimeout("$('#cajaLista').hide();", 200);
			creditosMayorInsoluto3PorcServicio.consulta(consultaParametro, RiesgosBeanCon,function(parametro) {
				if (parametro != null) {
					$('#capitalNetoMensual').val(parametro.capitalNetoMensual);
					$('#resultadoPorcentual').val(parametro.resultadoPorcentual);
					$('#parametroPorcentaje').val(parametro.parametroPorcentaje);
					
					$('#capitalNetoMensual').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
					 }); 
						
					$('#resultadoPorcentual').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
					});
					
					$('#parametroPorcentaje').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});
					consultaRegistrosFila();
				}
			});
		}	  
		
		
		 //funcion que bloquea la pantalla mientras se cargan los datos
		 function bloquearPantallaCarga() {
		 	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
		 	$('#contenedorForma').block({
		 		message : $('#mensaje'),
		 		css : {
		 			border : 'none',
		 			background : 'none'
		 		}
		 	});
		
		 }
		
		
	}); // fin ready


	 //Funcion para Consultar Filas del Grid
	  function consultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;		
		});
		return totales;
	}
	  
 	//Funcion para Consultar Registros
	  function consultaRegistrosFila(){
		var numFilas= consultaFilas();
			if(numFilas==0){
			alert('No Existe Información en el Periodo Seleccionado');
			deshabilitaBoton('generar', 'submit');
			 $('#divCredMayorInsoluto3Porc').html("");
			 $('#divCredMayorInsoluto3Porc').hide();
			 $('#capitalNetoMensual').val('');
			 $('#parametroPorcentaje').val('');
			 $('#resultadoPorcentual').val('');
		}
		else{
			 	habilitaBoton('generar', 'submit');
		}
	}	
  
