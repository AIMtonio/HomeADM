var catTipoConsultaCliAplicaPROFUN = {
  		'principal':1,
  		
};

var catTipoConsultaClientesPROFUN = {
  		'principal':1,
  		
};	
var catTipoConsultaParametrosCaja = {
		'principal':1,
};

// Definicion de Constantes y Enums
var catTransCliAplicaPROFUN = {
	'grabar' : '1',	
	'autorizar' : '2',
	'rechazar' : '4'
	
};			

	
$(document).ready(function() {
	esTab = false;
	comboTiposDocumento();
	datosUsuario();
	inicializaForma('formaGenerica', 'clienteID');
	$('#lblEstatus').hide();
	$('#estatus').hide();
	consultaParametrosCaja();
	var ejecutaFuncion = false; 
	
	// Definicion de Constantes y Enums
	catTransCliAplicaPROFUN = {
		'grabar' : '1',	
		'autorizar' : '2',
		'rechazar' : '4'
		
	};			
	
	catTipoConsultaCliAplicaPROFUN = {
	  		'principal':1,
	  		
	};
	
	catTipoConsultaClientesPROFUN = {
	  		'principal':1,
	  		
	};	
	catTipoConsultaParametrosCaja = {
			'principal':1,
	};
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('grabar', 'submit');
	
	$('#archivosAjunta').hide();
	$('#usuarioAutoriza').hide();
	$('#clienteID').focus();

	//-- Haciendo la transaccion
	$.validator.setDefaults({
	    submitHandler: function(event) {  
    		ejecutaFuncion = validaAutorizaRechazo();
    		if(ejecutaFuncion){
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID','funcionExitoProfun','funcionFalloProfun');
	    	}
	    }
	});
	
	$(':text').focus(function() {	
		esTab = false;	
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});			
		
	//-- Lista de Clientes Registrados en Tabla PROFUN --//
	
	$('#clienteID').bind('keyup',function(e) { 
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCompleto";
		parametrosLista[0] = $('#clienteID').val();
		lista('clienteID', '2', '1',  camposLista, parametrosLista, 'listaClientePROFUN.htm');
	}); 
	
/*
	$('#clienteID').bind('keyup',function(e){
		if($('#clienteID').val().length<3){		
			$('#cajaListaCte').hide();
		}
	});*/

	$('#buscarMiSuc').click(function(){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCompleto";
		parametrosLista[0] = $('#clienteID').val();
		listaCte('clienteID', '3', '19', 'camposLista', parametrosLista, 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCompleto";
		parametrosLista[0] = $('#clienteID').val();
		listaCte('clienteID', '3', '1', 'camposLista', parametrosLista, 'listaCliente.htm');
	});
	
	//--llamando a la funcion que cargara el valor de clientes
	$('#clienteID').blur(function() {
		if(esTab){
			consultaSolicitudCancelaCliente(this.id);
		}		
	});
	
	$('#fechaDefuncionProfun').blur(function() { 
		if($('#fechaDefuncionProfun').val().trim()!=""){
			if(esFechaValida($('#fechaDefuncionProfun').val())){
				
			}else{
				$('#fechaDefuncionProfun').focus();
				$('#fechaDefuncionProfun').val("");
			}
		}
	}); 	
	
	$('#grabar').click(function() {		
		$('#tipoTransaccion').val(catTransCliAplicaPROFUN.grabar);
	});
	
	$('#autorizar').click(function() {	
		if($('#autorizaProfun').is(":checked")){
			$('#rechazaProfun').attr("checked",false);
			$('#tipoTransaccion').val(catTransCliAplicaPROFUN.autorizar);
		}
		if($('#rechazaProfun').is(":checked")){
			$('#autorizaProfun').attr("checked",false);
			$('#tipoTransaccion').val(catTransCliAplicaPROFUN.rechazar);				
		}						
	});
	
	$('#rechazaProfun').click(function() {	
		$('#motivoRechazo').show();
		$('#labelMotivoRechazo').show();		
	});

	$('#autorizaProfun').click(function() {	
		$('#motivoRechazo').hide();
		$('#labelMotivoRechazo').hide();
	});
	
	$('#enviar').click(function(){
		subirArchivos();
	});
	$('#tipoDocumento32').blur(function() {
		
  		consultaArchivCliente();
		$('#imagenCte').hide();

	});		
	
	//-- Funcion para validar que seleccione un documento
	$('#enviar').click(function() {		
		if(($('#clienteID').val()==null || $.trim($('#clienteID').val())=='')){
			mensajeSis("Especifique un Cliente ");
			$('#clienteID').focus();
		}else{
			if ($('#tipoDocumento32').val()==null || $('#tipoDocumento32').val()==''){
				mensajeSis("Seleccione un tipo de Documento");
				$('#tipoDocumento32').focus();
			}else{
				subirArchivos();
			}
		}
	});
	
	//	------------ Validaciones de la Forma -------------------------------------
		
	$('#formaGenerica').validate({
		rules: {
			clienteID: {
				required: true,
			},
			comentario:{
				required:true,
				maxlength : 250
			},
			actaDefuncionProfun:{
				required:true,
			},
			fechaDefuncionProfun:{
				required: true,
				date	: true
			}
		},
		messages: {
			clienteID: {
				required: 'Especificar Cliente.',
			},
			comentario:{
				required: 'Escriba un comentario.',
				maxlength: 'Máximo 250 carácteres.'
			},
			actaDefuncionProfun:{
				required: 'Especifique Acta de Defuncion',
			},
			fechaDefuncionProfun:{
				required: 'Especifique la Fecha de Defuncion',
				date	: 'Fecha Incorrecta'
			}
		}		
	});
		
	
	//-- Funcion para enviar los archivos adjuntos --//
	function subirArchivos(ext) {		
		var url ="clientePROFUNArchivosAdjunta.htm?Cte="+$('#clienteID').val()+"&td="+53+"&pro="+0;
		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;
		ventanaArchivosCliente = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+ 				
										"left="+leftPosition+
										",top="+topPosition+
										",screenX="+leftPosition+
										",screenY="+topPosition); 
		
	
	}
	//-- Funcion para llenar el combo de tipos de documento PROFUN
	function comboTiposDocumento() {	
		var tiposDoc = {
			'requeridoEn':'F'			
		};
		dwr.util.removeAllOptions('tipoDocumento32'); 
		tiposDocumentosServicio.listaCombo(1,tiposDoc, function(tiposDocumentos){
			dwr.util.addOptions('tipoDocumento32', tiposDocumentos, 'tipoDocumentoID', 'descripcion');
		});
	}
	
	
});

