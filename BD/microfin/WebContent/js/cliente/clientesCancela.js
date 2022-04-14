var varperfilCancelPROFUN =0;
var parametroBean = consultaParametrosSession();
var procedeSubmit = false;
var folioCancenacion = 0;
//Definicion de Constantes y Enums  
var catTipoTranClientesCancela = {
		'alta'				:	1,
		'actualiza'			:	2
};	

var catTipoActClientesCancela = {
		'autorizar'			:	1
};	

$(document).ready(function() {
	
	//  ----------- inicializacion de valores ------------------------------------------
	esTab = false;
	procedeSubmit = true;
	catTipoTranClientesCancela = {
			'alta'				:	1,
			'actualiza'			:	2
	};	
	catTipoActClientesCancela = {
			'autorizar'			:	1
	};	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	/* se manda a llamar a la funcion que inicializa el formulario de 
	 * cancelacion de socio*/
	inicializarFormularioCancelSocio();
	
	//-- Haciendo la transaccion
	$.validator.setDefaults({
	    submitHandler: function(event) {  
	    	if(procedeSubmit){
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteCancelaID','exitoFormularioCancelSocio','errorFormularioCancelSocio');
	    	}
	    }
	});
	
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	// -- EVENTOS ------------------------------------
	$('#clienteCancelaID').blur(function() {	
		if(esTab){
			validaSolicitudCancelacionSocio(this.id); 
		}		 		
	});
	
	$('#clienteCancelaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCompleto";
		camposLista[1] = "areaCancela";
		parametrosLista[0] = $('#clienteCancelaID').val();
		parametrosLista[1] = $('#areaCancela').val();
		lista('clienteCancelaID', '2', '1', camposLista, parametrosLista, 'listaClientesCancela.htm');
	});
	
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '9', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	/*
	$('#clienteID').bind('keyup',function(e){
		if($('#clienteID').val().length<3){		
			$('#cajaListaCte').hide();
		}
	});*/

	$('#buscarMiSuc').click(function(){
		listaCte('clienteID', '3', '25', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('clienteID', '3', '9', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#clienteID').blur(function() {		
		validaClienteSolCancela(this.id);		
	});
	
	$('#guardar').click(function(){		
		$('#tipoTransaccion').val(catTipoTranClientesCancela.alta);	
		confirmarGuardar();
	});	
	
	$('#autorizar').click(function(){		
		$('#tipoTransaccion').val(catTipoTranClientesCancela.actualiza);
		$('#tipoActualizacion').val(catTipoActClientesCancela.autorizar);
	});
	
	$('#aplicaSeguroSi').click(function(){		
		$('#aplicaSeguroSi').focus(); 
		$('#aplicaSeguroSi').attr("checked",true);
		$('#aplicaSeguroNo').attr("checked",false);
		$('#aplicaSeguro').val("S");
	});
		
	$('#aplicaSeguroNo').click(function(){		
		$('#aplicaSeguroSi').focus(); 
		$('#aplicaSeguroSi').attr("checked",false);
		$('#aplicaSeguroNo').attr("checked",true);
		$('#aplicaSeguro').val("N");
	});
	
	$('#impSolicitud').click(function(){	
		if($('#clienteCancelaID').asNumber()!=0){
			parametroBean = consultaParametrosSession();
			var tipoReporte			= 0;
			var nombreInstitucion	= parametroBean.nombreInstitucion;
			var varFechaSistema		= parametroBean.fechaSucursal;
			var sucursal			= parametroBean.sucursal;
			
			if($('#esMenorEdad').val()== "S"){
				tipoReporte			= 2;
				window.open('reporteSolicitudClientesMenCancela.htm?tipoReporte='+tipoReporte+'&nombreInstitucion='+nombreInstitucion+
						'&clienteID='+$('#clienteID').val()+'&fechaSistema='+varFechaSistema+'&sucursalID='+sucursal+
						'&clienteCancelaID='+$('#clienteCancelaID').val(),'_blank' );
			}else{
				 tipoReporte			= 1;
				window.open('reporteSolitudClientesCancela.htm?tipoReporte='+tipoReporte+'&nombreInstitucion='+nombreInstitucion+
						'&clienteID='+$('#clienteID').val()+'&fechaSistema='+varFechaSistema+'&sucursalID='+sucursal+
						'&clienteCancelaID='+$('#clienteCancelaID').val(),'_blank' );
			}
		}
	});
	
	
	$('#impPago').click(function(){		
		parametroBean = consultaParametrosSession();
		var nombreInstitucion	= parametroBean.nombreInstitucion;
		switch($('#areaCancela').val()){
			case "Soc": //cliente con estatus cancelado
				$('#ligaGenerarPago').attr('href','pagoSolitudClientesCancela.htm?tipoReporte=1&nombreInstitucion='+nombreInstitucion+
						'&clienteID='+$('#clienteID').val()+'&sucursalID='+parametroBean.sucursal+'&sucursalDes='+parametroBean.nombreSucursal+
						'&usuarioSesion='+parametroBean.nombreUsuario+'&clienteCancelaID='+$('#clienteCancelaID').val());	
				break;
			case "Cob": //cliente con estatus cancelado
				$('#ligaGenerarPago').attr('href','pagoSolitudCobClientesCancela.htm?tipoReporte=2&nombreInstitucion='+nombreInstitucion+
						'&clienteID='+$('#clienteID').val()+'&sucursalID='+parametroBean.sucursal+'&sucursalDes='+parametroBean.nombreSucursal+
						'&usuarioSesion='+parametroBean.nombreUsuario+'&clienteCancelaID='+$('#clienteCancelaID').val());
				break;
		}
	});
	
	$('#fechaDefuncion').change(function(){		
		parametroBean = consultaParametrosSession();
		var fechaAplic = parametroBean.fechaSucursal;
		var fechaFact  = $('#fechaDefuncion').val();				
		if(fechaFact==''){
			$('#fechaDefuncion').val(fechaAplic);
		}else{
			if(esFechaValida(fechaFact)){
				if(mayor(fechaFact,fechaAplic)){
					mensajeSis("La Fecha Capturada es Mayor a la Fecha del Sistema");
					$('#fechaDefuncion').val(parametroBean.fechaSucursal);
					regresarFoco('fechaDefuncion');				
				}else{
					if(!esTab){
						regresarFoco('fechaDefuncion');	
					}
				}
			}else{
				$('#fechaDefuncion').val(fechaAplic);
				regresarFoco('fechaDefuncion');	
			}
		}
	});

	//	------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			clienteCancelaID: {
				required: true
			},
			clienteID:{
				required:true
			},
			usuarioRegistra:{
				required:true
			},
			areaCancela:{
				required: true				
			},
			motivoActivaID:{
				required: true				
			},
			actaDefuncion:{
				required : function() {return $('#areaCancela').val() == 'Pro';}				
			},
			fechaDefuncion:{
				required : function() {return $('#areaCancela').val() == 'Pro';}
			}			
		},
		messages: {
			clienteCancelaID: {
				required: 'Especifique Folio de Solicitud.',
			},
			clienteID:{
				required: 'Especifique Número de Cliente.'
			},
			usuarioRegistra:{
				required: 'Especifique Usuario que Registra'
			},
			areaCancela:{
				required: 'Especifique Área que realiza la Solicitud'
			},
			motivoActivaID:{
				required: 'Especifique Motivo de Cancelación.'				
			},
			actaDefuncion:{
				required: 'Especifique Folio de Acta de Defunción.'				
			},
			fechaDefuncion:{
				required: 'Especifique Fecha de Defunción.'				
			}
		}		
	});
		
	
	//-- funciones -----------------------------------------------
	
	/* Funcion para validar si se trata de un folio nuevo o si se trata de una consulta 
	 * de un folio registrado.*/
	function validaSolicitudCancelacionSocio(idControl) {
		var jqFolioSolicitud = eval("'#" + idControl + "'");
		var varFolioSolicitud = $(jqFolioSolicitud).val();
		var tipConPrincipal = 1;

		setTimeout("$('#cajaLista').hide();", 200);
		if (varFolioSolicitud != '' && !isNaN(varFolioSolicitud)) { // si es numero y no esta vacio el campo
			if(varFolioSolicitud == 0){ // si es cero 
				/*se trata de una solicitud nueva*/
				// se inicializa formulario para recibir nuevos datos
				inicializarFormularioNuevaSolicitud();
				habilitaBoton('guardar'); // se habilita boton guardar
				$('#clienteID').focus();
				$('#clienteID').select();
			}else{/*se trata de una consulta de folio */
				var clienteCancelaBean = {
					'clienteCancelaID'	:$('#clienteCancelaID').val()
				};
				clientesCancelaServicio.consulta(tipConPrincipal,clienteCancelaBean,function(cliente) {
					if(cliente!=null){			
						esTab = true;
						/* si el area que cancela al socio no corresponde con la del parametro de la pantalla
						 * se le indicara al socio que acuda a otra pantalla*/					
						if($('#areaCancela').val() != cliente.areaCancela){
							validaAreaCancelacionSocio(cliente.areaCancela); // se llama funcion para validar area
						}else{
							 var folioCan = validaExisteFolio();
							
							switch(cliente.areaCancela){
								case "Soc":
									$('#trActaFecDefuncion').hide();
									$('#trAplicaSeguro').hide();
									break;
								case "Pro": 
									$('#trActaFecDefuncion').show();
									$('#trAplicaSeguro').show();
									break;		
								case "Cob":
									$('#trActaFecDefuncion').hide();
									$('#trAplicaSeguro').hide();
									break;	
								default : 
									mensajeSis("El área que Solicita la Cancelación No esta Definida.");
									deshabilitaBoton('guardar');
									deshabilitaBoton('autorizar');
									deshabilitaBoton('impSolicitud');
									deshabilitaBoton('impPago');
									$('#impSolicitud').hide();
									$('#impPago').hide();
									break;
							}		
							
							$('#clienteID').val(cliente.clienteID);
							$('#estatus').val(cliente.estatus).selected = true;
							$('#usuarioRegistra').val(cliente.usuarioRegistra);
							$('#fechaRegistro').val(cliente.fechaRegistro);
							$('#motivoActivaID').val(cliente.motivoActivaID).selected = true;
							$('#comentarios').val(cliente.comentarios);
							$('#actaDefuncion').val(cliente.actaDefuncion);
							$('#fechaDefuncion').val(cliente.fechaDefuncion);
							$('#aplicaSeguro').val(cliente.aplicaSeguro);
							
							if($('#aplicaSeguro').val()=="S"){
								$('#aplicaSeguroSi').attr("checked",true);
								$('#aplicaSeguroNo').attr("checked",false);
							}else{
								$('#aplicaSeguroSi').attr("checked",false);
								$('#aplicaSeguroNo').attr("checked",true);
							}

							consultaUsuario(cliente.usuarioRegistra);
							consultaCliente('clienteID');
							
							/* muestra  el estatus de la solicitus */
							$('#lblEstatus').show();
							$('#estatus').show();
							deshabilitaControl('clienteID');
							deshabilitaControl('actaDefuncion');
							deshabilitaControl('fechaDefuncion');
							deshabilitaControl('aplicaSeguro');
							deshabilitaControl('aplicaSeguroSi');
							deshabilitaControl('aplicaSeguroNo');
							deshabilitaControl('comentarios');
							deshabilitaControl('motivoActivaID');
							$("#fechaDefuncion").datepicker("disable");
							

							switch(cliente.estatus){
								case 'R':
									habilitaBoton('autorizar'); // se habilita boton autorizar
									deshabilitaBoton('guardar'); // se deshabilita boton guardar
									deshabilitaBoton('impPago'); // se deshabilita boton para imprimir el pago
									$('#autorizar').focus();
									if($('#areaCancela').val() == "Soc"){
										habilitaBoton('impSolicitud'); // se habilita boton para imprimir la solicitud
										deshabilitaBoton('impPago'); // se habilita boton para imprimir el pago 
										$('#impSolicitud').show();
										$('#impPago').hide();
									}else{
										deshabilitaBoton('impSolicitud'); // se deshabilita boton para imprimir la solicitud
										deshabilitaBoton('impPago'); // se habilita boton para imprimir el pago
										$('#impSolicitud').hide();
										$('#impPago').hide();
									}
									break;
								case 'A':
									$('#impSolicitud').focus();
									deshabilitaBoton('guardar'); // se deshabilita boton guardar
									deshabilitaBoton('autorizar'); // se habilita boton autorizar
									if($('#areaCancela').val() == "Soc"){
										if(cliente.saldoFavorCliente>0){
											habilitaBoton('impPago'); // se habilita boton para imprimir el pago
											$('#impPago').show();
										}else{
											deshabilitaBoton('impPago'); // se habilita boton para imprimir el pago
											$('#impPago').hide();
										}
										if(folioCan != '0'){
											habilitaBoton('impSolicitud'); // se habilita boton para imprimir la solicitud
											$('#impSolicitud').show();
										}else{
											deshabilitaBoton('impSolicitud'); // se habilita boton para imprimir la solicitud
											$('#impSolicitud').hide();
										}
										
									}else{
										if($('#areaCancela').val() == "Cob"){
											deshabilitaBoton('impSolicitud'); // se habilita boton para imprimir la solicitud
											$('#impSolicitud').hide();
											if(cliente.saldoFavorCliente>0){
												habilitaBoton('impPago'); // se habilita boton para imprimir el pago
												$('#impPago').show();
											}else{
												deshabilitaBoton('impPago'); // se habilita boton para imprimir el pago
												$('#impPago').hide();
											}
										}else{
											$('#impSolicitud').hide();
											$('#impPago').hide();
										}
									}
									break;
								case 'P':
									$('#impSolicitud').focus();
									deshabilitaBoton('guardar'); // se deshabilita boton guardar
									deshabilitaBoton('autorizar'); // se habilita boton autorizar
									$('#impSolicitud').hide();
									$('#impPago').hide();
									break;
								default:
									$('#motivoActivaID').focus();
									deshabilitaBoton('guardar'); // se deshabilita boton guardar
									deshabilitaBoton('autorizar'); // se habilita boton autorizar
									$('#impSolicitud').hide();
									$('#impPago').hide();
							}
						}					
					}else{
						mensajeSis("El Número de Solicitud de Cancelación no Existe.");				
						$('#clienteCancelaID').focus();
						$('#clienteCancelaID').select();	
						$('#clienteCancelaID').val("");	
						inicializarFormularioNuevaSolicitud();
					}
				});
			}	
		}	
	}
	
	/* Funcion para validar si el cliente ya esta registrado en una solicitud de cancelacion.*/
	function validaClienteSolCancela(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var varClienteID = $(jqCliente).val();	
		var tipConCliente = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (varClienteID != '' && !isNaN(varClienteID)) { // si es numero y no esta vacio el campo
			var clienteCancelaBean = {
				'clienteID'	:varClienteID.trim()
			};
			if($('#clienteCancelaID').asNumber() == 0){ /* si se trata del alta de una nueva solicitud de cancelacion*/
				clientesCancelaServicio.consulta(tipConCliente,clienteCancelaBean,function(cliente) {
					if(cliente!=null ){
						if(cliente.permiteReactivacion =='S'){
							consultaCliente(idControl);
						}else{
							mensajeSis("El Socio ya Cuenta con una Solicitud de Cancelación con Folio: "+cliente.clienteCancelaID +".");
							inicializarFormularioNuevaSolicitud();
							$('#clienteID').focus();
							$('#clienteID').val("");							
						}
						
					}else{
						consultaCliente(idControl);
					}
				});
			}else{
				consultaCliente(idControl);
			}
			
		}	
	}
	
	
	/* funcion para consultar un cliente */
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);			
		limpiaDatosCliente();
		if(numCliente != '' && !isNaN(numCliente) ){
			clienteServicio.consulta(tipConPrincipal,numCliente.trim(),function(cliente) {
				if(cliente!=null){			
					esTab = true;
					$('#clienteID').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#fechaNacimiento').val(cliente.fechaNacimiento);
					$('#rfc').val(cliente.RFC);
					$('#edad').val(cliente.edad);
					$('#fechaIngreso').val(cliente.fechaAlta);
					$('#sucursalOrigen').val(cliente.sucursalOrigen);
					
					consultaSucursal(cliente.sucursalOrigen); // se consulta la sucursal
					
					if(cliente.tipoPersona == 'F'){
						$('#tipoPersona').val('FÍSICA');
					}else{
						if(cliente.tipoPersona == 'A'){
							$('#tipoPersona').val('FÍSICA ACT. EMP.');
						}else{
							$('#tipoPersona').val('MORAL');
						}
					}	
					
					if(cliente.esMenorEdad == 'S'){// si el cliente es menor de edad, se muestra la seccion con la informacion del tutor
						consultaTutor();
						$('#esMenorEdad').val(cliente.esMenorEdad);
					}else{
						$('#divDatosTutor').hide();
						$('#esMenorEdad').val("N");
					}
					
				}else{
					mensajeSis("No Existe el Cliente");				
					$('#clienteID').focus();
					$('#clienteID').select();	
					inicializarFormularioNuevaSolicitud();
				}
			});
		}
	}
	
	/*funcion para consultar la sucursal*/
	function consultaSucursal(numSucursal) {
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal)) {
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#sucursalOrigenDes').val(sucursal.nombreSucurs);
				} else {
					mensajeSis("No Existe la Sucursal");
				}
			});
		}
	}

	function consultaUsuario(numUsuario) {
		var conUsuario = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		var usuarioBeanCon = {
				'usuarioID':numUsuario 
		};	
		if (numUsuario != '' && !isNaN(numUsuario)) {
			usuarioServicio.consulta(conUsuario, usuarioBeanCon,function(usuario) {
				if (usuario != null) {
					$('#usuarioRegistraDes').val(usuario.nombreCompleto);
				} else {
					mensajeSis("No Existe el Usuario");
					$(jqUsuario).focus();
				}
			});
		}
	}
	
	function validaAreaCancelacionSocio(cliAreaCancela){
		switch(cliAreaCancela){
			case 'Soc':
				mensajeSis("La Solicitud de Cancelación: "+$('#clienteCancelaID').val()+" debe consultarse en la pantalla: \nCancelar Socio Por Atención a Socio");		
				$('#clienteCancelaID').focus();
				$('#clienteCancelaID').select();	
				$('#clienteCancelaID').val("");	
				inicializaRadiosCancelSocio();
				limpiaCamposNuevaSolicitud();
				break;
			case 'Pro':
				mensajeSis("La Solicitud de Cancelación: "+$('#clienteCancelaID').val()+" debe consultarse en la pantalla: \nCancelar Socio Por Protecciones");		
				$('#clienteCancelaID').focus();
				$('#clienteCancelaID').select();	
				$('#clienteCancelaID').val("");
				inicializaRadiosCancelSocio();
				limpiaCamposNuevaSolicitud();
				break;
			case 'Cob':
				mensajeSis("La Solicitud de Cancelación: "+$('#clienteCancelaID').val()+" debe consultarse en la pantalla: \nCancelar Socio Por Cobranza");		
				$('#clienteCancelaID').focus();
				$('#clienteCancelaID').select();	
				$('#clienteCancelaID').val("");
				inicializaRadiosCancelSocio();
				limpiaCamposNuevaSolicitud();
				break;
			default:
				mensajeSis("La Solicitud de Cancelación: "+$('#clienteCancelaID').val()+" no tiene un area de cancelación correcta.");		
				$('#clienteCancelaID').focus();
				$('#clienteCancelaID').select();	
				$('#clienteCancelaID').val("");	
				inicializaRadiosCancelSocio();
				limpiaCamposNuevaSolicitud();
		}
	}

	/* consulta los datos del tutor */
	function consultaTutor() {
		var numCliente = $('#clienteID').val();			
		var tipoConsulta = 12;
		setTimeout("$('#cajaLista').hide();", 200);
	
		if (numCliente != '') {				
			socioMenorServicio.consultaTutor(tipoConsulta,numCliente, function(tutor) {
				if (tutor != null) {
					$('#divDatosTutor').show();
					$('#clienteIDTutor').val(tutor.clienteTutorID);	
					$('#clienteIDTutorDes').val(tutor.nombreTutor);	
					$('#parentescoIDDes').val(tutor.parentescoTutor);	
				} else {
					mensajeSis("El cliente No tiene Registrado un Tutor");
				}
			});
		}
	}
	
	
	function validaExisteFolio(){
		var tipConFolioCan =  6;
		 var folioCancelacionClente = 0;
		var clienteCancelaBean = {
				'clienteCancelaID'	:$('#clienteCancelaID').val()
			};
			 
			clientesCancelaServicio.consulta(tipConFolioCan,clienteCancelaBean,{ async: false, callback:function(folioCliente) {
					if(folioCliente!=null){		
						folioCancelacionClente = folioCliente.clienteCancelaID;
						
								}
							}
						});
						
			return folioCancelacionClente;	
	}
	
});


