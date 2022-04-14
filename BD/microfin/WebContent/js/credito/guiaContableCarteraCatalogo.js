$(document).ready(function() {
	
	$("#conceptoCarID").focus();
	
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionCartera = {
  		'graba':'1',
  		'modifica':'2',
  		'elimina':'3'
	};

	var catTipoConsultaCartera = {
  		'principal':1,
  		'foranea':2
	};	

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	deshabilita();
	
	function deshabilita(){
		deshabilitaBoton('grabaCM', 'submit');     
		deshabilitaBoton('grabaClas', 'submit');	
		deshabilitaBoton('grabaPro', 'submit');	
		deshabilitaBoton('grabaMon', 'submit');
		deshabilitaBoton('grabaFon', 'submit');
		deshabilitaBoton('grabaSubClas', 'submit');
		deshabilitaBoton('grabaIA', 'submit');
	
		deshabilitaBoton('modificaCM', 'submit');
		deshabilitaBoton('modificaClas', 'submit');
		deshabilitaBoton('modificaPro', 'submit');
		deshabilitaBoton('modificaMon', 'submit');
		deshabilitaBoton('modificaFon', 'submit');
		deshabilitaBoton('modificaSubClas', 'submit');
		deshabilitaBoton('modificaIA', 'submit');
		
	
		deshabilitaBoton('eliminaCM', 'submit');
		deshabilitaBoton('eliminaClas', 'submit');
		deshabilitaBoton('eliminaPro', 'submit');
		deshabilitaBoton('eliminaMon', 'submit');
		deshabilitaBoton('eliminaFon', 'submit');
		deshabilitaBoton('eliminaSubClas', 'submit');
		deshabilitaBoton('eliminaIA', 'submit');
   }
   
   function vacia(){
		$('#cuenta').focus();
		$('#cuenta').val('');
		$('#nomenclatura').val('');
		$('#nomenclaturaCR').val('');								
		$('#subCuenta').val('');
		$('#subcuenta1').val('');
		$('#subcuenta5').val('');
		$('#consumo').val('');
		$('#comercial').val('');
		$('#vivienda').val('');		   
		$('#subCuenta7').val('');
		$('#porcentaje').val('');
   }
   
   // CONSULTA FONDEADOR
   
	$('#fondeoID').bind('keyup',function(e) {
		lista('fondeoID', '2', '1','nombreInstitFon', $('#fondeoID').val(),'intitutFondeoLista.htm');
	});

	$('#fondeoID').blur(function() {
		if(esTab){
			  if($('#fondeoID').val()!='' && $('#fondeoID').asNumber()>=0 && !isNaN($('#fondeoID').val() )){
					consultaInstitucionFondeo(this.id);
					consultaSubCuentaFD($('#conceptoCarID6').val());
			  }else{
			  		$('#fondeoID').focus();
					$('#fondeoID').val("");
					$('#descripFondeo').val("");
					$('#subCuenta6').val("");
			  }
		}
	});
	
	function consultaInstitucionFondeo(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		var tipoCon = 1;
		var instFondeoBeanCon = {
				'institutFondID' : numInstituto
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if (numInstituto != '' && !isNaN(numInstituto)) {
			fondeoServicio.consulta(tipoCon,instFondeoBeanCon,function(instituto) {
				if (instituto != null) {
					$('#descripFondeo').val(instituto.nombreInstitFon);
					$('#fondeoID').val(numInstituto);

				} else {
					var institucion = $('#fondeoID').val();
					if (institucion != '0' && institucion != '') {
						mensajeSis("No Existe la Institución");
						$('#fondeoID').focus();
						$('#fondeoID').select();
					}
				}
			});
		}
	}

	
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionCC').val(0);
	$('#tipoTransaccionPC').val(0);
	$('#tipoTransaccionMC').val(0);
	$('#tipoTransaccionSC').val(0);
	$('#tipoTransaccionFD').val(0);
	$('#tipoTransaccionIA').val(0); /*Límpia tipo de transaccion para IVA*/
	
	$.validator.setDefaults({	
      submitHandler: function(event) {       
      	if($('#tipoTransaccionCM').val()==1 || $('#tipoTransaccionCM').val()==2 || $('#tipoTransaccionCM').val()==3){
      		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'cuenta','exito','fallo');		
   		}   
		if($('#tipoTransaccionCC').val()==1 || $('#tipoTransaccionCC').val()==2 || $('#tipoTransaccionCC').val()==3 ){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje', 'true', 'consumo','exito','fallo');				
   		}  
   		if($('#tipoTransaccionPC').val()==1 || $('#tipoTransaccionPC').val()==2 || $('#tipoTransaccionPC').val()==3){
   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica3', 'contenedorForma', 'mensaje', 'true', 'subCuenta','exito','fallo');				
   		} 
   		if($('#tipoTransaccionMC').val()==1 || $('#tipoTransaccionMC').val()==2 || $('#tipoTransaccionMC').val()==3){
   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica4', 'contenedorForma', 'mensaje', 'true', 'SubCuenta1','exito','fallo');
   		}   
   		if($('#tipoTransaccionSC').val()==1 || $('#tipoTransaccionSC').val()==2 || $('#tipoTransaccionSC').val()==3){
   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica5', 'contenedorForma', 'mensaje', 'true', 'SubCuenta5','exito','fallo');		
											
   		}
   		if($('#tipoTransaccionFD').val()==1 || $('#tipoTransaccionFD').val()==2 || $('#tipoTransaccionFD').val()==3){
   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica6', 'contenedorForma', 'mensaje', 'true', 'SubCuenta6','exito','fallo');		
			deshabilitaBoton('grabaFon', 'submit');
			habilitaBoton('modificaFon', 'submit');	
			habilitaBoton('eliminaFon', 'submit');		
   		}
   		/*Si el tipoTransaccionIA es alguna acccion (graba,modifica o elimina) ejecuta dicha transaccion*/
   		if($('#tipoTransaccionIA').val()==1 || $('#tipoTransaccionIA').val()==2 || $('#tipoTransaccionIA').val()==3){
   			grabaFormaTransaccionRetrollamada(event,'formaGenerica7', 'contenedorForma', 'mensaje', 'true', 'subCuenta7', 'exito','fallo');
   		}
      }
   });		
   
   $(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#monedaID').change(function(){
		if($('#conceptoCarID').val()!=0)
			consultaSubCuentaM($('#conceptoCarID').val());
	});
	
	$('#producCreditoID').change(function(){
		if($('#conceptoCarID').val()!=0)
			consultaSubCuentaP($('#conceptoCarID').val());
	});

	$('#porcentaje').change(function(){
		consultaSubCuentaIA($('#conceptoCarID').val());
	});
	
	$('#grabaCM').click(function() {
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionCM').val(catTipoTransaccionCartera.graba);
		$('#tipoTransaccionIA').val(0);
	});
	$('#grabaClas').click(function() {		
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionCC').val(catTipoTransaccionCartera.graba);
		$('#tipoTransaccionIA').val(0);
	}); 
	$('#grabaPro').click(function() {		
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionPC').val(catTipoTransaccionCartera.graba);
		$('#tipoTransaccionIA').val(0);
	});
	
	//FONDEADOR
	$('#grabaFon').click(function() {	
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionFD').val(catTipoTransaccionCartera.graba);
		$('#tipoTransaccionIA').val(0);
	});

	$('#grabaMon').click(function() {		
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionMC').val(catTipoTransaccionCartera.graba);
		$('#tipoTransaccionIA').val(0);
	});
	$('#grabaSubClas').click(function(){
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionSC').val(catTipoTransaccionCartera.graba);
		$('#tipoTransaccionIA').val(0);
	});
	/*Transacción Grabar para la FormaGenerica del IVA*/
	$('#grabaIA').click(function(){
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionIA').val(catTipoTransaccionCartera.graba);
	});
	

	
	$('#modificaCM').click(function() {		
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionCM').val(catTipoTransaccionCartera.modifica);
		$('#tipoTransaccionIA').val(0);
	});

	$('#modificaClas').click(function() {
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionCC').val(catTipoTransaccionCartera.modifica);
		$('#tipoTransaccionIA').val(0);
	}); 
	$('#modificaPro').click(function() {	
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionPC').val(catTipoTransaccionCartera.modifica);
		$('#tipoTransaccionIA').val(0);
	}); 
	$('#modificaMon').click(function() {
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionMC').val(catTipoTransaccionCartera.modifica);
		$('#tipoTransaccionIA').val(0);
	});
	$('#modificaSubClas').click(function() {
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionSC').val(catTipoTransaccionCartera.modifica);
		$('#tipoTransaccionIA').val(0);
	});
	//FONDEADOR
	$('#modificaFon').click(function() {		
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionFD').val(catTipoTransaccionCartera.modifica);
		$('#tipoTransaccionIA').val(0);
	});
	/*Transacción Modificar para la FormaGenerica de IVA*/
	$('#modificaIA').click(function() {		
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionIA').val(catTipoTransaccionCartera.modifica);
	});
	

	
	$('#eliminaCM').click(function() {		
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionCM').val(catTipoTransaccionCartera.elimina);
		$('#tipoTransaccionIA').val(0);
	});
	$('#eliminaClas').click(function() {
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionCC').val(catTipoTransaccionCartera.elimina);
		$('#tipoTransaccionIA').val(0);
	}); 
	$('#eliminaPro').click(function() {	
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionPC').val(catTipoTransaccionCartera.elimina); 
		$('#tipoTransaccionIA').val(0);
	}); 
	$('#eliminaMon').click(function() {	
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionMC').val(catTipoTransaccionCartera.elimina);
		$('#tipoTransaccionIA').val(0);
	});
	$('#eliminaSubClas').click(function() {	
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionSC').val(catTipoTransaccionCartera.elimina);
		$('#tipoTransaccionIA').val(0);
	});
	//FONDEADOR
	$('#eliminaFon').click(function() {		
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionFD').val(catTipoTransaccionCartera.elimina);
		$('#tipoTransaccionIA').val(0);
	});
	/*Transacción Eliminar para la FormaGenerica de IVA*/
	$('#eliminaIA').click(function() {		
		$('#tipoTransaccionCM').val(0);
		$('#tipoTransaccionCC').val(0);
		$('#tipoTransaccionPC').val(0);
		$('#tipoTransaccionSC').val(0);
		$('#tipoTransaccionMC').val(0);
		$('#tipoTransaccionFD').val(0);
		$('#tipoTransaccionIA').val(catTipoTransaccionCartera.elimina);
	});
	
	
	$('#conceptoCarID').change(function(){
		validaConcepto('conceptoCarID');
			 
		$('#conceptoCarID2').val($('#conceptoCarID').val());
		$('#conceptoCarID3').val($('#conceptoCarID').val());
		$('#conceptoCarID4').val($('#conceptoCarID').val());
		$('#conceptoCarID5').val($('#conceptoCarID').val());
		$('#conceptoCarID6').val($('#conceptoCarID').val());
		$('#conceptoCarID7').val($('#conceptoCarID').val());
	});


	
	$('#cuenta').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#cuenta').val();
			lista('cuenta', '1', '2', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 	
	

	consultaConceptosCar();
  	consultaMoneda();	
  	consultaProducto();
  	consultaSubClasificacion();

  	function consultaConceptosCar() {	
  		dwr.util.removeAllOptions('conceptoCarID'); 
  		dwr.util.addOptions('conceptoCarID', {0:'SELECCIONAR'}); 
		conceptosCarteraServicio.listaCombo(1, function(conceptosCar){
			dwr.util.addOptions('conceptoCarID', conceptosCar, 'conceptoCarID', 'descripcion');
		});
	}
	
	function consultaMoneda() {			
  		dwr.util.removeAllOptions('monedaID');
  		dwr.util.addOptions('monedaID', {0:'SELECCIONAR'}); 
		monedasServicio.listaCombo(3, function(monedas){
		dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}
	
	function consultaProducto(){
		dwr.util.removeAllOptions('producCreditoID');
  		dwr.util.addOptions('producCreditoID', {0:'SELECCIONAR'}); 
		productosCreditoServicio.listaCombo(16, function(producto){
		dwr.util.addOptions('producCreditoID', producto, 'producCreditoID', 'descripcion');
		});	
	}
	
	function consultaSubClasificacion(){
		dwr.util.removeAllOptions('producCreditoID5');
  		dwr.util.addOptions('producCreditoID5', {0:'SELECCIONAR'}); 
  		SubClasiBean={
  			'descripClasifica':0	
  		};
  		clasificCreditoServicio.listaCombo(3,SubClasiBean, function(producto){
  			dwr.util.addOptions('producCreditoID5', producto, 'clasificacionID', 'descripClasifica');
		});
	}
	
	
	$('#formaGenerica').validate({
		rules: {
			conceptoCarID	: 'required',
			cuenta			: {
				maxlength	: 	4
			}
		},
		
		messages: {
			conceptoCarID	: 'Especifique Concepto',
			cuenta			: {
				maxlength	: 	'Máximo Cuatro Dígitos'
			}
		}		
	});
	
	$('#formaGenerica2').validate({
		rules: {
			conceptoCarID2	: 'required',
			consumo			: {
				required 	: true,
				number		: true
			},
			comercial		: {
				required 	: true,
				number		: true
			},
			vivienda		: {
				required 	: true,
				number		: true
			}
		},
		
		messages: {
			conceptoCarID2	: 'Especifique Concepto',
			consumo			: {
				required 	: 'Especifique Cuenta Consumo',
				number		: 'Solo Números'
			},
			comercial		: {
				required 	: 'Especifique Cuenta Consumo',
				number		: 'Solo Números'
			},
			vivienda		: {
				required 	: 'Especifique Cuenta Consumo',
				number		: 'Solo Números'
			}
			
		}		
	});
	
		$('#formaGenerica3').validate({
		rules: {
			conceptoCarID3	: 'required',
			subCuenta		: {
				maxlength	: 	3,
				number		: true
			}
		},		
		messages: {
			conceptoCarID3	: 'Especifique Concepto',
			subCuenta		: {
				maxlength	: 	'Máximo 3 Dígitos',
				number		: 	'Solo Números'	
			}
		}		
	});
	
		
	$('#formaGenerica4').validate({
		rules: {
			conceptoCarID4	: 'required',
			subCuenta1		: {
				maxlength	: 	2,
				number		:	true
			}
		},
		
		messages: {
			conceptoCarID4	: 'Especifique Concepto',
			subCuenta1		: {
				maxlength	: 	'Como Máximo Dos Dígitos',
				number  	:   'Solo Números'
			}
		}		
	});
	
	$('#formaGenerica5').validate({
		rules: {
			conceptoCarID5	: 'required',
			subCuenta5		: {
				maxlength	: 	6,
				number		: true
			}
		},		
		messages: {
			conceptoCarID5	: 'Especifique Concepto',
			subCuenta5		: {
				maxlength	: 'Máximo 6 Dígitos',
				number		: 'Solo Números'
			}
		}		
	});
	
	$('#formaGenerica6').validate({
		rules: {
			conceptoCarID6	: 'required',
			subCuenta6		: {
				maxlength	: 	2,
				number		:	true
			}
		},
		
		messages: {
			conceptoCarID6	: 'Especifique Concepto',
			subCuenta6		: {
				maxlength	: 	'Como Máximo Dos Dígitos',
				number  	:   'Solo Números'
			}
		}
	});
	
	/*Validación para la forma generica 7 de la sección IVA*/
	$('#formaGenerica7').validate({
		rules:{
			porcentaje 	: 'required',
			subCuenta7		:{
				maxlength	: 2,
				number		: true
			}
		},
		messages : {
			porcentaje	: 'Especificar % de IVA',
			subCuenta7		:{
				maxlength	: 'Como Máximo Dos Dígitos',
				number		: 'Solo Números'
			}
		}
	});
			//------------ Validaciones de Controles -------------------------------------
	
	function validaConcepto(idControl) {
		var jqConcepto = eval("'#" + idControl + "'");
		var numConcepto = $(jqConcepto).val();	
		var tipConPrincipal = 1;
		var CuentaMayorCarBean = {
			'conceptoCarID'	:numConcepto
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){		
			if($('#conceptoCarID').val()==0){
				vacia();				
				deshabilita();
			
				inicializaForma('formaGenerica','conceptoCarID');
							
			} else {
				cuentasMayorCarServicio.consulta(tipConPrincipal, CuentaMayorCarBean,function(cuentaM) {
						if(cuentaM!=null){
							$('#cuenta').val(cuentaM.cuenta);
							$('#nomenclatura').val(cuentaM.nomenclatura);
							$('#nomenclaturaCR').val(cuentaM.nomenclaturaCR);
							consultaSubCuentas(numConcepto);
							deshabilitaBoton('grabaCM', 'submit'); 
							habilitaBoton('modificaCM', 'submit');
							habilitaBoton('eliminaCM', 'submit');															
						}else{
							consultaSubCuentas(numConcepto);
							deshabilitaBoton('modificaCM', 'submit');
							deshabilitaBoton('eliminaCM', 'submit');
							habilitaBoton('grabaCM', 'submit');
							vacia();	
															
						}
				});														
			}												
		}
	}
	
	function consultaSubCuentas(numConcepto) {	
		consultaSubCuentaC(numConcepto);
		consultaSubCuentaP(numConcepto);
		consultaSubCuentaM(numConcepto);
		consultaSubCuentaSC(numConcepto);

		if($('#fondeoID').val()!=''){
			consultaSubCuentaFD(numConcepto);
		}

		$('#porcentaje').val('');
		consultaSubCuentaIA(numConcepto);	
	}

		// CONSULTA SUBCUENTA FONDEADOR CONCEPTO
		function consultaSubCuentaFD(numConcepto) {	
			var fondID = 0;
			if($('#fondeoID').val()!=''){
				fondID = $('#fondeoID').val();
			}else{
				fondID = 0;
			}
			var SubfondeoBean = {
				'conceptoCarID'	:numConcepto,
				'fondeoID'		:fondID
			};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numConcepto != '' && !isNaN(numConcepto) && esTab){
				  guiaContableCartServicio.consulta(catTipoConsultaCartera.principal, SubfondeoBean,function(subCuentaFD) {
					if(subCuentaFD!=null){

						$('#conceptoCarID6').val(subCuentaFD.conceptoCarID);			
						$('#subCuenta6').val(subCuentaFD.subCuenta);
						deshabilitaBoton('grabaFon', 'submit');
						habilitaBoton('modificaFon', 'submit');
						habilitaBoton('eliminaFon', 'submit');													
					}else{
						deshabilitaBoton('modificaFon', 'submit');
						deshabilitaBoton('eliminaFon', 'submit');
						habilitaBoton('grabaFon', 'submit');	
						$('#subCuenta6').val('');						
					}
				});											
			}
		}


	function consultaSubCuentaC(numConcepto) {	
	
		var SubClasific = {
			'conceptoCarID'	:numConcepto,

		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subctaClasifCartServicio.consulta(catTipoConsultaCartera.principal, SubClasific,function(subCuentaC) {			
				if(subCuentaC!=null){
					$('#conceptoCarID2').val(subCuentaC.conceptoCarID);			
					$('#consumo').val(subCuentaC.consumo);
					$('#comercial').val(subCuentaC.comercial);
					$('#vivienda').val(subCuentaC.vivienda);
					deshabilitaBoton('grabaClas', 'submit');
					habilitaBoton('modificaClas', 'submit');
					habilitaBoton('eliminaClas', 'submit');													
				}else{
					deshabilitaBoton('modificaClas', 'submit');
					deshabilitaBoton('eliminaClas', 'submit');
					habilitaBoton('grabaClas', 'submit');	
					$('#consumo').val("");
					$('#comercial').val("");
					$('#vivienda').val("");		
										
				}
			});											
		}
	}
	
	
	function consultaSubCuentaP(numConcepto) {	
	
		var SubProducto = {
			'conceptoCarID'	:numConcepto,
			'producCreditoID'		:$('#producCreditoID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subctaProductCartServicio.consulta(catTipoConsultaCartera.principal, SubProducto,function(subCuentaP) {
				if(subCuentaP!=null){
					$('#conceptoCarID3').val(subCuentaP.conceptoCarID);	
					$('#subCuenta').val(subCuentaP.subCuenta);
					deshabilitaBoton('grabaPro', 'submit');
					habilitaBoton('modificaPro', 'submit');
					habilitaBoton('eliminaPro', 'submit');													
				}else{
					deshabilitaBoton('modificaPro', 'submit');
					deshabilitaBoton('eliminaPro', 'submit');
					habilitaBoton('grabaPro', 'submit');	
					$('#subCuenta').val('');		
										
				}
			});											
		}
	}
	
	function consultaSubCuentaM(numConcepto) {	
	
		var SubMonedaBean = {
			'conceptoCarID'	:numConcepto,
			'monedaID'		:$('#monedaID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subctaMonedaCartServicio.consulta(catTipoConsultaCartera.principal, SubMonedaBean,function(subCuentaM) {
				if(subCuentaM!=null){
					$('#conceptoCarID4').val(subCuentaM.conceptoCarID);			
					$('#subCuenta1').val(subCuentaM.subCuenta);
					deshabilitaBoton('grabaMon', 'submit');
					habilitaBoton('modificaMon', 'submit');
					habilitaBoton('eliminaMon', 'submit');													
				}else{
					deshabilitaBoton('modificaMon', 'submit');
					deshabilitaBoton('eliminaMon', 'submit');
					habilitaBoton('grabaMon', 'submit');	
					$('#subCuenta1').val('');						
				}
			});											
		}
	}
	
	function consultaSubCuentaSC(numConcepto) {
		var SubClasific = {
			'conceptoCarID'	 :numConcepto,
			'productoCartID' : $('#producCreditoID5').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto)){
			subCtaSubClasifCartServicio.consulta(catTipoConsultaCartera.principal, SubClasific,function(subCuentaSC) {
				if(subCuentaSC!=null){
					$('#producCreditoID5').val(subCuentaSC.productoCartID);
					$('#subCuenta5').val(subCuentaSC.subCuenta);
					deshabilitaBoton('grabaSubClas', 'submit');
					habilitaBoton('modificaSubClas', 'submit');
					habilitaBoton('eliminaSubClas', 'submit');
				}else{
					deshabilitaBoton('modificaSubClas', 'submit');
					deshabilitaBoton('eliminaSubClas', 'submit');
					habilitaBoton('grabaSubClas', 'submit');
					$('#subCuenta5').val('');
				}
			});
		}
	}

	$('#producCreditoID5').change(function(){		
		consultaSubCuentaSC($('#conceptoCarID5').val());
	});
	
	function consultaSubCuentaIA(numConcepto){
		var subCuentaIVA = {
				'conceptoCartID' : numConcepto,
				'porcentaje'	: $('#porcentaje').val()
		};

		if(numConcepto!='' && !isNaN(numConcepto) && $('#porcentaje').val()!='' && !isNaN($('#porcentaje').val())){
			subCuentaIVACartServicio.consulta(catTipoConsultaCartera.principal,subCuentaIVA,function(subCuenta){
				if(subCuenta!=null){
					$('#subCuenta7').val(subCuenta.subCuenta);
					deshabilitaBoton('grabaIA', 'submit');
					habilitaBoton('modificaIA', 'submit');
					habilitaBoton('eliminaIA', 'submit');
				}else{
					deshabilitaBoton('modificaIA', 'submit');
					deshabilitaBoton('eliminaIA', 'submit');
					habilitaBoton('grabaIA', 'submit');
					$('#subCuenta7').val('');
				}
			});
		}else{
			deshabilitaBoton('grabaIA', 'submit');
			deshabilitaBoton('modificaIA', 'submit');
			deshabilitaBoton('eliminaIA', 'submit');
			$('#porcentaje').val('');
			$('#subCuenta7').val('');
		}
	}
	
});

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