//funcion para validar la fecha
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

//Funcion para consultar los archivos del cliente PROFUN
function consultaArchivCliente(){
	if($('#clienteID').val()!=null || $('#clienteID').val()!=''){
		var params = {};
		params['tipoLista'] = 1;
		params['clienteID'] = $('#clienteID').val();
		params['tipoDocumento'] = $('#tipoDocumento32').val();
		$.post("gridClienteFileUpload.htm", params, function(data){		
			if(data.length >0) {
				
				$('#gridArchivosCliente').html(data);
				$('#gridArchivosCliente').show();
			}else{
				$('#gridArchivosCliente').html("");
				$('#gridArchivosCliente').show();
			}
		});
	}
}

//-- funcion para ver los archivos del cliente --//
function verArchivosCliente(id, idTipoDoc, idarchivo,recurso) {
	var varClienteVerArchivo = $('#clienteID').val();
	var varTipoConVerArchivo = 10;
	var parametros = "?clienteID="+varClienteVerArchivo+"&prospectoID="+0+"&tipoDocumento="+
		53+"&tipoConsulta="+varTipoConVerArchivo+"&recurso="+recurso;
	
	var pagina="clientesVerArchivos.htm"+parametros;
	var idrecurso = eval("'#recursoCteInput"+ id+"'");
	var extensionArchivo=  $(idrecurso).val().substring( $(idrecurso).val().lastIndexOf('.'));
	extensionArchivo = extensionArchivo.toLowerCase();
	if(extensionArchivo==".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg" || extensionArchivo == ".gif"){
		$('#imgCliente').attr("src",pagina); 		
		$('#imagenCte').html(); 
		 // $.blockUI({message: $('#imagenCte')}); 
		  $.blockUI({message: $('#imagenCte'),
			   css: { 
           top:  ($(window).height() - 400) /2 + 'px', 
           left: ($(window).width() - 400) /2 + 'px', 
           width: '400px' 
       } });  
		  $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
	}else{
		
		window.open(pagina, '_blank');
		$('#imagenCte').hide();
	}	
}