/* funcion para validar la fecha */
function esFechaValida(fecha){
	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
			return false;
		}

		var mes=  fecha.substring(5, 7)*1;
		var dia= fecha.substring(8, 10)*1;
		var anio= fecha.substring(0,4)*1;

		switch(mes){
			case 1: case 3:  case 5: case 7: case 8: case 10: case 12:	
				numDias=31;
			break;
		case 4: case 6: case 9: case 11:
			numDias=30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
			break;
		default:
			mensajeSis("Fecha introducida errónea");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida errónea");
			return false;
		}
		return true;
	}
}

function comprobarSiBisisesto(anio){
	if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
		return true;
	}
	else {
		return false;
	}
}

function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
	//0|1|2|3|4|5|6|7|8|9|
	//2 0 1 2 / 1 1 / 2 0
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

//Regresar el foco a un campo de texto. Habia problemas al regresar el foco a un input en el nav. firefox
function regresarFoco(idControl){
	var jqControl=eval("'#"+idControl+"'");
	setTimeout(function(){
		$(jqControl).focus();
	 },0);
}

/* llena el combo con motivos de inactivacion sin fallecimiento*/
function consultaMotivosInactivacion() {
	var motivoBean = {
		'motivoActivaID' : 0, 
		'tipoMovimiento' : 1,
	};			 	
	motivActivacionServicio.listaCombo(motivoBean, 4, function(motivos){
		dwr.util.removeAllOptions('motivoActivaID'); 
		dwr.util.addOptions('motivoActivaID', {'':'SELECCIONAR'});
		dwr.util.addOptions('motivoActivaID', motivos, 'motivoActivaID', 'descripcion');
	});
}

