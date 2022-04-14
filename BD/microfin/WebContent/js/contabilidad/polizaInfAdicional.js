	var botonPrincipal = 0;
	var datos = 1;
	var clienteValido = 1;
	var catTipoTransaccionCtaContable = {
	  		'agregarDoc' 	: '7',
	  		'modificarDoc'	: '8'
		};
		
	
		var catTipoConsultaInstituciones = {
		'principal':1, 
		'foranea':2
		};

		var catTipoConsultaCtaNostro = {
		'principal':1,
		'foranea':2, 
		'resumen':4,
		'folioInstit':5,
		'estatus':11
	};	
	var personaRFC = "";
	var numeroValido  = 0;
	$(document).ready(function(e) {
	
		esTab = true;
		press = false;
		var tab2=false;
	
		$(':text').focus(function() {	
		 	esTab = false;
		 	press=false;
		});
	
		$(':text').bind('keydown',function(e){ 
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
				press=true;
			}
			if (e.which == 9 && e.shiftKey){
				press= false; //alert("44");
			}
		}); 	
	
		
		
		//------------ Metodos y Manejo de Eventos -----------------------------------------
		deshabilitaBoton('agregarDoc', 'submit');
  		deshabilitaBoton('modificarDoc', 'submit');
	   	deshabilitaBoton('grabar', 'submit');
	   	deshabilitaBoton('imprimir', 'submit');
	   	deshabilitaBoton('adjuntar', 'submit');
	   	agregaFormatoControles('formaGenerica');
	   	cargaListaMetodosPago();
	   
	
	
		
		$('#agregarDoc').click(function() {
			
			$('#tipoTransaccion').val(catTipoTransaccionCtaContable.agregarDoc);	
			var numTransaccion = $('#tipoTransaccion').val();	

			if ($("#formaGenerica").valid()) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','polizaID','exito','falloPantalla');
			}
			
		});	
		
		
		$('#modificarDoc').click(function() {

			$('#tipoTransaccion').val(catTipoTransaccionCtaContable.modificarDoc);	
			var numTransaccion = $('#tipoTransaccion').val();	

			if ($("#formaGenerica").valid()) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','polizaID','exito','falloPantalla');
			}
			
		});	
		
		$('#infAdicionalBtn').click(function() {	
			botonPrincipal = 1;	
			$('#informacionAdicional').show();
			consultaPolizaInfAdicional();			

		});
		
		


	$('#movimiento').blur(function() {	   		
		var tipoMov = $('#movimiento').val();	
  		consultaTipo(tipoMov);

  		var mov = $('#movimiento').val();
  		if(mov != ""){
  			desbloqueaCampos();
  			 $('#institucionID').focus();
  			 if(datos == 1){
  			 	habilitaBoton('modificarDoc', 'submit');
  			 	deshabilitaBoton('agregarDoc', 'submit');
  			 }else{
  			 	habilitaBoton('agregarDoc', 'submit');
  			 	deshabilitaBoton('modificarDoc', 'submit');
  			 }
  			
  			
  			if(mov == "I"){
	  			$('#pagadorID').css({ 'width':'100px'});
	  			$('#pagadorID').val("");
	  			$('#nomPagador').val("");
	  		}else{
	  			$('#pagadorID').css({ 'width':'50px'});
	  			$('#pagadorID').val("");
	  			$('#nomPagador').val("");
	  		}
  		}else{
  			bloqueaCampos();
  			deshabilitaBoton('agregarDoc', 'submit');
  			deshabilitaBoton('modificarDoc', 'submit');
  		}
  		
  		
  		
 	});		

	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});
	
	
   $('#institucionID').blur(function() {	   		
		
  		if($('#institucionID').val()!=""){
  		   	consultaInstitucion(this.id);  
  		}
 	});	
	
	$('#instOrigenID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('instOrigenID', '1', '1', 'nombre', $('#instOrigenID').val(), 'listaInstituciones.htm');
	});
	
	
   $('#instOrigenID').blur(function() {	   		
		
  		if($('#instOrigenID').val()!=""){
  		   	consultaInstitucionOrigen(this.id);  
  		}
 	});	

	$('#numCtaBancaria').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "numCtaInstit";
		camposLista[1] = "institucionID";
		parametrosLista[0] = $('#numCtaBancaria').val();
		parametrosLista[1] = $('#institucionID').val();
		listaAlfanumerica('numCtaBancaria', '3', '7', camposLista,parametrosLista, 'ctaNostroLista.htm');	       
	});	

		$('#numCtaBancaria').blur(function(){
   		if($('#numCtaBancaria').val()!="" && $('#institucionID').val()!=""){
   			validaCtaNostroExiste('numCtaBancaria','institucionID');
   		}		
   	});

	$('#numCheque').blur(function() {
				
		if (isNaN($('#numCheque').val())) { 			
			$('#numCheque').val("");
			$('#numCheque').focus();
		} 
	});

	$('#ctaClabeOrigen').blur(function() {
				
		if (isNaN($('#ctaClabeOrigen').val())) { 			
			$('#ctaClabeOrigen').val("");
			$('#ctaClabeOrigen').focus();
		} 
	});
	
		
	$('#pagadorID').bind('keyup',function(e){
		
		var tipoMov = $('#movimiento').val();
		if(tipoMov == "E"){
			if(this.value.length >= 2){ 
				var camposLista = new Array();
				var parametrosLista = new Array();			
				camposLista[0] = "primerNombre"; 
				camposLista[0] = "apellidoPaterno"; 
				parametrosLista[0] = $('#pagadorID').val();
				listaAlfanumerica('pagadorID', '1', '1', camposLista, parametrosLista, 'listaProveedores.htm');
					
			}
		}else{
			if($('#pagadorID').val().length<3){		
				$('#cajaListaCte').hide();
			}else{
				lista('pagadorID', '3', '1', 'nombreCompleto', $('#pagadorID').val(), 'listaCliente.htm');
			}
			
		}
		
	});	
	
	
	$('#metodoPago').blur(function() {
		var metodoPago = $('#metodoPago option:selected').text();
		
		if(metodoPago == 'TRANSFERENCIA'){
			$('#Transferencia').show();	
			$('#instOrigenID').focus();	
		}else{
			$('#Transferencia').hide();
			$('#instOrigenID').val("");
			$('#nomInstOrigen').val("");
			$('#ctaClabeOrigen').val("");
			
		}

		
		
	});

	$('#pagadorID').blur(function() {
		var tipoMov = $('#movimiento').val();

		if(isNaN($('#pagadorID').val()) ){
			$('#pagadorID').val("");
			$('#pagadorID').focus();
		}else{
			if(tab2 == false){
				if(tipoMov == "E"){
					consultaProveedor(this.id);
				}else{
					consultaCliente(this.id);
				}

				if(numeroValido > 0 && clienteValido == 1){
					mensajeSisRetro({
						mensajeAlert : 'El RFC no coincide con el Detalle de Movimientos',
						muestraBtnAceptar: true,
						muestraBtnCancela: true,
						txtAceptar : 'Aceptar',
						txtCancelar : 'Cancelar',
						funcionAceptar : function(){
							$('#importe').focus();
						},
						funcionCancelar : function(){
							$('#pagadorID').val("");
							$('#nomPagador').val("");
							$('#pagadorID').focus();
						}
					});
				}
				
				
				
			}
		}
		
	});


	$('#monedaIDDoc').blur(function() {
		buscarDivisa(this.id); 
	});

	$('#monedaIDDoc').bind('keyup',function(e){
		lista('monedaIDDoc', '0', 2, 'monedaID', $('#monedaIDDoc').val(), 'listaMonedas.htm');
	});
	
	
		//------------ Validaciones de la Forma -------------------------------------
		$('#formaGenerica').validate({
			rules: { 			

				institucionID: {
					required: function() {return botonPrincipal == 1},
				},
				numCtaBancaria: {
					required: function() {return botonPrincipal == 1},
				},
				cuentaClabe: {
					required: function() {return botonPrincipal == 1},
				},
				tipoDoc: {
					required: function() {return botonPrincipal == 1},
				},
				numCheque: {
					required: function() {return botonPrincipal == 1},
				},
				pagadorID: {
					required: function() {return botonPrincipal == 1},
				},
				importe: {
					required: function() {return botonPrincipal == 1},
					number: true

				},
				referenciaDoc: {
					required: function() {return botonPrincipal == 1},
				},
				metodoPago: {
					required: function() {return botonPrincipal == 1},
				},
				monedaIDDoc: {
					required: function() {return botonPrincipal == 1},
				},
				tipoCambio: {
					required: function() {return botonPrincipal == 1},
				}

				
			},	
		
			messages: {
			
				institucionID: {
					required: "Especifique Institución",
				},
				numCtaBancaria: {
					required: "Especifique Número de Cuenta Bancaria",
				},
				cuentaClabe: {
					required: "Especifique Cuenta Clabe",
				},
				tipoDoc: {
					required: "Especifique Tipo de Movimiento",
				},
				numCheque: {
					required: "Especifique Folio",
				},
				pagadorID: {
					required: "Especfique Pagador",
				},
				importe: {
					required: "Especifique Importe",
					number: "Solo números"
				},
				referenciaDoc: {
					required: "Especifique Referencia",
				},
				metodoPago: {
					required: "Especifique Método de Pago",
				},
				monedaIDDoc: {
					required: "Especifique Moneda",
				},
				tipoCambio: {
					required: "Especifique Tipo de Cambio",
				}

				
			
			}		
		}); 

			});	
		//------------ Validaciones de Controles ----------------------------------
		
		function consultaTipo(tipoMov) {			
			var Bean = {
					'tipo' : tipoMov, 
				};			 	
				catIngresosEgresosServicio.listaCombo(Bean, 2, { async: false, callback: function(ingresos){
					dwr.util.removeAllOptions('tipoDoc'); 
					dwr.util.addOptions('tipoDoc', {'':'SELECCIONAR'});
					dwr.util.addOptions('tipoDoc', ingresos, 'numero', 'descripcion');
				}});
		}
		
		
		// funcion que llena el combo de calcInteres
			function consultaComboCalInteres() {
				dwr.util.removeAllOptions('calcInteresID'); 
				formTipoCalIntServicio.listaCombo(1, { async: false, callback: function(formTipoCalIntBean){
					dwr.util.addOptions('calcInteresID', {'':'SELECCIONAR'});
					dwr.util.addOptions('calcInteresID', formTipoCalIntBean, 'formInteresID', 'formula');
				}});
			}

		function cargaListaMetodosPago(){
			catMetodosPagoServicio.listaCombo(2, function(ingresos){
				dwr.util.removeAllOptions('metodoPago'); 
				dwr.util.addOptions('metodoPago', {'':'SELECCIONAR'});
				dwr.util.addOptions('metodoPago', ingresos, 'metodoPagoID', 'descripcion');
			});
		}
		
		// funcion para consultar al proveedor
		function consultaProveedor(idControl) {

			var jqProveedor  = eval("'#" + idControl + "'");
			var numProveedor = $(jqProveedor).val();	

			var proveedorBeanCon = { 
					'proveedorID'	:numProveedor
			};		
			setTimeout("$('#cajaLista').hide();", 200);
			if(numProveedor != '' && !isNaN(numProveedor)){				
				proveedoresServicio.consulta(1,proveedorBeanCon,{ async: false, callback:function(proveedores) {
					if(proveedores!=null){
						esTab=true;
						var nombreCompleto ="";
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('cancela', 'submit');
						if(proveedores.estatus != 'A'){
							mensajeSis("El Proveedor Debe estar Activo");
							inicializaForma('formaGenerica','pagadorID');	
							$('#pagadorID').val('');
							$('#pagadorID').focus();
						}else{
							if(proveedores.tipoPersona == 'F' ){
								nombreCompleto = proveedores.primerNombre+" "+proveedores.segundoNombre+" "+proveedores.apellidoPaterno+" "
								+proveedores.apellidoMaterno;

								personaRFC = proveedores.RFC;
								numeroValido = cuentaRFC();
							}
							if(proveedores.tipoPersona == 'M' ){
								nombreCompleto = proveedores.razonSocial;
								personaRFC = proveedores.RFCpm;
								numeroValido = cuentaRFC();

							}
							$('#nomPagador').val(nombreCompleto);	

						}
					}
					else{
						mensajeSis("El Proveedor No Existe.");
						deshabilitaBoton('agrega', 'submit');
						$('#pagadorID').val("");
						$('#nomPagador').val("");
						$('#pagadorID').focus();

					}
				}});
			}	
		}
		
		// Función para consultar Clientes
		function consultaCliente(idControl) {
			var jqCliente = eval("'#" + idControl + "'");
			var numCliente = $(jqCliente).val();
			setTimeout("$('#cajaLista').hide();", 200);
			
			if (numCliente != '' && !isNaN(numCliente) && esTab) {
				clienteServicio.consulta(1, numCliente, { async: false, callback:function(cliente) {
					if (cliente != null) {
						
						$('#pagadorID').val(cliente.numero);
						$('#nomPagador').val(cliente.nombreCompleto);
						personaRFC = cliente.RFC;
						numeroValido = cuentaRFC();

						 if (cliente.estatus=='I'){
						 	clienteValido = 0;
								deshabilitaBoton('actualiza','submit');
								mensajeSis("El Cliente se encuentra Inactivo");
								$('#pagadorID').focus();
								$('#pagadorID').val('');
								$('#nomPagador').val('');
						 }
						 else{
						 	clienteValido = 1;
						 }

					} else {
						clienteValido = 0;
						mensajeSis("No Existe el Cliente");
						$('#pagadorID').val('');						
						$('#nomPagador').val('');
						$('#pagadorID').focus();
						deshabilitaBoton('agrega', 'submit');
					}
				}});
			}
		}
		
		function buscarDivisa(monedaID) {
						var monedaid = eval("'#" + monedaID + "'");
						var monedaNum = $(monedaid).val();
						if(monedaNum != '' && !isNaN(monedaNum)) {
							if(monedaNum=='0'){
								inicializaForma('formaGenerica','monedaIDDoc' );
								habilitaBoton('agrega', 'submit');
								deshabilitaBoton('modifica', 'submit');
						
							}
							else {
						var divisaBean = {
							'monedaId' : monedaNum
						};

						divisasServicio.consultaExisteDivisa(3,divisaBean,{ async: false, callback:function(divisa) {
								if (divisa != null) {

									$('#descMoneda').val(divisa.descripcion);
									$('#tipoCambio').val(divisa.tipCamDof);

									deshabilitaBoton('agrega','submit');
									habilitaBoton('modifica','submit');
									
								} 
								else {
									mensajeSis("La Moneda no Existe");
									inicializaForma('formaGenerica','monedaIDDoc' );
										$('#monedaIDDoc').focus();
										$('#monedaIDDoc').select();	
								}
						}});

						
					}
						}
						

					}
    
		
	

		 //Funcion de consulta para obtener el nombre de la institucion	
		function consultaPolizaInfAdicional() {
			var numPoliza = $('#polizaID').val();
			setTimeout("$('#cajaLista').hide();", 200);	
			var PolizaInfAdicionalBeanCon = {
				'polizaID':numPoliza
			};	

			if(numPoliza!='' && !isNaN(numPoliza)){

				polizaServicio.consulta(3,PolizaInfAdicionalBeanCon,function(dcto){		
						if(dcto!=null){	
							datos = 1;
							desbloqueaCampos();	
							$('#informacionAdicional').show();		
							deshabilitaBoton('agregarDoc', 'submit');
  							habilitaBoton('modificarDoc', 'submit');

							var tipoMov = dcto.movimiento;	
  		   					consultaTipo(tipoMov); 
							$('#movimiento').val(dcto.movimiento);
							$('#institucionID').val(dcto.institucionID);
							consultaInstitucion('institucionID');
							$('#numCtaBancaria').val(dcto.numCtaBancaria);
							$('#cuentaClabe').val(dcto.cuentaClabe);
							$('#tipoDoc').val(dcto.tipoDoc);
							$('#numCheque').val(dcto.numCheque);
							$('#pagadorID').val(dcto.pagadorID);
							$('#ctaClabeOrigen').val(dcto.ctaClabeOrigen);
							if(tipoMov == "E"){
								esTab = true;
								consultaProveedor('pagadorID');
							}else{
								esTab = true;
								consultaCliente('pagadorID');
							}
							$('#importe').val(dcto.importe);
							$('#referenciaDoc').val(dcto.referenciaDoc);
							$('#metodoPago').val(dcto.metodoPago);
							$('#monedaIDDoc').val(dcto.monedaIDDoc);
							buscarDivisa('monedaIDDoc'); 
							var MetodoPago =  $('#metodoPago option:selected').text();
							if(MetodoPago == 'TRANSFERENCIA'){
								$('#Transferencia').show();	
								$('#instOrigenID').val(dcto.instOrigenID);
								consultaInstitucionOrigen('instOrigenID');
								$('#instOrigenID').focus();	
							}else{
								$('#instOrigenID').val("");
								$('#nomInstOrigen').val("");
								$('#ctaClabeOrigen').val("");								
								$('#Transferencia').hide();
							}

							
						}else{	
							datos = 0;						
							exito();
							bloqueaCampos();
							deshabilitaBoton('agregarDoc', 'submit');
  							deshabilitaBoton('modificarDoc', 'submit');
							
						}	
										
					});

			}
		
		}
		
		
		 //Funcion de consulta para obtener el nombre de la institucion	
		function consultaInstitucion(idControl) {
			var jqInstituto = eval("'#" + idControl + "'");
			var numInstituto = $(jqInstituto).val();
			setTimeout("$('#cajaLista').hide();", 200);	
			var InstitutoBeanCon = {
				'institucionID':numInstituto
			};
			if(numInstituto!='' && !isNaN(numInstituto)){
					institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,{ async: false, callback:function(instituto){		
						if(instituto!=null){							
							$('#nomInstitucion').val(instituto.nombre);
						}else{
							mensajeSis("No existe la Institución"); 
							$('#institucionID').val('');
							$('#institucionID').focus();
							$('#nomInstitucion').val("");
						}    						
					}});
			}else{
				$('#institucionID').val('');
				$('#nomInstitucion').val("");
			}
		
		}


		 //Funcion de consulta para obtener el nombre de la institucion	
		function consultaInstitucionOrigen(idControl) {
			var jqInstituto = eval("'#" + idControl + "'");
			var numInstituto = $(jqInstituto).val();
			setTimeout("$('#cajaLista').hide();", 200);	
			var InstitutoBeanCon = {
				'institucionID':numInstituto
			};
			if(numInstituto!='' && !isNaN(numInstituto)){
					institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,{ async: false, callback:function(instituto){		
						if(instituto!=null){							
							$('#nomInstOrigen').val(instituto.nombre);
						}else{
							mensajeSis("No existe la Institución"); 
							$('#instOrigenID').val('');
							$('#instOrigenID').focus();
							$('#nomInstOrigen').val("");
						}    						
					}});
			}else{
				$('#instOrigenID').val('');
				$('#nomInstOrigen').val("");
			}
		
		}
		
		

		function validaCtaNostroExiste(numCta,institID){
  		var jqNumCtaInstit = eval("'#" + numCta + "'");
  		var jqInstitucionID = eval("'#" + institID + "'");
  		var numCtaInstit = $(jqNumCtaInstit).val();
  		var institucionID = $(jqInstitucionID).val();
  		var CtaNostroBeanCon = {
  				'institucionID':institucionID,
  				'numCtaInstit':numCtaInstit
  		};

		setTimeout("$('#cajaLista').hide();", 200);
  		if(numCtaInstit != '' && !isNaN(numCtaInstit)){
  			cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.resumen,CtaNostroBeanCon, function(ctaNostro){
  				  				
  				if(ctaNostro!=null){  
  				 				
	  				var cuenta = ctaNostro.cuentaClabe;
					$('#cuentaClabe').val(cuenta);
					
					validaCuentaContable('cuentaCompletaID') ;		
									
					
  				}
  				else{
  					mensajeSis("No Existe el Número de Cuenta.");
  					$('#numCtaBancaria').focus();
					$('#numCtaBancaria').val('');
					$('#cuentaClabe').val('');

  					deshabilitaBoton('grabar', 'submit');
  					deshabilitaBoton('imprimir', 'submit');
  					deshabilitaBoton('adjuntar', 'submit');
  					
					
  				} 
  			});
  		}else{$('#numCtaInstit').val('');}
  	}

  		function validaCuentaContable(idControl) { 
		var jqCtaContable = eval("'#" + idControl + "'");
		var numCtaContable = $(jqCtaContable).val();
		var conPrincipal = 1;
		var CtaContableBeanCon = {
			'cuentaCompleta':numCtaContable
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaContable != '' && !isNaN(numCtaContable)){
			cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){					
					$('#descripcion').val(ctaConta.descripcion); 				
				} 
				else{
					mensajeSis("No Existe la Cuenta Contable.");
					$('#cuentaCompletaID').focus(); 
					$('#descripcion').val("");
				}
			}); 
		}else{
			$('#cuentaCompletaID').val('');
		}
  	}
  	function exito() {
  		$('#movimiento').val("");
  		$('#institucionID').val("");
  		$('#nomInstitucion').val("");
  		$('#numCtaBancaria').val("");
  		$('#cuentaClabe').val("");
  		$('#tipoDoc').val("");
  		$('#numCheque').val("");
  		$('#pagadorID').val("");
  		$('#nomPagador').val("");
  		$('#importe').val("");
  		$('#referenciaDoc').val("");
  		$('#metodoPago').val("");
  		$('#monedaIDDoc').val("");
  		$('#descMoneda').val("");
  		$('#tipoCambio').val("");	
  		$('#instOrigenID').val("");
  		$('#ctaClabeOrigen').val("");
  		$('#nomInstOrigen').val("");	
  		botonPrincipal = 1;		
  							
  					
  		}  		
  	
  		function falloPantalla() {
		}
		
		function cuentaRFC(){
			var numero = 0;
			$("input[name=RFC]").each(function(i){		

				var jqValida = eval("'#" + this.id + "'");	
				var id = jqValida.replace(/\D/g,'');
				var valor = $('#RFC'+id).val();	
				if(valor != personaRFC){
					numero = numero+1;

				}		
				

					
				});
			return numero;
		}
		function bloqueaCampos(){

			deshabilitaControl('institucionID');
			deshabilitaControl('nomInstitucion');
			deshabilitaControl('numCtaBancaria');
			deshabilitaControl('cuentaClabe');
			deshabilitaControl('tipoDoc');
			deshabilitaControl('numCheque');
			deshabilitaControl('pagadorID');
			deshabilitaControl('importe');
			deshabilitaControl('referenciaDoc');
			deshabilitaControl('metodoPago');
			deshabilitaControl('monedaIDDoc');
			deshabilitaControl('descMoneda');
			deshabilitaControl('ctaClabeOrigen');
			deshabilitaControl('instOrigenID');
	
		}

		function desbloqueaCampos(){

			habilitaControl('institucionID');
			habilitaControl('numCtaBancaria');
			habilitaControl('tipoDoc');
			habilitaControl('numCheque');
			habilitaControl('pagadorID');
			habilitaControl('importe');
			habilitaControl('referenciaDoc');
			habilitaControl('metodoPago');
			habilitaControl('monedaIDDoc');
			habilitaControl('ctaClabeOrigen');
			habilitaControl('instOrigenID');
	
		}

  		function limpiaPolizaInfAdicional() {
	  		$('#movimiento').val("");
	  		$('#institucionID').val("");
	  		$('#nomInstitucion').val("");
	  		$('#numCtaBancaria').val("");
	  		$('#cuentaClabe').val("");
	  		$('#tipoDoc').val("");
	  		$('#numCheque').val("");
	  		$('#pagadorID').val("");
	  		$('#nomPagador').val("");
	  		$('#importe').val("");
	  		$('#referenciaDoc').val("");
	  		$('#metodoPago').val("");
	  		$('#monedaIDDoc').val("");
	  		$('#descMoneda').val("");
	  		$('#tipoCambio').val("");	
	  		$('#instOrigenID').val("");
	  		$('#ctaClabeOrigen').val("");
	  		$('#nomInstOrigen').val("");	
  							
  					
  		}  		
	   
		