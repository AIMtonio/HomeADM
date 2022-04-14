var catFormTipoCalInt = { 
		'principal'	: 1,
};
var TasaFijaID 			= 1; // ID de la formula para tasa fija (FORMTIPOCALINT)
var TasaBasePisoTecho 	= 3; // ID de la formula para tasa base con piso y techo (FORMTIPOCALINT)
var VarTasaFijaoBase	= 'Tasa Fija Anualizada'; // Texto que indica si se trata de tasa fija o tasa base actual
var VarTasaOrdinaria	= 'Tasa Ordinaria'; // Texto que indica si se trata de tasa fija o tasa base actual
$(document).ready(function() {
	esTab = true;
	var tab2=false;		
	//Definicion de Constantes y Enums  
	var tipoTransaccion= {			
			'actualizaTasa': '6'
		};
	
	var tipoActualizacion= {
			'ninguna': '0',
			'actTasaFija' : '6',
			'actTasaMora' : '7',
			'actComxApt'  : '8',
			'actTsaFMCom' : '9',
			'actSobreTasa' : '10'
		};
	var tipoCondiModificar = {
		'Todos'				: 2,
		'TasaOrdinaria'		: 3,
		'TasaMoratoria'		: 4,
		'ComisionXApertura'	: 5,
		'SobreTasa'			: 6
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('modificar');
	consultaComboCalInteres();
	muestraCamposTasa(0);
	llenaComboCondicionesModif(0);

	$('#solicitudCreditoID').focus();
	
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});		
	

	$('#solicitudCreditoID').bind('keyup',function(e) {
		lista('solicitudCreditoID', '2', '7','clienteID',$('#solicitudCreditoID').val(),'listaSolicitudCredito.htm');
	});

	$('#solicitudCreditoID').blur(function() {
		if(isNaN($('#solicitudCreditoID').val())){
			$('#solicitudCreditoID').focus();
				limpiaCampos();
		}else{
			consultaSolici();
		}
	});
	
	$('#modificar').click(function() {	
		$('#tipoTransaccion').val(tipoTransaccion.actualizaTasa);		
		
	});

	$('#sobreTasa').blur(function() {
		var valorTasaBase = $('#tasaBaseValor').asNumber();
		var valorSobreTasa = $('#sobreTasa').asNumber();
		if(valorTasaBase>0 && valorSobreTasa>0){
			$('#tasaFija').val(parseFloat(valorTasaBase) + parseFloat(valorSobreTasa)).change();
			$('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
		} else {
			$('#tasaFija').val('').change();
		}
	});
	
	$('#condiModificar').change(function(){	
		$("#formaGenerica").validate().resetForm();	
		$('#tasaFija').val('');
		$('#factorMora').val('');		
		$('#montoPorComAper').val('');	
		
		var tipo = $("#condiModificar").asNumber();	
		var tipocom= $('#tipoComxAperturaAna').val();	
		var cobraMora= $('#cobraMora').val();		
		
		$('#tipoComxApertura').val(tipocom);
		
		if(tipo == 0){
			
			deshabilitaBoton('modificar', 'submit');			
			deshabilitaControl('tasaFija');
			deshabilitaControl('factorMora');
			deshabilitaControl('montoPorComAper');
			deshabilitaControl('sobreTasa');
		} else if(tipo == tipoCondiModificar.Todos){		
			
			habilitaControl('tasaFija');				
			habilitaControl('montoPorComAper');
	
			if(cobraMora == 'S'){
				
				habilitaControl('factorMora');
				habilitaBoton('modificar', 'submit');	
				
				$('#tipoActualizacion').val(tipoActualizacion.actTsaFMCom);	
				
			}else{
				
				mensajeSis("El Producto de Crédito No Cobra Moratorio");
				deshabilitaBoton('modificar', 'submit');	
				deshabilitaControl('tasaFija');
				deshabilitaControl('factorMora');
				deshabilitaControl('montoPorComAper');
				deshabilitaControl('sobreTasa');
			}		
			
		} else if(tipo == tipoCondiModificar.TasaOrdinaria){
			
			habilitaBoton('modificar', 'submit');
			habilitaControl('tasaFija');	
			deshabilitaControl('factorMora');
			deshabilitaControl('montoPorComAper');
			deshabilitaControl('sobreTasa');
			
			$('#tipoActualizacion').val(tipoActualizacion.actTasaFija);		
			
		} else if(tipo == tipoCondiModificar.TasaMoratoria){			
						
			deshabilitaControl('tasaFija');
			deshabilitaControl('montoPorComAper');	
			deshabilitaControl('sobreTasa');
			
			if(cobraMora == 'S'){
				
				habilitaControl('factorMora');
				habilitaBoton('modificar', 'submit');
				
				$('#tipoActualizacion').val(tipoActualizacion.actTasaMora);		
				
			}else{
				
				mensajeSis("El Producto de Crédito No Cobra Moratorio");
				deshabilitaBoton('modificar', 'submit');	
				
			}
		} else if(tipo == tipoCondiModificar.ComisionXApertura){
			
			habilitaBoton('modificar', 'submit');			
			deshabilitaControl('tasaFija');
			deshabilitaControl('factorMora');
			deshabilitaControl('sobreTasa');
			habilitaControl('montoPorComAper');	
			
			$('#tipoActualizacion').val(tipoActualizacion.actComxApt);					
		} else if(tipo == tipoCondiModificar.SobreTasa){
			
			habilitaBoton('modificar', 'submit');
			deshabilitaControl('tasaFija');
			deshabilitaControl('factorMora');
			deshabilitaControl('montoPorComAper');
			habilitaControl('sobreTasa');
			$('#sobreTasa').focus();
			$('#tipoActualizacion').val(tipoActualizacion.actSobreTasa);					
		}
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 
						'contenedorForma', 'mensaje',
						'true','solicitudCreditoID',
				'funcionExitoSol','funcionErrorSol');	
				limpiaCampos();					
		}

	});	
	
	
	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			solicitudCreditoID:{
				required: true,					
			},
			tasaFija:{
				required: true,	
				number: true,
			},
			factorMora:{
				required: true,
				number: true,
				
			},
			montoPorComAper:{
				required: true,
				number: true,
				valorTasa: function() {
					var comi = $('#tipoComxAperturaAna').val();
					
					if(comi == 'P'){
						
						return true;
					}
				},
				
			},
			sobreTasa:{
				required : true,
				number : true
			}
		},		
		messages: {						
			solicitudCreditoID:{
				required:'Especificar Solicitud de Credito',			
			},
			tasaFija:{
				required:'Especificar Tasa Fija',	
				number : "Solo números",
			},
			factorMora:{
				required:'Especificar Factor Moratorio',
				number : "Solo números",
			},
			montoPorComAper:{
				required:'Especificar Comisión Por Apertura',
				number : "Solo números",
				valorTasa: "El procentaje debe de ser Menor o Igual al 100%",
			},
			sobreTasa:{
				required:'Especificar Sobre Tasa',	
				number : "Solo números",
			}
							
		}		
	});	
	
});	
	
	
function consultaSolici() {
	var numSol = $('#solicitudCreditoID').val();

	var tipConPantalla = 8;
	var SolBeanCon = {
		'solicitudCreditoID' : numSol
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numSol != '' && !isNaN(numSol)) { 		
		solicitudCredServicio.consulta(tipConPantalla, SolBeanCon,{ async: false, callback:
				function(solicitud) {	
					$("#formaGenerica").validate().resetForm();	
					if (solicitud != null) {						
						$('#cliNombreCompleto').val(solicitud.nombreCompletoCliente);
						$('#productoCreditoID').val(solicitud.productoCreditoID);
						$('#descripcion').val(solicitud.descripcionProducto);
						$('#fechaInicio').val(solicitud.fechaInicio);
						$('#cicloActual').val(solicitud.cicloActual);
						$('#fechaVencimiento').val(solicitud.fechaVencimiento);
						$('#plazoID').val(solicitud.desPlazo);
						$('#tasaFijaAna').val(solicitud.tasaFija);
						$('#factorMoraAna').val(solicitud.factorMora);
						$('#tipoComxAperturaAna').val(solicitud.tipoComXapert);
						$('#valorComxAperturaAna').val(solicitud.montoPorComAper);
						$('#cobraMora').val(solicitud.cobraMora);

						$('#tasaBaseAna').val(solicitud.tasaBase);
						$('#sobreTasaAna').val(solicitud.sobreTasa);
						$('#pisoTasaAna').val(solicitud.pisoTasa);
						$('#techoTasaAna').val(solicitud.techoTasa);
						muestraCamposTasa(solicitud.calcInteresID);	
						llenaComboCondicionesModif(solicitud.calcInteresID);
						
						if(solicitud.calcInteresID == TasaFijaID){	
							var selectTipCobComMorato=	eval("'#tipCobComMorato option[value="+solicitud.tipCobComMorato+"]'");								
							$(selectTipCobComMorato).attr('selected','true');
							
							habilitaControl('condiModificar');								
							$('#tasaFija').val('');
							$('#factorMora').val('');
							$('#tipoComxApertura').val('');
							$('#montoPorComAper').val('');	
							$('#condiModificar').val($('option:first', $('#condiModificar')).val());
							deshabilitaControl('tasaFija');
							deshabilitaControl('factorMora');
							deshabilitaControl('montoPorComAper');
							
						} else {
							habilitaControl('condiModificar');
						}
						$('#condiModificar').focus();

					} else {
						mensajeSis("Sólo se Permite el Cambio a Solicitudes Con Estatus Autorizada");
						$('#solicitudCreditoID').focus();
						limpiaCampos();						
					}	
					
					
				}
		
		});
		
		
	}
}

