sCheque = parseFloat[0];
var Cons_Enum_ConsultaChequeras= {
	'folioUtilizar':				2,
	'consultafolioxBloqueCheques':	4,
};
$(document).ready(function(){	
	var numeroCaja=parametroBean.cajaID;
	var sucursalID=parametroBean.sucursal;
	//Definicion de Constantes y Enums
	var cargoCuenta			= 1;
	var devolucionGarLiq	= 5;
	var desemboCred 		= 7;
	var aplicaPolizaRiesgo 	= 9;
	var tranferenciaCuenta	=10;
	var devAportacionSocial	=13;
	var aplicaSegVidaAyuda	=15;
	var pagoRemesas			=16;
	var pagoOportunidades	=17;
	var pagoServifun		=25;
	var cobroApoyoEscolar	=26;
	var pagoCancelSocio		=30;
	var anticiposGastos		=38;	
	var haberesExmenor		=40;
	var transferenciaInterna=41;
	var bloquearCaja = "no";
	
	var numeroInstitucion="";
	var cuentaInstitucion="";
	
	
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#formaPagoOpera2').click(function(){
		$(this).focus();
		if($(this).is(':checked')){
			numeroInstitucion="";
			cuentaInstitucion="";
			deshabilitaBoton('graba','submit');			
			$('#divCuentaCheques').show();
			$('#entradaSalida').hide();
			$('#totales').hide();
			$('#numeroCheque').val('');
			$('#confirmeCheque').val('');
			$('#tipoChequera').val('');
			var tipoLista=2;
			var asignaChequeBean ={
					'sucursalID' : sucursalID,
					'cajaID'	 : numeroCaja
			};						
			$('#beneCheque').val(socioDeOperacion());			
			asignarChequeSucurServicio.listaCombo(tipoLista,asignaChequeBean,function(chequesBean){
				if(chequesBean!=''){
					dwr.util.removeAllOptions('cuentaChequePago'); 
  			  		dwr.util.addOptions('cuentaChequePago', {'':'SELECCIONAR'});
  			  		dwr.util.addOptions('cuentaChequePago', chequesBean, 'institucionCta', 'descripLista');  
				}
			});
		}
	});
	
	$('#formaPagoOpera1').click(function(){
		if($('#formaPagoOpera1').is(':checked')){
			deshabilitaBoton('graba','submit');
			$('#divCuentaCheques').hide();
			$('#entradaSalida').show();
			$('#totales').show();
			borrarDivCheques();
		}
	});
	
	$('#graba').click(function(){
			
		validarFormaPago();
		if($('#tipoOperacion').asNumber()==tranferenciaCuenta || $('#tipoOperacion').asNumber()==transferenciaInterna){			
			$('#formaPagoOpera1').attr('checked','checked');
			$('#pagoServicioRetiro').attr('checked','checked');
		}
		if($('#formaPagoOpera2').is(':checked') || $('#pagoServicioCheque').is(':checked')){
			$('#institucionID').val(numeroInstitucion);
			$('#numCtaInstit').val(cuentaInstitucion);
		}					
		
	});
	
	$('#beneCheque').blur(function(){
		if(esTab){
			$('#graba').focus();
		}
		switch($('#tipoOperacion').asNumber()){
			case pagoCancelSocio :
				funcionActualizaRecibePagoCancelSocio();
			break;
		}
	});		
	
	$('#formaPagoOpera1').blur(function(){		
		//Se validan los tabs cuando las pantallas contengan forma de pago efectivo o cheque
		if($('#tipoOperacion').asNumber()==cargoCuenta || $('#tipoOperacion').asNumber()==devolucionGarLiq || 
			$('#tipoOperacion').asNumber()==devAportacionSocial || $('#tipoOperacion').asNumber()==desemboCred || 
				$('#tipoOperacion').asNumber()==pagoServifun || $('#tipoOperacion').asNumber()==cobroApoyoEscolar || 
					$('#tipoOperacion').asNumber()==aplicaSegVidaAyuda){
										//si es forma de pago efectivo el foco se ira a salida de efectivo
										$('#cantSalMil').focus();
										
		}		
	});
		
	$('#formaPagoOpera2').blur(function(){
		$('#cuentaChequePago').focus();		
		$('#beneCheque').val(socioDeOperacion());					
	});
	$('#cuentaChequePago').blur(function(){
		if($('#cuentaChequePago').val()!=''){			
			$('#beneCheque').removeAttr('readOnly');
			$('#numeroCheque').removeAttr('readOnly');
			$('#confirmeCheque').removeAttr('readOnly');
		}			
	});
	$('#cuentaChequePago').change(function(){
		if($('#cuentaChequePago').val()!=''){	
			$('#tipoChequera').val('');
			$('#folioUtilizar').val('');
			$('#numeroCheque').val('');
			$('#confirmeCheque').val('');	
			$('#impCheque').hide();
			$('#impTicket').hide();
			numeroInstitucion="";
			cuentaInstitucion="";
			var parametrosCheque=$('#cuentaChequePago').val().split('-');			
			numeroInstitucion=parametrosCheque[0];
			cuentaInstitucion=parametrosCheque[1];		
			cargaTipoChequera();
			
		}else{
			numeroInstitucion="";
			cuentaInstitucion="";
			$('#folioUtilizar').val('');
		}
	});	
	
	 	function cargaTipoChequera(){
		tipoChequeraBean = {
				'institucionID':numeroInstitucion,
				'numCtaInstit':cuentaInstitucion
				};
		
			cuentaNostroServicio.listaCombo(15,tipoChequeraBean,function(tiposChe){
				if(tiposChe!=''){
					dwr.util.removeAllOptions('tipoChequera'); 
  			  		dwr.util.addOptions('tipoChequera', {'':'SELECCIONAR'});
  			  		dwr.util.addOptions('tipoChequera', tiposChe, 'tipoChequera', 'descripTipoChe');  
				}
			});	
		}

	$('#tipoChequera').blur(function(){
		$('#numeroCheque').val('');
		$('#confirmeCheque').val('');	
		$('#impCheque').hide();
		$('#impTicket').hide();
		var valorChequera=$('#tipoChequera option:selected').val();
		var tipoLista=2;
		var asignaChequeBean={
			'institucionID' : numeroInstitucion,
			'numCtaInstit'  : cuentaInstitucion,
			'sucursalID'  : sucursalID,
			'cajaID': numeroCaja,
			'tipoChequera': valorChequera
		};			
		
		asignarChequeSucurServicio.consulta(tipoLista,asignaChequeBean,function(cheque){	
			if(cheque!=null){
			$('#folioUtilizar').val(cheque.folioUtilizar);
			}
			else{
				
				mensajeSis('La Caja no tiene Chequeras Asignadas.');
				$('#tipoChequera').val('');
				$('#cuentaChequePago').focus();
				
				
			}
		});

	});


	$('#numeroCheque').blur(function(){
		var parametrosCheque=$('#cuentaChequePago').val().split('-');
		var valorChequera=$('#tipoChequera option:selected').val();
		
		var numCheque = $('#numeroCheque').val();
		if($('#numeroCheque').val()!=''){
			if($('#numeroCheque').val()==$('#folioUtilizar').val()){
				mensajeSis("El Número de Cheque no puede ser el mismo que el Último Cheque Registrado");
				$('#numeroCheque').val('');
				$('#numeroCheque').focus();
			}else{
				consultaChequeEmitido(parametrosCheque,numCheque,valorChequera);
				validarFolioxBloqueCheques(valorChequera);
			}

			if(valorChequera == 'P'){
				consultaRutaChequeProforma(parametrosCheque,valorChequera);
			}else if(valorChequera == 'E'){
				consultaRutaChequeEstan(parametrosCheque,valorChequera);
			}
			
		}
	});
	$('#confirmeCheque').blur(function(){ 		
		deshabilitaBotonCheque();
			
	});
	$('#pagoServicioCheque').click(function(){
		$('#entradaSalida').hide();		
		$('#totales').hide();
		$('#divCuentaCheques').show();		
		borrarDivCheques();
		var tipoLista=2;
		var asignaChequeBean ={
				'sucursalID' : sucursalID,
				'cajaID'	 : numeroCaja
		};
		$('#beneCheque').val(socioDeOperacion());
		asignarChequeSucurServicio.listaCombo(tipoLista,asignaChequeBean,function(chequesBean){
			if(chequesBean!=''){
				dwr.util.removeAllOptions('cuentaChequePago'); 
			  		dwr.util.addOptions('cuentaChequePago', {'':'SELECCIONAR'});
			  		dwr.util.addOptions('cuentaChequePago', chequesBean, 'institucionCta', 'descripLista');  
			}
		});		
	});
	$('#pagoServicioCheque').blur(function(){
		$('#beneCheque').val(socioDeOperacion());
	});
	
	$('#tipoOperacion').change(function() {
		bloquearCaja = consultaLimiteCaja();
		
		if(bloquearCaja == "no"){
			setTimeout("$('#cajaLista').hide();", 200);
			switch($(this).asNumber())
			{
				case cargoCuenta:					
						$('#divFormaPago').show();
						$('#divCuentaCheques').hide();							
					break;
				case desemboCred:
					$('#divFormaPago').show();
					$('#divCuentaCheques').hide();																			
					break;
				case aplicaPolizaRiesgo:
						$('#divFormaPago').show();
						$('#divCuentaCheques').hide();						
					break;
				case devolucionGarLiq:
					$('#divFormaPago').show();		
					$('#divCuentaCheques').hide();					
					break;
				case devAportacionSocial:
					$('#divFormaPago').show();
					$('#divCuentaCheques').hide();					
					break;								
				case aplicaSegVidaAyuda:
					$('#divFormaPago').show();
					$('#divCuentaCheques').hide();					
					break;
				case pagoServifun:
					$('#divFormaPago').show();
					$('#divCuentaCheques').hide();					
					break;
				case cobroApoyoEscolar:
					$('#divFormaPago').show();
					$('#divCuentaCheques').hide();									
				break;
				case pagoCancelSocio:
					$('#divFormaPago').show();
					$('#divCuentaCheques').hide();									
				break;
				default:					
					$('#divFormaPago').hide();
					$('#divCuentaCheques').hide();
					borrarDivCheques();
				break;			
			}
		}	 
	}); 
	
	// validar el limite de efectivo de la caja
	function consultaLimiteCaja() {
		parametroBean = consultaParametrosSession();
		var varMontoLimiteMN = parametroBean.limiteEfectivoMN; 
		var saldoEfectCaja = $('#saldoEfecMNSesion').asNumber(); 
		if(parametroBean.cajaID>0){
			if(parseFloat(varMontoLimiteMN) >= parseFloat(saldoEfectCaja)){
				bloquearCaja = "no";
			}else{
				bloquearCaja = "si";
				deshabilitaBoton('graba', 'submit');
				$('#impTicket').hide();
				mensajeSis("Para poder realizar una nueva operación es \n" +
						"necesario realizar una transferencia de efectivo. ");
			}
		}
		else{
			mensajeSis('El Estado de Operación de esta Caja es Cerrada');
			bloquearCaja = "si";
			deshabilitaBoton('graba', 'submit');
		}
		return bloquearCaja;
	}
	
	function consultaRutaChequeProforma(parametrosCheque,valorChequera){
		var tipoConsulta=13;
		var cuentasNostroBean = {
				'institucionID' : parametrosCheque[0],
				'numCtaInstit'	: parametrosCheque[1],
				'tipoChequera'	: valorChequera
			};
		setTimeout("$('#cajaLista').hide();", 200);	
		cuentaNostroServicio.consulta(tipoConsulta,cuentasNostroBean,function(ruta){
			if(ruta!=null){
				var nombreRutaCheque=(ruta.rutaCheque).split(".");				
				$('#rutaChequeInstit').val(nombreRutaCheque[0]);
			}
		});				
	}
	
	function consultaRutaChequeEstan(parametrosCheque,valorChequera){
		var tipoConsulta=16;
		var cuentasNostroBean = {
				'institucionID' : parametrosCheque[0],
				'numCtaInstit'	: parametrosCheque[1],
				'tipoChequera'	: valorChequera
			};
		setTimeout("$('#cajaLista').hide();", 200);		
		cuentaNostroServicio.consulta(tipoConsulta,cuentasNostroBean,function(ruta){
			if(ruta!=null){
				var nombreRutaCheque=(ruta.rutaChequeEstan).split(".");				
				$('#rutaChequeInstit').val(nombreRutaCheque[0]);
			}
		});				
	}
	
	function consultaChequeEmitido(parametrosCheque, numCheque,valorChequera){
		var tipoConsulta=14;
		var cuentasNostroBean = {
				'institucionID' : parametrosCheque[0],
				'numCtaInstit'	: parametrosCheque[1],
				'cuentaClabe'	: numCheque,
				'tipoChequera'	: valorChequera
			};
		setTimeout("$('#cajaLista').hide();", 200);		
		
		cuentaNostroServicio.consulta(tipoConsulta,cuentasNostroBean,function(cheque){
			if(cheque!=null){
				var chequeEmitido= cheque.folioEmitido;			
				if(chequeEmitido > 0 && chequeEmitido != '' && chequeEmitido != null){
					mensajeSis('El Número de Cheque ya fue Emitido');
					$('#numeroCheque').val('');
					$('#numeroCheque').focus();
				} 
			}
		});				
	}
	
	
	function socioDeOperacion(){
		NombreBeneficiario='';
		switch($('#tipoOperacion').asNumber()){
			case cargoCuenta :			
				NombreBeneficiario=$('#nombreClienteCa').val();	
			break;
			case devolucionGarLiq:
				NombreBeneficiario=$('#nombreClienteDG').val();
			break;			
			case desemboCred :
				NombreBeneficiario=$('#nombreClienteDC').val();
			break;
			case devAportacionSocial :
				NombreBeneficiario=$('#nombreClienteDAS').val();
			break;
			case aplicaPolizaRiesgo :
				NombreBeneficiario=$('#nombreClienteS').val();
			break;
			case aplicaSegVidaAyuda :
				NombreBeneficiario=$('#nombreClienteDAS').val();
			break;
			case pagoServifun :
				NombreBeneficiario=$('#nombreCteServifun').val();
			break;
			case cobroApoyoEscolar :
				NombreBeneficiario=$('#nombreCteApoyoEsc').val();
			break;
			case pagoRemesas :
				NombreBeneficiario=$('#nombreClienteServicio').val();
			break;
			case pagoOportunidades :
				NombreBeneficiario=$('#nombreClienteServicio').val();
			break;
			case pagoCancelSocio :
				NombreBeneficiario=$('#nombreRecibePago').val();
			break;
			case anticiposGastos :
				if($('#empleadoID').val()!=''){
					NombreBeneficiario=$('#nombreEmpleadoGA').val();
				}else{
					NombreBeneficiario='';
				}
			break;
			case haberesExmenor :
				NombreBeneficiario=$('#nombreClienteMenor').val();
			break;
			
			
		}
		return NombreBeneficiario;
	}
	
	/**
	 * Funcion para validar que el folio a utilizar se encuentre dentro del bloque de cheques asignados 
	 * 
	 */
	function validarFolioxBloqueCheques(valorChequera){
		var parametrosCheque=$('#cuentaChequePago').val().split('-');
		var numFolio= $('#numeroCheque').val();
		var NoExisteFolio = 'N';
		var asignarBeanCon = {
				'folioCheqInicial':numFolio,
				'institucionID':parametrosCheque[0],
				'numCtaInstit':parametrosCheque[1],
				'sucursalID':sucursalID,
				'cajaID':numeroCaja,
				'tipoChequera': valorChequera
		};
		if(numFolio != '' && !isNaN(numFolio)){
			asignarChequeSucurServicio.consulta(Cons_Enum_ConsultaChequeras.consultafolioxBloqueCheques,asignarBeanCon,function(asignarCheques){
				if(asignarCheques!=null){
					if(asignarCheques.existeFolio==NoExisteFolio){
						mensajeSis("El Folio a utilizar no se Encuentra dentro del Bloque de Cheques Asignados a la Caja."); 
						$('#numeroCheque').val();
						$('#numeroCheque').focus();
					}
				}
			});
		}
	}

	
});// FIN DEL DOCUMENT