/* agrega al combo la opcion por fallecimiento fallecimiento*/
function  agregarOpcionFallecimiento(){
	document.getElementById("motivoActivaID").innerHTML = "";
	$("#motivoActivaID").append('<option value="">SELECCIONAR</option>');
	$("#motivoActivaID").append('<option value="2">MUERTE</option>');
}


/* funcion que inicializa el formulario de cancelacion de socio
 * cuando se carga la pantalla por primera vez*/
function inicializarFormularioCancelSocio() {
	/*se pone el foco en la primer caja */
	$('#clienteCancelaID').focus();
	
	/* se consultan los parametros de sesion*/
	parametroBean = consultaParametrosSession();
	$('#usuarioRegistra').val(parametroBean.numeroUsuario);
	$('#usuarioAutoriza').val(parametroBean.numeroUsuario);
	$('#usuarioRegistraDes').val(parametroBean.nombreUsuario);
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	
	/* se agrega formato al formulario */
	agregaFormatoControles('formaGenerica');
	
	/*se inicializan los radios*/
	inicializaRadiosCancelSocio();
	
	/* inicializa radios de si aplica seguro o no */ 
	$('#aplicaSeguroSi').attr("checked",true);
	$('#aplicaSeguroNo').attr("checked",false);
	$('#aplicaSeguro').val("S");
	
	/* se oculta seccion con datos del tutor*/
	$('#divDatosTutor').hide();
	
	/* se deshabilitan los botones del formulario */
	deshabilitaBoton('guardar');
	deshabilitaBoton('autorizar');
	deshabilitaBoton('impSolicitud');
	deshabilitaBoton('impPago');
}

