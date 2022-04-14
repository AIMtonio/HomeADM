var caracterMinimo = 0;
var caracterMayus = 0;
var caracterMinus = 0;
var caracterNumerico = 0;
var caracterEspecial = 0;
var reqCaracterMayus = "";
var reqCaracterMinus  = "";
var reqCaracterNumerico = "";
var reqCaracterEspecial = "";
var habilitaConfPass  = "";


$(document).ready(function() {
	var parametroBean = consultaParametrosSession();

	$('#usuarioID').focus();
	esTab = false;

	inicializaForma('formaGenerica','usuarioID');
	
	//Definicion de Constantes y Enums
	var catTipoTransaccionUsuario = {
  		'agrega':'1',
  		'modifica':'2',
	};
	var prefijo='';
	var mostrarPrefijo='';
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	paramConfigContrasenia();
	valdidaReglaPasword();
	deshabilitaBoton('modifica', 'submit');

	deshabilitaBoton('agrega', 'submit');

	$("#fechaExpedicion").change(function(){
		this.focus();
	});
	
	$("#fechaVencimiento").change(function(){
		this.focus();
	});
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','usuarioID');
		}
    });
	$('#lblImei').hide(200);
	$('#imei').hide(200);
	$('#imei').val('');
	
	// Se carga el prefijo de la Compañia
	conPrefijo();

	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#rutaReportes').val(parametroBean.rutaReportes);

	$('#rutaImgReportes').val(parametroBean.rutaImgReportes);

	$('#logoCtePantalla').val(parametroBean.logoCtePantalla);

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionUsuario.agrega);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionUsuario.modifica);
	});

	$('#usuarioID').bind('keyup',function(e){
		lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});

	$('#usuarioID').blur(function() {
  		validaUsuario(this);
	});

	$('#clave').blur(function (){
		var claveUsuario=$('#clave').val();
		var tmpPrefijo='';
		if(mostrarPrefijo=='S'){
			tmpPrefijo=claveUsuario.substring(0, 3);
			if(tmpPrefijo!=prefijo){
				$('#clave').val(prefijo+claveUsuario);
			}
		}
	});

	$('#sucursalUsuario').bind('keyup',function(e){
		lista('sucursalUsuario', '1', '1', 'nombreSucurs',$('#sucursalUsuario').val(), 'listaSucursales.htm');
	});

	$('#sucursalUsuario').blur(function() {
  		consultaSucursal(this.id);
	});

	$('#rolID').bind('keyup',function(e){
		lista('rolID', '1', '1', 'nombreRol',$('#rolID').val(), 'listaRoles.htm');
	});

	$('#rolID').blur(function() {
  		consultaRoles(this.id);
	});

	$('#clavePuestoID').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#clavePuestoID').val();
			listaAlfanumerica('clavePuestoID', '1', '1',camposLista, parametrosLista,'listaPuestos.htm');
		}
	});

	$('#clavePuestoID').blur(function() {
  		consultaPuesto(this.id);
	});

	$('#realizaConsultasCCSI').change(function(){
		if($('#realizaConsultasCCSI').is(':checked')){
			$('#usuarioCirculo').val('');
			$('#contrasenaCirculo').val('');
			$('#trUsuarioCirculo').show(200);
		}
	});

	$('#realizaConsultasCCNO').change(function(){
		if($('#realizaConsultasCCNO').is(':checked')){
			$('#trUsuarioCirculo').hide(200);
		}
	});

	$('#realizaConsultasBCSI').change(function(){
		if($('#realizaConsultasBCSI').is(':checked')){
			$('#usuarioBuroCredito').val('');
			$('#contrasenaBuroCredito').val('');
			$('#trUsuarioBuro').show(200);
		}
	});

	$('#realizaConsultasBCNO').change(function(){
		if($('#realizaConsultasBCNO').is(':checked')){
			$('#trUsuarioBuro').hide(200);
		}
	});
	$('#usaAplicacionNO').change(function(){
		if($('#usaAplicacionNO').is(':checked')){
			$('#lblImei').hide(200);
			$('#imei').hide(200);
			$('#imei').val('');
		}
	});
	$('#usaAplicacionSI').change(function(){
		if($('#usaAplicacionSI').is(':checked')){
			$('#imei').val('');
			$('#lblImei').show(200);
			$('#imei').show(200);
		}
	});
 	$('#imei').change(function(){
 		
 	});
	$('#fechaExpedicion').change(function() {
		var parametroBean = consultaParametrosSession();
		var Zfecha=  parametroBean.fechaSucursal;
		
		var Xfecha= $('#fechaExpedicion').val();
		var Yfecha= $('#fechaVencimiento').val();
		if(Yfecha!=''){
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Expedición es Mayor a la Fecha de Vencimiento.")	;
				$('#fecExfechaExpedicionIden').val('');
			}
		}else{
			if ( mayor(Xfecha, Zfecha) )
			{
				mensajeSis("La Fecha Capturada es Mayor a la de Hoy.")	;
				$('#fechaExpedicion').val('');
			
			}
		}
	});

	$('#fechaVencimiento').change(function() {
		var Xfecha= $('#fechaExpedicion').val();
		var Yfecha= $('#fechaVencimiento').val();
		if(Yfecha!=''){
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Expedición es Mayor a la Fecha de Vencimiento.")	;
				$('#fechaVencimiento').val('');
			}
		}
	});
	
	$('#empleadoID').bind('keyup',function(e){
		 var camposLista = new Array(); var
		 parametrosLista = new Array(); camposLista[0] = "nombreCompleto";
		 parametrosLista[0] = $('#empleadoID').val();
		 listaAlfanumerica('empleadoID', '2', '1', camposLista, parametrosLista, 'listaEmpleados.htm'); 
	});

	$('#empleadoID').blur(function() {
		if(esTab){
			consultaEmpleado(this.id);
		}
	});

	$.validator.addMethod("character", function(value, element) {
  				return this.optional(element) ||/^[a-z0-9]+$/i.test(value);
	}, "No acepta caracteres especiales.");

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			nombre: {
				required: true
			},
			clave: {
				required: true
			},
			correo: {
				required:  false,
				email: 	true
			},
			clavePuestoID: {
				required:  true,
			},
			sucursalUsuario: {
				required:  true,
			},
			rolID: {
				required:  true,
			},
			rfc: {
				maxlength: 13,
				minlength: function(){ return $('#rfc').val() != '' ? 13 : 0; }
			},
			curp : {
				maxlength : 18
			},
			direccionCompleta : {
				maxlength : 200
			},
			folioIdentificacion : {
				maxlength : 18
			},
			fechaExpedicion: {
				date : true
			},

			fechaVencimiento: {
				date : true
			},
			imei: {
				character: true,
				minlength : 1,
				maxlength : 32
			
			},
		},
		messages: {
			nombre: {
				required: 'Especificar Nombre'
			},
			clave: {
				required: 'Especificar Clave'
			},
			correo: {
				required: 	'Especifique un Correo',
				email: 		'Direccion Invalida'
			},
			clavePuestoID: {
				required: 'Especificar Puesto'
			},
			sucursalUsuario: {
				required: 'Especificar Sucursal'
			},
			rolID: {
				required: 'Especificar Rol'
			},
			rfc: {
				maxlength: 'Ingrese un RFC Válido',
				minlength: 'Ingrese un RFC Válido'
			},
			CURP : {
				maxlength : 'Máximo 18 caracteres'
			},
			direccionCompleta : {
				maxlength : 'Máximo 200 caracteres'
			},
			folioIdentificacion : {
				maxlength : 'Máximo 18 caracteres'
			},
			fechaExpedicion: {
				date : 'Fecha Incorrecta'
			},

			fechaVencimiento: {
				date : 'Fecha Incorrecta'
			},
			imei : {
				character : 'El campo no acepta caracteres especiales',
				minlength : 'Min 1 caracter.',
				maxlength : 'Máximo 32 caracteres.'

			}
			
		}
	});

	agregaFormatoControles('formaGenerica');
	//------------ Validaciones de Controles -------------------------------------

	function validaUsuario(control) {
		var numUsuario = $('#usuarioID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
			if(numUsuario=='0'){
				$('#clave').attr('readonly',false);
				$('#contrasenia').attr("readOnly",false);
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica', 'usuarioID');
				conPrefijo();
				$('#contrasenia').val("");
				$('#trUsuarioCirculo').hide(200);
				$('#trUsuarioBuro').hide(200);
				habilitaCamposEmpleado('S');
				$('#accederAutorizar').val('');
				$('#lblImei').hide(200);
				$('#imei').hide(200);
				$('#imei').val('');
			} else {
				$('#clave').attr('readonly',true);
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var usuarioBeanCon = {
						'usuarioID':numUsuario
				};
				usuarioServicio.consulta(1,usuarioBeanCon,{ async: false, callback:function(usuario) {
					if(usuario!=null){
						dwr.util.setValues(usuario);
						var clave=usuario.clave.substring(0, 3);
						conPrefijo();
						if(usuario.realizaConsultasCC == 'S'){
							$('#trUsuarioCirculo').show(300);
						}else if(usuario.realizaConsultasCC == 'N'){
							$('#usuarioCirculo').val('');
							$('#contrasenaCirculo').val('');
							$('#trUsuarioCirculo').hide(300);
						}

						if(usuario.realizaConsultasBC == 'S'){
							$('#trUsuarioBuro').show(300);
						}else if(usuario.realizaConsultaBC == 'N'){
							$('#usuarioBuroCredito').val('');
							$('#contrasenaBuroCredito').val('');
							$('#trUsuarioBuro').hide(300);
						}

						if(usuario.fechaExpedicion == '1900-01-01'){
							$('#fechaExpedicion').val("");
						}

						if(usuario.fechaVencimiento== '1900-01-01'){
							$('#fechaVencimiento').val("");
						}
						if(usuario.usaAplicacion == 'S'){
							$('#imei').val('');
							$('#lblImei').show(200);
							$('#imei').show(200);

						}else if(usuario.usaAplicacion == 'N'){
								$('#lblImei').hide(200);
								$('#imei').hide(200);
								$('#imei').val('');
						}
						if(usuario.imei != ""){
							console.log("imei:"+usuario.imei);
							$("#imei").val(usuario.imei);
						}

						switch(usuario.estatus){
							case "A":
								$('#estatus').val("ACTIVO");
								break;
							case "B":
								$('#estatus').val("BLOQUEADO");
								break;
							case "C":
								$('#estatus').val("CANCELADO");
								break;
							default:
								$('#estatus').val(usuario.estatus);
						}
						$('#contrasenia').attr("readOnly",true);
						esTab=true;
						$('#sucursalUsuario').val(usuario.sucursalUsuario);
						consultaSucursal('sucursalUsuario');
						$('#rolID').val(usuario.rolID);
						consultaRoles('rolID');
						consultaPuesto('clavePuestoID');
						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('modifica', 'submit');

						if(usuario.empleadoID > 0){
							deshabilitaCamposEmpleado('N');
						}else{
							$('#empleadoID').val('');
							habilitaCamposEmpleado('N');
						}
						if(usuario.notificaCierre == 'S'){
							$('#notificaCierreSI').attr("checked",true);
							$('#notificaCierreNO').attr("checked",false);
						}else{
							$('#notificaCierreNO').attr("checked",true);
							$('#notificaCierreSI').attr("checked",false);
						}
						
						esTab=false;						
					}else{
						inicializaForma('formaGenerica', 'usuarioID');
						$('#contrasenia').val("");
						$('#trUsuarioCirculo').hide(200);
						$('#trUsuarioBuro').hide(200);
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						$('#usuarioID').select();
						$('#usuarioID').focus();
						mensajeSis("No Existe el Usuario");
					}
				}});
			}
		}
	}

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
				if(sucursal!=null){
					$('#nomSucursal').val(sucursal.nombreSucurs);
				}else{
					$(jqSucursal).focus();
					$(jqSucursal).val("");
					$('#nomSucursal').val("");
					mensajeSis("No Existe la Sucursal");
				}
			});
		}
	}

	function consultaRoles(idControl) {
		var jqRol = eval("'#" + idControl + "'");
		var numRol = $(jqRol).val();
		var conRol=2;
		var rolesBeanCon = {
				'rolID':numRol
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numRol != '' && !isNaN(numRol) && esTab){
			rolesServicio.consultaRoles(conRol,rolesBeanCon,function(roles) {
				if(roles!=null){
					$('#nombreRol').val(roles.nombreRol);
				}else{
					$(jqRol).focus();
					$(jqRol).val("");
					$('#nombreRol').val("");
					mensajeSis("El rol indicado no existe");
				}
			});
		}
	}

	// ////////////////funcion consultar puesto//////////////////
	function consultaPuesto(idControl) {
		var jqPuesto = eval("'#" + idControl + "'");
		var numPuesto = $(jqPuesto).val();
		var conPuesto=1;
		setTimeout("$('#cajaLista').hide();", 200);
		var PuestoBeanCon = {
				'clavePuestoID' : numPuesto
		};
		if (numPuesto != '' && esTab) {
			puestosServicio.consulta(conPuesto,PuestoBeanCon, function(puestos) {
				if (puestos != null) {
					$('#descripcionPuesto').val(puestos.descripcion);
				} else {
					$(jqPuesto).focus();
					$(jqPuesto).val("");
					$('#descripcionPuesto').val("");
					mensajeSis("No Existe el Puesto");
				}
			});
		}
	}

	function conPrefijo(){
		var claveUsuario=$('#clave').val();
		var tmpPrefijo='';
		var parametrosSisCon ={
	 		 	'empresaID' : 1
		};
		parametrosSisServicio.consulta(1,parametrosSisCon, function(varParamSistema) {
			if (varParamSistema != null) {
				mostrarPrefijo=varParamSistema.mostrarPrefijo;
				if(mostrarPrefijo=='S' && claveUsuario!='' && claveUsuario!='0'){
					tmpPrefijo=claveUsuario.substring(0, 3);
				}
				companiasServicio.consulta(1, function(companiaBean) {
					if(companiaBean!=null){
						if(varParamSistema.mostrarPrefijo=='S'){
							tmpPrefijo=claveUsuario.substring(0, companiaBean.prefijo.length);
							if(tmpPrefijo==companiaBean.prefijo){
								$('#clave').val(claveUsuario);
							}
							else{
								$('#clave').val(companiaBean.prefijo);
								prefijo=companiaBean.prefijo;
							}
						}
					}
				});

				/** Notificaciones -----------------------*/
				if(varParamSistema.validarVigDomi == 'S'){
					mostrarElementoPorClase('validarVigDomi',true);
				} else {
					mostrarElementoPorClase('validarVigDomi',false);
				}
			}

		});


	}

	// FUNCION CONSULTAR EMPLEADO
	function consultaEmpleado(idControl) {
		var jqEmpleado = eval("'#" + idControl + "'");
		var numEmpleado = $(jqEmpleado).val();
		var numCon = 5;
		setTimeout("$('#cajaLista').hide();", 200);
		var EmpleadoBeanCon = {
			'empleadoID' : numEmpleado
		};
		
		if (numEmpleado != '' && !isNaN(numEmpleado) && numEmpleado > 0) {
			empleadosServicio.consulta(numCon,EmpleadoBeanCon, { async: false, callback: function(empleados) {
				if(empleados != null) {
					if(empleados.estatus == 'A'){	
						deshabilitaCamposEmpleado('S');
						$('#nombre').val(empleados.primerNombre);
						$('#apPaterno').val(empleados.apellidoPat);
						$('#apMaterno').val(empleados.apellidoMat);
						$('#rfc').val(empleados.RFC);
						$('#curp').val(empleados.CURP);
						$('#sucursalUsuario').val(empleados.sucursalID);
						$('#clavePuestoID').val(empleados.clavePuestoID);	
						consultaSucursal('sucursalUsuario');
						consultaPuesto('clavePuestoID');
						$('#clave').focus();
					}else{
						habilitaCamposEmpleado('S');
						mensajeSis("El Empleado no esta Activo.");
						$(jqEmpleado).focus();
						$(jqEmpleado).val("");						
					}					
				}else{
					habilitaCamposEmpleado('S');
					mensajeSis("No Existe el Empleado");
					$(jqEmpleado).focus();
					$(jqEmpleado).val("");
				}
			}});
		}else if(numEmpleado != '' && isNaN(numEmpleado)){
			habilitaCamposEmpleado('S');
			mensajeSis("No Existe el Empleado");
			$(jqEmpleado).focus();		
			$(jqEmpleado).val("");	
		}else if(numEmpleado == 0 && numEmpleado != ''){
			habilitaCamposEmpleado('S');
			$(jqEmpleado).val("");	
			$('#nombre').focus();	
		}
	}

});
function ayudaValidaVig() {
	$.blockUI({
	message : $('#ayudaValVig'),
	css : {
	top : ($(window).height() - 400) / 2 + 'px',
	left : ($(window).width() - 400) / 2 + 'px',
	width : '400px'
	}
	});
	$('.blockOverlay').attr('title', 'Clic para Desbloquear').click($.unblockUI);
}

