var detAntiguedadTrabajo = ""; // esta variable indica que campos se mostraran en la seccion de Datos laborales
var varSeleccionaMoral="";
var editaSucursal = "N";

listaPersBloqBean = {
		'estaBloqueado'	:'N',
		'coincidencia'	:0
};
consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};

$(document).ready(function() {

	esTab = true;

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$("#numero").focus();
	$('#clienteIDf').focus();

	var catTipoConsultaProspec = {
	  		'principal':1,
	  		'prospectoCliente':3
	};
	var parametroBean = consultaParametrosSession();
	//Validacion para mostrarar boton de calcular CURP Y RFC
	permiteCalcularCURPyRFC('generarc','generar',3);

	validaDatosLaborales("","F");
	$('#sucursalOrigen').val(parametroBean.sucursal);
	$('#sucursalO').val(parametroBean.nombreSucursal);
	$('#registroFEA').hide(500);


	var numEmpresa =1;
	$('#empresa').val(numEmpresa);

	// Definicion de Constantes y Enums
	var catTipoTransaccionCliente = {
		'agrega' : '1',
		'modifica' : '2',
		'actualiza' : '3'

	};

	var catTipoConsultaCliente = {
		'principal' : '1',
		'foranea' : '2',
		'corporativos' : '12'

	};

	var catTipoConsultaOcupacion = {
		'principal' : '1',
		'foranea' : '2'
	};

	var catTipoConsultaPromotor = {
		'principal' : '1',
		'foranea' : '2'
	};
	var catTipoConsultaSucursal = {
		'principal' : '1',
		'foranea' : '2'
	};
	var catTipoConsultaSociedad = {
		'principal' : 1,
		'foranea' : 2
	};
	var catTipoConsultaInstitucion = {
			'principal':1

	};
	expedienteBean = {
			'clienteID' : 0,
			'tiempo' : 0,
			'fechaExpediente' : '1900-01-01',
	};
	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('actualiza','submit');
	agregaFormatoControles('formaGenerica');
	$('#campoCorpRel').hide();
	$('#campoCorpRellbl').hide();
	$('#cteCorpNom').hide();
	$('#cteCorpInst').hide();
	$('#negAfiliaNom').hide();
	$('#negAfilia').hide();

	if($('#flujoCliNumCli').val() != undefined){
		if(!isNaN($('#flujoCliNumCli').val())){
			var numCliFlu = Number($('#flujoCliNumCli').val());
			if(numCliFlu > 0){
				$('#numero').val($('#flujoCliNumCli').val());
				consultaTipoPuestos();
				validaCliente('numero',0);
				habilitaBoton('modifica', 'submit');
				deshabilitaBoton('agrega', 'submit');
			}else{
				deshabilitaBoton('modifica', 'submit');
				habilitaBoton('agrega', 'submit');
				validaDatosLaborales("","F");
				$('#numero').val('0');
				$('#numero').focus().select();
			}
		}
	}

	$('#fechaNacimiento').change(function() {
		var Xfecha= $('#fechaNacimiento').val();
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaNacimiento').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha Capturada es Mayor a la de Hoy")	;
				$('#fechaNacimiento').val(parametroBean.fechaSucursal);

			}else{
				$('#nacion').focus();
			}
		}else{
			$('#fechaNacimiento').val(parametroBean.fechaSucursal);

		}
		$('#CURP').val('');

	});

	$('#fechaRegistroPM').change(function() {
			var Xfecha= $('#fechaRegistroPM').val();
			var Yfecha=  parametroBean.fechaSucursal;
			if(esFechaValida(Xfecha)){
				if(Xfecha=='')$('#fechaRegistroPM').val(parametroBean.fechaSucursal);

				if ( mayor(Xfecha, Yfecha) )
				{
					mensajeSis("La fecha capturada es mayor a la de hoy")	;
					$('#fechaRegistroPM').val(parametroBean.fechaSucursal);
				}else{

					$('#nombreNotario').focus();
				}
			}else{
				$('#fechaRegistroPM').val(parametroBean.fechaSucursal);
			}

	});

	$('#sexo').change(function() {
		$('#CURP').val('');
	});

	$('#fechaConstitucion').change(function() {
		var Xfecha= $('#fechaConstitucion').val();
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaConstitucion').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha Capturada es Mayor a la de Hoy")	;
				$('#fechaConstitucion').val(parametroBean.fechaSucursal);
			}else{
				$('#estadoCivil').focus();
			}
		}else{
			$('#fechaConstitucion').val(parametroBean.fechaSucursal);
		}

	});


	$('#nacion').change(function() {
		validaNacionalidadCte();
	});

	// Nacionalidad para persona moral
	$('#nacionalidadPM').change(function() {
		validaNacionalidadCte();
	});

	$('#RFC').focus(function(e){
		maxCaracteres=13;
		if($('#registroHaciendaSi').is(':checked')){
			minCaracteres=13;
		}  else{
		minCaracteres=10;
		}
	});

	$('#tipoPersona1').click(function() {
		if(varSeleccionaMoral == 'S'){
				limpiaForma();
				varSeleccionaMoral='N';
			}
		permiteCalcularCURPyRFC('','generar',2);
		$('#personaFisica').show(500);
		$('#personaMoral').hide(500);
		$('#registroFEA').hide(500);
		$('#datosPersonaFisica').show(500);
		$('#personaFisica').show(500,function(){
		});
		$('#personaMoral').hide(500);
		$('#datosAdicionalesPF').show(500);

		$('#pagaIVA').val('S');
		$('#pagaISR').val('S');
		$('#registroHaciendaNo').val('N').attr('checked',true);

		limpiaDatosPersonaMoral();

		var numCliente = $('#numero').val();
		var numProspecto = $('#prospectoID').val();
		var prospectoBeanCon ={
		 		 'prospectoID' : numProspecto
			};
		if(numCliente != ""){
			clienteServicio.consulta(1,numCliente,function(cliente) {

				if(cliente != null) {
					validaDatosLaborales(cliente,'F');

				}

				if($('#prospectoID').val()!= '' && $('#prospectoID').val()!= 0){
					prospectosServicio.consulta(catTipoConsultaProspec.principal,prospectoBeanCon,{ async: false, callback:function(prospectos) {
					validaDatosLaborales(prospectos,'F');

					}
					});
				}

			});
		}
	});

	$('#tipoPersona2').click(function() {
		if(varSeleccionaMoral == 'S'){
			limpiaForma();
			varSeleccionaMoral='N';
		}
		$('#tipoPersona2').attr("checked", true);
		PermiteRFC();
		$('#esMenorEdad').val('N');
		$('#generar').hide(500);
		$('#personaFisica').hide(500);
		$('#personaMoral').show(500);
		$('#registroFEA').hide(500);
		$('#registroHaciendaSi').val('S').attr('checked',true);

		limpiaDatosPersonaFisica();
		validaDatosLaborales("",'M');

		if ($('#numero').val() != '0') { // IALDANA
			habilitaBoton('modifica','submit'); // agregado Aeuan T_10880
		} else {
			habilitaBoton('agrega','submit');
		}

		habilitaControl('promotorActual');
		habilitaControl('promotorInicial'); // fin agregado
	});

	$('#tipoPersona3').click(function() {

		if(varSeleccionaMoral == 'S'){
				limpiaForma();
				varSeleccionaMoral='N';
			}
		$('#tipoPersona3').attr("checked", true);

		validaDatosLaborales("","F");
		PermiteRFC();

		limpiaDatosPersonaMoral();

		$('#generar').hide(500);
		$('#personaFisica').show(500);
		$('#registroFEA').show(500);
		$('#personaMoral').hide(500);
		$('#pagaIVA').val('S');
		$('#pagaISR').val('S');
		$('#registroHaciendaSi').val('S').attr('checked',true);

		var numCliente = $('#numero').val();
		var numProspecto = $('#prospectoID').val();
		var prospectoBeanCon ={
		 		 'prospectoID' : numProspecto
			};

		if(numCliente != ""){
			clienteServicio.consulta(1,numCliente,function(cliente) {
				if(cliente != null) {
					validaDatosLaborales(cliente,'A');

				}

				if($('#prospectoID').val()!= '' && $('#prospectoID').val()!= 0){
					prospectosServicio.consulta(catTipoConsultaProspec.principal,prospectoBeanCon,{ async: false, callback:function(prospectos) {
					validaDatosLaborales(prospectos,'A');

					}
					});
				}

			});
		}
	});

	$('#RFC').blur(function() {
		if($('#tipoPersona1').is(':checked') && esTab && $('#RFC').val()!= ''){
			validaRFC('RFC');
			validaRFCv1($('#RFC').val());
		}else{
			if($('#tipoPersona3').is(':checked') && esTab && $('#RFC').val()!= ''){
				validaRFC('RFC');
			}
		}
	});

	$('#primerNombre').blur(function() {
		var nombre = $('#primerNombre').val();
		$('#primerNombre').val($.trim(nombre));

	});

	$('#segundoNombre').blur(function() {
		var senombre = $('#segundoNombre').val();
		$('#segundoNombre').val($.trim(senombre));
	});

	$('#tercerNombre').blur(function() {
		var ternombre = $('#tercerNombre').val();
		$('#tercerNombre').val($.trim(ternombre));
	});

	$('#apellidoPaterno').blur(function() {
		var ap = $('#apellidoPaterno').val();
		$('#apellidoPaterno').val($.trim(ap));
	});

	$('#apellidoMaterno').blur(function() {
		var am = $('#apellidoMaterno').val();
		$('#apellidoMaterno').val($.trim(am));
	});

	$('#razonSocial').blur(function() {
		var rz = $('#razonSocial').val();
		$('#razonSocial').val($.trim(rz));
	});

	$('#CURP').blur(function() {
		if($('#primerNombre').val() != '' && $('#fechaNacimiento').val() != '' && $('#nacion').val() != '' && $('#sexo').val() != '' && esTab){
			validaCURP('CURP');
			validaCURPv1($('#CURP').val());
		}
	});

	$('#RFCpm').blur(function() {
		if($('#tipoPersona2').is(':checked')){
			validaRFC('RFCpm');
		}
	});

	$('#clasificacion').change(function() {
		if($('#clasificacion').val() == 'R'){
				$('#campoCorpRel').show();
				$('#campoCorpRellbl').show();
		}else{
			limpiaForm('#campoCorpRel');
			$('#campoCorpRel').hide();
			$('#campoCorpRellbl').hide();
		}
		if($('#clasificacion').val() == 'C' && !( $('#tipoPersona2').is(':checked'))){
			mensajeSis('Para Seleccionar la Opción de Cliente Corporativo Necesita ser una Persona Moral');
			$('#tipoPersona2').focus().select();
			$('#clasificacion').val('I');
		}

		if($('#clasificacion').val() == 'N'){
				$('#cteCorpInst').show();
				$('#cteCorpNom').show();
				if(( $('#tipoPersona1').is(':checked'))){
					mensajeSis('Para Seleccionar la Opción de Cliente Corporativo Nómina Necesita ser una Persona Moral o Persona Física con Actividad Empresarial');
					$('#clasificacion').focus();
					$('#clasificacion').val('I');
					$('#cteCorpInst').hide();
					$('#cteCorpNom').hide();
				}
		}else{
			limpiaForm('#cteCorpNom');
			$('#cteCorpNom').hide();
			$('#cteCorpInst').hide();
		}

		if($('#clasificacion').val() == 'F'){
			$('#negAfilia').show();
			$('#negAfiliaNom').show();
			if(!( $('#tipoPersona2').is(':checked'))){
				mensajeSis('Para Seleccionar la Opción de Negocio Afiliado Necesita ser una Persona Moral');
				$('#tipoPersona2').focus().select();
				$('#clasificacion').val('I');
				$('#negAfilia').hide();
				$('#negAfiliaNom').hide();
			}
		}else{
			limpiaForm('#negAfiliaNom');
			$('#negAfilia').hide();
			$('#negAfiliaNom').hide();
		}
		if($('#clasificacion').val() == 'M'){
			$('#datosNomina').show();
			consultaTipoPuestos();
		}else{
			$('#datosNomina').hide();
			$('#noEmpleado').val('');
			$('#tipoEmpleado').val('');
			$('#tipoPuestoID').val('');   /*TIPO PUESTO*/

		}



	});

	$.validator.setDefaults({
		submitHandler : function(event) {

			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','numero','exitoTransCliente','falloTransCliente');

		}
	});

	$('#agrega').click(function() { // IALDANA T_15553 Validación para que no deje guardar cuando la antiguedad de trabajo sea mayor a 99 años
		if( $('#antiguedadTra').val() > 99 ){
			mensajeSis('La Antig&uuml;edad de Trabajo no puede ser Mayor a 99 A&ntilde;os');
		} else {
			limpiaChecks();
			$('#tipoTransaccion').val(catTipoTransaccionCliente.agrega);
		}
	});

	$('#modifica').click(function() {
		if( $('#antiguedadTra').val() > 99 ){
			mensajeSis('La Antig&uuml;edad de Trabajo no puede ser Mayor a 99 A&ntilde;os');
		} else {
			limpiaChecks();
			$('#tipoTransaccion').val(catTipoTransaccionCliente.modifica);
		}
	});

	$('#actualiza').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionCliente.actualiza);
	});

	$('#generar').click(function() {
		if($('#primerNombre').val()!=''){
		if($('#apellidoPaterno').val()!=''|| $('#apellidoMaterno').val()!=''){


		if ($('#fechaNacimiento').val()!=''){
			//Estableciendo el bloqueo de pantalla mientras se genera el RFC
			$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
			$('#contenedorForma').block({
				message: $('#mensaje'),
				css: {border:		'none',
					background:	'none'}
			});
			formaRFC();
			$('#RFC').focus();
			$('#RFC').select();
		}else{
			mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
		}
	}else{
		mensajeSis("Los campos Apellidos Paterno y Materno están vacios debe ingresar uno de ellos");
			$('#apellidoPaterno').focus();
	}
	}else{
		mensajeSis("El Nombre es requerido para esta operación");
		$('#primerNombre').focus();
	}

	});

	$('#generarc').click(function() {
		if ($('#fechaNacimiento').val()!=''){
			formaCURP();
			$('#CURP').focus();
			$('#CURP').select();
		}else{
			mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
		}
	});

	$('#institNominaID').bind('keyup',function(e) {
		var NumNom=$('#institNominaID').val();
		lista('institNominaID', '3', '1', 'institNominaID',NumNom,'institucionesNomina.htm');
	});
	$('#negocioAfiliadoID').bind('keyup',function(e) {
		var NumNeg=$('#negocioAfiliadoID').val();
		lista('negocioAfiliadoID', '3', '2', 'negocioAfiliadoID',NumNeg,'listaNegociosAfiliados.htm');
	});

	$('#clienteIDf').bind('keyup',function(e){
		if($('#clienteIDf').val().length<3){
			$('#cajaListaCte').hide();
		}else{
			lista('clienteIDf', '3', '1', 'nombreCompleto', $('#clienteIDf').val(), 'listaCliente.htm');
		}
	});


	$('#clienteIDf').blur(function() {
		consultaCliente('clienteIDf');
	});

	$('#numero').bind('keyup',function(e) {
				lista('numero', '3', '1', 'nombreCompleto', $('#numero').val(), 'listaCliente.htm');
	});

	$('#buscarMiSuc').click(function(){
		listaCte('numero', '3', '19', 'nombreCompleto', $('#numero').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('numero', '3', '1', 'nombreCompleto', $('#numero').val(), 'listaCliente.htm');
	});

	$('#numero').blur(function() {
		deshabilitaControl('sucursalOrigen');
		if(isNaN($('#numero').val()) ){
				inicializaForma('formaGenerica', 'numero');
				//METODO EDITA SUCURSAL
				consultaModificaSuc();
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica','submit');
			}else   {
				if( $('#numero').val() =='0' ){

					limpiaDatosPersonaMoral();
					limpiaDatosPersonaFisica();
					validaDatosLaborales("","F");
					varSeleccionaMoral='N';
					//METODO EDITA SUCURSAL
					consultaModificaSuc();
					habilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica','submit');
				}
				$("#ocupaTab").val('1');
				consultaTipoPuestos();

				var clienteExpediente = $('#numero').asNumber();
				if(clienteExpediente>0){
					expedienteBean = consultaExpedienteCliente(clienteExpediente);
					if(expedienteBean.tiempo<=1){
						validaCliente(this,0);
					} else {
						limpiaForm($('#formaGenerica'));
						mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar');
						deshabilitaBoton('modifica','submit');
						deshabilitaBoton('agrega','submit');
						$('#numero').focus();
						$('#numero').select();
					}
				} else if(clienteExpediente==0) {
					validaCliente(this,0);
				}
			}
	});

	$('#actividadBancoMX').bind('keyup',function(e) {
		lista('actividadBancoMX', '3', '1','descripcion', $('#actividadBancoMX').val(),'listaActividades.htm');
	});

	$('#actividadBancoMX').blur(function() {
		consultaActividadBMX(this.id);
	});

	$('#agrega').attr('tipoTransaccion', '1');
	$('#modifica').attr('tipoTransaccion', '2');

	$('#ocupacionID').bind('keyup',function(e) {
		lista('ocupacionID', '1', '1', 'descripcion',$('#ocupacionID').val(),'listaOcupaciones.htm');
	});


	$('#ocupacionID').blur(function() {
		$("#ocupaTab").val('2');
		if($('#tipoPersona1').attr('checked')==true || $('#tipoPersona3').attr('checked')==true){
			consultaOcupacion(this.id);
		}
	});

	$('#promotorInicial').bind('keyup',function(e) {
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#promotorInicial').val();
		if(editaSucursal=="N"){
			parametrosLista[1] = parametroBean.sucursal;
		}else{
			parametrosLista[1] =$('#sucursalOrigen').val();
		}
		lista('promotorInicial', '1', '4',camposLista, parametrosLista, 'listaPromotores.htm');
	});

	$('#promotorInicial').blur(function() {
		if(isNaN($('#promotorInicial').val()) || $('#promotorInicial').val()==""){
			$('#promotorInicial').val('');
			$('#nombrePromotorI').val('');
			$('#promotorInicial').focus();
		}else{
			consultaPromotorI(this.id, 'nombrePromotorI', true);
			($('#actividadINEGI').val());
			($('#sectorEconomico').val());
		}
	});

	$('#promotorActual').bind('keyup',function(e) {
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#promotorActual').val();
		if(editaSucursal=="N"){
			parametrosLista[1] = parametroBean.sucursal;
		}else{
			parametrosLista[1] =$('#sucursalOrigen').val();
		}
		lista('promotorActual', '1', '4',camposLista, parametrosLista, 'listaPromotores.htm');
	});

	$('#institNominaID').blur(function() {
		if(esTab){
			consultaCteNomina('institNominaID');
		}
	});

	$('#negocioAfiliadoID').blur(function() {
		if(esTab){
			consultaCteNegocio('negocioAfiliadoID');
		}
	});

	$('#promotorActual').blur(function() {
		if(isNaN($('#promotorActual').val()) || $('#promotorActual').val()==""){
			$('#promotorActual').val('');
			$('#nombrePromotorA').val('');
			$('#promotorActual').focus();
		}else{
			consultaPromotorI(this.id, 'nombrePromotorA', true);
		}
	});

	$('#sucursalOrigen').bind('keyup',function(e) {
		lista('sucursalOrigen', '1', '1','nombreSucurs', $('#sucursalOrigen').val(), 'listaSucursales.htm');
	});

	$('#sucursalOrigen').blur(function() {
		if(esTab && !isNaN($('#sucursalOrigen').val()) && $('#sucursalOrigen').val()!=""){
			consultaSucursal(this.id);
		}else{
			$("#sucursalOrigen").val("");
			$("#sucursalO").val("");
			$('#sucursalOrigen	').focus();
		}
	});

	$('#sucursalOrigen').change(function() {
		if(editaSucursal=="S"){
			$('#promotorInicial').val("");
			$('#nombrePromotorI').val("");
			$('#promotorActual').val("");
			$('#nombrePromotorA').val("");
		}
	});

	$('#paisResidencia').bind('keyup',function(e) {
		lista('paisResidencia', '1', '1', 'nombre', $('#paisResidencia').val(),'listaPaises.htm');
	});

	$('#paisResidencia').blur(function() {
		if(esTab){
			consultaPais(this.id);
		}
	});

	$('#lugarNacimiento').bind('keyup',function(e) {
		lista('lugarNacimiento', '1', '1', 'nombre', $('#lugarNacimiento').val(),'listaPaises.htm');
	});

	$('#lugarNacimiento').blur(function() {
		if(esTab){
			consultaPaisNac(this.id);
		}
	});

	$('#paisNacionalidad').bind('keyup',function(){
		lista('paisNacionalidad', '1', '1', 'nombre', $('#paisNacionalidad').val(),'listaPaises.htm');
	});

	$('#paisNacionalidad').blur(function(){
		if(esTab){
			consultaPaisNacionalidad(this.id);
		}
	});

	$('#grupoEmpresarial').bind('keyup',function(e) {
		lista('grupoEmpresarial', '3', '1','nombreGrupo', $('#grupoEmpresarial').val(), 'listaEmpresas.htm');
	});

	$('#grupoEmpresarial').blur(function() {
		if(esTab){
			consultaGEmpres(this.id);
		}
	});

	$('#estadoID').bind('keyup',function(e) {
		lista('estadoID', '2', '1', 'nombre',$('#estadoID').val(),'listaEstados.htm');
	});

	$('#estadoID').blur(function() {
		if(esTab){
			consultaEstado(this.id);
		}

	});

	$('#sectorGeneral').bind('keyup',function(e) {
		lista('sectorGeneral', '2', '1', 'descripcion',$('#sectorGeneral').val(),'listaSectores.htm');
	});

	$('#sectorGeneral').blur(function() {
		consultaSecGeneral(this.id);
	});

	$('#tipoSociedadID').bind('keyup',function(e) {
		lista('tipoSociedadID', '2', '1','descripcion', $('#tipoSociedadID').val(),'listaTipoSociedad.htm');
	});

	$('#tipoSociedadID').blur(function() {
		if(esTab){
			consultaSociedad(this.id);
		}
	});

	$('#prospectoID').blur(function() {
		if(esTab){
			consultaProspecto('prospectoID');
		}
	});

	$('#prospectoID').bind('keyup',function(e){
		lista('prospectoID', '1', '1', 'prospectoID', $('#prospectoID').val(), 'listaProspecto.htm');
	});

	$('#paisFea').bind('keyup',function(e) {
		lista('paisFea', '1', '1', 'nombre', $('#paisFea').val(),'listaPaises.htm');
	});

	$('#paisFea').blur(function() {
		if(esTab){
			consultaPaisF(this.id);
		}
	});

	$('#paisFeaPM').bind('keyup',function(e) {
		lista('paisFeaPM', '1', '1', 'nombre', $('#paisFeaPM').val(),'listaPaises.htm');
	});

	$('#paisFeaPM').blur(function() {
		if(esTab){
			consultaPaisF(this.id);
		}
	});
	// eventos campos persona morales

	$('#paisConstitucionID').bind('keyup',function(e) {
		lista('paisConstitucionID', '1', '1', 'nombre', $('#paisConstitucionID').val(),'listaPaises.htm');
	});

	$('#paisConstitucionID').blur(function() {
		if(esTab){
			consultaPaisNac(this.id);
		}
	});

	$('#corpRelacionado').blur(function() {
		var numCliente=$('#corpRelacionado').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if ( !isNaN(numCliente) && Number(numCliente)>0) {
			clienteServicio.consulta(Number(catTipoConsultaCliente.corporativos), numCliente,"",function(cliente) {
				if (cliente != null) {
					$('#corpRelacionado').val(cliente.numero);
					$('#nomRelCorp').val(cliente.nombreCompleto);
				} else {
					mensajeSis("No Existe el Corporativo");
					$('#corpRelacionado').val('');
					$('#nomRelCorp').val('');
				}
			});
		}else{
			$('#corpRelacionado').val('');
			$('#nomRelCorp').val('');
		}
	});

	$('#corpRelacionado').bind('keyup',function(e) {
		lista('corpRelacionado', '3', '3', 'nombreCompleto', $('#corpRelacionado').val(), 'listaCliente.htm');
	});

	$("#telefonoCelular").setMask('phone-us');
	$("#telefonoCasa").setMask('phone-us');
	$("#telTrabajo").setMask('phone-us');
	$("#telefonoPM").setMask('phone-us');


	$("#telefonoCasa").blur(function(){
		if($("#telefonoCasa").val() == ''){
			$('#extTelefonoPart').val('');
		}
	});

	$("#extTelefonoPart").blur(function(){
		if(esTab){
			if(this.value != ''){
				if($("#telefonoCasa").val() == ''){
					this.value = '';
					mensajeSis("El Número de Teléfono está Vacío");
					$("#telefonoCasa").focus();
				}
			}
		}
	});

	$("#telTrabajo").blur(function(){
		if($("#telTrabajo").val() == ''){
			$('#extTelefonoTrab').val('');
		}
	});

	$("#extTelefonoTrab").blur(function(){
		if(esTab){
			if(this.value != ''){
				if($("#telTrabajo").val() == ''){
					this.value = '';
					mensajeSis("El Número de Teléfono está Vacío");
					$("#telTrabajo").focus();
				}
			}
		}
	});

	$("#telefonoPM").blur(function(){
		if($("#telefonoPM").val() == ''){
			$('#extTelefonoPM').val('');
		}
	});

	$("#extTelefonoPM").blur(function(){
		if(esTab){
			if(this.value != ''){
				if($("#telefonoPM").val() == ''){
					this.value = '';
					mensajeSis("El Número de Teléfono está Vacío.");
					$("#telefonoPM").focus();
				}
			}
		}
	});
	// ------------ Validaciones de la Forma
	$('#formaGenerica').validate({
		rules : {
			numero : {
				required : false
			},

			titulo : {
				required : true
			},

			primerNombre : {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true},
				minlength : 1,
				maxlength :20
			},

			apellidoPaterno: {
				required : function() {if(validaApellidos('apellidoMaterno')) return true; else return false},// IALDANA TICKET 13494
				minlength : 2
			},



			telefonoCelular: {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true},
				minlength : 14
			},
			razonSocial : {
				required : function() {return $('#tipoPersona2').is(':checked'); },
				minlength : 2
			},
			direccion : 'required',

			correo : {
				required : false,
				email : true
			},

			sucursalOrigen : 'required',

			CURP : {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true},
				maxlength : 18
			},

			RFC : {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return $('#tipoPersona1').is(':checked') || $('#registroHaciendaSi').is(':checked')},
				minlength	: function() { if($('#tipoPersona1').is(':checked') && $('#registroHaciendaSi').is(':checked')){
					minCaracteres=13;
				return 13;
			}  else{
				minCaracteres=10;
				return 10} },
			maxlength	: 13,
			},
			RFCpm : {
				required : function() {return $('#tipoPersona2').is(':checked');},
				minlength : function() { if($('#tipoPersona2').is(':checked')) return 12; else return 0}
			},

			clasificacion : {
				required : true
			},

			motivoApertura : {
				required : true
			},

			sectorGeneral : 'required',

			actividadBancoMX : {
				required: true,
			    numeroPositivo: true
			},


			fechaNacimiento : {required : function() {return $('#tipoPersona1').is(':checked');},
				date: true
			},

			lugarNacimiento : {required : function() {return $('#tipoPersona1').is(':checked');}
			},
			ocupacionID : {
				required : function() {return $('#tipoPersona1').is(':checked');}
			},
			paisResidencia : {required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true}},

			corpRelacionado: {
				required : function() {return $('#clasificacion').val() == 'R';}
			},
			registroHacienda: { //--
				required : true,
			},
			institNominaID: {
				required : function() {return $('#clasificacion').val() == 'N';}
			},
			negocioAfiliadoID: {
				required : function() {return $('#clasificacion').val() == 'F';}
			},
			tipoEmpleado: {
				required : function() {return $('#clasificacion').val() == 'M';}
			},
			tipoPuestoID: {
				required : function() {return $('#clasificacion').val() == 'M';}
			},
			extTelefonoPart: {
				number: true,
			},
			extTelefonoTrab: {
				number:true,
			},

			promotorExtInv : {
				required : function() {return $('#muestraEjec').val() == '1';}
			},
			correoPM : {
				required : false,
				email : true
			},

			correoAlterPM : {
				required : false,
				email : true
			},
			extTelefonoPM: {
				number:true,
			},

			paisConstitucionID : {
				required : function() {return $('#tipoPersona2').is(':checked');}
			},

			tipoSociedadID : {
				required : function() {return $('#tipoPersona2').is(':checked');}
			},

			fechaRegistroPM : {
				required : function() {return $('#tipoPersona2').is(':checked');},
				date: true
			},

			nombreNotario : {
				required : function() {return $('#tipoPersona2').is(':checked');}
			},

			numNotario : {
				required : function() {return $('#tipoPersona2').is(':checked');},
				number: true
			},

			inscripcionReg : {
				required : function() {return $('#tipoPersona2').is(':checked');}
			},
			titulo : {
				required :  function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			nacion : {
				required :  function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			sexo : {
				required :  function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			estadoCivil : {
				required :  function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			nacionalidadPM : {
				required :  function() { if($('#tipoPersona2').is(':checked')) return true; else return false}
			},

			escrituraPubPM : {
				required : function() {return $('#tipoPersona2').is(':checked');}
			},
			fechaConstitucion : { required : function(){
				if(($('#tipoPersona3').is(':checked'))&&($('#nacion').val().trim()=='N')){
					return true;
				} else {
					return false;
				}
				},
				date: true
			},
			promotorInicial : {
				required : true
			},
			promotorActual : {
				required : true
			},
			estadoID : {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true},
			},

			actividadFR: {
				required: true
			},
			paisNacionalidad: { required : function() {return $('#tipoPersona1').is(':checked');}
			}
		},

		messages : {
			primerNombre : {
				required : 'Especifique nombre',
				minlength : 'Al menos un Carácter'
			},

			apellidoPaterno : {
				required : 'Especifique Apellido Paterno',
				minlength : 'Al menos dos Caracteres'
			},



			telefonoCelular : {
				required : 'Especifique Teléfono Celular',
				minlength : 'Requiere 10 caracteres'
			},

			titulo : {
				required : 'Especifique Titulo',
				minlength : 'Al menos dos Caracteres'
			},

			correo : {
				required : 'Especifique un Correo Electrónico',
				email : 'Dirección Inválida'
			},

			direccion : 'Especifique Dirección',

			representanteLegal : {
				required : 'Especifique Representante Legal',
				minlength : 'Al menos tres Caracteres'
			},
			razonSocial : {
				required : 'Especifique Razón Social',
				minlength : 'Al menos dos Caracteres'
			},

			sucursalOrigen : 'Especifique Sucursal',

			CURP : {
				required : 'Especifique CURP',
				maxlength : 'Máximo 18 caracteres'
			},

			RFC	: {
				required	: 'Especifique RFC.',
				minlength	: $.validator.format("Mínimo {0} caracteres."),
				maxlength	: "Máximo 13 caracteres."
			}	,

			RFCpm :{
				required : 'Especifique RFC',
				minlength : 'Minimo 12 carácteres'

			},

			clasificacion : {
				required : 'Especifique Clasificacion',
			},

			motivoApertura : {
				required : 'Especifique Motivo Apertura'
			},

			sectorGeneral : 'Especifique Sector General',

			actividadBancoMX : {
				required: 'Especifique la Actividad BMX',
				numeroPositivo : "Sólo números"
			},

			fechaNacimiento : {
				required : 'Especifique Fecha de Nacimiento',
				date : 'Fecha Incorrecta'
			},

			lugarNacimiento : {
				required : 'Especifique Lugar de Nacimiento'
			},
			ocupacionID : {
				required : 'Especifique la Ocupación del Cliente'
			},
			paisResidencia : {
				required: 'Especifique País de Residencia'
			},
			corpRelacionado : {
				required : 'Especifique el Corporativo Relacionado al Cliente.'
			},
			registroHacienda: {
				required: 'Especifique si está dado de Alta en Hacienda'
			},
			institNominaID: {
				required : 'Especifique la Institución de Nómina'
			},
			negocioAfiliadoID: {
				required : 'Especifique el Negocio Afiliado'
			},
			tipoEmpleado: {
				required : 'Especifique un Tipo de Empleado'
			},
			tipoPuestoID: {
				required : 'Especifique un Tipo de Puesto'
			},
			extTelefonoPart:{
				number:'Sólo Números (Campo opcional)'
			},
			extTelefonoTrab:{
				number:'Sólo Números (Campo opcional)'
			},

			promotorExtInv : {
				required : 'Especifique Promotor externo de Inversión'

			},

			correoPM : {
				required : 'Especifique Correo.',
				email : 'Dirección Inválida.'
			},

			correoAlterPM : {
				required : 'Especifique Correo Alternativo.',
				email : 'Dirección Inválida.'
			},
			extTelefonoPM:{
				number:'Sólo Números(Campo opcional).'
			},

			paisConstitucionID : {
				required : 'Especifique País de Constitución.'
			},

			tipoSociedadID : {
				required : 'Especifique Tipo de Sociedad.'
			},

			fechaRegistroPM : {
				required : 'Especifique Fecha de Registro.',
				date : 'Fecha Incorrecta.'
			},

			nombreNotario : {
				required : 'Especifique Nombre Notario.'
			},

			numNotario : {
				required : 'Especifique No. Notario.',
				number:'Sólo Números.'
			},

			inscripcionReg : {
				required : 'Especifique Inscripción en el Registro Público.'
			},

			titulo : {
				required : 'Especifique el Título.'
			},
			nacion : {
				required :  'Especifique la Nacionalidad.'
			},
			sexo : {
				required :  'Especifique el Género.'
			},
			estadoCivil : {
				required :  'Especifique el Estado Civil.'
			},
			nacionalidadPM : {
				required :  'Especifique la Nacionalidad.'
			},

			escrituraPubPM : {
				required : 'Especifique Escritura Pública.'
			},

			fechaConstitucion : {
				required : 'Especifique Fecha de Constitución',
				date : 'Fecha Incorrecta'
			},
			promotorInicial :{
				required : 'Especifique el Promotor Inicial'
			},
			promotorActual :{
				required : 'Especifique el Promotor Actual'
			},
			estadoID : {
				required : "Especifique Entidad Federativa"
			},
			actividadFR: {
				required: "Especifique Actividad FR"
			},
			paisNacionalidad : {
				required : "Especifique país de Nacionalidad"
			}

		}
	});



	$('#ejecutivoCap').bind('keyup',function(e) {
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#ejecutivoCap').val();
		parametrosLista[1] = parametroBean.sucursal;
		lista('ejecutivoCap', '2', '8',camposLista, parametrosLista, 'listaPromotores.htm');
	});


	$('#promotorExtInv').bind('keyup',function(e) {
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "numero";
		camposLista[1] = "nombre";
		parametrosLista[0] = $('#promotorExtInv').val();
		parametrosLista[1] = parametroBean.sucursal;
		lista('promotorExtInv', '2', '7',camposLista, parametrosLista, 'listaPromotores.htm');
	});

	consultaPromotorActiva('empresa');


		// ------------ Validaciones de Controles-------------------------------------

	function consultaProspecto(idControl) {

		var jqProspecto = eval("'#" + idControl + "'");
		var numProspecto = $(jqProspecto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProspecto != '' && !isNaN(numProspecto) && esTab){
			deshabilitaBoton('agrega', 'submit');
			habilitaBoton('modifica', 'submit');
			var prospectoBeanCon ={
		 		 	'prospectoID' : numProspecto
			};
			prospectosServicio.consulta(catTipoConsultaProspec.principal,prospectoBeanCon,function(prospectos) {
				if(prospectos!=null){
					if(prospectos.cliente>0){
						$('#numero').val(prospectos.cliente);
						$('#prospectoID').val(prospectos.prospectoID);
						$('#nombreProspecto').val(prospectos.nombreCompleto);
						esTab=true;
						validaCliente('numero',prospectos.prospectoID);
						$('#prospectoID').val(prospectos.prospectoID);
						$('#nombreProspecto').val(prospectos.nombreCompleto);
					}else{


						$('#prospectoID').val(prospectos.prospectoID);
						$('#nombreProspecto').val(prospectos.nombreCompleto);
						$('#numero').val("0",prospectos.prospectoID);
						validaCliente('numero',prospectos.prospectoID);

						if (prospectos.tipoPersona == 'F') {
							$('#tipoPersona1').attr('checked', true);
							$('#tipoPersona2').attr('checked',false);
							$('#tipoPersona3').attr('checked',false);
							permiteCalcularCURPyRFC('','generar',2);
							$('#registrofea').hide(500);
							$('#fea').val('');
							$('#paisFea').val('');
							$('#paisF').val('');
							$('#cuentaConFEA').hide(500);
							$('#paisFeal').hide(500);
							$('#ocupacionID').val('');
							$('#pagaIVA').val('S');
							$('#pagaISR').val('S');
						}

							if (prospectos.tipoPersona == 'A') {
								$('#tipoPersona3').attr('checked',true);
								$('#tipoPersona2').attr('checked','false');
								$('#tipoPersona1').attr('checked','false');
								$('#pagaIVA').val('S');
								$('#pagaISR').val('S');
								$('#registrofea').hide(500);
							}
							if (prospectos.tipoPersona == 'M'){
								$('#tipoPersona2').attr("checked",true);
								$('#tipoPersona1').attr("checked",false);
								$('#tipoPersona3').attr("checked",false);
								$('#generar').hide(500);
								$('#grupoEmpresarial').val("");
								$('#registrofea').hide(500);
							}
						validaDatosLaborales(prospectos,prospectos.tipoPersona);

						$('#razonSocial').val(prospectos.razonSocial);
						$('#primerNombre').val(prospectos.primerNombre);
						$('#segundoNombre').val(prospectos.segundoNombre);
						$('#tercerNombre').val(prospectos.tercerNombre);
						$('#apellidoPaterno').val(prospectos.apellidoPaterno);
						$('#apellidoMaterno').val(prospectos.apellidoMaterno);
						$('#RFC').val(prospectos.RFC);
						$('#fechaNacimiento').val(prospectos.fechaNacimiento);
						$('#estadoCivil').val(prospectos.estadoCivil);
						$('#telefonoCelular').val(prospectos.telefono);

						$('#telefonoCasa').val(prospectos.telefono);
						$('#prospectoID').val(prospectos.prospectoID);
						$('#nombreProspecto').val(prospectos.nombreCompleto);
						$('observacionesPM').val(prospectos.observaciones);




						if(prospectos.clasificacion=='M')
						$('#datosNomina').show();
						else
						$('#datosNomina').hide();
						// setea los valores del prospecto a la pantalla de cliente.
						dwr.util.setValues(prospectos);

						consultaPaisNac('lugarNacimiento');
						$('#paisResidencia').val(prospectos.paisResidenciaID);
						$('#paisR').val(prospectos.paisResidencia);

						consultaEstado('estadoID');
						consultaOcupacion('ocupacionID');

						var select =	eval("'#sexo option[value="+prospectos.sexo+"]'");

					   $(select).attr('selected','true');
						   if(prospectos.registroHacienda=='S'){
							$('#registroHaciendaSi').attr("checked",true);
							$('#registroHaciendaNo').attr("checked",false);
						}else if(prospectos.registroHacienda=='N'){
							$('#registroHaciendaNo').attr("checked",true);
							$('#registroHaciendaSi').attr("checked",false);
							}
						   /*En el caso de uan persona moral como prospecto
						    * el campo nacionalidadPM se queda vacio y con esto
						    * se cambia la nacion al campo nacionalidadPM y nacion
						    * pasas a estar vacio ya que no es funcional para la persona
						    * moral*/
						 if(prospectos.tipoPersona=='M'){
							$('#nacionalidadPM').val(prospectos.nacion);
							$('#nacion').val('');
						}
					}

				}else{
					mensajeSis("No Existe el Prospecto");
					$('#prospectoID').val("0");
					$('#nombreProspecto').val("");
					$('#numero').val("0");
					validaCliente('numero',	$('#prospectoID').val());
				}
			});
		}
	}


	// a traves de un numero de cliente consulta el numero de prospecto
	function consultaProspectoCliente(idControl) {
		var jqCte = eval("'#" + idControl + "'");
		var numCte = $(jqCte).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCte != '' && !isNaN(numCte) && esTab){
			deshabilitaBoton('agrega', 'submit');
			habilitaBoton('modifica', 'submit');
			var prospectoBeanCon ={
		 		 	'cliente' : numCte
			};
			prospectosServicio.consulta(catTipoConsultaProspec.prospectoCliente,prospectoBeanCon,{ async: false, callback:function(prospectos) {
				if(prospectos!=null){
					if(prospectos.prospectoID>0){
						$('#numero').val(prospectos.cliente);
						$('#prospectoID').val(prospectos.prospectoID);
						$('#nombreProspecto').val(prospectos.nombreCompleto);
						$('#lblProspecto').show();
						$('#inputProspectoID').show();
					}else{
						$('#numero').val(prospectos.cliente);
						$('#prospectoID').val(prospectos.prospectoID);
						$('#nombreProspecto').val(prospectos.nombreCompleto);
						$('#lblProspecto').hide();
						$('#inputProspectoID').hide();

					}
				}else{

					$('#prospectoID').val("0");
					$('#nombreProspecto').val("");
					$('#lblProspecto').hide();
					$('#inputProspectoID').hide();

				}
				}
			});
		}
	}


	function validaNacionalidadCte(){
		if($('#tipoPersona2').is(':checked')){
			var nacionalidad = $('#nacionalidadPM').val();
			var pais= $('#paisConstitucionID').val();
		}else{
		var nacionalidad = $('#nacion').val();
		var pais= $('#lugarNacimiento').val();
		}
		var mexico='700';
		var nacdadMex='N';
		var nacdadExtr='E';

		if(nacionalidad==nacdadMex){
			if(pais!=mexico && pais!=''){
				mensajeSis("Por la Nacionalidad de la Persona el País debe ser México.");
				if($('#tipoPersona2').is(':checked')){
					$('#paisConstitucionID').focus();
					$('#paisConstitucionID').val('');
					$('#descPaisConst').val('');
				}else{
				$('#lugarNacimiento').focus();
				$('#lugarNacimiento').val('');
				$('#paisNac').val('');
			}
		}
		}
		if(nacionalidad==nacdadExtr){
			if(pais==mexico){
				mensajeSis("Por la Nacionalidad de la Persona el País No debe ser México.");
				if($('#tipoPersona2').is(':checked')){
					$('#paisConstitucionID').val('');
					$('#paisConstitucionID').focus();
					$('#descPaisConst').val('');
				}else{
				$('#lugarNacimiento').val('');
				$('#lugarNacimiento').focus();
				$('#paisNac').val('');
				}


			}
		}
	}


	function validaCliente(control,valorProspecto) {
		var numCliente = $('#numero').val();
		var ConttipoInactiva=0;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente) && esTab) {
				if (numCliente == '0') {
					$('#sucursalOrigen').val(parametroBean.sucursal);
					$('#sucursalO').val(parametroBean.nombreSucursal);
					$('#tipoPersona1').attr("checked", true);
					$('#registrofea').hide(500);
		            varSeleccionaMoral = 'N';
					validaDatosLaborales("","F");
					habilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
					habilitaControl('promotorInicial');
					habilitaControl('promotorActual');
					inicializaForma('formaGenerica', 'numero');
					limpiarDatos();
					consultaPromotorActiva('empresa');
					$('#prospectoID').val('');
					$('#nombreProspecto').val('');
					dwr.util.removeAllOptions('descripcionActFR2');
		            dwr.util.removeAllOptions('desActFomur2');
		            $('#sexo').val('');
		            $('#paisResidencia').val('');
		            $('#paisR').val('');
		            $('#esMenorEdad').val('N');
					if($('#prospectoID').asNumber()>0){

					}else{
						$('#tipoPersona1').attr("checked", "1");
						permiteCalcularCURPyRFC('','generar',2);
						$('#registrofea').hide(500);
						$('#fea').val('');
						$('#paisFea').val('');
						$('#paisF').val('');
						$('#nacion').val('');
						$('#prospectoID').val("");
						$('#nombreProspecto').val("");
						$('#lblProspecto').show();
						$('#inputProspectoID').show();
						$('#sucursalOrigen').val(parametroBean.sucursal);
						$('#sucursalO').val(parametroBean.nombreSucursal);
					}
				} else {

					if($('#prospectoID').asNumber()>0){
						$('#lblProspecto').show();
						$('#inputProspectoID').show();
					}else{
						$('#lblProspecto').hide();
						$('#inputProspectoID').hide();
						$('#prospectoID').val("");
						$('#nombreProspecto').val("");
					}

					$('#tipoPersona1').focus();
					deshabilitaBoton('agrega', 'submit');
					habilitaBoton('modifica', 'submit');
					clienteServicio.consulta(1,numCliente,function(cliente) {
						consultaPromotorActiva('empresa');
						if (cliente != null) {
							listaPersBloqBean =consultaListaPersBloq(numCliente,'CTE',0,0);
							consultaSPL = consultaPermiteOperaSPL(numCliente,'LPB','CTE');
							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
								if (cliente.tipoInactiva==11){
									ConttipoInactiva ++;
								}

								if(ConttipoInactiva == 0){
									if(cliente.tipoPersona == 'M' || (cliente.esMenorEdad == 'N' || cliente.esMenorEdad == null|| cliente.esMenorEdad == '')){
										dwr.util.setValues(cliente);
										esTab = true;
										consultaProspectoCliente('numero');
										if(cliente.clasificacion=='M'){
											$('#datosNomina').show();
										} else {
											$('#datosNomina').hide();
										}
										if (cliente.fechaNacimiento == '1900-01-01'){
											$('#fechaNacimiento').val('');
										} else {
											$('#fechaNacimiento').val(cliente.fechaNacimiento);
										}
										if (cliente.tipoPersona == 'F') {
											limpiaDatosPersonaMoral();
											$('#tipoPersona1').attr("checked",true);
											$('#tipoPersona2').attr("checked",false);
											$('#tipoPersona3').attr("checked",false);
											permiteCalcularCURPyRFC('','generar',2);
											$('#registroFEA').hide(500);
											$('#fea').val('');
											$('#paisFea').val('');
											$('#paisF').val('');
											if(cliente.ocupacionID != 0){
												$('#ocupacionID').val(cliente.ocupacionID);

											}else{
												$('#ocupacionID').val('');
											}
											$('#pagaIVA').val('S');
											$('#pagaISR').val('S');
											consultaOcupacion('ocupacionID');
											$('#datosPersonaFisica').show(500);
							                            $('#datosAdicionalesPF').show(500);
							                            $('#nacion').val(cliente.nacion);
							                            varSeleccionaMoral = 'N';
										} else {
											if (cliente.tipoPersona == 'A') {
												limpiaDatosPersonaMoral();
												$('#tipoPersona3').attr("checked", true);
												$('#tipoPersona2').attr("checked",false);
												$('#tipoPersona1').attr("checked",false);
												$('#datosPersonaFisica').show(500);
												$('#datosAdicionalesPF').show(500);
												$('#registroFEA').show(500);
												consultaPaisFea('paisFea');

												if(cliente.ocupacionID != 0){
													$('#ocupacionID').val(cliente.ocupacionID);
												}
												$('#pagaIVA').val('S');
												$('#pagaISR').val('S');
												consultaOcupacion('ocupacionID');
												$('#nacion').val(cliente.nacion);
												varSeleccionaMoral = 'N';
											}
											if (cliente.tipoPersona == 'M'){
												limpiaDatosPersonaFisica();
												$('#tipoPersona2').attr("checked", true);
												$('#tipoPersona1').attr("checked",false);
												$('#tipoPersona3').attr("checked",false);
												$('#generar').hide(500);
												$('#grupoEmpresarial').val(cliente.grupoEmpresarial);
												consultaGEmpres('grupoEmpresarial');
												$('#datosPersonaFisica').hide(500);
												$('#datosAdicionalesPF').hide(500);
												$('#nacionalidadPM').val(cliente.nacion);
												consultaPaisNac('paisConstitucionID');
												$('#correoPM').val(cliente.correo);
												$('#telefonoPM').val(cliente.telefonoCasa);
												$('#extTelefonoPM').val(cliente.extTelefonoPart);
												$('#fechaRegistroPM').val(cliente.fechaConstitucion);
												varSeleccionaMoral = 'S';
												$('#feaPM').val(cliente.fea);
												$('#paisFeaPM').val(cliente.paisFea);
												consultaPaisFea('paisFeaPM');
												$('#telefonoPM').setMask('phone-us');
												$('#observacionesPM').val(cliente.observaciones);
											}
										}
										validaDatosLaborales(cliente,cliente.tipoPersona);
										if(cliente.paisFea==0){
											$('#paisFea').val('');
											$('#paisFeaPM').val('');

										}

										if(cliente.clasificacion == 'R'){
										// si tiene corporativo relacionado tiene algo entonces consulta el nombre del corporativo
											if(cliente.corpRelacionado != null&&cliente.corpRelacionado != ''&&cliente.corpRelacionado != undefined	&&cliente.corpRelacionado != '0'){

												clienteServicio.consulta(Number(catTipoConsultaCliente.corporativos), cliente.corpRelacionado,"",function(clienteCorp) {
												if (clienteCorp != null) {
													$('#corpRelacionado').val(clienteCorp.numero);
													$('#nomRelCorp').val(clienteCorp.nombreCompleto);
												} });
											}
											$('#campoCorpRel').show();
											$('#campoCorpRellbl').show();
										} else if(cliente.clasificacion == 'L'){
											$('#clasificacion').val('R');

											clienteServicio.consulta(Number(catTipoConsultaCliente.corporativos), cliente.corpRelacionado,"",function(clienteCorp) {
											if (clienteCorp != null) {
												$('#corpRelacionado').val(clienteCorp.numero);
												$('#nomRelCorp').val(clienteCorp.nombreCompleto);
											} });
											$('#campoCorpRel').show();
											$('#campoCorpRellbl').show();
											var consultaValidar = 3;
											var bean = {
											'clienteID':cliente.numero
											};

											tarjetaHabienteCNUnoServicio.consulta(consultaValidar, bean, function(valorRespuesta){
											if(valorRespuesta != null){
												if(Number(valorRespuesta.tarjetaDebID) != 0 ){
													mensajeSis(valorRespuesta.descripcion);
													deshabilitaBoton('agrega','submit');
													deshabilitaBoton('modifica','submit');
												}else{
													deshabilitaBoton('agrega','submit');
													habilitaBoton('modifica','submit');
												}
											}else{
												mensajeSis('Validación de Tarjeta Habiente Corporativo Nivel Uno fallida');
												deshabilitaBoton('agrega','submit');
												deshabilitaBoton('modifica','submit');
											} });
										} else {
											limpiaForm('#campoCorpRel');
											$('#campoCorpRel').hide();
											$('#campoCorpRellbl').hide();
										}

										if(cliente.clasificacion == 'N'){
											$('#cteCorpInst').show();
											$('#cteCorpNom').show();
											var consultaCteNomina = 6;
											var bean = {
											'clienteID':cliente.numero
											};

											institucionNominaServicio.consulta(consultaCteNomina, bean, function(Respuesta){
											if(Respuesta != null){
												$('#institNominaID').val(Respuesta.institNominaID);
												$('#nombreInstit').val(Respuesta.nombreInstit);
											}else{
												mensajeSis('No Existe el Cliente en la Institución ');
												$('#cteCorpInst').hide();
												$('#cteCorpNom').hide();
											} });
										}else{
											$('#institNominaID').val('');
											$('#nombreInstit').val('');
											$('#cteCorpNom').hide();
											$('#cteCorpInst').hide();
										}
										if(cliente.clasificacion == 'F'){
											$('#negAfilia').show();
											$('#negAfiliaNom').show();
											var consultaCteNegocio = 3;
											var bean = {
													'clienteID':cliente.numero
											};
											negocioAfiliadoServicio.consulta(consultaCteNegocio, bean, function(Respuesta){
												if(Respuesta != null){
													$('#negocioAfiliadoID').val(Respuesta.negocioAfiliadoID);
													$('#razonSocialNegAfi').val(Respuesta.razonSocial);
												}else{
													mensajeSis('No Existe el Cliente en el Negocio Afiliado ');
													$('#negocioAfiliadoID').val('');
													$('#razonSocialNegAfi').val('');
												}
											});

										}else{
											$('#negocioAfiliadoID').val('');
											$('#razonSocialNegAfi').val('');
											$('#negAfiliaNom').hide();
											$('#negAfilia').hide();
										}
										$('#sucursalOrigen').val(cliente.sucursalOrigen);
										consultaSucursal('sucursalOrigen');
										esTab = true;
										if (cliente.tipoPersona == 'M') {
											$('#tipoSociedadID').val(cliente.tipoSociedadID);
											consultaSociedad('tipoSociedadID');
			                           				} else {
											$('#estadoID').val(cliente.estadoID);
											consultaEstado('estadoID');
											$('#lugarNacimiento').val(cliente.lugarNacimiento);
											consultaPaisNac('lugarNacimiento');
											$('#paisResidencia').val(cliente.paisResidencia);
											consultaPais('paisResidencia');
											$('#paisNacionalidad').val(cliente.paisNacionalidad);
											if(cliente.paisNacionalidad != null){
												consultaPaisNacionalidad('paisNacionalidad');
											}
										}
										$('#sectorGeneral').val(cliente.sectorGeneral);
										consultaSecGeneral('sectorGeneral');
										$('#actividadBancoMX').val(cliente.actividadBancoMX);
										consultaActividadBMXDescrip('actividadBancoMX',cliente.actividadFR, cliente.actividadFOMUR);
										$('#promotorInicial').val(cliente.promotorInicial);
										deshabilitaControl('promotorInicial');
										consultaPromotorI('promotorInicial', 'nombrePromotorI', false);
										$('#promotorActual').val(cliente.promotorActual);
										deshabilitaControl('promotorActual');
										consultaPromotorI('promotorActual', 'nombrePromotorA', false);
										$('#tipoSociedadID').val(cliente.tipoSociedadID);
										consultaSociedad('tipoSociedadID');
										deshabilitaBoton('agrega','submit');
										habilitaBoton('modifica','submit');

										if (cliente.esMenorEdad == null){
											$('#esMenorEdad').val('N');
										}

										if (cliente.estatus=="I"){
											deshabilitaBoton('modifica','submit');
											deshabilitaBoton('agrega','submit');
											mensajeSis("El Cliente se encuentra Inactivo");
										}
										$("#telefonoCelular").setMask('phone-us');
										$("#telefonoCasa").setMask('phone-us');
										$("#telTrabajo").setMask('phone-us');

									} else {
										mensajeSis("El Cliente capturado es Socio Menor");
										inicializaForma('formaGenerica', 'numero');
										$('#numero').focus();
									}


								} else {
									limpiaForm($('#formaGenerica'));
									deshabilitaBoton('modifica','submit');
									deshabilitaBoton('agrega','submit');
									$('#numero').focus();
									mensajeSis("El Cliente se encuentra Inactivo por Mayoría de Edad");
								}

							}else{

								limpiaForm($('#formaGenerica'));
								deshabilitaBoton('modifica','submit');
								deshabilitaBoton('agrega','submit');
								$('#numero').focus();
								$('#numero').select();
								mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operacion.');
							}
						} else {
							limpiaForm($('#formaGenerica'));
							mensajeSis("No Existe el Cliente");
							deshabilitaBoton('modifica','submit');
							deshabilitaBoton('agrega','submit');
							$('#numero').focus();
							$('#numero').select();
						}
					});
				}
			}
	}

	function consultaActividadBMX(idControl) { 	//aaa
		var jqActividad = eval("'#" + idControl + "'");
		var numActividad = $(jqActividad).val();
		var tipConCompleta = 3;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numActividad != '' && !isNaN(numActividad) && esTab) {
			actividadesServicio.consultaActCompleta(tipConCompleta,	numActividad, { async: false, callback: function(actividadComp) {
				if (actividadComp != null) {

					$('#descripcionBMX').val(actividadComp.descripcionBMX);
					$('#actividadINEGI').val(actividadComp.actividadINEGIID);
					$('#descripcionINEGI').val(actividadComp.descripcionINE);
					$('#sectorEconomico').val(actividadComp.sectorEcoID);
					$('#descripcionSE').val(actividadComp.descripcionSEC);
					$('#descripcionActFR').val(actividadComp.actividadFR);
					$('#desActFomur').val(actividadComp.actividadFOMUR);

					esTab=true;
					consultaActividadFR('actividadBancoMX',actividadComp.actividadFR);
					consultaActividadFOMUR('actividadBancoMX',actividadComp.actividadFOMUR);

				} else {
					mensajeSis("No Existe la Actividad BMX");
					$('#descripcionBMX').val('');
					$('#actividadINEGI').val('');
					$('#descripcionINEGI').val('');
					$('#sectorEconomico').val('');
					$('#descripcionSE').val('');
				}
			}
			});
		}
	}

	function consultaActividadBMXDescrip(idControl,actFR, actFOMUR) {
		var jqActividad = eval("'#" + idControl + "'");
		var numActividad = $(jqActividad).val();
		var tipConCompleta = 3;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numActividad != '' && !isNaN(numActividad) && esTab) {
			actividadesServicio.consultaActCompleta(tipConCompleta,	numActividad,{ async: false, callback: function(actividadComp) {
			if (actividadComp != null) {

				$('#descripcionBMX').val(actividadComp.descripcionBMX);
				$('#actividadINEGI').val(actividadComp.actividadINEGIID);
				$('#descripcionINEGI').val(actividadComp.descripcionINE);
				$('#sectorEconomico').val(actividadComp.sectorEcoID);
				$('#descripcionSE').val(actividadComp.descripcionSEC);
				$('#descripcionActFR').val(actividadComp.actividadFR);

				esTab=true;
				if(actFR==null || actFR==""){
					consultaActividadFR('actividadBancoMX', actividadComp.actividadFR);
				}
				else{
					consultaActividadFR('actividadBancoMX', actFR);
				}
				if(actFOMUR==null || actFOMUR==""){
					consultaActividadFOMUR('actividadBancoMX', actividadComp.actividadFOMUR);
				}
				else{
					consultaActividadFOMUR('actividadBancoMX', actFOMUR);
				}

			} else {
				mensajeSis("No Existe la Actividad BMX");
				$('#descripcionBMX').val('');
				$('#actividadINEGI').val('');
				$('#descripcionINEGI').val('');
				$('#sectorEconomico').val('');
				$('#descripcionSE').val('');
			}
			} });
		}
	}


	function formaRFC() {
		var pn = $('#primerNombre').val();
		var sn = $('#segundoNombre').val();
		var tn = $('#tercerNombre').val();
		var nc = pn + ' ' + sn + ' ' + tn;

		var rfcBean = {
			'primerNombre' : nc,
			'apellidoPaterno' : $('#apellidoPaterno').val(),
			'apellidoMaterno' : $('#apellidoMaterno').val(),
			'fechaNacimiento' : $('#fechaNacimiento').val()
		};
		clienteServicio.formaRFC(rfcBean, function(cliente) {
			if (cliente != null) {

				$('#RFC').val(cliente.RFC);
			}
			$("#contenedorForma").unblock();
		});
	}

	function validaRFC(idControl) {
		var jqRFC = eval("'#" + idControl + "'");
		var numRFC = $(jqRFC).val();
		var tipCon = 4;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numRFC != '' && esTab ) {
			clienteServicio.consultaRFC(tipCon,	numRFC,function(rfc) {
				if (rfc != null) {
					 numCliente = rfc.numero;
						clienteServicio.consulta(17, numCliente, function(cliente) {
							if (cliente != null) {
								var numClienteID = parseInt(cliente.numero);
								if($('#numero').val() != numClienteID){
									if(cliente.descripcionRFC!=''){
										mensajeSis(cliente.descripcionRFC +cliente.numero);
										$(jqRFC).focus();
										$(jqRFC).select();

									}
								}
							}
						});
				}
			});
		}
	}

	function consultaOcupacion(idControl) {

		var jqOcupacion = eval("'#" + idControl + "'");
		var numOcupacion = $(jqOcupacion).val();
		var tipConForanea = 2;
		var jqLugarTrabajo = eval("'#lugarTrabajo'");
		var jqAntiguedadTra = eval("'#antiguedadTra'");
		var jqFechaIniTrabajo = eval("'#fechaIniTrabajo'");
		var jqUbicaNegocioID = eval("'#ubicaNegocioID'");
		var jqPuesto = eval("'#puesto'");

		setTimeout("$('#cajaLista').hide();", 200);
		if (numOcupacion != 0 && numOcupacion != '' && !isNaN(numOcupacion) ) {
			ocupacionesServicio.consultaOcupacion(tipConForanea, numOcupacion, { async: false, callback: function(ocupacion) {
						if (ocupacion != null) {
							$('#ocupacionC').val(ocupacion.descripcion);
							if (ocupacion.implicaTrabajo == 'S'){
								$(jqPuesto).rules("add", {
									required:function() {
										return $('#tipoPersona1').is(':checked') ||  $('#tipoPersona3').is(':checked');
									},
	 								messages: {
	 									required: "Especifique el Puesto"
									}
								});
								if ($(jqAntiguedadTra).length > 0) {
									$(jqAntiguedadTra).rules("add", {
		 									required: function() {return $('#tipoPersona1').is(':checked') ||  $('#tipoPersona3').is(':checked');},
		 								messages: {
		 									required: "Especifique la Antiguedad de Trabajo"
										}
									});
								}
								if ($(jqFechaIniTrabajo).length > 0) {
									$(jqFechaIniTrabajo).rules("add", {
	 									required: function() {return $('#tipoPersona1').is(':checked') ||  $('#tipoPersona3').is(':checked');},
		 								messages: {
		 									required: "Especifique Fecha de Inicio Trabajo"
										}
									});
								}
								if ($(jqUbicaNegocioID).length > 0) {
									$(jqUbicaNegocioID).rules("add", {
	 									required: function() {return $('#tipoPersona1').is(':checked') ||  $('#tipoPersona3').is(':checked');},
		 								messages: {
		 									required: "Especifique Ubicación del Negocio"
										}
									});
								}
							}else{
								$("#puesto").rules("remove");
								$("#puesto").focus();
								$("#puesto").blur();

								if ($(jqLugarTrabajo).length != 0 ) {
									$(jqLugarTrabajo).rules("remove");
									$(jqLugarTrabajo).focus();
									$(jqLugarTrabajo).blur();
									}

								if ($(jqAntiguedadTra).length > 0) {
									$(jqAntiguedadTra).rules("remove");
									$(jqAntiguedadTra).focus();
									$(jqAntiguedadTra).blur();
								}
								if ($(jqFechaIniTrabajo).length > 0) {
									$(jqFechaIniTrabajo).rules("remove");
									$(jqFechaIniTrabajo).focus();
									$(jqFechaIniTrabajo).blur();
									$(jqFechaIniTrabajo).val('');
								}
								if ($(jqUbicaNegocioID).length > 0) {
									$(jqUbicaNegocioID).rules("remove");
									$(jqUbicaNegocioID).focus();
									$(jqUbicaNegocioID).blur();
								}

							if($('#ocupaTab').val() == '2')	{
								$("#puesto").focus();
							}else {
								$("#tipoPersona1").focus();
							}

						esTab = true;

						  }
						} else {
							if(numOcupacion != 0){
								mensajeSis("No Existe la Ocupación");
								$('#ocupacionC').val('');
								$('#ocupacionID').val('');
								$('#ocupacionID').focus();
							}
						}
					}
					});
		}else{
			$('#ocupacionID').val('');
			$('#ocupacionC').val('');
		}
	}

	function consultaPromotorI(idControl,idControlNom, valida) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var jqNombre = eval("'#" + idControlNom + "'");
		var tipConForanea = 2;
		var promotor = {
			'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPromotor != '' && !isNaN(numPromotor)) {
			promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
				if (promotor != null) {
					if(valida){
						if(promotor.estatus != 'A'){
							mensajeSis("El Promotor debe de estar Activo");
							 $(jqPromotor).val("");
							 $(jqPromotor).focus();
							 $(jqNombre).val("");
						}
						if(promotor.sucursalID != $('#sucursalOrigen').asNumber()){
							mensajeSis("El Promotor no pertenece a la sucursal "+$('#sucursalOrigen').val());
							 $(jqPromotor).val("");
							 $(jqPromotor).focus();
							 $(jqNombre).val("");
						}
					}else{/*RLAVIDA T_11740  : Se realiza ajuste para mostrar en nombre del promotor cuando esta no se encuentra activa al momento de consultar un cliente  */
                        if(promotor.estatus == 'B'){
                            $(jqNombre).val(promotor.nombrePromotor);
                        }
                    }



					if(promotor.estatus == 'A'){
						if(valida){
							parametroBean = consultaParametrosSession();
							if(promotor.sucursalID != parametroBean.sucursal && editaSucursal=="N"){
								mensajeSis("El Promotor debe de pertenecer a la Sucursal: "+parametroBean.nombreSucursal);
								$(jqPromotor).val("");
								 $(jqNombre).val("");
								 $(jqPromotor).focus();
							}else{
								$(jqNombre).val(promotor.nombrePromotor);
							}
						} else {
							$(jqNombre).val(promotor.nombrePromotor);
						}
					}else{ /*RLAVIDA T_11740  : Se realiza ajuste para mostrar en nombre del promotor cuando esta no se encuentra activa al momento de consultar un cliente  */
                        if(promotor.estatus == 'B'){
                            $(jqNombre).val(promotor.nombrePromotor);
                        }
                    }
				} else {
					$(jqPromotor).val("");
					$(jqNombre).val("");
					$(jqPromotor).focus();
					mensajeSis("No Existe el Promotor.");
				}
			});
		}
	}

	/////leo/////////

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
			sucursalesServicio.consultaSucursal(conSucursal,
					numSucursal, function(sucursal) {
						if (sucursal != null) {
							$('#sucursalO').val(
									sucursal.nombreSucurs);
						} else {
							mensajeSis("No Existe la Sucursal");
						}
					});
		}
	}

	function consultaPais(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais) && esTab) {
			paisesServicio.consultaPaises(conPais, numPais,
					function(pais) {
						if (pais != null) {
							$('#paisR').val(pais.nombre);
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
	function consultaPaisF(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais) && esTab) {
			paisesServicio.consultaPaises(conPais, numPais,function(pais) {
				if (pais != null) {
					$('#paisF').val(pais.nombre);
					$('#paisFPM').val(pais.nombre);
				}
				else {
					mensajeSis("No Existe el País");
					$('#'+idControl).focus();
					$('#paisFea').val('');
					$('#paisF').val('');
					$('#paisFeaPM').val('');
					$('#paisFPM').val('');
				}
			});
		}else{
			if(isNaN(numPais) ){
				mensajeSis("No Existe el País");
				$('#paisFea').val('');
				$('#paisF').val('');
				$('#paisFeaPM').val('');
				$('#paisFPM').val('');
				$('#'+idControl).focus();

			}
		}


	}
	function consultaPaisFea(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais)) {
			paisesServicio.consultaPaises(conPais, numPais,function(pais) {
				if (pais != null) {
					$('#paisF').val(pais.nombre);
					$('#paisFPM').val(pais.nombre);
				}
				else {

					$('#paisFeaPM').val('');
					$('#paisFPM').val('');
					$('#paisFea').val('');
					$('#paisF').val('');

				}
			});
		}
		if(numPais == 0 || numPais ==''){
			$('#paisFeaPM').val('');
			$('#paisFPM').val('');
			$('#paisFea').val('');
			$('#paisF').val('');

		}
	}
	function consultaPaisNac(idControl) {
			var jqPais = eval("'#" + idControl + "'");
			var numPais = $(jqPais).val();
			var conPais = 2;

			setTimeout("$('#cajaLista').hide();", 200);
			if (numPais != '' && !isNaN(numPais) && esTab) {
				paisesServicio.consultaPaises(conPais, numPais,
						function(pais) {
							if (pais != null) {
								if($('#tipoPersona2').is(':checked')){
									$('#paisConstitucionID').val(pais.paisID * 1);
									$('#descPaisConst').val(pais.nombre);
								}else{
								$('#estadoID').attr('readonly',false);
								$('#paisNac').val(pais.nombre);
								$('#paisNacionalidad').val(numPais);
								$('#paisN').val(pais.nombre);
								if (pais.paisID != 700) {
									$('#estadoID').val(0);
									$('#estadoID').attr('readonly',true);
									consultaEstado('estadoID');
								}
								}
								validaNacionalidadCte();
							} else {
								mensajeSis("No Existe el País.");
								$(jqPais).focus();
								$(jqPais).val("");
								if($('#tipoPersona2').is(':checked')){
									$('#descPaisConst').val("");
								}else{
									$('#paisNac').val("");
								}
							}
						});
			}
		}


	function consultaPaisNacionalidad(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais) && esTab) {
			paisesServicio.consultaPaises(conPais, numPais,
					function(pais) {
						if (pais != null) {
							$('#paisNacionalidad').val(numPais);
							$('#paisN').val(pais.nombre);
						} else {
							mensajeSis("No Existe el País");
							$(jqPais).val('');
							$('#paisN').val('');
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




	function consultaGEmpres(idControl) {
		var jqGempresa = eval("'#" + idControl + "'");
		var numGempresa = $(jqGempresa).val();
		var conGempresa = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numGempresa != '' && !isNaN(numGempresa) && esTab && numGempresa > 0) {
			gruposEmpServicio.consulta(conGempresa,
					numGempresa, function(empresa) {
						if (empresa != null) {
							$('#descripcionGE').val(empresa.nombreGrupo);
						} else {
							if($('#grupoEmpresarial').val() > '0'){
							mensajeSis("No Existe el Grupo");
							$('#grupoEmpresarial').focus();
							$('#grupoEmpresarial').select();
							$('#descripcionGE ').val('');
							}
						}
					});
		}else{
			$('#descripcionGE').val('');
			$('#grupoEmpresarial').val('0');
		}
	}

	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEstado != '' && !isNaN(numEstado) && esTab) {
			estadosServicio
					.consulta(
							tipConForanea,
							numEstado,
							function(estado) {
								if (estado != null) {
									var p = $('#lugarNacimiento').val();
									if (p == 700 && estado.estadoID == 0 && esTab) {
										mensajeSis("No Existe el Estado");
										$('#estadoID').focus();
									}
									$('#nombreEstado').val(estado.nombre);
								} else {
									mensajeSis("No Existe el Estado");
									$(jqEstado).val('');
									$(jqEstado).focus();
								}
							});
		}else{
			if(esTab){
				mensajeSis("No Existe el Estado");
				$(jqEstado).val('');
				$(jqEstado).focus();
			}
		}
	}

	function validaNacionalidad(idControl) {
		var jqnacion = eval("'#" + idControl + "'");
		var nacion = $(jqnacion).val();
		var conPais = 2;
		var numPais = 700;

		setTimeout("$('#cajaLista').hide();", 200);
		if (nacion == 'N' && esTab) {
			paisesServicio.consultaPaises(conPais, numPais,
					function(pais) {
						if (pais != null) {

							$('#paisR').val(pais.nombre);
						}
					});
		}
	}

	function consultaSecGeneral(idControl) {
		var jqSecG = eval("'#" + idControl + "'");
		var numSec = $(jqSecG).val();
		var tipConPrin = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		var sectoresBeanCon = {
			'sectorID' : $('#sectorGeneral').val()
		};
		if (numSec != '' && !isNaN(numSec) && esTab) {
			sectoresServicio.consulta(tipConPrin,sectoresBeanCon, { async: false, callback: function(sector) {
				if (sector != null) {
					$('#descripcionSG').val(
							sector.descripcion);

					var pIVA = sector.pagaIVA;
					var pISR = sector.pagaISR;
					if ($('#tipoPersona2').is(':checked') && pIVA != 'S') {
						$('#pagaIVA').val(pIVA);
					} else {
						$('#pagaIVA').val('S');
					}
					if ($('#tipoPersona2').is(':checked') && pISR != 'S') {
						$('#pagaISR').val(pISR);
					} else {
						$('#pagaISR').val('S');
					}

				} else {
					mensajeSis("No Existe el Sector");
					$('#sectorGeneral').val("");
					$('#descripcionSG').val("");
					$('#sectorGeneral').focus();
				}
			}
			});
		}
	}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCliente != '' && !isNaN(numCliente) && esTab) {
			clienteServicio.consulta(1, numCliente, function(
					cliente) {
				if (cliente != null) {
					$('#numero').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#pagaIVA').val(cliente.pagaIVA);
					$('#pagaISR').val(cliente.pagaISR);
					$('#pagaIDE').val(cliente.pagaIDE);
					habilitaBoton('actualiza','submit');
					 if (cliente.estatus=='I'){
							deshabilitaBoton('actualiza','submit');
							mensajeSis("El Cliente se encuentra Inactivo");
							$('#clienteIDf').focus();
					 }

				} else {
					mensajeSis("No Existe el Cliente");
					$('#numero').val('');
					$('#nombreCliente').val('');
					$('#pagaIVA').val('S');
					$('#pagaISR').val('S');
					$('#pagaIDE').val('S');
					$('#clienteIDf').val('');
					$('#clienteIDf').focus();
					deshabilitaBoton('actualiza','submit');
				}
			});
		}
	}

	function consultaSociedad(idControl) {
		var jqSociedad = eval("'#" + idControl + "'");
		var numSociedad = $(jqSociedad).val();

		setTimeout("$('#cajaLista').hide();", 200);
		var SociedadBeanCon = {
			'tipoSociedadID' : numSociedad
		};
		if (numSociedad != '' && !isNaN(numSociedad) && esTab) {
			tipoSociedadServicio.consulta(catTipoConsultaSociedad.foranea, SociedadBeanCon,function(sociedad) {
				if (sociedad != null) {
					$('#descripSociedad').val(sociedad.descripcion);
				} else {
					var tp = $('#tipoPersona1').val();
					if (tp == 'M') {
						mensajeSis("No Existe el Tipo de Sociedad");
						$('#tipoSociedadID').focus();
						$('#tipoSociedadID').val("");
						$('#descripSociedad').val("");
					}
				}
			});
		}
	}

	function validaClienteForanea(controlOrigen, controlDestino) {
		var jqCliente = eval("'#" + controlOrigen + "'");
		var jqDestino = eval("'#" + controlDestino + "'");
		var numCliente = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente) && esTab) {
			clienteServicio.consulta(catTipoConsultaCliente.foranea, numCliente,function(cliente) {
				if (cliente != null) {
					$(jqDestino).val(cliente.nombreCompleto);
				} else {
					mensajeSis("No Existe el Cliente");
				}
			});
		}
	}

	function consultaActividadFR(idControl,b) {
		$('#descripcionActFR').val(b);
		var jqAct = eval("'#" + idControl + "'");
		var numAct = $(jqAct).val();
		var ActFRBeanCon = {
  				'actividadBancoMX':numAct
			};
  		dwr.util.removeAllOptions('descripcionActFR2');
  		if ($('#descripcionActFR').val()==null || $('#descripcionActFR').val()=='' || $('#descripcionActFR').val()==0){
  			habilitaControl('descripcionActFR2');
  			dwr.util.addOptions('descripcionActFR2', {'':'SELECCIONAR'});
  			actividadesFRServicio.listaCombo(ActFRBeanCon, 2, function(act){
  				dwr.util.addOptions('descripcionActFR2', act, 'actividadFRID', 'descripcion');
  			});
  			$('#descripcionActFR2').val(b).selected = true;
  		}
  		else{
  			soloLecturaControl('descripcionActFR2');
  			dwr.util.removeAllOptions('descripcionActFR2');
  			actividadesFRServicio.listaCombo(ActFRBeanCon, 1, function(act){
  				dwr.util.addOptions('descripcionActFR2', act, 'actividadFRID', 'descripcion');
  			});
  		}
  		$('#descripcionActFR2').val(b).selected = true;
	}

	function consultaActividadFOMUR(idControl,b) {
		$('#desActFomur').val(b);
		var jqAct = eval("'#" + idControl + "'");
		var numAct = $(jqAct).val();
		var ActFOMURBeanCon = {
  				'actividadBancoMX':numAct
			};
  		dwr.util.removeAllOptions('desActFomur2');
  		if ($('#desActFomur').val()==null || $('#desActFomur').val()=='' || $('#desActFomur').val()==0){
  			habilitaControl('desActFomur2');
  			dwr.util.addOptions('desActFomur2', {0:'SELECCIONAR'});
  			actividadesFomurServicio.listaCombo(ActFOMURBeanCon, 2, function(act){
  				dwr.util.addOptions('desActFomur2', act, 'actividadFOMURID', 'descripcion');
  			});
  			$('#desActFomur2').val(b).selected = true;
  		}
  		else{
  			soloLecturaControl('desActFomur2');
  			dwr.util.removeAllOptions('desActFomur2');
  			actividadesFomurServicio.listaCombo(ActFOMURBeanCon, 1, function(act){
  				dwr.util.addOptions('desActFomur2', act, 'actividadFOMURID', 'descripcion');
  			});
  		}
  		$('#desActFomur2').val(b).selected = true;
	}

	function compare_dates(fecha){
      var fechaHoy = parametroBean.fechaSucursal;
      var xMonth=fecha.substring(3, 5);
      var xDay=fecha.substring(0, 2);
      var xYear=fecha.substring(6,10);
      var yMonth=fechaHoy.substring(3, 5);
      var yDay=fechaHoy.substring(0, 2);
      var yYear=fechaHoy.substring(6,10);
      if (xYear> yYear){
			return(true);
		}
      else{
			if (xYear == yYear){
				if (xMonth> yMonth){
					return(true);
            }
            else{
              if (xMonth == yMonth){
                if (xDay> yDay)
                  return(true);
                else
                  return(false);
              }
              else
              	return(false);
            }
          }
          else
				return(false);
		}
	}




	//Funcion que consulta la institucion de Nomina
	function consultaCteNomina(idControl){
		var jqNumNom = eval("'#" + idControl + "'");
		var NumNomina = $(jqNumNom).val();
		var Baja='B';
		var bean = {
				'institNominaID':NumNomina
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (NumNomina != '' && !isNaN(NumNomina) && esTab) {
			institucionNomServicio.consulta(catTipoConsultaInstitucion.principal, bean, function(Respuesta){
			if(Respuesta != null){
				$('#nombreInstit').val(Respuesta.nombreInstit);
				if(Respuesta.estatus==Baja){
					mensajeSis('La Institución de Nómina se encuentra Cancelada');
					$('#institNominaID').focus();
					$('#institNominaID').val('');
					$('#nombreInstit').val('');
				}
			}else{
				mensajeSis('No Existe la Institución ');
				$('#institNominaID').focus();
				$('#institNominaID').val('');
				$('#nombreInstit').val('');
			}
			});
		}
	}

	//Funcion que consulta el negocio afiliado
	function consultaCteNegocio(idControl){
		var jqNumNeg = eval("'#" + idControl + "'");
		var NumNeg = $(jqNumNeg).val();
		var consultaCteNeg = 1;
		var Baja='B';
		var bean = {
				'negocioAfiliadoID':NumNeg
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (NumNeg != '' && !isNaN(NumNeg) && esTab) {
			negocioAfiliadoServicio.consulta(consultaCteNeg, bean, function(Respuesta){
			if(Respuesta != null){
				$('#razonSocialNegAfi').val(Respuesta.razonSocial);
				if(Respuesta.estatus==Baja){
					mensajeSis('El Negocio Afiliado se encuentra Cancelado');
					$('#negocioAfiliadoID').focus();
					$('#negocioAfiliadoID').val('');
					$('#razonSocialNegAfi').val('');
				}
			}else{
				mensajeSis('No Existe el Negocio Afiliado');
				$('#negocioAfiliadoID').focus();
				$('#negocioAfiliadoID').val('');
				$('#razonSocialNegAfi').val('');
			}
			});
		}
	}
	function PermiteRFC() {
		var numEmpresaID = 1;
		var tipoCon = 1;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				if(parametrosSisBean.permiteRFC=="S"){
					if($('#tipoPersona1').is(':checked')){
						permiteCalcularCURPyRFC('','generar',2);
					}else{
						$('#generar').hide(500);
					 }

				}else{
					$('#generar').hide(500);
				}
			}
		});
	}

	/***********************************/
	//FUNCION PARA MOSTRAR O OCULTAR BOTONES CALCULAR CURP o RFC
	//PRIMER PARAMETRO ID BOTON CURP
	//SEGUNDO PARAMETRO ID BOTON RFC
	//TERCER PARAMETRO 1= SOLO CURP, 2= SOLO RFC, 3= AMBOS
	function permiteCalcularCURPyRFC(idBotonCURP,idBotonRFC,tipo) {
		var jqBotonCURP = eval("'#" + idBotonCURP + "'");
		var jqBotonRFC = eval("'#" + idBotonRFC + "'");
		var numEmpresaID = 1;
		var tipoCon = 17;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				//Validacion para mostrarar boton de calcular CURP Y RFC
				if(parametrosSisBean.calculaCURPyRFC == 'S'){
					if(tipo == 3){
						$(jqBotonCURP).show();
						$(jqBotonRFC).show();
					}else{
						if(tipo == 1){
							$(jqBotonCURP).show();
						}else{
							if(tipo == 2){
								$(jqBotonRFC).show();
							}
						}
					}
				}else{
					if(tipo == 3){
						$(jqBotonCURP).hide();
						$(jqBotonRFC).hide();
					}else{
						if(tipo == 1){
							$(jqBotonCURP).hide();
						}else{
							if(tipo == 2){
								$(jqBotonRFC).hide();
							}
						}
					}
				}
			}
		});
	}
});//	FIN VALIDACIONES

	function formaCURP() {
		var sexo = $('#sexo').val();
		var nacionalidad = $('#nacion').val();
		if(sexo == "M")
		{sexo = "H";}
		else if(sexo == "F")
		{sexo = "M";}
		else{
			sexo = "H";
			mensajeSis("Especifique Género");
		}

		if(nacionalidad == "N")
		{nacionalidad = "N";}
		else if(nacionalidad == "E")
		{nacionalidad = "S";}
		else{
			nacionalidad = "N";
			mensajeSis("No se Asignó Nacionalidad");
		}
		var CURPBean = {
			'primerNombre'	:$('#primerNombre').val(),
			'segundoNombre'	:$('#segundoNombre').val(),
			'tercerNombre'	:$('#tercerNombre').val(),
			'apellidoPaterno' : $('#apellidoPaterno').val(),
			'apellidoMaterno' : $('#apellidoMaterno').val(),
			'sexo'			:sexo,
			'fechaNacimiento' : $('#fechaNacimiento').val(),
			'nacion'		:nacionalidad,
			'estadoID':$('#estadoID').val()

		};
		clienteServicio.formaCURP(CURPBean, function(cliente) {
			if (cliente != null) {
				$('#CURP').val(cliente.CURP);
			}
		});
	}

	function validaCURP(idControl) {
		var jqCURP = eval("'#" + idControl + "'");
		var numCURP = $(jqCURP).val();
		var tipoPer;
		var persona;
		var tipCon = 11;
		setTimeout("$('#cajaLista').hide();", 200);

		if($('#tipoPersona1').is(':checked')){
			persona = 'F';
		}else if(($('#tipoPersona2').is(':checked'))){
			persona = 'M';
		}else if(($('#tipoPersona3').is(':checked'))){
			persona = 'A';
		}


		if (numCURP != '' && esTab ) {
			clienteServicio.consultaCURP(tipCon, numCURP,function(curp) {
				if (curp != null) {
						 numCliente = curp.numero;
						 tipoPer = curp.tipoPersona;
							clienteServicio.consulta(17, numCliente, function(cliente) {

								if (cliente != null) {
									var numClienteID = parseInt(cliente.numero);
										if($('#numero').val() != numClienteID){
											if(persona == 'F' || persona == 'A'){
												if(cliente.descripcionCURP!=''){
													mensajeSis(cliente.descripcionCURP +cliente.numero);
													$(jqCURP).select();
													$(jqCURP).focus();
												}
									}
								}
								}
							});

					}
			});
		}
	}

	function limpiaDatosPersonaFisica(){
		$('#primerNombre').val('');
		$('#segundoNombre').val('');
		$('#tercerNombre').val('');
		$('#apellidoPaterno').val('');
		$('#apellidoMaterno').val('');
		$('#fechaNacimiento').val('');
		$('#lugarNacimiento').val('');
		$('#paisNac').val('');
		$('#estadoID').val('');
		$('#nombreEstado').val('');
		$('#paisResidencia').val('');
		$('#paisR').val('');
		$('#CURP').val('');
		$('#registroHaciendaNo').attr('checked',true);
		$('#RFC').val('');
		$('#telefonoCelular').val('');
		$('#telefonoCasa').val('');
		$('#extTelefonoPart').val('');
		$('#correo').val('');
		$('#fax').val('');
		$('#observaciones').val('');
		$('#ocupacionID').val('');
		$('#ocupacionC').val('');
		$('#puesto').val('');
		$('#domicilioTrabajo').val('');
		$('#lugarTrabajo').val('');
		$('#antiguedadTra').val('');
		$('#antiguedadTraMes').val('');
		$('#telTrabajo').val('');
		$('#extTelefonoTrab').val('');

		$('#titulo').val("");
		$('#nacion').val("");
		$('#sexo').val("");
		$('#estadoCivil').val("");

		dwr.util.removeAllOptions('descripcionActFR2');
			dwr.util.addOptions('descripcionActFR2', {'':''});
			$('#descripcionActFR2').val("");
		dwr.util.removeAllOptions('desActFomur2');
			dwr.util.addOptions('desActFomur2', {'':''});
			$('#desActFomur2').val("");


		$('#ciaCelular').val('');

	}

	function limpiaDatosPersonaMoral(){
		$('#razonSocial').val('');
		$('#RFCpm').val('');
		$('#paisConstitucionID').val('');
		$('#descPaisConst').val('');
		$('#correoPM').val('');
		$('#correoAlterPM').val('');
		$('#telefonoPM').val('');
		$('#extTelefonoPM').val('');
		$('#tipoSociedadID').val('');
		$('#descripSociedad').val('');
		$('#grupoEmpresarial').val('');
		$('#descripcionGE').val('');
		$('#fechaRegistroPM').val('');
		$('#nombreNotario').val('');
		$('#numNotario').val('');
		$('#inscripcionReg').val('');
		$('#escrituraPubPM').val('');
		$('#observacionesPM').val('');
		$('#nacionalidadPM').val("");

		if(varSeleccionaMoral == 'S'){

			dwr.util.removeAllOptions('descripcionActFR2');
				dwr.util.addOptions('descripcionActFR2', {'':''});
				$('#descripcionActFR2').val("");
			dwr.util.removeAllOptions('desActFomur2');
				dwr.util.addOptions('desActFomur2', {'':''});
				$('#desActFomur2').val("");
		}
	}

	function limpiaChecks(){
		if($('#tipoPersona2').is(':checked')){
			$('#ocupacionID').val('');
			$('#ocupacionC').val('');
			$('#puesto').val('');
			$('#lugarTrabajo').val('');
			$('#domicilioTrabajo').val('');
			$('#antiguedadTra').val('');
			$('#antiguedadTraMes').val('');
			$('#telTrabajo').val('');
			$('#extTelefonoTrab').val('');
		}
		if($('#tipoPersona1').is(':checked') || $('#tipoPersona3').is(':checked')){
			$('#razonSocial').val('');
			$('#tipoSociedadID').val('');
			$('#descripSociedad').val('');
			$('#RFCpm').val('');
			$('#grupoEmpresarial').val('');
		}

	}

	function limpiaForma(){
		limpiaFormaCompleta('formaGenerica', true, [ 'numero', 'sucursalOrigen', 'sucursalO' ]);
		$('#tipoPersona1').attr("checked", true);
		dwr.util.removeAllOptions('descripcionActFR2');
		dwr.util.removeAllOptions('desActFomur2');
		deshabilitaBoton('elimina', 'submit');
		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('modifica', 'submit');
	}


	function exitoTransCliente(){
		if($('#flujoCliNumCli').val() != undefined){
			$('#flujoCliNumCli').val($('#numero').val());
			$('#_pantalla1').click();
			consultaFlujo('1',$('#numero').val());
		}
	limpiaForma();

	}
	function falloTransCliente(){

	}


	//devuelve el nombre del Promotor de captacion
	function consultaNombreCaptacion(idControl){

		var tipoConsulta  = 6;
		var jqPromotor  = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();

		if($('#ejecutivoCap').val()!='0'&& $('#ejecutivoCap').val()!=''){

		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor != '' && !isNaN(numPromotor) && esTab){
			var promotorBeanCon = {
				'promotorID'	: numPromotor,
				'sucursalID'	: parametroBean.sucursal
			};
			promotoresServicio.consulta(tipoConsulta, promotorBeanCon ,function(promotor){
				if(promotor!=null){
					if(promotor.varSucursalID == parametroBean.sucursal){
						$('#nomEjecutivoCap').val(promotor.nombrePromotor);
					}else if(promotor.varSucursalID != parametroBean.sucursal){
						mensajeSis('El Ejecutivo de Captación Indicado no Pertenece a esta Sucursal');
						$('#ejecutivoCap').focus();
						$('#ejecutivoCap').val('');
						$('#nomEjecutivoCap').val('');
					}
				}else{
					mensajeSis("El Ejecutivo de Captación Indicado no Existe");
					$('#ejecutivoCap').focus();
					$('#ejecutivoCap').val('');
					$('#nomEjecutivoCap').val('');
				}
			});
		}
	}
		else {
			$('#ejecutivoCap').val('');
			$('#nomEjecutivoCap').val('');
		}

	}

	//devuelve el nombre del Promotor de esterno de inversion
	function consultaNomProExterno(idControl){

		var tipoConsulta  = 7;
		var jqPromotor  = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();

		var promotorBeanCon = {
				'numero'	:numPromotor
		};

		if($('#promotorExtInv').val()!='0'&& $('#promotorExtInv').val()!=''){
		setTimeout("$('#cajaLista').hide();", 200);

		if(numPromotor != '' && !isNaN(numPromotor)){

			promotoresServicio.consulta(tipoConsulta, promotorBeanCon ,function(promotor){

				if(promotor!=null){
					if(promotor.varEstatus == 'A'){
					$('#nomPromotorExtInv').val(promotor.nombre);
					}else if(promotor.varEstatus == 'C'){
						mensajeSis('El Promotor Externo Indicado no se Encuentra Activo');
					}

				}
				else{
					mensajeSis("El Promotor Externo Indicado no Existe");
					$('#promotorExtInv').focus();
					$('#promotorExtInv').val('');
					$('#nomPromotorExtInv').val('');
				}
			});
		}
		}
		else {
			$('#promotorExtInv').val('');
			$('#nomPromotorExtInv').val('');
		}
	}




	function consultaTipoPuestos() {
		dwr.util.removeAllOptions('tipoPuestoID');

		var tipoLista  = 1;
		dwr.util.addOptions('tipoPuestoID',{'':'SELECCIONAR'});
		tiposPuestosServicio.listaCombo(tipoLista, function(tipoPuestos){
		dwr.util.addOptions('tipoPuestoID', tipoPuestos, 'tipoPuestoID', 'descripcion');

	   });
	}

