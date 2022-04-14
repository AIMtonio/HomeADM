$(document).ready(function(){	
		agregaFormatoControles('formaGenerica');
		
		var Enum_Tran_CatCajerosATM={
			  'agregar':1,
			  'modificar':2,
			  'cancelar':3
		};
		var catTipoConsultaUsuario = {
			  'principal':1
		};	
		var Enum_Act_CatCajerosATM = {
				  'actualizarStatus':1
		};
		var Enum_Con_CatCajerosATM={
			  'consultaPrincipal':1
		};
		
		$(':text').focus(function() {
			esTab = false;
		});

		$(':text').bind('keydown', function(e) {
			if (e.which == 9 && !e.shiftKey) {
				esTab = true;
			}
		});
		
		deshabilitaBoton('modifica', 'submit');
		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('cancela','submit');
		
		llenarComboTipoCajero();

		$('#cajeroID').focus();
		
		$.validator.setDefaults({
			submitHandler: function(event) {
		   	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','catalogoServID','FuncionExitosaATM','FuncionErrorExitosaATM');
			}
		});
		
		$('#cajeroID').bind('keyup',function(e){
				lista('cajeroID', '1', '2','nombreCompleto',$('#cajeroID').val(), 'listaCajerosATM.htm');
		});
		$('#cajeroID').blur('keyup',function(e){
		      if($('#cajeroID').val()!=""){
		    	  consultaCajero(this.id);
		      }else{
		    	  $('cajeroID').val('');
		      }
		});
					
		$('#sucursalID').bind('keyup',function(e){
			lista('sucursalID', '2', '4', 'nombreSucurs',$('#sucursalID').val(), 'listaSucursales.htm');
		});
		$('#sucursalID').blur(function() {
			if($('#sucursalID').val()!="")
			  	consultaSucursal(this.id);
			else
				$('#nombreSucursal').val('');
		});
		
		$('#usuarioID').bind('keyup',function(e){
			lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
		});
		$('#usuarioID').blur('keyup',function(e){
			if($('#usuarioID').val() != "")
				validaUsuario(this.id);
			else
				$('#usuario').val('');
		});
		$('#ctaContableMN').bind('keyup',function(e){
			listaMaestroCuentas(this.id);
		});
		$('#ctaContableME').bind('keyup',function(e){
			listaMaestroCuentas(this.id);
		});
		$('#ctaContaMNTrans').bind('keyup',function(e){
			listaMaestroCuentas(this.id);
		});
		$('#ctaContaMETrans').bind('keyup',function(e){
			listaMaestroCuentas(this.id);
		});
		$('#ctaContableMN').blur(function() {	
			if(esTab){
				maestroCuentasDescripcion(this.id, 'descripcionCtaContaMN');
			}
		});
		$('#ctaContableME').blur(function() {	
			if(esTab){
				maestroCuentasDescripcion(this.id, 'descripcionCtaContaME');
			}
		});
		$('#ctaContaMNTrans').blur(function() {
			if(esTab){
				maestroCuentasDescripcion(this.id, 'desripcionCtaContableMN');
			}
		});
		
		$('#ctaContaMETrans').blur(function() {
			if(esTab){
				maestroCuentasDescripcion(this.id, 'desripcionCtaContableME');
			}
		});
		
		$('#agrega').click(function() {		
			$('#tipoTransaccion').val(Enum_Tran_CatCajerosATM.agregar);	
			$('#tipoActualizacion').val(Enum_Tran_CatCajerosATM.agregar);
		});
		$('#modifica').click(function() {		
			$('#tipoTransaccion').val(Enum_Tran_CatCajerosATM.modificar);
			$('#tipoActualizacion').val(Enum_Tran_CatCajerosATM.agregar);					
		});
		$('#cancela').click(function() {		
			$('#tipoTransaccion').val(Enum_Tran_CatCajerosATM.cancelar);		
			$('#tipoActualizacion').val(Enum_Act_CatCajerosATM.actualizarStatus);
		});
		
		$('#estadoID').bind('keyup',function(e){
		lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
	});

	$('#longitud').blur(function(){
		console.log('ms');
		var punto = $('#longitud').val().indexOf(".");
		var numCar = $('#longitud').val().length;
		if(punto > 0 && ((punto+1) < numCar) ){
			$('#longitud').val($('#longitud').val()+padCero.substring(numCar,11));
		}
	});
	
	$('#latitud').blur(function(){
		var punto = $('#latitud').val().indexOf(".");
		var numCar = $('#latitud').val().length;
		if(punto > 0 && ((punto+1) < numCar) ){
			$('#latitud').val($('#latitud').val()+padCero.substring($('#latitud').val().length,10));
		}
	});
	
	$('#estadoID').blur(function() {
		consultaEstado(this.id);
	});
	$('#municipioID').blur(function() {
  		consultaMunicipio(this.id);
	});
	$('#localidadID').blur(function() {
		consultaLocalidad(this.id);
	});
	$('#coloniaID').blur(function() {
		consultaColonia(this.id);
	});
	
	$('#municipioID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";
		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		
		lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});
	
	$('#localidadID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "nombreLocalidad";
		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#localidadID').val();
		
		lista('localidadID', '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
	});
	
	$('#coloniaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "localidadID";
		camposLista[3] = "asentamiento";
		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#localidadID').val();
		parametrosLista[3] = $('#coloniaID').val();
		
		lista('coloniaID', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
	});

	
	$('#calle').blur(function () {
		generaDireccion();	
	});
	$('#numero').blur(function () {
		generaDireccion();	
	});
	$('#numInterior').blur(function () {
		generaDireccion();	
	});
		
	$('#formaGenerica').validate({			
		rules: {
			cajeroID: {
				required: true,					
			},
			numCajeroPROSA:{
				required: true
			},
			sucursalID:{
				required: true,
			},
			usuarioID:{
				required: true,
			},
			ubicacion:{
				required: true,
			},
			ctaContableMN:{
				required: true,
			},
			ctaContableME:{
				required: true,
			},
			ctaContaMNTrans:{
				required: true,				
			},
			ctaContaMETrans:{
				required: true,
			},
			estadoID: {
				required: true
			},
			municipioID: {
				required: true
			}, 
			latitud:{
				required: true,
				digito: latitud,
				maxlength: 10,
			},
			longitud:{
				required: true,
				digito: longitud,
				maxlength: 11,
			},
			estadoID:{
				required: true
			},
			municipioID:{
				required: true
			},
			localidadID:{
				required : function() {return $('#calle').val() != '' && $('#coloniaID').val() == ''? true : false;}
			},
			coloniaID:{
				required : function() {return $('#calle').val() != '' && $('#localidadID').val() == ''? true : false;}
			},
			calle:{
				required : function() {return $('#numero').val() != '' || $('#numInterior').val() }
			},
			numero:{
				required : function() {return $('#calle').val() != '' || $('#numInterior').val() }
			}
		},		
		messages: {
			cajeroID: {
				required: 'Especifiar el Número de Cajero'
			},
			numCajeroPROSA:{
				required: 'Especificar el Número de Cajero PROSA'
			},
			sucursalID:{
				required: 'Especificar el Número de Sucursal',
			},
			usuarioID:{
				required: 'Especificar el Número de Usuario',
			},	
			ubicacion:{
				required: 'Especificar la Ubicación',
			},
			ctaContableMN:{
				required: 'Especifiar el Campo de Cuenta Contable',
			},
			ctaContableME:{
				required: 'Especificar el Campo de Cuenta Contable',
			},
			ctaContaMNTrans:{
				required: 'Especificar el Campo de Cuenta Contable de Efectivo',
			},	
			ctaContaMETrans:{
				required: 'Especificar el Campo de Cuenta Contable de Efectivo',
			},
			estadoID: {
				required: 'Especificar el Estado'
			},
			municipioID: {
				required: 'Especificar el Municipio'
			},
			localidadID:{
				required : 'Especificar la Localidad'
			},
			coloniaID:{
				required : 'Especificar la Colonia'
			},
			calle:{
				required : 'Especificar la Calle '
			},
			numero:{
				required : 'Especificar el Numero'
			},
			latitud:{
				required: 'Especifique la Latitud del Cajero',
				digito: 'Ingrese una Latitud correcta',
				maxlength: 'Se requieren 10 caracteres',
			},
			longitud:{
				required: 'Especifique la Longitud del Cajero',
				digito: 'Ingrese una Longitud correcta',
				maxlength: 'Se requieren 11 caracteres',
			},
			cp:{
				required: 'Espacifique el código postal del Cajero'
			},
			tipoCajeroID:{
				required: 'Especifique el tipo de Cajero'
			}
		}		
	});
		

	jQuery.validator.addMethod("digito", function(value, element) {
		  return this.optional(element) || /^[-]?\d*\.\d+$/.test(value);
	}, "Ingrese un valor correcto");
	
	
	function generaDireccion() {
		var direcCompleta = '';
		var estado = $('#nombreEstado').val();
		var municipio = $('#nombreMuni').val();
		var localidad = $('#nombrelocalidad').val();
		var colonia = $('#nombreColonia').val();
		var calle = $('#calle').val();
		var numero = $('#numero').val();
		var numInt = $('#numInterior').val();
		if (estado != ''){
			direcCompleta = estado;
		}
		if (municipio != ''){
			direcCompleta = municipio + ', ' + estado;
		}
		if (localidad != ''){
			direcCompleta = localidad + ', ' + municipio + ', ' + estado;
		}else {
			direcCompleta = municipio + ', ' + estado;
		}
		if (colonia != ''){
			direcCompleta = colonia + ', ' + direcCompleta;
		}else{
			direcCompleta = direcCompleta;
		}
		if (calle != ''){
			//direcCompleta = calle +', '+ colonia + ', ' + localidad + ', ' + municipio + ', ' + estado;
			direcCompleta = calle +', '+ direcCompleta;
		}
		if (numero != ''){
			direcCompleta = calle +' No. '+ numero;
			if (colonia != '') {
				direcCompleta = calle +' No. '+ numero + ', '+ colonia;
			}else {
				direcCompleta = calle +' No. '+ numero;
			}
			if (localidad != '') {
				direcCompleta = direcCompleta + ', ' + localidad;
			}else {
				direcCompleta = direcCompleta;
			}
			direcCompleta = direcCompleta + ', '+ municipio +', '+ estado;
		}
		if (numInt != ''){
			direcCompleta = calle +' No. '+ numero+ ' No.INT. '+numInt;
			if (colonia != '') {
				direcCompleta = direcCompleta+ ', '+ colonia;
			}else {
				direcCompleta = direcCompleta;
			}
			if (localidad != '') {
				direcCompleta = direcCompleta + ', ' + localidad;
			}else {
				direcCompleta = direcCompleta;
			}
			direcCompleta = direcCompleta + ', '+ municipio +', '+ estado;
		}
		$('#ubicacion').val(direcCompleta);
	}
		
		function consultaCajero(idCajero){
			var jqCajero=eval("'#"+idCajero+"'");
			var numCajero=$(jqCajero).val();
			setTimeout("$('#cajaLista').hide();",200);
			if(numCajero != '' && esTab == true){ //numero de cajero puede que no sea un numero
				var cajeroBeanCon= {
							'cajeroID':numCajero			
				};
				catCajerosATMServicio.consulta(Enum_Con_CatCajerosATM.consultaPrincipal,cajeroBeanCon,function(cajero){
					if(cajero!=null){										
						dwr.util.setValues(cajero);	
						$('#tipoCajeroID').val(cajero.tipoCajeroID);
						consultaSucursal('sucursalID');
						validaUsuario('usuarioID');
						$('#saldoMN').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						$('#saldoME').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						esTab = true;
						consultaEstadoInt('estadoID');
						consultaMunicipioInt('municipioID');
						if (cajero.localidadID != 0 ) {
							consultaLocalidadInt('localidadID');
						}else {
							$('#localidadID').val('');
						}
						if (cajero.coloniaID != 0 ) {
							consultaColoniaInt('coloniaID');
						}else {
							$('#coloniaID').val('');
						}
						
						maestroCuentasDescripcion('ctaContableMN','descripcionCtaContaMN');
						maestroCuentasDescripcion('ctaContableME','descripcionCtaContaME');
						maestroCuentasDescripcion('ctaContaMNTrans','desripcionCtaContableMN');
						maestroCuentasDescripcion('ctaContaMETrans','desripcionCtaContableME');
						if($('#estatus').val()=='A'){					
							$('#estatus').val('ACTIVO');
							habilitaBoton('cancela', 'submit');
							habilitaBoton('modifica', 'submit');
						}else if($('#estatus').val()=='I'){						
							$('#estatus').val('INACTIVO');		
							deshabilitaBoton('cancela', 'submit');
							deshabilitaBoton('modifica', 'submit');
						}																	
						deshabilitaBoton('agrega', 'submit');
					}else{				
						habilitaBoton('agrega', 'submit');
						deshabilitaBoton('cancela', 'submit');
						deshabilitaBoton('modifica', 'submit');						
						$('#usuarioID').val('');							
						$('#usuario').val("");
						$('#sucursalID').val('');							
						$('#nombreSucursal').val("");
						$('#saldoMN').val('0.00');
						$('#saldoME').val('0.00');	
						$('#ubicacion').val("");
						$('#ctaContableMN').val('');							
						$('#ctaContableME').val("");
						$('#ctaContaMNTrans').val("");
						$('#ctaContaMETrans').val("");		
						$('#descripcionCtaContaMN').val('');							
						$('#descripcionCtaContaME').val("");
						$('#desripcionCtaContableMN').val("");
						$('#desripcionCtaContableME').val("");
						$('#estadoID').val("");
						$('#municipioID').val("");
						$('#localidadID').val("");
						$('#coloniaID').val("");
						$('#nombreEstado').val("");
						$('#nombreMuni').val("");
						$('#nombrelocalidad').val("");
						$('#nombreColonia').val("");
						$('#calle').val("");
						$('#numero').val("");
						$('#cp').val("");
						$('#numInterior').val("");
						$('#tipoCajeroID').val("");
						$('#numCajeroPROSA').val("");
						$('#estatus').val('ACTIVO');
					}			
				});		
			}	
		}
		
		function consultaSucursal(idControl) {	
			var jqSucursal = eval("'#" + idControl + "'");
			var numSucursal = $(jqSucursal).val();	
			var conSucursal=2;
			setTimeout("$('#cajaLista').hide();", 200);
			if(numSucursal != '' && !isNaN(numSucursal)){
				sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
					if(sucursal!=null){					
						$('#nombreSucursal').val(sucursal.nombreSucurs);						
					}else{
						mensajeSis("No Existe la Sucursal");
						$(jqSucursal).focus();
						$('#sucursalID').val('');							
						$('#nombreSucursal').val("");
					}    						
				});
			}
		}

		function validaUsuario(control) {	
			var jqUsuario = eval("'#" + control + "'");
			var numUsuario = $(jqUsuario).val();			
			setTimeout("$('#cajaLista').hide();", 200);		
			if(numUsuario != '' && !isNaN(numUsuario)){		
				var usuarioBeanCon = {
						'usuarioID':numUsuario 
				};									
				usuarioServicio.consulta(1,usuarioBeanCon,function(usuario) {
				if(usuario!=null){			
					$('#usuario').val(usuario.nombreCompleto);						
					$('#sucursalID').val(usuario.sucursalUsuario);					
					consultaSucursal('sucursalID');
					//$('#ubicacion').focus();
				}else{
					mensajeSis("el usuario no existe");
					$(jqUsuario)-focus();
					$('#usuarioID').val("");
					$('#usuario').val("");
				}
				});
			}	
		}
		
		function listaMaestroCuentas(idControl){
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
				if('ctaContableMN'==idControl){								
					$('#descripcionCtaContaMN').val('');
					$(jqcontrol).val('');
				}else if('ctaContableME'==idControl){								
					$('#descripcionCtaContaME').val('');
					$(jqcontrol).val('');
				}else if('ctaContaMNTrans'==idControl){								
					$('#desripcionCtaContableMN').val('');
					$(jqcontrol).val('');
				}else if('ctaContaMETrans'==idControl){								
					$('#desripcionCtaContableME').val('');
					$(jqcontrol).val('');
				}
			}
		 }
		
		function maestroCuentasDescripcion(idControl,descripcionCta) {
			var jqCuentaContable = eval("'#" + idControl + "'");	
			var numCta = $(jqCuentaContable).val();
			var jdDescripvionCta =eval("'#" + descripcionCta + "'");			
			var tipConForanea = 2;			
			var ctaContableBeanCon = {
			  'cuentaCompleta':numCta
			};
			setTimeout("$('#cajaLista').hide();", 200);			
			if (numCta != '' && !isNaN(numCta)) {
				//if(numCta.length >= 10){
					cuentasContablesServicio.consulta(tipConForanea,ctaContableBeanCon,function(ctaConta){
						if (ctaConta != null) {
							if(ctaConta.grupo != "E"){
								$(jdDescripvionCta).val(ctaConta.descripcion);
							} else{
								mensajeSis("Solo Cuentas Contables De Detalle");
								$(jqCuentaContable).val("");
								$(jqCuentaContable).focus();
								$(jdDescripvionCta).val("");						
							}
						}else {
							mensajeSis("La Cuenta Contable no existe.");
							$(jqCuentaContable).val("");
							$(jqCuentaContable).focus();
							$(jdDescripvionCta).val("");
						}
					});
				//s}
			}
		}
	
	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numEstado != '' && !isNaN(numEstado) && esTab){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
				if(estado!=null){
					$('#nombreEstado').val(estado.nombre);
				}else{
					mensajeSis("No Existe el Estado");
					$('#nombreEstado').val("");
					$('#estadoID').val("");
					$('#estadoID').focus();
				}
				generaDireccion();
			});
		}else {
			if (numEstado == '') {
				$('#nombreEstado').val("");
				$('#municipioID').val("");
				$('#nombreMuni').val("");
				$('#localidadID').val("");
				$('#nombrelocalidad').val("");
				$('#coloniaID').val("");
				$('#nombreColonia').val("");
			}
		}
		generaDireccion();
	}
	
	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();
		var numEstado =  $('#estadoID').val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMunicipio != '' && !isNaN(numMunicipio) && esTab){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
				if(municipio!=null){
					$('#nombreMuni').val(municipio.nombre);
				}else{
					mensajeSis("No Existe el Municipio");
					$('#nombreMuni').val("");
					$('#municipioID').val("");
					$('#municipioID').focus();
				}
				generaDireccion();
			});
		}else {
			if (numMunicipio == '') {
				$('#nombreMuni').val("");
				$('#localidadID').val("");
				$('#nombrelocalidad').val("");
				$('#coloniaID').val("");
				$('#nombreColonia').val("");
			}
		}
		generaDireccion();
	}
	
	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#estadoID').val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numLocalidad != '' && numLocalidad != 0 && !isNaN(numLocalidad) && esTab){
			localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
				if(localidad!=null){
					$('#nombrelocalidad').val(localidad.nombreLocalidad);
				}else{
					mensajeSis("No Existe la Localidad");
					$('#nombrelocalidad').val("");
					$('#localidadID').val("");
					$('#localidadID').focus();
					$('#localidadID').select();
				}
				generaDireccion();
			});
		}else {
			if (numLocalidad == '') {
				$('#nombrelocalidad').val("");
			}
		}
		generaDireccion();
	}
	
	function consultaColonia(idControl) {
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();
		var numEstado =  $('#estadoID').val();
		var numMunicipio =	$('#municipioID').val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numColonia != '' && numColonia != 0 && !isNaN(numColonia) && esTab){
			coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
				if(colonia!=null){
					$('#nombreColonia').val(colonia.asentamiento);
					$('#cp').val(colonia.codigoPostal);
				}else{
					mensajeSis("No Existe la Colonia");
					$('#nombreColonia').val("");
					$('#coloniaID').val("");
					$('#coloniaID').focus();
				}
				generaDireccion();
			});
		}else {
			if (numColonia == '') {
				$('#nombreColonia').val("");
			}
		}
		generaDireccion();
	}