/* funcion que inicializa el formulario de cancelacion de socio
 * cuando se trata de una solicitud nueva*/
function inicializarFormularioNuevaSolicitud() {
	/*se inicializan los radios*/
	inicializaRadiosCancelSocio();
	/*se limpian los campos*/
	limpiaCamposNuevaSolicitud();
	/* se consultan los parametros de sesion*/
	parametroBean = consultaParametrosSession();
	$('#usuarioRegistra').val(parametroBean.numeroUsuario);
	$('#usuarioAutoriza').val(parametroBean.numeroUsuario);
	$('#usuarioRegistraDes').val(parametroBean.nombreUsuario);
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	
	/* se oculta seccion con datos del tutor*/
	$('#divDatosTutor').hide();
	
	/* oculta el estatus de la solicitus */
	$('#lblEstatus').hide();
	$('#estatus').hide();
	habilitaControl('clienteID');
	habilitaControl('actaDefuncion');
	habilitaControl('fechaDefuncion');
	habilitaControl('aplicaSeguro');
	habilitaControl('aplicaSeguroSi');
	habilitaControl('aplicaSeguroNo');
	habilitaControl('comentarios');
	habilitaControl('motivoActivaID');
	$("#fechaDefuncion").datepicker("enable");

	
	/* inicializa radios de si aplica seguro o no */ 
	$('#aplicaSeguroSi').attr("checked",true);
	$('#aplicaSeguroNo').attr("checked",false);
	$('#aplicaSeguro').val("S");
	
	
	/* se deshabilitan y habilitan los botones del formulario */
	habilitaBoton('guardar');
	deshabilitaBoton('autorizar');
	deshabilitaBoton('impSolicitud');
	deshabilitaBoton('impPago');
	
}