function limpiaCampos(){		
	$('#solicitudCreditoID').val('');
	$('#cliNombreCompleto').val('');
	$('#productoCreditoID').val('');
	$('#descripcion').val('');
	$('#fechaInicio').val('');
	$('#cicloActual').val('');
	$('#fechaVencimiento').val('');
	$('#plazoID').val('');
	$('#tasaFijaAna').val('');
	$('#factorMoraAna').val('');
	$('#tasaFija').val('');
	$('#factorMora').val('');
	$('#tipoComxApertura').val('');
	$('#montoPorComAper').val('');	
	$('#sobreTasa').val('');
	$('#condiModificar').val($('option:first', $('#condiModificar')).val());
	deshabilitaBoton('modificar');	
	deshabilitaControl('tasaFija');
	deshabilitaControl('factorMora');
	deshabilitaControl('montoPorComAper');
	muestraCamposTasa(0);
	llenaComboCondicionesModif(0);
}


function funcionExitoSol() {
	inicializaForma('formaGenerica','solicitudCreditoID');
	$('#condiModificar').val($('option:first', $('#condiModificar')).val());
	deshabilitaControl('tasaFija');
	deshabilitaControl('factorMora');
	deshabilitaControl('montoPorComAper');
	
}

function funcionErrorSol() {
	limpiaCampos();
}