//funcion para eliminar el documento digitalizado
function  eliminaArchivo(folioDocumento){
	if($('#estatus').val() =='R' ){
		var bajaFolioDocumentoCliente = 1;
		var clienteArchivoBean = {
			'clienteID'	:$('#clienteID').val(),
			'clienteArchivosID'	:folioDocumento
		};
		$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
		$('#contenedorForma').block({
				message: $('#mensaje'),
			 	css: {border:		'none',
			 			background:	'none'}
		});
		clienteArchivosServicio.bajaArchivosCliente(bajaFolioDocumentoCliente, clienteArchivoBean, function(mensajeTransaccion) {
			if(mensajeTransaccion!=null){
				mensajeSis(mensajeTransaccion.descripcion);
				$('#contenedorForma').unblock(); 
				consultaArchivCliente();

			}else{				
				mensajeSis("Existio un Error al Borrar el Documento");			
			}
		});
	}else{
		mensajeSis("Solo se pueden eliminar archivos de una solicitud con estatus Registrado.");
	}
	
}

function consultaCliente(idControl, mostarAlert) {
	var jqCliente = eval("'#" + idControl + "'");
	var numCliente = $(jqCliente).val();
	setTimeout("$('#cajaLista').hide();", 200);
	
	if (numCliente != '' && !isNaN(numCliente) ) {//
		clienteServicio.consulta(7, numCliente, function(
				cliente) {
			if (cliente != null) {
				$('#nombreCliente').val(cliente.nombreCompleto);
				$('#fechaIngresoID').val(cliente.fechaAlta);
				$('#fechaNacimientoID').val(cliente.fechaNacimiento);
				$('#promotorID').val(cliente.promotorActual);
				$('#sucursalID').val(cliente.sucursalOrigen);
				switch(cliente.tipoPersona){
					case 'F':
						$('#tipoPersonaID').val("FÍSICA");
						break;
					case 'A':
						$('#tipoPersonaID').val(" FÍSICA ACT. EMP.");
						break;
					case 'M':
						$('#tipoPersonaID').val("MORAL");
						break;
					default:
						mensajeSis("El Tipo de Persona no existe.");
				}
				consultaClientePROFUN('clienteID', mostarAlert); // valida si existe en registro PROFUN
			} else {
				mensajeSis('El Cliente No Existe');
				$(jqCliente).focus();
				$(jqCliente).val("");
			}
		});
	}
}


//-- Funcion para consultar el cliente PROFUN --//
function consultaClientePROFUN(idControl, mostarAlert) {
	var jqClientePROFUN = eval("'#" + idControl + "'");
	var numClientePROFUN = $(jqClientePROFUN).asNumber();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numClientePROFUN != '' && !isNaN(numClientePROFUN) ){	
		var clientePROFUNBeanCon ={
	 		 	'clienteID' : numClientePROFUN
		};		
		clientesPROFUNServicio.consulta(catTipoConsultaClientesPROFUN.principal,clientePROFUNBeanCon,function(ClientePROFUN) {
			if(ClientePROFUN!=null){
				$('#clienteID').val(ClientePROFUN.clienteID);
				$('#estatusClientePro').val(ClientePROFUN.estatus).selected = true;
				datosUsuario();
				if(ClientePROFUN.estatus!="C"){	
					
					consultaCliAplicaPROFUN('clienteID', mostarAlert);// Valida si existe en solicitudes PROFUN
					consultaNomPromotorA('promotorID');
					consultaSucursal('sucursalID');
					habilitaBoton('grabar', 'submit');
					
				}else{
					mensajeSis("El Cliente tiene un registro cancelado ante PROFUN");
					$('#archivosAjunta').hide();
					$('#usuarioAutoriza').hide();
					$('#clienteID').focus();
					deshabilitaBoton('grabar', 'submit');
				}				    
			}else{
				mensajeSis("El cliente no está registrado ante PROFUN");
				inicializaForma('formaGenerica', 'clienteID'); 
				$('#archivosAjunta').hide();
				$('#usuarioAutoriza').hide();
				$(jqClientePROFUN).val("");
				$(jqClientePROFUN).focus();
				$(jqClientePROFUN).select();
				$('#lblEstatus').hide();
				$('#estatus').hide();
				deshabilitaBoton('grabar', 'submit');
			}
				
		});			
	}		
}
	
