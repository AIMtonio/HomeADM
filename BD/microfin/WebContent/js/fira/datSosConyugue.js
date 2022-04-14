var tab2=false;
var implicaTrabajo ='N';


var ocupacionID = 0; // almacena la ocupacionID que tenia guardado el conyugue
	esTab = true;

	//Definicion de Constantes y Enums  
	var catTipoConsultaDatosConyug = {
			'principal':1,
			'foranea':2,
			'infoDatosSocioe':3
	};		

	var catTipoTranDatosConyug = {
			'graba':1,
			'modifica':2,
			'grabalista':3
	};
	var catTipoConsultaDirCliente= {
		'dirTrabajo' : 8	
		
	};
	var parametroBean = consultaParametrosSession();  
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('grabar', 'submit');
	llenaComboTiposIdenti();
	
	agregaFormatoControles('formaGenerica3');
	
	$(':text').focus(function() {	
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccion(event, 'formaGenerica3', 'contenedorForma', 'mensaje','false','pNombre');	
			$("label.error").hide(); 
			$(".error").removeClass("error");
		}
	});					

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#grabarCony').click(function() {	
		conyugeID=$('#buscClienteID').val();
		$('#tipoTransaccionCony').val(catTipoTranDatosConyug.graba);
	});

	$('#buscClienteID').bind('keyup',function(e){
		lista('buscClienteID', '1', '13', 'nombreCompleto', $('#buscClienteID').val(), 'listaCliente.htm');
	}); 

	$('#nacionaID').change(function(){
		$('#paisNacimiento').val('');
		$('#nombPaisNacim').val('');
	});

	$('#buscClienteID').blur(function() {
		if($('#buscClienteID').val()!='' && $('#buscClienteID').val()>0 && !isNaN($('#buscClienteID').val())){
			if($('#buscClienteID').val()==conyugeID){ //Realizar la consulta pero con los datos guardados del conyuge
				consultaDatosCony();
				
			} else { //Se realiza consulta en clientes
				consultaClienteConyug(this.id);
				consultaClienteDirec(this.id);
			}
		}
		else {
				if(isNaN($('#buscClienteID').val())){
					$('#buscClienteID').focus();
				}else{
					if($('#buscClienteID').val()  == '0'){
						inicializaFormaConyugue();
					}					
				}
		}
			
	});
	
	function consultaDatosCony(){
		var tipolistaPrincipal= {
			'principal': 1			
		};
		var clienteID = $('#clienteID').val();
		var prospectoID = $('#prospectoID').val();
		var datSocConyugueBean = {
			'prospectoID': prospectoID,
			'clienteID':  clienteID
		};
		
		limpiaInputsForm('formaGenerica3');
		$('#formaGenerica3').show('slow');
		
		socDemoConyugServicio.consulta(tipolistaPrincipal.principal,datSocConyugueBean ,function(conyugue){ 
			if(conyugue!=null){	
				camposDatosConyugue(conyugue);
				var jQpaisNacimiento = eval("'#paisNacimiento'");
								
				if(conyugue.ocupacionID!='0'){
					$('#ocupacionID').val(conyugue.ocupacionID);
					ocupacionID = conyugue.ocupacionID;
				}else{
					 $('#ocupacionID').val('');
					 ocupacionID = '';
				}
				if(	$('#ocupacionID').val()!='' && $('#ocupacionID').val()!='0'){
					consultaOcupacion('ocupacionID');
				}
								
				var clienteID = conyugue.clienteConyID;
				if(parseInt(clienteID)>0){
					$('#buscClienteID').val(conyugue.clienteConyID);
					deshabilitaControl('tipoIdentiID');
					deshabilitaControl('folioIdentificacion');
				}else{
					$('#buscClienteID').val('');
					habilitaControl('tipoIdentiID');
					habilitaControl('folioIdentificacion');
				}
				$('#pNombre').val(conyugue.primerNombre);						 
				$('#sNombre').val(conyugue.segundoNombre);
				$('#tNombre').val(conyugue.tercerNombre);

				if(conyugue.empresaLabora!=''){
					$('#empresaLabora').val(conyugue.empresaLabora);
				}else{
					$('#empresaLabora').val('');
				}
								
				$('#entFedID').val(conyugue.entFedID); 
				if ($('#entFedID').val()!='' && $('#entFedID').val()!='0') {
					consultaEstado('entFedID','entidadFedNombre');
				}
				$('#municipioID').val(conyugue.municipioID);
				if( $('#municipioID').val()!='' && $('#municipioID').val()!='0'){
					consultaMunicipio('municipioID');
				}
				$('#localidadID').val(conyugue.localidadID);
				if( $('#localidadID').val()!='' && $('#localidadID').val()!='0'){
					consultaLocalidad('localidadID');
				}
				$('#coloniaID').val(conyugue.coloniaID);
				
				if( $('#coloniaID').val()!='' && $('#coloniaID').val()!='0'){
					consultaColonias('coloniaID');
				}
				$('#aPaterno').val(conyugue.apellidoPaterno);
				$('#aMaterno').val(conyugue.apellidoMaterno);
				$('#colonia').val(conyugue.colonia);
				$('#calle').val(conyugue.calle);
				
				if(conyugue.numero != 0){
					$('#numero').val(conyugue.numero);
				}else{
					$('#numero').val("");
				}
				if(conyugue.interior != 0){
					$('#interior').val(conyugue.interior);
				}else{
					$('#interior').val("");
				}
				if(conyugue.piso != 0){
					$('#piso').val(conyugue.piso);
				}
				else{
					$('#piso').val("");
				}
				$('#nacionaID').val(conyugue.nacionaID);
				$(jQpaisNacimiento).val(conyugue.paisNacimiento);
								
				if(conyugue.fechaExpedicion !='1900-01-01'){
					$('#fechaExpedicion').val(conyugue.fechaExpedicion);
				}else{
					$('#fechaExpedicion').val('');
				}
				if(conyugue.fechaVencimiento !='1900-01-01'){
					$('#fechaVencimiento').val(conyugue.fechaVencimiento);
				}else{
					$('#fechaVencimiento').val('');
				}
				$('#telCelular').val(conyugue.telCelular);
				$('#tipoIdentiID').val(conyugue.tipoIdentiID);
				tipoIndenConyuge=conyugue.tipoIdentiID;
				consultaTipoIdent();
				$('#folioIdentificacion').val(conyugue.folioIdentificacion);
				$('#fechaRegistro').val(parametroBean.fechaAplicacion);	
				
				$('#telCelular').setMask('phone-us');		
				
			}
			else{ 	
				camposDatosConyugue("");
			}
		});
  	}

	function validaMesAntiguedad() {
		var mesesAntig = $('#mesesAnti').asNumber();
		if(mesesAntig >11){
			mensajeSis("El Número de Meses no Debe ser Mayor a 11 ");
			$('#mesesAnti').val('');
			$('#mesesAnti').focus();
		}
		if($("#mesesAnti").val()=='')
		{
			$("#mesesAnti").val(0);
		}	
		if (isNaN($("#mesesAnti").val())) 
		{
			mensajeSis("El Número de Meses debe ser un Número Entero.");
			$('#mesesAnti').val('');
			$('#mesesAnti').focus();
		}
		if($("#mesesAnti").asNumber()<0)
		{
			mensajeSis("El Número de Meses debe ser un Número Positivo.");
			$('#mesesAnti').val('');
			$('#mesesAnti').focus();
		}

	}
	
	function validaAniosAntiguedad() {
		if($("#aniosAnti").val()=='')
		{
			$("#aniosAnti").val(0);
		}	
		if (isNaN($("#aniosAnti").val())) 
		{
			mensajeSis("El Número de Años Debe ser un Número Entero.");
			$('#aniosAnti').val('');
			$("#aniosAnti").focus();
		}
		if($("#aniosAnti").asNumber()<0)
		{
			mensajeSis("El Número de Años Debe ser un Número Positivo.");
			$('#aniosAnti').val('');
			$("#aniosAnti").focus();
		}
		
		
	}
	


