	$(document).ready(function() {	
		esTab = true;
		agregaFormatoControles('formaGenerica');
		var parametroBean = consultaParametrosSession();
		$('#trTotalPM').hide();
		
		var catTipoReporte = { 
				'Excel'	: 1
		};	
				
			
	   llenaComboAnios(parametroBean.fechaAplicacion);
	   $('#mes').focus();
		
	   consultaMayorSaldoPMGrid();
	   
		deshabilitaBoton('generar', 'submit');
	   
	   $('#generar').click(function() {		
		   generaExcel();
	   });
	   
	   
	   $('#mes').change(function (){
		   consultaMayorSaldoPMGrid();
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
		   consultaMayorSaldoPMGrid();
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
	   
	   
	   // Funcion que genera el reporte en Excel de mayor saldo insoluto del mes P.M.
	   function generaExcel(){
		   var tr= catTipoReporte.Excel; 
		   var anio = $('#anio').val();
		   var mes = $('#mes').val();
		   
		   var nombreInstitucion =  parametroBean.nombreInstitucion; 
		   
		   $('#ligaGenerar').attr('href','credMayorInsolutoPMRep.htm?tipoReporte=' + tr + '&anio='+anio+ '&mes=' + mes+
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
	   
		//Funcion para Consultar el mayor saldo insoluto del mes P.M.
		function consultaMayorSaldoPMGrid(){
			$('#divCredMayorInsolutoPM').val('');
			$('#trTotalPM').val('');
			var params = {};		
		
			params['tipoLista'] = 1;
			params['anio'] = $('#anio').val();
			params['mes'] = $('#mes').val();
			
			bloquearPantallaCarga();
			
			$.post("credMayorInsolutoPMGrid.htm", params, function(data){
				if(data.length >0) { 
					$('#divCredMayorInsolutoPM').html(data);
					$('#divCredMayorInsolutoPM').show();
					$('#trTotalPM').show();
					agregaFormatoControles('divCredMayorInsolutoPM');
					consultaParametro();
				}else{
					$('#divCredMayorInsolutoPM').html("");
					$('#divCredMayorInsolutoPM').show();
				}	$('#contenedorForma').unblock();		
			}); 
		}
		// Consulta Parametro Persona Moral
		function consultaParametro() {
			var consultaParametro = 2;
			var RiesgosBeanCon = {
					'anio' : $('#anio').val(),
					'mes' : $('#mes').val()
			};
			setTimeout("$('#cajaLista').hide();", 200);
			creditosMayorInsolutoPMServicio.consulta(consultaParametro, RiesgosBeanCon,function(parametro) {
				if (parametro != null) {
					
					var tds = "";
					tds += '<tr>';
					tds += '<td colspan="2"></td>';
					tds += '<td class="label" align="right">';
					tds += '<label for="">TOTAL:</label>';
					tds += '</td>';
					tds += '<td>';
					tds += '<input id="totalSaldoInsolutoPM" name="totalSaldoInsolutoPM" readonly="true" size="20" style="text-align: right;" > ';
					tds += '</td>';
					tds += '</tr>';
					 
			
					$("#miTabla").append(tds);  
					
					$('#totalSaldoInsolutoPM').val(parametro.totalSaldoInsolutoPM);
					$('#totalCreditoPM').val(parametro.totalSaldoInsolutoPM);
					$('#capitalNetoMensual').val(parametro.capitalNetoMensual);
					$('#resultadoPorcentual').val(parametro.resultadoPorcentual);
					$('#parametroPorcentaje').val(parametro.parametroPorcentaje);
					
					$('#totalSaldoInsolutoPM').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
					});
					
					$('#totalCreditoPM').formatCurrency({
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
		
		function limpiaFormulario () {
			$('#totalSaldoInsolutoPM').val('');
			$('#totalCreditoPM').val('');
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
				 $('#trTotalPM').show();
				 $('#divCredMayorInsolutoPM').html("");
				 $('#divCredMayorInsolutoPM').show();
				 $('#totalSaldoInsolutoPM').val(0);
				 $('#totalCreditoPM').val(0);
				 $('#capitalNetoMensual').val(0);
				 $('#parametroPorcentaje').val(0);
				 $('#resultadoPorcentual').val(0);

				 $('#totalSaldoInsolutoPM').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
					});
					
					$('#totalCreditoPM').formatCurrency({
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


				
			}
			else
			{
				habilitaBoton('generar', 'submit');
			}
		}	

