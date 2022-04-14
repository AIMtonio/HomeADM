
// DECLARACION DE VARIABLES 
var parametroBean = consultaParametrosSession();
var usuarioBean		= parametroBean.numeroUsuario;
var fechaSucursal 	= parametroBean.fechaSucursal;
var estatusSimulacion = false;
esTab = true;	
var calculosRea = 0;
// Definicion de Constantes y Enums
var catTipoTransaccionCredito = {
		'agrega' : '1',
		'modifica' : '2',
		'simulador' : '9'
};

var catTipoConsulta = {
		'principal' : 1,
		'foranea' : 2,
		'prodSinLin' : 3
};

var catTipoConsultaSeg = {
		'principal' : 1,
		'mueble' : 2,
		'vida' : 3
};

var listaPersBloqBean = {
		'estaBloqueado'	:'N',
		'coincidencia'	:0
};
var esCliente 			='CTE';
$(document).ready(function() {
	parametroBean = consultaParametrosSession();
	esTab = true;	
	calculosRea = 0;
	// Definicion de Constantes y Enums
	catTipoTransaccionCredito = {
			'agrega' : '1',
			'modifica' : '2',
			'simulador' : '9'
	};
	
	catTipoConsulta = {
			'principal' : 1,
			'foranea' : 2,
			'prodSinLin' : 3
	};
	
	listaPersBloqBean = {
			'estaBloqueado'	:'N',
			'coincidencia'	:0
	};
	esCliente 			='CTE';
	// ------------ Metodos y Manejo de Eventos -----------------------------------------
	
	// METODO PARA INICIALIZAR EL FORMULARIO
	inicializaFormulario();
	
	$(':text').focus(function() {
		esTab = false;
	});
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	// ------------ SUBMIT DE FORMULARIO -----------------------------------------
	$.validator.setDefaults({submitHandler : function(event) {	
		if(($("#tipoTransaccion").val() == 1 || $("#tipoTransaccion").val() == 2) && estatusSimulacion == false){
			mensajeSis("Se Requiere Simular las Amortizaciones.");
		}
		else{
			//procedeSubmit = validaCamposRequeridos();
			procedeSubmit = 0;
			if (procedeSubmit == 0) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma','mensaje', 'true', 'arrendaID', 
						'arrendaAccionExitoso','arrendaAccionFallo');					
			
			}
		}
	}
	});
	
	
	$('#agrega').click(function() {
		var solCre = $('#solicitudCreditoID').val();
		if (solCre > 0) {
			habilitaControl('direccionBen');
		} 
		$('#tipoTransaccion').val(catTipoTransaccionCredito.agrega);
	});
	
	$('#modifica').click(function() {
		var solCre = $('#arrendaID').val();
		if (solCre > 0) {
			habilitaControl('direccionBen');
		}
		$('#tipoTransaccion').val(
				catTipoTransaccionCredito.modifica);
	});
	
	$('#arrendaID').bind('keyup',function(e) {
		lista('arrendaID', '2', '1','arrendaID', $('#arrendaID').val(),'arrendamientosLista.htm');
	});
	
	$('#arrendaID').blur(function() {
		consultaArrendamiento($('#arrendaID').asNumber());
	});
	
	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '3', '1', 'nombreCompleto',$('#clienteID').val(),'listaCliente.htm');
	});
	
	$('#clienteID').blur(function() {
		if(($('#clienteID').val()!='0' && $('#clienteID').val()!='') && esTab){
			var clienteBloq = $('#clienteID').asNumber();
			if(clienteBloq>0){
				listaPersBloqBean = consultaListaPersBloq(clienteBloq, esCliente, 0, 0);
				if(listaPersBloqBean.estaBloqueado!='S'){
					consultaCliente(this.id);
				} else {
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operacion.');
					$('#clienteID').focus();
					$('#clienteID').val('');
					$('#nombreCliente').val('');
				}
			}
		} else if ($('#clienteID').val() == '0') {
			mensajeSis('Cliente no válido');
			$('#clienteID').focus();
			$('#clienteID').val('');
			$('#nombreCliente').val('');
		}
	});
	
	$('#productoArrendaID').bind('keyup',function(e) {
		lista('productoArrendaID', '2', '1','productoArrendaID', $('#productoArrendaID').val(),'productoArrendaLista.htm');
	});
	
	$('#productoArrendaID').blur(function() {
		if(($('#productoArrendaID').val()!='0' || $('#productoArrendaID').val()!='') && esTab){
			consultaProductoArrenda($('#productoArrendaID').val());
		}		
	});
	
	$('#seguroArrendaID').bind('keyup',function(e) {
		lista('seguroArrendaID', '2', '2','seguroArrendaID', $('#seguroArrendaID').val(),'segurosArrendaLista.htm');
	});
	
	$('#seguroArrendaID').blur(function() {
		if(($('#seguroArrendaID').asNumber() >0) && esTab){
			consultaSegurosArrenda($('#seguroArrendaID').val());
		}else{
			$('#seguroArrendaID').val(1);
			consultaSegurosArrenda($('#seguroArrendaID').val());
		}
	});
	$('#seguroVidaArrendaID').bind('keyup',function(e) {
		lista('seguroVidaArrendaID', '2', '3','seguroVidaArrendaID', $('#seguroVidaArrendaID').val(),'segurosVidaArrendaLista.htm');
	});
	
	$('#seguroVidaArrendaID').blur(function() {
		if(($('#seguroVidaArrendaID').asNumber()>0) && esTab){
			consultaSegurosVidaArrenda($('#seguroVidaArrendaID').val());
		}else{
			$('#seguroVidaArrendaID').val(1);
			consultaSegurosVidaArrenda($('#seguroVidaArrendaID').val());
		}
	});
	
	$('#montoArrenda').blur(function() {
		if($('#montoArrenda').asNumber()>='0' ){
			calculaValores($('#porcEnganche').asNumber(),$('#montoEnganche').asNumber(), 'montoArrenda');
		}		
	});
	$('#porcEnganche').blur(function() {
		if($('#porcEnganche').asNumber()>='0' ){
			calculaValores($('#porcEnganche').asNumber(),0 ,'porcEnganche' );
		}		
	});
	$('#cantRentaDepo').blur(function() {
		if($('#cantRentaDepo').asNumber()>='0' ){
			calculaValores($('#porcEnganche').asNumber(),$('#montoEnganche').asNumber(), 'cantRentaDepo');
		}		
	});
	$('#montoEnganche').blur(function() {
		if($('#montoEnganche').asNumber()>='0' ){
			calculaValores(0,$('#montoEnganche').asNumber(),'montoEnganche');
		}		
	});
	$('#otroGastos').blur(function() {
		if($('#otroGastos').asNumber()>='0' ){
			calculaValores($('#porcEnganche').asNumber(),$('#montoEnganche').asNumber(),'otroGastos');
		}		
	});
	$('#montoComApe').blur(function() {
		if($('#montoComApe').asNumber()>='0' ){
			calculaValores($('#porcEnganche').asNumber(),$('#montoEnganche').asNumber(),'montoComApe');
		}		
	});
	$('#montoDeposito').blur(function() {
		if($('#montoDeposito').asNumber()>='0' ){
			calculaValores($('#porcEnganche').asNumber(),$('#montoEnganche').asNumber(),'montoDeposito');
		}		
	});
	$('#montoSeguroAnual').blur(function() {
		if($('#montoSeguroAnual').asNumber()>'0' ){
			calculaValores($('#porcEnganche').asNumber(),$('#montoEnganche').asNumber(),'montoSeguroAnual');
		}		
	});
	$('#montoSeguroVidaAnual').blur(function() {
		if($('#montoSeguroVidaAnual').asNumber()>'0' ){
			calculaValores($('#porcEnganche').asNumber(),$('#montoEnganche').asNumber(),'montoSeguroVidaAnual');
		}		
	});
	$('#tipoPagoSeguro').change(function() {
		if($('#tipoPagoSeguro').asNumber()>'0' ){
			calculaValores($('#porcEnganche').asNumber(),$('#montoEnganche').asNumber(),'tipoPagoSeguro');
		}		
	});
	$('#tipoPagoSeguroVida').change(function() {
		if($('#tipoPagoSeguroVida').asNumber()>'0' ){
			calculaValores($('#porcEnganche').asNumber(),$('#montoEnganche').asNumber(),'tipoPagoSeguroVida');
		}		
	});
	$('#plazo').blur(function() {
		if($('#plazo').asNumber()>'0' ){
			calculaValores($('#porcEnganche').asNumber(),$('#montoEnganche').asNumber(),'plazo');
		}		
	});
	$('#tasaFijaAnual').blur(function() {
		if($('#tasaFijaAnual').asNumber()>'0' ){
			calculaValores($('#porcEnganche').asNumber(),$('#montoEnganche').asNumber(),'tasaFijaAnual');
		}
	});
	
	$('#fechaInhabil1').click(function() {
		$('#fechaInhabil2').attr('checked', false);
		$('#fechaInhabil1').attr('checked', true);
		$('#fechaInhabil').val("S");
		$('#fechaInhabil1').focus();
	});
	
	$('#fechaInhabil2').click(function() {
		$('#fechaInhabil1').attr('checked', false);
		$('#fechaInhabil2').attr('checked', true);
		$('#fechaInhabil').val("S");
		$('#fechaInhabil2').focus();
	});
	
	$('#rentaAnticipadaS').click(function() {
		$('#rentaAnticipadaN').attr('checked', false);
		$('#rentaAnticipadaS').attr('checked', true);
		$('#rentaAnticipada').val("S");
		$('#rentaAnticipadaS').focus();
	});
	
	$('#rentaAnticipadaN').click(function() {
		$('#rentaAnticipadaS').attr('checked', false);
		$('#rentaAnticipadaN').attr('checked', true);
		$('#rentaAnticipada').val("N");
		$('#rentaAnticipadaN').focus();
	});
	
	$('#adelantoPri').click(function() {
		$('#adelantoUlt').attr('checked', false);
		$('#adelantoPri').attr('checked', true);
		$('#adelanto').val("P");
		$('#adelantoPri').focus();
	});
	
	$('#adelantoUlt').click(function() {
		$('#adelantoPri').attr('checked', false);
		$('#adelantoUlt').attr('checked', true);
		$('#adelanto').val("U");
		$('#adelantoUlt').focus();
	});
	
	$('#diaPagoProd1').click(function() {					
		$('#diaPagoProd2').attr('checked',false);
		$('#diaPagoProd1').attr('checked',true);
		$('#diaPagoProd').val('F');
		$('#diaPagoProd1').focus();
	});
	
	$('#diaPagoProd2').click(function() {					
		$('#diaPagoProd1').attr('checked',false);
		$('#diaPagoProd2').attr('checked',true);
		$('#diaPagoProd').val('A');
		$('#diaPagoProd2').focus();
	});

	$('#simular').click(function() {
		simuladorPagos(); // SE MANDA A LLAMAR A METODO DEL SIMULADOR	
	});
	
	$("#fechaApertura").change(function (){
		this.focus();
	});
	
	$("#fechaApertura").blur(function (){
		var dias  =  restaFechas(parametroBean.fechaAplicacion, this.value);
		if(parseInt(dias) < 0 ){
			mensajeSis("La Fecha de Apertura No debe ser Menor a la Fecha del Sistema.");
			this.value= parametroBean.fechaAplicacion ;
			this.focus();
		}
	});
	
	$('#rentasAdelantadas').bind('keyup mouseup', function () {
		if ($(this).val() != '' && $(this).val() != 0) {
			habilitaControl('adelantoPri');
			habilitaControl('adelantoUlt');
		} else {
			deshabilitaControl('adelantoPri');
			deshabilitaControl('adelantoUlt');
			$('input[name="adelantos"]').removeAttr("checked");
		}
	});
	
	// ------------ Validaciones de la Forma
	// -------------------------------------
	
	$('#formaGenerica').validate({
		rules : {
			clienteID : {
				required : true
			},
			fechaApertura : {
				required : true,
				date : true
			},
			fechaUltimoVen : {
				required : true,
				date : true
			},
			montoArrenda : {
				required : true,
				number: true
			},
			montoResidual : {
				required : true,
				number: true
			},
			tasaFijaAnual : {
				required : true,
				number: true
			},
			montoSeguroAnual : {
				number: true
			},
			montoSeguroVidaAnual : {
				number: true
			},
			plazo : {
				required : true,
				numeroMayorCero : true
			},
			productoArrendaID : 'required',
			fechaApertura : 'required',
			frecuenciaPlazo : 'required',
			tipoArrenda : 'required',
			
			ivaMontoArrenda : 'required',
			montoEnganche : 'required',
			ivaEnganche : 'required',
			porcEnganche : 'required',
			montoFinanciado : 'required',

			fechaRegistro : 'required',
			fechaPrimerVen : 'required',
			montoRenta : 'required',
			totalPagoInicial:'required',
			rentasAnticipada : {
				required : true
			},
			rentasAdelantadas : {
				required : true
			},
			concRentaAnticipada : {
				required : true
			},
			concIvaRentaAnticipada : {
				required : true
			},
			concRentasAdelantadas : {
				required : true
			},
			concIvaRentasAdelantadas : {
				required : true
			}
		},
		messages : {
			clienteID : {
				required : 'Especificar cliente'
			},
			fechaApertura : {
				required : 'Especificar Fecha',
				date : 'Fecha Incorrecta'
			},
			fechaUltimoVenien : {
				required : 'Especificar Fecha',
				date : 'Fecha Incorrecta'
			},
			montoArrenda : {
				required : 'Especificar Monto',
				number : 'Ingrese un monto válido'
			},
			montoResidual : {
				required : 'Especificar monto Residual',
				number : 'Ingrese un monto válido'
			},
			tasaFijaAnual : {
				required : 'Especificar Tasa',
				number : 'Ingrese una tasa válida'
			},
			montoSeguroAnual : {
				number : 'Ingrese un monto válido'
			},
			montoSeguroVidaAnual : {
				number : 'Ingrese un monto válido'
			},
			plazo : {
				required : 'Especificar Plazo',
				numeroMayorCero : 'Plazo esta vacío'
			},
			productoArrendaID : 'Especificar Producto de Arrendamiento',
			fechaApertura : 'Especificar Fecha de Apertura',
			frecuenciaPlazo : 'Especificar Frecuencia de Pagos',
			tipoArrenda : 'Especificar Tipo de Arrendamiento ',

			ivaMontoArrenda : 'Especificar Iva de Monto de Arrendamiento',
			montoEnganche : 'Especificar monto de enganche',
			ivaEnganche : 'Especificar iva de enganche',
			porcEnganche : 'Especificar porcentaje de enganche',
			montoFinanciado : 'Especificar monto financiado',

			fechaRegistro : 'Especificar fecha de registro',
			fechaPrimerVen : 'Especificar fecha de primer vencimiento',
			montoRenta : 'Especificar monto de renta',
			totalPagoInicial: 'Especificar total pago inicial',
			rentasAnticipada : {
				required : 'Especifique si se anticipa la primera renta'
			},
			rentasAdelantadas : {
				required : 'Especifique cantidad de rentas adelantadas'
			},
			concRentaAnticipada : {
				required : 'Especifique monto de renta anticipada'
			},
			concIvaRentaAnticipada : {
				required : 'Especifique IVA de renta anticipada'
			},
			concRentasAdelantadas : {
				required : 'Especifique monto de cuotas adelantadas'
			},
			concIvaRentasAdelantadas : {
				required : 'Especifique IVA de cuotas adelantadas'
			}
		}
	});
	

	
	// ------------ Validaciones de Controles  -------------------------------------
	
	
	function convertDate(stringdate) {
		var DateRegex = /([^-]*)-([^-]*)-([^-]*)/;
		var DateRegexResult = stringdate.match(DateRegex);
		var DateResult;
		var StringDateResult = "";
	
		try {
			DateResult = new Date(DateRegexResult[2] + "/"
					+ DateRegexResult[3] + "/"
					+ DateRegexResult[1]);
		} catch (err) {
			DateResult = new Date(stringdate);
		}
	
		StringDateResult = (DateResult.getMonth() + 1) + "/"
		+ (DateResult.getDate() + 1) + "/"
		+ (DateResult.getFullYear());
	
		return StringDateResult;
	}
	

	
});

