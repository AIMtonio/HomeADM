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
	
	$("#prospectoID").focus();
	
	esTab = true;

	//Definicion de Constantes y Enums  
	var catTipoTransaccionProspec = {
  		'agrega':'1',
  		'modifica':'2', 
	}; 
	
	var catTipoConsultaProspec = {
  		'principal':1,
  		'foranea':2
	};	
	var parametroBean = consultaParametrosSession();

	 //------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('modifica', 'submit'); 
	deshabilitaBoton('agrega', 'submit');
	agregaFormatoControles('formaGenerica');
	// se llama la funcion que llena el combo de tipo de direccion
	llenarComboTipoDireccion();
	 document.getElementById("tipoPersona").checked = true;
	 $('#personaMoral').hide();


	//Validacion para mostrarar boton de calcular RFC
	permiteCalcularCURPyRFC('','generar',2);
	 
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
      submitHandler: function(event) { 
    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','prospectoID', 'exitoTransProspecto','');
      	
      }
	});		
	     
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionProspec.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionProspec.modifica);			
	});	

	$('#prospectoID').bind('keyup',function(e){
		lista('prospectoID', '1', '1', 'prospectoID', $('#prospectoID').val(), 'listaProspecto.htm');
	});
	
	$('#prospectoID').blur(function() {
			validaProspecto(this.id);
	});

	$('#nacion').change(function() {
		validaNacionalidad();
	});

	$('#lugarNacimiento').bind('keyup',function(e) { 
		lista('lugarNacimiento', '1', '1', 'nombre', $('#lugarNacimiento').val(),'listaPaises.htm');
	});

	$('#lugarNacimiento').blur(function() {
		consultaPaisNac(this.id);
	});
	
	$('#paisResidenciaID').bind('keyup',function(e) { 
		lista('paisResidenciaID', '1', '1', 'nombre', $('#paisResidenciaID').val(),'listaPaises.htm');
	});

	$('#paisResidenciaID').blur(function() {
		consultaPaisResidencia(this.id);
	});
	
	$('#estadoID').bind('keyup',function(e){
		lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
	});
	
	$('#estadoID').blur(function() {
  		consultaEstado(this.id);
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
	
	$('#localidadID').blur(function() {
		consultaLocalidad(this.id);
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
	
	$('#coloniaID').blur(function() {
		consultaColonia(this.id);
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
	
	$('#tipoPersona').click(function() {
		$('#tipoPersona').focus();
		$('#personaFisica').show(300);
		$('#personaMoral').hide(300);
		$('#razonSocial').val('');
		$('#RFCpm').val('');
	});
	
	$('#tipoPersona2').click(function() {
		$('#tipoPersona2').focus();
		$('#personaFisica').hide(300);
		$('#ocupacionID').val('0');
		$('#antiguedadTra').val('0');
		$('#personaMoral').show(300);
		
		$('#ocupacionC').val('');
		$('#lugarTrabajo').val('');
		$('#telTrabajo').val('');
		$("#extTelefonoTrab").val('');
		$('#puesto').val('');


	});
	
	$('#tipoPersona3').click(function() {
		$('#tipoPersona3').focus();
		$('#personaFisica').show();
		$('#personaMoral').hide(300);
		$('#razonSocial').val('');
		$('#RFCpm').val('');
	});

	$('#RFC').focus(function(e){
		maxCaracteres=13;
		if($('#tipoPersona').is(':checked') || $('#tipoPersona3').is(':checked')){
			minCaracteres=13;
		}else if($('#tipoPersona2').is(':checked')){
			minCaracteres=12;
		}
	});
	
 	$('#RFC').blur(function() {
		if($('#tipoPersona').is(':checked')){  
			validaRFC('RFC');
			validaRFCv1($('#RFC').val());
		}else{
			if($('#tipoPersona3').is(':checked')){  
				validaRFC('RFC');
			}
		}
	});
	
	$('#RFCpm').blur(function() {
		if($('#tipoPersona2').is(':checked')){  
			validaRFC('RFCpm');
		}
	});
	
	$('#ocupacionID').blur(function() {
		if($('#ocupacionID').val() == '')
			$('#ocupacionID').val('0');
	});
	
	$('#antiguedadTra').blur(function() {
		if($('#antiguedadTra').val() == '')
			$('#antiguedadTra').val('0');
	});
	$('#fechaNacimiento').change(function() {
		var Xfecha= $('#fechaNacimiento').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaNacimiento').val(parametroBean.fechaSucursal);
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La fecha capturada es mayor a la de hoy")	;
				$('#fechaNacimiento').val(parametroBean.fechaSucursal);
				$('#fechaNacimiento').focus();
			}else{
				$('#fechaNacimiento').focus();
				$('#lugarNacimiento').focus();	
			}
			$('#fechaNacimiento').focus();
		}else{
			$('#fechaNacimiento').val(parametroBean.fechaSucursal);
			$('#fechaNacimiento').focus();
		}
	});
	$('#ocupacionID').bind('keyup',function(e) { 
		lista('ocupacionID', '1', '1', 'descripcion',$('#ocupacionID').val(),'listaOcupaciones.htm');
	});
	$('#ocupacionID').blur(function() {
		if( $('#tipoPersona').attr('checked')==true || $('#tipoPersona3').attr('checked')==true){	
		consultaOcupacion(this.id);
		}
	});
	$('#clasificacion').change(function() {
	if($('#clasificacion').val() == 'M'){
			$('#datosNomina').show(300);
		}else{
			$('#datosNomina').hide(300);
			$('#noEmpleado').val('');
			$('#tipoEmpleado').val('');
		}
	});
	$('#generar').click(function() {
		if ($('#fechaNacimiento').val()!=''){
			formaRFC();
		}else{
			mensajeSis('Se necesita la Fecha de Nacimiento para esta Opcion');
		}
	});
	
	$('#telefono').setMask('phone-us');
	$('#telTrabajo').setMask('phone-us');
	
	$('#telefono').blur(function(){
		if($('#telefonsaleso').val()==''){
			$('#extTelefonoPart').val('');						
		}
	});
	$('#telefono').blur(function() {
		if(this.value == ''){
			$("#extTelefonoPart").val('');
		}
	});
	
	$('#telTrabajo').blur(function(){
		if($('#telTrabajo').val()== ''){
			$('#extTelefonoTrab').val('');
		}
	});
	
	$("#extTelefonoPart").blur(function(){
		if(this.value != ''){
			if($("#telefono").val() == ''){
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío.");
				$("#telefono").focus();
			}
		}				
	});
	$("#extTelefonoTrab").blur(function(){
		if(this.value != ''){
			if($("#telTrabajo").val() == ''){
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío.");
				$("#telTrabajo").focus();
			}
		}				
	});
	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		ignore: ":hidden",
		rules: {
			primerNombre: { 
				required: true
			},			
			tipoPersona: { 
				required: true
			},	 
			razonSocial : {
				required : function() {return $('#tipoPersona2:checked').val() == 'M' ;}
			},
			RFC	: {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return $('#tipoPersona').is(':checked') || $('#tipoPersona3').is(':checked')},
				minlength	: function() { if($('#tipoPersona').is(':checked') && $('#tipoPersona3').is(':checked')){
					minCaracteres=13;
				return 13;
			}  else{
				minCaracteres=13;
				return 13} },
			maxlength	: 13,
			}	,
			calle: { 
				required: true
			},
			numExterior: { 
				required: true
			},
			municipioID: { 
				required: true
			},
			estadoID: { 
				required: true
			},
			CP: { 
				required: true
			},
			coloniaID: { 
				required: true
			},
			localidadID: { 
				required: true
			},
			extTelefonoTrab:{
				number: true
			},
			extTelefonoPart: {
				number:true
			},
			
			sexo:{
				required: true
			},
			estadoCivil: {
				required: true
			},
			tipoDireccionID: {
				required: true
			},
			clasificacion: {
				required: true
			},
			lugarNacimiento : {required : function() {return $('#tipoPersona').is(':checked');}	
			},
			nacion : {required : true
			},
			paisResidenciaID: { required : function() {return $('#tipoPersona').is(':checked');} },
			RFCpm	: {
				required : function() {return $('#tipoPersona2').is(':checked');},
				minlength : function() { if($('#tipoPersona2').is(':checked')) return 12; else return 0}
			}	
		},
		messages: {
			primerNombre: {
				required: 'Especificar Nombre'
			},
			apellidoPaterno: {
				required: 'Especificar Apellido'
			},
			tipoPersona: {
				required: 'Especificar Tipo de Persona'
			},
			razonSocial : {
				required : 'Especificar Razon Social'
			},
			RFC	: {
				required	: 'Especifique RFC',
				maxlength	: 'Máximo 13 caracteres'
			}	,
			calle: {
				required: 'Especificar Calle'
			},
			numExterior: { 
				required: 'Especificar Numero'
			},
			municipioID: { 
				required: 'Especificar Municipio'
			},
			estadoID: { 
				required: 'Especificar Estado'
			},
			CP: { 
				required: 'Especificar Codigo Postal'
			},
			coloniaID: { 
				required: 'Especificar Colonia'
			},
			localidadID: { 
				required: 'Especificar Localidad'
			},
			extTelefonoTrab:{
				number: 'Sólo Números(Campo opcional)'
			},
			extTelefonoPart: {
				number:'Sólo Números(Campo opcional)'
			},	
		
			sexo:{
				required: 'Especificar Género'
			},
			estadoCivil: {
				required: 'Especificar Estado Civil '
			},
			tipoDireccionID: {
				required: 'Especificar Tipo de Dirección'
			},
			clasificacion: {
				required: 'Especificar Clasificación'
			},
			lugarNacimiento : {
				required : 'Especifique Lugar de Nacimiento.'
			},
			nacion : {
				required : 'Especifique Nacionalidad.'
			},
			paisResidenciaID: {
				required : 'Especifique país de residencia'
			},
			RFCpm	: {
				minlength	: "Mínimo 12 Caracteres",
				maxlength	: "Máximo 12 Caracteres"
			}	
		}
		
	});
	
	//------------ Validaciones de Controles -------------------------------------
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
				$('#RFC').focus();
			}
		});
	}
	
	function validaProspecto(idControl) {
		var jqProspecto = eval("'#" + idControl + "'");
		var numProspecto = $(jqProspecto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProspecto != '' && !isNaN(numProspecto) && esTab){
			if(numProspecto == '0'){	
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				limpiaFormulario();
				$('#tipoPersona').attr("checked","1");
				$('#tipoPersona2').attr("checked",false);
				$('#tipoPersona3').attr("checked",false);
			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var prospectoBeanCon ={
			 		 	'prospectoID' : numProspecto 
				};		
				prospectosServicio.consulta(catTipoConsultaProspec.principal,prospectoBeanCon,function(prospectos) {
					if(prospectos!=null){
						listaPersBloqBean =consultaListaPersBloq(prospectos.prospectoID,'PRO',0,0);
						consultaSPL = consultaPermiteOperaSPL(prospectos.prospectoID,'LPB','PRO');
						if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
							dwr.util.setValues(prospectos);
							if(prospectos.clasificacion=='M')
							$('#datosNomina').show();
							else
							$('#datosNomina').hide();
						
						
							esTab= true;
							consultaPaisNac('lugarNacimiento');
							consultaEstado('estadoID'); 
							consultaMunicipio('municipioID');
							consultaLocalidad('localidadID');	
							consultaColonias('coloniaID');
							if(prospectos.ocupacionID > 0)
							consultaOcupacion('ocupacionID');	
							if (prospectos.tipoPersona == 'F') {
								$('#tipoPersona').attr("checked","1");
								$('#tipoPersona2').attr("checked",false);
								$('#tipoPersona3').attr("checked",false);
								$('#personaFisica').show(300);
								$('#personaMoral').hide(300);
							} else {
								if (prospectos.tipoPersona == 'A') {
									$('#tipoPersona3').attr("checked","1");
									$('#tipoPersona2').attr("checked",false);
									$('#tipoPersona').attr("checked",false);
									$('#personaFisica').show(300);
									$('#personaMoral').hide(300);
									$('#razonSocial').val('');
									$('#RFCpm').val('');
								} 
								if (prospectos.tipoPersona == 'M'){
									$('#tipoPersona2').attr("checked","1");
									$('#tipoPersona').attr("checked",false);
									$('#tipoPersona3').attr("checked",false);
									$('#personaFisica').hide(300);
									$('#personaMoral').show(300);
								}
							}		
							$('#tipoDireccionID').val(prospectos.tipoDireccionID).selected = true;
							$('#telefono').setMask('phone-us');
							$('#telTrabajo').setMask('phone-us');
							if(prospectos.cliente!="0"){
								deshabilitaBoton('agrega', 'submit');
								deshabilitaBoton('modifica', 'submit');
								mensajeSis("El prospecto no puede ser modificado porque ya es cliente.");
							}
						}else{
							mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operacion.');
							$('#prospectoID').focus();
							$('#prospectoID').val('');
							
						}
					}else{ 
						mensajeSis("No Existe el Prospecto");
						deshabilitaBoton('modifica', 'submit');
   						deshabilitaBoton('agrega', 'submit');
   						$('#prospectoID').focus();
   						$('#prospectoID').select();	
					}
				});
			}
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
					$('#estadoID').focus();
					$('#estadoID').select();
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
		if(numMunicipio != '' && !isNaN(numMunicipio) && esTab){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
				if(municipio!=null){							
					$('#nombreMuni').val(municipio.nombre);
					$('#ciudad').val(municipio.ciudad);
				}else{
					mensajeSis("No Existe el Municipio");
					$('#municipioID').focus();
					$('#municipioID').select();
				}    	 						
			});
		}
	}	
		  
	function validaRFC(idControl) {
		var jqRFC = eval("'#" + idControl + "'");
		var numRFC = $(jqRFC).val();
		var tipCon = 4;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numRFC != '') {
			clienteServicio.consultaRFC(tipCon,	numRFC,function(rfc) {
				if (rfc != null) {
					mensajeSis('El RFC <i>' + rfc.RFCOficial + '</i> ya se Encuentra Registrado en el Sistema para el '
						+ $('#alertCliente').val().trim()+' <i>' + rfc.numero
						+ '</i>.<br>Favor de revisar el Registro para Evitar Duplicidad.');
					$(jqRFC).focus();
				}
			});
		}
	}
	
	// comparaciones fechas 
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
  	
	/*funcion valida fecha formato (yyyy-MM-dd)*/
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				mensajeSis("Fecha introducida errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea.");
				return false;
			}
			return true;
		}
	}


	function comprobarSiBisisesto(anio){		
		if (anio % 4 == 0 && anio % 100 != 0 || anio % 400 == 0) {
			return true;
		}
		else {
			return false;
		}
	}
	
	// funcion para llenar combo de tipo de direccion
	function llenarComboTipoDireccion(){
		dwr.util.removeAllOptions('tipoDireccionID'); 
		tiposDireccionServicio.listaCombo(3, function(tdirecciones){
			dwr.util.addOptions('tipoDireccionID', {'':'SELECCIONAR'});
			dwr.util.addOptions('tipoDireccionID', tdirecciones, 'tipoDireccionID', 'descripcion');
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


});	// fin document ready

//funcion para consultar colonia y cp
function consultaColonia(idControl) {
	var jqColonia = eval("'#" + idControl + "'");
	var numColonia= $(jqColonia).val();		
	var numEstado =  $('#estadoID').val();	
	var numMunicipio =	$('#municipioID').val();
	var tipConPrincipal = 1;	
	
	if(numEstado==''){	return;}
	if(numMunicipio==''){ return;}
	
	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numColonia != '' && !isNaN(numColonia) && esTab){
		coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
			if(colonia!=null){							
				$('#colonia').val(colonia.asentamiento);
				$('#CP').val(colonia.codigoPostal);
			}else{
				mensajeSis("No Existe la Colonia");
				$('#colonia').val("no existe");
				$('#coloniaID').val("");
				$('#coloniaID').focus();
				$('#coloniaID').select();
			}    	 						
		});
	}else{
		$('#colonia').val("");
	}
}