function ayuda(){	
	var data;			       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura:</legend>'+
			'<div id="ContenedorAyuda">'+ 			
			'<table id="tablaLista">'+
				'<tr align="left">'+
					'<td id="encabezadoLista">&CM</td><td id="contenidoAyuda" align="left"><b>Cuentas de Mayor</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&CL</td><td id="contenidoAyuda" align="left"><b> SubCuenta por Clasificaci&oacute;n(Consumo, Comercial o Vivienda)</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&TP</td><td id="contenidoAyuda" align="left"><b> SubCuenta por Producto de Cr&eacute;dito</b></td>'+ 
				'</tr>'+
				'<tr>'+
				'<td id="encabezadoLista">&TM</td><td id="contenidoAyuda" align="left"><b> SubCuenta por Tipo de Moneda</b></td>'+ 
				'</tr>'+
			'</table>'+
			'<br>'+
			'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo: Cartera de Creditos al Consumo MN</legend>'+
			
			'<table id="tablaLista">'+				
				'<tr>'+
					'<td id="encabezadoAyuda" colspan="9"><b>Nomenclatura:</b></td>'+ 
				'</tr>'+
				'<tr align="center" id="contenidoAyuda" >'+
					'<td>&CM</td><td>-</td><td>&CL</td>'+
					'<td>-</td><td>&TM</td><td>-</td>'+
					'<td>&TP</td><td>-</td><td>00</td>'+
				'</tr>'+
				'<tr>'+
					'<td colspan="9" id="encabezadoAyuda"><b>Cuenta Completa:</b></td>'+ 
				'</tr>'+
				'<tr align="center" id="contenidoAyuda">'+
					'<td>1301</td><td>-</td><td>02</td>'+
					'<td>-</td><td>1</td><td>-</td>'+
					'<td>001</td><td>-</td><td>00</td>'+
				'</tr>'+				
			'</table>'+
			'</div></div>'+ 
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
	
function ayudaCR(){	
	var data;
	
				       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura Centro Costo:</legend>'+
			'<table id="tablaLista">'+
				'<tr align="left">'+
					'<td id="encabezadoLista">&SO</td><td id="contenidoAyuda"><b>Sucursal Origen</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista" >&SC</td><td id="contenidoAyuda"><b>Sucursal Cliente</b></td>'+
				'</tr>'+ 
			'</table>'+
			'<br>'+
			'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+  
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplos: </legend>'+
			'<table id="tablaLista">'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Ejemplo 1: </b></td>'+ 
					'<td id="contenidoAyuda">&SO</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Ejemplo 2:</b></td>'+ 
					'<td id="contenidoAyuda">&SC</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Ejemplo 3:</b></td>'+ 
					'<td id="contenidoAyuda">15</td>'+
				'</tr>'+
			'</table>'+
			'</div></div>'+  
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

/*Función para limpar el tipo de transaccion a todas las formas*/
function limpiaTiposTransaccion(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionCC').val(0);
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionPC').val(0);
	$('#tipoTransaccionMC').val(0);
	$('#tipoTransaccionSC').val(0);
	$('#tipoTransaccionFD').val(0);
	$('#tipoTransaccionIA').val(0);
}

function exito(){
	if($('#tipoTransaccionCM').val()==3){
		deshabilitaBoton('modificaCM', 'submit');
		deshabilitaBoton('eliminaCM', 'submit');
		habilitaBoton('grabaCM', 'submit');
	}else if($('#tipoTransaccionCM').val()==1 || $('#tipoTransaccionCM').val()==2){
		habilitaBoton('modificaCM', 'submit');
		habilitaBoton('eliminaCM', 'submit');
		deshabilitaBoton('grabaCM', 'submit');	
	}
	
	if($('#tipoTransaccionCC').val()==3){
		deshabilitaBoton('modificaClas', 'submit');
		deshabilitaBoton('eliminaClas', 'submit');
		habilitaBoton('grabaClas', 'submit');
		$('#consumo').val('');
		$('#comercial').val('');
		$('#vivienda').val('');
	}else if($('#tipoTransaccionCC').val()==1 || $('#tipoTransaccionCC').val()==2){
		habilitaBoton('modificaClas', 'submit');
		habilitaBoton('eliminaClas', 'submit');
		deshabilitaBoton('grabaClas', 'submit');		
	}
	
	if($('#tipoTransaccionPC').val()==3){
		deshabilitaBoton('modificaPro', 'submit');
		deshabilitaBoton('eliminaPro', 'submit');
		habilitaBoton('grabaPro', 'submit');
		$('#subCuenta').val('');
		$('#subCuenta').focus();
	}else if($('#tipoTransaccionPC').val()==1 || $('#tipoTransaccionPC').val()==2){
		habilitaBoton('modificaPro', 'submit');
		habilitaBoton('eliminaPro', 'submit');
		deshabilitaBoton('grabaPro', 'submit');
		$('#subCuenta').focus();
	}

	if($('#tipoTransaccionMC').val()==3){
		deshabilitaBoton('modificaMon', 'submit');
		deshabilitaBoton('eliminaMon', 'submit');
		habilitaBoton('grabaMon', 'submit');
		$('#subCuenta1').val('');
		$('#subCuenta1').focus();
	}else if($('#tipoTransaccionMC').val()==1 || $('#tipoTransaccionMC').val()==2){
		habilitaBoton('modificaMon', 'submit');
		habilitaBoton('eliminaMon', 'submit');
		deshabilitaBoton('grabaMon', 'submit');
		$('#subCuenta1').focus();
	}
	
	if($('#tipoTransaccionSC').val()==3){
		deshabilitaBoton('modificaSubClas', 'submit');
		deshabilitaBoton('eliminaSubClas', 'submit');
		habilitaBoton('grabaSubClas', 'submit');
		$('#subCuenta5').val('');
		$('#subCuenta5').focus();
	}else if($('#tipoTransaccionSC').val()==1 || $('#tipoTransaccionSC').val()==2){
		habilitaBoton('modificaSubClas', 'submit');
		habilitaBoton('eliminaSubClas', 'submit');
		deshabilitaBoton('grabaSubClas', 'submit');
		$('#subCuenta5').focus();
	}
	
	if($('#tipoTransaccionFD').val()==3){
		deshabilitaBoton('modificaSubClas', 'submit');
		deshabilitaBoton('eliminaSubClas', 'submit');
		habilitaBoton('grabaSubClas', 'submit');
		$('#subCuenta6').val('');
		$('#subCuenta6').focus();
	}else if($('#tipoTransaccionFD').val()==1 || $('#tipoTransaccionFD').val()==2){
		habilitaBoton('modificaSubClas', 'submit');
		habilitaBoton('eliminaSubClas', 'submit');
		deshabilitaBoton('grabaSubClas', 'submit');
		$('#subCuenta6').focus();
	}
	
	/* Valiación para habiliar botones después de transacción exitosa*/
	if($('#tipoTransaccionIA').val()==3){
		/*Si grabó solo puede modificar o eliminar*/
		deshabilitaBoton('modificaIA', 'submit');
		deshabilitaBoton('eliminaIA', 'submit');
		habilitaBoton('grabaIA', 'submit');
		$('#subCuenta7').val('');
		$('#subCuenta7').focus();
	}else if($('#tipoTransaccionIA').val()==1 || $('#tipoTransaccionIA').val()==2){
		/*Solo si elimina puede grabar nuevamente*/
		habilitaBoton('modificaIA', 'submit');
		habilitaBoton('eliminaIA', 'submit');
		deshabilitaBoton('grabaIA', 'submit');
		$('#subCuenta7').focus();
	}

	limpiaTiposTransaccion();
}

function fallo(){
	
}