// funcion para calcular los valores dle formulario
function calculaValores(varporcEnganche,varmontoEnganche,idControl ) {
	var tipCalculo = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	var numTrans = $('#transaccion').asNumber();
	if(numTrans == 0) {
		numTrans = $('#numTransacSim').asNumber();
	}
	var arrendaBean = {
			'clienteID' 			: $('#clienteID').val(),
			'montoArrenda' 			: $('#montoArrenda').asNumber(),
			'porcEnganche' 			: varporcEnganche,
			'tipoPagoSeguro'  		: $('#tipoPagoSeguro').asNumber(),
			'montoSeguroAnual'  	: $('#montoSeguroAnual').asNumber(),

			'tipoPagoSeguroVida'  	: $('#tipoPagoSeguroVida').asNumber(),
			'montoSeguroVidaAnual'  : $('#montoSeguroVidaAnual').asNumber(),
			'plazo'  				: $('#plazo').asNumber(),
			'tasaFijaAnual'  		: $('#tasaFijaAnual').asNumber(),
			'montoRenta'  			: $('#montoRenta').asNumber(),
			
			'montoDeposito'  		: $('#montoDeposito').asNumber(),
			'montoComApe'  			: $('#montoComApe').asNumber(),
			'otroGastos'  			: $('#otroGastos').asNumber(),
			'montoEnganche'  		: varmontoEnganche,
			'montoResidual'  		: $('#montoResidual').asNumber(),
			'cantRentaDepo'  		: $('#cantRentaDepo').asNumber(),
			
			'sucursalID'  			: parametroBean.sucursal ,
			'rentaAnticipada'		: $('#rentaAnticipada').val(),
			'rentasAdelantadas'		: $('#rentasAdelantadas').asNumber(),
			'adelanto'				: $('#adelanto').val(),
			'numTransacSim'			: numTrans,
	};
	arrendamientoServicio.calculos(tipCalculo,arrendaBean,function(arrendaBean) {
		if (arrendaBean != null) {		
			$('#ivaMontoArrenda').val(arrendaBean.ivaMontoArrenda);
			$('#montoEnganche').val(arrendaBean.montoEnganche);
			$('#montoEngancheConsulta').val(arrendaBean.montoEnganche);
			$('#ivaEnganche').val(arrendaBean.ivaEnganche);
			$('#ivaEngancheConsulta').val(arrendaBean.ivaEnganche);
			$('#montoFinanciado').val(arrendaBean.montoFinanciado);
			$('#ivaComApe').val(arrendaBean.ivaComApe);
		
			$('#ivaDeposito').val(arrendaBean.ivaDeposito);
			$('#ivaOtrosGastos').val(arrendaBean.ivaOtrosGastos);
			$('#montoSeguro').val(arrendaBean.montoSeguro);
			$('#montoSeguroVida').val(arrendaBean.montoSeguroVida);
			$('#montoSeguroConsulta').val(arrendaBean.montoSeguroAnual);
			$('#montoSeguroVidaConsulta').val(arrendaBean.montoSeguroVidaAnual);
			$('#totalPagoInicial').val(arrendaBean.totalPagoInicial);
			$('#montoDeposito').val(arrendaBean.montoDeposito);
			$('#porcEnganche').val(arrendaBean.porcEnganche);
			$('#concRentaAnticipada').val(arrendaBean.concRentaAnticipada);
			$('#concIvaRentaAnticipada').val(arrendaBean.concIvaRentaAnticipada);
			$('#concRentasAdelantadas').val(arrendaBean.concRentasAdelantadas);
			$('#concIvaRentasAdelantadas').val(arrendaBean.concIvaRentasAdelantadas);
			calculosRea = 0;
			
		}else{
			if(calculosRea == 0){
				mensajeSis("Error al realizar los calculos ");
			}
			calculosRea = 1;
		}
	});

	return calculosRea;
}