//funcion para consultar colonia
function consultaColonias(idControl) {
	var jqColonia = eval("'#" + idControl + "'");
	var numColonia= $(jqColonia).val();		
	var numEstado =  $('#estadoID').val();	
	var numMunicipio =	$('#municipioID').val();
	var tipConPrincipal = 1;	
	
	if(numEstado==''){	return;}
	if(numMunicipio==''){ return;}	
	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numColonia != '' && !isNaN(numColonia) && esTab){
		coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
			if(colonia!=null){							
				$('#colonia').val(colonia.asentamiento);
			}else{
				mensajeSis("No Existe la Colonia");
				$('#colonia').val("no existe");
				$('#coloniaID').val("");
				$('#coloniaID').focus();
				$('#coloniaID').select();
			}    	 						
		});
	}
}
function consultaLocalidad(idControl) {
	var jqLocalidad = eval("'#" + idControl + "'");
	var numLocalidad = $(jqLocalidad).val();
	var numMunicipio =	$('#municipioID').val();
	var numEstado =  $('#estadoID').val();				
	var tipConPrincipal = 1;	
	
	if(numEstado==''){		 return;}
	if(numMunicipio==''){	return;}
	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numLocalidad != '' && !isNaN(numLocalidad) && esTab){
		localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
			if(localidad!=null){							
				$('#nombreLocalidad').val(localidad.nombreLocalidad);
			}else{
				mensajeSis("No Existe la Localidad");
				$('#nombreLocalidad').val("");
				$('#localidadID').val("");
				$('#localidadID').focus();
				$('#localidadID').select();
			}    	 						
		});
	}
}

