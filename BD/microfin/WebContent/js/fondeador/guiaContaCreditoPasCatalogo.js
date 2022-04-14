$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionGuiaFondeo = {
  		'graba':1,
  		'modifica':2,
  		'elimina':3
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	validaConcepto('conceptoFondID');
	$('#tipoFondeador2').val($('#tipoFondeador').val());
	$('#tipoFondeador3').val($('#tipoFondeador').val());
	$('#tipoFondeador4').val($('#tipoFondeador').val());
	$('#tipoFondeador5').val($('#tipoFondeador').val());
	$('#tipoFondeador1').val($('#tipoFondeador').val());
	$('#tipoFondeador6').val($('#tipoFondeador').val());

	deshabilitaBoton('grabaCM', 'submit');     
	deshabilitaBoton('grabaPL', 'submit');
	deshabilitaBoton('grabaTP', 'submit');	
	deshabilitaBoton('grabaNC', 'submit');	
	deshabilitaBoton('grabaIF', 'submit');		
	deshabilitaBoton('grabaTPE', 'submit');
	deshabilitaBoton('grabaTM', 'submit');
	deshabilitaBoton('modificaCM', 'submit');
	deshabilitaBoton('modificaPL', 'submit');
	deshabilitaBoton('modificaTP', 'submit');
	deshabilitaBoton('modificaNC', 'submit');
	deshabilitaBoton('modificaIF', 'submit');
	deshabilitaBoton('modificaTPE', 'submit');
	deshabilitaBoton('modificaTM', 'submit');
	deshabilitaBoton('eliminaCM', 'submit');
	deshabilitaBoton('eliminaPL', 'submit');
	deshabilitaBoton('eliminaTP', 'submit');
	deshabilitaBoton('eliminaNC', 'submit');
	deshabilitaBoton('eliminaIF', 'submit');
	deshabilitaBoton('eliminaTPE', 'submit');
	deshabilitaBoton('eliminaTM', 'submit');
	
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionPLZ').val(0);
	$('#tipoTransaccionTPI').val(0);
	$('#tipoTransaccionNC').val(0);
	$('#tipoTransaccionIF').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionTM').val(0);

	$.validator.setDefaults({	
      submitHandler: function(event) { 
      	if($('#tipoTransaccionCM').val()==1||$('#tipoTransaccionCM').val()==2 ||$('#tipoTransaccionCM').val()==3){
      		if($('#tipoTransaccionCM').val()==1||$('#tipoTransaccionCM').val()==2){
      			habilitaBoton('modificaCM', 'submit');
      			habilitaBoton('eliminaCM', 'submit');
      			deshabilitaBoton('grabaCM', 'submit');
      		}else{
      			$('#cuenta').val('');
      			$('#nomenclatura').val('');
      			deshabilitaBoton('modificaCM', 'submit');
      			deshabilitaBoton('eliminaCM', 'submit');
      			habilitaBoton('grabaCM', 'submit');
      		}
      	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cuenta', 
    			  'funcionExito','funcionError');
     		$('#tipoTransaccionPL').val(0);
   			$('#tipoTransaccionTP').val(0);
			$('#tipoTransaccionIF').val(0);
			$('#tipoTransaccionNC').val(0);
			$('#tipoTransaccionCM').val(0);
			$('#tipoTransaccionTPE').val(0);
			$('#tipoTransaccionTM').val(0);
      	}

   		if($('#tipoTransaccionTPI').val()==1||$('#tipoTransaccionTPI').val()==2||$('#tipoTransaccionTPI').val()==3){
   			if($('#tipoTransaccionTPI').val()==1||$('#tipoTransaccionTPI').val()==2){
      			habilitaBoton('modificaTP', 'submit');
      			habilitaBoton('eliminaTP', 'submit');
      			deshabilitaBoton('grabaTP', 'submit');
      		}else{
      			$('#subCuenta').val('');
      			deshabilitaBoton('modificaTP', 'submit');
      			deshabilitaBoton('eliminaTP', 'submit');
      			habilitaBoton('grabaTP', 'submit');
      		}
   			
   		  grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje','true','subCuenta', 
    			  'funcionExito','funcionError');
   			$('#tipoTransaccionCM').val(0);
   			$('#tipoTransaccionPLZ').val(0);
			$('#tipoTransaccionIF').val(0);
			$('#tipoTransaccionNC').val(0);
   			$('#tipoTransaccionTPI').val(0);
			$('#tipoTransaccionTPE').val(0);
			$('#tipoTransaccionTM').val(0);
   		}
   		
   	 	if($('#tipoTransaccionPLZ').val()==1 || $('#tipoTransaccionPLZ').val()==2 || $('#tipoTransaccionPLZ').val()==3) {
   	 	if($('#tipoTransaccionPLZ').val()==1||$('#tipoTransaccionPLZ').val()==2){
  			habilitaBoton('modificaPL', 'submit');
  			habilitaBoton('eliminaPL', 'submit');
  			deshabilitaBoton('grabaPL', 'submit');
  		}else{
  			$('#cortoPlazo').val('');
  			$('#largoPlazo').val('');
  			deshabilitaBoton('modificaPL', 'submit');
  			deshabilitaBoton('eliminaPL', 'submit');
  			habilitaBoton('grabaPL', 'submit');
  		}
   	 	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica3', 'contenedorForma', 'mensaje','true','cortoPlazo', 
    			  'funcionExito','funcionError');
   			$('#tipoTransaccionCM').val(0);
   			$('#tipoTransaccionTPI').val(0);
			$('#tipoTransaccionIF').val(0);
			$('#tipoTransaccionNC').val(0);
   			$('#tipoTransaccionPLZ').val(0);
			$('#tipoTransaccionTPE').val(0);   
			$('#tipoTransaccionTM').val(0);
      	}

   		if($('#tipoTransaccionNC').val()==1||$('#tipoTransaccionNC').val()==2||$('#tipoTransaccionNC').val()==3){
   			if($('#tipoTransaccionNC').val()==1||$('#tipoTransaccionNC').val()==2){
   	  			habilitaBoton('modificaNC', 'submit');
   	  			habilitaBoton('eliminaNC', 'submit');
   	  			deshabilitaBoton('grabaNC', 'submit');
   	  		}else{
   	  			$('#nacional').val('');
   	  			$('#extranjera').val('');
   	  			deshabilitaBoton('modificaNC', 'submit');
   	  			deshabilitaBoton('eliminaNC', 'submit');
   	  			habilitaBoton('grabaNC', 'submit');
   	  		}
   		  grabaFormaTransaccionRetrollamada(event, 'formaGenerica4', 'contenedorForma', 'mensaje','true','nacional', 
    			  'funcionExito','funcionError');
   	
   			$('#tipoTransaccionCM').val(0);
   			$('#tipoTransaccionPLZ').val(0);
			$('#tipoTransaccionTPI').val(0);
			$('#tipoTransaccionIF').val(0);
			$('#tipoTransaccionNC').val(0);
			$('#tipoTransaccionTPE').val(0);
			$('#tipoTransaccionTM').val(0);
    		
		
   		}
		if($('#tipoTransaccionIF').val()==1||$('#tipoTransaccionIF').val()==2||$('#tipoTransaccionIF').val()==3){
			if($('#tipoTransaccionIF').val()==1||$('#tipoTransaccionIF').val()==2){
   	  			habilitaBoton('modificaIF', 'submit');
   	  			habilitaBoton('eliminaIF', 'submit');
   	  			deshabilitaBoton('grabaIF', 'submit');
   	  		}else{
   	  			$('#subCuentaIns').val('');
   	  			deshabilitaBoton('modificaIF', 'submit');
   	  			deshabilitaBoton('eliminaIF', 'submit');
   	  			habilitaBoton('grabaIF', 'submit');
   	  		}
			 grabaFormaTransaccionRetrollamada(event, 'formaGenerica5', 'contenedorForma', 'mensaje','true','subCuentaIns', 
	    			  'funcionExito','funcionError');
			$('#tipoTransaccionCM').val(0);
			$('#tipoTransaccionPLZ').val(0);
			$('#tipoTransaccionTPI').val(0);
			$('#tipoTransaccionNC').val(0);
			$('#tipoTransaccionIF').val(0);
			$('#tipoTransaccionTPE').val(0);
			$('#tipoTransaccionTM').val(0);
		}
		
		if($('#tipoTransaccionTPE').val()> 0){
			if($('#tipoTransaccionTPE').val()==1||$('#tipoTransaccionTPE').val()==2){
   	  			habilitaBoton('modificaTPE', 'submit');
   	  			habilitaBoton('eliminaTPE', 'submit');
   	  			deshabilitaBoton('grabaTPE', 'submit');
   	  		}else{
   	  			$('#fisica').val('');
   	  			$('#fisicaActEmp').val('');
   	  			$('#moral').val('');
   	  			deshabilitaBoton('modificaTPE', 'submit');
   	  			deshabilitaBoton('eliminaTPE', 'submit');
   	  			habilitaBoton('grabaTPE', 'submit');
   	  		}
			 grabaFormaTransaccionRetrollamada(event, 'formaGenerica1', 'contenedorForma', 'mensaje','true','fisica', 
	    			  'funcionExito','funcionError');
			$('#tipoTransaccionCM').val(0);
			$('#tipoTransaccionPLZ').val(0);
			$('#tipoTransaccionTPI').val(0);
			$('#tipoTransaccionNC').val(0);
			$('#tipoTransaccionIF').val(0);
			$('#tipoTransaccionTPE').val(0);
			$('#tipoTransaccionTM').val(0);
		}
		if($('#tipoTransaccionTM').val()==1 || $('#tipoTransaccionTM').val()==2 || $('#tipoTransaccionTM').val()==3){
			if($('#tipoTransaccionTM').val()==1||$('#tipoTransaccionTM').val()==2){
   	  			habilitaBoton('modificaTM', 'submit');
   	  			habilitaBoton('eliminaTM', 'submit');
   	  			deshabilitaBoton('grabaTM', 'submit');
   	  		}else{
   	  			$('#subCuentaTM').val('');
   	  			deshabilitaBoton('modificaTM', 'submit');
   	  			deshabilitaBoton('eliminaTM', 'submit');
   	  			habilitaBoton('grabaTM', 'submit');
   	  		}
			 grabaFormaTransaccionRetrollamada(event, 'formaGenerica6', 'contenedorForma', 'mensaje','true','subCuentaTM', 
	    			  'funcionExito','funcionError');
			$('#tipoTransaccionCM').val(0);
			$('#tipoTransaccionPLZ').val(0);
			$('#tipoTransaccionTPI').val(0);
			$('#tipoTransaccionNC').val(0);
			$('#tipoTransaccionIF').val(0);
			$('#tipoTransaccionTPE').val(0);
			$('#tipoTransaccionTM').val(0);
		}
      }
   });		


	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#grabaCM').click(function() {
		$('#tipoTransaccionCM').val(catTipoTransaccionGuiaFondeo.graba);
	});
	$('#modificaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionGuiaFondeo.modifica);
	});

	$('#eliminaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionGuiaFondeo.elimina);
	});
	
	$('#grabaTP').click(function() {		
		$('#tipoTransaccionTPI').val(catTipoTransaccionGuiaFondeo.graba);
	}); 
	
	$('#modificaTP').click(function() {		
		$('#tipoTransaccionTPI').val(catTipoTransaccionGuiaFondeo.modifica);
	});

	$('#eliminaTP').click(function() {		
		$('#tipoTransaccionTPI').val(catTipoTransaccionGuiaFondeo.elimina);
	});
	
	$('#grabaPL').click(function() {		
		$('#tipoTransaccionPLZ').val(catTipoTransaccionGuiaFondeo.graba);
	}); 
	
	$('#modificaPL').click(function() {		
		$('#tipoTransaccionPLZ').val(catTipoTransaccionGuiaFondeo.modifica);
	});
	
	$('#eliminaPL').click(function() {		
		$('#tipoTransaccionPLZ').val(catTipoTransaccionGuiaFondeo.elimina);
	});

	
	$('#grabaNC').click(function() {		
		$('#tipoTransaccionNC').val(catTipoTransaccionGuiaFondeo.graba);
	}); 
	
	$('#modificaNC').click(function() {		
		$('#tipoTransaccionNC').val(catTipoTransaccionGuiaFondeo.modifica);
	});
	
	$('#eliminaNC').click(function() {		
		$('#tipoTransaccionNC').val(catTipoTransaccionGuiaFondeo.elimina);
	});

	
	$('#grabaIF').click(function() {		
		$('#tipoTransaccionIF').val(catTipoTransaccionGuiaFondeo.graba);
	}); 
	
	$('#modificaIF').click(function() {		
		$('#tipoTransaccionIF').val(catTipoTransaccionGuiaFondeo.modifica);
	});
	
	$('#eliminaIF').click(function() {		
		$('#tipoTransaccionIF').val(catTipoTransaccionGuiaFondeo.elimina);
	});

	$('#grabaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionGuiaFondeo.graba);
	}); 
	
	$('#modificaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionGuiaFondeo.modifica);
	});
	
	$('#eliminaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionGuiaFondeo.elimina);
	});
	$('#grabaTM').click(function(){
		$('#tipoTransaccionTM').val(catTipoTransaccionGuiaFondeo.graba);
	});
	$('#modificaTM').click(function(){
		$('#tipoTransaccionTM').val(catTipoTransaccionGuiaFondeo.modifica);
	});
	$('#eliminaTM').click(function(){
		$('#tipoTransaccionTM').val(catTipoTransaccionGuiaFondeo.elimina);
	});
	
	$('#conceptoFondID').change(function() {	
		validaConcepto('conceptoFondID');	
		$('#conceptoFondID2').val($('#conceptoFondID').val());
		$('#conceptoFondID3').val($('#conceptoFondID').val());
		$('#conceptoFondID4').val($('#conceptoFondID').val());
		$('#conceptoFondID5').val($('#conceptoFondID').val());
		$('#conceptoFondID1').val($('#conceptoFondID').val());
		$('#conceptoFondID6').val($('#conceptoFondID').val());
	});	
	
	$('#conceptoFondID').blur(function() {	
		validaConcepto('conceptoFondID');	
		$('#conceptoFondID2').val($('#conceptoFondID').val());
		$('#conceptoFondID3').val($('#conceptoFondID').val());
		$('#conceptoFondID4').val($('#conceptoFondID').val());
		$('#conceptoFondID5').val($('#conceptoFondID').val());
		$('#conceptoFondID1').val($('#conceptoFondID').val());
		$('#conceptoFondID6').val($('#conceptoFondID').val());
	});	
	
	$('#tipoFondeador').blur(function() {
		validaConcepto('conceptoFondID');
		$('#tipoFondeador2').val($('#tipoFondeador').val());
		$('#tipoFondeador3').val($('#tipoFondeador').val());
		$('#tipoFondeador4').val($('#tipoFondeador').val());
		$('#tipoFondeador5').val($('#tipoFondeador').val());
		$('#tipoFondeador1').val($('#tipoFondeador').val());
		$('#tipoFondeador6').val($('#tipoFondeador').val());
	});
	$('#tipoFondeador').change(function() {
		validaConcepto('conceptoFondID');
		$('#tipoFondeador2').val($('#tipoFondeador').val());
		$('#tipoFondeador3').val($('#tipoFondeador').val());
		$('#tipoFondeador4').val($('#tipoFondeador').val());
		$('#tipoFondeador5').val($('#tipoFondeador').val());
		$('#tipoFondeador1').val($('#tipoFondeador').val());
		$('#tipoFondeador6').val($('#tipoFondeador').val());
	});
	
	$('#tipoInstitID').change(function() {	
		consultaSubTipoPro($('#conceptoFondID').val());
	});
	$('#institutFondID').change(function() {	
		consultaIF($('#conceptoFondID').val());
	});
	$('#monedaID').change(function(){
		consultaMonFon($('#conceptoFondID').val());
	});
	
	$('#cuenta').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#cuenta').val();
			listaAlfanumerica('cuenta', '1', '2', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	$('#cuenta').blur(function() {	
		setTimeout("$('#cajaLista').hide();", 200);	
	});
	
	
	

	//-----------combos ------------------------------- 
 	consultaConceptosFondeo();
  	consultaTiposInstitucion();
  	consultaInstitucion();
  	consultaMoneda();
	//------------ Validaciones de la Forma -------------------------------------
	
	
	$('#formaGenerica').validate({
		rules: {
			conceptoFondID: 'required',
			cuenta: {
				number: true,
					},
		},
		
		messages: {
			conceptoFondID: 'Especifique Concepto',
			cuenta		: {
				number	: 	'Solo Números'
			}
		}		
	});

	$('#formaGenerica2').validate({
		rules: {
			conceptoFondID2: 'required',
			subCuenta: {
				number: true,
					},
				
		},
		
		messages: {
			conceptoFondID2: 'Especifique Concepto',
			subCuenta: {
				number: 'Solo Números'
					},
		}		
	}); 	

	$('#formaGenerica3').validate({
		rules: {
			conceptoFondID3: 'required',
			cortoPlazo: {
				number:true
					},
			largoPlazo: {
				number:true
					}
		},
		
		messages: {
			conceptoFondID3: 'Especifique el Concepto',
			cortoPlazo: {
				number:'Solo Números',
					},
			largoPlazo: {
				number:'Solo Números'
					}		
		}		
	}); 
	
	$('#formaGenerica4').validate({
		rules: {
			conceptoAhoID4: 'required',
			nacional: {
				number:true,
					},
			extranjera: {
				number:true
					}		
		},
		
		messages: {
			conceptoAhoID4: 'Especifique el Concepto',
			nacional: {
				number:'Solo Números',
					},
			extranjera: {
				number:'Solo Números'
					}	
		}		
	}); 
	
	$('#formaGenerica5').validate({
		rules: {
			conceptoAhoID5: 'required',
			subCuentaIns		: {
				number	:true
			}
		},
		
		messages: {
			conceptoAhoID5: 'Especifique Concepto',
			subCuentaIns		: {
				number	: 	'Solo Números'
			}
		}		
	});
	$('#formaGenerica6').validate({
		rules:{
			conceptoFonID6:'requiered',
			subCuentaTM: {
				number : true
			}
		},
		messages:{
			conceptoFondID6:'Especifique Concepto',
			subCuentaTM : {
				number:'solo Números'
			}	
		}
	});
	
	$('#formaGenerica1').validate({
		rules: {
			conceptoFondID1: 'required',
			subCuenta: {
				number: true,
					},
				
		},
		
		messages: {
			conceptoFondID1: 'Especifique Concepto',
			subCuenta: {
				number: 'Solo Números'
					},
		}		
	}); 	

	//------------ Validaciones de Controles -------------------------------------
	//cnsulta cuenta mayor 
	function validaConcepto(idControl) {
		var jqConcepto = eval("'#" + idControl + "'");
		var numConcepto = $(jqConcepto).val();	
		var tipConPrincipal = 1;
		var CuentaMayorBeanCon = {
			'conceptoFondID'	:numConcepto,
			'tipoFondeador'		:$('#tipoFondeador').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){		
			if(numConcepto=='-1'){
				deshabilitaBoton('grabaCM', 'submit');     
				deshabilitaBoton('grabaTP', 'submit');					
				deshabilitaBoton('grabaPL', 'submit');     
				deshabilitaBoton('grabaNC', 'submit');	
				deshabilitaBoton('grabaIF', 'submit');		
				deshabilitaBoton('grabaTPE', 'submit');	
				deshabilitaBoton('modificaCM', 'submit');
				deshabilitaBoton('modificaTP', 'submit');
				deshabilitaBoton('modificaTPE', 'submit');
				deshabilitaBoton('modificaPL', 'submit');
				deshabilitaBoton('modificaNC', 'submit');
				deshabilitaBoton('modificaIF', 'submit');
				deshabilitaBoton('eliminaPL', 'submit');
				deshabilitaBoton('eliminaNC', 'submit');
				deshabilitaBoton('eliminaIF', 'submit');
				deshabilitaBoton('eliminaCM', 'submit');
				deshabilitaBoton('eliminaTP', 'submit');
				deshabilitaBoton('eliminaTPE', 'submit');
				deshabilitaBoton('grabaTM', 'submit');
				deshabilitaBoton('modificaTM', 'submit');
				deshabilitaBoton('eliminaTM', 'submit');
				inicializaForma('formaGenerica','conceptoID');	
				
			} else {
				cuentasMayorCreditoPasServicio.consulta(tipConPrincipal, CuentaMayorBeanCon,function(cuentaM) {
						if(cuentaM!=null){
							$('#cuenta').val(cuentaM.cuenta);
							$('#tipoFondeador').val(cuentaM.tipoFondeador);
							$('#nomenclatura').val(cuentaM.nomenclatura);
							
							
							consultaSubCuentas(numConcepto);
							deshabilitaBoton('grabaCM', 'submit'); 
							habilitaBoton('modificaCM', 'submit');
							habilitaBoton('eliminaCM', 'submit');															
						}else{
							consultaSubCuentas(numConcepto);
							deshabilitaBoton('modificaCM', 'submit');
							deshabilitaBoton('eliminaCM', 'submit');
							habilitaBoton('grabaCM', 'submit');
							$('#cuenta').focus();
							$('#cuenta').val('');
							$('#nomenclatura').val('');						
												
						}
				});														
			}												
		}
	}
	
	//consulta tipo de institucion
	function consultaSubCuentas(numConcepto) {	
		consultaSubTipoPro(numConcepto);
		consultaSubPlazo(numConcepto);
		consultaNC(numConcepto);
		consultaIF(numConcepto);
		consultaSubTipoPersona(numConcepto);
		consultaMonFon(numConcepto);
	}
	
	function consultaSubTipoPro(numConcepto){	
		var tipConPrincipal = 1;
		var SubTipoProBeanCon = {
			'conceptoFondID'	:numConcepto,
			'tipoInstitID'	    :$('#tipoInstitID').val(),
			'tipoFondeador'		:$('#tipoFondeador').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaTipInstFondeo.consulta(tipConPrincipal, SubTipoProBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoFonID2').val(subCuentaTP.conceptoFonID);
					$('#tipoFondeador').val(subCuentaTP.tipoFondeador);
					$('#tipoInstitID').val(subCuentaTP.tipoInstitID).selected = true;	
					$('#subCuenta').val(subCuentaTP.subCuenta);
					deshabilitaBoton('grabaTP', 'submit');
					habilitaBoton('modificaTP', 'submit');
					habilitaBoton('eliminaTP', 'submit');													
				}else{
					deshabilitaBoton('modificaTP', 'submit');
					deshabilitaBoton('eliminaTP', 'submit');
					habilitaBoton('grabaTP', 'submit');
					$('#subCuenta').val('');
				}
			});											
		}
	}
	
	//consulta por plazo 
	
	function consultaSubPlazo(numConcepto){	
		var tipConPrincipal = 1;
		var SubTipoProBeanCon = {
			'conceptoFondID'	:numConcepto,
			'tipoFondeador'		:$('#tipoFondeador').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaPorPlazoFondeo.consulta(tipConPrincipal, SubTipoProBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoFonID3').val(subCuentaTP.conceptoFonID);
					$('#tipoFondeador').val(subCuentaTP.tipoFondeador);
					$('#largoPlazo').val(subCuentaTP.largoPlazo);
					$('#cortoPlazo').val(subCuentaTP.cortoPlazo);
					deshabilitaBoton('grabaPL', 'submit');
					habilitaBoton('modificaPL', 'submit');
					habilitaBoton('eliminaPL', 'submit');													
				}else{
					deshabilitaBoton('modificaPL', 'submit');
					deshabilitaBoton('eliminaPL', 'submit');
					habilitaBoton('grabaPL', 'submit');
					$('#largoPlazo').val("");
					$('#cortoPlazo').val("");
				}
			});											
		}
	}
	
	//consulta por nacionalidad
	
	function consultaNC(numConcepto){	
		var tipConPrincipal = 1;
		var SubTipoProBeanCon = {
			'conceptoFondID'	:numConcepto,
			'tipoFondeador'		:$('#tipoFondeador').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaNacInstFondeo.consulta(tipConPrincipal, SubTipoProBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoFonID4').val(subCuentaTP.conceptoFonID);
					$('#tipoFondeador').val(subCuentaTP.tipoFondeador);
					$('#nacional').val(subCuentaTP.nacional);
					$('#extranjera').val(subCuentaTP.extranjera);
					deshabilitaBoton('grabaNC', 'submit');
					habilitaBoton('modificaNC', 'submit');
					habilitaBoton('eliminaNC', 'submit');		
		
				}else{
					deshabilitaBoton('modificaNC', 'submit');
					deshabilitaBoton('eliminaNC', 'submit');
					habilitaBoton('grabaNC', 'submit');
					$('#extranjera').val('');
					$('#nacional').val('');			
				}
			});											
		}
	}
	
	
	// consulta por institución de fondeo
	
	function consultaIF(numConcepto){	
		var tipConPrincipal = 1;
		var SubTipoProBeanCon = {
			'conceptoFondID'	:numConcepto,
			'institutFondID'    :$('#institutFondID').val(),
			'tipoFondeador'		:$('#tipoFondeador').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaInstFondeo.consulta(tipConPrincipal, SubTipoProBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoFonID5').val(subCuentaTP.conceptoFonID);
					$('#tipoFondeador').val(subCuentaTP.tipoFondeador);
					$('#subCuentaIns').val(subCuentaTP.subCuenta);
					$('#institutFondID').val(subCuentaTP.institutFondID).selected = true;	
					deshabilitaBoton('grabaIF', 'submit');
					habilitaBoton('modificaIF', 'submit');
					habilitaBoton('eliminaIF', 'submit');													
				}else{
					deshabilitaBoton('modificaIF', 'submit');
					deshabilitaBoton('eliminaIF', 'submit');
					habilitaBoton('grabaIF', 'submit');
					$('#subCuentaIns').val('');
					
				}
			});											
		}
	}
	
	function consultaMonFon(numConcepto){
		var tipoConPrincipal = 1;
		var subCtaMonFon= {
				'conceptoFonID' :numConcepto,
				'tipoFondeo'	:$('#tipoFondeador').val(),
				'monedaID'		:$('#monedaID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaMonFonServicio.consulta(tipoConPrincipal, subCtaMonFon, function(subTipMon){
				if(subTipMon != null){
					$('#conceptoFonID6').val(subTipMon.conceptoFonID);
					$('#tipoFondeador6').val(subTipMon.tipoFondeo);
					$('#monedaID').val(subTipMon.monedaID);
					$('#subCuentaTM').val(subTipMon.subCuenta);
					deshabilitaBoton('grabaTM', 'submit');
					habilitaBoton('modificaTM', 'submit');
					habilitaBoton('eliminaTM', 'submit');
				}else{
					deshabilitaBoton('modificaTM', 'submit');
					deshabilitaBoton('eliminaTM', 'submit');
					habilitaBoton('grabaTM', 'submit');
					$('#subCuentaTM').val('');
				}
			});
		}
	}
	
	function consultaConceptosFondeo() {	
  		dwr.util.removeAllOptions('conceptoFondID'); 
  		dwr.util.addOptions('conceptoFondID', {0:'SELECCIONAR'}); 
		conceptosFondServicio.listaCombo(1, function(conceptosFond){
			dwr.util.addOptions('conceptoFondID', conceptosFond, 'conceptoFondID', 'descripcion');
		});
	}

		
	//Combo Tipos Institucion
	function consultaTiposInstitucion() {			
  		dwr.util.removeAllOptions('tipoInstitID'); 
  		dwr.util.addOptions('tipoInstitID', {0:'SELECCIONAR'}); 
  		fondeoServicio.listaCombo(1, function(tiposInstitut){
		dwr.util.addOptions('tipoInstitID', tiposInstitut, 'tipoInstitID', 'descripcion');
		});
	}
	
	//Combo Institucion
	function consultaInstitucion() {			
  		dwr.util.removeAllOptions('institutFondID'); 
  		fondeoServicio.listaCombo(2, function(Institut){
		dwr.util.addOptions('institutFondID', Institut, 'institutFondID', 'nombreInstitFon');
		});
	}
	
	function consultaSubTipoPersona(numConcepto){	
		var tipConPrincipal = 1;
		var SubTipoProBeanCon = {
			'conceptoFondID'	:numConcepto,
			'tipoFondeador'		:$('#tipoFondeador').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaTipPerFonServicio.consulta(tipConPrincipal, SubTipoProBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoFondID1').val(subCuentaTP.conceptoFondID);
					$('#tipoFondeador').val(subCuentaTP.tipoFondeador);
					$('#fisica').val(subCuentaTP.fisica);
					$('#fisicaActEmp').val(subCuentaTP.fisicaActEmp);
					$('#moral').val(subCuentaTP.moral);
			
					deshabilitaBoton('grabaTPE', 'submit');
					habilitaBoton('modificaTPE', 'submit');
					habilitaBoton('eliminaTPE', 'submit');													
				}else{
					deshabilitaBoton('modificaTPE', 'submit');
					deshabilitaBoton('eliminaTPE', 'submit');
					habilitaBoton('grabaTPE', 'submit');
					$('#fisica').val('');
					$('#fisicaActEmp').val('');
					$('#moral').val('');
				}
			});											
		}
	}
	
	
});