// Funcion que llena el combo de calcInteres
function llenaComboCondicionesModif(calcInteresID) {
	dwr.util.removeAllOptions('condiModificar'); 
	// Si el calculo de interes es por tasaFija se llena el combo con las opciones para tasa fija
	if(calcInteresID <= TasaFijaID){
		dwr.util.addOptions('condiModificar', {'':'SELECCIONAR'});
		dwr.util.addOptions('condiModificar', {'2':'Todos'});
		dwr.util.addOptions('condiModificar', {'3':'Tasa Ordinaria'});
		dwr.util.addOptions('condiModificar', {'4':'Tasa Moratoria'});
		dwr.util.addOptions('condiModificar', {'5':'Comisión por Apertura'});
	} else {// sino solo para que se actualice la sobre tasa
		dwr.util.addOptions('condiModificar', {'':'SELECCIONAR'});
		dwr.util.addOptions('condiModificar', {'6':'Sobre Tasa'});
	}
}

// Funcion que llena el combo de calcInteres
function consultaComboCalInteres() {
	dwr.util.removeAllOptions('calcInteres'); 
	formTipoCalIntServicio.listaCombo(catFormTipoCalInt.principal,function(formTipoCalIntBean){
		dwr.util.addOptions('calcInteres', {'':'SELECCIONAR'});
		dwr.util.addOptions('calcInteres', formTipoCalIntBean, 'formInteresID', 'formula');
	});
}

// Funcion que consulta la tasa base 
function consultaTasaBase(idControl) {
	var jqTasa = eval("'#" + idControl + "'");
	var tasaBase = $(jqTasa).asNumber();
	var TasaBaseBeanCon = {
			'tasaBaseID' : tasaBase
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if (tasaBase > 0) {
		tasasBaseServicio.consulta(1, TasaBaseBeanCon, function(tasasBaseBean) {
			if (tasasBaseBean != null) {
				$('#desTasaBase').val(tasasBaseBean.nombre);
				$('#tasaBaseValor').val(tasasBaseBean.valor+'%');
				$('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
				$('#tasaBaseValor').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
			} else {
				$('#desTasaBase').val('');
				$('#tasaBaseValor').val('');
			}
		});
	}
}

// Funcion que muestra los campos de la tasa variable
function muestraCamposTasa(calcInteresID){
	calcInteresID = Number(calcInteresID);
	$('#calcInteres').val(calcInteresID);
	// Si el calculo de interes es por tasaFija se ocultan campos de tasa variable
	if(calcInteresID <= TasaFijaID){
		VarTasaFijaoBase = 'Tasa Fija Anualizada';
		VarTasaOrdinaria = 'Tasa Ordinaria';
		$('tr[name=tasaFija]').show();
		$('td[name=tasaFija]').show();
		$('tr[name=tasaBase]').hide();
		$('tr[name=tasaPisoTecho]').hide();
		$('td[name=tasaBase]').hide();
		$('#tasaBaseAna').val('');
		$('#desTasaBase').val('');
		$('#tasaBaseValor').val('');
		$('#sobreTasaAna').val('');
		$('#pisoTasaAna').val('');
		$('#techoTasaAna').val('');
	} else if(calcInteresID != TasaFijaID){
		// Si es por tasa variable, se consulta y se muestra
		VarTasaFijaoBase = 'Tasa Base Actual';
		VarTasaOrdinaria = 'Tasa Resultante';
		consultaTasaBase('tasaBaseAna');
		$('tr[name=tasaFija]').hide();
		$('td[name=tasaFija]').hide();
		$('td[name=tasaBase]').show();
		$('tr[name=tasaBase]').show();
		$('tr[name=tasaPisoTecho]').hide();
		if(calcInteresID == TasaBasePisoTecho){
			$('tr[name=tasaPisoTecho]').show();
		}
	}
	$('#lblTasaFija').text(VarTasaFijaoBase+': ');
	$('#lblTasaOrdinaria').text(VarTasaOrdinaria+': ');
}