function consultaOcupacion(idControl) {
		var jqOcupacion = eval("'#" + idControl + "'");
		var numOcupacion = $(jqOcupacion).val();
		var tipConForanea = 2;		
		setTimeout("$('#cajaLista').hide();", 200);		
		if (numOcupacion != 0 && numOcupacion != '' && !isNaN(numOcupacion) && esTab ) {
			ocupacionesServicio.consultaOcupacion(tipConForanea, numOcupacion, function(ocupacion) {
						if (ocupacion != null) {
							$('#ocupacionC').val(ocupacion.descripcion);
								if (ocupacion.implicaTrabajo == 'S'){
								$("#puesto").rules("add", {
	 									required:function() {return $('#tipoPersona').is(':checked') ||  $('#tipoPersona3').is(':checked');},
	 								messages: {
	 									required: "Especifique el Puesto"
									}
								});
								$("#lugarTrabajo").rules("add", {
										required: function() {return $('#tipoPersona').is(':checked') ||  $('#tipoPersona3').is(':checked');},
									messages: {
										required: "Especifique el Lugar de Trabajo"
									}
								});
								$("#antiguedadTra").rules("add", {
	 									required: function() {return $('#tipoPersona').is(':checked') ||  $('#tipoPersona3').is(':checked');},
	 								messages: {
	 									required: "Especifique la Antiguedad de Trabajo"
									}
								});								
							}else{
								$("#puesto").rules("remove");
								$("#lugarTrabajo").rules("remove");
								$("#antiguedadTra").rules("remove");
								$("#telTrabajo").rules("remove");						
						  }
								
						} else {
							if(numOcupacion != 0){
								mensajeSis("No Existe la Ocupacion");
								$('#ocupacionC').val('');
								$('#ocupacionID').focus();
							}
						}
					});
		}else{
			$('#ocupacionID').val('0');
			$('#ocupacionC').val('');
		}
}
function limpiaFormulario(){
	$('#primerNombre').val('');
	$('#segundoNombre').val('');
	$('#tercerNombre').val('');
	$('#apellidoPaterno').val('');
	$('#apellidoMaterno').val('');
	$('#fechaNacimiento').val('');
	$('#paisResidenciaID').val('');
	$('#paisResidencia').val('');
	$('#ciudad').val('');
	$('#RFC').val('');
	$('#telefono').val('');
	$('#razonSocial').val('');
	$('#estadoID').val('');
	$('#municipioID').val('');
	$('#localidadID').val('');
	$('#coloniaID').val('');
	$('#calle').val('');
	$('#numExterior').val('');
	$('#numInterior').val('');
	$('#CP').val('');
	$('#manzana').val('');
	$('#lote').val('');
	$('#latitud').val('');
	$('#longitud').val('');
	$('#ocupacionID').val('');
	$('#puesto').val('');
	$('#ocupacionC').val('');
	$('#lugarTrabajo').val('');
	$('#antiguedadTra').val('');
	$('#telTrabajo').val('');
	$('#nombreEstado').val('');
	$('#nombreMuni').val('');
	$('#noEmpleado').val('');
	$('#nombreLocalidad').val('');
	$('#colonia').val('');
	$('#clasificacion').val('');
	$('#sexo').val('');
	$('#estadoCivil').val('');
	$('#tipoDireccionID').val('');
	$('#extTelefonoPart').val('');
	$('#telTrabajo').val('');
	$('#tipoEmpleado').val('');
	$('#extTelefonoTrab').val('');
	$('#personaMoral').hide();
	$('#personaMoral').hide();
	$('#datosNomina').hide();
	 document.getElementById("tipoPersona3").checked = false;
	 document.getElementById("tipoPersona2").checked = false;
	 document.getElementById("tipoPersona").checked = true;
	$('#nacion').val('');
	$('#lugarNacimiento').val('');
	$('#paisNac').val('');
	$('#paisResidenciaID').val('');
	$('#paisResidencia').val('');
	$('#ciudad').val('');
}

