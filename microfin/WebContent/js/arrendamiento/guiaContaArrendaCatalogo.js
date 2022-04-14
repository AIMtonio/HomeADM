$(document).ready(function() {
	esTab = true;

	$('#conceptoArrendaID').focus();
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionGuiArrenda = {
  		'graba'		:1,
  		'modifica'	:2,
  		'elimina'	:3
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
	 	esTab = false;
	});

	deshabilitaBoton('grabaCM', 'submit');     
	deshabilitaBoton('grabaSTP', 'submit');
	deshabilitaBoton('grabaSTA', 'submit');	
	deshabilitaBoton('grabaSM', 'submit');	
	deshabilitaBoton('grabaSS', 'submit');	
	deshabilitaBoton('grabaSP', 'submit');			
	deshabilitaBoton('modificaCM', 'submit');
	deshabilitaBoton('modificaSTP', 'submit');
	deshabilitaBoton('modificaSTA', 'submit');
	deshabilitaBoton('modificaSM', 'submit');
	deshabilitaBoton('modificaSS', 'submit');
	deshabilitaBoton('modificaSP', 'submit');
	deshabilitaBoton('eliminaCM', 'submit');
	deshabilitaBoton('eliminaSTP', 'submit');
	deshabilitaBoton('eliminaSTA', 'submit');
	deshabilitaBoton('eliminaSM', 'submit');
	deshabilitaBoton('eliminaSS', 'submit');
	deshabilitaBoton('eliminaSP', 'submit');
	
	
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionSTP').val(0);
	$('#tipoTransaccionSTA').val(0);
	$('#tipoTransaccionSS').val(0);
	$('#tipoTransaccionSP').val(0);
	
	$.validator.setDefaults({	
      submitHandler: function(event) { 
      	if($('#tipoTransaccionCM').val()==1||$('#tipoTransaccionCM').val()==2 ||$('#tipoTransaccionCM').val()==3){
      	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cuenta',  'funcionExito','funcionError');
      	}

   		if($('#tipoTransaccionSTP').val()==1||$('#tipoTransaccionSTP').val()==2||$('#tipoTransaccionSTP').val()==3){
   			if($('#conceptoArrendaID2').val()==''){
   				mensajeSis("Especificar Concepto de Arrendamiento");
   			}else{
   	   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje','true','subCuenta','funcionExito','funcionError');
   			}
   		}

   		if($('#tipoTransaccionSTA').val()==1||$('#tipoTransaccionSTA').val()==2||$('#tipoTransaccionSTA').val()==3){
   			if($('#conceptoArrendaID3').val()==''){
   				mensajeSis("Especificar Concepto de Arrendamiento");
   			}else{
   	   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica3', 'contenedorForma', 'mensaje','true','subCuenta',  'funcionExito','funcionError');
   			}
   		}
   		if($('#tipoTransaccionSM').val()==1||$('#tipoTransaccionSM').val()==2||$('#tipoTransaccionSM').val()==3){
   			if($('#conceptoArrendaID4').val()==''){
   				mensajeSis("Especificar Concepto de Arrendamiento");
   			}else{
   	   		  	grabaFormaTransaccionRetrollamada(event, 'formaGenerica4', 'contenedorForma', 'mensaje','true','subCuenta',  'funcionExito','funcionError');
   			}
   		}
   		if($('#tipoTransaccionSS').val()==1||$('#tipoTransaccionSS').val()==2||$('#tipoTransaccionSS').val()==3){
   			if($('#conceptoArrendaID5').val()==''){
   				mensajeSis("Especificar Concepto de Arrendamiento");
   			}else{
   	   		  	grabaFormaTransaccionRetrollamada(event, 'formaGenerica5', 'contenedorForma', 'mensaje','true','subCuenta',  'funcionExito','funcionError');
   			}
   		}
   		if($('#tipoTransaccionSP').val()==1||$('#tipoTransaccionSP').val()==2||$('#tipoTransaccionSP').val()==3){
   			if($('#conceptoArrendaID6').val()==''){
   				mensajeSis("Especificar Concepto de Arrendamiento");
   			}else{
   	   		  	grabaFormaTransaccionRetrollamada(event, 'formaGenerica6', 'contenedorForma', 'mensaje','true','subCuenta',  'funcionExito','funcionError');
   			}
   		}
      }
	});		


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#grabaCM').click(function() {
		$('#tipoTransaccionCM').val(catTipoTransaccionGuiArrenda.graba);
	});
	$('#modificaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionGuiArrenda.modifica);
	});
	$('#eliminaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionGuiArrenda.elimina);
	});
	
	$('#grabaSTP').click(function() {		
		$('#tipoTransaccionSTP').val(catTipoTransaccionGuiArrenda.graba);
	}); 
	
	$('#modificaSTP').click(function() {		
		$('#tipoTransaccionSTP').val(catTipoTransaccionGuiArrenda.modifica);
	});

	$('#eliminaSTP').click(function() {		
		$('#tipoTransaccionSTP').val(catTipoTransaccionGuiArrenda.elimina);
	});
	
	$('#grabaSTA').click(function() {		
		$('#tipoTransaccionSTA').val(catTipoTransaccionGuiArrenda.graba);
	}); 
	
	$('#modificaSTA').click(function() {		
		$('#tipoTransaccionSTA').val(catTipoTransaccionGuiArrenda.modifica);
	});
	
	$('#eliminaSTA').click(function() {		
		$('#tipoTransaccionSTA').val(catTipoTransaccionGuiArrenda.elimina);
	});
	
	$('#grabaSM').click(function() {	
		$('#tipoTransaccionSM').val(catTipoTransaccionGuiArrenda.graba);
	}); 
	
	$('#modificaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionGuiArrenda.modifica);
	});
	
	$('#eliminaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionGuiArrenda.elimina);
	});
	
	$('#grabaSS').click(function() {	
		$('#tipoTransaccionSS').val(catTipoTransaccionGuiArrenda.graba);
	}); 
	
	$('#modificaSS').click(function() {		
		$('#tipoTransaccionSS').val(catTipoTransaccionGuiArrenda.modifica);
	});
	
	$('#eliminaSS').click(function() {		
		$('#tipoTransaccionSS').val(catTipoTransaccionGuiArrenda.elimina);
	});


	$('#grabaSP').click(function() {	
		$('#tipoTransaccionSP').val(catTipoTransaccionGuiArrenda.graba);
	}); 
	
	$('#modificaSP').click(function() {		
		$('#tipoTransaccionSP').val(catTipoTransaccionGuiArrenda.modifica);
	});
	
	$('#eliminaSP').click(function() {		
		$('#tipoTransaccionSP').val(catTipoTransaccionGuiArrenda.elimina);
	});
	
	$('#conceptoArrendaID').change(function() {	
		validaConcepto('conceptoArrendaID');	
		$('#conceptoArrendaID2').val($('#conceptoArrendaID').val());
		$('#conceptoArrendaID3').val($('#conceptoArrendaID').val());
		$('#conceptoArrendaID4').val($('#conceptoArrendaID').val());
		$('#conceptoArrendaID5').val($('#conceptoArrendaID').val());
		$('#conceptoArrendaID6').val($('#conceptoArrendaID').val());
	});	
	
	$('#conceptoArrendaID').blur(function() {	
		validaConcepto('conceptoArrendaID');	
		$('#conceptoArrendaID2').val($('#conceptoArrendaID').val());
		$('#conceptoArrendaID3').val($('#conceptoArrendaID').val());
		$('#conceptoArrendaID4').val($('#conceptoArrendaID').val());
		$('#conceptoArrendaID5').val($('#conceptoArrendaID').val());
		$('#conceptoArrendaID6').val($('#conceptoArrendaID').val());
	});	
	
	$('#productoArrendaID').bind('keyup',function(e) {
		lista('productoArrendaID', '2', '1','productoArrendaID', $('#productoArrendaID').val(),'productoArrendaLista.htm');
	});
	
	$('#productoArrendaID').blur(function() {
		if(($('#productoArrendaID').val()!='0' || $('#productoArrendaID').val()!='') && esTab){
			consultaProductoArrenda($('#productoArrendaID').val());
			consultaSubCuentas($('#conceptoArrendaID').val());
		}		
	});
	
	$('#sucursalID').bind('keyup',function(e) {
		lista('sucursalID', '2', '1','nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
	
	$('#sucursalID').blur(function() {
		if(($('#sucursalID').val()!='0' || $('#sucursalID').val()!='') && esTab){
			consultaSucursal('sucursalID');
			consultaSubCuentas($('#conceptoArrendaID').val());
		}		
	});
	
	$('#tipoArrenda').change(function() {
		if($('#tipoArrenda').val()!=''){
			consultaSubCuentas($('#conceptoArrendaID').val());	
		}else{
			$('#subCuenta2').val('');
		}
	});
	
	$('#monedaID').change(function() {
		if($('#monedaID').val()!='' ){
			consultaSubCuentas($('#conceptoArrendaID').val());	
		}else{
			$('#subCuenta3').val('');
		}
	});

	$('#plazo').change(function() {
		if($('#plazo').val()!=''){
			consultaSubCuentas($('#conceptoArrendaID').val());	
		}else{
			$('#subCuenta5').val('');
		}
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
	consultaMoneda();
	consultaConceptosArrenda();

	//------------ Validaciones de la Forma -------------------------------------
	
	
	$('#formaGenerica').validate({
		rules: {
			conceptoArrendaID: 'required',
			cuenta: {
				number: true,
					},
		},
		
		messages: {
			conceptoArrendaID: 'Especifique Concepto',
			cuenta		: {
				number	: 	'Solo Nœmeros'
			}
		}		
	});

	$('#formaGenerica2').validate({
		rules: {
			conceptoArrendaID2: 'required',
			subCuenta: {
				number: true,
					},
			productoArrendaID:'required',
				
		},
		
		messages: {
			conceptoArrendaID2: 'Especifique Concepto',
			subCuenta: {
				number: 'Solo Nœmeros'
					},
			productoArrendaID:'Especifique Producto',
		}		
	}); 	

	$('#formaGenerica3').validate({
		rules: {
			conceptoArrendaID3: 'required',
			subCuenta2: {
				number: true,
			},
			tipoArrenda:'required',
		},
		
		messages: {
			conceptoArrendaID3: 'Especifique el Concepto',
			subCuenta2: {
				number: 'Solo Nœmeros'
			},	
			tipoArrenda:'Especifique Tipo de Arrendamiento',
		}		
	}); 
	
	$('#formaGenerica4').validate({
		rules: {
			conceptoArrendaID4: 'required',
			subCuenta3: {
				number: true,
			},	
			monedaID:'required',
		},
		
		messages: {
			conceptoArrendaID4: 'Especifique el Concepto',
			subCuenta3: {
				number: 'Solo Nœmeros'
			},	
			monedaID:'Especifique moneda',
		}		
	}); 
	$('#formaGenerica5').validate({
		rules: {
			conceptoArrendaID5: 'required',
			subCuenta4: {
				number: true,
			},	
			sucursalID:'required',
		},
		
		messages: {
			conceptoArrendaID5: 'Especifique el Concepto',
			subCuenta4: {
				number: 'Solo Nœmeros'
			},	
			sucursalID:'Especifique Sucursal',
		}		
	}); 
	$('#formaGenerica6').validate({
		rules: {
			conceptoArrendaID6: 'required',
			subCuenta5: {
				number: true,
			},	
			plazo:'required',
		},
		
		messages: {
			conceptoArrendaID6: 'Especifique el Concepto',
			subCuenta5: {
				number: 'Solo Nœmeros'
			},	
			plazo:'Especifique moneda',
		}		
	}); 	

	//------------ Validaciones de Controles -------------------------------------
	
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
	
	
	function consultaConceptosArrenda() {
		dwr.util.removeAllOptions('conceptoArrendaID');
		dwr.util.addOptions('conceptoArrendaID', {
			"" : 'SELECCIONAR'
		});
		conceptosArrendaServicio.listaCombo(1, function(conceptos) {
			dwr.util.addOptions('conceptoArrendaID', conceptos,'conceptoArrendaID', 'descripcion');
		});
	}
	
	function consultaProductoArrenda(productoArrendaID){
		// consulta del arrendamiento
		var arrendaBeanCon = {
				'productoArrendaID' : productoArrendaID
		};
		productoArrendaServicio.consulta(1,arrendaBeanCon,function(arrendamiento) {
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
	
	//cnsulta cuenta mayor 
	function validaConcepto(idControl) {
		var jqConcepto = eval("'#" + idControl + "'");
		var numConcepto = $(jqConcepto).val();	
		var tipConPrincipal = 1;
		var CuentaMayorBeanCon = {
			'conceptoArrendaID'	:numConcepto,
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){		
			if(numConcepto==''){
				deshabilitaBoton('grabaCM', 'submit');     
				deshabilitaBoton('grabaSTP', 'submit');
				deshabilitaBoton('grabaSTA', 'submit');	
				deshabilitaBoton('grabaSM', 'submit');	
				deshabilitaBoton('grabaSS', 'submit');	
				deshabilitaBoton('grabaSP', 'submit');			
				deshabilitaBoton('modificaCM', 'submit');
				deshabilitaBoton('modificaSTP', 'submit');
				deshabilitaBoton('modificaSTA', 'submit');
				deshabilitaBoton('modificaSM', 'submit');
				deshabilitaBoton('modificaSS', 'submit');
				deshabilitaBoton('modificaSP', 'submit');
				deshabilitaBoton('eliminaCM', 'submit');
				deshabilitaBoton('eliminaSTP', 'submit');
				deshabilitaBoton('eliminaSTA', 'submit');
				deshabilitaBoton('eliminaSM', 'submit');
				deshabilitaBoton('eliminaSS', 'submit');
				deshabilitaBoton('eliminaSP', 'submit');
				inicializaForma('formaGenerica','conceptoID');	
			} else {
				cuentasMayorArrendaServicio.consulta(tipConPrincipal, CuentaMayorBeanCon,function(cuentaM) {
					if(cuentaM!=null){
						$('#cuenta').val(cuentaM.cuenta);
						$('#nomenclatura').val(cuentaM.nomenclatura);
						$('#nomenclaturaCR').val(cuentaM.nomenclaturaCR);  	
						
						consultaSubCuentas(numConcepto);
						deshabilitaBoton('grabaCM', 'submit'); 
						habilitaBoton('modificaCM', 'submit');
						habilitaBoton('eliminaCM', 'submit');	
						
						$('#tipoTransaccionCM').val(0);
						$('#tipoTransaccionSM').val(0);
						$('#tipoTransaccionSTP').val(0);
						$('#tipoTransaccionSTA').val(0);
						$('#tipoTransaccionSS').val(0);
						$('#tipoTransaccionSP').val(0);
						
					}else{
						consultaSubCuentas(numConcepto);
						deshabilitaBoton('modificaCM', 'submit');
						deshabilitaBoton('eliminaCM', 'submit');
						habilitaBoton('grabaCM', 'submit');
						$('#cuenta').focus();
						$('#cuenta').val('');
			  			$('#nomenclatura').val('');
			  			$('#nomenclaturaCR').val('');		
						
						$('#tipoTransaccionCM').val(0);
						$('#tipoTransaccionSM').val(0);
						$('#tipoTransaccionSTP').val(0);
						$('#tipoTransaccionSTA').val(0);
						$('#tipoTransaccionSS').val(0);
						$('#tipoTransaccionSP').val(0);
						
						 
					}
				});														
			}												
		}
	}// FIN DE CONSULTA CUENTA MAYOR 
	
	//consulta tipo de institucion
	function consultaSubCuentas(numConcepto) {	
		consultaSubMoneda(numConcepto);
		consultaSubTipoPro(numConcepto);
		consultaSubTipoArrenda(numConcepto);
		consultaSubSucursal(numConcepto);
		consultaSubPlazo(numConcepto);
	}
	
	function consultaSubTipoPro(numConcepto){	
		var tipConPrincipal = 1;
		var SubTipoProBeanCon = {
			'conceptoArrendaID'	:numConcepto,
			'productoArrendaID'		:$('#productoArrendaID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaTiProArrendaServicio.consulta(tipConPrincipal, SubTipoProBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoArrendaID2').val(subCuentaTP.conceptoArrendaID);
					$('#productoArrendaID').val(subCuentaTP.productoArrendaID);
					$('#subCuenta').val(subCuentaTP.subCuenta);
					consultaProductoArrenda(subCuentaTP.productoArrendaID);
					deshabilitaBoton('grabaSTP', 'submit');
					habilitaBoton('modificaSTP', 'submit');
					habilitaBoton('eliminaSTP', 'submit');													
				}else{
					deshabilitaBoton('modificaSTP', 'submit');
					deshabilitaBoton('eliminaSTP', 'submit');
					habilitaBoton('grabaSTP', 'submit');
					$('#subCuenta').val('');
				}
			});											
		}
	} // fin sub cta tipo producto
	
	//sub cuenta por mo tipo arrenda
	function consultaSubTipoArrenda(numConcepto){	
		var tipConPrincipal = 1;
		var SubTipoProBeanCon = {
			'conceptoArrendaID'	:numConcepto,
			'tipoArrenda'		:$('#tipoArrenda').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaTipoArrendaServicio.consulta(tipConPrincipal, SubTipoProBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoArrendaID3').val(subCuentaTP.conceptoArrendaID);
					$('#tipoArrenda').val(subCuentaTP.tipoArrenda);
					$('#subCuenta2').val(subCuentaTP.subCuenta);
					deshabilitaBoton('grabaSTA', 'submit');
					habilitaBoton('modificaSTA', 'submit');
					habilitaBoton('eliminaSTA', 'submit');													
				}else{
					deshabilitaBoton('modificaSTA', 'submit');
					deshabilitaBoton('eliminaSTA', 'submit');
					habilitaBoton('grabaSTA', 'submit');
					$('#subCuenta2').val("");
				}
			});											
		}
	} // fin sub cuenta tipo arrenda
	
	// consulta por moneda
	function consultaSubMoneda(numConcepto){	
		var tipConPrincipal = 1;
		var SubTipoProBeanCon = {
			'conceptoArrendaID'	:numConcepto,
			'monedaID'    :$('#monedaID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaMonedaArrendaServicio.consulta(tipConPrincipal, SubTipoProBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoArrendaID4').val(subCuentaTP.conceptoArrendaID);
					$('#monedaID').val(subCuentaTP.monedaID).selected = true;
					$('#subCuenta3').val(subCuentaTP.subCuenta);
					deshabilitaBoton('grabaSM', 'submit');
					habilitaBoton('modificaSM', 'submit');
					habilitaBoton('eliminaSM', 'submit');													
				}else{
					deshabilitaBoton('modificaSM', 'submit');
					deshabilitaBoton('eliminaSM', 'submit');
					habilitaBoton('grabaSM', 'submit');
					$('#subCuenta3').val('');
				}
			});											
		}
	}

	// consulta por sucursal 
	function consultaSubSucursal(numConcepto){	
		var tipConPrincipal = 1;
		var SubBeanCon = {
			'conceptoArrendaID'	:numConcepto,
			'sucursalID'    :$('#sucursalID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaSucurArrendaServicio.consulta(tipConPrincipal, SubBeanCon,function(subCuentaSS) {
				if(subCuentaSS!=null){
					$('#conceptoArrendaID5').val(subCuentaSS.conceptoArrendaID);
					$('#sucursalID').val(subCuentaSS.sucursalID);
					$('#subCuenta4').val(subCuentaSS.subCuenta);
					consultaSucursal('sucursalID');
					deshabilitaBoton('grabaSS', 'submit');
					habilitaBoton('modificaSS', 'submit');
					habilitaBoton('eliminaSS', 'submit');													
				}else{
					deshabilitaBoton('modificaSS', 'submit');
					deshabilitaBoton('eliminaSS', 'submit');
					habilitaBoton('grabaSS', 'submit');
					$('#subCuenta4').val('');
				}
			});											
		}
	}
	// consulta por PLAZO 
	function consultaSubPlazo(numConcepto){	
		var tipConPrincipal = 1;
		var SubBeanCon = {
			'conceptoArrendaID'	:numConcepto,
			'plazo'    :$('#plazo').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaPlazoArrendaServicio.consulta(tipConPrincipal, SubBeanCon,function(subCuentaSS) {
				if(subCuentaSS!=null){
					$('#conceptoArrendaID6').val(subCuentaSS.conceptoArrendaID);
					$('#plazo').val(subCuentaSS.plazo);
					$('#subCuenta5').val(subCuentaSS.subCuenta);
					deshabilitaBoton('grabaSP', 'submit');
					habilitaBoton('modificaSP', 'submit');
					habilitaBoton('eliminaSP', 'submit');													
				}else{
					deshabilitaBoton('modificaSP', 'submit');
					deshabilitaBoton('eliminaSP', 'submit');
					habilitaBoton('grabaSP', 'submit');
					$('#subCuenta5').val('');
				}
			});											
		}
	}// fin consultaSubPlazo
	
	
	
	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal)) {
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
						if (sucursal != null) {
							$('#sucursalID').val(sucursal.sucursalID);
							$('#sucursalDes').val(sucursal.nombreSucurs);
						} else {
							mensajeSis("No Existe la Sucursal");
							$(jqSucursal).focus();
							$('#sucursalID').val('');
							$('#sucursalDes').val('');
						}
					});
		}
	}

	
});

