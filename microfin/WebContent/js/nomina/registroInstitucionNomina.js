$(document).ready(function() {
	esTab = true;
	// Definicion de Constantes y Enums
	var catTipoTransaccionInstitucion = {
		'agrega' : '1',
		'modifica':'2',
		'actualizacion':'3'
	};

	var catTipoActualInstitucion = {
		'estatusBaja':'1'
	};
	var catTipoConsultaInstitucion = {
			'principal':1 

	};
	var catTipoConsultaInstituciones = {
			'foranea':2
	};
	
	var catTipoConsultaCtaNostro = {
		'resumen' : 4
	};

	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('cancelar', 'submit');
	consultaAplicaTabla();
	
	$('#formaGenerica2').hide();
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
     	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','institNominaID',
     			'Exito','Error'); 
		}
   });			
	$('#reqVerificacion').attr("checked",true);
	$('#espCtaConNo').attr("checked",true);
	$('#aplicaTablaNo').attr("checked",true);

	$('#institNominaID').blur(function(){
		validaInstitucionNomina(this.id);
	});
	
	$('#institNominaID').bind('keyup',function(e) {
		lista('institNominaID', '2', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});

	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '2', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});
	
	$('#numCtaInstit').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionID').val();
		listaAlfanumerica('numCtaInstit', '0', '3', camposLista,parametrosLista, 'ctaNostroLista.htm');	       
	});	
	
	$('#numCtaInstit').blur(function(){
				
   			validaCtaNostroExiste('numCtaInstit','institucionID');
   		
   	});
	
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#numCtaContable').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#numCtaContable').val();
			lista('numCtaContable', '3', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});
	
	$('#numCtaContable').blur(function(){
		validaCuentaContable('numCtaContable');
	});

	$('#tipoMovID').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "movConciliado";
			camposLista[1] = "numCuenta";
			parametrosLista[0] = $('#tipoMovID').val();
			parametrosLista[1] = $('#numCtaContable').val();
			lista('tipoMovID', '1', '6', camposLista, parametrosLista, 'aplicacionPagosInsLista.htm');
		}
	}); 

	$('#tipoMovID').blur(function() {
		if($('#tipoMovTesoID').val()!=""){
			validaConcepto('tipoMovID');
		}  		    
	});

	$('#agregar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionInstitucion.agrega);
		$('#tipoActualizacion').val(catTipoActualInstitucion.estatusBaja);
	});
	
	$('#modificar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionInstitucion.modifica);
		$('#tipoActualizacion').val(catTipoActualInstitucion.estatusBaja);
	});
	
	$('#cancelar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionInstitucion.actualizacion);
		$('#tipoActualizacion').val(catTipoActualInstitucion.estatusBaja);
	});

   $('#institucionID').blur(function() {
	    consultaInstitucionBancaria(this.id);  
	});
   
   $('#clienteID').blur(function() {
	   consultaCliente(this.id);  
	});
   $('#telContactoRH').setMask('phone-us');

   $("#espCtaConSi").click(function() {
		$("#cuentaMov").show();
	});



   $("#espCtaConNo").click(function() {
		$("#cuentaMov").hide();
   		$("#numCtaContable").val('');
   		$("#tipoMovID").val('');
	});

   validaEspCuenta();
   
	// ------------ Validaciones de la Forma
	$('#formaGenerica').validate({
		rules : {
			institNominaID: {
				required: true		
			},
			nombreInstit : {
				required: true
			},
			domicilio : {
				required: true
			},
			contactoRH: {
				required: true	
			},
			extTelContacto: {
				number: true	
			},
				
			correo: {
				email : true,
			},
			numCtaContable: {
				required : function() {return $("#espCtaConSi").is(':checked');}
			},
			tipoMovID: {
				required : function() {return $("#espCtaConSi").is(':checked');}
			}
		},
	
		messages : {
			institNominaID : {
				required : 'Especificar Empresa de Nómina.'
			},
			nombreInstit : {
				required : 'Especificar Nombre de la Empresa.'
			},
			domicilio : {
				required: 'Especificar Dirección de la Empresa.'
			},
			contactoRH : {
				required : 'Especificar Nombre del Contacto.'

			},
			extTelContacto: {
				number:'Sólo Números(Campo opcional).'	
			},
			correo: {
				email :'Correo Inválido.',
			},
			numCtaContable: {
				required : 'Especificar la cuenta contable.'
			},
			tipoMovID: {
				required : 'Especificar el tipo de movimiento.'
			}
		}
	});
		

	// ------------ Validaciones de Institución de Nómina-------------------------------------
	
	 function validaInstitucionNomina(idControl) {
		var jqInstitucion  = eval("'#" + idControl + "'");
		var numInstitucion = $(jqInstitucion).val();
		if(numInstitucion != '' && !isNaN(numInstitucion) && esTab){
		var institNominaBean = {
				'institNominaID': numInstitucion						
		};
		if(numInstitucion == '0'){ 
			limpiarFormulario();
			agregaFormatoControles('formaGenerica');
			habilitaBoton('agregar', 'submit');	
			deshabilitaBoton('modificar', 'submit');
			deshabilitaBoton('cancelar', 'submit');
		}else{
			deshabilitaBoton('agregar', 'submit');	
			habilitaBoton('modificar', 'submit');
			habilitaBoton('cancelar', 'submit');

			institucionNomServicio.consulta(catTipoConsultaInstitucion.principal,institNominaBean,function(institucionNomina) {
			if(institucionNomina!=null){
				$('#formaGenerica2').show();
				funcionLimpiaConvenio();
				if(institucionNomina.estatus == 'B'){
					mensajeSis("La Empresa de Nómina se Encuentra Cancelada");
					$('#institNominaID').focus();
					$('#nombreInstit').val(institucionNomina.nombreInstit);
					$('#clienteID').val(institucionNomina.clienteID);
					$('#contactoRH').val(institucionNomina.contactoRH);
					$('#telContactoRH').val(institucionNomina.telContactoRH);
					$('#telContactoRH').setMask('phone-us');
					$('#extTelContacto').val(institucionNomina.extTelContacto);
					$('#institucionID').val(institucionNomina.institucionID);
					$('#numCtaInstit').val(institucionNomina.cuentaDeposito);
					$('#correo').val(institucionNomina.correo);
					$('#domicilio').val(institucionNomina.domicilio);
					
					if(institucionNomina.reqVerificacion=='S')
					$('#reqVerificacion').attr("checked",true);
					if(institucionNomina.reqVerificacion=='N')
					$('#reqVerificacion1').attr("checked",true);

					if(institucionNomina.espCtaCon=='S'){
						$('#espCtaConSi').attr("checked",true);
					}else{
						$('#espCtaConNo').attr("checked",true);
					}

					if(institucionNomina.aplicaTabla=='S'){
						$('#aplicaTablaSi').attr("checked",true);
					}else{
						$('#aplicaTablaNo').attr("checked",true);
					}

					$('#numCtaContable').val(institucionNomina.numCtaContable);
					$('#tipoMovID').val(institucionNomina.tipoMovID);

					validaEspCuenta();
					validaConcepto('tipoMovID');
					consultaInstitucionBancaria('institucionID');  
					consultaCliente('clienteID');
					validaCuentaContable('numCtaContable');
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('modificar', 'submit');
					deshabilitaBoton('cancelar', 'submit');
				}
				else {
				$('#nombreInstit').val(institucionNomina.nombreInstit);
				$('#clienteID').val(institucionNomina.clienteID);
				$('#contactoRH').val(institucionNomina.contactoRH);
				$('#telContactoRH').val(institucionNomina.telContactoRH);
				$('#telContactoRH').setMask('phone-us');
				$('#extTelContacto').val(institucionNomina.extTelContacto);
				$('#institucionID').val(institucionNomina.institucionID);
				$('#numCtaInstit').val(institucionNomina.cuentaDeposito);
				$('#correo').val(institucionNomina.correo);
				$('#domicilio').val(institucionNomina.domicilio);
				
				if(institucionNomina.reqVerificacion=='S')
				$('#reqVerificacion').attr("checked",true);
				if(institucionNomina.reqVerificacion=='N')
				$('#reqVerificacion1').attr("checked",true);

				if(institucionNomina.espCtaCon=='S'){
					$('#espCtaConSi').attr("checked",true);
				}else{
					$('#espCtaConNo').attr("checked",true);
				}

				if(institucionNomina.aplicaTabla=='S'){
					$('#aplicaTablaSi').attr("checked",true);
				}else{
					$('#aplicaTablaNo').attr("checked",true);
				}

				$('#numCtaContable').val(institucionNomina.numCtaContable);
				$('#tipoMovID').val(institucionNomina.tipoMovID);

				validaEspCuenta();
				validaConcepto('tipoMovID');
				consultaInstitucionBancaria('institucionID');  
				consultaCliente('clienteID');
				validaCuentaContable('numCtaContable');
				deshabilitaBoton('grabar', 'submit');
				habilitaBoton('modificar', 'submit');
				habilitaBoton('cancelar', 'submit');
				}
			}else{
				$('#formaGenerica2').hide();
				mensajeSis("El Número de Empresa de Nómina No Existe");
				limpiarFormulario();
				$('#institNominaID').focus();
				$('#institNominaID').val('');
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				deshabilitaBoton('cancelar', 'submit');
				}
			});	
			}
		}
	}

	//Funcion de consulta para obtener el nombre de la institucion bancaria
	function consultaInstitucionBancaria(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		if(numInstituto != '' && !isNaN(numInstituto) && numInstituto >0 ){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){		
				if(instituto!=null){							
					$('#nombreInstitucion').val(instituto.nombre);
				}else{
					mensajeSis("No existe la Institución Bancaria"); 
					$('#institucionID').val('');	
					$('#institucionID').focus();	
					$('#nombreInstitucion').val("");					
				}    						
			});
		}else{
			$('#institucionID').val("");
			$('#nombreInstitucion').val('');
		}
	}
	
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if (numCliente != '' && !isNaN(numCliente) && numCliente >0) {
			clienteServicio.consulta(1, numCliente, function(
					cliente) {
					if(cliente.esMenorEdad != 'S'){
							if (cliente != null) {
								
								if(cliente.estatus == 'A'){
									if(cliente.tipoPersona != 'F'){
								$('#clienteID').val(cliente.numero);
								$('#nombreCliente').val(cliente.nombreCompleto);
									}else{
										mensajeSis('No Se Pueden Relacionar Personas Físicas con Empresas de Nómina.');
										$('#clienteID').focus();
										$('#clienteID').val('');
										$('#nombreCliente').val('');
									}
							
								}else{
									mensajeSis('El Cliente Esta Inactivo.');
									$('#clienteID').focus();
									$('#clienteID').val('');
									$('#nombreCliente').val('');
								}
							} else {
								mensajeSis("El Número de Cliente no Existe");
					$('#clienteID').focus();
					$('#clienteID').val('');
					$('#nombreCliente').val('');
				}
			}else{
				mensajeSis('El Socio Es Menor de Edad');
				$('#clienteID').focus();
				$('#clienteID').val('');
				$('#nombreCliente').val('');
				
			}
					
			});
		}
			else {
				 $('#clienteID').val("");
				 $('#nombreCliente').val('');
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
  	if(numCtaInstit != '' && !isNaN(numCtaInstit) && institucionID != '' && !isNaN(institucionID) && esTab==true ){  			 		
  			cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.resumen,CtaNostroBeanCon, function(ctaNostro){  				  			
  				if(ctaNostro!=null){  	
  					
					if(ctaNostro.estatus !='A'){
						mensajeSis("El Número de Cuenta Bancaria esta Inactiva");
						$('#numCtaInstit').focus();
						$('#numCtaInstit').val('');
	  				}
  				}
  				else{
					mensajeSis("No Existe la Cuenta Bancaria");
  					$('#numCtaInstit').val('');
  					$('#numCtaInstit').focus();
  				} 
  			});
  		}
  	}
	
	});//	Fin de las validaciones 
	
	function limpiarFormulario(){
		$('#nombreInstit').val('');
		$('#clienteID').val('');
		$('#contactoRH').val('');
		$('#telContactoRH').val('');
		$('#extTelContacto').val('');
		$('#institucionID').val('');
		$('#nombreInstitucion').val('');
		$('#numCtaInstit').val('');
		$('#nombreCliente').val('');
		$('#correo').val('');
		$('#domicilio').val('');
		$('#reqVerificacion1').attr("checked",true);

		$('#aplicaTablaNo').attr("checked",true);
		$('#espCtaConNo').attr("checked",true);
		$('#numCtaContable').val('');
		$('#tipoMovID').val('');
		$('#descMovimiento').val('');
		
		deshabilitaBoton('agregar', 'submit');	
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('cancelar', 'submit');
		validaEspCuenta();
		funcionLimpiaConvenio();
	}
	
	function Exito(){
		limpiarFormulario();
		$('#formaGenerica2').show();
	}

	function Error(){
		$('#formaGenerica2').hide();
		if($("#institNominaID").val()!=0 && $("#institNominaID").val()!="" && $("#institNominaID").val()!=null){
			habilitaBoton('modificar', 'submit');
		}
		else{
			habilitaBoton('agregar', 'submit');	
		}
		deshabilitaBoton('cancelar', 'submit');
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
					$('#numCtaContable').val(ctaConta.cuentaCompleta);
				}
				else{
					mensajeSis("No Existe la Cuenta Contable.");
					$('#numCtaContable').val("");	
					$('#numCtaContable').focus();	
				}
			}); 																					
		}
	}

	function validaConcepto(idControl) { 
		var jqCtaConcepto = eval("'#" + idControl + "'");
		var numConcepto = $(jqCtaConcepto).val();
		var tipoConciliado= 'C';
		var tesoMovTipoBean = {
				'tipoMovTesoID':numConcepto,
				'tipoMovimiento':tipoConciliado
		};

		setTimeout("$('#cajaLista').hide();", 200);

		if(numConcepto != '' && !isNaN(numConcepto) && numConcepto==0){
		}
		else{
			if(numConcepto != '' && !isNaN(numConcepto) ){
				TiposMovTesoServicioScript.conTiposMovTeso(1,tesoMovTipoBean,function(tipoBean){
					if(tipoBean!=null){
						$('#tipoMovID').val(tipoBean.tipoMovTesoID);
						$('#descMovimiento').val(tipoBean.descripcion);
						
					} 
					else{
						mensajeSis("No Existe el Tipo de Movimiento.");

						$('#tipoMovID').val("");
						$('#descMovimiento').val("");
						//function limpiapantalla
					}
				}); 

			}  

		}	
	}

	function consultaAplicaTabla() {
		var conAplicaTabla = 37;
		var institNominaBean = {
				'institNominaID': 0
		};

		institucionNomServicio.consulta(conAplicaTabla,institNominaBean,function(datos){
			
			if(datos!=null){
				if (datos.aplicaTabla == 'S') {
					$('#aplicaTabla').show();
					$('#aplicaTablaNo').attr("checked",true);
				}else{
					$('#aplicaTabla').hide();
					$('#aplicaTablaNo').attr("checked",true);
				}
			}
		});
	}

	function validaEspCuenta(){
		if ($("#espCtaConNo").is(':checked')) {
	   		$("#cuentaMov").hide();
	   		$("#numCtaContable").val('');
	   		$("#tipoMovID").val('');
	   }

	   if ($("#espCtaConSi").is(':checked')) {
	   		$("#cuentaMov").show();
	   }
	}