function exitoTransProspecto(){
	limpiaFormulario();
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	
}
/**
 * Consulta el país de nacimiento de un aval.
 * @param idControl : ID del input que genera el evento.
 * @author avelasco
 */
function consultaPaisNac(idControl) {
	var jqPais = eval("'#" + idControl + "'");
	var numPais = $(jqPais).val();
	var conPais = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numPais != '' && !isNaN(numPais) && esTab) {
		paisesServicio.consultaPaises(conPais, numPais,function(pais) {
			if (pais != null) {
				$('#paisNac').val(pais.nombre);
				//if (pais.paisID != 700) {
					validaNacionalidad();
				//}
			} else {
				mensajeSis("No Existe el País.");
				$(jqPais).val('');
				$(jqPais).focus();
			}
		});
	}else{
		if(esTab){
			mensajeSis("No Existe el País.");
			$(jqPais).val('');
			$(jqPais).focus();
		}
	}
}

function consultaPaisResidencia(idControl) {
	var jqPais = eval("'#" + idControl + "'");
	var numPais = $(jqPais).val();
	var conPais = 2;
	var paisMexico=700;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numPais != '' && !isNaN(numPais)) {
		paisesServicio.consultaPaises(conPais, numPais,function(pais) {
			if (pais != null) {
				$('#paisResidencia').val(pais.nombre);

				if (Number(pais.paisID) != paisMexico) {
					residenciaExt();
				}else {
					residenciaNacional();
				}
			} else {
				mensajeSis("El país no existe");
				$('#paisResidencia').val('');
				$(jqPais).val('');
				$(jqPais).focus();
			}
		});
	}else {
		$('#paisResidenciaID').val('');
		$('#paisResidencia').val('');
	}
}

