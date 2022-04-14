$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();
	$('#fechaSistema').val(parametroBean.fechaSucursal);
	agregaFormatoControles('formaGenerica');
	
	//Definicion de Constantes y Enums
	var catTipoTransConcilia = {
			'grabar':'1'
	};

	var catTipoConConcilia = {
			'principal':1,
			'foranea':2
	};
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({	
		submitHandler: function(event) {
			if (validacionGrid() != false){
				grabaFormaTransaccionConciliacionTeso(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', '');
			}
		}
	});
	
	$('#procesar').click(function () {
		$('#tipoTransaccion').val(catTipoTransConcilia.grabar);
		//realizaConciliacion();
	});
	
	
	$('#formaGenerica').validate({
		rules: {
		},
		messages: {
		}
	});

	function grabaFormaTransaccionConciliacionTeso(event, idForma, idDivContenedor, idDivMensaje, inicializaforma, idCampoOrigen) {
		var jqForma = eval("'#" + idForma + "'");
		var jqContenedor = eval("'#" + idDivContenedor + "'");
		var jqMensaje = eval("'#" + idDivMensaje + "'");
		var url = $(jqForma).attr('action');
		var resultadoTransaccion = 0;	
		quitaFormatoControles(idForma);
		//No descomentar la siguiente linea
		//event.preventDefault();
		$(jqMensaje).html('<img src="images/barras.jpg" alt=""/>');   
		$(jqContenedor).block({
			message: $(jqMensaje),
			css: {border:		'none',
				background:	'none'}
		});
		// Envio de la forma
		
		$.post( url, serializaForma(idForma), function( data ) {
			if(data.length >0) {
				$(jqMensaje).html(data);
				var exitoTransaccion = $('#numeroMensaje').val();
				resultadoTransaccion = exitoTransaccion; 
				if (exitoTransaccion == 0 && inicializaforma == 'true' ){
					inicializaForma(idForma, idCampoOrigen);
					$('#contenedorMovs').html(""); 	
					$('#contenedorMovs').hide();
					var parametroBean = consultaParametrosSession();
					$('#fechaActual').val(parametroBean.fechaSucursal);
					$(jqContenedor).block({
						message: data,
						css: {
							border:	'none',
							background:	'none'
						}
					});
					movimientos();
				}
				$(jqMensaje).html(data);
				var campo = eval("'#" + idCampoOrigen + "'");
				if($('#consecutivo').val() != 0){
					$(campo).val($('#consecutivo').val());
				}				
			}
		});
		return resultadoTransaccion;
	}
	
	
	
	movimientos();
	function movimientos(){
			var params = {};
			params['tipoLista'] = 1;
			$.post("tarDebMovsGrid.htm", params, function(data){
				if(data.length >0){
					$('#contenedorMovs').html(data);
					$('#contenedorMovs').show();
				}else{
					$('#contenedorMovs').hide();
					$('#contenedorMovs').html("");
					alert('No se han encontrado movimientos con los datos proporcionados');
				}
			});
	}

	function AgreratotalConci(){
		var filas = $('#vacio').val();
		var total=0;
		var monto=0;

		for (var i = 1; i<=filas; i++){
			var idMonto =  eval("'#MontoMov" + i + "'");
			var estatus =  eval("'status"+ i + "'");

			if(document.getElementById(estatus).checked){
				monto = $(idMonto).asNumber();  
				total = total + monto;
			}
		}
		total = total.toFixed(2);
		if(isNaN(total)){total="0.00";}
		$('#totalConciliados').val(total);
		$('#totalConciliadosVista').val(total);
		$('#totalConciliadosVista').formatCurrency({colorize: true,positiveFormat: '%n',roundToDecimalPlace: -1});
	}
	
	function AgreratotalNoConci(){
		var filas = $('#vacio').val();
		var total=0;
		var monto=0;
		for (var i = 1; i<=filas; i++){
			var idMonto =  eval("'#montoMovArch" + i + "'");
			monto = $(idMonto).asNumber();  
			total += parseFloat(monto);
		}
		total = total.toFixed(2);	
		if(isNaN(total)){total="0.00";}
		$('#totalNoConci').val(total);
		$('#totalNoConciVista').val(total);
		$('#totalNoConciVista').formatCurrency({colorize: true,positiveFormat: '%n',roundToDecimalPlace: -1});
	}
});// fin de jquery

function agregaFormatoMonto(){
	
	$('input[name=montoMov]').each(function() {		
		var jqMonto = eval("'#" + this.id  + "'");   
		$(jqMonto).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});	
	});
}