// METODO PARA CONSULTAR EL ARRENDAMIENTO
function consultaArrendamiento(varNumArrenda) {
	setTimeout("$('#cajaLista').hide();", 200);
	if ( !isNaN(varNumArrenda)) {
		// ingreso por cero (cuando es un arrendamiento nuevo)
		if ($('#arrendaID').asNumber() > 0) {
			calculosRea = 0;
			// consulta del arrendamiento
			deshabilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
			var arrendaBeanCon = {
					'arrendaID' : $('#arrendaID').val()
			};
			arrendamientoServicio.consulta(catTipoConsulta.principal,arrendaBeanCon,function(arrendamiento) {
				if (arrendamiento != null) {
					dwr.util.setValues(arrendamiento);
					$('#productoArrendaID').val(arrendamiento.productoArrendaID);
					$('#plazo').val(arrendamiento.plazo);
					$('#numTransacSim').val(arrendamiento.numTransacSim);
					
					$('#rentaAnticipada').val(arrendamiento.rentaAnticipada);
					$('#rentasAdelantadas').val(arrendamiento.rentasAdelantadas);
					$('#adelanto').val(arrendamiento.adelanto);
					
					habilitaControl('rentaAnticipadaS');
					habilitaControl('rentaAnticipadaN');
					$('#rentaAnticipada' + $('#rentaAnticipada').val()).attr('checked', 'true');
					
					if ($('#rentasAdelantadas').asNumber() > 0) {
						habilitaControl('adelantoPri');
						habilitaControl('adelantoUlt');
						$(':radio[value="' + $('#adelanto').val() + '"]').attr('checked', 'true');
					} else {
						deshabilitaControl('adelantoPri');
						deshabilitaControl('adelantoUlt');
						$('input[name="adelantos"]').removeAttr("checked");
					}

					consultaCliente('clienteID');
					consultaProductoArrenda(arrendamiento.productoArrendaID);	
					consultaFechaInhabilArrenda(arrendamiento.fechaInhabil);
					if(arrendamiento.seguroVidaArrendaID > 0){
						consultaSegurosVidaArrenda(arrendamiento.seguroVidaArrendaID);
					}
					if(arrendamiento.seguroVidaArrendaID > 0){
						consultaSegurosArrenda(arrendamiento.seguroArrendaID);
					}
					
					calculaValores($('#porcEnganche').asNumber(),$('#montoEnganche').asNumber());
					deshabilitaBoton('agrega','submit');
					//habilitaBoton('modifica','submit');
					agregaFormatoControles('formaGenerica');
					
					$('#contenedorSimulador').html("");
					$('#contenedorSimulador').hide();
					
				} else {
					mensajeSis("No Existe el Arrendamiento");
					deshabilitaBoton('modifica','submit');
					deshabilitaBoton('agrega','submit');
					$('#arrendaID').focus();
					$('#arrendaID').select();
					$('#arrendaID').val("");
				}
			});
		} else {
			estatusSimulacion = false;
			calculosRea = 0;
			deshabilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
			inicializaValores();
		}
	}
}