/**
 * Valida la nacionalidad de un aval.
 * @author avelasco
 */
function validaNacionalidad(){
	var nacionalidad = $('#nacion').val();
	var pais= $('#lugarNacimiento').val();
	var mexico='700';
	var nacdadMex='N';
	var nacdadExtr='E';

	if(nacionalidad==nacdadMex){
		if(pais!=mexico && pais !='' ){
			mensajeSis("Por la nacionalidad de la persona el país debe ser México");
			$('#lugarNacimiento').val('');
			$('#paisNac').val('');
			$('#lugarNacimiento').focus();
		}
	}
	if(nacionalidad==nacdadExtr){
		if(pais==mexico){
			mensajeSis("Por la nacionalidad de la persona el país NO debe ser México");
			$('#lugarNacimiento').val('');
			$('#paisNac').val('');
			$('#lugarNacimiento').focus();
		}
	}
}

function residenciaExt () {
	$("#estadoID").attr('disabled', 'disabled');
	$("#municipioID").attr('disabled','disabled');
	$("#localidadID").attr('disabled','disabled');
	$("#coloniaID").attr('disabled','disabled');
	$("#CP").attr('disabled','disabled');

	$('#estadoID').val('0');
	$('#municipioID').val('0');
	$('#localidadID').val('0');
	$('#coloniaID').val('0');
	$('#CP').val('0');

	$('#nombreEstado').val('NO APLICA');
	$('#nombreMuni').val('NO APLICA');
	$('#nombreLocalidad').val('NO APLICA');
	$('#colonia').val('NO APLICA');
	$('#ciudad').val('NO APLICA');
}

function residenciaNacional () {
	$("#estadoID").removeAttr('disabled');
	$("#municipioID").removeAttr('disabled');
	$("#localidadID").removeAttr('disabled');
	$("#coloniaID").removeAttr('disabled');
	$("#CP").removeAttr('disabled');

	$('#estadoID').val('');
	$('#municipioID').val('');
	$('#localidadID').val('');
	$('#coloniaID').val('');
	$('#CP').val('');

	$('#nombreEstado').val('');
	$('#nombreMuni').val('');
	$('#nombreLocalidad').val('');
	$('#colonia').val('');
	$('#ciudad').val('');
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
