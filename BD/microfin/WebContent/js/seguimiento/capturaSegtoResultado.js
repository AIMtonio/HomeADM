var parametroBean = consultaParametrosSession();
var catTipoLisSegto = {
	'principal'	: 1,
	'foranea'	: 2
};

var catTipoListaDocu ={
	'principal' : 1
};

$(document).ready(function(){
	// inicializacion de variables y elementos del formulario
	inicializaFormaCapturaSegto();
	$('#segtoPrograID').focus();
	
	var catTipoCategoriaCon ={
		'principal'	: 1
	};
	var catTipoConSegto = {
		'principal'	: 1,
		'foranea'	: 2,
		'estatus'	: 3,
		'supervisor': 6
	};
	var catTipoTranSegto = {
  		'agrega'	: 1, 
  		'modifica': 2
	};
	
	var catConSegtoResultado={
		'alcance' : 3
	};
	var catConSegtoRecomendas = {
		'alcance' : 3
	};
	var catTiposSeguimiento ={
		'desaProyecto' : 2,
		'cobAdmtva'		: 4
	};
	var catConDesarrolloProy ={
		'principal'		: 1
	};
	var catConsultaAval = {
		'principal' : 1
	};

	var catLisArchivo ={
		'principal'	: 1,
		'archivos'	: 2
	};
	
	consultaMotivosNoPago();
	consultaOrigenPago();
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modifica', 'submit');
	var consultaCalendario = 0;       // Para indicar si la consulta se realiza en la pantalla de calendario de seguimiento
	//-----------------------Métodovalidas y manejo de eventos-----------------------
	//si se encuentra en la pantalla de calendario ejecuta lo siguiente
	if($('#consultaID').val() != undefined){
		if(Number($('#consultaID').val()) > 0){
			esTab = true;
			$('#segtoPrograID').val($('#consultaID').val());
			consultaSeguimientoProgramado($('#consultaID').val());
			consultaCalendario = 1;
			deshabilitaControl('segtoPrograID');
			deshabilitaControl('creditoID');
			deshabilitaControl('grupoID');
		}
	} 
	///----------------------------------------------------
   $.validator.setDefaults({
   	submitHandler: function(event) {
       	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','segtoRealizaID',
       			'funcionExitoCapturaSegto','funcionFalloCapturaSegto');
		}
	});

   $(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$(':text').focus(function() {
		esTab = false;
	});
	
	$('#grabar').click(function(){
		if( ($('#esSupervisor').val() == 'S') && $('#fechaSegtoFor').val() != '' ){
			if ($('#horaSegtoFor').val() == '') {
				alert("Capture la Hora del Proximo Seguimiento");
				$('#horaSegtoFor').focus();
				return false;
			}
		}
		$('#categoriaID').removeAttr('disabled');
		$('#tipoTransaccion').val(catTipoTranSegto.agrega);
	});
	
	$('#modifica').click(function(){
		$('#tipoTransaccion').val(catTipoTranSegto.modifica);
	});
	
	$('#capturaDetalle').click(function(){
		muestraSeguimientoCobranza();
	});
	
	 $('#segtoPrograID').bind('keyup',function(e){
		   if(this.value.length >= 2){
			   var camposLista = new Array(); 
			   var parametrosLista = new Array();
			   camposLista[0] = "puestoResponsableID"; 
			   camposLista[1] = "nombreResponsable";
				parametrosLista[0] = parametroBean.numeroUsuario;
			   parametrosLista[1] = $('#segtoPrograID').val();
			   listaAlfanumerica('segtoPrograID', '1', '2', camposLista, parametrosLista, 'listaCalSegto.htm');
		   }
	   });

	$('#segtoPrograID').blur(function() {
		$('#detalleArchivos').html('');
		$('#detalleArchivos').show();
		if(consultaCalendario == 0 ){
			consultaSeguimientoProgramado(this.value);
		}
	});
	
	$('#segtoRealizaID').blur(function() {
		consultaResultadoSegto(this.id);
		if ( $('#categoriaID').val() == catTiposSeguimiento.cobAdmtva) {
			consultaSegtoCobranza(this.id);
		}else if ($('#categoriaID').val() == catTiposSeguimiento.desaProyecto) {
			consultaSegtoDesProy(this.id);
		}
		//consultaArchivosAdjuntos();
	});

	$('#segtoRealizaID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "segtoPrograID";
			parametrosLista[0] = $('#segtoPrograID').val();
			listaAlfanumerica('segtoRealizaID', '1', '1', camposLista, parametrosLista, 'listaSegtoRealizado.htm');
		}
	});
	
	$('#usuarioSegto').blur(function() {
		consultaUsuario('usuarioSegto',$('#usuarioSegto').val(),'nombreUsuarioSegto');
	});
	
	$('#usuarioSegto').bind('keyup',function(e){
		listaAlfanumerica('usuarioSegto', '1', '1', 'nombreCompleto', $('#usuarioSegto').val(), 'listaUsuarios.htm');
	});

	$('#fechaSegto').change(function() {
		$('#fechaSegto').focus();
	});
	
	$('#fechaPromPago').change(function() {
		$('#fechaPromPago').focus();
	});
	
	$('#fechaEstFlujo').change(function() {
		$('#fechaEstFlujo').focus();
	});
	
	$('#fechaComercial').change(function() {
		$('#fechaComercial').focus();
	});
	
	$('#fechaSegtoFor').change(function() {
		$('#fechaSegtoFor').focus();
	});

	$("#horaSegtoFor").setMask('time').val('');
	$("#horaCaptura").setMask('time').val('');

	$('#tipoContacto').change(function () {
		if (this.value == 'C' && $('#creditoID').val() != '' ) {
			$('#nombreContacto').val($('#nombreCompleto').val());
		}else if (this.value == "C" && $('#grupoID').val() != '') {
			$('#nombreContacto').val($('#nomPresidente').val());
		}
		else if (this.value == "O" && $('#creditoID').val() != '') {
			$('#nombreContacto').val($('#nombreConyuge').val());
		}
		else if (this.value == "O" && $('#grupoID').val() != '') {
			$('#nombreContacto').val($('#nombreConyuge').val());
		}
		else if (this.value == "V" ) {
			consultaAval('solicitudCreditoID');
		}
		else {
			$('#nombreContacto').val('');
			habilitaControl('nombreContacto');
		}
	});
	
	$('#origenPagoID').change(function () {
		if (this.value == 1) {
			deshabilitaControl('nomOriRecursos');
			if ($('#creditoID').val() != '' ) {
				$('#nomOriRecursos').val($('#nombreCompleto').val());
			}else {
				$('#nomOriRecursos').val($('#nomPresidente').val());
			}
		}else{
			$('#nomOriRecursos').val('');
			habilitaControl('nomOriRecursos');			
		}
	});
	
	$('#existFlujo2').click(function() {	
		$('#lblcerrarFecha').hide();
		$('#fechaEstFlujo').val('1900-01-01');
		$('#cerrarFecha').hide();
	});

	$('#existFlujo1').click(function() {
		$('#lblcerrarFecha').show();
		$('#fechaEstFlujo').val('');
		$('#cerrarFecha').show();	
	});
	
	$('#estatus').change(function () {
		var resultado = $('#categoResultado').val();
		var recomendauno = $('#categoRecomenda').val();
		var recomendados = $('#categoRecomenda2').val();
		var supervisor = $('#esSupervisor').val();
		if (this.value == 'T'){
			if (supervisor != 'S' && resultado == 'S') {
				alert('No Tiene Autorización para Terminar el Seguimiento');
				$(this).val('');
			}else if (supervisor != 'S' && recomendauno == 'S') {
				alert('No Tiene Autorización para Terminar el Seguimiento');
				$(this).val('');
			}else if (supervisor != 'S' && recomendados == 'S') {
				alert('No Tiene Autorización para Terminar el Seguimiento');
				$(this).val('');
			}
		}
		if (this.value == 'C'){
			if (supervisor != 'S' && resultado == 'S') {
				alert('No Tiene Autorización para Cancelar el Seguimiento');
				$(this).val('');
			}else if (supervisor != 'S' && recomendauno == 'S') {
				alert('No Tiene Autorización para Cancelar el Seguimiento');
				$(this).val('');
			}else if (supervisor != 'S' && recomendados == 'S') {
				alert('No Tiene Autorización para Cancelar el Seguimiento');
				$(this).val('');
			}
		}
	});
	
	$('#fechaEstFlujo').change(function () {
		var fechaPro = $('#fechaPromPago').val();
		if(this.value > fechaPro){
			alert("La Fecha Est. Flujo No Debe Ser Mayor a la Fecha Promesa de Pago");
			$(this).val('');
			$(this).focus();
		}
	});
	
	$('#fechaPromPago').change(function () {
		var fechaPro = $('#fechaEstFlujo').val();
		if(this.value < fechaPro){
			alert("La Fecha Promesa de Pago No Debe Ser Menor a la Fecha Est. Flujo");
			$(this).val('');
			$(this).focus();
		}
	});
	
	$('#resultadoSegtoID').change(function () {
		var resultadoBean = {
			'resultadoSegtoID' : this.value
		};
		segtoResultadosServicio.consulta(catConSegtoResultado.alcance, resultadoBean, function (beanResultado) {
			if (beanResultado!= null){
				//alert(beanResultado.reqSupervisor)
				$('#categoResultado').val(beanResultado.reqSupervisor);
			}
		});
	});
	
	$('#recomendacionSegtoID').change(function () {
		var segRecomen = $('#segdaRecomendaSegtoID').val();
		if (this.value == segRecomen && this.value != ""){
			alert("La Recomendación ya ha sido seleccionada.");
			$(this).val("");
		}else {
			var recomendasBean = {
				'recomendacionSegtoID'	: this.value
			};
			segtoRecomendasServicio.consulta(catConSegtoRecomendas.alcance, recomendasBean, function (beanRecomenda) {
				if (beanRecomenda!= null){
					//alert(beanRecomenda.reqSupervisor)
					$('#categoRecomenda').val(beanRecomenda.reqSupervisor);
				}
			});
		}
	});
	
	$('#segdaRecomendaSegtoID').change(function () {
		var segRecomen = $('#recomendacionSegtoID').val();
		if (this.value == segRecomen && this.value != ""){
			alert("La Recomendación ya ha sido seleccionada.");
			$(this).val("");
		}else {
			var recomendasBean = {
				'recomendacionSegtoID'	: this.value
			};
			segtoRecomendasServicio.consulta(catConSegtoRecomendas.alcance, recomendasBean, function (beanRecomenda) {
				if (beanRecomenda!= null){
					//alert(beanRecomenda.reqSupervisor)
					$('#categoRecomenda2').val(beanRecomenda.reqSupervisor);
				}
			});
		}
	});

	$('#adjuntar').click(function () {
		if ($('#segtoRealizaID').val() != '') {
			if ($('#tipoDocumento').val() != '' ) {
				subirArchivos();
			}else {
				alert("Especifique el Tipo de Documento a Adjuntar")
				$('#tipoDocumento').focus();
			}
		}else {
			alert("Especifique un Número Consecutivo de Seguimiento");
			$('#segtoRealizaID').focus();
		}
	});
	
   $('#fechaSegto').change(function() { 
	   var fechaelegida = $('#fechaSegto').val(); 
	   $('#fechaSegto').focus();
 		if(esFechaValida(fechaelegida)){		
 		}
 		else {
 			$('#fechaSegto').val(parametroBean.fechaSucursal);
			$('#fechaSegto').focus();	
 		}
	});
   
   $('#fechaSegtoFor').change(function() { 
	   var fechaelegida = $('#fechaSegtoFor').val(); 
	   $('#fechaSegtoFor').focus();
 		if(esFechaValida(fechaelegida)){		
 		}
 		else {
 			$('#fechaSegtoFor').val(parametroBean.fechaSucursal);
			$('#fechaSegtoFor').focus();	
 		}
	});
   
   $('#fechaComercial').change(function() { 
	   var fechaelegida = $('#fechaComercial').val(); 
	   $('#fechaComercial').focus();
 		if(esFechaValida(fechaelegida)){		
 		}
 		else {
 			$('#fechaComercial').val(parametroBean.fechaSucursal);
			$('#fechaComercial').focus();	
 		}
	});
   
   $('#fechaPromPago').change(function() { 
	   var fechaelegida = $('#fechaPromPago').val(); 
	   $('#fechaPromPago').focus();
 		if(esFechaValida(fechaelegida)){		
 		}
 		else {
 			$('#fechaPromPago').val(parametroBean.fechaSucursal);
			$('#fechaPromPago').focus();	
 		}
	});
   
   $('#fechaEstFlujo').change(function() { 
	   var fechaelegida = $('#fechaEstFlujo').val(); 
	   $('#fechaEstFlujo').focus();
 		if(esFechaValida(fechaelegida)){		
 		}
 		else {
 			$('#fechaEstFlujo').val(parametroBean.fechaSucursal);
			$('#fechaEstFlujo').focus();	
 		}
	});
   
	$('#expediente').click(function() {
		var numTr = ($('#tablaArchivos >tbody >tr').length ) -1;
		if(numTr != 0){
			var segtoPrograID = $('#segtoPrograID').val();
			var segtoRealizaID = $('#segtoRealizaID').val();
			
			var fechaEmision = parametroBean.fechaSucursal;
			var usuario = 	parametroBean.numeroUsuario;
			var nombreUsuario = parametroBean.claveUsuario;
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			$('#enlaceSegto').attr('href','segtoExpedientePDF.htm?segtoPrograID='+segtoPrograID
				+'&numSecuencia='+segtoRealizaID+'&nombreUsuario='+nombreUsuario.toUpperCase()+'&usuario='+usuario+
				'&fecha='+fechaEmision+'&nombreInstitucion='+nombreInstitucion);
		}else {
			alert("No Existen Documentos Adjuntos");
		}
	});
   
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			segtoPrograID: {
				required: true
			},
			segtoRealizaID:{
				required: true
			},
			fechaSegto: {
				required: true
			},
			usuarioSegto: {
				required: true
			},
			tipoContacto: {
				required: true
			},
			nombreContacto: {
				required: true
			},
			comentario: {
				required: true
			},
			resultadoSegtoID: {
				required: true
			},
			recomendacionSegtoID: {
				required: true
			},
			segdaRecomendaSegtoID: {
				required: true
			},
			estatus: {
				required: true
			},				
			fechaEstFlujo:{
				required: function() {return $('#existFlujo1').is(':checked');}
			},
			motivoNPID:{
				required: function () { return $('#categoriaID').val() == catTiposSeguimiento.cobAdmtva ? true : false },
			},
			existFlujo :{
				required: function () { return $('#categoriaID').val() == catTiposSeguimiento.cobAdmtva ? true : false }
			},
			fechaPromPago: {
				required: function () { return  ($('#categoriaID').val() == catTiposSeguimiento.cobAdmtva  && $('#montoPromPago').val() !='') 
							|| ($('#categoriaID').val() == catTiposSeguimiento.cobAdmtva  && $('#origenPagoID').val() !='')
							|| ($('#categoriaID').val() == catTiposSeguimiento.cobAdmtva  && $('#nomOriRecursos').val() !='') ? true : false }
			},
			montoPromPago: {
				required: function () { return  ($('#categoriaID').val() == catTiposSeguimiento.cobAdmtva  && $('#fechaPromPago').val() !='') 
							|| ($('#categoriaID').val() == catTiposSeguimiento.cobAdmtva  && $('#origenPagoID').val() !='') 
							|| ($('#categoriaID').val() == catTiposSeguimiento.cobAdmtva  && $('#nomOriRecursos').val() !='') ? true : false }
			},
			origenPagoID: {
				required: function () { return  ($('#categoriaID').val() == catTiposSeguimiento.cobAdmtva  && $('#montoPromPago').val() !='') 
							|| ($('#categoriaID').val() == catTiposSeguimiento.cobAdmtva  && $('#origenPagoID').val() !='') 
							|| ($('#categoriaID').val() == catTiposSeguimiento.cobAdmtva  && $('#nomOriRecursos').val() !='') ? true : false }
			},
			nomOriRecursos: {
				required: function () { return  ($('#categoriaID').val() == catTiposSeguimiento.cobAdmtva  && $('#montoPromPago').val() !='') 
							|| ($('#categoriaID').val() == catTiposSeguimiento.cobAdmtva  && $('#origenPagoID').val() !='') 
							|| ($('#categoriaID').val() == catTiposSeguimiento.cobAdmtva  && $('#nomOriRecursos').val() !='') ? true : false }
			},
			asistenciaGpo:{
				required: function () { return $('#categoriaID').val() == catTiposSeguimiento.desaProyecto ? true : false; }
			},
			recoAdeudo:{
				required: function () { return $('#categoriaID').val() == catTiposSeguimiento.desaProyecto ? true : false; }
			},
			recoMontoFecha:{
				required: function () { return $('#categoriaID').val() == catTiposSeguimiento.desaProyecto ? true : false; }
			},
			avanceProy:{
				required: function () { return $('#categoriaID').val() == catTiposSeguimiento.desaProyecto ? true : false; }
			},
			montoEstProd:{
				required: function () { return $('#categoriaID').val() == catTiposSeguimiento.desaProyecto ? true : false; }
			},
			uniEstProd:{
				required: function () { return $('#categoriaID').val() == catTiposSeguimiento.desaProyecto ? true : false; }
			},
			montoEstUni:{
				required: function () { return $('#categoriaID').val() == catTiposSeguimiento.desaProyecto ? true : false; }
			},
			montoEstVtas:{
				required: function () { return $('#categoriaID').val() == catTiposSeguimiento.desaProyecto ? true : false; }
			},
			fechaComercial:{
				required: function () { return $('#categoriaID').val() == catTiposSeguimiento.desaProyecto ? true : false; }
			}
		},
		messages: {
			segtoPrograID: {
				required: 'Especificar No de Segto.'
			},
			segtoRealizaID:{
				required: 'Especificar el Número Consecutivo'
			},
			fechaSegto: {
				required: 'Especificar Fecha de Segto.'
			},
			usuarioSegto: {
				required: 'Especificar Responsable de Segto.'
			},
			tipoContacto: {
				required: 'Especificar Persona que lo Atendió'
			},
			nombreContacto: {
				required: 'Especificar Nombre de Persona que lo Atendió'
			},
			comentario: {
				required: 'Especificar Comentario.'
			},
			resultadoSegtoID: {
				required: 'Especificar Resultado de Segto'
			},
			recomendacionSegtoID: {
				required: 'Especificar 1era. Recomendación de Segto.'
			},
			segdaRecomendaSegtoID: {
				required: 'Especificar 2da. Recomendación de Segto.'
			},
			estatus: {
				required: 'Especificar Estatus de Segto.'
			},
			fechaEstFlujo:{
				required: 'Especificar Fecha Estimada de Flujo',				
			},
			motivoNPID:{
				required: 'Especificar Motivo de No Pago',				
			},
			existFlujo :{
				required: 'Especificar si Habrá Flujo Pago'
			},
			fechaPromPago: {
				required: 'Especificar la Fecha Promesa de Pago'
			},
			montoPromPago: {
				required: 'Especificar el Monto Promesa de Pago'
			},
			origenPagoID: {
				required: 'Especificar el Origen Recursos para el Pago'
			},
			nomOriRecursos: {
				required: 'Especificar el Nombre Origen de Recursos para Pago'
			},
			asistenciaGpo:{
				required: 'Especificar la Asistencia del Grupo'
			},
			recoAdeudo:{
				required: 'Especificar si Reconoce Adeudo'
			},
			recoMontoFecha:{
				required: 'Especificar si Conoce Montos y Fechas'
			},
			avanceProy:{
				required: 'Especificar el Avance del Proyecto'
			},
			montoEstProd:{
				required: 'Especificar el Monto Estimado de Producción'
			},
			uniEstProd:{
				required: 'Especificar las Unidades Estimadas de Producción'
			},
			montoEstUni:{
				required: 'Especificar Precio Estimado por Unidad'
			},
			montoEstVtas:{
				required: 'Especificar el Monto Estimado de Ventas'
			},
			fechaComercial:{
				required: 'Especificar la Fecha de Comercialización'
			}
		}
	});
	
	//-------------Validaciones de controles---------------------

	function consultaArchivosAdjuntos(){
 		var numSegtoPrograID = $('#segtoPrograID').val();
 		var numSegtoRealizaID = $('#segtoRealizaID').val();
 		
 		if (numSegtoPrograID != '' && numSegtoRealizaID != ''){
 			var params = {};
 			params['tipoLista'] = catLisArchivo.archivos;
 			params['segtoPrograID'] = numSegtoPrograID;
 			params['numSecuencia'] = numSegtoRealizaID;
			$.post("gridSegtoArchivo.htm", params, function(data){
				if(data.length >0) {
					$('#detalleArchivos').html(data);
					$('#detalleArchivos').show();
					habilitaBoton('expediente', 'button');	
					habilitaBoton('adjuntar', 'button');
				}else{
					$('#detalleArchivos').html("");
					$('#detalleArchivos').show();
				}
			});
 		}else{
 			$('#detalleArchivos').html("");
 			$('#detalleArchivos').hide();
		}
	}
	

	function consultaTipoGestor(numPuesto){
		var numSegtoID = $('#segtoPrograID').val();
		var SegtoBeanCon = {
			'segtoPrograID' : numSegtoID,
			'puestoResponsableID' : numPuesto
		};
		if (numPuesto != '' && numSegtoID != '' && numPuesto != '') {
			segtoManualServicio.consulta(catTipoConSegto.supervisor, SegtoBeanCon, function(seguimiento) {
				if (seguimiento != null) {
					if (seguimiento.puestoSupervisorID != '') {
						$('#esSupervisor').val('S');
						$('#lblForzado').show();
						$('#txtForzado').show();	
					}else {
						$('#esSupervisor').val('N');
						$('#lblForzado').hide();
						$('#txtForzado').hide();
					}
				}else {
					$('#esSupervisor').val('N');
					$('#lblForzado').hide();
					$('#txtForzado').hide();
				}
			});
		}
	}
	// funcion consulta de Resultados Seguimiento
	function consultaResultadoSegto(idControl){
		var jqSegtoRealizaID  = eval("'#" + idControl + "'");
		var varSegtoRealizaID = $(jqSegtoRealizaID).val();
		setTimeout("$('#cajaLista').hide();", 200);
		consultaEstatus('segtoRealizaID');
		if(varSegtoRealizaID=='0'){
			inicializaFormaCapturaNuevoSegto();
		}else{
			var segtoRealizaBeanCon = { 
					'segtoPrograID'	:$('#segtoPrograID').val(),
					'segtoRealizaID':varSegtoRealizaID
				};	
			if(varSegtoRealizaID != '' && !isNaN(varSegtoRealizaID) && esTab){
				segtoRealizadosServicio.consulta(catTipoConSegto.principal,segtoRealizaBeanCon,function(beanSegtoRealizado) {
					if(beanSegtoRealizado!=null){
						esTab=true;
						$('#usuarioSegto').val(beanSegtoRealizado.usuarioSegto);
						$('#fechaSegto').val(beanSegtoRealizado.fechaSegto);
						$('#nombreContacto').val(beanSegtoRealizado.nombreContacto);
						$('#fechaCaptura').val(beanSegtoRealizado.fechaCaptura);
						$('#horaCaptura').val(beanSegtoRealizado.horaCaptura);
						$('#comentario').val(beanSegtoRealizado.comentario);
						$('#fechaSegtoFor').val(beanSegtoRealizado.fechaSegtoFor);
						$('#horaSegtoFor').val(beanSegtoRealizado.horaSegtoFor);
						
						$('#resultadoSegtoID').val(beanSegtoRealizado.resultadoSegtoID).selected = true;
						$('#recomendacionSegtoID').val(beanSegtoRealizado.recomendacionSegtoID).selected = true;
						$('#segdaRecomendaSegtoID').val(beanSegtoRealizado.segdaRecomendaSegtoID).selected = true;
						$('#tipoContacto').val(beanSegtoRealizado.tipoContacto).selected = true;
						$('#estatus').val(beanSegtoRealizado.estatus).selected = true;
						
						$('#telefonFijo').val(beanSegtoRealizado.telefonFijo);
						$('#telefonCel').val(beanSegtoRealizado.telefonCel);

						$("#telefonFijo").setMask('phone-us');
						$("#telefonCel").setMask('phone-us');
						
						if(beanSegtoRealizado.fechaSegtoFor == '1900-01-01'){
							$('#fechaSegtoFor').val('');
						}
						consultaUsuario('usuarioSegto',beanSegtoRealizado.usuarioSegto,'nombreUsuarioSegto');						
						deshabilitaBoton('grabar', 'submit');
					}else{
						if(varSegtoRealizaID != 0 && varSegtoRealizaID != '' ){
							alert("No existen Datos capturados para el número indicado");
							limpiaFormularioResultadoSegto();
							$('#segtoRealizaID').focus();
							$('#segtoRealizaID').val('');
							deshabilitaBoton('grabar', 'submit');
							deshabilitaBoton('modifica', 'submit');
						}
					}
				});		
			}
		}
	}
	
	function consultaEstatus(idControl) {
		var jqSegtoRealizaID  = eval("'#" + idControl + "'");
		var varSegtoRealizaID = $(jqSegtoRealizaID).val();
		var segtoRealizaBeanCon = {
			'segtoPrograID'	: $('#segtoPrograID').val(),
			'segtoRealizaID':  varSegtoRealizaID
		};

		if(varSegtoRealizaID != '' && !isNaN(varSegtoRealizaID) && esTab){
			segtoRealizadosServicio.consulta(catTipoConSegto.estatus,segtoRealizaBeanCon,function(beanSegtoRealizado) {
				if(beanSegtoRealizado!=null){
					if (beanSegtoRealizado.estatus == 'T' ) {
						alert("El Seguimiento ya se encuentra Terminado");
						$('#segtoRealizaID').focus();
						deshabilitaBoton('grabar', 'submit');
						deshabilitaBoton('modifica', 'submit');
					}else {
						if ($('#segtoRealizaID').val() == 0) {
							habilitaBoton('grabar', 'submit');
							deshabilitaBoton('modifica', 'submit');

						}else {
							deshabilitaBoton('grabar', 'submit');
							habilitaBoton('modifica', 'submit');
						}
					}
				}
			});
		}
	}

	function consultaSeguimientoProgramado(numSeg) { 
		var segtoBeanCon = {
  			'segtoPrograID'		: numSeg,
  			'puestoResponsableID': parametroBean.numeroUsuario
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSeg != '' && !isNaN(numSeg) && esTab){
			if(numSeg == '0'){
				alert("El Número de Seguimiento No Existe");
				inicializaForma('formaGenerica','segtoPrograID');
				$('#segtoPrograID').focus();
				$('#segtoPrograID').val('');
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('modifica', 'submit');
				limpiaFormularioResultadoSegto();
				$('#fechaCaptura').val('');
			} else {
				$('#tipoContacto').val('');
				$('#nombreContacto').val('');
				segtoManualServicio.consulta(1, segtoBeanCon,function(segto) {
					if(segto!=null){
						if(segto.creditoID=='0'){
						}else{
							$('#creditoID').val(segto.creditoID);	
							esTab = true;
							validaCredito();
						}
						if(segto.grupoID=='0'){
						}else{
							 $('#grupoID').val(segto.grupoID);
							 esTab=true;
							 validaGrupo();
						}
						$('#fechaProg').val(segto.fechaProgramada);
						$('#horaProgramada').val(segto.horaProgramada);
						$('#categoriaID').val(segto.categoriaID);
						$('#puestoResponsableID').val(segto.puestoResponsableID);
						$('#puestoSupervisorID').val(segto.puestoSupervisorID);
						consultaUsuario('puestoResponsableID',segto.puestoResponsableID,'nombreUsuario' );
						consultaUsuario('puestoSupervisorID',segto.puestoSupervisorID, 'nombreSupervisor' );
						validaCategoria(segto.categoriaID);
						if(segto.tipoGeneracion=='M'){
			         		$('#tipoGeneracion').val('M').selected = true;
			         		$('#tipoGeneracion').val('MANUAL');
						}else{
							$('#tipoGeneracion').val('A').selected = true;
							$('#tipoGeneracion').val('AUTOMATICO');
						}
						if(segto.esForzado=='S'){
							$('#segtoForzado').attr("checked",true) ;
						}else{
							$('#segtoForzado').attr("checked",false) ;
						}
						$('#estatusProg').val(segto.estatus).selected = true;
						deshabilitaControl('estatusProg');
						$('#fechaForzado').val(segto.fechaForzado);
						$('#secSegtoForzado').val(segto.secSegtoForzado);
						if (segto.categoriaID == catTiposSeguimiento.cobAdmtva){
							$('#capacidadPago').show();
							$('#desaProyecto').hide();
						}else if (segto.categoriaID == catTiposSeguimiento.desaProyecto) {
							$('#capacidadPago').hide();
							$('#desaProyecto').show();
						}
						if (segto.categoriaID != catTiposSeguimiento.cobAdmtva 
												&& segto.categoriaID != catTiposSeguimiento.desaProyecto){
							$('#capacidadPago').hide();
							$('#desaProyecto').hide();
						}
	   					$('#montoSolici').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	   					$('#montoSolicitado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	   					$('#montoAutorizado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	   					$('#saldoVigente').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
  						$('#saldoAtrasado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
 						$('#saldoVencido').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2}); 
						//--------------------------------------------------------------
					}else{
						alert("El Número de Seguimiento No Existe");
						inicializaForma('formaGenerica','segtoPrograID');
						$('#estatusProg').val("").selected = true;
						$('#segtoPrograID').focus();
						$('#segtoPrograID').val('');
						deshabilitaBoton('grabar', 'submit');
						deshabilitaBoton('modifica', 'submit');
					}
				});
				      inicializaForma('formaGenerica','segtoPrograID');
						limpiaFormularioResultadoSegto();
						deshabilitaBoton('grabar', 'submit');
						deshabilitaBoton('modifica', 'submit');
			}
			consultaTipoGestor(parametroBean.numeroUsuario);
		}
	}

	
	function validaCategoria(){
		var categoID  = $('#categoriaID').val();
		var CategoBeanCon = {
			'categoriaID': categoID
		};
		if(categoID != '' && !isNaN(categoID) && esTab){
			catSegtoCategoriasServicio.consulta(catTipoCategoriaCon.principal,CategoBeanCon,function(categorias) {
				if(categorias != null){
					$('#descripcionCat').val(categorias.descripcion);
				}
			});
		}
	}
	
	
	function validaCredito() {
		var numCredito = $('#creditoID').val();
		var estatusInactivo 	="I";		
		var estatusAutorizado 	="A";
		var estatusVigente		="V";
		var estatusPagado		="P";
		var estatusCancelada 	="C";		
		var estatusVencido		="B";
		var estatusCastigado 	="K";	

		setTimeout("$('#cajaLista').hide();", 200);
		var porCredito = 3;
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			if(numCredito=='0'){
				alert("No existe el Crédito");
			} else {
				var segtoBeanCon = {
  				'creditoID':numCredito
				};
				segtoManualServicio.consulta(porCredito,segtoBeanCon,function(segto) {
						if(segto!=null){
							$('#nombreCompleto').val(segto.nombreCliente);
							$('#solicitudCreditoID').val(segto.solCred);
							$('#producCredID').val(segto.prodCred);
							$('#nombreProdCred ').val(segto.descripcion);
							$('#montoSolicitado').val(segto.montoSoli);
							$('#montoAutorizado').val(segto.montoAutor);
							$('#fechaSol').val(segto.fechaSol);
							$('#fechaDesembolso').val(segto.fechaDesem);
							$('#estatusCredito').val(segto.estatusCred);

							var var_estatus = segto.estatusCred;

							if(var_estatus == estatusInactivo){
								$('#estatusCredito').val('INACTIVO');
							}	
							if(var_estatus == estatusAutorizado){
								$('#estatusCredito').val('AUTORIZADO');
							}
							if(var_estatus == estatusVigente){
								$('#estatusCredito').val('VIGENTE');
							}
							if(var_estatus == estatusPagado){
								$('#estatusCredito').val('PAGADO');
							}
							if(var_estatus == estatusCancelada){
								$('#estatusCredito').val('CANCELADO');							
							}
							if(var_estatus == estatusVencido){
								$('#estatusCredito').val('VENCIDO');							
							}
							if(var_estatus == estatusCastigado){
								$('#estatusCredito').val('CASTIGADO');							
							}

							$('#saldoVigente').val(segto.saldoCapVig);
							$('#diasAtraso').val(segto.diasFaltaPago);
							$('#saldoAtrasado').val(segto.saldoCapAtrasa);
							$('#saldoVencido').val(segto.saldoCapVencido);
							$('#telefonoCasa').val(segto.telefonoCasa);
							$('#extTelefonoPart').val(segto.extTelefonoPart);
							$('#telefonoCelular').val(segto.telefonoCelular);
							
							$('#grupoID').val('');
							$('#nombreGrupo').val('');
	   						$('#montoSolici').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	   						$('#montoSolicitado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	   						$('#montoAutorizado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	   						$('#saldoVigente').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	   						$('#saldoAtrasado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	   						$('#saldoVencido').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	   						$('#segtoRealizaID').val('');
	   						$('#fechaSegto').val('');
	   						$('#usuarioSegto').val('');
	   						$('#nombreUsuarioSegto').val('');   						
	   						$('#tipoContacto').val('');
	   						$('#nombreContacto').val('');
	   						$('#fechaPromPago').val('');
							$('#montoPromPago').val('');
							$('#origenPagoID').val('');
							$('#nomOriRecursos').val('');
							$('#telefonCel').val('');
							$('#telefonFijo').val('');
							$('#telefonCel').val('');
							$('#comentario').val('');
							$('#resultadoSegtoID').val('');
							$('#recomendacionSegtoID').val('');
							$('#segdaRecomendaSegtoID').val('');
							$('#estatus').val('');
							$('#fechaSegtoFor').val('');
							$('#horaSegtoFor').val('');
							consultaCredito();
						}
						else{
							alert("No Existe Generales del Crédito");
							deshabilitaBoton('grabar', 'submit');
							$('#creditoID').focus();
							$('#creditoID').val();
							$('#nombreCompleto').val('');						
						}
				});			
			}							
		}
	}
	
	function validaGrupo() {
		var numGrupo = $('#grupoID').val();
		var grupoID=$('#grupoID').asNumber();
		setTimeout("$('#cajaLista').hide();", 200);
		var principal = 1;
		esTab=true;
		if(numGrupo != '' && !isNaN(numGrupo) && esTab){
			if(numGrupo=='0'){
				alert("No existe el Grupo");
			} else {				
				var grupoBeanCon = { 
  				'grupoID':$('#grupoID').val(),
				};
				gruposCreditoServicio.consulta(principal,grupoBeanCon,function(grupos) {
						if(grupos!=null){
							$('#nombreGrupo').val(grupos.nombreGrupo);
							consultaSolGrupo(grupos.grupoID);
							
						}
						else{
							alert("No Existe el grupo");
							deshabilitaBoton('grabar', 'submit');
							$('#grupoID').focus();
							$('#grupoID').val();
							$('#nombreGrupo').val('');						
						}
				});			
			}							
		}
	}
	
	function consultaSolGrupo(numGrupo){
		var numGrupoBean  = numGrupo;
		var conPorGrupo  = 4;
		var SegtoBeanCon = {
			'grupoID': numGrupoBean
		};
		esTab=true;
		if(numGrupoBean != '' && !isNaN(numGrupoBean) && esTab){
			segtoManualServicio.consulta(conPorGrupo,SegtoBeanCon,function(segto) {
				if(segto != null){
					$('#solicitudCreditoID').val(segto.solCred);
					$('#producCredID').val(segto.prodCred);
					$('#nombreProdCred ').val(segto.descripcion);
					$('#montoSolicitado').val(segto.montoSoli);
					$('#montoAutorizado').val(segto.montoAutor);
					$('#fechaSol').val(segto.fechaSol);
					$('#fechaDesembolso').val(segto.fechaDesem);
					$('#estatus').val(segto.estatusCred);
					$('#saldoVigente').val(segto.saldoCapVig);
					$('#diasAtraso').val(segto.diasFaltaPago);
					$('#saldoAtrasado').val(segto.saldoCapAtrasa);
					$('#saldoVencido').val(segto.saldoCapVencido);
					$('#nomPresidente').val(segto.nombreCliente);
			 		$('#creditoID').val('');
			 		$('#nombreCompleto').val('');
			 		
					$('#montoSolici').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#montoSolicitado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#montoAutorizado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#saldoVigente').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#saldoAtrasado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#saldoVencido').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#cliente').val(segto.clienteIDPre);
					$('#telefonoCasa').val(segto.telefonoCasa);
					$('#extTelefonoPart').val(segto.extTelefonoPart);
					$('#telefonoCelular').val(segto.telefonoCelular);
					
					consultaDatosConyugue('cliente');
				}
				else{
					alert("No Existe Generales del Crédito");
					deshabilitaBoton('grabar', 'submit');
					$('#grupoID').focus();
					$('#grupoID').val();
					$('#nombreGrupo').val('');						
				}
			});
		}		
	}
	// funcion para consultar el nombre del usuario
	function consultaUsuario(idControl, numUsuario, idNombreUsuario) {
		var jqDescripcion  = eval("'#" + idNombreUsuario + "'");
		var jqID  = eval("'#" + idControl + "'");
		var conUsuario=2;
		var usuarioBeanCon = {
				'usuarioID':numUsuario 
		};	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
			usuarioServicio.consulta(conUsuario,usuarioBeanCon,function(usuario) {
				if(usuario!=null){							
					$(jqDescripcion).val(usuario.nombreCompleto);															
				}else{
					alert("No Existe el Usuario");
					$(jqID).val("");
					$(jqDescripcion).val("");
					$(jqID).focus();
				}    						
			});
		}
	}
	

	//funcion que consulta seguimiento 
	function consultaSegtoCobranza(idSegto) {
		var numSegto = $('#segtoPrograID').val();
		var consecutivo = $('#segtoRealizaID').val();
		var tipoPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(consecutivo != '' && !isNaN(consecutivo)){
			var bean={
				'segtoPrograID': numSegto,
				'segtoRealizaID' : consecutivo
			};
			resultadoSegtoCobranzaServicio.consultaPrincipal(tipoPrincipal,bean,function(segto) {
				if(segto!=null){
					if (segto.fechaPromPago == '1900-01-01') {
						$('#fechaPromPago').val('');
					}else {
						$('#fechaPromPago').val(segto.fechaPromPago);
					}
					if (segto.montoPromPago == 0) {
						$('#montoPromPago').val('');
					}else {
						$('#montoPromPago').val(segto.montoPromPago);
					}
					
					$('#existFlujo').val(segto.montoPromPago);
					
					if (segto.existFlujo=='S'){
						$('#lblcerrarFecha').show();
						$('#fechaEstFlujo').val(segto.fechaEstFlujo);
						$('#cerrarFecha').show();
						$('#existFlujo1').attr("checked",true);
					}else{
						$('#lblcerrarFecha').hide();
						$('#fechaEstFlujo').val('1900-01-01');
						$('#cerrarFecha').hide();
						$('#existFlujo2').attr("checked",true);		
					}
					$('#montoPromPago').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#fechaEstFlujo').val(segto.fechaEstFlujo);
					$('#origenPagoID').val(segto.origenPagoID);
					$('#motivoNPID').val(segto.motivoNPID);
					$('#nomOriRecursos').val(segto.nomOriRecursos);
					if (segto.origenPagoID == 1 || segto.origenPagoID == 2) {
						deshabilitaControl('nomOriRecursos');
					}else {
						habilitaControl('nomOriRecursos');
					}
					$('#telefonFijo').val(segto.telefonFijo);
					$('#telefonCel').val(segto.telefonCel);

					$("#telefonFijo").setMask('phone-us');
					$("#telefonCel").setMask('phone-us');
				
				}else{
					$('#segtoPrograIDCob').val();
					$('#segtoRealizaIDCob').val();
					$('#fechaPromPago').val('');
					$('#montoPromPago').val('');
					$('#existFlujo').val('');
					$('#fechaEstFlujo').val('');
					$('#origenPagoID').val('');
					$('#motivoNPID').val('');
					$('#nomOriRecursos').val('');
					$('#telefonFijo').val('');
					$('#telefonCel').val('');
				}		
							
			});
		}
	}


	function consultaSegtoDesProy(idControl){		
		var numSegto = $('#segtoPrograID').val();
		var jqSegtoRealizaID  = eval("'#" + idControl + "'");
		var numSegtoRealiza = $(jqSegtoRealizaID).val();
		var DesProyBean = {
			'segtoPrograID'	: numSegto,
			'segtoRealizaID'	: numSegtoRealiza
		}
		resultadoSegtoDesProyServicio.consulta(catConDesarrolloProy.principal, DesProyBean, function(segtoDesProy) {
			if (segtoDesProy != null) {
				$('#asistenciaGpo').val(segtoDesProy.asistenciaGpo);
				if (segtoDesProy.reconoceAdeudo == 'S') {
					$('#recoAdeudo1').attr("checked",true);	
				}else {
					$('#recoAdeudo2').attr("checked",true);
				}
				if (segtoDesProy.conoceMtosFechas == 'S') {
					$('#recoMontoFecha1').attr("checked",true);
				}else {
					$('#recoMontoFecha1').attr("checked",true);
				}
				$('#avanceProy').val(segtoDesProy.avanceProy);
				$('#montoEstProd').val(segtoDesProy.montoEstProd);
				$('#uniEstProd').val(segtoDesProy.unidEstProd);
				$('#montoEstUni').val(segtoDesProy.precioEstUni);
				$('#montoEstVtas').val(segtoDesProy.montoEspVtas);
				$('#fechaComercial').val(segtoDesProy.fechaComercializa);
				$('#telefonFijo').val(segtoDesProy.telefonoFijo);
				$('#telefonCel').val(segtoDesProy.telefonoCel);
				$('#montoEstProd').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
				$('#montoEstUni').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
				$('#montoEstVtas').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

				$("#telefonFijo").setMask('phone-us');
				$("#telefonCel").setMask('phone-us');
				
			}
		});
	}
	
	function consultaMotivosNoPago() {
		var motivoBean = {
			'motivoNPID' : ''
		};
		dwr.util.removeAllOptions('motivoNPID'); 
		dwr.util.addOptions('motivoNPID', {'':'SELECCIONA'});
		 	
		segtoMotNoPagoServicio.listaCombo(motivoBean, 3, function(motivos){
			dwr.util.addOptions('motivoNPID', motivos, 'motivoNPID', 'descripcion');
		});
	}

	function consultaOrigenPago() {
		var motivoBean = {
			'origenPagoID' : ''
		};
		dwr.util.removeAllOptions('origenPagoID'); 
		dwr.util.addOptions('origenPagoID', {'':'SELECCIONA'});
		 	
		segtoOrigenPagoServicio.listaCombo(motivoBean, 3, function(motivos){
			dwr.util.addOptions('origenPagoID', motivos, 'origenPagoID', 'descripcion');
		});
	}
	
	
	function consultaCredito() {	
		var creditoBeanCon ={
				'creditoID' : $('#creditoID').val()
		};
		creditosServicio.consulta(1,creditoBeanCon,function(credito) {
			if (credito != null) {
				$('#cliente').val(credito.clienteID);
				consultaDatosConyugue('cliente');
			} else {
				alert("No Existe el Credito");	
			}
		});
	}

	function consultaDatosConyugue(idControl){
		var tipolistaPrincipal= {
			'principal': 1			
		};
		var jqClienteID  = eval("'#" + idControl + "'");
		var jqCliente 	=$(jqClienteID).val();
		var datSocConyugueBean = {
			'clienteID':  jqCliente
		};
		socDemoConyugServicio.consulta(tipolistaPrincipal.principal,datSocConyugueBean ,function(conyugue){
			if(conyugue!=null){
				$('#nombreConyuge').val(conyugue.primerNombre+" " + conyugue.segundoNombre+ " " +conyugue.tercerNombre
						+" " +conyugue.apellidoPaterno+ " " +conyugue.apellidoMaterno);			
			}else{
				$('#nombreConyuge').val('');
			}
		});
  	}
	
	function consultaAval(idControl) {
		var jqNumSol = eval("'#" + idControl + "'");
		var numSolicitud = $(jqNumSol).val();
		var avalBean = {
			'avalID': numSolicitud
		};
		avalesPorSoliciServicio.consulta(catConsultaAval.principal,avalBean, function(avales) {
			if(avales!=null){
				$('#nombreContacto').val(avales.nombre);
			}else{
				$('#nombreContacto').val('');
			}
		});
	}
}); 


	function subirArchivos() {
		agregarFilasArchivos();
 		var consecutivo = ($('#tablaArchivos >tbody >tr').length ) -1;
		var numSegto = $('#segtoPrograID').val();
		var numSecuencia = $('#segtoRealizaID').val();		
		
		var url ="seguimientoFileUploadVista.htm?segtoPrograID="+ numSegto + "&numSecuencia="+ numSecuencia +"&consecutivoID="+consecutivo;
 		var leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
 		var topPosition = (screen.height) ? (screen.height-500)/2 : 0;
 		ventanaArchivosAclaracion = window.open(url,
 				"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no," +
 				"addressbar=0,menubar=0,toolbar=0"+
 				"left="+leftPosition+
 				",top="+topPosition+
 				",screenX="+leftPosition+
 				",screenY="+topPosition);
	}