// FUNCION QUE ASIGNA EL VALOR PARA DIA HABIL
function consultaFechaInhabilArrenda(varfechaInhabil){
	if (varfechaInhabil == 'S') {
		$('#fechaInhabil1').attr("checked","1");
		$('#fechaInhabil2').attr("checked",false);
		$('#fechaInhabil').val("S");
	} else {
		$('#fechaInhabil2').attr("checked","1");
		$('#fechaInhabil1').attr("checked",false);
		$('#fechaInhabil').val("A");
	}
}

function consultaProductoArrenda(productoArrendaID){
	// consulta del arrendamiento
	var arrendaBeanCon = {
			'productoArrendaID' : productoArrendaID
	};
	productoArrendaServicio.consulta(catTipoConsulta.principal,arrendaBeanCon,function(arrendamiento) {
		if (arrendamiento != null) {
			$('#descripcionProducto').val(arrendamiento.descripcion);
		} else {
			mensajeSis("No Existe el Producto");
			$('#productoArrendaID').focus();
			$('#productoArrendaID').select();
			$('#productoArrendaID').val("");
			$('#descripcionProducto').val("");
		}
	});

}


function consultaSegurosArrenda(seguroArrendaID){
	// consulta del arrendamiento
	var arrendaBeanCon = {
			'seguroArrendaID' : seguroArrendaID
	};
	segurosArrendaServicio.consulta(catTipoConsultaSeg.mueble,arrendaBeanCon,function(arrendamiento) {
		if (arrendamiento != null) {
			$('#descripcionSeg').val(arrendamiento.descripcion);
		} else {
			mensajeSis("No Existe la aseguradora.");
			$('#seguroArrendaID').focus();
			$('#seguroArrendaID').select();
			$('#seguroArrendaID').val("");
			$('#descripcionSeg').val("");
		}
	});

}
// consulta de seguros de vida
function consultaSegurosVidaArrenda(seguroVidaArrendaID){
	// consulta del arrendamiento
	var arrendaBeanCon = {
			'seguroVidaArrendaID' : seguroVidaArrendaID
	};
	segurosVidaArrendaServicio.consulta(catTipoConsultaSeg.vida,arrendaBeanCon,function(arrendamiento) {
		if (arrendamiento != null) {
			$('#descripcionSegVida').val(arrendamiento.descripcion);
		} else {
			mensajeSis("No Existe la aseguradora.");
			$('#seguroVidaArrendaID').focus();
			$('#seguroVidaArrendaID').select();
			$('#seguroVidaArrendaID').val("");
			$('#descripcionSegVida').val("");
		}
	});

}