// ------------------------------- ------------------------------------------------------------------------

	function consultaEstadoInt(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado) && esTab){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
				if(estado!=null){							
					$('#nombreEstado').val(estado.nombre);
				}else{
					mensajeSis("No Existe el Estado");
					$('#nombreEstado').val("");
					$('#estadoID').val("");
					$('#estadoID').focus();
					$('#estadoID').select();
				}    	 						
			});
		}
	}	
	
	function consultaMunicipioInt(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMunicipio != '' && !isNaN(numMunicipio) && esTab){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
				if(municipio!=null){							
					$('#nombreMuni').val(municipio.nombre);
				}else{
					mensajeSis("No Existe el Municipio");
					$('#nombreMuni').val("");
					$('#municipioID').val("");
					$('#municipioID').focus();
					$('#municipioID').select();
				}    	 						
			});
		}
	}	
	
	function consultaLocalidadInt(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#estadoID').val();				
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numLocalidad != '' && !isNaN(numLocalidad) && esTab){
			localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
				if(localidad!=null){							
					$('#nombrelocalidad').val(localidad.nombreLocalidad);
				}else{
					mensajeSis("No Existe la Localidad");
					$('#nombrelocalidad').val("");
					$('#localidadID').val("");
					$('#localidadID').focus();
					$('#localidadID').select();
				}    	 						
			});
		}
	}

	function consultaColoniaInt(idControl) {
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();		
		var numEstado =  $('#estadoID').val();	
		var numMunicipio =	$('#municipioID').val();
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numColonia != '' && !isNaN(numColonia) && esTab){
			coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
				if(colonia!=null){							
					$('#nombreColonia').val(colonia.asentamiento);
				}else{
					mensajeSis("No Existe la Colonia");
					$('#nombreColonia').val("");
					$('#coloniaID').val("");
					$('#coloniaID').focus();
					$('#coloniaID').select();
				}    	 						
			});
		}
	}
}); //FIN DE DOCUMENT.READY