//-- Funcion para consultar el Cliente PROFUN con Solicitud-- //
function consultaCliAplicaPROFUN(idControl, mostarAlert) {
	var jqCliAplicaPROFUN = eval("'#" + idControl + "'");
	var numCliAplicaPROFUN = $(jqCliAplicaPROFUN).asNumber();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numCliAplicaPROFUN != '' && !isNaN(numCliAplicaPROFUN) ){	
	
		var cliAplicaPROFUNBeanCon ={
	 		 	'clienteID' : numCliAplicaPROFUN 
	 		 	
		};		
		cliAplicaPROFUNServicio.consulta(cliAplicaPROFUNBeanCon,catTipoConsultaCliAplicaPROFUN.principal, function(CliAplicaPROFUN) {
			if(CliAplicaPROFUN!=null){
				$('#estatus').val(CliAplicaPROFUN.estatus).selected = true;
				$('#comentario').val(CliAplicaPROFUN.comentario);						
				$('#monto').val(CliAplicaPROFUN.monto);
				$('#actaDefuncionProfun').val(CliAplicaPROFUN.actaDefuncionProfun);
				$('#fechaDefuncionProfun').val(CliAplicaPROFUN.fechaDefuncionProfun);
				consultaArchivCliente();
				
				deshabilitaBoton('grabar','submit');
				switch (CliAplicaPROFUN.estatus) {
					case "A" :
						$('#archivosAjunta').show();
						$('#usuarioAutoriza').hide();
						deshabilitaBoton('enviar','submit');
						if(mostarAlert=='S'){
							mensajeSis('La Solicitud PROFUN se encuentra Autorizada');
						}
						deshabilitaBoton('autorizar','submit');
						break;
					case "P" :
						$('#archivosAjunta').show();
						$('#usuarioAutoriza').hide();
						deshabilitaBoton('enviar','submit');
						if(mostarAlert=='S'){
							mensajeSis('El Beneficio PROFUN ya fue Aplicado');
						}
						deshabilitaBoton('autorizar','submit');
						break;
					case "E" :
						$('#archivosAjunta').show();
						$('#usuarioAutoriza').hide();
						deshabilitaBoton('enviar','submit');
						if(mostarAlert=='S'){
							mensajeSis('La Solicitud PROFUN se encuentra Rechazada ');
						}
						deshabilitaBoton('autorizar','submit');
						break;
					case  "R":
						$('#archivosAjunta').show();
						$('#usuarioAutoriza').show();
						habilitaBoton('enviar','submit');
						habilitaBoton('autorizar');
						break;
					default:
						$('#archivosAjunta').show();
						$('#usuarioAutoriza').hide();
					break;
				}

				$('#lblEstatus').show();
				$('#estatus').show();
			}else{
				$('#estatus').val("R").selected == true;						
				$('#comentario').val("");								
				$('#motivoRechazo').val("");						
				consultaParametrosCaja();
				$('#archivosAjunta').hide();
				$('#usuarioAutoriza').hide();
				$('#usuarioAutoriza').hide();
				$('#comentario').focus();
				$('#lblEstatus').hide();
				$('#estatus').hide();
			}					
		});		
	}
}

function consultaNomPromotorA(idControl) {
	var jqPromotor = eval("'#" + idControl + "'");
	var numPromotor = $(jqPromotor).val();
	var tipConForanea = 2;
    var promotor = {
		'promotorID' : numPromotor
	};
	setTimeout("$('#cajaLista').hide();", 200);
	promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
		if (promotor != null) {
			$('#nombrePromotorID').val(promotor.nombrePromotor);
								
		} else {
			mensajeSis("No Existe el Promotor");
		}
	});
}


function consultaSucursal(idControl) {
	var jqSucursal = eval("'#" + idControl + "'");
	var numSucursal = $(jqSucursal).val();
	var conSucursal = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	sucursalesServicio.consultaSucursal(conSucursal, numSucursal, function(sucursal) {
		if (sucursal != null) {
			$('#nombreSucursalID').val(
					sucursal.nombreSucurs);
		} else {
			mensajeSis("No Existe la Sucursal");
		}
	});
}

/* funcion para validar que el cliente tenga una solicitud de cancelacion de socio por 
 * protecciones,*/