//-- Funcion para inicializar los radios de area que lo requiere  -- //
function inicializaRadiosCancelSocio() {
	switch($('#areaCancela').val()){
		case "Soc": //cliente con estatus cancelado    
			$('#areaAtencionSocio').attr("checked",true);
			$('#areaProtecciones').attr("checked",false);
			$('#areaCobranza').attr("checked",false);
			deshabilitaControl('areaAtencionSocio');
			deshabilitaControl('areaProtecciones');
			deshabilitaControl('areaCobranza');			
			$('#areaCancela').val("Soc");
			consultaMotivosInactivacion();
			$('#impSolicitud').show();
			$('#impPago').show();

			$('#trActaFecDefuncion').hide();
			$('#trAplicaSeguro').hide();
			break;
		case "Pro": //cliente con estatus pagado         
			$('#areaAtencionSocio').attr("checked",false);
			$('#areaProtecciones').attr("checked",true);
			$('#areaCobranza').attr("checked",false);
			deshabilitaControl('areaAtencionSocio');
			deshabilitaControl('areaProtecciones');
			deshabilitaControl('areaCobranza');			
			$('#areaCancela').val("Pro");
			agregarOpcionFallecimiento();
			$('#impSolicitud').hide();
			$('#impPago').hide();
			$('#trActaFecDefuncion').show();
			$('#trAplicaSeguro').show();
			break;		
		case "Cob": //cliente con estatus pagado         
			$('#areaAtencionSocio').attr("checked",false);
			$('#areaProtecciones').attr("checked",false);
			$('#areaCobranza').attr("checked",true);
			deshabilitaControl('areaAtencionSocio');
			deshabilitaControl('areaProtecciones');
			deshabilitaControl('areaCobranza');			
			$('#areaCancela').val("Cob");
			consultaMotivosInactivacion();
			$('#impSolicitud').hide();
			$('#impPago').hide();
			$('#trActaFecDefuncion').hide();
			$('#trAplicaSeguro').hide();
			break;	
		default : 
			mensajeSis("El área que Solicita la Cancelación No esta Definida.");
			deshabilitaBoton('guardar');
			deshabilitaBoton('autorizar');
			deshabilitaBoton('impSolicitud');
			deshabilitaBoton('impPago');
			$('#impSolicitud').hide();
			$('#impPago').hide();
			break;
	}		
}