//funcion para llenar el combo Resultado Segto
function llenaComboResultadoSegto() {
	var segtoBean = {
			'descripcion'	: ""
	};
	dwr.util.removeAllOptions('resultadoSegtoID'); 
	$('#resultadoSegtoID').append(new Option('SELECCIONA', '', true, true)); 
	segtoResultadosServicio.listaCombo(segtoBean, catTipoLisSegto.principal,function(segtoLista){
		if(segtoLista!=null){
			dwr.util.addOptions('resultadoSegtoID', segtoLista, 'resultadoSegtoID', 'descripcion');
		}
	});
}

//funcion para llenar el combo Resultado Segto

function llenaComboRecomendacionSegto() {
	var segtoBean = {
			'descripcion'	: ""
	};
	dwr.util.removeAllOptions('recomendacionSegtoID'); 
	$('#recomendacionSegtoID').append(new Option('SELECCIONA', '', true, true));
	segtoRecomendasServicio.listaCombo(segtoBean,catTipoLisSegto.principal, function(segtoLista){
		if(segtoLista!=null){
			dwr.util.addOptions('recomendacionSegtoID', segtoLista, 'recomendacionSegtoID', 'descripcion');
		}
	});
}	

function llenaCombo2daRecomendacionSegto() {
	var segtoBean = {
			'descripcion'	: ""
	};
	dwr.util.removeAllOptions('segdaRecomendaSegtoID'); 
	$('#segdaRecomendaSegtoID').append(new Option('SELECCIONA', '', true, true));
	segtoRecomendasServicio.listaCombo(segtoBean,catTipoLisSegto.principal, function(segtoLista){
		if(segtoLista!=null){
			dwr.util.addOptions('segdaRecomendaSegtoID', segtoLista, 'recomendacionSegtoID', 'descripcion');
		}
	});
}