function mayor(fecha, fecha2){
	
	var xMes=fecha.substring(5, 7);
	var xDia=fecha.substring(8, 10);
	var xAnio=fecha.substring(0,4);

	var yMes=fecha2.substring(5, 7);
	var yDia=fecha2.substring(8, 10);
	var yAnio=fecha2.substring(0,4);



	if (xAnio > yAnio){
		return true;
	}else{
		if (xAnio == yAnio){
			if (xMes > yMes){
				return true;
			}
			if (xMes == yMes){
				if (xDia > yDia){
					return true;
				}else{
					return false;
				}
			}else{
				return false;
			}
		}else{
			return false ;
		}
	} 
}
function soloNumeros(valorEntrada){

	var expReg = /^[0-9]+$/;
	return valorEntrada.match(expReg);
}

//FUNCION DESHABILITA CAMPOS EMPLEADO
function deshabilitaCamposEmpleado(limpiaCampos){
	deshabilitaControl('nombre');
	deshabilitaControl('apPaterno');
	deshabilitaControl('apMaterno');
	deshabilitaControl('rfc');
	deshabilitaControl('curp');
	deshabilitaControl('sucursalUsuario');
	deshabilitaControl('clavePuestoID');

	if(limpiaCampos == 'S'){
		$('#nombre').val('');
		$('#apPaterno').val('');
		$('#apMaterno').val('');
		$('#rfc').val('');
		$('#curp').val('');
		$('#sucursalUsuario').val('');
		$('#clavePuestoID').val('');		
	}
}
//Solo permite introducir numeros.
function soloNumeros(e){
  var key = window.event ? e.which : e.keyCode;
  if (key < 48 || key > 57) {
    e.preventDefault();
  }
}