/* consulta de cliente se ejecuta solo cuando pierde el foco el campo cliente y en la consulta del arrendamiento*/
function consultaCliente(idControl) {
	var jqCliente = eval("'#" + idControl + "'");
	var numCliente = $(jqCliente).val();
	var tipConPrincipal = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCliente != '' && !isNaN(numCliente) && numCliente != '0') {
		clienteServicio	.consulta(tipConPrincipal,numCliente,function(cliente) {
			if (cliente != null) {		
				datosCompletos = true;
				$('#clienteID').val(cliente.numero);
				$('#nombreCliente').val(cliente.nombreCompleto);
				$('#pagaIVACte').val(cliente.pagaIVA);
				$('#sucursalCte').val(cliente.sucursalOrigen);
				if($('#arrendaID').val()==''||$('#arrendaID').val()=='0'){
					if (cliente.estatus=="I"){
						deshabilitaBoton('agrega','submit');
						deshabilitaBoton('modifica','submit');
						mensajeSis("El Cliente se encuentra Inactivo");
						$('#clienteID').focus();
						$('#clienteID').val('');
						$('#nombreCliente').val('');
					}		
				}else{
					if (cliente.estatus=="I"){
						deshabilitaBoton('agrega','submit');
						deshabilitaBoton('modifica','submit');
						mensajeSis("El Cliente se encuentra Inactivo");
					}		
				}
			}else{
				datosCompletos = false;
				mensajeSis("El cliente no existe");
				$('#clienteID').focus();
				$('#clienteID').select();
				$('#clienteID').val("");
				$('#nombreCliente').val("");
				$('#pagaIVACte').val("");
				$('#sucursalCte').val("");
			}
		});
	} else {
		mensajeSis("Cliente No Valido");
		$('#clienteID').focus();
		$('#clienteID').select();
	}
}// fin consulta cliente