function borrarDivCheques(){	
	$('#cuentaChequePago').val('');
	$('#tipoChequera').val('');
	$('#folioUtilizar').val('');
	$('#numeroCheque').val('');
	$('#confirmeCheque').val('');
	$('#beneCheque').val('');
	$('#rutaChequeInstit').val('');
	$('#institucionID').val('');
	$('#numCtaInstit').val('');
	numeroInstitucion="";
	cuentaInstitucion="";
}

function deshabilitaBotonCheque(){
	var montoCargar = $('#montoCargar').asNumber();
	var montoDevGL = $('#montoDevGL').asNumber();
	var totalRetirarDC = $('#totalRetirarDC').asNumber();
	var montoPoliza = $('#montoPoliza').asNumber();
	var montoDAS = $('#montoDAS').asNumber();
	var montoPolizaSegAyudaCobroA = $('#montoPolizaSegAyudaCobroA').asNumber();
	var montoServicio = $('#montoServicio').asNumber();
	var montoEntregarServifun = $('#montoEntregarServifun').asNumber();
	var monto = $('#monto').asNumber();
	var montoGastoAnt = $('#montoGastoAnt').asNumber();
	var totalHaberes = $('#totalHaberes').asNumber();
	var totalBeneficio = $('#totalBeneficio').asNumber();
	
	
	montosCheque = montoCargar + montoDevGL + totalRetirarDC + montoPoliza + montoDAS +
					montoPolizaSegAyudaCobroA +  montoServicio + montoEntregarServifun +  monto + montoGastoAnt +
					totalHaberes + totalBeneficio;
	
	if($('#numeroCheque').val() !='' && $('#confirmeCheque').val()!=''){
		
		if($('#numeroCheque').asNumber() != $('#confirmeCheque').asNumber()){
			$('#confirmeCheque').focus();
			$('#confirmeCheque').val('');
			mensajeSis('Error en la Confirmación de Número de Cheque');
		}else{
			if($('#numeroTransaccion').val()=="" && montosCheque > 0 ){
				habilitaBoton('graba','submit');
				
			}else{
				deshabilitaBoton('graba','submit');
			}
		}
	}
}