function consultaSolicitudCancelaCliente(idControl) {
	var jqCliente = eval("'#" + idControl + "'");
	var varClienteID = $(jqCliente).val();	
	var tipConCliente = 3;
	setTimeout("$('#cajaLista').hide();", 200);
	if (varClienteID != '' && !isNaN(varClienteID)) { // si es numero y no esta vacio el campo
		var clienteCancelaBean = {
			'clienteID'	:varClienteID.trim()
		};
		if($('#clienteCancelaID').asNumber() == 0){ /* si se trata del alta de una nueva solicitud de cancelacion*/
			clientesCancelaServicio.consulta(tipConCliente,clienteCancelaBean,function(cliente) {
				if(cliente!=null){
					$('#actaDefuncionProfun').val(cliente.actaDefuncion);
					$('#fechaDefuncionProfun').val(cliente.fechaDefuncion);
					consultaCliente(idControl,'S');
				}else{
					mensajeSis("El Socio No Tiene una Solicitud de Cancelación.");
					inicializaForma('formaGenerica', 'clienteID'); 
					$('#clienteID').val("");
					$('#clienteID').focus();
					$('#actaDefuncionProfun').val("");
					$('#fechaDefuncionProfun').val("");
					deshabilitaBoton('enviar','submit');
					deshabilitaBoton('autorizar','submit');
					deshabilitaBoton('grabar','submit');
					$('#lblEstatus').hide();
					$('#estatus').hide();
					$('#estatus').val("R").selected == true;						
					$('#comentario').val("");								
					$('#motivoRechazo').val("");						
					consultaParametrosCaja();
					$('#archivosAjunta').hide();
					$('#usuarioAutoriza').hide();
					$('#usuarioAutoriza').hide();
				}
			});
		}else{
			consultaCliente(idControl,'S');
		}
		
	}	
}


//-- Funcion para cargar los Datos de usuario --//
function datosUsuario(){
	var parametroBean = consultaParametrosSession();
	$('#usuarioReg').val(parametroBean.numeroUsuario);   
	$('#nombreUsuario').val(parametroBean.nombreUsuario);           
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
}

//-- Funcion para consultar el monto-- //
function consultaParametrosCaja() {
	var numParametrosCaja = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	if(numParametrosCaja != ''){
		
		var parametrosCajaBeanCon ={
	 		 	'empresaID' : numParametrosCaja		 		 	
		};	
		parametrosCajaServicio.consulta(catTipoConsultaParametrosCaja.principal,parametrosCajaBeanCon, function(ParametrosCaja) {
			if(ParametrosCaja!=null){	
				$('#monto').val(ParametrosCaja.montoPROFUN);
				$('#montoParamCaja').val(ParametrosCaja.montoPROFUN);
				
			}else{
				mensajeSis('Valores no parametrizados');
				funcionExitoProfun();										
			}					
		});		
	}		
}

function funcionExitoProfun(){
	deshabilitaBoton('grabar', 'submit');
	inicializaForma('formaGenerica', 'clienteID');
	$('#archivosAjunta').show();
	$('#usuarioAutoriza').show();
	if($('#tipoTransaccion').val() == 1 ){
		
		consultaCliente('clienteID', 'N');
	}else{
		deshabilitaBoton('autorizar','submit');
		$('#usuarioAutoriza').hide();
		
		consultaCliente('clienteID', 'N');
	}	
}

function funcionFalloProfun(){

}

/* Esta funcion se ejecuta cuando le dan clic al boton CONTINUAR 
 * de la ventana emergente despues de adjuntar un archivo */
function consultaArchivosCliente(){
	consultaArchivCliente();
}


/* funcion para validar los datos requeridos al autorizar o rechazar 
 * la solicitud del beneficio PROFUN*/
function validaAutorizaRechazo(){
	var procede = false;
	if( $('#tipoTransaccion').val()!=catTransCliAplicaPROFUN.grabar){
		if($('#motivoRechazo').val().trim() == "" && $('#rechazaProfun').is(":checked")){
			mensajeSis("Especificar Motivo de Rechazo");
			$('#motivoRechazo').focus();
			procede = false;
		}else{
			if($('#usuarioAuto').val().trim() ==""){
				mensajeSis("Especificar Usuario que Autoriza/Rechaza la Operación.");
				$('#usuarioAuto').focus();
				procede = false;
			}else{
				if($('#contrasenia').val().trim() ==""){
					mensajeSis("Especificar Contraseña del Usuario que Autoriza la Operación.");	
					$('#contrasenia').focus();
					procede = false;
				}else{
					procede = true;
				}
			}
		}		
	}else{
		procede = true;
	}	
	return procede; 
}