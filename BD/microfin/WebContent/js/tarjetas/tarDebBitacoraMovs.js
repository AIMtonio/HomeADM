$(document).ready(function(){
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	var catTipoCategoriaTran ={
			'procesar'	: 1
		};
	
	var horacompleta ='';
	calculaHora();	
	deshabilitaBoton('procesar','submit');
	//-----------------------Métodovalidas y manejo de eventos-----------------------
	agregaFormatoControles('formaGenerica');
	
	$.validator.setDefaults({		
	    submitHandler: function(event) {  
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','',
		    			'funcionExito',''); 
	    }
	 });
	
	$('#formaGenerica').validate({
	});
	
	$('#procesar').click(function(){
		$('#tipoTransaccion').val(catTipoCategoriaTran.procesar);		
	});
});

consultaGridCheckin();


function consultaGridCheckin() {		
	var numCon = 3;
	tarDebBitacoraMovsServicio.listaConsulta(numCon, function(checkin) {
		
		if (checkin != null){				
		var tds = '';
		tds += '<table id="tablaCheckOut" border="1">';
		tds += '<tr>';
		tds += '<td>';
		tds += '<label>No. Tarjeta </label>';
		tds += '</td>';		
		tds += '<td>';
		tds += '<label>Nombre del Cliente </label>';
		tds += '</td>';
		tds += '<td>';
		tds += '<label>No. Cuenta</label>';
		tds += '</td>';
		tds += '<td>';
		tds += '<label>Operación </label>';
		tds += '</td>';
		tds += '<td>';
		tds += '<label>Ubicación Terminal </label>';
		tds += '</td>';
		tds += '<td>';
		tds += '<label>Monto <br> Transacción </label>';
		tds += '</td>';			
		tds += '<td>';
		tds += '<label>Aplicar<br> CheckOut</label>';		
		tds += '</td>';
		tds += '<td>';
		tds += '<label>Todos</label>';
		tds += '<input type="checkbox" id="seleccionaTodos" name="seleccionaTod" onclick="selecTodoCheckout(this.id)"/>';
		tds += '</td>';
		tds += '</tr>';
		var consec = 1;
		for (var i=0; i< checkin.length; i++) {
			var idMonto = "montoTransac"+i;	
			var jqMonto  = eval("'#" + idMonto + "'");
			var auxNum =  checkin[i].numtarjeta;
			
			if (i != 0){
				var pos   = i - 1 ;
				if (auxNum == checkin[pos].numtarjeta){
					consec ++;
				}else{
					consec = 1;
				}
			}
			var tarje = checkin[i].numtarjeta.substring(12);
			$(jqMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});			
			tds +='<tr>';
			tds += '<td>';
			tds += '<input type="text" id="numtarjeta'+i+'" value="'+checkin[i].numtarjeta+'" name="numtarjeta" readonly="true"/>';
			tds += '</td>';			
			tds += '<td>';
			tds += '<input type="text" id="cliente'+i+'" value="'+checkin[i].cliente+'" name="cliente" size="45" readonly="true"/>';
			tds += '</td>';
			tds += '<td>';
			tds += '<input type="text" id="numCta'+i+'" value="'+checkin[i].numCta+'" name="numCta" size="15" readonly="true"/>';
			tds += '</td>';
			tds += '<td>';
			tds += '<input type="text" id="operacion'+i+'" value="'+checkin[i].operacion+'" name="operacion" readonly="true"/>';
			tds += '</td>';
			tds += '<td>';
			tds += '<input type="text" id="ubicaTerminal'+i+'" value="'+checkin[i].ubicaTerminal+'" name="ubicaTerminal" readonly="true" size="22"/>';
			tds += '</td>';
			tds += '<td>';
			tds += '<input type="text" id="montoTransac'+i+'" value="'+checkin[i].montoTransac+'" name="montoTransac" size="15" esMoneda="true" style="text-align: right" readonly="true"/>';			
			tds += '</td>';
			tds += '<td align="center">';
			tds += '<input type="checkbox" id="aplicaCheckout'+i+'" name="aplicaCheckout" onclick="procesaFilas()"/>';			
			tds += '</td>';		
			tds += '<td align="center">';			
			tds += '</td>';	
			tds += '<input type="hidden" id="tipoMensaje'+i+'" value="'+checkin[i].tipoMensaje+'" name="tipoMensaje" size="15" />';			
			tds += '<input type="hidden" id="origenInst'+i+'" value="'+checkin[i].origenInst+'" name="origenInst" size="15" />';			
			tds += '<input type="hidden" id="giroNegocio'+i+'" value="'+checkin[i].giroNegocio+'" name="giroNegocio" size="15" />';			
			tds += '<input type="hidden" id="puntoEntrada'+i+'" value="'+checkin[i].puntoEntrada+'" name="puntoEntrada" size="15"/>';
			tds += '<input type="hidden" id="checkin'+i+'" value="'+checkin[i].checkIn+'" name="checkin" size="15" />';
			tds += '<input type="hidden" id="codigoAprobacion'+i+'" value="'+checkin[i].codigoAprobacion+'" name="codigoAprobacion" size="15" />';
			tds += '<input type="hidden" id="referencia'+i+'" value="'+tarje + consec + checkin[i].codigoAprobacion+'" name="referencia" size="20" readonly="true" />';
			tds += '<input type="hidden" id="fechaSistema'+i+'" value="'+checkin[i].fechaSistema+'" name="fechaSistema" size="15" />';
			tds += '<input type="hidden" id="codigoMonOpe'+i+'" value="'+checkin[i].codigoMonOpe+'" name="codigoMonOpe" size="15" />';
			tds += '<input type="hidden" id="esIsotrx'+i+'" value="'+checkin[i].esIsotrx+'" name="esIsotrx"/>';
			tds += '<input type="hidden" id="tarDebMovID'+i+'" value="'+checkin[i].tarDebMovID+'" name="tarDebMovID"/>';
			tds += '<input type="hidden" id="listTransaccCheckout'+i+'" value="" name="listTransaccCheckout" size="15" />';
			tds +='</tr>';
		}
					
		tds += '</table>';
		$('#tableCheckOut').html(tds);		
		habilitaBoton('procesar','submit');
			if(i == 0){			
				deshabilitaBoton('procesar','submit');
			}
		}// diferente de null
		
});	
}

