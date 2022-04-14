$(document).ready(function() {

	var parametroBean = consultaParametrosSession();
	$("#cuentaAhoID").focus();

	esTab = true;

	var selectTipoIdenti='';
	var selectNacion='';
	var selectDocEstancia='';
	var numCtePersonaRelacionada= '';
	var estatusCuenta ='';
	var esMenorEdad='';
	//Definicion de Constantes y Enums
	var catTipoTransaccionCtaPer = {
  		'agrega':'1',
  		'modifica':'2',
  		'elimina' :'3'
	};

	var catTipoConsultaCtaPer = {
  		'principal':1,
  		'foranea':2
	};

	var catTipoConsultaDirCliente = {
  		'principal'	:	1,
  		'foranea'	:	2,
		'oficialDirec' :  3,
		'oficial'  : 4,
		'verOficial' : 5
	};

	var catTipoConsultaIdenCliente = {
  		'principal'	: 1,
  		'foranea'	: 2,
  		'oficial' 	: 3,
  		'tieneTipoIden' : 4
	};

	var catTipoConsultaSociedad = {
		'principal': 1,
		'foranea': 2
	};

	expedienteBean = {
			'clienteID' : 0,
			'tiempo' : 0,
			'fechaExpediente' : '1900-01-01',
	};
	listaPersBloqBean = {
			'estaBloqueado'	:'N',
			'coincidencia'	:0
	};
	var esCliente 			='CTE';
	var esUsuario			='USS';
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('elimina', 'submit');
	agregaFormatoControles('formaGenerica');

	//consultaIdentificacionSeleccionada();	//al cargar la pagina checamos que identificacion es la seleccionada
	consultaTipoIden();
	tipoPersonaSeleccionada(); // al cargar la pagina chacamos tipo de Persona Seleccionada
	ocultaIngresosRealoRecursos();
	$('#porcentajeAcc').hide();
	$('#porcentajeAccVal').hide();
	$('#porcentajeAccMo').hide();


	//Validacion para mostrarar boton de calcular CURP Y RFC
	permiteCalcularCURPyRFC('generarc','generar',3);

	if($('#flujoCliSolCue').val() != undefined){
		if(!isNaN($('#flujoCliSolCue').val())){
			var SolCuentaFlu = Number($('#flujoCliSolCue').val());
			if(SolCuentaFlu > 0){
				$('#cuentaAhoID').val($('#flujoCliSolCue').val());
		  		consultaCtaAho('cuentaAhoID');
	  			limpiaForm('#personasRelacionadas');

			}else{
				$('#cuentaAhoID').val();
				$('#cuentaAhoID').focus().select();
			}
		}
	}

   $(':text').focus(function() {
	 	esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) {

			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','personaID', 'exitoTransCuenta', 'falloTransCuenta');

      	}
    });

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	//	Datos de la Cuenta
	$('#cuentaAhoID').blur(function() {

  		consultaCtaAho(this.id);
  		limpiaForm('#personasRelacionadas');

	});

	$('#cuentaAhoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#cuentaAhoID').val();
			lista('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}
	});

	$('#personaID').blur(function() {
		if (esTab == true) {
		validaCtaPersona(this.id);
  		esMenorEdad='';
		}
	});

	$('#personaID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "cuentaAhoID";
		camposLista[1] = "nombreCompleto";
		parametrosLista[0] = $('#cuentaAhoID').val();
		parametrosLista[1] = $('#personaID').val();

		lista('personaID', '2', '1', camposLista, parametrosLista, 'cuentasPersonaListaVista.htm');
	});


	$('#numeroCte').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('numeroCte', '2', '1', 'nombreCompleto', $('#numeroCte').val(), 'listaCliente.htm');
		}
	});

	$('#numeroCte').blur(function() {
		if (esTab == true) {
		if( Number($('#numeroCte').val()) > 0 && Number($('#personaID').val()) == 0){		//Alta con cliente
			listaPersBloqBean = consultaListaPersBloq($('#numeroCte').val(), esCliente, 0, 0);
			if (listaPersBloqBean.estaBloqueado != 'S') {
			consultaCliente($('#numeroCte').val(),'alta','');
			desactivarRadiosOcultaDivs();
			ocultaIngresosRealoRecursos();
			deshabilitaBoton('elimina','submit');
			limpiaCombos();
			limpiaPorcentaje();
			}else{
				mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación')
				$('#numeroCte').val('');
				$('#numeroCte').focus();;
			}
		}else if( Number($('#numeroCte').val()) == 0 && $('#personaID').val() == 0 ){// Alta Sin cliente
			desactivarRadiosOcultaDivs();
			ocultaIngresosRealoRecursos();
			inicializaForma('personasRelacionadas', 'personaID');
			limpiaCombos();
			limpiaPorcentaje();
			habilitaFormularioCuentaPersona();
			limpiaDatosPersonaMoral();
			limpiaDatosPersonaFisica();
			$('#datosPersonaMoral').hide(500);
			$('#datosPersonaFisica').show(500);
			$('#domicilioOficialPM').hide(500);
			$('#identificacionDiv').show(500);
			$('#nacionalidadDiv').show(500);

		}else if($('#personaID').asNumber() > 0){									// Modifica
				if(Number($('#numeroCte').val()) >0 ){
					if($('#numeroCte').asNumber() != Number(numCtePersonaRelacionada)){	// se esta cambiando el cliente ya relacionado por otro cliente
						consultaCliente($('#numeroCte').val(),'modificaOtroCte','');
					}else if($('#numeroCte').asNumber() == Number(numCtePersonaRelacionada)){ //se esta modificando informacion del mismo cliente ya relacionado
						validaCtaPersona('personaID');
					}
				}else{															// Se modifica el cliente Relacionado por una persona NO cliente
					if(numCtePersonaRelacionada != -1 ){ 						/* numCtePersonaRelacionada == -1  Significa que la persona Relacionada consultada no es un
																					cliente (No inicializar Forma).*/
						inicializaForma('personasRelacionadas','personaID');
						limpiaCombos();// se inicializa la forma SOLO SI se desea cambiar el cliente relacionado por un NO cliente
						habilitaFormularioCuentaPersona(); 						// habilitamos Los campos para ingresar los datos de uan persona
					}
				}
		}
		}

  	});
	//	Tipo de Persona
	$(':checkbox').change(function () {
		tipoPersonaSeleccionada(); // checamos Tipo de Personas seleccionadas
	});

	//	Datos Generales de la Persona

	$('#paisNacimiento').blur(function() {
		if(!estaDeshabilitado(this.id)){
	  		consultaPais(this.id, true);
	  		if($('#paisNacimiento').val()=='700'){
	  			$('#nacion').val('N');
	  			selectNacion = 'N';
				$('tr[name=extranjero]').hide(500);
				$('#paisResidencia').val(700);
				$('#paisR').val('MEXICO (PAIS)');
				habilitaControl('edoNacimiento');
				$('#edoNacimiento').focus();
	  		}else if( $('#paisNacimiento').val() != '700' && $('#paisNacimiento').val() != ''){
	  			$('#nacion').val('E');
	  			selectNacion = 'E';
				$('tr[name=extranjero]').show(500);
	  		}
		}
	});

	$('#fechaNacimiento').change(function () {
		$('#fechaNacimiento').focus();
		$('#fechaNacimiento').select();
		calculaEdad($('#fechaNacimiento').val());

	});
	$('#paisNacimiento').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('paisNacimiento', '2', '1', 'nombre',
					$('#paisNacimiento').val(), 'listaPaises.htm');
		}
	});
	$('#edoNacimiento').bind('keyup',function(e){
			lista('edoNacimiento', '2', '1', 'nombre', $('#edoNacimiento').val(), 'listaEstados.htm');

	});
	$('#edoNacimiento').blur(function() {
		consultaEstadoDatosP(this.id);
	});

	$('#generar').click(function() {
		if ($('#fechaNacimiento').val()!=''){
		formaRFC();
		$('#RFC').select();
		$('#RFC').focus();
		}else{
		mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
		}
	});
	$('#generarc').click(function() {
		if ($('#fechaNacimiento').val()!=''){
		formaCURP();
		$('#CURP').select();
		$('#CURPC').focus();
		}else{
		mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
		}
	});

	$('#paisRFC').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('paisRFC', '2', '1', 'nombre',$('#paisRFC').val(), 'listaPaises.htm');
		}
	});

	$('#paisRFC').blur(function() {
  		consultaPais(this.id, true);
	});

	$('#ocupacionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('ocupacionID', '1', '1', 'descripcion',
				 $('#ocupacionID').val(), 'listaOcupaciones.htm');
	});

	$('#ocupacionID').blur(function() {
  		consultaOcupacion(this.id);
	});
	//	Actividad
	$('#sectorGeneral').blur(function() {
  		consultaSecGeneral(this.id);
	});

	$('#sectorGeneral').bind('keyup',function(e){
		lista('sectorGeneral', '2', '1', 'descripcion', $('#sectorGeneral').val(), 'listaSectores.htm');
	});

	$('#actividadBancoMX').bind('keyup',function(e){
		if(this.value.length >= 4){
			lista('actividadBancoMX', '4', '1', 'descripcion',
					$('#actividadBancoMX').val(), 'listaActividades.htm');
		}
	});

	$('#actividadBancoMX').blur(function() {
  		consultaActividadBMX(this.id);
	});

	//	Identificación
	$('#fecExIden').change(function(){
		$('#fecExIden').focus().select();
		if ($('#fecExIden').val() > parametroBean.fechaAplicacion){
			mensajeSis('La Fecha Capturada es Mayor a la del Sistema');
			$('#fecExIden').val('');
			$('#fecExIden').focus();
		}
	});
	$('#fecVenIden').change(function(){
		$('#fecVenIden').focus().select();
	});
	$('#paisFea').bind('keyup',function(e) {
		lista('paisFea', '1', '1', 'nombre', $('#paisFea').val(),'listaPaises.htm');
	});

	$('#paisFea').blur(function() {
		consultaPais(this.id, true);
	});

	$('#paisFeaPM').bind('keyup',function(e) {
		lista('paisFeaPM', '1', '1', 'nombre', $('#paisFeaPM').val(),'listaPaises.htm');
	});

	$('#paisFeaPM').blur(function() {
		consultaPais(this.id, true);
	});

	$('#tipoIdentiID').change(function() {
		var numIden = $('#tipoIdentiID option:selected').val();

		if(numIden != '-1'){
			consultaNumeroCaracteresTipoIdent($('#tipoIdentiID').val());
		}else{
			mensajeSis("No Existe la Identificación del Cliente");
			deshabilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('elimina', 'submit');
			$('#tipoIdentiID').val('-1');
			$('#numIdentific').val('');
			$('#fecExIden').val('');
			$('#fecVenIden').val('');
		}

	});

	//	Nacionalidad
	$('#nacion').change(function () {
		var nacion = $('#nacion option:selected').val();
		if(nacion != ''){
			validaNacionalidadCte();
		}else{
			mensajeSis("Selecciona una Nacionalidad");
			deshabilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('elimina', 'submit');
		}
	});


	$('#paisResidencia').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('paisResidencia', '2', '1', 'nombre',
					$('#paisResidencia').val(), 'listaPaises.htm');
		}
	});

	$('#paisResidencia').blur(function() {
  		consultaPais(this.id, true);
	});
   	$('#docEstanciaLegal').change(function (){
		if(selectDocEstancia!=null){
			$('#docEstanciaLegal').val(selectDocEstancia).selected = true;
		}
	});
   	$('#docEstanciaLegal').blur(function (){
		if(selectDocEstancia!=''){
			$('#docEstanciaLegal').val(selectDocEstancia).selected = true;
		}
	});
   	$('#fechaVenEst').change(function(){
   		$('#fechaVenEst').focus().select();
	});
	//   	Escritura
	$('#numEscPub').blur(function() {
  		consultaEscritura(this.id);
  		if($('#numeroCte').val() > 0){
			deshabilitaCamposEscritura();
		}
	});
	$('#numEscPub').bind('keyup',function(e){
		if ($('#numeroCte').val() > 0){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#numeroCte').val();
		lista('numEscPub', '0', '3', camposLista,parametrosLista, 'listaEscrituraPub.htm');
		}
	});

	$('#fechaEscPub').change(function() {
		$('#fechaEscPub').focus().select();
		validaFechaInicio('fechaEscPub');
	});

	$('#estadoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
		}
	});

	$('#estadoID').blur(function() {
  		consultaEstado(this.id);
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

	$('#municipioID').blur(function() {
  		consultaMunicipio(this.id);
	});

	$('#notariaID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "estadoID";
			camposLista[1] = "municipioID";
			camposLista[2] = "titular";

			parametrosLista[0] = $('#estadoID').val();
			parametrosLista[1] = $('#municipioID').val();
			parametrosLista[2] = $('#notariaID').val();

			if($('#estadoID').val() != '' && $('#estadoID').asNumber() > 0 ){
				if($('#municipioID').val()!='' && $('#municipioID').asNumber()>0){
					lista('notariaID', '1', '1', camposLista, parametrosLista, 'listaNotarias.htm');
				}else{
					if($('#notariaID').val().length >= 3){
						$('#municipioID').focus();
						$('#notariaID').val('');
						$('#titularNotaria').val('');
						mensajeSis('Especificar Municipio');
					}
				}
			}else{
				if($('#notariaID').val().length >= 3){
					$('#estadoID').focus();
					$('#notariaID').val('');
					$('#titularNotaria').val('');
					mensajeSis('Especificar Estado');
				}

			}
	});

	$('#notariaID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if($('#notariaID').val() 	!= 	'' &&	$('#notariaID').val() > 0	&&	!isNaN($('#notariaID').val())){
			if($('#estadoID').val()!=''  ){
				if($('#municipioID').val() !=''){
					consultaNotaria(this.id);
				}else{
					$('#titularNotaria').val('');
					$('#notariaID').val('');
					mensajeSis("Elija un Municipio  antes de buscar Notaria");
				}
			}else{
				$('#titularNotaria').val('');
				$('#notariaID').val('');
				mensajeSis("Elija un Estado  antes de buscar Notaria");
			}
		}else{
			$('#titularNotaria').val('');
			$('#notariaID').val('');
		}

	});

	//Relación
	$('#parentescoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('parentescoID', '2', '1', 'descripcion',
					$('#parentescoID').val(), 'listaParentescos.htm');
		}
	});

	$('#parentescoID').blur(function() {
  		consultaParentesco(this.id,'');
	});

	//Botones de submit
	$('#agrega').click(function() {
		var consultaRadios=consultaRadiosActivados();
		if(consultaRadios==0){
			mensajeSis("Seleccione un Tipo de Persona");
			event.preventDefault();
		}else{
			$('#tipoTransaccion').val(catTipoTransaccionCtaPer.agrega);
		}
	});

	$('#modifica').click(function() {
		var consultaRadios=consultaRadiosActivados();
		if(consultaRadios==0){
			mensajeSis("Seleccione un Tipo de Persona");
			event.preventDefault();
		}else{
			$('#tipoTransaccion').val(catTipoTransaccionCtaPer.modifica);
		}
	});

	$('#elimina').click(function(event) {
		var consultaRadios=consultaRadiosActivados();
		if(consultaRadios==0){
			mensajeSis("Seleccione un Tipo de Persona");
			event.preventDefault();
		}else{
			$('#tipoTransaccion').val(catTipoTransaccionCtaPer.elimina);
		grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','personaID');
	      	limpiaForm('formaGenerica');
	      	deshabilitaBoton('elimina','submit');
		}
	});

	$('#esProvRecurso').click(function(){
		ocultaIngresosRealoRecursos();
		$('#ingreRealoRecursos').val('');
	});
	$('#esPropReal').click(function(){
		ocultaIngresosRealoRecursos();
		$('#ingreRealoRecursos').val('');
	});

	$('#agrega').attr('tipoTransaccion', '1');
	$('#modifica').attr('tipoTransaccion', '2');
	$('#elimina').attr('tipoTransaccion', '3');


	$('#telefonoCasa').setMask('phone-us');
	$('#telefonoCelular').setMask('phone-us');
	$('#telefonoPM').setMask('phone-us');

	$("#extTelefonoPart").blur(function(){
		if(this.value != ''){
			if($("#telefonoCasa").val() == ''){
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío");
				$("#telefonoCasa").focus();
			}
		}
	});
	$("#telefonoCasa").blur(function (){
		if(this.value ==''){
			$('#extTelefonoPart').val('');
		}
	});

	$('#porcentajeAccionM').blur(function() {
		if(esTab){
			validarPorcentaje(this.id,this.value);
		}
		asignaPorcentaje(this.id,this.value);
	});

	$('#porcentajeAccion').blur(function() {
		if(esTab){

			validarPorcentaje(this.id,this.value);
		}
		asignaPorcentaje(this.id,this.value);
	});

	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

		rules	: {
			cuentaAhoID: {
				required: true,
			},

			titulo: {
				required: function() {
					if ($('#tipoPersona').val() != 'M') {
						return true;
					}
					else {
						return false;
					}
				}
			},

			primerNombre: {
				required : function() {return $('#tipoPersona').val() != 'M';},
				minlength: 3
			},
			RFC: {

				required: function(){if((esMenorEdad == 'N') && $('#tipoPersona').val() != 'M' ){
					return true;}
				else {
					return false;
					}
				maxlength: 13;
				}
			},
			CURP: {
				required : function() {return $('#tipoPersona').val() != 'M';},
				maxlength: 18
			},
			ocupacionID: {
				required : function() {return $('#tipoPersona').val() != 'M';}

			},
			correo: 'email',
			cuentaAhoID: 'required',

			personaID: 'required',

			primerNombre: {
				required : function() {return $('#tipoPersona').val() != 'M';}
				},
			fechaNacimiento: {
				required : function() {return $('#tipoPersona').val() != 'M';},
				date: true ,
			},
			paisNacimiento:	{
				required : function() {return $('#tipoPersona').val() != 'M';}

			},
			estadoCivil		: {
				required : function() {return $('#tipoPersona').val() != 'M';}
			},
			sexo			: {
				required : function() {return $('#tipoPersona').val() != 'M';}

			},
			nacion			: {
				required : function() {return $('#tipoPersona').val() != 'M';}
			},
			actividadINEGI	: 'required',

			sectorEconomico: 'required',

			tipoIdentiID : {
				required : function() {
				  		if(esMenorEdad == 'N' && $('#numeroCte').asNumber() <= 0){
					  			return true;
					  		}
					  		else{
					  			return false;
					  		}
						}
			},
			numIdentific:{
			  	required: function() {
			  		if(esMenorEdad == 'N' && $('#numeroCte').asNumber() <= 0){
			  			return true;
			  		}
			  		else{
			  			return false;
			  		}
				},
				minlength: 5,
				maxlength: 18
			},
			fecExIden:{
				required:function() {
			  		if(esMenorEdad == 'N' && $('#numeroCte').asNumber() <= 0){
			  			return true;
			  		}
			  		else{
			  			return false;
			  		}
				},
				date: true,
			},
			fecVenIden:{
				required:function() {
			  		if(esMenorEdad == 'N' && $('#numeroCte').asNumber() <= 0){
			  			return true;
			  		}
			  		else{
			  			return false;
			  		}
				},
				date: true,
			},
			domicilio		: {
				required:function() {
			  		if(esMenorEdad == 'N' && $('#numeroCte').asNumber() <= 0){
			  			return true;
			  		}
			  		else{
			  			return false;
			  		}
				},
				minlength: 15
			},
			paisResidencia	: 'required',
			fechaEscPub		:'date',
			//estas son validaciones de escritura publica si y solo si es apoderado
			numEscPub		: 	{
				required		: function (){return $('#esApoderado').attr('checked');}
			},
			fechaEscPub		:	{
				required		: function (){return $('#esApoderado').attr('checked');}
			},
			estadoID		:	{
				required		: function (){return $('#esApoderado').attr('checked');}
			},
			municipioID		:	{
				required		: function (){return $('#esApoderado').attr('checked');}
			},
			notariaID		:	{
				required		: function (){return $('#esApoderado').attr('checked');}
			},
			titularNotaria	:	{
				required		: function (){return $('#esApoderado').attr('checked');}
			},
			//estas son validaciones de escritura publica si y solo si es beneficiario
			parentescoID	:	{
				required		: function (){return $('#esBeneficiario').attr('checked');}
			},
			porcentaje	:	{
				required		: function (){return $('#esBeneficiario').attr('checked');},
				min: function() {
					if ($('#esBeneficiario').attr('checked')) {
						return 1;
					}
					else {
						return 0;
					}
				}
			},
			ingreRealoRecursos:{
				maxlength:18,
				number:true
			},
			paisRFC: {
				required : function(){
							if ($('#nacion').val() == 'E'){
								return true;
							}else{
								return false;
							}
						}
			},
			porcentajeAccion:{

				required: function(){if( $('#esAccionista').attr('checked') && $('#tipoPersona').val() != 'M' ){
					return true;}
				else {
					return false;
					}
				}
			},
			porcentajeAccionM:{

				required: function(){if( $('#esAccionista').attr('checked') && $('#tipoPersona').val() == 'M' ){
					return true;}
				else {
					return false;
					}
				}
			}
		},

		messages: {
			cuentaAhoID: {
				required	: 'Especifique el Número de Cuenta.',
			},

			titulo: {
				required: 'Especifique Título'
			},

			primerNombre: {
				required	: 'Especifique el Nombre.',
				minlength	: 'Mínimo 3 Caracteres.'
			},

			correo: {
				email		: 'Dirección de correo Inválida.'
			},
			RFC	: {
				required	: 'Especifique RFC.',
				maxlength	: 'Máximo 13 Caracteres.',
			},
			CURP	: {
				required	: 'Especifique CURP.',
				maxlength	: 'Máximo 18 Caracteres.'
			},
			ocupacionID    	: 'Especifique la Ocupación.',
			cuentaAhoID		: 'Especifique Número de Cuenta.',
			personaID		: 'Especifique Número.',
			primerNombre	: 'Especifique Nombre.',
			fechaNacimiento: {
				required: 'Especifique Fecha de Nacimiento.',
				date: 'Fecha Incorrecta.',
			},
			estadoCivil		: 'Especifique Estado Civil.',
			sexo			: 'Especifique Género.',
			nacion			: 'Especifique Nacionalidad.',
			paisNacimiento	: 'Especifique País de Nacimiento.',
			actividadINEGI	: 'Especifique Actividad.',
			sectorEconomico:  'Especifique Sector.',
			tipoIdentiID : 'Especifique Tipo de Identificación'	,
			numIdentific:{
				  required: 'Especifique Folio de Identificación',
				  minlength:jQuery.format("Se Requieren Mínimo {0} Caracteres"),
				  maxlength:jQuery.format("Se Requieren Máximo {0} Caracteres"),
				} ,
			domicilio		:{
				required:function (){
					var mensaje= "";
				if($('#numeroCte').val().length>0){
					 mensaje='El cliente no tiene Domicilio Oficial.';
				}else{
					 mensaje='Especifique Domicilio.';
					}
				return mensaje;
				},
				minlength: 'Se Requieren Mínimo 15 Caracteres'
			},
			paisResidencia	: 'Especifique País.',
				fecExIden	: {
					required:'Especifique Fecha Expedición Identificación.',
					date:'Fecha Incorrecta'
				},
				fecVenIden	: {
					required:'Especifique Fecha Vencimiento Identificación.',
					date:'Fecha Incorrecta'
				},
				fechaEscPub	: 'Fecha Incorrecta.',
				//estas son validaciones de escritura publica si y solo si es apoderado
				numEscPub		: 	{
					required		: function (){
						var mensaje = 'Especifique  Número de Escritura Pública.';
						return mensaje;}
				},
				fechaEscPub		:	{
					required		: function (){
						var mensaje = 'Especifique  Fecha .';
						return mensaje;
					}
				},
				estadoID		:	{
					required		: function (){
						var mensaje = 'Especifique  Estado.';
						return mensaje;}
				},
				municipioID		:	{
					required		: function (){
						var mensaje = 'Especifique   Municipio.';
						return mensaje;}
				},
				notariaID		:	{
					required		: function (){
						var mensaje = 'Especifique Notaria.';
						return mensaje;}
				},
				titularNotaria	:	{
					required		: function (){
						var mensaje = 'Especifique el Nombre del Titular. ';
						return mensaje;}
				},
				//estas son validaciones de escritura publica si y solo si es beneficiario
				parentescoID	:	{
					required		: function (){
						var mensaje = 'Especifique el Parentesco.';
						return mensaje;}
				},
				porcentaje	:	{
					required		: function (){
						var mensaje = 'Especifique el Porcentaje.';
						return mensaje;},
					min: 'Mínimo 1'
				},
				ingreRealoRecursos:{
					maxlength:'Máximo 18 Caracteres.',
					number:'Sólo Números.'
				},
				paisRFC: {
					required : 'Especifique País que Asigna RFC.'
				},
				porcentajeAccion:{
					required : 'Indique el Porcentaje de Acciones.'
				},
				porcentajeAccionM:{
					required : 'Indique el Porcentaje de Acciones.'
				}
		}
	});

	//------------ Validaciones de Controles -------------------------------------

	function validaCtaPersona(idControl) {
		var jqCtaPersona  = eval("'#" + idControl + "'");
		var numCtaPersona = $(jqCtaPersona).val();
		var numCta = $('#cuentaAhoID').val();
		var conPersona = 1;
		numCtePersonaRelacionada = '';   // variable global
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaPersona != '' && !isNaN(numCtaPersona) && esTab){
			if(numCtaPersona == '0' && estatusCuenta != 'C'){
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('elimina', 'submit');
				habilitaFormularioCuentaPersona();
				inicializaForma('formaGenerica',idControl);
				limpiaPorcentaje();
				$('#primerNombre').attr('readOnly',false);
				$('#primerNombre').attr('disabled',false);
				$('#titulo').attr('readOnly',false);
				$('#titulo').attr('disabled',false);
				$('#tipoIdentiID').val('');//.selected = true;

				$('#miscelaneos').show();
				$('#tipoPersona').val('');
				$('#datosPersonaMoral').hide(500);
				$('#datosPersonaFisica').show(500);
				$('#escritura').hide();

				limpiaCombos();
			} else {
				if(numCtaPersona != '' && !isNaN(numCtaPersona) && esTab ){
					var CtaPersonaBeanCon = {
	  					'cuentaAhoID': numCta,
	  					'personaID': numCtaPersona
					};
					cuentasPersonaServicio.consultaCuentasPersona(conPersona,CtaPersonaBeanCon,{ async: false, callback:function(cuentaPer){
						if(cuentaPer!=null ){


							limpiaForm('#personasRelacionadas');

							dwr.util.setValues(cuentaPer);// la mas importante de esta operacion
							consultaClienteRelacion(cuentaPer.clienteID);

							var tipoPersonaRelacion= $('#tipoPersona').val();
							if(tipoPersonaRelacion == 'M'){
								$('#datosPersonaFisica').hide();
								if(cuentaPer.esAccionista=='S'){
									$('#porcentajeAccMo').show();
									$('#porcentajeAccionM').val(cuentaPer.porcentajeAccionista);
									consultaPaisFea('paisFeaPM');
								}
							}else{
								$('#datosPersonaMoral').hide();
								$('#miscelaneos').hide();
								consultaOcupacion('ocupacionID');
								consultaPaisFea('paisFea');
								consultaEstado('estadoID');
								consultaMunicipio('municipioID');
								consultaPais('paisNacimiento', false);
								if(cuentaPer.esAccionista=='S'){
									$('#porcentajeAcc').show();
									$('#porcentajeAccVal').show();
									$('#porcentajeAccion').val(cuentaPer.porcentajeAccionista);

								}
							}

						   	calculaEdad(cuentaPer.fechaNacimiento);
							consultaActividadBMX('actividadBancoMX');

							$('#fechaEscPub').val(cuentaPer.fechaEscPub);
							$('#numEscPub').val(cuentaPer.numEscPub );
							$('#telefonoCasa').setMask('phone-us');
							$('#telefonoCelular').setMask('phone-us');

							activarDesRadios(cuentaPer.esApoderado, cuentaPer.esAccionista, cuentaPer.esTitular,
									cuentaPer.esCotitular, cuentaPer.esBeneficiario, cuentaPer.esProvRecurso,
									cuentaPer.esPropReal,cuentaPer.	esFirmante);
							$('#ingreRealoRecursos').formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 2
							});


							ocultaIngresosRealoRecursos();

							consultaPais('paisResidencia', false);
							consultaPais('paisRFC', false);

							if(esMenorEdad=='N'){
								consultaNumeroCaracteresTipoIdent(cuentaPer.tipoIdentiID);
							}

							deshabilitaBoton('agrega', 'submit');
							if (estatusCuenta != 'C'){ // si la cuenta esta cancelada
								habilitaBoton('modifica', 'submit');
								habilitaBoton('elimina', 'submit');
							}
							if (cuentaPer.sectorGeneral != 0) {
								consultaSecGeneral('sectorGeneral');
							}else {
								$('#sectorGeneral').val('');
								$('#actividadINEGI').val('');
								$('#sectorEconomico').val('');
							}
							if(cuentaPer.fechaEscPub=='1900-01-01' || cuentaPer.fechaEscPub=='0000-00-00'){
								$('#fechaEscPub').val('');
							}
							if(cuentaPer.fechaNacimiento=='1900-01-01' || cuentaPer.fechaNacimiento=='0000-00-00'){
								$('#fechaNacimiento').val('');
							}
							if(cuentaPer.fecExIden=='1900-01-01' || cuentaPer.fecExIden=='0000-00-00'){
								$('#fecExIden').val('');
							}
							if(cuentaPer.fecVenIden=='1900-01-01' || cuentaPer.fecVenIden=='0000-00-00'){
								$('#fecVenIden').val('');
							}
							if(cuentaPer.fechaVenEst=='1900-01-01' || cuentaPer.fechaVenEst=='0000-00-00'){
								$('#fechaVenEst').val('');
							}
							if(cuentaPer.clienteID > 0){ // si el relacionado es cliente entonces se consulta y deshabilitan los campos
								$('#numeroCte').val(cuentaPer.clienteID);
								esTab = true;
								numCtePersonaRelacionada =cuentaPer.clienteID;
								consultaCliente(cuentaPer.clienteID,'modificaMismoCte',cuentaPer);
								soloLEcturaFomCuentas();
							}else{
								numCtePersonaRelacionada = -1;
								habilitaFormularioCuentaPersona();

							}
							if(cuentaPer.estadoID=='' || cuentaPer.estadoID==0){
								$('#nombreEstado').val('');
							}
							if(cuentaPer.municipioID=='' || cuentaPer.municipioID==0){
								$('#nombreMuni').val('');
							}

							if(cuentaPer.edoNacimiento=='' || cuentaPer.edoNacimiento==0){
								$('#nomEdoNacimiento').val('');
							}else{consultaEstadoDatosP('edoNacimiento');}

							// si no trae numero de escritura entonces no selecciono una existente
							if(cuentaPer.numEscPub !='' && cuentaPer.numEscPub !=null){
								consultaEscritura('numEscPub');
								consultaEstado('estadoID');
								consultaMunicipio('municipioID');
								habilitaCamposEscritura();
								consultaNotaria('notariaID');
							}

							if(cuentaPer.nacion == 'N'){
								$('tr[name=extranjero]').hide(500);
							}else{
								$('tr[name=extranjero]').show(500);
							}

							if(cuentaPer.esApoderado != 'S'  && cuentaPer.esTitular != 'S' &&
									cuentaPer.esCotitular!='S' && cuentaPer.esProvRecurso != 'S' &&
									cuentaPer.esPropReal != 'S' && cuentaPer.esFirmante
									&& cuentaPer.esBeneficiario != 'S'){
								$('#miscelaneos').hide();
								$('#escritura').hide();
								$('#beneficiarios').hide();
							} else{
								// si esta seleccionado cualquiera que no sea el Beneficiario
								if(cuentaPer.esBeneficiario == 'S'){
									$('#beneficiarios').show();
									consultaParentesco('',cuentaPer.parentescoID);

									//segun lo que habiamos visto del mensaje anterior si selecciona el beneficiaro no se debe mostrar micelaneos
									$('#miscelaneos').hide();
								} else{
									$('#beneficiarios').hide();
									$('#miscelaneos').show();
								}

								if(cuentaPer.esApoderado == 'S'){//definido informalmente el 29 oct 2013 solo el apoderado debe ser el unico que pueda agregar escritura publica
									$('#escritura').show();
								} else{
									$('#escritura').hide();
								}
							}
						}else {
							mensajeSis("No Existe la Persona");
							inicializaForma('formaGenerica','jqCtaPersona');
							limpiaCombos();
							habilitaFormularioCuentaPersona();
							$(jqCtaPersona).focus();
							$(jqCtaPersona).select();
							deshabilitaBoton('modifica', 'submit');
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('elimina', 'submit');
							ocultaIngresosRealoRecursos();
							$('#datosPersonaMoral').hide(500);
							$('#datosPersonaFisica').show(500);
							$('#escritura').hide();
						}
						}
					});
				}
			}
		}
	}

	function consultaCtaAho(control) {
		habilitaControl('personaID');
		habilitaControl('numeroCte');

		var numCta = $('#cuentaAhoID').val();
		var tipConCampos = 4;
		var CuentaAhoBeanCon = {
			'cuentaAhoID' : numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCta != '' && !isNaN(numCta) && esTab) {
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon, function(cuenta) {

				if (cuenta != null) {
					$('#tipoCuenta').val(cuenta.descripcionTipoCta);
					$('#moneda').val(cuenta.descripcionMoneda);
					$('#cuentaAhoID').val(cuenta.cuentaAhoID);
					$('#numCliente').val(cuenta.clienteID);
					$('#totalPer').val(cuenta.totalPersonas);

					var cliente = $('#numCliente').asNumber();
					if (cliente > 0) {
						listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, cuenta.cuentaAhoID, 0);
						if (listaPersBloqBean.estaBloqueado != 'S') {
							expedienteBean = consultaExpedienteCliente(cliente);
							if (expedienteBean.tiempo <= 1) {
								if (alertaCte(cliente) != 999) {
									consultaClientePantalla('numCliente');
									estatusCuenta = cuenta.estatus;
									if (cuenta.estatus == 'C') {
										mensajeSis("La cuenta se encuentra Cancelada");
										$('#cuentaAhoID').focus();
									}
								}
							} else {
								limpiaCampos();
								limpiaForm('formaGenerica');
								$('#cuentaAhoID').focus();
								mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar');
								$('#cuentaAhoID').val('');
							}
						} else {
							limpiaCampos();
							limpiaForm('formaGenerica');
							$('#cuentaAhoID').focus();
							mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación');
							$('#cuentaAhoID').val('');
						}
					}
				} else {
					mensajeSis("No Existe la cuenta de ahorro");
					$('#cuentaAhoID').focus();
					$('#cuentaAhoID').select();

					inicializaForma('formaGenerica', 'jqCtaPersona');

				}
			});
		}
	}

	function consultaCteConCta(idControl) {
		var nomCliente = idControl;
		var lisCliente =1;
		var clienteBean = {
  			'nombreCompleto': nomCliente
		};
		if(nomCliente!='0'){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && esTab){
				clienteServicio.lista(lisCliente,clienteBean,function(clienteLista){
					if(clienteLista!=null){
						$('#numeroCte').val(clienteLista.numero);
					}
				});
			}
		}
	}

	function consultaCliente(numCliente, tipoTransaccion,cuentasPersonaBean) {
		var conCliente =1;
		var rfc = ' ';

		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' &&	numCliente != '0' && !isNaN(numCliente) ){
			var cliente = Number(numCliente);
			if(cliente>0){
				listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
				if(listaPersBloqBean.estaBloqueado!='S'){
					clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){

						if(cliente != null){
							if(tipoTransaccion == 'modificaMismoCte'  ){ // si es modificacion del mismo cliente Relacionado tomamos los sig. datos de CUENTASPERSONA y no de CLIENTES
								cliente.razonSocial = cuentasPersonaBean.razonSocial;
							}
							$('#tipoPersona').val(cliente.tipoPersona);
							if(cliente.tipoPersona == 'M'){
								limpiaDatosPersonaFisica();
								$('#datosPersonaMoral').show(500);
								$('#datosPersonaFisica').hide(500);
								$('#domicilioOficialPM').show(500);
								$('#identificacionDiv').hide(500);
								$('#nacionalidadDiv').hide(500);
								$('#nombreCompleto').val(cliente.nombreCompleto);
								$('#razonSocial').val(cliente.razonSocial);
								$('#razonSocialPM').val(cliente.razonSocial);
								$('#RFCpm').val(cliente.RFCpm);
								$('#nacionalidadPM').val(cliente.nacion);
								$('#paisConstitucionID').val(cliente.paisConstitucionID);
								consultaPais('paisConstitucionID', false);
								$('#correoPM').val(cliente.correo);
								$('#correoAlterPM').val(cliente.correoAlterPM);
								$('#telefonoPM').val(cliente.telefonoCasa);
								$('#extTelefonoPM').val(cliente.extTelefonoPart);
								$('#tipoSociedadID').val(cliente.tipoSociedadID);
								consultaSociedad('tipoSociedadID');
								$('#grupoEmpresarial').val(cliente.grupoEmpresarial);
								consultaGEmpres('grupoEmpresarial');
								$('#fechaRegistroPM').val(cliente.fechaConstitucion);
								$('#nombreNotario').val(cliente.nombreNotario);
								$('#numNotario').val(cliente.numNotario);
								$('#inscripcionReg').val(cliente.inscripcionReg);
								$('#escrituraPubPM').val(cliente.escrituraPubPM);
								$('#tipoPersona').val('M');
								$('#feaPM').val(cliente.fea);
								$('#paisFeaPM').val(cliente.paisFea);
								consultaPaisFea('paisFeaPM');
								$('#telefonoPM').setMask('phone-us');

								//Campos ocultos
								$('#primerNombre').val(cliente.primerNombre);
								$('#paisNacimiento').val(cliente.lugarNacimiento);
								$('#paisResidencia').val(cliente.paisResidencia);
								$('#nacion').val(cliente.nacion);
								consultaPais('paisResidencia', false);
								consultaIdenCliente(cliente.numero);

								deshabilitaCamposPersonaMoral();
								validaNacion('nacionalidadPM');


							}else{
								limpiaDatosPersonaMoral();
								$('#datosPersonaMoral').hide(500);
								$('#datosPersonaFisica').show(500);
								$('#domicilioOficialPM').hide(500);
								$('#identificacionDiv').show(500);
								$('#nacionalidadDiv').show(500);
								$('#nombreCompleto').val(cliente.nombreCompleto);
								$('#numeroCte').val(cliente.numero);
								$('#paisNacimiento').val(cliente.lugarNacimiento);
								$('#edoNacimiento').val(cliente.estadoID);
								$('#nacion').val(cliente.nacion);//.selected = true;
								$('#FEA').val(cliente.fea);
								$('#paisFea').val(cliente.paisFea);
								consultaPaisFea('paisFea');

								$('#titulo').val(cliente.titulo);//.selected = true;
								$('#puestoA').val(cliente.puesto);
								$('#tipoPersona').val('F');
								$('#titulo').val(cliente.titulo);

								$('#primerNombre').val(cliente.primerNombre);
								$('#segundoNombre').val(cliente.segundoNombre);
								$('#tercerNombre').val(cliente.tercerNombre);
								$('#apellidoPaterno').val(cliente.apellidoPaterno);
								$('#apellidoMaterno').val(cliente.apellidoMaterno);
								$('#fechaNacimiento').val(cliente.fechaNacimiento);
								$('#estadoCivil').val(cliente.estadoCivil);
								$('#sexo').val(cliente.sexo);

								$('#CURP').val(cliente.CURP);
								$('#RFC').val(cliente.RFC);

								$('#ocupacionID').val(cliente.ocupacionID);
								consultaOcupacion('ocupacionID');

								$('#telefonoCasa').val(cliente.telefonoCasa);
								$('#extTelefonoPart').val(cliente.extTelefonoPart);
								$('#telefonoCelular').val(cliente.telefonoCelular);
								$('#correo').val(cliente.correo);
								$('#paisResidencia').val(cliente.paisResidencia);
								consultaPais('paisResidencia', false);
								$('#razonSocial').val(cliente.razonSocial);
								$('#fax').val(cliente.fax);

							   	calculaEdad(cliente.fechaNacimiento);

							if(cliente.nacion == 'N'){
								$('tr[name=extranjero]').hide(500);
							} else{
								$('tr[name=extranjero]').show(500);
								var cteExtBeanCon = {
					  				'clienteID':cliente.numero
								};
								var consultaCliExtranjeroPrincipal = 1;
								cliExtranjeroServicio.consulta(consultaCliExtranjeroPrincipal, cteExtBeanCon,function(cteExt) {
									if(cteExt!=null){
										$('#docEstanciaLegal').val(cteExt.documentoLegal);
										$('#docExisLegal').val(cteExt.motivoEstancia);
										$('#fechaVenEst').val(cteExt.fechaVencimiento);
										$('#paisRFC').val(cteExt.paisRFC);
										consultaPais('paisRFC', false);
										$('#fea').val(cteExt.fea);
										$('#paisFea').val(cteExt.paisFea);
										consultaPaisFea('paisFea');

										if(cteExt.fechaVencimiento=='1900-01-01' || cteExt.fechaVencimiento=='0000-00-00'){
											$('#fechaVenEst').val('');
										}
										selectDocEstancia = cteExt.documentoLegal;
									}else{
											mensajeSis('El Cliente No tiene una Identificación Oficial Capturada');
											return;
									}
								});
							}

							selectNacion = cliente.nacion;
							if(selectNacion == null){selectNacion = '';}

							if(cliente.fechaNacimiento=='1900-01-01' || cliente.fechaNacimiento=='0000-00-00'){
								$('#fechaNacimiento').val('');
							}

							validaNacionalidadCte();
							consultaPais('paisResidencia', false);
							consultaPais('paisNacimiento', false);

							if (cliente.lugarNacimiento == '700') {
								$('#paisRFC').val('700');
							}
							consultaPais('paisRFC', false);
							consultaOcupacion('ocupacionID');

							esMenorEdad=cliente.esMenorEdad;
							if(cliente.esMenorEdad == 'N'){
								consultaIdenCliente(cliente.numero);
							}

					  		consultaEstadoDatosP('edoNacimiento');
							soloLEcturaFomCuentas();
						}
						$('#razonSocial').val(cliente.razonSocial);
						$('#sectorGeneral').val(cliente.sectorGeneral);
						$('#actividadBancoMX').val(cliente.actividadBancoMX);
						$('#actividadINEGI').val(cliente.actividadINEGI);
						$('#sectorEconomico').val(cliente.sectorEconomico);
						consultaActividadBMX('actividadBancoMX');
						consultaSecGeneral('sectorGeneral');
						consultaDireccion('numeroCte'); // fer

					}else{ // si no existe el Cliente
						mensajeSis("No Existe el Cliente");
						inicializaForma('personasRelacionadas','personaID');
						habilitaFormularioCuentaPersona(); // habilitamos Los campos para ingresar los datos de uan persona
						limpiaCombos();
						$('#numeroCte').focus();
						$('#datosPersonaMoral').hide(500);
						$('#datosPersonaFisica').show(500);
						$('#domicilioOficialPM').hide(500);
						$('#identificacionDiv').show(500);
						$('#nacionalidadDiv').show(500);
						$('#escritura').hide();
					}
					});
				} else {
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación');
					inicializaForma('personasRelacionadas','personaID');
					habilitaFormularioCuentaPersona();
					limpiaCombos();
					$('#numeroCte').focus();
				}
			}
		}

	}

	function consultaActividadBMX(idControl) {
		var jqActividad = eval("'#" + idControl + "'");
		var numActividad = $(jqActividad).val();
		var tipConCompleta = 3;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numActividad != '' && !isNaN(numActividad)){
			actividadesServicio.consultaActCompleta(tipConCompleta, numActividad,function(actividadComp) {
				if(actividadComp!=null){
					$('#descripcionBMX').val(actividadComp.descripcionBMX);
					$('#actividadINEGI').val(actividadComp.actividadINEGIID);
					$('#descripcionINEGI').val(actividadComp.descripcionINE);
					$('#sectorEconomico').val(actividadComp.sectorEcoID);
					$('#descripcionSE').val(actividadComp.descripcionSEC);
				}else{
					mensajeSis("No Existe la Actividad BMX");
					$('#descripcionBMX').val('');
					$('#actividadINEGI').val('');
					$('#descripcionINEGI').val('');
					$('#sectorEconomico').val('');
					$('#descripcionSE').val('');
				}
			});
		}else {
			$('#descripcionBMX').val('');
			$('#actividadINEGI').val('');
			$('#descripcionINEGI').val('');
			$('#sectorEconomico').val('');
			$('#descripcionSE').val('');
		}
	}

	function consultaSecGeneral(idControl) {
			var jqSecG = eval("'#" + idControl + "'");
			var numSec = $(jqSecG).val();
			var tipConForanea = 2;
			setTimeout("$('#cajaLista').hide();", 200);
			var sectoresBeanCon = {
  				'sectorID':numSec
				};
			if(numSec != '' && !isNaN(numSec)){
				sectoresServicio.consulta(tipConForanea,sectoresBeanCon,function(sector) {
					if(sector!=null){
						$('#sectorGral').val(sector.descripcion);
					}else{
						mensajeSis("No Existe el Sector");
						$('#sectorGral').val('');
					}
				});
			}else {
				$('#sectorGral').val('');
			}
	}

	function consultaNumeroCaracteresTipoIdent(numTipoIden) {
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoIden != '' && !isNaN(numTipoIden)){

			tiposIdentiServicio.consulta(tipConPrincipal,numTipoIden,function(tipIdentificacion) {
						if(tipIdentificacion != null){
							$('#numeroCaracteres').val(tipIdentificacion.numeroCaracteres);
						}else{
							mensajeSis("No Existe la Identificación");
						}
				});
			}
	}// fin de la funcion consultaNumeroCaracteresTipoIdent

	function consultaIdenCliente(numCliente) {
		var identificacionCliente = {
  			'clienteID': numCliente
  		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente) && numCliente != 0){
			  identifiClienteServicio.consulta(3,identificacionCliente,function(identificacion){
				if(identificacion!=null){
					$('#tipoIdentiID').val(identificacion.tipoIdentiID).selected = true;
					$('#numIdentific').val(identificacion.numIdentific);
					$('#fecExIden').val(identificacion.fecExIden);
					$('#fecVenIden').val(identificacion.fecVenIden);
					selectTipoIdenti = identificacion.tipoIdentiID;
					if(selectTipoIdenti == null){
						selectTipoIdenti = '';
					}
					if(identificacion.fecExIden=='1900-01-01' || identificacion.fecExIden=='0000-00-00'){
						$('#fecExIden').val('');
					}
					if(identificacion.fecVenIden=='1900-01-01' || identificacion.fecVenIden=='0000-00-00'){
						$('#fecVenIden').val('');
					}
					consultaNumeroCaracteresTipoIdent(identificacion.tipoIdentiID);

				}else{
					selectTipoIdenti = '';
					mensajeSis('El Cliente no tiene una Identificación Oficial Capturada');
					$('#numeroCte').focus();
					$('#numeroCte').select();
				}
			});
		}
	}

	function consultaDireccion(idControl) {
		var jqCliente = eval("'#" + idControl + "'");

		var numCliente = $(jqCliente).val();
		var direccionCliente = {
  			'clienteID':numCliente
		};
		setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && !isNaN(numCliente) && esTab){
				 direccionesClienteServicio.consulta(catTipoConsultaDirCliente.oficialDirec,direccionCliente,function(direccion) {
						if(direccion!=null){
							$('#domicilio').val(direccion.direccionCompleta);
						}

				});
			}
	}


	function consultaPais(idControl, origenInput) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		var idControlNomPais = '';
		if(idControl == 'paisResidencia'){
			idControlNomPais = 'paisR';
		}else if (idControl == 'paisConstitucionID') {
			idControlNomPais = 'descPaisConst';
		} else if(idControl == 'paisNacimiento'){
			idControlNomPais = 'paisNac';
		} else if(idControl == 'paisRFC'){
			idControlNomPais = 'NomPaisRFC';
		} else if(idControl == 'paisFea'){
			idControlNomPais = 'paisF';
		} else if(idControl == 'paisFeaPM'){
			idControlNomPais = 'paisFPM';
		}

		if(numPais != '' && !isNaN(numPais)&& esTab==true){
			paisesServicio.consultaPaises(conPais,numPais,function(pais) {
				if(pais!=null){
					$('#'+idControlNomPais).val(pais.nombre);
					if(idControlNomPais == 'paisNac'){
						if (Number(pais.paisID) != 700) {
							$('#edoNacimiento').val(0);
							deshabilitaControl('edoNacimiento');
							consultaEstadoDatosP('edoNacimiento');
						} else {
							if(origenInput){
								$('#edoNacimiento').focus();
								$('#edoNacimiento').val('');
								$('#nomEdoNacimiento').val('');
								habilitaControl('edoNacimiento');
							}
							consultaEstadoDatosP('edoNacimiento');
						}
					}

				}else{
					mensajeSis("No Existe el País");
					$(jqPais).val('');
					$(jqPais).focus();
					$('#'+idControlNomPais).val('');
					if(idControlNomPais == 'paisNac'){
						$('#edoNacimiento').val('');
						$('#nomEdoNacimiento').val('');
					}
				}
			});
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

	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numEstado != '' && !isNaN(numEstado)){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
						if(estado!=null){
							$('#nombreEstado').val(estado.nombre);
						}else{
							mensajeSis("No Existe el Estado");
							$(jqEstado).focus();
							$('#nombreEstado').val('');
						}
				});
			}
	}

	function consultaMunicipio(idControl) {
	var jqMunicipio = eval("'#" + idControl + "'");
	var numMunicipio = $(jqMunicipio).val();
	var numEstado =  $('#estadoID').val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);

	if(numMunicipio != '' && !isNaN(numMunicipio)  && (numMunicipio>0)){
		municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
					if(municipio!=null){
						$('#nombreMuni').val(municipio.nombre);

					}else{
						mensajeSis("No Existe el Municipio");
						$(jqMunicipio).focus();
						$('#nombreMuni').val('');
					}
			});
		}
	}

	function consultaNotaria(idControl) {
		var jqNotaria = eval("'#" + idControl + "'");
		var numNotaria = $(jqNotaria).val();
		var tipConForanea = 2;
		var notariaBeanCon = {
  			'estadoID':$('#estadoID').val(),
  			'municipioID':$('#municipioID').val(),
  			'notariaID':numNotaria
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(numNotaria != '' && !isNaN(numNotaria)){
			notariaServicio.consulta(tipConForanea,notariaBeanCon,function(notaria) {
					if(notaria!=null){
						$('#titularNotaria').val(notaria.titular);
						$('#direccion').val(notaria.direccion);
					}else{
						mensajeSis("El Número de Notaria No Existe");
						$('#titularNotaria').val('');
						$('#direccion').val('');
						$('#notariaID').val('');
						$('#'+idControl).focus();
						$('#'+idControl).select();
					}
				});
		}
	}

	function consultaParentesco(idControl,dato) {
		var numParentesco = dato;
		var jqParentesco = "";
		if(dato == ''){
			jqParentesco = eval("'#" + idControl + "'");
			numParentesco = $(jqParentesco).val();
		}
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		var ParentescoBean = {
				'parentescoID' : numParentesco
		};
		if(numParentesco != '' && !isNaN(numParentesco) && esTab){
			parentescosServicio.consultaParentesco(tipConPrincipal, ParentescoBean, function(parentesco) {
						if(parentesco!=null){
							$('#parentesco').val(parentesco.descripcion);
						}else{
							mensajeSis("No Existe el Parentesco");
							if(dato == ''){
								$(jqParentesco).focus().select();
							}
						}
				});
			}
		}


	function consultaClientePantalla(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente =5;
		var rfc = ' ';
		esTab = true;
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCliente != '' && !isNaN(numCliente)&& esTab){
			clienteServicio.consulta(conCliente,numCliente,rfc,{ async: false, callback:function(cliente){
				if(cliente!=null){
					var tipo = (cliente.tipoPersona);
					if(tipo=="F"){
						$('#nombreCliente').val(cliente.nombreCompleto);;
						$('#tipoPer').val("FISICA");
						$('#tipoPersona').val("F");
					}
					if(tipo=="M"){
						$('#nombreCliente').val(cliente.razonSocial);
						$('#tipoPer').val("MORAL");
						$('#tipoPersona').val("M");
					}
					if(tipo=="A"){
						$('#nombreCliente').val(cliente.nombreCompleto);;
						$('#tipoPer').val("FISICA CON ACT. EMP.");
						$('#tipoPersona').val("F");

					}

				}else{
					mensajeSis("No Existe el Cliente");
					$(jqCliente).focus();
				}
				}
			});
		}
	}

	function consultaClienteRelacion(idControl) {
		var numCliente = idControl;
		var conCliente =5;
		var rfc = ' ';

		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,{ async: false, callback:function(cliente){
				if(cliente!=null){
					var tipo = (cliente.tipoPersona);
					if(tipo=="M"){
						$('#tipoPersona').val("M");
					}else{
						$('#tipoPersona').val("F");

					}

				}
				}
			});
		}
	}

	function validaNacion(idControl) {
		var jqNacion = eval("'#" + idControl + "'");
		var valNacion = $(jqNacion).val();
		var nacional = 'N';

		if (valNacion == nacional) {
			deshabilitaControl('paisResidencia');
		}
		if (valNacion == 'E') {

		}
	}

	function validaNacionalidadCte(){
		var nacionalidad = $('#nacion').val();
		var pais= $('#paisNacimiento').val();
		var mexico='700';
		var nacdadMex='N';
		var nacdadExtr='E';

		if(nacionalidad==nacdadMex){
			$('tr[name=extranjero]').hide(500);

			if(pais!=mexico){
				mensajeSis("Por la Nacionalidad de la Persona el País debe ser México");
				$('#paisNacimiento').val('');
				$('#paisNac').val('');
			}
		}
		if(nacionalidad==nacdadExtr){
			$('tr[name=extranjero]').show(500);

			if(pais==mexico){
				mensajeSis("Por la Nacionalidad de la Persona el País No debe ser México");
				$('#paisNacimiento').val('');
				$('#paisNac').val('');
			}
		}
	}

	function consultaOcupacion(idControl) {
		if(esTab){
			var jqOcupacion = eval("'#" + idControl + "'");
		var numOcupacion = $(jqOcupacion).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numOcupacion != '' && !isNaN(numOcupacion) && numOcupacion >0){
			ocupacionesServicio.consultaOcupacion(tipConForanea,numOcupacion,function(ocupacion) {
						if(ocupacion!=null){
							$("#ocupacionC").val(ocupacion.descripcion);
						}else{
							mensajeSis("No Existe la Ocupación.");
							$('#ocupacionC').val('');
							$('#ocupacionID').focus();
						}
			});
		}else{
			$('#ocupacionID').val('0');
			$('#ocupacionC').val('');
		}
		}

	}

	function consultaEscritura(idControl) {
		var jqEscritura = eval("'#" + idControl + "'");
		var numEscritura = $(jqEscritura).val();
		var tipConPoderes = 3;
		var EscrituraBeanCon = {
	 			'escrituraPub': $('#numEscPub').val(),//numEscritura
				};
		//esTab=true;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numEscritura != '' && esTab){
			escrituraServicio.consulta(tipConPoderes,EscrituraBeanCon,function(escritura) {
				if(escritura!=null){

					$('#municipioID').val(escritura.localidadEsc);
					$('#notariaID').val(escritura.notaria);
					$('#escDireccion').show();
					$('#titularNotaria').val(escritura.nomNotario);
					$('#direccion').val(escritura.direcNotaria);
					$('#fechaEscPub').val(escritura.fechaEsc);
					$('#estadoID').val(escritura.estadoIDEsc);

					consultaEstado('estadoID');
					consultaMunicipio('municipioID');
					if($('#fechaEscPub').val()=='1900-01-01' || $('#fechaEscPub').val()=='0000-00-00'){
						$('#fechaEscPub').val('');
					}
				}else{
					if($('#numeroCte').asNumber() > 0){
						mensajeSis("La Escritura Pública No Existe");
						$('#numEscPub').focus();

						$('#numEscPub').val('');
						limpiaCamposEscritura();
					}else{
						habilitaCamposEscritura();
					}
					if($('#personaID').asNumber() >0){
							// si es mayor a 0 entonces se esta consultando por lo tanto no limpiamos campos
					}else{
						limpiaCamposEscritura();
					}
				}
			});
		}
	}
	function consultaGEmpres(idControl) {
		var jqGempresa = eval("'#" + idControl + "'");
		var numGempresa = $(jqGempresa).val();
		var conGempresa = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numGempresa != '' && !isNaN(numGempresa) && numGempresa > 0) {
			gruposEmpServicio.consulta(conGempresa,
					numGempresa, function(empresa) {
						if (empresa != null) {
							$('#descripcionGE').val(empresa.nombreGrupo);
						} else {
							if($('#grupoEmpresarial').val() > '0'){
							mensajeSis("No Existe el Grupo.");
							$('#grupoEmpresarial').focus();
							$('#descripcionGE ').val('');
							}
						}
					});
		}else{
			$('#descripcionGE').val('');
			$('#grupoEmpresarial').val('0');
		}
	}


	function consultaSociedad(idControl) {
		var jqSociedad = eval("'#" + idControl + "'");
		var numSociedad = $(jqSociedad).val();

		var SociedadBeanCon = {
			'tipoSociedadID': numSociedad
		};
		if (numSociedad != '' && !isNaN(numSociedad)) {
			tipoSociedadServicio.consulta(catTipoConsultaSociedad.foranea, SociedadBeanCon, function(sociedad) {
				if (sociedad != null) {
					$('#descripSociedad').val(sociedad.descripcion);
				}
				else {
					var tp = $('#tipoPersona').val();
					if (tp == 'M') {
						mensajeSis("No Existe el Tipo de Sociedad.");
					}
				}
			});
		}
	}

	function formaRFC(){
		var pn =$('#primerNombre').val();
		var sn =$('#segundoNombre').val();
	 	var tn =$('#tercerNombre').val();
		var nc =pn+' '+sn+' '+tn;

	 	var rfcBean = {
	 		'primerNombre':nc,
  			'apellidoPaterno':$('#apellidoPaterno').val(),
  			'apellidoMaterno':$('#apellidoMaterno').val(),
  			'fechaNacimiento':$('#fechaNacimiento').val()
		};
		clienteServicio.formaRFC(rfcBean,function(cliente) {
			if(cliente!=null){
				$('#RFC').val(cliente.RFC);
			}
	 	});
   	}

	function consultaTipoIden(){
		dwr.util.removeAllOptions('tipoIdentiID');
		dwr.util.addOptions('tipoIdentiID', {'':'SELECCIONAR'});
		dwr.util.addOptions('tipoIdentiID', {0:'OTRA'});
		tiposIdentiServicio.listaCombo(3, function(tIdentific){
			dwr.util.addOptions('tipoIdentiID', tIdentific, 'tipoIdentiID', 'nombre');
		});
	}


	function activarDesRadios(esApoderado,esAccionista,esTitular,esCotitular,
						esBeneficiario, esProvRecurso, esPropReal, esFirmante) {

		if (esApoderado == 'S'){
			$('#esApoderado').attr("checked",true);

		}
		if (esAccionista == 'S'){
			$('#esAccionista').attr("checked",true);

		}
		if (esTitular == 'S'){
			$('#esTitular').attr("checked",true);
		}
		if (esCotitular == 'S'){
			$('#esCotitular').attr("checked",true);
		}
		if (esBeneficiario == 'S'){
			$('#esBeneficiario').attr("checked",true);
		}
		if (esProvRecurso == 'S'){
			$('#esProvRecurso').attr("checked",true);
		}
		if (esPropReal == 'S'){
			$('#esPropReal').attr("checked",true);
		}
		if (esFirmante == 'S'){
			$('#esFirmante').attr("checked",true);
		}
	}

	// Consulta cuantos Tipos de PErsonas estan seleccionados
	function consultaRadiosActivados(){
		var totalesActivados=0;
		if ($('#esApoderado').attr("checked")==true){
			totalesActivados++;
		}
		if ($('#esAccionista').attr("checked")==true){
			totalesActivados++;
		}
		if ($('#esTitular').attr("checked")==true){
			totalesActivados++;
		}
		if ($('#esCotitular').attr("checked")==true){
			totalesActivados++;
		}
		if ($('#esBeneficiario').attr("checked")==true){
			totalesActivados++;
		}
		if ($('#esProvRecurso').attr("checked")==true){
			totalesActivados++;
		}
		if ($('#esPropReal').attr("checked")==true){
			totalesActivados++;
		}
		if ($('#esFirmante').attr("checked")==true){
			totalesActivados++;
		}
		return totalesActivados;
	}

	function desactivarRadiosOcultaDivs() { // menos titular y div de miselaneos(Es el default)
		$('#esApoderado').attr("checked",false);
		$('#esAccionista').attr("checked",false);
		$('#esCotitular').attr("checked",false);
		$('#esBeneficiario').attr("checked",false);
		$('#esProvRecurso').attr("checked",false);
		$('#esPropReal').attr("checked",false);
		$('#esFirmante').attr("checked",false);
		//$('#esTitular').attr("checked",false);
		$('#escritura').hide();
		$('#beneficiarios').hide();

	}
	function deshabilitaCamposEscritura(){
		$('#fechaEscPub').attr('readOnly',true);
		$('#estadoID').attr('readOnly',true);
		$('#municipioID').attr('readOnly',true);
		$('#notariaID').attr('readOnly',true);
	}
	function habilitaCamposEscritura(){
		$('#fechaEscPub').attr('readOnly',false);
		$('#estadoID').attr('readOnly',false);
		$('#municipioID').attr('readOnly',false);
		$('#notariaID').attr('readOnly',false);
	}
	function limpiaCamposEscritura(){
		$('#fechaEscPub').val('');
		$('#estadoID').val('');
		$('#municipioID').val('');
		$('#notariaID').val('');
		$('#nombreEstado').val('');
		$('#direccion').val('');
		$('#nombreMuni').val('');
		$('#titularNotaria').val('');
	}
	function limpiaPorcentaje(){

		$('#porcentajeAccMo').hide();
		$('#porcentajeAcc').hide();
	    $('#porcentajeAccVal').hide();
	    $('#porcentajeAccion').val('');
	    $('#porcentajeAccionM').val('');

	}

	//hoblita el formulario
	function habilitaFormularioCuentaPersona(){
		habilitaControl('titulo');
		habilitaControl('estadoCivil');
		habilitaControl('sexo');
		habilitaControl('tipoIdentiID');
		habilitaControl('nacion');
		$('input[name="docEstanciaLegal"]').attr('disabled',false);

		$('#primerNombre').attr('readOnly',false);
		$('#segundoNombre').attr('readOnly',false);
		$('#tercerNombre').attr('readOnly',false);
		$('#apellidoPaterno').attr('readOnly',false);
		$('#apellidoMaterno').attr('readOnly',false);
		$('#fechaNacimiento').removeAttr('readOnly');
		$('#paisNacimiento').attr('readOnly',false);
		$('#edoNacimiento').attr('readOnly',false);
		$('#CURP').attr('readOnly',false);
		$('#RFC').attr('readOnly',false);
		$('#puestoA').attr('readOnly',false);
		$('#telefonoCelular').attr('readOnly',false);
		$('#telefonoCasa').attr('readOnly',false);
		$('#correo').attr('readOnly',false);
		$('#ocupacionID').attr('readOnly',false);
		$('#sectorGeneral').attr('readOnly',false);
		$('#actividadBancoMX').attr('readOnly',false);
		$('#actividadINEGI').attr('readOnly',false);
		$('#sectorEconomico').attr('readOnly',false);
		$('#numIdentific').attr('readOnly',false);
		$('#fecExIden').attr('readOnly',false);
		$('#fecVenIden').attr('readOnly',false);
		$('#domicilio').attr('readOnly',false);
		$('#paisResidencia').attr('readOnly',false);
		$('#fechaVenEst').attr('readOnly',false);
		$('#docExisLegal').attr('readOnly',false);
		$('#extTelefonoPart').attr('readOnly',false);

		$('#FEA').attr('readOnly',false);
		$('#paisFea').attr('readOnly',false);
		$('#paisF').attr('readOnly',false);
		$('#paisRFC').attr('readOnly',false);
		$('#feaPM').attr('readOnly',false);
		$('#paisFeaPM').attr('readOnly',false);
		$('#paisFPM').attr('readOnly',false);
		//miscelaneos
		$('#razonSocial').attr('readOnly',false);
		$('#razonSocialPM').attr('readOnly',false);
		$('#fax').attr('readOnly',false);

		agregaCalendario('formaGenerica');
		//Botones
		permiteCalcularCURPyRFC('generarc','generar',3);
		$('#generar').removeAttr('disabled');
		$('#generarc').removeAttr('disabled');


	}

	//desactiva formulario
	function soloLEcturaFomCuentas(){
		deshabilitaControl('titulo');
		deshabilitaControl('estadoCivil');
		deshabilitaControl('sexo');
		deshabilitaControl('tipoIdentiID');
		deshabilitaControl('nacion');

		$('input[name="docEstanciaLegal"]').attr('disabled',true);

		//campos de Datos Generales de la Persona
		$('#primerNombre').attr('readOnly',true);
		$('#segundoNombre').attr('readOnly',true);
		$('#tercerNombre').attr('readOnly',true);
		$('#apellidoPaterno').attr('readOnly',true);
		$('#apellidoMaterno').attr('readOnly',true);
		$('#fechaNacimiento').attr('readOnly',true);
		$('#paisNacimiento').attr('readOnly',true);
		$('#edoNacimiento').attr('readOnly',true);
		$('#CURP').attr('readOnly',true);
		$('#RFC').attr('readOnly',true);
		$('#ocupacionID').attr('readOnly',true);
		$('#puestoA').attr('readOnly',true);
		//Campos de Actividad
		$('#sectorGeneral').attr('readOnly',true);
		$('#actividadBancoMX').attr('readOnly',true);
		$('#actividadINEGI').attr('readOnly',true);
		$('#sectorEconomico').attr('readOnly',true);
		//Campos de Identificacion
		$('#numIdentific').attr('readOnly',true);
		$('#fecExIden').attr('readOnly',true);
		$('#fecVenIden').attr('readOnly',true);
		$('#telefonoCasa').attr('readOnly',true);
		$('#telefonoCelular').attr('readOnly',true);
		$('#correo').attr('readOnly',true);
		$('#domicilio').attr('readOnly',true);
		$('#extTelefonoPart').attr('readOnly',true);

	//		Deshabilitacion de combos relacionados con clientes

		$('#fechaNacimiento').datepicker("destroy");
		$('#fecExIden').datepicker("destroy");
		$('#fecVenIden').datepicker("destroy");
		$('#fechaRegistroPM').datepicker("destroy");
		$('#fechaVenEst').datepicker("destroy");

		//Campos de Nacionalidads
		$('#paisResidencia').attr('readOnly',true);
		$('#fechaVenEst').attr('readOnly',true);
		$('#docExisLegal').attr('readOnly',true);

		$('#FEA').attr('readOnly',true);
		$('#paisFea').attr('readOnly',true);
		$('#paisRFC').attr('readOnly',true);
		$('#feaPM').attr('readOnly',true);
		$('#paisFeaPM').attr('readOnly',true);

		//miscelaneos
		$('#razonSocial').attr('readOnly',true);
		$('#razonSocialPM').attr('readOnly',true);
		$('#fax').attr('readOnly',true);

		//Botones

		$('#generarc').hide();
		$('#generar').hide();
		$('#generar').attr('disabled',true);
		$('#generarc').attr('disabled',true);

	}

	// Verifica que tipo de persona esta seleccionada para asicmostrar los divs correspondientes
	function tipoPersonaSeleccionada(){
		// si todos estan de seleccionados ocultamos todos los divs
		if($('#esApoderado').attr('checked')==false  && $('#esTitular').attr('checked')==false &&
				$('#esCotitular').attr('checked')==false && $('#esProvRecurso').attr('checked')==false &&
				$('#esPropReal').attr('checked')==false && $('#esFirmante').attr('checked')==false
				&& $('#esBeneficiario').attr('checked')==false && $('#esAccionista').attr('checked')==false ){
			limpiaForm('#miscelaneos');//evitamos que se guarde basura
			limpiaForm('#escritura');//evitamos que se guarde basura
			limpiaForm('#beneficiarios');//evitamos que se guarde basura
			$('#miscelaneos').hide();
			$('#escritura').hide();
			$('#beneficiarios').hide();
		}
		else{

			// si esta seleccionado cualquiera que no sea el Beneficiario
			if($('#esBeneficiario').attr('checked')){
				limpiaForm('#miscelaneos');//evitamos que se guarde basura
				$('#beneficiarios').show();
				$('#miscelaneos').hide();
			}else{
				limpiaForm('#beneficiarios');//evitamos que se guarde basura
				$('#beneficiarios').hide();
				$('#miscelaneos').show();
			}
			if($('#esApoderado').attr('checked')){//definido informalmente el 29 oct 2013 solo el apoderado debe ser el unico que pueda agregar escritura publica

				if ($('#tipoPersona').val() == "M") {
					mensajeSis("La Persona Moral No puede ser Apoderado.");
					$('#esApoderado').attr("checked", false);
				}
				$('#escritura').show();
			}else {
				$('#escritura').hide();
			}
			if($('#esAccionista').attr('checked')){

				if ($('#tipoPer').val() != "MORAL") {
					mensajeSis("El Cliente No puede Tener Accionistas Como Relacionados.");
					$('#esAccionista').attr("checked", false);
					$('#porcentajeAcc').hide();
					$('#porcentajeAccVal').hide();
					$('#porcentajeAccMo').hide();
				}else {
					if($('#tipoPersona').val() == "M"){
						$('#porcentajeAccMo').show();
						$('#porcentajeAccionista').val($('#porcentajeAccionM'));

					}else{
						$('#porcentajeAcc').show();
						$('#porcentajeAccVal').show();
						$('#porcentajeAccionista').val($('#porcentajeAccion'));
					}
				}

			}
		}if($('#esAccionista').attr('checked')==false ){
				$('#porcentajeAcc').hide();
				$('#porcentajeAccVal').hide();
				$('#porcentajeAccMo').hide();
				$('#porcentajeAccion').val('');
				$('#porcentajeAccionM').val('');

		}
	}
	//  le quita el check a todos los tipos de Personas
	function quitaTipoPersonaSeleccionada(){
			// quitamos todos los que estan seleccionados y ocultamos divs
			$('#esApoderado').attr('checked', false);
			$('#esTitular').attr('checked', false);
			$('#esCotitular').attr('checked', false);
			$('#esProvRecurso').attr('checked', false);
			$('#esPropReal').attr('checked', false);
			$('#esFirmante').attr('checked', false);
			$('#esBeneficiario').attr('checked', false);

			$('#miscelaneos').hide();
			$('#escritura').hide();
			$('#beneficiarios').hide();
	}
	function consultaIdentificacionSeleccionada(){
		if($('#tipoIdentiID').val()==0){
			 $("#lbIOtradentificacion").show();
			$("#otraIdentifi").show();
		}else{
			 $("#lbIOtradentificacion").hide();
			$("#otraIdentifi").hide();
			$("#otraIdentifi").val('');
		}
	}

	function calculaEdad(fecha){
		if(fecha < parametroBean.fechaAplicacion){
				var fechaNac=(fecha).split('-');
				var fechaActual=(parametroBean.fechaAplicacion).split('-');
				var anioNac = fechaNac[0];
				var anioAct = fechaActual[0];
				var mesNac = fechaNac[1];
				var mesAct = fechaActual[1];
				var diaNac = fechaNac[2];
				var diaAct = fechaActual[2];
				var anios = anioAct - anioNac;

				if(mesAct < mesNac){
					anios=anios-1;
				}
				if(mesAct = mesNac)	{
					if(diaAct < diaNac ){
						anios = anios - 1;
					}
				}
				if(anios < 18){
					esMenorEdad='S';

				}else{
					esMenorEdad='N';
				}
		}else{
			mensajeSis("La Fecha de Nacimiento es Mayor a la del Sistema");
			$('#fechaNacimiento').focus();
			$('#fechaNacimiento').val('');
		}
	}

	//funcion para mostrar u ocultar “Ingresos Propietario Real o Proveedor de Recursos
	function ocultaIngresosRealoRecursos(){
		if(($('#esProvRecurso').is(':checked'))||($('#esPropReal').is(':checked'))){
			$('#trIngresoRealoRecursos').show();
		}else{
			$('#trIngresoRealoRecursos').hide();
		}
	}

	function validarPorcentaje(controlID,valor){

		if(isNaN(parseFloat(valor))){
			mensajeSis("Porcentaje Inválido");
			$('#'+controlID).focus();
  	    	$('#'+controlID).val('');
		}else{
			if(valor<= 0 || valor>100){
				mensajeSis("El porcentaje debe ser mayor a Cero y menor a 100");
				$('#'+controlID).focus();
  	    	$('#'+controlID).val('');
			if(!/^[0-9]+(\.[0-9]{1,4})?$/.test(valor)){
				mensajeSis("Máximo 4 decimales");
				$('#'+controlID).focus();
  	    		$('#'+controlID).val('');
			}
		}
		$('controlID').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
				});
		$('#porcentajeAccionista').val(valor);
	}
	}
	function asignaPorcentaje(controlID,valor){

		if(isNaN(parseFloat(valor))){
			$('#'+controlID).focus();
  	    	$('#'+controlID).val('');
		}else{
		$('controlID').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
				});
		$('#porcentajeAccionista').val(valor);
		}
	}

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
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,{ async: false, callback:function(parametrosSisBean) {
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
		}});
	}


	function validaFechaInicio(idControl){
		var jqFechaInicio = eval("'#" + idControl + "'");
		var fechaInicio = $(jqFechaInicio).val();
		var fechaSistema= parametroBean.fechaSucursal;

		if(esFechaValida(fechaInicio)){
			if( mayor(fechaInicio, fechaSistema)){
				mensajeSis("La Fecha de Puede ser Mayor a la Fecha del Sistema.");
				$(jqFechaInicio).val(fechaSistema);
				$(jqFechaInicio).focus();
			}
		}else{
			mensajeSis("La Fecha no es Valida.");
			$(jqFechaInicio).val(fechaSistema);;
			$(jqFechaInicio).focus();
		}
	}

	function mayor(fecha, fecha2){
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

	//funcion valida fecha formato (yyyy-MM-dd)
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;}
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

	// funcion comprobar anio bisiesto
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}


});

	function valoresListaEscPub(valor,valor2){
			cargaValorLista('numEscPub', valor);
			cargaValorLista('fechaEscPub', valor2);
		}

	function deshabilitaCamposPersonaMoral() {
		deshabilitaControl('razonSocialPM');
		deshabilitaControl('actividadBancoMX');
		deshabilitaControl('RFCpm');
		deshabilitaControl('nacionalidadPM');
		deshabilitaControl('paisConstitucionID');
		deshabilitaControl('correoPM');
		deshabilitaControl('correoAlterPM');
		deshabilitaControl('telefonoPM');
		deshabilitaControl('extTelefonoPM');
		deshabilitaControl('tipoSociedadID');
		deshabilitaControl('grupoEmpresarial');
		deshabilitaControl('fechaRegistroPM');
		deshabilitaControl('nombreNotario');
		deshabilitaControl('numNotario');
		deshabilitaControl('inscripcionReg');
		deshabilitaControl('escrituraPubPM');

		deshabilitaControl('tipoIdentiID');
		deshabilitaControl('numIdentific');
		deshabilitaControl('fecExIden');
		deshabilitaControl('fecVenIden');
		deshabilitaControl('telefonoCasa');
		deshabilitaControl('extTelefonoPart');

		deshabilitaControl('fecVenIden');
		deshabilitaControl('correo');
		deshabilitaControl('fecExIden');
		deshabilitaControl('telefonoCelular');
		deshabilitaControl('domicilio');
		deshabilitaControl('nacion');
		deshabilitaControl('feaPM');
		deshabilitaControl('paisFeaPM');
		$('input[name="docEstanciaLegal"]').attr('disabled',true);
		deshabilitaControl('docExisLegal');
		deshabilitaControl('fechaVenEst');
		deshabilitaControl('paisRFC');
	}
	function limpiaDatosPersonaMoral() {
		$('#razonSocialPM').val('');
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
		$('#paisResidencia').val('');
		$('#nacionalidadPM').val("");
		$('#nacion').val("");
	}

	function limpiaDatosPersonaFisica() {
		$('#primerNombre').val('');
		$('#segundoNombre').val('');
		$('#tercerNombre').val('');
		$('#apellidoPaterno').val('');
		$('#apellidoMaterno').val('');
		$('#fechaNacimiento').val('');
		$('#paisNacimiento').val('');
		$('#paisNac').val('');
		$('#edoNacimiento').val('');
		$('#nomEdoNacimiento').val('');
		$('#CURP').val('');
		$('#RFC').val('');
		$('#ocupacionID').val('');
		$('#ocupacionC').val('');
		$('#puestoA').val('');
		$('#paisResidencia').val('');
		$('#paisR').val('');
		$('#telefonoCelular').val('');
		$('#telefonoCasa').val('');
		$('#extTelefonoPart').val('');
		$('#correo').val('');

		$('#titulo').val("");
		$('#nacion').val("");
		$('#sexo').val("");
		$('#estadoCivil').val("");
		$('#tipoIdentiID').val("");


	}
	function formaCURP() {
		var sexo = $('#sexo').val();
		var nacionalidad = $('#paisNacimiento').val();
		if(sexo == "M")
		{sexo = "H";}
		else if(sexo == "F")
		{sexo = "M";}
		else{
			sexo = "H";
			mensajeSis("Especifique el Género");
		}

		if(nacionalidad == "700")
		{nacionalidad = "N";}
		else if(nacionalidad != "")
		{nacionalidad = "S";}
		else{
			nacionalidad = "N";
			mensajeSis("Especifique el País de Nacimiento");
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
			'estadoID':$('#edoNacimiento').val()

		};
		clienteServicio.formaCURP(CURPBean, function(cliente) {
			if (cliente != null) {
				$('#CURP').val(cliente.CURP);
			}
		});
	}

		function consultaEstadoDatosP(idControl) {
			var jqEstado = eval("'#" + idControl + "'");
			var numEstado = $(jqEstado).val();
			var tipConForanea = 2;
			setTimeout("$('#cajaLista').hide();", 200);
			if (numEstado != '' && !isNaN(numEstado) ) {
				estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
				if (estado != null) {
					var p = $('#paisNacimiento').val();
					if (p == 700 && estado.estadoID == 0 && esTab) {
						mensajeSis("No Existe el Estado");
						$('#edoNacimiento').focus();
					}
					$('#nomEdoNacimiento').val(estado.nombre);
				} else {
					mensajeSis("No Existe el Estado");
					$('#nomEdoNacimiento').val('');
				}
				});
			}
		}
		function limpiaCampos(){
			$('#numCliente').val('');
			$('#nombreCliente').val('');
			$('#tipoCuenta').val('');
			$('#moneda').val('');
			$('#tipoPer').val('');
		}

		function limpiaCombos(){
			$('#titulo').val("");
			$('#estadoCivil').val("");
			$('#sexo').val("");
			$('#tipoIdentiID').val("");
			$('#nacion').val("");
		}

		function exitoTransCuenta(){
			inicializaForma('personasRelacionadas', 'personaID');

			deshabilitaBoton('elimina', 'submit');
			deshabilitaBoton('agregar', 'submit');
			deshabilitaBoton('modifica', 'submit');
			$('#nomEdoNacimiento').val("");

			limpiaCombos();

		}

		function falloTransCuenta(){

		}