//FUNCION HABILITA CAMPOS EMPLEADO
function habilitaCamposEmpleado(limpiaCampos){
	habilitaControl('nombre');
	habilitaControl('apPaterno');
	habilitaControl('apMaterno');
	habilitaControl('rfc');
	habilitaControl('curp');
	habilitaControl('sucursalUsuario');
	habilitaControl('clavePuestoID');
	if(limpiaCampos == 'S'){
		$('#nombre').val('');
		$('#apPaterno').val('');
		$('#apMaterno').val('');
		$('#rfc').val('');
		$('#curp').val('');
		$('#sucursalUsuario').val('');
		$('#nomSucursal').val('');
		$('#clavePuestoID').val('');
		$('#descripcionPuesto').val('');		
	}
}

	//Consulta de parametros de configuracion de contraseña
	function paramConfigContrasenia() {
		var numEmpresaID = 1;
		var tipoCon = 23;
		var ParametrosSisBean = {
			'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean, { async: false, callback:function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				caracterMinimo = parametrosSisBean.caracterMinimo;
				caracterMayus = parametrosSisBean.caracterMayus;
				caracterMinus = parametrosSisBean.caracterMinus;
				caracterNumerico = parametrosSisBean.caracterNumerico;
				caracterEspecial = parametrosSisBean.caracterEspecial;
				reqCaracterMayus = parametrosSisBean.reqCaracterMayus;
				reqCaracterMinus = parametrosSisBean.reqCaracterMinus;
				reqCaracterNumerico = parametrosSisBean.reqCaracterNumerico;
				reqCaracterEspecial = parametrosSisBean.reqCaracterEspecial;
				habilitaConfPass = parametrosSisBean.habilitaConfPass;
			}
		}});
	}

	function valdidaReglaPasword(){
		var mensajeLabel = '';

		if(habilitaConfPass == "S"){
			mensajeLabel += 'Reglas para definir password: <br>&nbsp;&nbsp;&nbsp;1.-Longitud Mínima de ' + caracterMinimo + ' Caracteres.';

			if(reqCaracterMayus == 'S'){
				if(caracterMayus > 1){
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;2.-Debe contener al menos: ' + caracterMayus + ' Caracteres Alfabéticos Mayúsculas.');
				}else{
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;2.-Debe contener al menos: ' + caracterMayus + ' Caracter Alfabético Mayúsculas.');	
				}
			}

			if(reqCaracterMinus == 'S'){
				if(caracterMinus > 1){
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;3.-Debe contener al menos: ' + caracterMinus + ' Caracteres Alfabéticos Minúscula.');
				}else{
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;3.-Debe contener al menos: ' + caracterMinus + ' Caracter Alfabético Minúscula.');
				}
			}

			if(reqCaracterNumerico == 'S'){
				if(caracterNumerico > 1){
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;4.-Debe contener al menos: ' + caracterNumerico + ' Caracteres Numérico.');
				}else{
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;4.-Debe contener al menos: ' + caracterNumerico + ' Caracter Numérico.');
				}
			}

			if(reqCaracterEspecial == 'S'){
				if(caracterEspecial > 1) {
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;5.-Debe contener al menos: ' + caracterEspecial + ' Caracteres Especiales.');
				}else{
					mensajeLabel +=('<br>&nbsp;&nbsp;&nbsp;5.-Debe contener al menos: ' + caracterEspecial + ' Caracter Especial.');
				}
			}
		}else{
			mensajeLabel += 'Reglas para definir password: <br>&nbsp;&nbsp;&nbsp;1. Longitud Mínima de 6 caracteres.<br>&nbsp;&nbsp;&nbsp;2. Debe contener al menos: 1 Caracter Alfabético Mayúsculas, 1 Caracter Alfabético Minúscula,1 Número o Caracter Especial.';
		}
		
		$('#mensajeLabel').html(mensajeLabel);
	}	