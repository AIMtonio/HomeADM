var onlydigits6="\b\d{6}\b";
var esTab = true;
var catTipoTransaccionInvBan = {
  		'graba':'1',
  		'modifica':'2',
  		'elimina':'3'
	};
var catTipoConsultaInstituciones = {
		'principal':1, 
		'foranea':2
	};

$(document).ready(function() {
	inicializa();
	consultaConceptoInvBan();
	consultaMoneda();
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#MonedaID').change(function() {	
		consultaSubMoneda($('#ConceptoInvBanID').val());	
	});
	
	$('#InstitucionID').bind('keyup',function(e){
		lista('InstitucionID', '1', '1', 'nombre', $('#InstitucionID').val(), 'listaInstituciones.htm');
	});	
	
	$('#InstitucionID').blur(function() {
		    if($('#InstitucionID').val()!=""){
		    	consultaInstitucion();  
		}
	});	
	
	$('#Cuenta').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#Cuenta').val();
			listaAlfanumerica('Cuenta', '1', '2', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	$('#InstitucionID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
	});
	
	$('#Cuenta').blur(function() {
		if(esTab){
		setTimeout("$('#cajaLista').hide();", 200);
		}
	});
	
	//Si cambia el valor del concepto aplicarselo a todos los cmpos ocultos de concepto
	$('#ConceptoInvBanID').change(function() {	
		$('#InstitucionID').val('');
		$('#nombreInstitucion').val("");
		$('#SubCuentaInst').val("");
		$('#MonedaID').val('-1');
		$('#SubCuenta').val('');
		
		validaConcepto('ConceptoInvBanID');	
		$('#ConceptoInvBanID2').val($('#ConceptoInvBanID').val());
		$('#ConceptoInvBanID3').val($('#ConceptoInvBanID').val());
		$('#ConceptoInvBanID4').val($('#ConceptoInvBanID').val());
		$('#ConceptoInvBanID5').val($('#ConceptoInvBanID').val());
		$('#ConceptoInvBanID6').val($('#ConceptoInvBanID').val());
		$('#ConceptoInvBanID1').val($('#ConceptoInvBanID').val());
	});	
	$('#ConceptoInvBanID').blur(function() {	
		validaConcepto('ConceptoInvBanID');	
		$('#ConceptoInvBanID2').val($('#ConceptoInvBanID').val());
		$('#ConceptoInvBanID3').val($('#ConceptoInvBanID').val());
		$('#ConceptoInvBanID4').val($('#ConceptoInvBanID').val());
		$('#ConceptoInvBanID5').val($('#ConceptoInvBanID').val());
		$('#ConceptoInvBanID6').val($('#ConceptoInvBanID').val());
		$('#ConceptoInvBanID1').val($('#ConceptoInvBanID').val());
	});	
	
	/*=================VALIDACIONES===============================*/
	// EVENTO SUBMIT
	$.validator.setDefaults({	
	      submitHandler: function(event) { 
	      	
	      		//console.log("submitHandler");
	      	//MAYOR
	      	if($('#tipoTransaccionCM').val()==1||$('#tipoTransaccionCM').val()==2||$('#tipoTransaccionCM').val()==3){
	      		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'Cuenta','funcionExitoCM','funcionFalloGuiaConta');
	   		}
			//MONEDA
			if($('#tipoTransaccionTM').val()==1 || $('#tipoTransaccionTM').val()==2 || $('#tipoTransaccionTM').val()==3 ){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica1', 'contenedorForma', 'mensaje', 'true', 'MonedaID','funcionExitoTM','funcionFalloGuiaConta');
	   		}
	   		//INSTITUCION
	   		if($('#tipoTransaccionTP').val()==1||$('#tipoTransaccionTP').val()==2||$('#tipoTransaccionTP').val()==3){
	   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje', 'true', 'Moral','funcionExitoTP','funcionFalloGuiaConta');
	   		}
	   		//TITULO
	   		if($('#tipoTransaccionTT').val()==1||$('#tipoTransaccionTT').val()==2||$('#tipoTransaccionTT').val()==3){
	   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica3', 'contenedorForma', 'mensaje', 'true', 'TituNegocio','funcionExitoTT','funcionFalloGuiaConta');
	   		}
	   		//RESTRICCION
			if($('#tipoTransaccionR').val()==1||$('#tipoTransaccionR').val()==2||$('#tipoTransaccionR').val()==3){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica4', 'contenedorForma', 'mensaje', 'true', 'RestricionCon','funcionExitoR','funcionFalloGuiaConta');
	   		}
	   		//DEUDA
			if($('#tipoTransaccionTD').val()==1||$('#tipoTransaccionTD').val()==2||$('#tipoTransaccionTD').val()==3){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica5', 'contenedorForma', 'mensaje', 'true', 'TipoDeuGuber','funcionExitoTD','funcionFalloGuiaConta');
	   		}
	   		//PLAZO
			if($('#tipoTransaccionPB').val()==1||$('#tipoTransaccionPB').val()==2||$('#tipoTransaccionPB').val()==3){
				//console.log("PLAZO");
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica6', 'contenedorForma', 'mensaje', 'false', 'Plazo','funcionExitoPB','funcionFalloGuiaConta');
	   		}
	   
	   	}
	   });		
	// MAYOR
	$('#formaGenerica').validate({
		rules: {
			ConceptoInvBanID: 'required',
			Cuenta		: {
				maxlength	: 	4
			}
		},
		
		messages: {
			ConceptoInvBanID: 'Especifique Concepto',
			Cuenta		: {
				maxlength	: 	'Maximo Cuatro Digitos'
			}
		}		
	});
	//MONEDA
	$('#formaGenerica1').validate({
		rules: {
			ConceptoInvBanID1: 'required'
		},
		
		messages: {
			ConceptoInvBanID1: 'Especifique Concepto'
		}		
	});
	//INSTITUCION
	$('#formaGenerica2').validate({
		rules: {
			ConceptoInvBanID2: 'required'
		},
		
		messages: {
			ConceptoInvBanID2: 'Especifique Concepto'
		}		
	});
	//TITULO
	$('#formaGenerica3').validate({
		rules: {
			ConceptoInvBanID3: 'required',
			TituNegocio: 		{
				number: 		true
			},
			TituDispVenta: 		{
				number: 		true
			},
			TituConsVenc: 		{
				number: 		true
			}
		},
		messages: {
			ConceptoInvBanID3: 'Especifique Concepto',
			TituNegocio: 		{
				number: 		'Soló números'
			},
			TituDispVenta: 		{
				number: 		'Soló números'
			},
			TituConsVenc: 		{
				number: 		'Soló números'
			}
		}
	});
	//RESTRICCION
	$('#formaGenerica4').validate({
		rules: {
			ConceptoInvBanID4: 'required'
		},
		
		messages: {
			ConceptoInvBanID4: 'Especifique Concepto'
		}		
	});
	//DEUDA
	$('#formaGenerica5').validate({
		rules: {
			ConceptoInvBanID5: 'required',
			TipoDeuGuber: 		{
				number: 		true
			},
			TipoDeuBanca: 		{
				number: 		true
			},
			TipoDeuOtros: 		{
				number: 		true
			}
		},
		
		messages: {
			ConceptoInvBanID5: 'Especifique Concepto',
			TipoDeuGuber: 		{
				number: 		'Soló números'
			},
			TipoDeuBanca: 		{
				number: 		'Soló números'
			},
			TipoDeuOtros: 		{
				number: 		'Soló números'
			}
		}		
	});
	//PLAZO BANCARIO
	$('#formaGenerica6').validate({
		rules: {
			ConceptoInvBanID: 'required'
		},
		
		messages: {
			ConceptoInvBanID: 'Especifique Concepto'
		}		
	});
	
	/*======== FIN VALIDACIONES DE LA FORMA ==================================*/
	/*======== EVENTO GRABAR, MODIFICAR, ELIMINAR ============================*/
	// MAYOR
	$('#grabaCM').click(function() { $('#tipoTransaccionCM').val(catTipoTransaccionInvBan.graba);});
	$('#modificaCM').click(function() { $('#tipoTransaccionCM').val(catTipoTransaccionInvBan.modifica);});
	$('#eliminaCM').click(function() { $('#tipoTransaccionCM').val(catTipoTransaccionInvBan.elimina);});
	// MONEDA
	$('#grabaTM').click(function() { 
		//console.log("Graba"); 
	$('#tipoTransaccionTM').val(catTipoTransaccionInvBan.graba);});
	$('#modificaTM').click(function() { $('#tipoTransaccionTM').val(catTipoTransaccionInvBan.modifica);});
	$('#eliminaTM').click(function() { $('#tipoTransaccionTM').val(catTipoTransaccionInvBan.elimina);});
	// INSTITUCION
	$('#grabaTP').click(function() { $('#tipoTransaccionTP').val(catTipoTransaccionInvBan.graba);});
	$('#modificaTP').click(function() { $('#tipoTransaccionTP').val(catTipoTransaccionInvBan.modifica);});
	$('#eliminaTP').click(function() { $('#tipoTransaccionTP').val(catTipoTransaccionInvBan.elimina);});
	// TITULO
	$('#grabaTT').click(function() { $('#tipoTransaccionTT').val(catTipoTransaccionInvBan.graba);});
	$('#modificaTT').click(function() { $('#tipoTransaccionTT').val(catTipoTransaccionInvBan.modifica);});
	$('#eliminaTT').click(function() { $('#tipoTransaccionTT').val(catTipoTransaccionInvBan.elimina);});
	// RESTRICCION
	$('#grabaR').click(function() { $('#tipoTransaccionR').val(catTipoTransaccionInvBan.graba);});
	$('#modificaR').click(function() { $('#tipoTransaccionR').val(catTipoTransaccionInvBan.modifica);});
	$('#eliminaR').click(function() { $('#tipoTransaccionR').val(catTipoTransaccionInvBan.elimina);});
	// DEUDA
	$('#grabaTD').click(function() { $('#tipoTransaccionTD').val(catTipoTransaccionInvBan.graba);});
	$('#modificaTD').click(function() { $('#tipoTransaccionTD').val(catTipoTransaccionInvBan.modifica);});
	$('#eliminaTD').click(function() { $('#tipoTransaccionTD').val(catTipoTransaccionInvBan.elimina);});
	// PLAZO BANCARIO
	$('#grabaPB').click(function() { $('#tipoTransaccionPB').val(catTipoTransaccionInvBan.graba);});
	$('#modificaPB').click(function() { $('#tipoTransaccionPB').val(catTipoTransaccionInvBan.modifica);});
	$('#eliminaPB').click(function() { $('#tipoTransaccionPB').val(catTipoTransaccionInvBan.elimina);});
});

