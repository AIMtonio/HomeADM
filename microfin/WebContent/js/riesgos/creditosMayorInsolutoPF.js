	$(document).ready(function() {	
		esTab = false;
		agregaFormatoControles('formaGenerica');
		var parametroBean = consultaParametrosSession(); 

		$('#trTotalPF').hide();
		
		var catTipoReporte = { 
				'Excel'	: 1
		};	

	   llenaComboAnios(parametroBean.fechaAplicacion);
	   
	 
	   	   
	   $('#mes').focus();
		
	   
	   consultaMayorSaldoPFGrid();
	   
	   	deshabilitaBoton('generar', 'submit');

	   $('#generar').click(function() {		
		   generaExcel();
	   });

	   
	   $('#mes').change(function (){
		   consultaMayorSaldoPFGrid();
		   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
		   var anioSeleccionado = $('#anio').val();
		   
		   if((parseInt(this.value) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
			   alert("El Mes Indicado es Mayor al Mes Actual del Sistema.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
			   limpiaFormulario();
		   }
	   });
	   
	   $('#anio').change(function (){
		   consultaMayorSaldoPFGrid();
		   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
		   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
		   var anioSeleccionado = $('#anio').val();
		   var mesSeleccionado = $('#mes').val();
		   
		   if((parseInt(mesSeleccionado) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
			   alert("El Año Indicado es Incorrecto.");
			   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
			   this.focus();
			   limpiaFormulario(); 
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
	   
	   
	   // Funcion que genera el reporte en Excel de mayor saldo insoluto del mes P.F.
	   function generaExcel(){
		   var tr= catTipoReporte.Excel; 
		   var anio = $('#anio').val();
		   var mes = $('#mes').val();
		   var nombreInstitucion =  parametroBean.nombreInstitucion; 
		   
		   $('#ligaGenerar').attr('href','credMayorInsolutoPFRep.htm?tipoReporte=' + tr + '&anio='+anio+ '&mes=' + mes+
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
	   
		//Funcion para Consultar el mayor saldo insoluto del mes P.F.
		function consultaMayorSaldoPFGrid(){
			$('#divCredMayorInsolutoPF').val('');
			$('#trTotalPF').val('');
			var params = {};		
		
			params['tipoLista'] = 1;
			params['anio'] = $('#anio').val();
			params['mes'] = $('#mes').val();
			bloquearPantallaCarga();
			$.post("credMayorInsolutoPFGrid.htm", params, function(data){
				if(data.length >0) { 
					$('#divCredMayorInsolutoPF').html(data);
					$('#divCredMayorInsolutoPF').show();
					$('#trTotalPF').show();
					agregaFormatoControles('divCredMayorInsolutoPF');
					consultaParametro();
				}else{
					$('#divCredMayorInsolutoPF').html("");
					$('#divCredMayorInsolutoPF').show();
				}			
				$('#contenedorForma').unblock();
			}); 
		}
	  
		// Consulta Parametro Persona Fisica
		function consultaParametro() {
			var consultaParametro = 2;
			var RiesgosBeanCon = {
					'anio' : $('#anio').val(),
					'mes' : $('#mes').val()
			};
			setTimeout("$('#cajaLista').hide();", 200);
			
			
			creditosMayorInsolutoPFServicio.consulta(consultaParametro, RiesgosBeanCon,function(parametro) {
				if (parametro != null) {
					var tds = "";
					tds += '<tr>';
					tds += '<td colspan="2"></td>';
					tds += '<td class="label" align="right">';
					tds += '<label for="">TOTAL:</label>';
					tds += '</td>';
					tds += '<td>';
					tds += '<input id="totalSaldoInsolutoPF" name="totalSaldoInsolutoPF" readonly="true" size="20" style="text-align: right;" > ';
					tds += '</td>';
					tds += '</tr>';
					 
			
					$("#miTabla").append(tds);   
				   
					$('#totalSaldoInsolutoPF').val(parametro.totalSaldoInsolutoPF);
					$('#totalCreditoPF').val(parametro.totalSaldoInsolutoPF);
					$('#capitalNetoMensual').val(parametro.capitalNetoMensual);
					$('#resultadoPorcentual').val(parametro.resultadoPorcentual);
					$('#parametroPorcentaje').val(parametro.parametroPorcentaje);
					
					$('#totalSaldoInsolutoPF').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
					});
					
					$('#totalCreditoPF').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});
					
					$('#capitalNetoMensual').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});

					$('#resultadoPorcentual').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});
					consultaRegistrosFila(); 
				} 
			});
		}
		
		function limpiaFormulario (){
			$('#totalSaldoInsolutoPF').val('');
			$('#totalCreditoPF').val('');
			$('#capitalNetoMensual').val('');
			$('#parametroPorcentaje').val('');
			$('#resultadoPorcentual').val('');
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
			 $('#trTotalPF').hide();
			 $('#divCredMayorInsolutoPF').html("");
			 $('#divCredMayorInsolutoPF').hide();
			 $('#totalSaldoInsolutoPF').val('');
			 $('#totalCreditoPF').val('');
			 $('#capitalNetoMensual').val('');
			 $('#parametroPorcentaje').val('');
			 $('#resultadoPorcentual').val('');
			 }
			 else{
			 	habilitaBoton('generar', 'submit');
			 }
		}	

			