function cambiaStatus(monto,estatus){
	monto = eval("'#"+monto+"'");
	var total = $('#totalConciliados').asNumber();
	var mon = $(monto).asNumber();
	$('#totalConciliados').val("");
	if(document.getElementById(estatus).checked){
		var subtotal = parseFloat(total)+ parseFloat(mon);
		$('#totalConciliados').val(subtotal.toFixed(2));
		$('#totalConciliadosVista').val(subtotal.toFixed(2));
	}else{
		var subtotal = parseFloat(total) - parseFloat(mon);
		$('#totalConciliados').val(subtotal.toFixed(2));
		$('#totalConciliadosVista').val(subtotal.toFixed(2));
	}
	agregaFormatoControles('formaGenerica');
}

	function conciliaManual(numeroFila){
		var jqidNumeroMov =  eval("'#numeroMovArch" + numeroFila + "'");
		var jqfolioCargaIDArch = eval("'#folioCargaIDArch" + numeroFila + "'");
		var jqfolioMovExterno =  eval("'#folioMovExterno" + numeroFila + "'");
		var numTransacExt = $(jqidNumeroMov).val();
		var folioCargaIDArch = $(jqfolioCargaIDArch).val();
		var folioMovExterno = $(jqfolioMovExterno).val();
	
		if(numTransacExt!='' && numTransacExt!='0'){
			$('input[name=transaccion]').each(function() {
				var numFilaTransac =   this.id;
				var jqLista =  eval("'#status" + numFilaTransac + "'");		 
				var jqTransac = eval("'#" + this.id + "'");
				var numtransac= $(jqTransac).val();
				if(numtransac == numTransacExt && numtransac!='0' ){
					var jqFolioMovimiento=  eval("'#folioMovimiento" + numFilaTransac + "'");
					var jqNatMovimiento=  eval("'#natMovimiento" + numFilaTransac + "'");
					var jqMontoMov=  eval("'#MontoMov" + numFilaTransac + "'");
					var jqTipoMov=  eval("'#tipoMov" + numFilaTransac + "'");			
					var folioMovInter =$(jqFolioMovimiento).val();
		 			var estatusConciliado= 'C';
					var naturaleza=$(jqNatMovimiento).val();
					var monto= $(jqMontoMov).asNumber();
					var tipoMovimiento= $(jqTipoMov).val();
					var nuevaLista = folioMovInter+','+folioCargaIDArch+','+tipoMovimiento+','+estatusConciliado+','+naturaleza+','+monto;
					$(jqLista).val(nuevaLista);
					$(jqfolioMovExterno).val(numtransac);
				}else{
					if((numtransac == 0 || numtransac =='' ) && folioMovExterno!='0'){
						var jqFolioMovimiento=  eval("'#folioMovimiento" + numFilaTransac + "'");
						var jqNatMovimiento=  eval("'#natMovimiento" + numFilaTransac + "'");
						var jqMontoMov=  eval("'#MontoMov" + numFilaTransac + "'");
						var jqTipoMov=  eval("'#tipoMov" + numFilaTransac + "'");
						
						var folioMovInter =$(jqFolioMovimiento).val();
			 			var estatusNoConciliado= 'N';
						var naturaleza=$(jqNatMovimiento).val();
						var monto= $(jqMontoMov).asNumber();
						var tipoMovimiento= $(jqTipoMov).val();				
						var ListaNOConci = folioMovInter+','+'0'+','+','+estatusNoConciliado+','+naturaleza+','+monto;				
						$(jqLista).val(ListaNOConci);
					}
				}		 
			});
		}
	}

	function realizaConciliacion(){
		$('input[name=chkConciliaMov]').each(function() {
			var id = this.id.substr(14);
			if ($(this).is(':checked')){
				var jqMovID=  eval("'#chkConciliaMov" + id + "'");
				var jqLista= eval("'#transaccion" + id + "'");
				$(jqLista).val($(jqMovID).val());
			}
		});
	}

	function cambiaEstatus(idControl){
		quitaFormatoMoneda('formaGenerica');
		var id = idControl.substr(11);
		var jqCarga = eval("'#folioCarga" + id + "'");
		var jqDetalle = eval("'#folioDetalle" + id + "'");
		var jqTipoTrans = eval("'#tipoOpeArch" + id + "'");
		var jqTarjetaExt = eval("'#numTarjetaArch" + id + "'");
		var jqReferExt = eval("'#referenciaArch" + id + "'");
		var jqMontoExt = eval("'#montoMovArch" + id + "'");

		var jqConcilia = eval("'#" + idControl + "'");
		
		var numConciliaExt = $(jqConcilia).val();
		
		if (numConciliaExt != '' && numConciliaExt != 0 ){
			$('input[name=tarDebMovID]').each(function() {
				var num = this.id.substring(11);
				var numConciInt = $(this).val();

				if (numConciInt == numConciliaExt && numConciInt != 0){
					var numCargaExt = $(jqCarga).val();
					var detalleExt = $(jqDetalle).val();
					var tipoTransExt = $(jqTipoTrans).val();
					var numTarjetaExt = $(jqTarjetaExt).val();
					var referExt = $(jqReferExt).val();
					var montoExt = $(jqMontoExt).val();
							var detalleExt = $(jqDetalle).val();
					var jqValores = eval("'#chkConciliaMov" + num + "'");
					var jqMontoInt = eval("'#montoMov" + num + "'");
					var jqLista = eval("'#transaccion" + num + "'");
					
					var nuevaLista = $(jqValores).val() + ',' + $(jqMontoInt).asNumber() + ',' + numCargaExt +','+ detalleExt+ ','+ tipoTransExt + ','+
					 numTarjetaExt + ',' +  referExt + ',' + montoExt;			
					//alert(nuevaLista);
					//modificar el value del input transaccion para agregar a la lista
					$(jqLista).val(nuevaLista);
				}
			});
		}
		agregaFormatoMoneda('formaGenerica');
	}

	function validacionGrid(){
		var count = 0;
		$('input[name=chkConciliaMov]').each(function() {
			if ($(this).is(':checked')){
				count ++;
			}
		});
		if (count == 0 ){
			alert("No ha seleccionado ningun registro para conciliar");
			return false;	
		}else {
			return true;
		}
	}

	function controlCheckMov(idControl){
		var jqRegistro = eval("'#" + idControl + "'");
		var id = idControl.substring(14);
		var jqTransac = eval("'#transaccion" + id + "'");
		if(!$(jqRegistro).is(':checked')){
			$(jqTransac).val('');
		}
	}