//consulta de monedas
function consultaMoneda() {
	dwr.util.removeAllOptions('monedaID');
	dwr.util.addOptions('monedaID', {
		"" : 'SELECCIONAR'
	});
	monedasServicio.listaCombo(3, function(monedas) {
		dwr.util.addOptions('monedaID', monedas,'monedaID', 'descripcion');
		$('#monedaID').val(1).selected = true;
	});
}

// -------------------------------------------------------------------------
//llamada al cotizador de amortizaciones  ----------------------------------
// -------------------------------------------------------------------------
function simuladorPagos(){
	if(validaDatosSimulador() == true){
		parametroBean = consultaParametrosSession();
		var fechaIni = parametroBean.fechaAplicacion;
		var params = {};
		
		if((Date.parse($('#fechaInicioAmor').val())) < (Date.parse(fechaIni))){
			$('#fechaInicioAmor').val(fechaIni);
		}else{
			fechaIni = $('#fechaInicioAmor').val();
		}
			
		$('#fechaInicio').val(fechaIni);
		
		ejecutarLlamada = false;

		params['tipoLista'] 			= 1; 
		params['montoFinanciado']		= $('#montoFinanciado').asNumber();
		params['diaPagoProd'] 			= $('#diaPagoProd').val();
		params['montoResidual']			= $('#montoResidual').asNumber();
		params['fechaApertura'] 		= $('#fechaApertura').val();
		params['frecuenciaPlazo'] 		= $('#frecuenciaPlazo').val();
		params['plazo'] 				= $('#plazo').val();
		params['tasaFijaAnual'] 		= $('#tasaFijaAnual').asNumber();
		params['montoComApe']			= $('#montoComApe').asNumber();
		params['fechaInhabil'] 			= $('#fechaInhabil').val();
		params['clienteID'] 			= $('#clienteID').val();
		params['rentaAnticipada'] 		= $('#rentaAnticipada').val();
		params['rentasAdelantadas'] 	= $('#rentasAdelantadas').val();
		params['adelanto']				= $('#adelanto').val();

		params['empresaID'] 			= parametroBean.empresaID;
		params['usuario'] 				= parametroBean.numeroUsuario;
		params['fecha'] 				= parametroBean.fechaSucursal;
		params['direccionIP'] 			= parametroBean.IPsesion;
		params['sucursal'] 				= parametroBean.sucursal;
		
		// SE VALIDA SI EL PAGO DEL SEGURO SERA DE CONTADO 
		if($('#tipoPagoSeguroVida').val() == '1'){
			params['montoSeguroVidaAnual']	= 0;
		}else{
			params['montoSeguroVidaAnual']	= $('#montoSeguroVidaAnual').asNumber();
		}
		// SE VALIDA SI EL PAGO DEL SEGURO SERA DE CONTADO S
		if($('#tipoPagoSeguro').val() == '1'){
			params['montoSeguroAnual']		= 0;
		}else{
			params['montoSeguroAnual']		= $('#montoSeguroAnual').asNumber();
		}
		
		var numeroError = 0;
		var mensajeTransaccion = "";
		bloquearPantallaAmortizacion();
		
		$.post("simPagArrenda.htm",params,function(data) {
			if (data.length > 0 || data != null) {
				$('#contenedorSimulador').html(data);
				if ( $("#numeroErrorList").length ) {
					numeroError = $('#numeroErrorList').asNumber();  
					mensajeTransaccion = $('#mensajeErrorList').val();
				}
				estatusSimulacion = true;
				if(numeroError==0){
					estatusSimulacion = true;
					if ($('#arrendaID').asNumber() == '0') {
						habilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
					}else{
						if ($('#estatus').val() == 'G') {
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');
						}else{
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('modifica', 'submit');
						}
					}
					$('#contenedorSimulador').show(); 
					$('#numTransacSim').val($('#transaccion').val());
					$('#cantCuota').val($('#cuotas').val());
					$('#fechaPrimerVen').val($('#valorPrimerVencimiento').val());
					$('#fechaUltimoVen').val($('#valorUltimoVencimiento').val());
					
					$('#montoArrenda').blur();

					// actualiza la nueva fecha de vencimiento que devuelve el cotizador
					var jqFechaVen = eval("'#fech'");
					$('#fechaVencimien').val($(jqFechaVen).val());

					if ($('#siguiente').is(':visible') && $('#anterior').is(':visible')==false){
						$('#filaTotales').hide();	
					}

					if ($('#siguiente').is(':visible')==false && $('#anterior').is(':visible')==false){
						$('#filaTotales').show();	
					}		
					
					
					$('#imprimirRep').hide(); 
				}
			} else{
				$('#contenedorSimulador').html("");
				$('#contenedorSimulador').hide();
				estatusSimulacion = false;
			}
			$('#contenedorForma').unblock();
			agregaFormatoControles('formaGenerica');
			/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
			if(numeroError!=0){
				$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
				mensajeSisError(numeroError,mensajeTransaccion);
			}
			/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
		});
	}

}// fin funcion simuladorPagos()