//Concatena los registros seleccionados


function procesaFilas(){
	
			$('input[name=numtarjeta]').each(function(){
			var i = this.id.substring(10);
		  	var jqAplicaCheckout = eval("'#aplicaCheckout" + i + "'");
		  	var jqListTransaccCheckout = eval("'#listTransaccCheckout"+i+"'");
		  	var jqNumtarjeta = eval("'#numtarjeta" + i + "'");
		  	var jqNumCta = eval("'#numCta" + i + "'");
		  	var jqOperacion = '00';
		  	var jqUbicaTerminal = eval("'#ubicaTerminal" +i +"'");
		  	var jqMontoTransac = eval("'#montoTransac"+ i+ "'");
		  	var jqTipoMensaje = eval("'#tipoMensaje"+i+"'");
		  	var jqOrigenInst = eval("'#origenInst"+i+"'");
		  	var jqGiroNegocio = eval("'#giroNegocio"+i+"'");
		  	var jqCheckin = eval("'#checkin"+i+"'");
		  	var jqCodigoAprobacion = eval("'#codigoAprobacion"+i+"'");
		  	var jqFechaSistema = eval("'#fechaSistema"+i+"'");
		  	var jqCodigoMonOpe = eval("'#codigoMonOpe"+i+"'");
		  	var jqPuntoEntrada = eval("'#puntoEntrada"+i+"'");
		  	var jqReferencia = eval("'#referencia"+i+"'");
		  	var jqIsotrx = eval("'#esIsotrx"+i+"'");
		  	var jqtarDebMovID = eval("'#tarDebMovID"+i+"'");

		  	var cadena = $(jqNumtarjeta).val()+'&'+
		  					$(jqNumCta).val()+'&'+
		  					jqOperacion+'&'+
		  					$(jqUbicaTerminal).val().replace('&','')+'&'+
		  					$(jqMontoTransac).val()+'&'+
		  					$(jqTipoMensaje).val()+'&'+
		  					$(jqOrigenInst).val()+'&'+
		  					$(jqGiroNegocio).val()+'&'+
		  					$(jqCheckin).val()+'&'+
		  					$(jqCodigoAprobacion).val()+'&'+
		  					$(jqFechaSistema).val()+horacompleta+'&'+
		  					$(jqCodigoMonOpe).val()+'&'+		  					
		  					$(jqPuntoEntrada).val()+'&'+
		  					$(jqReferencia).val() +'&'+
							$(jqIsotrx).val()+'&'+
		  					$(jqtarDebMovID).val();
		  	if( $(jqAplicaCheckout).is(":checked") ){
		  		$(jqListTransaccCheckout).val(cadena);
		  	}
		  	else{
		  		$(jqListTransaccCheckout).val('');
		  		$("#seleccionaTodos").removeAttr('checked');
		  		}
	  });
		
	}

//Selecciona todos los registros del grid

function selecTodoCheckout(idControl){
	var jqSelec  = eval("'#" + idControl + "'");
	if ($(jqSelec).is(':checked') == true){
		$('input[name=aplicaCheckout]').each(function () {
			$(this).attr('checked', 'true');
		});
	}else {
		$('input[name=aplicaCheckout]').each(function () {
			$(this).removeAttr('checked');
		});
	}
	procesaFilas();
}

function calculaHora(){
	var fecha=new Date();
	var hora=fecha.getHours();
	var minuto = fecha.getMinutes();
	var segundo = fecha.getSeconds(); 
	if (hora<=9){
		hora = "0" + hora;
	}		 
	if (minuto<=9){
			minuto = "0" + minuto;
	}			 
	if (segundo<=9){
			segundo = "0" + segundo;
	}			
	horacompleta = hora+":"+minuto+":"+segundo;
	setTimeout("calculaHora()",1000) ;	
	}

function funcionExito(){
	consultaGridCheckin();
	deshabilitaBoton('procesar','submit');
}