////	validaciones fechas

	function validaFecNacimiento(Xfecha) { 	
		if(Xfecha !=''){
			if(!esFechaValida(Xfecha)){
				$('#fecNacimiento').focus();
			}else{
				$("label.error").hide(); 
				$(".error").removeClass("error");
			}
		}		
	}
	
	$('#fechaExpedicion').change(function() {
		var Xfecha= $('#fechaExpedicion').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaExpedicion').val('');
			var Yfecha= $('#fechaVencimiento').val();
			if(Yfecha!=''){
				if ( mayor(Xfecha, Yfecha) )
				{
					mensajeSis("La Fecha de Expedición es mayor o igual a la Fecha de Vencimiento.")	;
					$('#fechaExpedicion').val('');
					$('#fechaExpedicion').focus();
				}
			}
			$('#fechaExpedicion').focus();
		}else{
			$('#fechaExpedicion').val('');
			$('#fechaExpedicion').focus();
		}
	});

	$('#fechaVencimiento').change(function() {
		var Xfecha= $('#fechaExpedicion').val();
		var Yfecha= $('#fechaVencimiento').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimiento').val('');
			if(Yfecha!=''){
				if ( mayor(Xfecha, Yfecha) )
				{
					mensajeSis("La Fecha de Expedición es mayor o igual a la Fecha de Vencimiento.")	;
					$('#fechaVencimiento').val('');
					$('#fechaVencimiento').focus();
				}
			}
			$('#fechaVencimiento').focus();
		}else{
			$('#fechaVencimiento').val('');
			$('#fechaVencimiento').focus();
		}

	});

	// fin validaciones fechas
	
	


	$('#entFedID').bind('keyup',function(e) {
		lista('entFedID', '2', '1', 'nombre',$('#entFedID').val(),'listaEstados.htm');
	});

	$('#entFedID').blur(function() {
		consultaEstado(this.id,'entidadFedNombre');
	});


	$('#ocupacionID').bind('keyup',function(e) { 
		lista('ocupacionID', '1', '1', 'descripcion',$('#ocupacionID').val(),'listaOcupaciones.htm');
	});

	$('#ocupacionID').blur(function() {
		consultaOcupacionFechaTrabajo(this.id);
	});

	function generarRFC() {
		if ($('#fecNacimiento').val()!=''){
			formaRFC();
		}else{
			mensajeSis('Se Necesita la Fecha de Nacimiento para esta Opción.');
		}
	}

	$('#municipioID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";


		parametrosLista[0] = $('#entFedID').val();
		parametrosLista[1] = $('#municipioID').val();

		lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});

	$('#municipioID').blur(function() {
		consultaMunicipio(this.id);
	});

	$('#localidadID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "nombreLocalidad";
		
		
		parametrosLista[0] = $('#entFedID').val();
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
		
		
		parametrosLista[0] = $('#entFedID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#localidadID').val();
		parametrosLista[3] = $('#coloniaID').val();
		
		lista('coloniaID', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
	});

	$('#localidadID').blur(function() {
		consultaLocalidad(this.id);
	});
	$('#coloniaID').blur(function() {
		consultaColonia(this.id);
	});

	$('#pNombre').blur(function() {
		var nombre = $('#pNombre').val();
		$('#pNombre').val($.trim(nombre));
	});
	
	$('#sNombre').blur(function() {
		var senombre = $('#sNombre').val();
		$('#sNombre').val($.trim(senombre));
	});
	
	$('#tNombre').blur(function() {
		var ternombre = $('#tNombre').val();
		$('#tNombre').val($.trim(ternombre));
	});
	
	$('#aPaterno').blur(function() {
		var ap = $('#aPaterno').val();
		$('#aPaterno').val($.trim(ap));
	});
	
	$('#aMaterno').blur(function() {
		var am = $('#aMaterno').val();
		$('#aMaterno').val($.trim(am));
	});
	
	$('#tipoIdentiID').change(function() {
		if(this.value != ''){
			consultaTipoIdent();
			$("label.error").hide(); 
			$(".error").removeClass("error");
		}else{
			$('#folioIdentificacion').val('');
		}
		
	});
	$('#tipoIdentiID').blur(function() {
		if(this.value != ''){
			consultaTipoIdent();
			$("label.error").hide(); 
			$(".error").removeClass("error");
		}else{
			$('#folioIdentificacion').val('');
		}
		
	});
	
	$('#folioIdentificacion').bind('keyup',function(){
		if(this.value != ''){			
			var tipoIdenti = $('#tipoIdentiID').val();
			
			if(tipoIdenti==1 &&  this.value.length >= 18){
				$("label.error").hide(); 
				$(".error").removeClass("error");
			}if(tipoIdenti==2 && this.value.length >= 9){
				$("label.error").hide(); 
				$(".error").removeClass("error");
			}if(tipoIdenti>2 && this.value.length >= 5){
				$("label.error").hide(); 
				$(".error").removeClass("error");
			}
			
		}
		
	});
	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica3').validate({
		rules: {
			pNombre: { 
				required: true
			},
			aPaterno: { 
				required: true
			},
			telCelular : {
				required : false,
				minlength : 7,
				maxlength : 15
			},
			telEmpresa: {
				required : false,
				minlength : 7,
				maxlength : 15
			},

			paisNacimiento :{
				required: true
			},
			codPostal:{
				required: false,
				maxlength : 6
			},
			estadoID :{
				required: true
			},

			fecNacimiento :{
				required: true
			},
			extencionTrabajo :{
				number: true
			},
			tipoIdentiID:{
				required: true
			},
			folioIdentificacion:{
				  required: true,
				  minlength:function(){
						var tipoIdenti = $('#tipoIdentiID').val();
						var numc = 5;
   					if(tipoIdenti==1){
  						var elec= $('#numeroCaracteres').val();
							return elec;
						}if(tipoIdenti==2){
							var pasa= $('#numeroCaracteres').val();
							return pasa;
						}if(tipoIdenti>2){
							return numc;
						}
				  } ,
 				  maxlength:function(){
						var tipoIdenti = $('#tipoIdentiID').val(); 
						var numc=15;
						if(tipoIdenti==1){
							var elec= $('#numeroCaracteres').val();
							return elec;
						}if(tipoIdenti==2){
							var pasa= $('#numeroCaracteres').val();
							return pasa;
						}if(tipoIdenti>2){
							return numc;
							
						}
				  }  
				  
				},

				rfcConyugue : {
					required: true,
					maxlength: 13
				}


		},

		messages: {
			tipoIdentiID:{
				required: 'Especifique Tipo de Indentificación'
			},
			folioIdentificacion:{
				  required: 'Especifique Folio de Identificación',
				  minlength:jQuery.format("Se requieren {0} Caracteres"),
				  maxlength:jQuery.format("Se requieren {0} Caracteres"),
				} , 
			pNombre: {
				required: 'Especifique Nombre'
			},
			aPaterno: {
				required: 'Especifique Apellido paterno'
			},

			paisNacimiento :{
				required: 'Especifique País de Nacimiento'
			},
			telEmpresa : {
				minlength : 'Mínimo 7 carácteres',
				maxlength : 'Máximo 15 carácteres'
			},
			telCelular: {
				minlength : 'Mínimo 7 carácteres',
				maxlength : 'Máximo 15 carácteres'
			},
	
			estadoID :{
				required: 'Especifique Entidad Federativa'
			},
			codPostal:{
				maxlength : 'Máximo 6 carácteres'
			},
			fecNacimiento :{
				required: 'Especifique Fecha de Nacimiento'
			},
			extencionTrabajo : {
				number: 'Sólo Números(Campo opcional)'
			},
			rfcConyugue : {
				required: 'Especifique RFC',
				maxlength: 'M&aacute;ximo 13 caracteres'
			}

		}		
	});

	//------------ Validaciones de Controles -------------------------------------



	function llenaComboTiposIdenti(){

		dwr.util.removeAllOptions('tipoIdentiID'); 
		tiposIdentiServicio.listaCombo(3, function(tIdentific){
			dwr.util.addOptions('tipoIdentiID'	,{'':'SELECCIONAR'});
			dwr.util.addOptions('tipoIdentiID', tIdentific, 'tipoIdentiID', 'nombre');
		});
	}


	function consultaClienteConyug(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		

		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(catTipoConsultaDatosConyug.principal,numCliente,function(cliente) {
				if(cliente!=null){
						if(cliente.esMenorEdad != "S"){
								esTab=true;
								$('#buscClienteID').val(numCliente);
								$('#pNombre').val(cliente.primerNombre);
								$('#sNombre').val(cliente.segundoNombre);
								$('#tNombre').val(cliente.tercerNombre);
								$('#aPaterno').val(cliente.apellidoPaterno);
								$('#aMaterno').val(cliente.apellidoMaterno);
								$('#nacionaID').val(cliente.nacion);
								$('#paisNacimiento').val(cliente.lugarNacimiento);
								$('#estadoID').val(cliente.estadoID);
								$('#fecNacimiento').val(cliente.fechaNacimiento);
								$('#rfcConyugue').val(cliente.RFC );
								$('#telCelular').val(cliente.telefonoCelular );
								$('#ocupacionID').val(cliente.ocupacionID);	

								$('#grupoEmpresaID').val(cliente.grupoEmpresarial);
								$('#telEmpresa').val(cliente.telTrabajo);
								$('#empresaLabora').val(cliente.lugarTrabajo);
								$('#fechaIniTrabajo').val(cliente.fechaIniTrabajo);
								$('#extencionTrabajo').val(cliente.extTelefonoTrab);
								
								ocupacionID = cliente.ocupacionID;
								if(cliente.fechaIniTrabajo == "1900-01-01"){
									$('#fechaIniTrabajo').val('');
									$('#aniosAnti').val(parseInt(cliente.antiguedadTra));
									$('#mesesAnti').val('0');
								}else{
									if(cliente.fechaIniTrabajo!=null && cliente.fechaIniTrabajo != ""){
									var antiguedadAnio = "";
									var antiguedadMes = "";
									var antiguedad = cliente.fechaIniTrabajo;
									var fechaActualSistema = parametroBean.fechaSucursal;
									
									$('#fechaIniTrabajo').val(cliente.fechaIniTrabajo);
										
										var fechaInicioTrabajo = antiguedad.split("-");
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
										//	if(hoy_Mes != 2 && hoy_Mes != ini_Mes){
												if(parseInt(antiguedadMes) > 0){
													antiguedadMes --;
												}else{
													antiguedadMes = 11;
													antiguedadAnio --;
												}
										//	}
											
										}
										

										$('#mesesAnti').val(antiguedadMes);
										$('#aniosAnti').val(antiguedadAnio);
										
									}else{
										$('#aniosAnti').val('0');
										$('#mesesAnti').val('0');
									}
								}
								
								$('#forma3ClienteID').val( $('#clienteID').val() );
								$('#forma3ProspectoID').val($('#prospectoID').val())
								consultaOcupacion('ocupacionID');
								consultaPais('paisNacimiento','nombPaisNacim');
								consultaIdentificacion(jqCliente);
								consultaEstado('estadoID','nomEstado');
								habilitaBoton('grabarCony', 'submit');
						}
						else{
							$('#pNombre').val('');  
							$('#sNombre').val('');
							$('#tNombre').val('');
							$('#aPaterno').val('');
							$('#aMaterno').val('');
							$('#nacionaID').val('');
							$('#paisNacimiento').val('');
							$('#nombPaisNacim').val('');
							$('#estadoID').val('');
							$('#nomEstado').val('');
							$('#fecNacimiento').val('');
							$('#rfcConyugue').val('' );
							$('#telCelular').val('');
							$('#ocupacionID').val('');
							ocupacionID = '';
							$('#nombreOcupacion').val('');
							$('#grupoEmpresaID').val('');
							$('#telEmpresa').val('');
							$('#empresaLabora').val('');
							$('#aniosAnti').val('');
							$('#mesesAnti').val('');
							$('#extencionTrabajo').val('');
							$('#folioIdentificacion').val('');
							$('#fechaExpedicion').val('');
							$('#fechaVencimiento').val('');
							habilitaControl('folioIdentificacion');
							habilitaControl('tipoIdentiID');
								mensajeSis("El Cliente es Menor de Edad.");
								tab2 = false;
								$('#buscClienteID').val('');
								$('#buscClienteID').focus();
								limpiaInputsForm('formaGenerica3');
						} 
				}else{
					$('#pNombre').val('');  
					$('#sNombre').val('');
					$('#tNombre').val('');
					$('#aPaterno').val('');
					$('#aMaterno').val('');
					$('#nacionaID').val('');
					$('#paisNacimiento').val('');
					$('#nombPaisNacim').val('');
					$('#estadoID').val('');
					$('#nomEstado').val('');
					$('#fecNacimiento').val('');
					$('#rfcConyugue').val('' );
					$('#telCelular').val('');
					$('#ocupacionID').val('');
					ocupacionID = '';
					$('#nombreOcupacion').val('');
					$('#grupoEmpresaID').val('');
					$('#telEmpresa').val('');
					$('#empresaLabora').val('');
					$('#aniosAnti').val('');
					$('#mesesAnti').val('');
					$('#extencionTrabajo').val('');
					$('#folioIdentificacion').val('');
					$('#fechaExpedicion').val('');
					$('#fechaVencimiento').val('');
					habilitaControl('folioIdentificacion');
					habilitaControl('tipoIdentiID');
					var cte = $('#buscClienteID').val();
					if(cte != '0'){
						mensajeSis("Cliente No Valido");
						tab2 = false;
						$('#buscClienteID').val('');
						limpiaInputsForm('formaGenerica3');
					}
				}    	 						
			});
		} 
		else{
			habilitaControl('folioIdentificacion');
			habilitaControl('tipoIdentiID');
			limpiaInputsForm('formaGenerica3');
			$('#buscClienteID').val('');
		}
	}

	function consultaClienteDirec(idControl) {		
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipoDireccionID= 3;	
		setTimeout("$('#cajaLista').hide();", 200);		
		var direccionesCliente ={
	 			'clienteID' : numCliente,
	 			'tipoDireccionID' : tipoDireccionID
		};
		if(numCliente != '' && !isNaN(numCliente) ){
			direccionesClienteServicio.consulta(catTipoConsultaDirCliente.dirTrabajo,direccionesCliente,function(direccion) {
				if(direccion != null){ 
					esTab=true;
					$('#entFedID').val(direccion.estadoID);
					consultaEstado('entFedID', 'entidadFedNombre');
					$('#municipioID').val(direccion.municipioID);
					consultaMunicipio('municipioID');
					$('#localidadID').val(direccion.localidadID);
					consultaLocalidad('localidadID');
					$('#coloniaID').val(direccion.coloniaID);
					consultaColonia('coloniaID');
					$('#calle').val(direccion.calle);
					$('#numero').val(direccion.numeroCasa);
					$('#interior').val(direccion.numInterior);
					$('#piso').val(direccion.piso);
				}else{
					$('#entFedID').val('');
					$('#entidadFedNombre').val('');
					$('#municipioID').val('');
					$('#nombMunicipio').val('');
					$('#localidadID').val('');
					$('#nombrelocalidad').val('');
					$('#coloniaID').val('');
					$('#nombreColonia').val('');
					$('#calle').val('');
					$('#numero').val('');
					$('#interior').val('');
					$('#piso').val('');
				}    	 						
			});
		} 
	}
	
	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#entFedID').val();				
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);
				
		if(numLocalidad != '' && !isNaN(numLocalidad)){
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
	
	function limpiaInputsForm(idControl){
		var forma =  eval("'#" + idControl + "'");

		$(forma).find(':input').each( function(){	    		
			var control =  eval("'#" + this.id + "'");
			if(this.type != 'button' && this.type != 'submit'){
				$(control).val("");
			}
		});
	}






	function consultaPais(idControl,etiqNombre) {
		var jqPais = eval("'#" + idControl + "'");
		var jqNombrePais = eval("'#" + etiqNombre + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais) && esTab) {
			paisesServicio.consultaPaises(conPais, numPais,
					function(pais) {
				if (pais != null) {
					$(jqNombrePais).val(pais.nombre);
					validaNacionalidadCte();
				} else {
					mensajeSis("No Existe el Pais");
					$(jqPais).val('');
					$(jqNombrePais).val('');
				}
			});
		}
	}

	function consultaEstado(idControl,nomEstado) {
		var jqEstado = eval("'#" + idControl + "'");
		var jqNombEstado = eval("'#" + nomEstado + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEstado != '' && !isNaN(numEstado) ) {
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
				if (estado != null) {
					$(jqNombEstado).val(estado.nombre);
				} else {
					mensajeSis("No Existe el Estado");
					$(jqNombEstado).val('');
					$(jqEstado).val('');
					$(jqEstado).focus();
				}
			});
		}
	}

	function consultaOcupacion(idControl) {
		var jqOcupacion = eval("'#" + idControl + "'");
		var numOcupacion = $(jqOcupacion).val();
		var tipConForanea = 2;	
		
		setTimeout("$('#cajaLista').hide();", 200);		
		if (numOcupacion != 0 && numOcupacion != '' && !isNaN(numOcupacion) ) {
			
			ocupacionesServicio.consultaOcupacion(tipConForanea, numOcupacion, function(ocupacion) {
				if (ocupacion != null) {
					$('#nombreOcupacion').val(ocupacion.descripcion);
					 ocupacionID = ocupacion.ocupacionID;
					}
					else {
					$('#nombreOcupacion').val('');
					if(numOcupacion != 0){
						mensajeSis("No Existe la Ocupacion");
						$('#ocupacionID').focus();
						$('#nombreOcupacion').val('');
						 ocupacionID = '';
					}
				}
			});
		}
		else{
			$('#nombreOcupacion').val('');
		}
	}
	
	
	function consultaOcupacionFechaTrabajo(idControl) {
		var jqOcupacion = eval("'#" + idControl + "'");
		var numOcupacion = $(jqOcupacion).val();
		var tipConForanea = 2;	
		var jqFechaIniTrabajo = eval("'#fechaIniTrabajo'");
		var jqAnioAntiguedad = eval("'#aniosAnti'");
		var jqMesAntiguedad = eval("'#mesesAnti'");
		
		setTimeout("$('#cajaLista').hide();", 200);		
		if (numOcupacion != 0 && numOcupacion != '' && !isNaN(numOcupacion) ) {
			
			ocupacionesServicio.consultaOcupacion(tipConForanea, numOcupacion, function(ocupacion) {
				if (ocupacion != null) {
					 implicaTrabajo = ocupacion.implicaTrabajo;
					$('#nombreOcupacion').val(ocupacion.descripcion);
					if (ocupacion.implicaTrabajo == 'S' ){
						if($('#ocupacionID').val() != '' && 	$('#ocupacionID').val() != ocupacionID){
							$('#fechaIniTrabajo').val(parametroBean.fechaSucursal);		
							$(jqAnioAntiguedad).val(0);
							$(jqMesAntiguedad).val(0);					
						}
						
					} 
					else{
						$(jqFechaIniTrabajo).val('');
						$(jqAnioAntiguedad).val(0);
						$(jqMesAntiguedad).val(0);
					}
					ocupacionID = ocupacion.ocupacionID;
					}
					else {
						$('#nombreOcupacion').val('');
						ocupacionID = '';
						implicaTrabajo = 'N';
						if(numOcupacion != 0){
							mensajeSis("No Existe la Ocupacion");
							$('#ocupacionID').focus();
							$('#nombreOcupacion').val('');
						}
				}
			});
		}
		else{
			$('#nombreOcupacion').val('');
			implicaTrabajo = 'N';
		}
	}
	
	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#entFedID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numMunicipio == '' || numMunicipio==0 || numEstado == '' || numEstado==0){

		}
		else	
			if(numMunicipio != '' && !isNaN(numMunicipio)){
				municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
					if(municipio!=null){							
						$('#nombMunicipio').val(municipio.nombre);

					}else{
						mensajeSis("No Existe el Municipio");
						$('#municipioID').focus();
						$(jqMunicipio).val('');
						$('#nombMunicipio').val('');
						
					}    	 						
				});
			}
	}	

	function validaNacionalidadCte(){
		var nacionalidad =  $("#nacionaID option:selected").val();
		var jQpaisNacimiento = eval("'#paisNacimiento'");
		var pais= $(jQpaisNacimiento).val();
		var mexico='700';
		var nacdadMex='N';
		var nacdadExtr='E';

		if(nacionalidad==nacdadMex){
			if(pais!=mexico){
				mensajeSis("Por la Nacionalidad de la Persona el País Debe ser México.");
				$(jQpaisNacimiento).val('');
				$('#nombPaisNacim').val('');
				$('#paisNacimiento').focus();
			}
		}
		else if(nacionalidad==nacdadExtr){

			if(pais==mexico){
				mensajeSis("Por la Nacionalidad de la Persona el País NO Debe ser México.");
				$(jQpaisNacimiento).val('');
				$('#nombPaisNacim').val('');
				$('#paisNacimiento').focus();
			}
		}

	}


	function formaRFC() {
		var pn = $('#pNombre').val();
		var sn = $('#sNombre').val();
		var tn = $('#tNombre').val();
		var nc = pn + ' ' + sn + ' ' + tn;

		var rfcBean = {
				'primerNombre' : nc,
				'apellidoPaterno' : $('#aPaterno').val(),
				'apellidoMaterno' : $('#aMaterno').val(),
				'fechaNacimiento' : $('#fecNacimiento').val()
		};
		clienteServicio.formaRFC(rfcBean, function(cliente) {
			if (cliente != null) {

				$('#rfcConyugue').val(cliente.RFC);
				$('#tipoIdentiID').focus();
			}
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
					mensajeSis("El cliente: "
							+ rfc.numero
							+ "\ncon RFC : "
							+ rfc.RFCOficial
							+ ", \nya esta registrado en el sistema, \nfavor de utilizar este folio");
					$(jqRFC).focus();
				}
			});
		}
	}


	function consultaNombresParametros(){
		consultaPais('paisNacimiento','nombPaisNacim');
		consultaEstado('estadoID','nomEstado');

		if ($('#entFedID').val()!='') {
			consultaEstado('entFedID','entidadFedNombre');
		}

		if(	$('#ocupacionID').val()!=''){
			consultaOcupacion('ocupacionID');
		}

		if( $('#municipioID').val()!=''){
			consultaMunicipio('municipioID');
		}

	}
	function consultaTipoIdent() {
		var tipConP = 1;	
		var numTipoIden = $('#tipoIdentiID option:selected').val();
		
		setTimeout("$('#cajaLista').hide();", 200);		

			tiposIdentiServicio.consulta(tipConP,numTipoIden,function(identificacion) {
				if(identificacion!=null){							
					$('#tipoIdentiID').val(identificacion.tipoIdentiID);
					$('#numeroCaracteres').val(identificacion.numeroCaracteres);
				} 
				else{
					$('#folioIdentificacion').val('');
					mensajeSis('No Existe el Tipo de Indentificación.');
				}
			});
	}
	
	function consultaIdentificacion(idControl) {
		var numCliente = $(idControl).val(); 
		var conIde = 3;

		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)  ){
			var identifiCliente = {
					'clienteID' :  numCliente
			};
			identifiClienteServicio.consulta(conIde,identifiCliente,function(identificacion) {
					if(identificacion!=null){	
						$('#tipoIdentiID').val(identificacion.tipoIdentiID).selected = true;
						consultaTipoIdent();
						$('#folioIdentificacion').val(identificacion.numIdentific);
						$('#fechaExpedicion').val(identificacion.fecExIden);
						$('#fechaVencimiento').val(identificacion.fecVenIden);
						if($('#fechaExpedicion').val()=='1900-01-01' ){							
							$('#fechaExpedicion').val('');												
						}
						if($('#fechaVencimiento').val()=='1900-01-01'){
							$('#fechaVencimiento').val('');
						}
						deshabilitaControl('tipoIdentiID');
						deshabilitaControl('folioIdentificacion');
						$('#tipoIdentiID').attr('readOnly',false);
						$('#folioIdentificacion').attr('readOnly',false);
						habilitaBoton('grabarCony', 'submit');
					}else{
						$('#folioIdentificacion').val('');
						$('#folioIdentificacion').attr('readOnly',true);
						$('#tipoIdentiID').attr('readOnly',true);
						$('#tipoIdentiID').val('').selected = true;
						deshabilitaBoton('grabarCony', 'submit');
						mensajeSis("No Existe Identificacion Oficial del Cliente");
						$(idControl).focus();
					}
				});

		}
	}	


	function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
		if(fecha == fecha2){
			return false;
		}
		else{

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
	}