//funcion para inicializar los valores del formulario
// cuando se trata de un nuevo seguimiento realizado
function inicializaFormaCapturaNuevoSegto(){
	habilitaBoton('grabar', 'submit');
	$('#fechaCaptura').val(parametroBean.fechaSucursal);
	limpiaFormularioResultadoSegto();
	deshabilitaBoton('capturaDetalle', 'submit');
}

//funcion para inicializar los valores del formulario

function limpiaFormularioResultadoSegto(){
	$('#fechaSegto').val('');
	$('#usuarioSegto').val('');
	$('#fechaCaptura').val('');
	$('#horaCaptura').val('');
	$('#nombreContacto').val('');
	$('#asistenciaGpo').val('');
	$('#recoAdeudo1').attr('checked',false);
	$('#recoAdeudo2').attr('checked',false);
	$('#recoMontoFecha1').attr('checked',false);
	$('#recoMontoFecha2').attr('checked',false);
	$('#avanceProy').val('');
	$('#uniEstProd').val(''); 
	$('#montoEstUni').val('');
	$('#montoEstVtas').val('');
	$('#montoEstVtas').val('');
	$('#montoEstProd').val('');
	$('#fechaComercial').val('');
	$('#telefonFijo').val('');
	$('#telefonCel').val('');
	$('#comentario').val('');
	$('#fechaSegtoFor').val('');
	$('#nombreUsuarioSegto').val('');
	$('#fechaPromPago').val('');
	$('#montoPromPago').val('');
	$('#fechaEstFlujo').val('');
	$('#origenPagoID').val('');
	$('#nomOriRecursos').val('');
	$('#resultadoSegtoID').val('').selected = true;
	$('#recomendacionSegtoID').val("").selected = true;
	$('#segdaRecomendaSegtoID').val("").selected = true;
	$('#tipoContacto').val("").selected = true;
	$('#estatus').val("").selected = true;
	$('#motivoNPID').val("").selected = true;
	$('#fechaCaptura').val(parametroBean.fechaSucursal);
	$('[name=existFlujo]').each(function () {
		$(this).removeAttr('checked');
	});
}