// funcion para validar los datos requeridos para el simulador 

function validaDatosSimulador() {
	if ($('#montoArrenda').asNumber() <= 0) {
		mensajeSis("El monto esta vacio");
		$('#montoArrenda').val();
		$('#montoArrenda').focus();
		datosCompletos = false;
	}else{
		if($('#tasaFijaAnual').asNumber() == 0){
			mensajeSis("La Tasa  esta Vacia.");
		    $('#tasaFijaAnual').focus();
			datosCompletos = false;
		}else{
			if ($('#montoSeguroAnual').asNumber() < 0) {
				mensajeSis("El monto de Seguro Anual esta vacio");
				$('#montoSeguroAnual').focus();
				datosCompletos = false;
			} else {
				if ($('#montoFinanciado').asNumber() <= 0) {
					mensajeSis("El monto financiado esta vacio");
					$('#montoFinanciado').val();
					$('#montoFinanciado').focus();
					datosCompletos = false;
				}else {
					if ($('#montoSeguroVidaAnual').asNumber() < 0) {
						mensajeSis("El monto Seguro Vida Anual esta vacio");
						$('#montoSeguroVidaAnual').focus();
						datosCompletos = false;
					}else {
						if($('#frecuenciaPlazo').val() == ''){
							mensajeSis("La Frecuencia esta Vacia.");
						    $('#frecuenciaPlazo').focus();
							datosCompletos = false;
						}else{
							if($('#plazo').val() == ''){
								mensajeSis("El plazo esta vacio.");
							    $('#plazo').select();
							    $('#plazo').focus(); 
								datosCompletos = false;
							}else{
								if ($('#diaPagoProd').val() == '') {
									mensajeSis("El dia de pago esta vacio");
									$('#diaPagoProd').focus();
									datosCompletos = false;
								} else {
									if($('#fechaApertura').val() == ''){
										mensajeSis("La fecha de apertura esta vacia.");
									    $('#fechaApertura').focus();
										datosCompletos = false;
									}else{
										if($('#fechaInhabil').val() == ""){
											mensajeSis("La Fecha Inhabil esta Vacia.");
										    $('#montoComApe').focus();
											datosCompletos = false;
										}else{
											if($('#rentaAnticipada').val() == ""){
												mensajeSis("Especificar si se quiere renta anticipada.");
											    $('#rentaAnticipadaS').focus();
												datosCompletos = false;
											}else{
												if($('#rentasAdelantadas').val() == "" || $('#rentasAdelantadas').val() < 0 ||
													isNaN($('#rentasAdelantadas').val()) || $('#rentasAdelantadas').val() != parseInt($('#rentasAdelantadas').val())){
													mensajeSis("Especificar una cantidad válida para rentas adelantadas");
													$('#rentasAdelantadas').focus();
													datosCompletos = false;
												}else{
													if($('#rentasAdelantadas').asNumber() > ($('#plazo').asNumber() / 2)){
														mensajeSis("El número de rentas adelantadas supera la mitad de cuotas.");
														$('#rentasAdelantadas').focus();
														datosCompletos = false;
													}else{
														if($('#rentasAdelantadas').val() != "" && $('#rentasAdelantadas').val() != 0 && $('#adelanto').val() == ""){
															mensajeSis("Especificar si se adelantan las primeras o las últimas cuotas");
															$('#adelantoPri').focus();
															datosCompletos = false;
														}else{
															if($('#clienteID').val() == ""){
																mensajeSis("Especificar Cliente.");
																$('#clienteID').focus();
																datosCompletos = false;
															}else{
																consultaCliente('clienteID');
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}// else montoArrenda
	
	return datosCompletos;
}// fin de funcion para validar datos 

//funcion que bloque la pantalla mientras se cotiza
function bloquearPantallaAmortizacion() {
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
		message : $('#mensaje'),
		css : {
			border : 'none',
			background : 'none'
		}
	});

}


function vlidarTeclas(tecla){
	var aceptado = false;
	if((tecla.keyCode >= 48 && tecla.keyCode <= 57) ||  // teclas numercias
		(tecla.keyCode >= 96 && tecla.keyCode <= 105) || // panel teclado numerico 
		(tecla.keyCode == 190) || (tecla.keyCode == 110) || (tecla.keyCode == 8)){ // punto, retroceso
		aceptado = true;
	}
	return aceptado;	
}

/*
 * funcion para validar cuando un campo  toma el foco
 y es moneda, se necesita que se ponga el campo limpio cuando su valor es cero o seleccione elvalor si es 
 mayor que cero.*/
function validaFocoInputMoneda(controlID){
	jqID = eval("'#" + controlID + "'");
	if($(jqID).asNumber()>0){
		$(jqID).select();
	}else{
		$(jqID).val("0.00");
		$(jqID).select();
	}
}

/*
 * funcion para validar cuando un campo  toma el foco
 y es tasa, se necesita que se ponga el campo limpio cuando su valor es cero o seleccione elvalor si es 
 mayor que cero.*/
function validaFocoInputTasa(controlID){
	jqID = eval("'#" + controlID + "'");
	if($(jqID).asNumber()>0){
		$(jqID).select();
	}else{
		$(jqID).val("0.0000");
		$(jqID).select();
	}
}

function inicializaFormulario(){
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	
	$('#arrendaID').focus();
	$('#fechaApertura').val(parametroBean.fechaAplicacion);
	inicializaValores();
	inicializaCombos();
}

function inicializaValores(){
	$('#lineaArrendaID').val("");
	$('#descripcionLinea').val("");
	$('#clienteID').val("");
	$('#nombreCliente').val("");
	$('#productoArrendaID').val("");
	$('#descripcionProducto').val("");
	$('#estatus').val("");
	$('#tipoArrenda').val("");
	$('#montoResidual').val("");
	$('#fechaPrimerVen').val("");
	$('#fechaUltimoVen').val("");
	$('#montoArrenda').val("");
	$('#ivaMontoArrenda').val("");
	$('#tasaFijaAnual').val("");
	$('#montoFinanciado').val("");
	$('#frecuenciaPlazo').val("");
	$('#plazo').val("");
	$('#diaPagoProd').val("");
	$('#cantCuota').val("");
	$('#porcEnganche').val("");
	$('#montoEnganche').val("");
	$('#ivaEnganche').val("");
	$('#otroGastos').val("");
	$('#ivaOtrosGastos').val("");
	$('#montoComApe').val("");
	$('#ivaComApe').val("");
	$('#cantRentaDepo').val("");
	$('#montoDeposito').val("");
	$('#ivaDeposito').val("");
	$('#seguroArrendaID').val("");
	$('#descripcionSeg').val("");
	$('#montoSeguroAnual').val("");
	$('#montoSeguroConsulta').val("");
	$('#montoSeguroVidaConsulta').val("");
	$('#tipoPagoSeguro').val("");
	$('#seguroVidaArrendaID').val("");
	$('#descripcionSegVida').val("");
	$('#montoSeguroVidaAnual').val("");
	$('tipoPagoSeguroVida').val("");
	$('#totalPagoInicial').val("");
	$('#ivaEngancheConsulta').val("");
	$('#montoEngancheConsulta').val("");
	$('#monedaID').val('1');
	$('#rentaAnticipada').val("");
	$('#rentasAdelantadas').val("");
	$('#adelanto').val("");
	$('#concRentaAnticipada').val("");
	$('#concIvaRentaAnticipada').val("");
	$('#concRentasAdelantadas').val("");
	$('#concIvaRentasAdelantadas').val("");
	$('input[name="rentasAnticipada"]').removeAttr("checked");
	deshabilitaControl('adelantoPri');
	deshabilitaControl('adelantoUlt');
	$('input[name="adelantos"]').removeAttr("checked");
	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	$('#fechaApertura').val(parametroBean.fechaAplicacion);
}

function inicializaCombos() {
	consultaMoneda();
	$('#plazo').val('');
}

function arrendaAccionExitoso(){
	esTab = true;
	consultaArrendamiento($('#arrendaID').asNumber());
	$('#arrendaID').focus();
	calculosRea = 0;

	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
}

function arrendaAccionFallo(){
	calculosRea = 0;

}

function validaSoloNumeros() {
	if ((event.keyCode < 48) || (event.keyCode > 57)) 
	event.returnValue = false;
}


//Función para calcular los días transcurridos entre dos fechas
function restaFechas(fAhora,fEvento) {
	
	var ahora = new Date(fAhora);
 var evento = new Date(fEvento);
 var tiempo = evento.getTime() - ahora.getTime();
 var dias = Math.floor(tiempo / (1000 * 60 * 60 * 24));
 
	return dias;
}	