/* funcion  para limpiar todos los campos del formulario 
 * exceptp el campo del area que realiza la solicitud y los de parametros
 * de sesion */
function limpiaDatosCliente() {
	$('#clienteID').val("");
	$('#nombreCliente').val("");
	$('#fechaNacimiento').val("");
	$('#sucursalOrigen').val("");
	$('#sucursalOrigenDes').val("");
	$('#rfc').val("");
	$('#edad').val("");
	$('#tipoPersona').val("");
	$('#fechaIngreso').val("");
	$('#clienteIDTutor').val("");
	$('#clienteIDTutorDes').val("");
	$('#parentescoID').val("");
	$('#parentescoIDDes').val("");
}


/* funcion  para limpiar todos los campos del formulario 
 * exceptp el campo del area que realiza la solicitud y los de parametros
 * de sesion */
function limpiaCamposNuevaSolicitud() {
	$('#clienteID').val("");
	$('#nombreCliente').val("");
	$('#fechaNacimiento').val("");
	$('#sucursalOrigen').val("");
	$('#sucursalOrigenDes').val("");
	$('#rfc').val("");
	$('#edad').val("");
	$('#tipoPersona').val("");
	$('#fechaIngreso').val("");
	$('#clienteIDTutor').val("");
	$('#clienteIDTutorDes').val("");
	$('#parentescoID').val("");
	$('#parentescoIDDes').val("");
	$('#comentarios').val("");
	$('#actaDefuncion').val("");
	$('#fechaDefuncion').val("");
	
	$('#estatus').val("R").selected = true;
	$('#motivoActivaID').val("").selected = true;
}

/* funcion para confirmar el cancelar el socio.*/
function confirmarGuardar() {		
	var confirmar=confirm("¿Desea Continuar con el Proceso de Cancelación de Socio?");
	 
	if (confirmar == true) {
		// si pulsamos en aceptar
		procedeSubmit = true;
	}else{
		procedeSubmit = false; 
	} 	
}

/*funcion de exito */
function exitoFormularioCancelSocio() {
	$('#clienteCancelaID').select();
	$('#clienteCancelaID').focus();
	inicializaRadiosCancelSocio();
	limpiaCamposNuevaSolicitud();
}

/*funcion de error  */
function errorFormularioCancelSocio() {
	
}