//funcion para validar para ocultar  o habilitar  campo en caso de ser requerido

function consultaPromotorActiva(idControl) {
	var tipoConsulta = 1;
	var tipoCon = 8;
	var parametroBean = {
			'empresaID'		: 1
		};
	var promotor = {
			'tipoPromotorID' : ''
	};
	parametrosSisServicio.consulta(tipoConsulta, parametroBean, function(parametroBean) {
		if (parametroBean != null){
			if (parametroBean.activaPromotorCapta == 'S'){
				promotoresServicio.consulta(tipoCon, promotor, function(promotor) {
					if (promotor != null){
						if (promotor.aplicaPromotor == '1'){
							$('#promotorcap').show();
							$('#muestraEjec').val(1);

						}else{
							$('#promotorcap').hide();
							$('#promotorExtInv').val(0);
							$('#ejecutivoCap').val(0);
						}
					}
				});
			}
			else{
				$('#promotorcap').hide();
				$('#promotorExtInv').val(0);
				$('#ejecutivoCap').val(0);
			}
		}
	});
}



/*funcion valida fecha formato (yyyy-MM-dd)*/
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
	if ((( anio % 100 != 0) && (anio % 4 == 0)) || (anio % 400 == 0)) {
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


// Funcion que valida los campos y datos que se mostraran de acuerdo al valor del parametro para este efecto
function validaDatosLaborales(datos,tipoPersona){
	var lugarTrabajo = datos.lugarTrabajo;
	var antiguedadTra = datos.antiguedadTra;
	var fechaIniTrabajo = datos.fechaIniTrabajo;
	var ubicaNegocioID = datos.ubicaNegocioID;
	var antiguedadAnio = "";
	var antiguedadMes = "";
	var fechaActualSistema = parametroBean.fechaSucursal;
	var jqUbicaNegocioID = "";
	var tipoConsulta = 2;
	var bean = {
			'empresaID'		: 1
	};

	paramGeneralesServicio.consulta(tipoConsulta, bean,{ async: false, callback: function(parametro) {
		if(lugarTrabajo == undefined ) lugarTrabajo = "";
		if(antiguedadTra == undefined ) antiguedadTra = "";
		if(ubicaNegocioID == undefined ) ubicaNegocioID = "0";
		if(fechaIniTrabajo == undefined || fechaIniTrabajo == "1900-01-01") fechaIniTrabajo = "";

			if (parametro != null){
				$("#fila1").html('');
				$("#fila2").html('');

				if(tipoPersona == "F" || tipoPersona == "A"){

						if(parametro.valorParametro == "S"){
							if(fechaIniTrabajo != ""){

								var fechaInicioTrabajo = fechaIniTrabajo.split("-");
								var ini_dia = fechaInicioTrabajo[2];
								var ini_Mes = fechaInicioTrabajo[1];
								var ini_Anio = fechaInicioTrabajo[0];

								var fechaActual = fechaActualSistema.split("-");
								var hoy_dia = fechaActual[2];
								var hoy_Mes = fechaActual[1];
								var hoy_Anio = fechaActual[0];


								antiguedadAnio = parseInt(hoy_Anio) - parseInt(ini_Anio);



								if(parseInt(hoy_Mes) >= parseInt(ini_Mes)){
									antiguedadMes = parseInt(hoy_Mes) - parseInt(ini_Mes);
								}else{
									antiguedadMes = (12 + parseInt(hoy_Mes) ) - parseInt(ini_Mes);
									antiguedadAnio --;
								}


								if(parseInt(hoy_dia) < parseInt(ini_dia)){
									if(parseInt(antiguedadMes) > 0){
										antiguedadMes --;
									}else{
										antiguedadMes = 11;
										antiguedadAnio --;
									}

								}


							}

							$("#fila1").append('<td class="label"><label for="lugarTrabajo">Nombre del Centro de Trabajo:</label></td>'
										+'<td><input type="text" id="lugarTrabajo" name="lugarTrabajo" size="45" tabindex="61" onBlur=" ponerMayusculas(this)" maxlength="100" value="' + lugarTrabajo + '"/>'
										+'</td><td class="separador"></td><td class="label"><label for="antiguedadTra">Fecha Inicio Trabajo Actual:</label></td>'
										+'<td><input type="text" id="fechaIniTrabajo" name="fechaIniTrabajo" size="15" esCalendario="true" tabindex="62" value="' + fechaIniTrabajo + '"'
										+' onchange="calculaAntiguedadTrabajo(this); this.focus();" onblur="calculaAntiguedadTrabajo(this);"/></td>');
							$("#fila2").append('<td class="label"> <label for="antiguedadTra">Antig&uuml;edad Lugar de Trabajo:</label></td>'
										+'<td><input type="text" id="antiguedadAnio" value="' + antiguedadAnio + '" size="6" readonly="true" style="text-align: right"/>'
										+'<font size="2"><label for="antiguedadAnio">A&ntilde;o(s)</label></font>'
										+'&nbsp;&nbsp;&nbsp;<input type="text" id="antiguedadMes" value="' + antiguedadMes + '" size="6" readonly="true" style="text-align: right"/>'
										+'<font size="2"><label for="antiguedadMes">Mes(es)</label></font></td>'
										+'<td class="separador"></td><td class="label"><label for="lugarTrabajo">Ubicaci&oacute;n del Negocio:</label>'
										+'</td><td><select id="ubicaNegocioID" name="ubicaNegocioID" tabindex="63">'
										+	'<option>SELECCIONAR</option>'
										+'</select></td>');


							dwr.util.removeAllOptions('ubicaNegocioID');
							dwr.util.addOptions('ubicaNegocioID', {'':'SELECCIONAR'});
							catUbicaNegocioServicio.listaCombo(1,bean, function(catalogo){
								dwr.util.addOptions('ubicaNegocioID', catalogo, 'ubicaNegocioID', 'ubicacion');
								jqUbicaNegocioID = eval("'#ubicaNegocioID'");
								$(jqUbicaNegocioID).val(ubicaNegocioID).selected = true;
							});

							$("#personaFisica").show(500);
							$("#personaMoral").hide(500);
							$('#datosPersonaFisica').show(500);
							$('#datosAdicionalesPF').show(500);
						}else{
								$("#fila1").append('<td class="label"><label for="lugarTrabajo">Nombre del Centro de Trabajo:</label></td>'
												+'<td><input type="text" id="lugarTrabajo" name="lugarTrabajo" size="45" tabindex="64" onBlur=" ponerMayusculas(this)" maxlength="100"  value="' + lugarTrabajo + '"/></td>'
												+'<td class="separador"></td>'
												+'<td class="label"><label for="antiguedadTra">Antig&uuml;edad Lugar de Trabajo:</label></td>'
												+'<td><input type="text" id="antiguedadTra" name="antiguedadTra" size="6" tabindex="65" value="' + antiguedadTra + '"'
												+' onkeypress="return event.charCode >= 48 && event.charCode <= 57"/>'
												+'<font size="2"><label for="antiguedadTra">A&ntilde;o(s)</label></font></td>');
								$("#fila2").html('');
								$("#personaFisica").show(500);
								$("#personaMoral").hide(500);
								$('#datosPersonaFisica').show(500);
								$('#datosAdicionalesPF').show(500);
						}
				}else{
					$("#personaFisica").hide(500);
					$("#personaMoral").show(500);
					$('#datosPersonaFisica').hide(500);
					$('#datosAdicionalesPF').hide(500);
				}
			}
			else{
				if(tipoPersona == "F" || tipoPersona == "A"){
					$("#fila1").append('<td class="label"><label for="lugarTrabajo">Nombre del Centro de Trabajo:</label></td>'
							+'<td><input type="text" id="lugarTrabajo" name="lugarTrabajo" size="45" tabindex="58" onBlur=" ponerMayusculas(this)" maxlength="100"  value="' + lugarTrabajo + '"/></td>'
							+'<td class="separador"></td>'
							+'<td class="label"><label for="antiguedadTra">Antig&uuml;edad Lugar de Trabajo:</label></td>'
							+'<td><input type="text" id="antiguedadTra" name="antiguedadTra" size="6" tabindex="59" value="' + antiguedadTra + '"/>'
							+'<font size="2"><label for="antiguedadTra">A&ntilde;os:</label></font></td>');
						$("#fila2").html('');
						$("#personaFisica").show(500);
						$("#personaMoral").hide(500);
						$('#datosPersonaFisica').show(500);
						$('#datosAdicionalesPF').show(500);

				}else{
					$("#personaFisica").hide(500);
					$("#personaMoral").show(500);
					$('#datosPersonaFisica').hide(500);
					$('#datosAdicionalesPF').hide(500);
				}
			}
			agregaFormatoControles('formaGenerica');
	}
	});
}




//Función para calcular los días transcurridos entre dos fechas
function restaFechas(fAhora,fEvento) {
	var ahora = new Date(fAhora);
    var evento = new Date(fEvento);
    var tiempo = evento.getTime() - ahora.getTime();
    var dias = Math.floor(tiempo / (1000 * 60 * 60 * 24));

	return dias;
 }


// recalcula la antiguedad laboral del cliente
function calculaAntiguedadTrabajo(evento){
	var antiguedadTra = "";
	var antiguedadAnio = "";
	var antiguedadMes = "";
	var fechaActualSistema = parametroBean.fechaSucursal;
	var jqAntiguedadAnio =  eval("'#antiguedadAnio'");
	var jqAntiguedadMes =  eval("'#antiguedadMes'");

	if(evento.value != ""){
		if(esFechaValida(evento.value)){
			if ( mayor(evento.value, fechaActualSistema) ){
				mensajeSis("La Fecha Indicada es Mayor a la Fecha Actual del Sistema")	;
				evento.value = fechaActualSistema;
				evento.focus();
			}else{

					var fechaInicioTrabajo = evento.value.split("-");
					var ini_dia = fechaInicioTrabajo[2];
					var ini_Mes = fechaInicioTrabajo[1];
					var ini_Anio = fechaInicioTrabajo[0];

					var fechaActual = fechaActualSistema.split("-");
					var hoy_dia = fechaActual[2];
					var hoy_Mes = fechaActual[1];
					var hoy_Anio = fechaActual[0];


					antiguedadAnio = parseInt(hoy_Anio) - parseInt(ini_Anio);



					if(parseInt(hoy_Mes) >= parseInt(ini_Mes)){
						antiguedadMes = parseInt(hoy_Mes) - parseInt(ini_Mes);
					}else{
						antiguedadMes = (12 + parseInt(hoy_Mes) ) - parseInt(ini_Mes);
						antiguedadAnio --;
					}


					if(parseInt(hoy_dia) < parseInt(ini_dia) ){
							if(parseInt(antiguedadMes) > 0){
								antiguedadMes --;
							}else{
								antiguedadMes = 11;
								antiguedadAnio --;
							}
					}


					$(jqAntiguedadAnio).val(antiguedadAnio);
					$(jqAntiguedadMes).val(antiguedadMes);

			}
		}
		else{
			evento.value = fechaActualSistema;
			$(jqAntiguedadAnio).val('0');
			$(jqAntiguedadMes).val('0');
		}
	}else{
		evento.value = fechaActualSistema;
		$(jqAntiguedadAnio).val('0');
		$(jqAntiguedadMes).val('0');
	}


}

function validaCURPv1(curp){
	var fecha=$('#fechaNacimiento').val();
	var regexp = /^([A-Z][A,E,I,O,U,X][A-Z]{2})(\d{2})((01|03|05|07|08|10|12)(0[1-9]|[12]\d|3[01])|02(0[1-9]|[12]\d)|(04|06|09|11)(0[1-9]|[12]\d|30))([M,H])(AS|BC|BS|CC|CS|CH|CL|CM|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|NE)([B,C,D,F,G,H,J,K,L,M,N,Ñ,P,Q,R,S,T,V,W,X,Y,Z]{3})([0-9,A-Z][0-9])$/;
    if(regexp.test(curp) == false){
		mensajeSis('La CURP es incorrecta');
		$('#generarc').focus();
	}else{
		if(obtenFechaCurp(curp,fecha)!=true){
			 mensajeSis('La CURP no concuerda con la Fecha de Nacimiento');
		     $('#generarc').focus();
		}
	}

}

function validaRFCv1(rfc){
	var fecha=$('#fechaNacimiento').val();
	var regexp=/^([A-Z,Ñ,&]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])[A-Z|\d]{3})$/;
	if(regexp.test(rfc) == false){
		mensajeSis('El RFC es Incorrecto.');
		$('#generar').focus();
	}else{
		if(obtenFechaCurp(rfc,fecha)!=true){
			 mensajeSis('El RFC no concuerda con la Fecha de Nacimiento.');
		     $('#generar').focus();
		}
	}
}
function obtenFechaCurp(curp,fechaNaci){
		   var esValido=true;
		   var inicioCurp=4;
		   var finCurp=10;
		   var inicio = 2;
           var fin    = 9;
		   var exp=/([-])/;
           var fechaCurp=curp.substring(inicioCurp, finCurp);
           var fechaNac=fechaNaci.replace(exp,'');
           var fechaNacimiento=fechaNac.replace(exp,'');
           if(fechaCurp==fechaNacimiento.substring(inicio,fin)){
           	 esValido=true;
           }else{
           	esValido=false;
           }

           return esValido;
	}


