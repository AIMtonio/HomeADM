var catMenuRegulatorio = {
	'TipoCobranza'	: 18,
};
var statu = "";

var listaPersBloqBean = {
        'estaBloqueado' :'N',
        'coincidencia'  :0
};

var consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};

var esCliente           ='CTE';

$(document).ready(function(){

	$("#creditoID").focus();

	esTab = true;
	var parametrosBean = consultaParametrosSession();
	var fechaEmision = parametrosBean.fechaSucursal;


	//Definición de constantes y Enums
	var catTipoConsultaCredito = {
		'principal'	: 1,
		'foranea'	: 2,

	};

	var catTipoTransaccionCastiga ={
		'proceso' :'1',
	};

	//-----------------------Métodos y manejo de eventos-----------------------
	consultaMotivosCastigo();
	consultaTiposCobranza();
	deshabilitaBoton('castiga', 'submit');
	$('#imprimir').hide();


	agregaFormatoControles('formaGenerica');

	$(':text').focus(function() {
		esTab = false;
	});


	$.validator.setDefaults({
			submitHandler: function(event) {
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','polizaID',
						  'funcionExito','funcionError');
			}
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#castiga').click(function(){
		$('#tipoTransaccion').val('1');
	});

	$('#impPoliza').click(function(){
		var poliza = $('#polizaID').val();
		var fecha = parametroBean.fechaSucursal;
		window.open('RepPoliza.htm?polizaID='+poliza+'&fechaInicial='+fecha+
				'&fechaFinal='+fecha+'&nombreUsuario='+parametroBean.nombreUsuario);
	});

	$('#creditoID').blur(function(){
		consultaCredito(this.id);
	});

	$('#creditoID').bind('keyup', function(e){
		lista('creditoID', '2', '52', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});

//-------------Validaciones de la forma---------------------

	$('#formaGenerica').validate({
		rules: {
			creditoID: {
				required: false
			},
			tipoCobranza:{
				required:true
			},
			motivoCastigoID:{
				required:true
			}
		},
		messages: {
			creditoID: {
				required: 'Especifique el Crédito'
			},
			motivoCastigoID: {
				required: 'Especifique el Motivo de Castigo'
			},
			tipoCobranza:{
				required: 'Especifique el Tipo de Cobranza'
			},
		}
	});


	//-------------Validaciones de controles ---------------------
	//funcion principal consulta creditos
	function consultaCredito(controlID){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			var creditoBeanCon = {
				'creditoID':$('#creditoID').val()
			};
			creditosServicio.consulta(18, creditoBeanCon,function(credito){
				if(credito!=null){
					listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
					consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);
				
					if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
						esTab=true;	
						$('#producCreditoID').val(credito.producCreditoID);
						$('#creditoID').val(credito.creditoID);
						$('#diasFaltaPago').val(credito.diasFaltaPago);
						$('#monto').val(credito.montoCredito);
						$('#clienteID').val(credito.clienteID);
						$('#monedaID').val(credito.monedaID);
						consultaCliente('clienteID');			
						consultaMoneda('monedaID');							
						consultaProducCredito('producCreditoID');	
						consultaDiasAtraso(credito.creditoID);
						consultaReservas('creditoID');
						consultaCreditosFechas();
						consultaSaldos('creditoID');
						var estatus = credito.estatus;
						statu=credito.estatus;
						validaEstatusCredito(estatus);
						 $('#polizaID').val("");	
						 $('#impPoliza').hide();
					}else{
						inicializaForma('formaGenerica','creditoID' );
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						deshabilitaBoton('catigar', 'submit');
						$('#creditoID').focus();
						$('#creditoID').select();
					} 
				}else{
					inicializaForma('formaGenerica','creditoID');
					mensajeSis("No Existe el Credito");
					deshabilitaBoton('catigar', 'submit');
					$('#creditoID').focus();
					$('#creditoID').select();
				}
			});
		}
	}
	//consulta las fechas de inicio y vencimiento
	function consultaCreditosFechas(){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) ){
			var Con_PagoCred = 1;
			var creditoBeanCon = {
					'creditoID':$('#creditoID').val(),
			};
			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
				if(credito!=null){
					$('#fechaIni').val(credito.fechaInicio);
					$('#fechaVenc').val(credito.fechaVencimien);
				}else{
					mensajeSis("No Existe el Crédito");
				}
			});
		}
	}

	// funcion que consulta el nombre del cliente
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){
					$('#clienteID').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
				}else{
					mensajeSis("No Existe el Cliente");
					$('#clienteID').focus();
					$('#clienteID').select();
				}
			});
		}
	}
	// funcion que consulta el tipo de moneda y su descripcion
	function consultaMoneda(idControl) {
		var jqMoneda = eval("'#" + idControl + "'");
		var numMoneda = $(jqMoneda).val();
		var conMoneda=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMoneda != '' && !isNaN(numMoneda)){
			monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
				if(moneda!=null){
					$('#monedaDes').val(moneda.descripcion);
				}else{
					mensajeSis("No Existe el Tipo de Moneda");
					$('#monedaDes').val('');
					$(jqMoneda).focus();
				}
			});
		}
	}
	//funcion que valida el estatus del crédito
	function validaEstatusCredito(var_estatus) {
		var estatusInactivo 	="I";
		var estatusAutorizado 	="A";
		var estatusVigente		="V";
		var estatusPagado		="P";
		var estatusCancelada 	="C";
		var estatusVencido		="B";
		var estatusCastigado 	="K";
		var estatusSuspendido	="S";

		if(var_estatus == estatusInactivo){

			 $('#estatus').val('INACTIVO');
			 deshabilitaBoton('castiga','submit');
		}
		if(var_estatus == estatusAutorizado){

			 $('#estatus').val('AUTORIZADO');
			 deshabilitaBoton('castiga','submit');
		}
		if(var_estatus == estatusVigente){

			 $('#estatus').val('VIGENTE');
			 habilitaBoton('castiga','submit');
		}
		if(var_estatus == estatusPagado){

			 $('#estatus').val('PAGADO');
			 deshabilitaBoton('castiga','submit');
		}
		if(var_estatus == estatusCancelada){

			 $('#estatus').val('CANCELADO');
			 deshabilitaBoton('castiga','submit');
		}
		if(var_estatus == estatusVencido){

			 $('#estatus').val('VENCIDO');
			 habilitaBoton('castiga','submit');
		}
		if(var_estatus == estatusCastigado){
			 $('#estatus').val('CASTIGADO');
			 deshabilitaBoton('castiga','submit');
		}
		if(var_estatus == estatusSuspendido){
			$('#estatus').val('SUSPENDIDO');
			habilitaBoton('castiga','submit');
		}
	}
	// funcion para consultar el producto del crédito
	function consultaProducCredito(idControl) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();
		var ProdCredBeanCon = {
			'producCreditoID':ProdCred
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(ProdCred != '' && !isNaN(ProdCred) && esTab){
			productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					$('#descripProducto').val(prodCred.descripcion);

				}else{
					mensajeSis("No Existe el Producto de Credito");
				}
			});
		}
	}
	// consulta y rellena el combo de motivos de castigo
	function consultaMotivosCastigo() {
		dwr.util.removeAllOptions('motivoCastigoID');
		dwr.util.addOptions('motivoCastigoID', {'':'Selecciona'});
		castigosCarteraServicio.listaCombo(1, function(motivosCastigo){
			dwr.util.addOptions('motivoCastigoID', motivosCastigo, 'motivoCastigoID', 'descricpion');
		});
	}

	// consulta y rellena el combo de tipos de Cobranza
	function consultaTiposCobranza() {
		dwr.util.removeAllOptions('tipoCobranza');
		dwr.util.addOptions('tipoCobranza', {'':'Selecciona'});
		// Combo Clasificación del Crédito
		opcionMenuRegBean = {
			'menuID' : catMenuRegulatorio.TipoCobranza,
			'descripcion': ''
		};
		opcionesMenuRegServicio.listaCombo(2,opcionMenuRegBean,function(opcionesMenuRegBean1) {
			for ( var j = 0; j < opcionesMenuRegBean1.length; j++) {
				$('#tipoCobranza').append(new Option(opcionesMenuRegBean1[j].descripcion,opcionesMenuRegBean1[j].codigoOpcion,true,true));
			}
			$('#tipoCobranza').val('').selected = true;

		});
	}

	// funcion que consulta el tipo de moneda y su descripcion
	function consultaDiasAtraso() {
		var numDias = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numDias != '' && !isNaN(numDias)){
			var conDias = 7;
			var creditoBeanCon = {
				'creditoID':$('#creditoID').val(),
			};
			amortizacionCreditoServicio.consulta(conDias,creditoBeanCon,function(numDiasAtraso) {
				if(numDiasAtraso!=null){
					$('#diasAtraso').val(numDiasAtraso.diasAtraso);
					$('#diasAtraso').formatCurrency({
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: 0
					});
				}else{
					$('#diasAtraso').val(0);
				}
			});
		}
	}

	// funcion que consulta resrvas
	function consultaReservas(idControl) {
		var jqCred  = eval("'#" + idControl + "'");
		var Cred = $(jqCred).val();
		var CredBeanCon = {
				'creditoID':Cred
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if(Cred != '' && !isNaN(Cred)){
			estimacionPreventivaServicio.consultaReservas(2,CredBeanCon,function(reservas) {
				if(reservas!=null){
					$('#fecha').val(reservas.ultimaFecha);
					$('#reservaCap').val(reservas.saldoCap);
					$('#reservaInt').val(reservas.saldoInt);
					$('#totalReserva').val(reservas.totalReserva);
					agregaFormatoControles('formaGenerica');
				}else{
					$('#fecha').val('');
					$('#reservaCap').val('0');
					$('#reservaInt').val('0');
					$('#totalReserva').val('0');
				}
			});
		}
	}
	//consulta saldos
	function consultaSaldos(idControl) {
		var jqCred  = eval("'#" + idControl + "'");
		var Cred = $(jqCred).val();
		var CredBeanCon = {
				'creditoID':Cred
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if(Cred != '' && !isNaN(Cred)){
			creditosServicio.consulta(17,CredBeanCon,function(saldos) {
				if(saldos!=null){
					$('#saldoCap').val(saldos.totalCapital);
					$('#saldoInt').val(saldos.totalInteres);
					$('#saldoMoratorios').val(saldos.saldoMoratorios);
					$('#totalAdeudo').val(saldos.adeudoTotalSinIVA);
					var saldoComFaltPago = saldos.saldoComFaltPago;
					var saldoOtrasComis = saldos.saldoOtrasComis;
					saldoComFaltPago = saldoComFaltPago.replace(',', '');
					saldoOtrasComis = saldoOtrasComis.replace(',', '');

					var totalComisiones = parseFloat(saldoComFaltPago)+parseFloat(saldoOtrasComis);
					$('#SaldoComFaltaPa').val(totalComisiones);
					$('#SaldoComFaltaPa').formatCurrency({
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: 2

					});
					$('#saldoNotasCargo').val(saldos.saldoNotasCargo);

					validaCreditoEnGarantia();

				}else{

					mensajeSis("No existe el crédito");
				}
			});
		}
	}

	/* valida si el credito tiene inversiones en garantia */
	function validaCreditoEnGarantia(){
		var bean={
			'creditoID':$('#creditoID').val()
		};
		invGarantiaServicio.consulta(4,bean,function(inverGaran){
			if(inverGaran != null){
				if(inverGaran.creditoInvGarID == "0"){
					if(statu =='V' || statu =='B' || statu =='S'){
						habilitaBoton('castiga', 'submit');
					}else{
						deshabilitaBoton('castiga','submit');
					}
				}else{
					mensajeSis("El Crédito Indicado tiene Inversiones en Garantía.");
					deshabilitaBoton('castiga', 'submit');
				}
			}else{
				if(statu =='V' || statu =='B' || statu =='S'){
					habilitaBoton('castiga', 'submit');
				}else{
					deshabilitaBoton('castiga','submit');
				}
			}
		});
	}
});



//funcion que se ejecuta cuando el resultado fue un éxito
function funcionExito(){
	$('#impPoliza').show();
	 deshabilitaBoton('castiga','submit');
}

//funcion que se ejecuta cuando el resultado fue error
//diferente de cero
function funcionError(){
	$('#impPoliza').hide();

}