//==================================CONSULTA A SERVICIOS ==================================//
function consultaSubCuentas(numConcepto) {	
	consultaSubMoneda(numConcepto);//MONEDA
	consultaSubInstitucion(numConcepto);//INSTITUCION
	consultaSubTitulo(numConcepto);//TITULO
	consultaSubRestriccion(numConcepto);//RESTRICCION
	consultaSubDeuda(numConcepto);//DEUDA
	consultaSubPlazo(numConcepto);//PLAZO
}
/**
 * Llamado al servicio de conceptos de inversiones bancarias
 */
function consultaConceptoInvBan(){
	//console.log("consultaConceptoInvBan");
	dwr.util.removeAllOptions('ConceptoInvBanID'); 
	dwr.util.addOptions('ConceptoInvBanID', {"0":'SELECCIONAR'}); 
	conceptosInverBanServicio.listaCombo(1, function(conceptosInvBan){
		dwr.util.addOptions('ConceptoInvBanID', conceptosInvBan, 'conceptoInvBanID', 'descripcion');
	});
}
/**
 * Llamada al servicio de conceptos de moneda
 */
function consultaMoneda() {	
	//console.log("consultaMoneda");
	dwr.util.removeAllOptions('MonedaID');
	dwr.util.addOptions('MonedaID', {"0":'SELECCIONAR'}); 
	monedasServicio.listaCombo(3, function(monedas){
	dwr.util.addOptions('MonedaID', monedas, 'monedaID', 'descripcion');
	});
}
function consultaInstitucion() {
	//console.log("consultaInstitucion: "+$('#InstitucionID').val());
//	var jqInstituto = eval("'#" + idControl + "'");
	//var numInstituto = $('#InstitucionID').val();
	setTimeout("$('#cajaLista').hide();", 200);	
	var InstitutoBeanCon = {
		'institucionID': $('#InstitucionID').val()
	};
	if($('#InstitucionID').val()!='' && !isNaN($('#InstitucionID').val())){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){		
				if(instituto!=null){							
					$('#nombreInstitucion').val(instituto.nombre);
					var numConcepto = $("#ConceptoInvBanID").val();	
					consultaSubInstitucion(numConcepto);
					
				}else{
					alert("No existe la Institución"); 
					$('#InstitucionID').val('');
					$('#InstitucionID').focus();
					$('#nombreInstitucion').val("");
					$('#SubCuentaInst').val("");
				}
			});
	}else{
		$('#InstitucionID').val('');
		$('#nombreInstitucion').val("");
		$('#SubCuentaInst').val("");
	}
	
}
/** :::::::::::::::::::::. CONSULTA DE SUBCUENTAS :::::::::::::::::::::**/
function consultaSubMoneda(numConcepto){
	//console.log("consultaSubMoneda");
	if(numConcepto>0){
		var tipConPrincipal = 1;
		var monedaID= $('#MonedaID').asNumber();
		var SubCuentaM = {
			'conceptoInvBanID'	:numConcepto,
			'monedaID'			:monedaID
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && monedaID>0/*&& esTab*/){
			subCtaMonedaInvBanServicio.consulta(tipConPrincipal, SubCuentaM,function(subCuentaMoneda) {
				//console.log("subCtaMonedaInvBanServicio");
				if(subCuentaMoneda!=null){
					//console.log("no es nulo moneda");
					$('#ConceptoInvBanID1').val(subCuentaMoneda.conceptoInvBanID);
					$('#MonedaID').val(subCuentaMoneda.monedaID);
					$('#SubCuenta').val(subCuentaMoneda.subCuenta);
					deshabilitaBoton('grabaTM', 'submit');
					habilitaBoton('modificaTM', 'submit');
					habilitaBoton('eliminaTM', 'submit');
				} else {
					deshabilitaBoton('modificaTM', 'submit');
					deshabilitaBoton('eliminaTM', 'submit');
					habilitaBoton('grabaTM', 'submit');
					//$('#MonedaID').val('-1');
					$('#SubCuenta').val('');
				}
			});
		}
	}
		
}
function consultaSubInstitucion(numConcepto){
	//console.log("consultaSubInstitucion"+numConcepto);
	if(numConcepto > 0) {
		var tipConPrincipal = 1;
		var institucionID=$('#InstitucionID').asNumber();
		if(institucionID>0) {
			var SubCuentaTP = {
				'conceptoInvBanID'	:numConcepto,
				'institucionID': institucionID
			};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numConcepto != '' && !isNaN(numConcepto) && esTab){
				subCtaInstInvBanServicio.consulta(tipConPrincipal, SubCuentaTP,function(subCuentaPersona) {
					if(subCuentaPersona!=null){
						$('#ConceptoInvBanID2').val($("#ConceptoInvBanID").val());
						$('#InstitucionID').val(subCuentaPersona.institucionID);
						$('#SubCuentaInst').val(subCuentaPersona.subCuenta);
						deshabilitaBoton('grabaTP', 'submit');
						habilitaBoton('modificaTP', 'submit');
						habilitaBoton('eliminaTP', 'submit');
					} else {
						deshabilitaBoton('modificaTP', 'submit');
						deshabilitaBoton('eliminaTP', 'submit');
						habilitaBoton('grabaTP', 'submit');
						//$('#InstitucionID').val('');
						$('#SubCuentaInst').val('');
					}
				});
			}
		}
	}
}
function consultaSubTitulo(numConcepto){
	//console.log("consultaSubTitulo");
	var tipConPrincipal = 1;
	var SubCuentaTT = {
		'conceptoInvBanID'	:numConcepto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){
		subCtaTituInvBanServicio.consulta(tipConPrincipal, SubCuentaTT,function(subCuentaTitulo) {
			if(subCuentaTitulo!=null){
				$('#ConceptoInvBanID3').val(subCuentaTitulo.conceptoInvBanID);
				$('#TituNegocio').val(subCuentaTitulo.tituNegocio);
				$('#TituDispVenta').val(subCuentaTitulo.tituDispVenta);
				$('#TituConsVenc').val(subCuentaTitulo.tituConsVenc);
				deshabilitaBoton('grabaTT', 'submit');
				habilitaBoton('modificaTT', 'submit');
				habilitaBoton('eliminaTT', 'submit');
			} else {
				deshabilitaBoton('modificaTT', 'submit');
				deshabilitaBoton('eliminaTT', 'submit');
				habilitaBoton('grabaTT', 'submit');
				$('#TituNegocio').val('');
				$('#TituDispVenta').val('');
				$('#TituConsVenc').val('');
			}
		});
	}
}
function consultaSubRestriccion(numConcepto){
	try{
	//console.log("consultaSubRestriccion");
	var tipConPrincipal = 1;
	var SubCuentaTR = {
		'conceptoInvBanID'	:numConcepto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){
		subCtaRestInvBanServicio.consulta(tipConPrincipal, SubCuentaTR,function(subCuentaRestriccion) {
			if(subCuentaRestriccion!=null){
				$('#ConceptoInvBanID4').val(subCuentaRestriccion.conceptoInvBanID);
				$('#RestricionCon').val(subCuentaRestriccion.restricionCon);
				$('#RestricionSin').val(subCuentaRestriccion.restricionSin);
				deshabilitaBoton('grabaR', 'submit');
				habilitaBoton('modificaR', 'submit');
				habilitaBoton('eliminaR', 'submit');
			} else {
				deshabilitaBoton('modificaR', 'submit');
				deshabilitaBoton('eliminaR', 'submit');
				habilitaBoton('grabaR', 'submit');
				$('#RestricionCon').val('');
				$('#RestricionSin').val('');
			}
		});
	}
}
catch(err){
	//console.log(err.message);
}
}
function consultaSubDeuda(numConcepto){
	//console.log("consultaSubDeuda");
	var tipConPrincipal = 1;
	var SubCuentaTD = {
		'conceptoInvBanID'	:numConcepto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){
		subCtaDeudaInvBanServicio.consulta(tipConPrincipal, SubCuentaTD,function(subCuentaDeuda) {
			if(subCuentaDeuda!=null){
				$('#ConceptoInvBanID5').val(subCuentaDeuda.conceptoInvBanID);
				$('#TipoDeuGuber').val(subCuentaDeuda.tipoDeuGuber);
				$('#TipoDeuBanca').val(subCuentaDeuda.tipoDeuBanca);
				$('#TipoDeuOtros').val(subCuentaDeuda.tipoDeuOtros);
				deshabilitaBoton('grabaTD', 'submit');
				habilitaBoton('modificaTD', 'submit');
				habilitaBoton('eliminaTD', 'submit');
			} else {
				deshabilitaBoton('modificaTD', 'submit');
				deshabilitaBoton('eliminaTD', 'submit');
				habilitaBoton('grabaTD', 'submit');
				$('#TipoDeuGuber').val('');
				$('#TipoDeuBanca').val('');
				$('#TipoDeuOtros').val('');
			}
		});
	}
}
function consultaSubPlazo(numConcepto){
	//console.log("consultaSubPlazo: "+numConcepto);
	var tipConPrincipal = 1;
	var SubCuentaP = {
		'conceptoInvBanID'	:numConcepto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto)){
		subCtaPlazoInvBanServicio.consulta(tipConPrincipal, SubCuentaP,function(subCuentaPlazo) {
			//console.log("Entro subCtaPlazoInvBanServicio.consulta");
			if(subCuentaPlazo!=null){
				$('#ConceptoInvBanID6').val(subCuentaPlazo.conceptoInvBanID);
				$('#Plazo').val(subCuentaPlazo.plazo);
				$('#SubPlazoMayor').val(subCuentaPlazo.subPlazoMayor);
				$('#SubPlazoMenor').val(subCuentaPlazo.subPlazoMenor);
				deshabilitaBoton('grabaPB', 'submit');
				habilitaBoton('modificaPB', 'submit');
				habilitaBoton('eliminaPB', 'submit');
			} else {
				deshabilitaBoton('modificaPB', 'submit');
				deshabilitaBoton('eliminaPB', 'submit');
				habilitaBoton('grabaPB', 'submit');
				$('#Plazo').val('');
				$('#SubPlazoMayor').val('');
				$('#SubPlazoMenor').val('');
			}
		});
	}
}
/** ::::::::::::::::.. FIN CONSULTA SUBCUENTAS ..::::::::::::::::::::: **/
/** :::::::::::::::.. AYUDA ..:::::::::::::::::::::::::::::::::::::::: **/
function ayuda(){	
	var data;			       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
	'<div id="ContenedorAyuda">'+
	'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura:</legend>'+
	'<table id="tablaLista">'+
	'<td class="label">'+
		'<tr>'+
			'<td id="encabezadoLista">&CM</td><td id="contenidoAyuda" align="left"><b>Cuentas de Mayor</b></td>'+
		'</tr>'+
		'<tr>'+
			'<td id="encabezadoLista" >&TM</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Tipo de Moneda</b></td>'+
		'</tr>'+
		'<tr>'+
			'<td id="encabezadoLista">&TI</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Insituci&oacute;n</b></td>'+
		'</tr>'+
		'<tr>'+
			'<td id="encabezadoLista">&TT</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Tipo de T&iacute;tulo</b></td> '+
		'</tr>'+
		'<tr> '+
			'<td id="encabezadoLista">&TR</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Restricci&oacute;n</b></td>'+
		'</tr>'+
		'<tr> '+
			'<td id="encabezadoLista">&TD</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Tipo de Deuda</b></td>'+
		'</tr>'+
		'<tr> '+
			'<td id="encabezadoLista">&PB</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Plazo Bancario</b></td>'+
		'</tr>'+
	'</table>'+
	'<br>'+
	'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
	'<div id="ContenedorAyuda">'+
	'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo: Cuenta de Pasivo</legend>'+
	'<table id="tablaLista">'+
		'<tr>'+
			'<td id="encabezadoAyuda"><b>Cuenta: </b></td> '+
			'<td colspan="6" id="contenidoAyuda">2101</td>'+
		'</tr>'+
		'<tr>'+
			'<td colspan="9" id="encabezadoAyuda"><b>Nomenclatura:</b></td> '+
		'</tr>'+
		'<tr id="contenidoAyuda">'+
			'<td>&CM</td><td>-</td>'+
			'<td>&TM</td><td>-</td>'+
			'<td>&TI</td><td>-</td>'+
			'<td>&TT</td><td>-</td>'+
			'<td>&TR</td><td>-</td>'+
			'<td>&TD</td><td>-</td>'+
			'<td>&PB</td>'+
		'</tr>'+
		'<tr>'+
			'<td id="encabezadoAyuda" colspan="9"><b>Cuenta Completa:</b></td>'+
		'</tr>'+
		'<tr id="contenidoAyuda">'+
			'<td>2101</td><td>-</td>'+
			'<td>01</td><td>-</td>'+
			'<td>01</td><td>-</td>'+
			'<td>01</td><td>-</td>'+
			'<td>01</td><td>-</td>'+
			'<td>01</td><td>-</td>'+
			'<td>01</td><td>-</td>'+
		'</tr>'+
		'<tr>'+
			'<td id="encabezadoAyuda"><b>Descripci&oacute;n:</b></td> '+
			'<td colspan="8" id="contenidoAyuda"><i>CUENTA PARA INVERSION BANCARIA</i></td>'+
		'</tr>'+
	'</table>'+
	'</div></div> '+
	'</fieldset>'+
	'</fieldset>';
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '400px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}	
//OTROS
function inicializa(){
	// MAYOR
	deshabilitaBoton('grabaCM', 'submit');
	deshabilitaBoton('modificaCM', 'submit');
	deshabilitaBoton('eliminaCM', 'submit');
	$('#tipoTransaccionCM').val(0);
	// MONEDA
	deshabilitaBoton('grabaTM', 'submit');
	deshabilitaBoton('modificaTM', 'submit');
	deshabilitaBoton('eliminaTM', 'submit');
	$('#tipoTransaccionTM').val(0);
	// Institucion
	deshabilitaBoton('grabaTP', 'submit');
	deshabilitaBoton('modificaTP', 'submit');
	deshabilitaBoton('eliminaTP', 'submit');
	$('#tipoTransaccionTP').val(0);
	// TITULO
	deshabilitaBoton('grabaTT', 'submit');
	deshabilitaBoton('modificaTT', 'submit');
	deshabilitaBoton('eliminaTT', 'submit');
	$('#tipoTransaccionTT').val(0);
	// RESTRICCION
	deshabilitaBoton('grabaR', 'submit');
	deshabilitaBoton('modificaR', 'submit');
	deshabilitaBoton('eliminaR', 'submit');
	$('#tipoTransaccionR').val(0);
	// DEUDA
	deshabilitaBoton('grabaTD', 'submit');
	deshabilitaBoton('modificaTD', 'submit');
	deshabilitaBoton('eliminaTD', 'submit');
	$('#tipoTransaccionTD').val(0);
	// PLAZO BANCARIO
	deshabilitaBoton('grabaPB', 'submit');
	deshabilitaBoton('modificaPB', 'submit');
	deshabilitaBoton('eliminaPB', 'submit');
	$('#tipoTransaccionPB').val(0);

	
}
/**
 * Valida el concepto
 * @param idControl
 */
function validaConcepto(idControl) {
	//console.log("Valida concepto................");
	var jqConcepto = eval("'#" + idControl + "'");
	var numConcepto = $("#ConceptoInvBanID").val();	
	var tipConPrincipal = 1;
	var CuentaMayorBeanCon = {
		'conceptoInvBanID'	:numConcepto
	};
	setTimeout("$('#cajaLista').hide();", 200);	
	if(numConcepto != '' && !isNaN(numConcepto)){	
		//console.log('numConcepto entro');
		if(numConcepto=='-1'){
			//console.log("Concepto: -1");
			deshabilitaBoton('grabaCM', 'submit');     
			inicializaForma('formaGenerica','ConceptoInvBanID');	
		} else {
			cuentasMayorInvBanServicio.consulta(1, CuentaMayorBeanCon,function(cuentaM) {
					//console.log("cuentasMayorInvBanServicio");
					if(cuentaM!=null){
						$('#Cuenta').val(cuentaM.cuenta);
						$('#Nomenclatura').val(cuentaM.nomenclatura);
						$('#NomenclaturaCR').val(cuentaM.nomenclaturaCR);
						consultaSubCuentas(numConcepto);
						deshabilitaBoton('grabaCM', 'submit'); 
						habilitaBoton('modificaCM', 'submit');
						habilitaBoton('eliminaCM', 'submit');
					}else{
						consultaSubCuentas(numConcepto);
						deshabilitaBoton('modificaCM', 'submit');
						deshabilitaBoton('eliminaCM', 'submit');
						habilitaBoton('grabaCM', 'submit');
						$('#Cuenta').focus();
						$('#Cuenta').val('');
						$('#Nomenclatura').val('');
						$('#NomenclaturaCR').val('');
						//$('#subCuenta').val('');							
					}
			});														
		}												
	}
} // fin validaConcepto
function insertAtCaret(areaId,text) { 
    var txtarea = document.getElementById(areaId); 
    var scrollPos = txtarea.scrollTop; 
    var strPos = 0;  
    var br = ((txtarea.selectionStart || txtarea.selectionStart == '0') ?  
    "ff" : (document.selection ? "ie" : false ) ); 
    if (br == "ie") {  
    txtarea.focus(); 
    var range = document.selection.createRange(); 
    range.moveStart ('character', -txtarea.value.length); 
    strPos = range.text.length; 
    }  
    else if (br == "ff") strPos = txtarea.selectionStart; 
    var front = (txtarea.value).substring(0,strPos);   
    var back = (txtarea.value).substring(strPos,txtarea.value.length);  
    txtarea.value=front+text+back; 
    strPos = strPos + text.length; 
    if (br == "ie") {  
    txtarea.focus();  
    var range = document.selection.createRange(); 
    range.moveStart ('character', -txtarea.value.length); 
    range.moveStart ('character', strPos); 
    range.moveEnd ('character', 0); 
    range.select(); 
    } 
    else if (br == "ff") { 
    txtarea.selectionStart = strPos; 
    txtarea.selectionEnd = strPos; 
    txtarea.focus();  
    } 
    txtarea.scrollTop = scrollPos; 
} 
/** ================= FUNCIONES DE EXITO ========================= **/
//MAYOR
function funcionExitoCM(){
	esTab=true;
	//INICIALIZANDO LOS CAMPOS DE TRANSACCIÓN
	$('#tipoTransaccionCM').val(0);//MAYOR
	$('#tipoTransaccionTM').val(0);//MONEDA
	$('#tipoTransaccionTP').val(0);//INSTITUCION
	$('#tipoTransaccionTT').val(0);//TITULO
	$('#tipoTransaccionR').val(0);//RESTRICCION
	$('#tipoTransaccionTD').val(0);//DEUDA
	$('#tipoTransaccionPB').val(0);//PLAZO
	validaConcepto('conceptoAhoID');
	//DESHABILITANDO BOTONES
	if($('#tipoTransaccionCM').val()==1){
		deshabilitaBoton('grabaCM', 'submit'); 
		habilitaBoton('modificaCM', 'submit');
		habilitaBoton('eliminaCM', 'submit');	
		$('#tipoTransaccionCM').val(0);
	}else{
		if($('#tipoTransaccionCM').val()==2){
			deshabilitaBoton('grabaCM', 'submit'); 
			habilitaBoton('modificaCM', 'submit');
			habilitaBoton('eliminaCM', 'submit');	
			$('#tipoTransaccionCM').val(0);
		}else{
			if($('#tipoTransaccionCM').val()==3){
				habilitaBoton('grabaCM', 'submit'); 
				deshabilitaBoton('modificaCM', 'submit');
				deshabilitaBoton('eliminaCM', 'submit');
				$('#tipoTransaccionCM').val(0);	
			}
		}
	}
	//FIN DESHABILITA BOTONES
}
//MONEDA
function funcionExitoTM(){
	esTab=true;
	//INICIALIZANDO LOS CAMPOS DE TRANSACCIÓN
	$('#tipoTransaccionCM').val(0);//MAYOR
	$('#tipoTransaccionTM').val(0);//MONEDA
	$('#tipoTransaccionTP').val(0);//INSTITUCION
	$('#tipoTransaccionTT').val(0);//TITULO
	$('#tipoTransaccionR').val(0);//RESTRICCION
	$('#tipoTransaccionTD').val(0);//DEUDA
	$('#tipoTransaccionPB').val(0);//PLAZO
	var numConcepto = $("#ConceptoInvBanID").val();	
	consultaSubMoneda(numConcepto);
	//DESHABILITANDO BOTONES
	if($('#tipoTransaccionTM').val()==1){
		deshabilitaBoton('grabaTM', 'submit'); 
		habilitaBoton('modificaTM', 'submit');
		habilitaBoton('eliminaTM', 'submit');	
		$('#tipoTransaccionTM').val(0);
	}else{
		if($('#tipoTransaccionTM').val()==2){
			deshabilitaBoton('grabaTM', 'submit'); 
			habilitaBoton('modificaTM', 'submit');
			habilitaBoton('eliminaTM', 'submit');	
			$('#tipoTransaccionTM').val(0);
		}else{
			if($('#tipoTransaccionTM').val()==3){
				habilitaBoton('grabaTM', 'submit'); 
				deshabilitaBoton('modificaTM', 'submit');
				deshabilitaBoton('eliminaTM', 'submit');
				$('#tipoTransaccionTM').val(0);	
			}
		}
	}
	//FIN DESHABILITA BOTONES
}
//INSTITUCION
function funcionExitoTP(){
	console.log("funcionExitoTP");
	esTab=true;
	//INICIALIZANDO LOS CAMPOS DE TRANSACCIÓN
	$('#tipoTransaccionCM').val(0);//MAYOR
	$('#tipoTransaccionTM').val(0);//MONEDA
	$('#tipoTransaccionTP').val(0);//INSTITUCION
	$('#tipoTransaccionTT').val(0);//TITULO
	$('#tipoTransaccionR').val(0);//RESTRICCION
	$('#tipoTransaccionTD').val(0);//DEUDA
	$('#tipoTransaccionPB').val(0);//PLAZO
	var numConcepto = $("#ConceptoInvBanID").val();	
	consultaSubInstitucion(numConcepto);
	//DESHABILITANDO BOTONES
	if($('#tipoTransaccionTP').val()==1){
		deshabilitaBoton('grabaTP', 'submit'); 
		habilitaBoton('modificaTP', 'submit');
		habilitaBoton('eliminaTP', 'submit');	
		$('#tipoTransaccionTP').val(0);
	}else{
		if($('#tipoTransaccionTP').val()==2){
			deshabilitaBoton('grabaTP', 'submit'); 
			habilitaBoton('modificaTP', 'submit');
			habilitaBoton('eliminaTP', 'submit');	
			$('#tipoTransaccionTP').val(0);
		}else{
			if($('#tipoTransaccionTP').val()==3){
				habilitaBoton('grabaTP', 'submit'); 
				deshabilitaBoton('modificaTP', 'submit');
				deshabilitaBoton('eliminaTP', 'submit');
				$('#tipoTransaccionTP').val(0);	
			}
		}
	}
	//FIN DESHABILITA BOTONES
}
//TITULO
function funcionExitoTT(){
	esTab=true;
	//INICIALIZANDO LOS CAMPOS DE TRANSACCIÓN
	$('#tipoTransaccionCM').val(0);//MAYOR
	$('#tipoTransaccionTM').val(0);//MONEDA
	$('#tipoTransaccionTP').val(0);//INSTITUCION
	$('#tipoTransaccionTT').val(0);//TITULO
	$('#tipoTransaccionR').val(0);//RESTRICCION
	$('#tipoTransaccionTD').val(0);//DEUDA
	$('#tipoTransaccionPB').val(0);//PLAZO
	var numConcepto = $("#ConceptoInvBanID").val();	
	consultaSubTitulo(numConcepto);
	//DESHABILITANDO BOTONES
	if($('#tipoTransaccionTT').val()==1){
		deshabilitaBoton('grabaTT', 'submit'); 
		habilitaBoton('modificaTT', 'submit');
		habilitaBoton('eliminaTT', 'submit');	
		$('#tipoTransaccionTT').val(0);
	}else{
		if($('#tipoTransaccionTT').val()==2){
			deshabilitaBoton('grabaTT', 'submit'); 
			habilitaBoton('modificaTT', 'submit');
			habilitaBoton('eliminaTT', 'submit');	
			$('#tipoTransaccionTT').val(0);
		}else{
			if($('#tipoTransaccionTT').val()==3){
				habilitaBoton('grabaTT', 'submit'); 
				deshabilitaBoton('modificaTT', 'submit');
				deshabilitaBoton('eliminaTT', 'submit');
				$('#tipoTransaccionTT').val(0);	
			}
		}
	}
	//FIN DESHABILITA BOTONES
}
//RESTRICCION
function funcionExitoR(){
	esTab=true;
	//INICIALIZANDO LOS CAMPOS DE TRANSACCIÓN
	$('#tipoTransaccionCM').val(0);//MAYOR
	$('#tipoTransaccionTM').val(0);//MONEDA
	$('#tipoTransaccionTP').val(0);//INSTITUCION
	$('#tipoTransaccionTT').val(0);//TITULO
	$('#tipoTransaccionR').val(0);//RESTRICCION
	$('#tipoTransaccionTD').val(0);//DEUDA
	$('#tipoTransaccionPB').val(0);//PLAZO
	var numConcepto = $("#ConceptoInvBanID").val();	
	consultaSubRestriccion(numConcepto);
	//DESHABILITANDO BOTONES
	if($('#tipoTransaccionR').val()==1){
		deshabilitaBoton('grabaR', 'submit'); 
		habilitaBoton('modificaR', 'submit');
		habilitaBoton('eliminaR', 'submit');	
		$('#tipoTransaccionR').val(0);
	}else{
		if($('#tipoTransaccionR').val()==2){
			deshabilitaBoton('grabaR', 'submit'); 
			habilitaBoton('modificaR', 'submit');
			habilitaBoton('eliminaR', 'submit');	
			$('#tipoTransaccionR').val(0);
		}else{
			if($('#tipoTransaccionR').val()==3){
				habilitaBoton('grabaR', 'submit'); 
				deshabilitaBoton('modificaR', 'submit');
				deshabilitaBoton('eliminaR', 'submit');
				$('#tipoTransaccionR').val(0);	
			}
		}
	}
	//FIN DESHABILITA BOTONES
}
//DEUDA
function funcionExitoTD(){
	esTab=true;
	//INICIALIZANDO LOS CAMPOS DE TRANSACCIÓN
	$('#tipoTransaccionCM').val(0);//MAYOR
	$('#tipoTransaccionTM').val(0);//MONEDA
	$('#tipoTransaccionTP').val(0);//INSTITUCION
	$('#tipoTransaccionTT').val(0);//TITULO
	$('#tipoTransaccionR').val(0);//RESTRICCION
	$('#tipoTransaccionTD').val(0);//DEUDA
	$('#tipoTransaccionPB').val(0);//PLAZO
	var numConcepto = $("#ConceptoInvBanID").val();	
	consultaSubDeuda(numConcepto);
	//DESHABILITANDO BOTONES
	if($('#tipoTransaccionTD').val()==1){
		deshabilitaBoton('grabaTD', 'submit'); 
		habilitaBoton('modificaTD', 'submit');
		habilitaBoton('eliminaTD', 'submit');	
		$('#tipoTransaccionTD').val(0);
	}else{
		if($('#tipoTransaccionTD').val()==2){
			deshabilitaBoton('grabaTD', 'submit'); 
			habilitaBoton('modificaTD', 'submit');
			habilitaBoton('eliminaTD', 'submit');	
			$('#tipoTransaccionTD').val(0);
		}else{
			if($('#tipoTransaccionTD').val()==3){
				habilitaBoton('grabaTD', 'submit'); 
				deshabilitaBoton('modificaTD', 'submit');
				deshabilitaBoton('eliminaTD', 'submit');
				$('#tipoTransaccionTD').val(0);	
			}
		}
	}
	//FIN DESHABILITA BOTONES
}
//PLAZO
function funcionExitoPB(){
	esTab=true;
	//INICIALIZANDO LOS CAMPOS DE TRANSACCIÓN
	$('#tipoTransaccionCM').val(0);//MAYOR
	$('#tipoTransaccionTM').val(0);//MONEDA
	$('#tipoTransaccionTP').val(0);//INSTITUCION
	$('#tipoTransaccionTT').val(0);//TITULO
	$('#tipoTransaccionR').val(0);//RESTRICCION
	$('#tipoTransaccionTD').val(0);//DEUDA
	$('#tipoTransaccionPB').val(0);//PLAZO

	var numConcepto = $("#ConceptoInvBanID").val();	
	consultaSubPlazo(numConcepto);
	//DESHABILITANDO BOTONES
	if($('#tipoTransaccionPB').val()==1){
		deshabilitaBoton('grabaPB', 'submit'); 
		habilitaBoton('modificaPB', 'submit');
		habilitaBoton('eliminaPB', 'submit');	
		$('#tipoTransaccionPB').val(0);
	}else{
		if($('#tipoTransaccionPB').val()==2){
			deshabilitaBoton('grabaPB', 'submit'); 
			habilitaBoton('modificaPB', 'submit');
			habilitaBoton('eliminaPB', 'submit');	
			$('#tipoTransaccionPB').val(0);
		}else{
			if($('#tipoTransaccionPB').val()==3){
				habilitaBoton('grabaPB', 'submit'); 
				deshabilitaBoton('modificaPB', 'submit');
				deshabilitaBoton('eliminaPB', 'submit');
				$('#tipoTransaccionPB').val(0);	
			}
		}
	}
	//FIN DESHABILITA BOTONES
}
//Funcion de fallo de la guia contable
function funcionFalloGuiaConta(){
	//console.log("funcionFalloGuiaConta");
}