//	FIN VALIDACIONES DE REPORTES

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd)");
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
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
				break;
			default:
				mensajeSis("Fecha Introducida Errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha Introducida Errónea.");
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
	/***********************************/

	//});  fin de document ready
 
 
 
var nav4 = window.Event ? true : false;
function IsNumber(evt){
	var key = nav4 ? evt.which : evt.keyCode;
	return (key <= 13 || (key >= 48 && key <= 57) );
}


function listaPais(evento) { 
	lista('paisNacimiento', '1', '1', 'nombre', evento.value,'listaPaises.htm');
}


function listaEstados(evento) {
	lista('estadoID', '2', '1', 'nombre',evento.value,'listaEstados.htm');
}

function validaExtencionTrabajo(valor){
	if(valor != ''){
		if($("#telEmpresa").val() == ''){
			this.value = '';
			mensajeSis("El Número de Teléfono está Vacío.");
			$("#telEmpresa").focus();
		}
	}				
}
function validaTelefonoEmpresa(valor){
	if(valor ==''){
		$("label.error").hide(); 
		$(".error").removeClass("error");
		$('#extencionTrabajo').val('');
	}
		else{
			if(valor.length >= 7 && valor.length <= 15){
				$("label.error").hide(); 
				$(".error").removeClass("error");
			}		
		}
}