function limpiarDatos(){
	$('#titulo').val('');
	$('#nacion').val('');
	$('#sexo').val('');
	$('#estadoCivil').val('');
	$('#estadoCivil').val('');
	$('#clasificacion').val('');
	$('#motivoApertura').val('');
	dwr.util.removeAllOptions('descripcionActFR2');
	dwr.util.removeAllOptions('desActFomur2');
	$('#datosNomina').hide();
	$('#pagaIVA').val('S');
	$('#pagaISR').val('S');
	$('#pagaIDE').val('S');
	$('#tipoEmpleado').val('');
	$('#tipoPuestoID').val('');
	$('#paisResidencia').val('');
	$('#paisR').val('');
	$('#paisF').val('');
 }

//Metodo para consultar si modifica sucursal
function consultaModificaSuc(){
    var tipoConsulta = 58;
    var bean = {
            'empresaID'     : 1
        };
    paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
		if (parametro != null && parametro.valorParametro=="S"){
			editaSucursal = parametro.valorParametro;
			habilitaControl('sucursalOrigen');
			$("#sucursalOrigen").focus();
		}else {
			editaSucursal = 'N';
			deshabilitaControl('sucursalOrigen');
		}

    }});
}

function validaApellidos(idControl) {
	var jqApellido = eval("'#" + idControl + "'");
	var apellido = $(jqApellido).val();
	if ($('#tipoPersona2').is(':checked')) {
		return false;
	}
	if (apellido == '') {
		return true;
	}
}