//funcion para inicializar los valores del formulario

function inicializaFormaCapturaSegto(){
	parametroBean = consultaParametrosSession();
	$('#fechaCaptura').val(parametroBean.fechaSucursal);
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('grabar', 'submit');
	llenaComboRecomendacionSegto();
	llenaCombo2daRecomendacionSegto();
	llenaComboResultadoSegto();


	$("#telefonFijo").setMask('phone-us');
	$("#telefonCel").setMask('phone-us');
}

//funcion cuando es exito el resultado de la transaccion
function funcionExitoCapturaSegto(){
	inicializaFormaCapturaSegto();
	limpiaFormularioResultadoSegto();
	$('#divDetalleSegumiento').hide();
}

function validaFormatoMoneda() {
	if ((event.keyCode < 46) || (event.keyCode > 57)) 
	event.returnValue = false;
}

function validaSoloNumeros() {
	if ((event.keyCode < 48) || (event.keyCode > 57)) 
	event.returnValue = false;
}

//funcion cuando es fallo el resultado de la transaccion//
function funcionFalloCapturaSegto(){
}

	function agregarFilasArchivos(){
		var idTipoDoc	= $('#tipoDocumento').val();
		var descTipoDoc = $('#tipoDocumento option:selected').text();
		var fechaSucursal=parametroBean.fechaSucursal;
		var numeroFila = ($('#tablaArchivos >tbody >tr').length ) -1 ;
		var nuevaFila = numeroFila + 1;
		var tds = '<tr id="registro' + nuevaFila + '" name="registro" style="visibility : hidden" >';
		if (numeroFila == 0) {
			tds += '<td><input type="text" id="folioID'+nuevaFila+'" name="folioID"  size="7" autocomplete="off"/></td>';
			tds += '<td><input type="text" id="fecha'+nuevaFila+'" name="fecha"  size="10"  value="" /></td>';
			tds += '<td><input type="text" id="nombreArchivo' +nuevaFila+'" name="nombreArchivo" size="35" path="nombreArchivo" /></td>';
			tds += '<td><input type="text" id="tipoDocumento' +nuevaFila+'" name="tipoDocumento" value="'+descTipoDoc+'" size="45" path="tipoDocumento" /></td>';
			tds += '<input type="hidden" id="tipoDocID' +nuevaFila+'" name="tipoDocID" value="'+idTipoDoc+'" size="40" path="tipoDocID" />';
			tds += '<td><input type="text" id="comentaAdjunto'+nuevaFila+'" name="comentaAdjunto" path="comentaAdjunto" size="40"  value="" /></td>';
			tds += '<td> <a id="enlaceSegto'+nuevaFila+'" href="segtoVerArchivos.htm" target="_blank">';
			tds += '<input type="button" id="ver'+nuevaFila+'" name="ver" class="submit" value="Ver" autocomplete="off" onclick="verArchivosSegto(this.id)"/>';
			tds += '</a> </td> ';
			tds += '<input type="hidden" id="rutaArchivo' +nuevaFila+'" name="rutaArchivo" path="rutaArchivo" />';
		} else {
			var valor = numeroFila+ 1;
			tds += '<td><input type="text" id="folioID'+nuevaFila+'" name="folioID"'+valor+' size="7"/></td>';
			tds += '<td><input type="text"  id="fecha'+nuevaFila+'" name="fecha"  size="10"  value="" /></td>';
			tds += '<td><input type="text" id="nombreArchivo' +nuevaFila+'" name="nombreArchivo" size="35" path="nombreArchivo"  /></td>';
			tds += '<td><input type="text" id="tipoDocumento' +nuevaFila+'" name="tipoDocumento" value="'+descTipoDoc+'" size="45" path="tipoDocumento" /></td>';
			tds += '<input type="hidden" id="tipoDocID' +nuevaFila+'" name="tipoDocID" value="'+idTipoDoc+'" size="40" path="tipoDocID" />';
			tds += '<td><input type="text"  id="comentaAdjunto'+nuevaFila+'" name="comentaAdjunto" path="comentaAdjunto" size="40"  value="" /></td>';
			tds += '<td> <a id="enlaceSegto'+nuevaFila+'" href="segtoVerArchivos.htm" target="_blank">';
			tds += '<input type="button" id="ver'+nuevaFila+'" name="ver" class="submit" value="Ver" onclick="verArchivosSegto(this.id)"/>';
			tds += '</a> </td>';
			tds += '<input type="hidden" id="rutaArchivo' +nuevaFila+'" name="rutaArchivo" path="rutaArchivo"/>';
		}
		tds += '<td align="center"> <input type="button" id="'+nuevaFila+'" name="eliminar" class="btnElimina" onclick="eliminaArchivo(this)"/>';
		tds += '</tr>';
		$("#tablaArchivos").append(tds);
	}

	function verArchivosSegto(control) {
		var numero= control.substr(3,control.length);
		var segtoPrograID = $('#segtoPrograID').val();
		var numSecuencia = $('#segtoRealizaID').val();
		var folioID = $('#folioID'+numero).val();
		var nombreArchivo = $('#nombreArchivo'+numero).val();
		var rutaArchivo = $('#rutaArchivo'+numero).val();
		$('#enlaceSegto'+numero).attr('href','capturaSegtoVerArchivos.htm?segtoPrograID='+segtoPrograID+'&folioID='+folioID+
					'&nombreArchivo='+nombreArchivo+'&rutaArchivo='+rutaArchivo,'_blank');
	}

	function eliminaArchivo(control){
		if (confirm("¿Desea eliminar este registro?") == true){
			var numeroID = control.id;
			var jqTr = eval("'#registro" + numeroID + "'");
			var jqFolio = eval("'#folioID" + numeroID + "'");
			var jqTipoAr = eval("'#nombreArchivo" + numeroID + "'");
			var jqBoton = eval("'#ver" + numeroID + "'");	
			var jqElimina = eval("'#" + numeroID + "'");
			$(jqTr).remove();
		
			//Reordenamiento de Controles 
			var contador = 1;
			$('input[name=folioID]').each(function() {
				var jqFolio = eval("'#" + this.id + "'");
				$(jqFolio).attr("id", "folioID" + contador);
				contador = contador + 1;
			});
			contador = 1;
			$('input[name=fecha]').each(function() {
				var jqTipAr = eval("'#" + this.id + "'");
				$(jqTipAr).attr("id", "fecha" + contador);
				contador = contador + 1;
			});
			contador = 1;
			$('input[name=nombreArchivo]').each(function() {
				var jqTipAr = eval("'#" + this.id + "'");
				$(jqTipAr).attr("id", "nombreArchivo" + contador);
				contador = contador + 1;
			});			
			contador = 1;
			$('input[name=comentaAdjunto]').each(function() {
				var jqFec = eval("'#" + this.id + "'");
				$(jqFec).attr("id", "comentaAdjunto" + contador);
				contador = contador + 1;
			});
			contador = 1;
			$('input[name=rutaArchivo]').each(function() {
				var jqFec = eval("'#" + this.id + "'");
				$(jqFec).attr("id", "rutaArchivo" + contador);
				contador = contador + 1;
			});
			contador = 1;
			$('input[name=ver]').each(function() {
				var jqBotV = eval("'#" + this.id + "'");
				$(jqBotV).attr("id", "ver" + contador);
				contador = contador + 1;
			});
			contador = 1;
			$('input[name=eliminar]').each(function() {
				var jqElim = eval("'#" + this.id + "'");
				$(jqElim).attr("id", contador);
				contador = contador + 1;
			});
			contador = 1; 
			$('input[name=tipoDocumento]').each(function() {
				var jqReg = eval("'#" + this.id + "'");
				$(jqReg).attr("id", "tipoDocumento" + contador);
				contador = contador + 1;
			});
			contador = 1;
			$('input[name=tipoDocID]').each(function() {
				var jqReg = eval("'#" + this.id + "'");
				$(jqReg).attr("id", "tipoDocID" + contador);
				contador = contador + 1;
			});
			contador = 1; 
			$('tr[name=registro]').each(function() {
				var jqReg = eval("'#" + this.id + "'");
				$(jqReg).attr("id", "registro" + contador);
				contador = contador + 1;
			});
		}
	}

	llenaComboTiposDocumento();

	function llenaComboTiposDocumento() {
		var documentoBean = {
			'requeridoEn'	: "M"
		};
		dwr.util.removeAllOptions('tipoDocumento'); 
		$('#tipoDocumento').append(new Option('SELECCIONA', '', true, true));
		tiposDocumentosServicio.listaCombo(catTipoListaDocu.principal, documentoBean, function(documentos){
			if(documentos!=null){
				dwr.util.addOptions('tipoDocumento', documentos, 'tipoDocumentoID', 'descripcion');
			}
		});
	}

	function esFechaValida(fecha){
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("Formato de Fecha no Válida (aaaa-mm-dd)");
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				alert("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea");
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

	function muestraFila(fila){
		var jqTr = eval("'#registro" + fila + "'");
		$(jqTr).css("visibility", "visible");
		$('#fecha'+fila).val(parametroBean.fechaAplicacion);
		$('#tipoDocumento').val('');
	}