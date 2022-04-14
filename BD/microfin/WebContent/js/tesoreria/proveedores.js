$(document).ready(function() {

	$("#proveedorID").focus();


	esTab = true;

	//Definicion de Constantes y Enums
	var catTipoTransaccionProveedores = {
			'agrega':'1',
			'modifica':'2'	,
			'elimina':'3'};

	var catTipoConsultaProveedores = {
			'principal'	: 1


	};

	var catTipoConsultaInstituciones = {
			'principal':1,
			'foranea':2
	};

	var catTipoConsultaCtaNostro = {
			'folioInstit':5
	};

	//------------ Msetodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('elimina', 'submit');
	deshabilitaControl('desTipoProveedor');
	listaTipoTercero();
	$('#fechaNacimiento').datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'yy-mm-dd' ,
		minDate: new Date(1900, 1 - 1, 1),
		yearRange: '-100:+10'
	});

	$('#fechaNacimiento').datepicker($.datepicker.regional['es']);

	$('#fechaNacimiento').blur(function() {
		$('#CURP').focus();
	});


	$('#tipoPersona').click(function() {
		$('#personaFisica').show(500);
		$('#personaMoral').hide(500);
		$('#generar').show(500);
		$('#RFCrl').hide(500);
		$('#RFCpf').show(500);

	});

	$('#tipoPersona2').click(function() {
		$('#personaMoral').show(800);
		$('#generar').show(500);
		$('#personaFisica').hide(500);
		$('#RFCpf').hide(500);
		$('#RFCrl').show(500);
		$('#primerNombre').focus();
		$('#primerNombre').select();
	});


	$('#tipoPago').change(function() {
		valorTipoPago(this.id);

	});

	$('#tipoPersona').click(function() {
		$('#razonSocial').val('');
		$('#RFCpm').val('');
	});

	$('#RFC').blur(function() {
		validaRFC('RFC',$('#proveedorID').val());
	});


	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#institucionID').blur(function() {
		consultaInstitucion(this.id);
	});



	$('#cuentaClave').blur(function(){
		if($('#cuentaClave').val()!="" && $('#institucionID').val()!=""){
			validaExisteFolio('cuentaClave','institucionID');
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','proveedorID','funcionExito','funcionError');
		}
	});

	$('#proveedorID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "apellidoPaterno";
			parametrosLista[0] = $('#proveedorID').val();
			listaAlfanumerica('proveedorID', '1', '1', camposLista, parametrosLista, 'listaProveedores.htm');
		}
	});

	$('#tipoProveedorID').bind('keyup',function(e) {
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "tipoProveedorID";
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#tipoProveedorID').val();
			listaAlfanumerica('tipoProveedorID', '1', '1', camposLista, parametrosLista, 'listaTipoProveedores.htm');
		}
	});

	$('#tipoProveedorID').blur(function() {
		if($('#tipoProveedorID').val()!=""){
			validaTipoProveedor('tipoProveedorID');
		}
	});

	$('#paisNacimiento').bind('keyup',function(e) {
		lista('paisNacimiento', '1', '1', 'nombre', $('#paisNacimiento').val(),'listaPaises.htm');
	});

	$('#paisNacimiento').blur(function() {
		consultaPaisNac(this.id);
	});

	$('#estadoNacimiento').bind('keyup',function(e) {
		lista('estadoNacimiento', '2', '1', 'nombre',$('#estadoNacimiento').val(),'listaEstados.htm');
	});

	$('#estadoNacimiento').blur(function() {
		consultaEstado(this.id);
	});

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionProveedores.agrega);
	});

	$('#modifica').click(function() {
		var pagos=$('#tipoPago').val();

		if ($('#tipoPersona:checked').val() == "F") {
			$('#RFCpm').val("");
			$('#razonSocial').val("");
		}

		if ($('#tipoPersona2:checked').val() == "M") {
			$('#RFC').val("");
		}

		modificaPago(pagos);
	});

	$('#elimina').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionProveedores.elimina);
		$("#tipoProveedorID").rules("remove");
	});

	$('#proveedorID').blur(function() {
		inicializaForma('formaGenerica','proveedorID' );
		validaProveedor(this.id);
	});


	$('#generar').click(function() {
		formaRFC();
	});

	$('#cuentaCompleta').blur(function() {
		if($('#cuentaCompleta').val()!=""){
			validaCuentaContable('cuentaCompleta');
		}
		else{
			$('#descripcionCuenta').val('');
		}
	});

	$('#cuentaCompleta').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#cuentaCompleta').val();
			listaAlfanumerica('cuentaCompleta', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});

	$('#cuentaAnticipo').bind('keyup',function(e){
		listaCuentasAnticipo(this.id);
	});
	$('#cuentaAnticipo').blur(function() {
		validaCuentaAnticipacion(this.id);
	});

	$('#telefono').setMask('phone-us');
	$('#telefonoCelular').setMask('phone-us');

	$("#extTelefonoPart").blur(function(){
		if(this.value != ''){
			if($("#telefono").val() == ''){
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío.");
				$("#telefono").focus();
			}
		}
	});
	$('#telefono').blur(function() {
		if(this.value == ''){
			$("#extTelefonoPart").val('');
		}
	});

	$('#tipoTerceroID').change(function() {
		listaTipoOperacion();
		var tipoTercero = $('#tipoTerceroID').val();

		if(tipoTercero == '05'){
			// Muestra los elementos DIOT
			mostrarElementoPorClase('residenciaDIOT','S');
			$('#personaMoral').show(800);
			$('#generar').show(500);
			$('#personaFisica').hide(500);
			$('#RFCpf').hide(500);
			$('#RFCrl').show(500);

			if($('#tipoPersona2').is(':checked'))
   			 {
   			 	$('#personaMoral').show(500);
   			 	$('#personaFisica').hide(500);
   			 }
   			 else{
   			 	$('#personaFisica').show(500);
   			 	$('#personaMoral').hide(500);
   			 }

		}
		else{

   			if($('#tipoPersona2').is(':checked'))
   			 {
   			 	$('#personaMoral').show(500);
   			 	$('#personaFisica').hide(500);
   			 }
   			 else{
   			 	$('#personaFisica').show(500);
   			 	$('#personaMoral').hide(500);
   			 }

			// Oculta los elementos DIOT
			mostrarElementoPorClase('residenciaDIOT','N');
			$('#generar').show(500);
			$('#RFCrl').hide(500);
			$('#RFCpf').show(500);

		}

	});


	$('#paisResidencia').bind('keyup',function(e) {
		lista('paisResidencia', '1', '3', 'nombre', $('#paisResidencia').val(),'listaPaises.htm');
	});

	$('#paisResidencia').blur(function() {
		consultaPais(this.id);
	});


	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

		rules: {
			proveedorID: {
				required: true
			},

			tipoTerceroID: {
				required: true
			},

			tipoOperacionID: {
				required: true
			},

			apellidoPaterno: {
				required: function() {return $('#tipoPersona:checked').val()=='F'},
			},

			primerNombre: {
				required: function() {return $('#tipoPersona:checked').val()=='F'},
			},

			fechaNacimiento: {
				required: function() {return $('#tipoPersona:checked').val()=='F'},
				date: true
			},

			RFC: {
				required: function() {return $('#tipoPersona:checked').val()=='F'},
				maxlength: 13,
				minlength: 13
			},

			razonSocial: {
				required:	function() {return $('#tipoPersona2:checked').val()=='M'},
			},

			RFCpm: {
				required:	function() {return $('#tipoPersona2:checked').val()=='M'},
				maxlength: 12,
				minlength: 12
			},

			idFiscal: {
				required:	function() {return $('#tipoTerceroID').val()=='05'},
				maxlength: 40,
			},

			paisResidencia: {
				required:	function() {return $('#tipoTerceroID').val()=='05'},
			},
			institucionID :{
				required: function() {return $('#tipoPago').val()=='S'}
			},
			cuentaClave :{
				required: function() {return $('#tipoPago').val()=='S'},
				number: true,
				maxlength: 18,
				minlength: 18
			},
			cuentaCompleta: {
				required: true,
				maxlength: 25,
				minlength: 1
			},
			cuentaAnticipo: {
				required: true,
				maxlength: 25,
				minlength: 1
			},
			tipoProveedorID:{
				required: true
			},
			extTelefonoPart: {
				number: true
			},
			paisNacimiento : {
				required: function() {return $('#tipoPersona:checked').val()=='F'},
			},
			estadoNacimiento : {
				required: function() {return $('#tipoPersona:checked').val()=='F'},
			}
		},
		messages: {
			proveedorID: {
				required: 'Especifica Proveedor.'
			},

			tipoTerceroID: {
				required: 'Especifique un Tipo de Tercero.'
			},

			tipoOperacionID: {
				required: 'Especifique un Tipo de Operación.'
			},

			apellidoPaterno: {
				required: 'Especifica Apellido'
			},

			primerNombre: {
				required: 'Especifica Nombre'
			},

			fechaNacimiento: {
				required: 'Especifica Fecha',
				date:	'Fecha Incorrecta'
			},

			RFC: {
				required: 'Especifica RFC',
				maxlength: 'máximo 13 caracteres',
				minlength: 'mínimo 13 caracteres'
			},

			razonSocial: {
				required: 'Especifica Razón Social'
			},

			RFCpm: {
				required: 'Especifica RFC',
				maxlength: 'máximo 12 caracteres',
				minlength: 'mínimo 12 caracteres'
			},
			idFiscal: {
				required: 'Especifica ID Fiscal',
				maxlength: 'máximo 40 caracteres',
			},
			paisResidencia: {
				required: 'Especifique País',
			},
			institucionID :{
				required: 'Especificar Institución'
			},
			cuentaClave :{
				required: 'Especifica cuenta Clabe',
				number: 'solo numeros',
				maxlength: 'máximo 18 numeros',
				minlength: 'mínimo 18 numeros'
			},
			cuentaCompleta: {
				required : 'Especifica Cuenta Contable',
				maxlength: 'máximo 25 caracteres',
				minlength: 'mínimo 1 caracter'
			},
			cuentaAnticipo: {
				required : 'Especifica Cuenta Anticipo',
				maxlength: 'máximo 25 caracteres',
				minlength: 'mínimo 1 caracter'
			},
			tipoProveedorID: {
				required: 'Especifica el Tipo de Proveedor'
			},
			extTelefonoPart: {
				number: 'Sólo Números(Campo opcional)'
			},
			paisNacimiento: {
				required: 'Especifica el País de Nacimiento.'
			},
			estadoNacimiento: {
				required: 'Especifica el Estado de Nacimiento.'
			}
		}
	});



	//------------ Validaciones de Controles -------------------------------------

	function listaTipoTercero(){
		dwr.util.removeAllOptions('tipoTerceroID');
						dwr.util.addOptions('tipoTerceroID', {'' : 'SELECCIONAR'});
						var bean={};
						proveedoresServicio.listaCombo(4,bean,function(tiposTercero) {
									dwr.util.addOptions('tipoTerceroID',	tiposTercero, 'tipoTerceroID','descripTipoTer');
								});
	}
	function listaTipoOperacion(){
		var tipoTercero = $('#tipoTerceroID').val();
		dwr.util.removeAllOptions('tipoOperacionID');
						dwr.util.addOptions('tipoOperacionID', {'' : 'SELECCIONAR'});
						var bean={
							'tipoTerceroID' : tipoTercero
						};
						proveedoresServicio.listaCombo(5,bean,{ async: false, callback:function(tipoOperacion) {
									dwr.util.addOptions('tipoOperacionID',	tipoOperacion, 'tipoOperacionID','descripTipoOper');
								}});
	}

	function consultaPais(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 4;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && esTab) {
			paisesServicio.consultaPaises(conPais, numPais,
					function(pais) {
						if (pais != null) {
							$('#descPaisResidencia').val(pais.descPaisDIOT);
							$('#nacionalidad').val(pais.nacionalidadDIOT);
						} else {
							mensajeSis("No Existe el País");
							$(jqPais).val('');
							$(jqPais).focus();
						}
					});
		}else{
			if(esTab){
				mensajeSis("No Existe el País");
				$(jqPais).val('');
				$(jqPais).focus();
			}
		}
	}

	function modificaPago(tipoPago){
		if (tipoPago =='S'){
			$('#tipoTransaccion').val(catTipoTransaccionProveedores.modifica);
		}
		else{
			$('#institucionID').val('');
			$('#cuentaClave').val('');
			$('#descripcion').val('');

			$('#tipoTransaccion').val(catTipoTransaccionProveedores.modifica);
		}

	}

	//////////////////funcion consultar institucion//////////////////
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var InstitutoBeanCon = {
				'institucionID':numInstituto
		};
		esTab=true;
		if(numInstituto != '' && !isNaN(numInstituto) && esTab){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
				if(instituto!=null){
					$('#descripcion').val(instituto.nombre);
					if($('#cuentaClave').val() != ''){
						validaExisteFolio('cuentaClave','institucionID');
					}
				}else{
					mensajeSis("No existe la Institución");
					$('#descripcion').val('');
					$('#institucionID').focus();
					$('#institucionID').val("");
				}
			});
		}
	}

	////////////////funcion validar cuenta clave////////////////
	function validaExisteFolio(cuentaClave,institID){
		var jqNumCtaInstit = eval("'#" + cuentaClave + "'");
		var jqInstitucionID = eval("'#" + institID + "'");
		var numCtaInstit = $(jqNumCtaInstit).val();
		var institucionID = $(jqInstitucionID).val();

		var CtaNostroBeanCon = {
				'institucionID':institucionID,
				'cuentaClave':numCtaInstit
		};
		esTab=true;
		if(esTab){
			cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.folioInstit,CtaNostroBeanCon, function(ctaNtro){
				if(ctaNtro!=null){
					var folio = ctaNtro.cuentaClabe;// el folio de institucion se paso en el parametro cuentaClabe
					var cuentaClabe = $('#cuentaClave').val();
					var substrClabe= cuentaClabe.substr(0,3);
					if(folio!=substrClabe){
						mensajeSis("La Cuenta Clabe no coincide con la Institución.");
						$('#cuentaClave').focus();
						$('#cuentaClave').val("");
					}
				}
			});
		}
	}

	/////////////////////funcion formar RFC//////////////////////////////
	function formaRFC(){
		if($.trim($('#primerNombre').val())!="" && $.trim($('#apellidoPaterno').val())!="" && $.trim($('#fechaNacimiento').val())!=""){
			var pn =$('#primerNombre').val();
			var sn =$('#segundoNombre').val();
			var nc =pn+' '+sn;
			var rfcBean = {
					'primerNombre':nc,
					'apellidoPaterno':$('#apellidoPaterno').val(),
					'apellidoMaterno':$('#apellidoMaterno').val(),
					'fechaNacimiento':$('#fechaNacimiento').val()
			};
			clienteServicio.formaRFC(rfcBean,function(cliente) {
				if(cliente!=null){
					$('#RFC').val(cliente.RFC);
					$('#correo').focus();
				}
			});
		}
	}

	///////////////funcion validar RFC///////////////////////////

	function validaRFC(idControl,proveedorID) {
		var jqRFC = eval("'#" + idControl + "'");
		var numRFC = $(jqRFC).val();
		var tipCon = 3;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numRFC != '' && esTab && proveedorID ==''){
			clienteServicio.consultaRFC(tipCon,numRFC,function(rfc) {
				if(rfc!=null){
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('agrega', 'submit');
					mensajeSis("El proveedor: "+rfc.numero
							+ "\ncon RFC : "+rfc.RFC
							+", \nya esta registrado en el sistema, \nfavor de utilizar este folio");
				}
			});
		}
	}


	/////////////////////funcion validar proveedor/////////////////////////////////////////////
	function validaProveedor(control) {
		var numProveedor = $('#proveedorID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		if(numProveedor != '' && !isNaN(numProveedor) && esTab){
			if(numProveedor=='0'){
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('elimina', 'submit');
				inicializaForma('formaGenerica','proveedorID' );
				$('#tipoPersona').attr("checked","1") ;
				$('#tipoPago').val("") ;
				$('#generar').show(500);
				$('#personaFisica').show(500);
				$('#personaMoral').hide(500);
				$('#RFCpf').show(500);
				$('#RFCrl').hide(500);
				$('#cheque').show(500);
				$('#tipoPagoSpei').hide(500);
				$('#descripcionCuenta').val('') ;
				$('#tipoOperacionID').val('');
				$('#tipoTerceroID').val('');
				$('#estatus').val('ACTIVO');
			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				habilitaBoton('elimina', 'submit');
				var proveedorBeanCon = {
						'proveedorID':$('#proveedorID').val()
				};
				//////////consulta de proveedores/////////////////////////////
				proveedoresServicio.consulta(catTipoConsultaProveedores.principal,proveedorBeanCon,function(proveedores) {
					if(proveedores!=null){
						dwr.util.setValues(proveedores);

						if(proveedores.tipoPersona=='F'){
							$('#tipoPersona').attr("checked","1") ;
							$('#personaFisica').show(500);
							$('#personaMoral').hide(500);
							$('#generar').hide(500);
							$('#RFCrl').hide(500);
							$('#RFCpf').show(500);
						}
						else{
							if(proveedores.tipoPersona=='M'){
								$('#tipoPersona2').attr("checked","1") ;
								$('#personaMoral').show(800);
								$('#generar').hide(500);
								$('#personaFisica').hide(500);
								$('#RFCpf').hide(500);
								$('#RFCrl').show(500);
							}
						}
						if(proveedores.fechaNacimiento=='1900-01-01'){
							$('#fechaNacimiento').val('');
						}

						if(proveedores.tipoPago!='S'){
							$('#cheque').show(500);
							$('#tipoPagoSpei').hide(500);
							$('#institucionID').val('');
							$('#cuentaClave').val('');
							$('#descripcion').val('');
						}
						else{
							$('#tipoPagoSpei').show(800);
							esTab=true;
							$('#institucionID').val(proveedores.institucionID);
							consultaInstitucion('institucionID');
						}

						if(proveedores.estatus=='A'){
							$('#estatus').val('ACTIVO');
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');
							habilitaBoton('elimina', 'submit');
						}
						if(proveedores.estatus=='B'){
							$('#estatus').val('BAJA');
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('modifica', 'submit');
							deshabilitaBoton('elimina', 'submit');
						}
						if(proveedores.tipoTerceroID == '05' && proveedores.tipoPersona=='M'){
							// Muestra los elementos DIOT
							mostrarElementoPorClase('residenciaDIOT','S');
							$('#personaMoral').show(800);



						}
						else{
							 if(proveedores.tipoPersona == 'M'){
							 	$('#personaMoral').show(800);
							 	$('#personaFisica').hide(800);
							 }
							 else
							 {
							 	$('#personaMoral').hide(800);
							 	$('#personaFisica').show(800);
							 }
							// Oculta los elementos DIOT
							mostrarElementoPorClase('residenciaDIOT','N');

						}
						esTab=true;
						validaTipoProveedor('tipoProveedorID');
						validaCuentaContable('cuentaCompleta');
						validaCuentaAnticipacion('cuentaAnticipo');
						consultaEstado('estadoNacimiento');
						consultaPaisNac('paisNacimiento');
						if(proveedores.tipoTerceroID == '05'){
							consultaPais('paisResidencia');
						}

						listaTipoOperacion();
						$('#tipoOperacionID').val(proveedores.tipoOperacionID);

					}else{
						mensajeSis("No Existe el Proveedor");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('elimina', 'submit');
						inicializaForma('formaGenerica','proveedorID' );
						$('#descripcionCuenta').val('');
						$('#tipoPersona').attr("checked","1") ;
						$('#tipoPago').val("") ;
						$('#proveedorID').focus();
						$('#proveedorID').select();
						$('#personaFisica').show();
						$('#personaMoral').hide();
						$('#generar').hide();
						$('#RFCrl').hide();
						$('#RFCpf').show();
						$('#tipoPagoSpei').hide();
					}
					$('#telefono').setMask('phone-us');
					$('#telefonoCelular').setMask('phone-us');
				});

			}

		}
	}

	function validaCuentaContable(idControl) {
		var jqCtaContable = eval("'#" + idControl + "'");
		var numCtaContable = $(jqCtaContable).val();
		var conPrincipal = 1;
		var CtaContableBeanCon = {
				'cuentaCompleta':numCtaContable
		};
		esTab = true;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaContable != '' && !isNaN(numCtaContable) && esTab ){
			cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){
					if(ctaConta.grupo != "E"){
						$('#descripcionCuenta').val(ctaConta.descripcion);
					}else{
						mensajeSis("Sólo Cuentas Contables De Detalle");
						$('#cuentaCompleta').val("");
						$('#cuentaCompleta').focus(); 
						$('#descripcionCuenta').val("");		
					}
				}
				else{
					mensajeSis("La Cuenta Contable no Existe.");
					$('#cuentaCompleta').val("");
					$('#cuentaCompleta').focus();
					$('#descripcionCuenta').val("");
				}
			});
		}else{
			$('#descripcionCuenta').val("");
		}
	}

	function validaTipoProveedor(idControl){
		var jqTipoProveedor = eval("'#" + idControl + "'");
		var numTipoProveedor = $(jqTipoProveedor).val();
		var conForanea = 2;
		var TipoProveedorBeanCon = {
				'tipoProveedorID': numTipoProveedor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		if(numTipoProveedor != '' && !isNaN(numTipoProveedor) && esTab){
			tipoProvServicio.consulta(conForanea, TipoProveedorBeanCon ,function(tipoProveedor){
				if(tipoProveedor!=null){
					$('#desTipoProveedor').val(tipoProveedor.descripcion);
				}
				else{
					mensajeSis("No Existe el Tipo Proveedor.");
					$('#tipoProveedorID').focus();
					$('#tipoProveedorID').val('');
					$('#desTipoProveedor').val("");
				}
			});
		}
	}

	function valorTipoPago(idControl) {
		if($('#tipoPago').val()!='S'){
			$('#cheque').show(500);
			$('#tipoPagoSpei').hide(500);
		}
		else{
			$('#tipoPagoSpei').show(800);
			$('#institucionID').val('');
			$('#cuentaClave').val('');
			$('#descripcion').val('');
			$('#institucionID').focus();
			$('#institucionID').select();

		}
	}

	function listaCuentasAnticipo(idControl){
		var jqControl = eval("'#" + idControl+ "'");

		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = $(jqControl).val();

		if($(jqControl).val() != '' && !isNaN($(jqControl).val() )){
			listaAlfanumerica(idControl, '1', '6', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
		else{
			listaAlfanumerica(idControl, '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}

	function validaCuentaAnticipacion(idControl) {
		var jqCtaContable = eval("'#" + idControl + "'");
		var numCtaContable = $(jqCtaContable).val();

		var tipConForanea = 2;

		var CtaContableBeanCon = {
				'cuentaCompleta':numCtaContable
		};
		esTab = true;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaContable != '' && !isNaN(numCtaContable) && esTab ){
			cuentasContablesServicio.consulta(tipConForanea,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){
					if(ctaConta.grupo != "E"){
					$('#descripCuentaAnticipo').val(ctaConta.descripcion);
				}
				else{
					mensajeSis("Sólo Cuentas Contables De Detalle");
					$(jqCtaContable).val("");
					$(jqCtaContable).focus();
					$('#descripCuentaAnticipo').val("");
				}
				}else {
					mensajeSis("La Cuenta Contable no Existe.");
					$('#cuentaAnticipo').focus();
					$('#descripCuentaAnticipo').val("");
				}
			});
		}else{
			$('#descripCuentaAnticipo').val("");
		}
	}

	function validaTipoTercero(idControl){
		var jqTipoTercero = eval("'#" + idControl + "'");
		var numTipoTercero = $(jqTipoTercero).val();
		var conForanea = 4;
		var TipoTerceroBeanCon = {
				'tipoProveedorID': numTipoTercero
		};
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		if(numTipoTercero != '' && !isNaN(numTipoTercero) && esTab){
			proveedoresServicio.consulta(conForanea, TipoTerceroBeanCon ,function(tipoTercero){
				if(tipoTercero!=null){
					$('#desTipoProveedor').val(tipoTercero.tipoTerceroID);
				}
				else{

					$('#tipoProveedorID').focus();
					$('#tipoProveedorID').val('');
					$('#desTipoProveedor').val("");
				}
			});
		}
	}
	function consultaTipoOperacion(idControl){

		var jqTipoOperacion = eval("'#" + idControl + "'");
		var numTipoOperacion = $(jqTipoOperacion).val();
		var conForanea = 5;
		var TipoOperacionBeanCon = {
				'tipoOperacionID': idControl
		};
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		if(numTipoOperacion != '' && esTab){
			proveedoresServicio.consulta(conForanea, TipoOperacionBeanCon ,function(tipoOperacion){
				if(tipoOperacion!=null){
					$('#tipoOperacionID').val(tipoOperacion.tipoOperacionID).selected = true;
				}
				else{

					$('#tipoProveedorID').focus();
					$('#tipoProveedorID').val('');
					$('#desTipoProveedor').val("");
				}
			});
		}
	}

});

function validaCaracteresNumFiscal(campo,idcampo){
	var texto = $("#"+idcampo).val();
	var objRegExp = /\u002c/;

		if (objRegExp.test(texto)){
			mensajeSis("Caracteres no Válidos");
   	    $('#'+idcampo).focus();
  	    $('#'+idcampo).val('');
			return false;
		}



  }

  function validaRazonSocial(campo,idcampo){
	var texto = $("#"+idcampo).val();
	var objRegExp = /[`@%!¡$.&,´ʹ]/gi;

		if (objRegExp.test(texto)){
			mensajeSis("Caracteres no Válidos");
   	    $('#'+idcampo).focus();
  	    $('#'+idcampo).val('');
			return false;
		}
  }

//Función de éxito en la transación
function funcionExito(){
	inicializaForma('formaGenerica','proveedorID');
	$('#tipoTerceroID').val('');
	$('#tipoOperacionID').val('');
	$('#tipoPago').val('');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('elimina', 'submit');
}

//función de error en la transacción
function funcionError(){

}

function validaCaracteres(campo, idcampo){
	var tipoExtranjero = $('#tipoTerceroID').val();
	if(tipoExtranjero == '05'){
		validaRazonSocial(campo, idcampo);
	}
}

function consultaPaisNac(idControl) {
	var jqPais = eval("'#" + idControl + "'");
	var numPais = $(jqPais).val();
	var conPais = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numPais != '' && !isNaN(numPais) && esTab) {
		paisesServicio.consultaPaises(conPais, numPais,function(pais) {
			if (pais != null) {
				$('#estadoNacimiento').attr('readonly',false);
				$('#paisNac').val(pais.nombre);
				if (pais.paisID != 700) {
					$('#estadoNacimiento').val(0);
					$('#estadoNacimiento').attr('readonly',true);
					$('#nombreEstado').val('NO APLICA');
				}
			} else {
				mensajeSis("No Existe el País.");
				$(jqPais).focus();
				$(jqPais).val('');
				$('#paisNac').val('');
			}
		});
	}
}

function consultaEstado(idControl) {
	var jqEstado = eval("'#" + idControl + "'");
	var numEstado = $(jqEstado).val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numEstado != '' && !isNaN(numEstado) && esTab) {
		estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
			if (estado != null) {
				var p = $('#lugarNacimiento').val();
				if (p == 700 && estado.estadoNacimiento == 0 && esTab) {
					mensajeSis("No Existe el Estado.");
					$('#estadoNacimiento').focus();
				}
				$('#nombreEstado').val(estado.nombre);
			} else {
				mensajeSis("No Existe el Estado.");
				$(jqEstado).focus();
				$(jqEstado).val('');
				$('#nombreEstado').val('');
			}
		});
	}
}