function FuncionExitosaATM(){
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('agrega','submit');
	deshabilitaBoton('modifica','submit');
	deshabilitaBoton('cancela','submit');
	$('#usuarioID').val('');
	$('#usuario').val('');
	$('#sucursalID').val('');
	$('#nombreSucursal').val('');
	$('#saldoMN').val('');
	$('#saldoME').val('');
	$('#ubicacion').val('');
	$('#ctaContableMN').val('');
	$('#ctaContableME').val('');
	$('#ctaContaMNTrans').val('');
	$('#ctaContaMETrans').val('');
	$('#descripcionCtaContaMN').val('');
	$('#descripcionCtaContaME').val('');
	$('#desripcionCtaContableMN').val('');
	$('#desripcionCtaContableME').val('');
	$('#estadoID').val('');
	$('#nombreEstado').val('');	
	$('#municipioID').val('');
	$('#nombreMuni').val('');
	$('#localidadID').val('');
	$('#nombrelocalidad').val('');
	$('#coloniaID').val('');
	$('#nombreColonia').val('');
	$('#calle').val('');
	$('#numero').val('');
	$('#numInterior').val('');
	$('#estatus').val('');
	$('#cp').val("");
	$('#tipoCajeroID').val("");
	$('#nomenclaturaCR').val('');
	$('#numCajeroPROSA').val('');

}

	function FuncionErrorExitosaATM(){
		agregaFormatoControles('formaGenerica');
	}

	function concatenaNomenclatura(campoID,valor){
		var campo=eval("'#"+campoID+"'");
		$(campo).val(valor);
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
	
	
	function llenarComboTipoCajero(){
		dwr.util.removeAllOptions('tipoCajeroID');
		catCajerosATMServicio.listaTiposCajerosATM(1,function(tiposCajeroID){
			dwr.util.addOptions('tipoCajeroID', {'':'SELECCIONAR'});
			dwr.util.addOptions('tipoCajeroID', tiposCajeroID, 'tipoCajeroID', 'descripcion');
		});
	}