//recalcula la antiguedad laboral del cliente
function calculaAntiguedadTrabajo(evento){	
	var antiguedadTra = "";
	var antiguedadAnio = "";
	var antiguedadMes = "";	
	var fechaActualSistema = parametroBean.fechaSucursal;
	var jqAntiguedadAnio =  eval("'#aniosAnti'");
	var jqAntiguedadMes =  eval("'#mesesAnti'");
		
	if(evento.value != ""){
		if(esFechaValida(evento.value)){
			if ( mayor(evento.value, fechaActualSistema) ){
				mensajeSis("La Fecha Indicada es Mayor a la Fecha Actual del Sistema.")	;
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
		if(implicaTrabajo == 'S'){
			evento.value = fechaActualSistema;
		}else{
			evento.value = '';
		}
		
		$(jqAntiguedadAnio).val('0');
		$(jqAntiguedadMes).val('0');
	}
	
	
}



//Función para calcular los días transcurridos entre dos fechas
function restaFechas(fAhora,fEvento) {	
	var ahora = new Date(fAhora);
  var evento = new Date(fEvento);
  var tiempo = evento.getTime() - ahora.getTime();
  var dias = Math.floor(tiempo / (1000 * 60 * 60 * 24));
  
	return dias;
}	



// inicializa el formulario de datos del conyugue
	function inicializaFormaConyugue (){
		$('#ocupacionID').val('');
		$('#nombreOcupacion').val('');
		$('#pNombre	').val('');
		$('#empresaLabora').val('');
		$('#sNombre').val('');
		$('#entFedID').val('');
		
		
		$('#entidadFedNombre').val('');
		$('#tNombre').val('');		
		$('#municipioID').val('');
		$('#nombMunicipio').val('');
		$('#aPaterno').val('');
		$('#aMaterno').val('');
		$('#coloniaID').val('');
		$('#localidadID').val('');
		$('#nombrelocalidad').val('');
		$('#nombreColonia').val('');
		
		
		$('#calle').val('');
		$('#numero').val('');
		$('#interior').val('');
		$('#piso').val('');
		$('#nacionaID').val('');
		$('#paisNacimiento').val('');
		
		
		$('#nombPaisNacim').val('');
		$('#fechaIniTrabajo').val('');
		$('#estadoID').val('');
		$('#nomEstado').val('');
		$('#aniosAnti').val('');
		$('#aniosAnti').val('');
		$('#mesesAnti').val('');
		$('#fecNacimiento').val('');
		$('#telEmpresa').val('');
		$('#extencionTrabajo').val('');
		$('#rfcConyugue').val('');
		$('#codPostal').val('');
		$('#tipoIdentiID').val('');
		$('#folioIdentificacion').val('');
		$('#fechaExpedicion').val('');
		$('#fechaVencimiento').val('');
		$('#telCelular').val('');
		
		habilitaControl('tipoIdentiID');
		habilitaControl('folioIdentificacion');	
		
	}