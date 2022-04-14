$(document).ready(function() {
	esTab = true;

	agregaFormatoControles('formaGenerica');	

	//Definicion de Constantes y Enums  
	var catTipoTransaccionConciliacion = {
			'graba':'1',
			'modifica':'2',
			'elimina':'3',
			'cierre' : '4'
	};

	var catTipoConsultaConciliacion = {
			'principal':1,
			'foranea':2
	};	

	var catTipoConsultaInstituciones = {
			'principal':1, 
			'foranea':2
	};

	var catTipoConsultaSucursales = {
			'principal':1, 
			'foranea':2,
			'porCuentasAho':3
	};


	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
		esTab = false;
	});

	deshabilitaBoton('procesar');
	$('#institucionID').focus();
	
	$('#procesar').click(function(){
		$('#tipoTransaccion').val(catTipoTransaccionConciliacion.graba);
		$("#tipoLista").val(2);
	});
	
	$('#cerrar').click(function(){
		$('#tipoTransaccion').val(catTipoTransaccionConciliacion.cierre);
		$("#tipoLista").val(1);
	});
	
	$.validator.setDefaults({	
		submitHandler: function(event){
			if($('#tipoTransaccion').val() == catTipoTransaccionConciliacion.cierre){
				var confirma= confirm("¿Desea Cerrar Conciliación de Movs. Internos?");				
				if(confirma){
					grabaFormaTransaccionConciliacionTeso(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'cuentaAhorroID');
				}
			}else{
					grabaFormaTransaccionConciliacionTeso(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'cuentaAhorroID');
			}			
		}
	});		

	function grabaFormaTransaccionConciliacionTeso(event, idForma, idDivContenedor, idDivMensaje,
			 inicializaforma, idCampoOrigen) {
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
		
		if ($("#tipoLista").val() == 1) {
			var params = {};
			params['institucionID'] = $('#institucionID').val();
			params['tipoTransaccion'] = $('#tipoTransaccion').val();
			params['cuentaAhorroID'] = $('#cuentaAhorroID').val();
			params['tipoLista'] = $('#tipoLista').val();

			$.post( url, params, function( data ) {
				if(data.length >0) {
					$(jqMensaje).html(data);
					var exitoTransaccion = $('#numeroMensaje').val();
					resultadoTransaccion = exitoTransaccion; 
					var inst = $('#institucionID').val();
					var cuenta = $('#cuentaAhorroID').val();
					var nomIns = $('#nombreInstitucion').val();
					if (exitoTransaccion == 0 && inicializaforma == 'true' ){
						//inicializaForma(idForma, idCampoOrigen);
						$('#contenedorMovs').html(""); 	
						$('#contenedorMovs').hide();
						var parametroBean = consultaParametrosSession();
						$('#fechaActual').val(parametroBean.fechaSucursal);
						$('#institucionID').val(inst);
						$('#cuentaAhorroID').val(cuenta);
						$('#nombreInstitucion').val(nomIns);
						$('#cerrar').hide(250);					
						deshabilitaBoton('procesar');					
					}
					$(jqContenedor).block({
						message: data,
						css: {border:		'none',
							background:	'none'}
					});
					$(jqMensaje).html(data);
					$('#cuentaAhoID').focus();
					var campo = eval("'#" + idCampoOrigen + "'");						
					if($('#consecutivo').val() != 0){
						$(campo).val($('#consecutivo').val());
					}
				}
			});
		} else {
			$.post( url, serializaForma(idForma), function( data ) {
				if(data.length >0) {
					$(jqMensaje).html(data);
					var exitoTransaccion = $('#numeroMensaje').val();
					resultadoTransaccion = exitoTransaccion; 
					var inst = $('#institucionID').val();
					var cuenta = $('#cuentaAhorroID').val();
					var nomIns = $('#nombreInstitucion').val();
					if (exitoTransaccion == 0 && inicializaforma == 'true' ){
						//inicializaForma(idForma, idCampoOrigen);
						$('#contenedorMovs').html(""); 	
						$('#contenedorMovs').hide();
						var parametroBean = consultaParametrosSession();
						$('#fechaActual').val(parametroBean.fechaSucursal);
						$('#institucionID').val(inst);
						$('#cuentaAhorroID').val(cuenta);
						$('#nombreInstitucion').val(nomIns);
						$('#cerrar').hide(250);					
						deshabilitaBoton('procesar');					
					}
					$(jqContenedor).block({
						message: data,
						css: {border:		'none',
							background:	'none'}
					});
					$(jqMensaje).html(data);
					$('#cuentaAhoID').focus();
					var campo = eval("'#" + idCampoOrigen + "'");						
					if($('#consecutivo').val() != 0){
						$(campo).val($('#consecutivo').val());
					}
				}
			});
		}

		return resultadoTransaccion;
	}
	
	
	var parametroBean = consultaParametrosSession();
	$('#fechaActual').val(parametroBean.fechaSucursal);

	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '1', '1', 'nombre',  $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#institucionID').blur(function() {
		if($('#institucionID').val()!=""){
			consultaInstitucion(this.id);
			$('#cerrar').hide();
			$('#cuentaAhorroID').val("");
			$('#cuentaAhorroID').focus();
			$('#numCtaInstit').val("");
			$('#nombreSucurs').val("");
			$('#contenedorMovs').html("");
			$('#contenedorMovs').hide("");
			
		}else{
			$('#institucionID').focus();
		}
	});

	$('#cuentaAhorroID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionID').val();

		camposLista[1] = "cuentaAhoID";			
		parametrosLista[1] = $('#cuentaAhorroID').val();

		lista('cuentaAhorroID', '2', '2', camposLista, parametrosLista, 'tesoCargaMovLista.htm');	       
	});


	$('#cuentaAhorroID').blur(function() {	
		if($('#cuentaAhorroID').val() != '' && !isNaN($('#cuentaAhorroID').val())){
			var tipoConsulta = 9;
			var DispersionBeanCta = {
					'institucionID': $('#institucionID').val(),
					'numCtaInstit': $('#cuentaAhorroID').val()
			};
			operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
				if(data!=null){
					$('#cuentaAhorroID').val(data.numCtaInstit);
					$('#numCtaInstit').val(data.cuentaAhorro);
					$('#nombreSucurs').val(data.nombreCuentaInst);

					movimientos($('#institucionID').val(), data.numCtaInstit);
				}else{
					mensajeSis("No existe la Cuenta Especificada.");
					$('#contenedorMovs').html("");		
					$('#cuentaAhorroID').focus();		
					$('#cuentaAhorroID').select();
				}
			});
		}else{
			$('#cuentaAhorro').val("");
			$('#nombreSucurs').val("");  
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

		if(numInstituto != '' && !isNaN(numInstituto) ){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
				if(instituto!=null){							
					$('#nombreInstitucion').val(instituto.nombre);

				}else{
					mensajeSis("No existe la Institución"); 
				}    						
			});
		}
	}


	function movimientos(VarInstitucionID, VarCuentaAhorro){		
		if(!isNaN(VarCuentaAhorro)){
			var params = {};	
			params['institucionID'] = VarInstitucionID;
			params['numCtaInstit'] = VarCuentaAhorro;
			params['tipoLista'] = 1;
			$.post("movimientosGrid.htm", params, function(data){
				if(data.length >0){
					$('#contenedorMovs').html(data); 
					$('#contenedorMovs').show();
					AgreratotalConci();
					AgreratotalNoConci();
					agregaFormatoMonto();
				}else{
					$('#contenedorMovs').hide();
					$('#contenedorMovs').html(""); 
					mensajeSis('No se han encontrado movimientos con los datos proporcionados');
					$('#nombreSucurs').val("");
				}
			}); 
		}		 		
	}

	$('#formaGenerica').validate({
		rules: {
			institucionID: 'required',
			numCtaInstit: 'required'
		},

		messages: {
			institucionID: 'Especifique Institución',
			numCtaInstit: 'Cuenta Bancaria'
		}		
	});

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
		var numFilaTransac =   this.id  ;	
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
			
		}
		else{
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