// funcion que se ejecuta cuando el resultado fue un éxito
function funcionExito(){

}

// funcion que se ejecuta cuando el resultado fue error
// diferente de cero
function funcionError(){
	
}

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
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura:</legend>'+
			'<table id="tablaLista">'+
				'<tr>'+
					'<td id="encabezadoLista">&CM</td><td id="contenidoAyuda" align="left"><b>Cuentas de Mayor</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista" >&TI</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Tipo de Institución</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&PL</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Plazo</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&NC</td><td id="contenidoAyuda" align="left"><b>SubCuenta Nacionalidad Institución</b></td>'+ 
				'</tr>'+
				'<tr>'+ 
					'<td id="encabezadoLista">&IF</td><td id="contenidoAyuda" align="left"><b>SubCuenta Institución Fondeo</b></td>'+
				'</tr>'+
			'</table>'+
			'<br>'+
			'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo: Cuenta de Pasivo</legend>'+
			'<table id="tablaLista">'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Cuenta: </b></td>'+ 
					'<td colspan="6" id="contenidoAyuda">2101</td>'+
				'</tr>'+
				'<tr>'+
					'<td colspan="9" id="encabezadoAyuda"><b>Nomenclatura:</b></td>'+ 
				'</tr>'+
				'<tr id="contenidoAyuda">'+
					'<td>&CM</td><td>-</td><td>&TI</td>'+
					'<td>-</td><td>&PL</td><td>-</td>'+
					'<td>&NC</td><td>-</td><td>&IF</td>'+
					
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" colspan="9"><b>Cuenta Completa:</b></td>'+ 
				'</tr>'+
				'<tr id="contenidoAyuda">'+
					'<td>2101</td><td>-</td><td>01</td>'+
					'<td>-</td><td>01</td><td>-</td>'+
					'<td>01</td><td>-</td><td>01</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Descripci&oacute;n:</b></td>'+ 
					'<td colspan="8" id="contenidoAyuda"><i>CUENTA DE AHORRO PARA PERSONA FISICA</i></td>'+
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

function consultaMoneda() {			
	dwr.util.removeAllOptions('monedaID');
	dwr.util.addOptions('monedaID', {0:'SELECCIONAR'}); 
	monedasServicio.listaCombo(3, function(monedas){
		dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
	});
}