// funcion que se ejecuta cuando el resultado fue un Ã©xito
function funcionExito(){
	if($('#tipoTransaccionCM').val()==1||$('#tipoTransaccionCM').val()==2 ||$('#tipoTransaccionCM').val()==3){
  		if($('#tipoTransaccionCM').val()==1||$('#tipoTransaccionCM').val()==2){
  			habilitaBoton('modificaCM', 'submit');
  			habilitaBoton('eliminaCM', 'submit');
  			deshabilitaBoton('grabaCM', 'submit');
  		}else{
  			if($('#tipoTransaccionCM').val()==3){
  				$('#conceptoArrendaID').val("");
  	  			$('#nomenclaturaCR').val('');
  			}
  			
  			$('#cuenta').val('');
  			$('#nomenclatura').val('');
  			$('#nomenclaturaCR').val('');
  			deshabilitaBoton('modificaCM', 'submit');
  			deshabilitaBoton('eliminaCM', 'submit');
  			habilitaBoton('grabaCM', 'submit');
  			deshabilitaBoton('grabaSTP', 'submit');
  			deshabilitaBoton('grabaSTA', 'submit');	
  			deshabilitaBoton('grabaSM', 'submit');	
  			deshabilitaBoton('grabaSS', 'submit');	
  			deshabilitaBoton('grabaSP', 'submit');	
  			deshabilitaBoton('modificaSTP', 'submit');
  			deshabilitaBoton('modificaSTA', 'submit');
  			deshabilitaBoton('modificaSM', 'submit');
  			deshabilitaBoton('modificaSS', 'submit');
  			deshabilitaBoton('modificaSP', 'submit');
  			deshabilitaBoton('eliminaSTP', 'submit');
  			deshabilitaBoton('eliminaSTA', 'submit');
  			deshabilitaBoton('eliminaSM', 'submit');
  			deshabilitaBoton('eliminaSS', 'submit');
  			deshabilitaBoton('eliminaSP', 'submit');
  		}
  	}

	if($('#tipoTransaccionSTP').val()==1||$('#tipoTransaccionSTP').val()==2||$('#tipoTransaccionSTP').val()==3){
		if($('#tipoTransaccionSTP').val()==1||$('#tipoTransaccionSTP').val()==2){
			habilitaBoton('modificaSTP', 'submit');
			habilitaBoton('eliminaSTP', 'submit');
			deshabilitaBoton('grabaSTP', 'submit');
		}else{
			$('#subCuenta').val('');
			$('#descripcionProducto').val('');
			$('#productoArrendaID').val('');
			deshabilitaBoton('modificaSTP', 'submit');
			deshabilitaBoton('eliminaSTP', 'submit');
			habilitaBoton('grabaSTP', 'submit');
		}
	}

	if($('#tipoTransaccionSTA').val()==1||$('#tipoTransaccionSTA').val()==2||$('#tipoTransaccionSTA').val()==3){
		if($('#tipoTransaccionSTA').val()==1||$('#tipoTransaccionSTA').val()==2){
			habilitaBoton('modificaSTA', 'submit');
			habilitaBoton('eliminaSTA', 'submit');
			deshabilitaBoton('grabaSTA', 'submit');
		}else{
			$('#subCuenta2').val('');
			$('#tipoArrenda').val('');
			deshabilitaBoton('modificaSTA', 'submit');
			deshabilitaBoton('eliminaSTA', 'submit');
			habilitaBoton('grabaSTA', 'submit');
		}
	}
	if($('#tipoTransaccionSM').val()==1||$('#tipoTransaccionSM').val()==2||$('#tipoTransaccionSM').val()==3){
		if($('#tipoTransaccionSM').val()==1||$('#tipoTransaccionSM').val()==2){
			habilitaBoton('modificaSM', 'submit');
			habilitaBoton('eliminaSM', 'submit');
			deshabilitaBoton('grabaSM', 'submit');
		}else{
			$('#subCuenta3').val('');
			deshabilitaBoton('modificaSM', 'submit');
			deshabilitaBoton('eliminaSM', 'submit');
			habilitaBoton('grabaSM', 'submit');
		}
	}

	if($('#tipoTransaccionSS').val()==1||$('#tipoTransaccionSS').val()==2||$('#tipoTransaccionSS').val()==3){
		if($('#tipoTransaccionSS').val()==1||$('#tipoTransaccionSS').val()==2){
			habilitaBoton('modificaSS', 'submit');
			habilitaBoton('eliminaSS', 'submit');
			deshabilitaBoton('grabaSS', 'submit');
		}else{
			$('#subCuenta4').val('');
			deshabilitaBoton('modificaSS', 'submit');
			deshabilitaBoton('eliminaSS', 'submit');
			habilitaBoton('grabaSS', 'submit');
		}
	}
	

	if($('#tipoTransaccionSP').val()==1||$('#tipoTransaccionSP').val()==2||$('#tipoTransaccionSP').val()==3){
		if($('#tipoTransaccionSP').val()==1||$('#tipoTransaccionSP').val()==2){
			habilitaBoton('modificaSP', 'submit');
			habilitaBoton('eliminaSP', 'submit');
			deshabilitaBoton('grabaSP', 'submit');
		}else{
			$('#subCuenta5').val('');
			deshabilitaBoton('modificaSP', 'submit');
			deshabilitaBoton('eliminaSP', 'submit');
			habilitaBoton('grabaSP', 'submit');
		}
	}

	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionSTP').val(0);
	$('#tipoTransaccionSTA').val(0);
	$('#tipoTransaccionSS').val(0);
	$('#tipoTransaccionSP').val(0);
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
					'<td id="encabezadoLista">&PA</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Producto</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&TA</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Tipo</b></td>'+ 
				'</tr>'+
				'<tr>'+ 
					'<td id="encabezadoLista">&SM</td><td id="contenidoAyuda" align="left"><b>SubCuenta Moneda</b></td>'+
				'</tr>'+
				'<tr>'+ 
					'<td id="encabezadoLista">&SS</td><td id="contenidoAyuda" align="left"><b>SubCuenta Sucursal</b></td>'+
				'</tr>'+
				'<tr>'+ 
					'<td id="encabezadoLista">&SP</td><td id="contenidoAyuda" align="left"><b>SubCuenta Plazo</b></td>'+
				'</tr>'+
			'</table>'+
			'<br>'+
			'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo: Cuenta</legend>'+
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