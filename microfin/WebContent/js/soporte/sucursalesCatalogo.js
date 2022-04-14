var tipoInstFinancieras = {
	'sofipo' : 3,
	'sofom' : 4,
	'sofol' : 5,
	'scap' : 6
};

$(document).ready(function() {

	$("#sucursalID").focus();

	esTab = true;
	var parametroBean = consultaParametrosSession();
	$('#fechaSucursal').val(parametroBean.fechaSucursal);
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	$('#png').hide();
	$('#png1').hide();
	//Definicion de Constantes y Enums
	var catTipoTransaccionSucursal = {
  		'agrega':'1',
  		'modifica':'2',

	};

	var catTipoConsultaSucursal = {
  		'principal':1,
  		'foranea':2
	};

	var catTipoConPromCapta = {
  		'promCaptacion': 6
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------


	$(':text').focus(function() {
	 	esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			if(validaHorarios()){    
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','sucursalID','Exito','Error');
			}
		}

    });

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('td[name=td-claveCNBV]').hide();
	consultaTipInstFinanciera();

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionSucursal.agrega);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionSucursal.modifica);
	});

	$('#sucursalID').blur(function() {
  		validaSucursal(this);
	});

	$('#sucursalID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalID', '2', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});

	$('#estadoID').blur(function() {
  		consultaEstado(this.id);
	});
	$('#estadoID').bind('keyup',function(e) {
		lista('estadoID', '2', '1', 'nombre',$('#estadoID').val(),'listaEstados.htm');
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

	$('#localidadID').blur(function() {
		consultaLocalidad(this.id);
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

	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#estadoID').val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numLocalidad != '' && numLocalidad != 0 && !isNaN(numLocalidad) && esTab){
			localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,{ async: false, callback: function(localidad) {
				if(localidad!=null){
					$('#nombrelocalidad').val(localidad.nombreLocalidad);
				}else{
					mensajeSis("No Existe la Localidad");
					$('#nombrelocalidad').val("");
					$('#localidadID').val("");
					$('#localidadID').focus();
					$('#localidadID').select();
				}
				 consultaDirecCompleta()
			}});
		}else {
			if (numLocalidad == '') {
				$('#nombrelocalidad').val("");
			}
		}
		 consultaDirecCompleta()
	}



	$('#nombreGerente').bind('keyup',function(e){
		lista('nombreGerente', '2', '1', 'nombreCompleto', $('#nombreGerente').val(), 'listaUsuarios.htm');
	});

	$('#nombreGerente').blur(function() {
		var claveGerente = $('#nombreGerente').val();
		if(claveGerente != '' && esTab == true){
			consultaGerente(this.id);
		}
		else{
			$('#nombGerente').val('');
		}

	});
	$('#subGerente').bind('keyup',function(e){
		lista('subGerente', '2', '1', 'nombreCompleto', $('#subGerente').val(), 'listaUsuarios.htm');
	});

	$('#subGerente').blur(function() {
		var claveSubgerente = $('#subGerente').val();
		if(claveSubgerente != '' && esTab == true){
			consultaSubGerente(this.id);
		}
		else{
			$('#nomSubGerente').val('');
		}


	});

	$('#plazaID').bind('keyup',function(e){
		lista('plazaID', '2', '1', 'nombre', $('#plazaID').val(), 'listaPlazas.htm');
	});
	$('#plazaID').blur(function() {
  		consultaPlaza(this.id);
	});
	$('#CP').blur(function() {
  		consultaDirecCompleta(this.id);
  	});
  	$('#centroCostoID').bind('keyup',function(e){
		lista('centroCostoID', '2', '1', 'descripcion', $('#centroCostoID').val(), 'listaCentroCostos.htm');
	});
	$('#centroCostoID').blur(function() {
  		consultaCentroCostos(this.id);
	});

	$('#coloniaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "asentamiento";

		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#coloniaID').val();

		lista('coloniaID', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
	});


	$('#coloniaID').blur(function() {
		consultaColonia(this.id);

	});

	//consulta Colonia
	function consultaColonia(idControl) {
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();
		var numEstado =  $('#estadoID').val();
		var numMunicipio =	$('#municipioID').val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numColonia != '' && !isNaN(numColonia)){
			coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,{ async: false, callback: function(colonia) {
				if(colonia!=null){
					$('#colonia').val(colonia.asentamiento.substring(0,45));
					$('#CP').val(colonia.codigoPostal);
					consultaDirecCompleta(idControl);
				}else{
					mensajeSis("No Existe la Colonia");
					$('#colonia').val("");
					$('#coloniaID').val("");
					$('#coloniaID').focus();
				}
			}});
		}else{
			$('#colonia').val("");
		}
	}

	$('#longitud').blur(function(){
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


	$('#poderNotarial1').click(function() {
		$('#png').show();
		$('#png1').show();
		$('#PoderNotarial').focus();
	});

	$('#poderNotarial2').click(function() {
		$('#png').hide();
		$('#png1').hide();
		$('#subGerente').focus();
		$('#PoderNotarial').val('');
	});

	$('#telefono').setMask('phone-us');

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

	$('#promotorCaptaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#promotorCaptaID').val();
		parametrosLista[1] = $('#sucursalID').val();
		lista('promotorCaptaID', '2', '8',camposLista, parametrosLista, 'listaPromotores.htm');
	});

	$('#promotorCaptaID').blur(function () {
		consultaEjeCaptacion(this.id);
	});

	//validaPromotor();

	//----------- Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			nombreSucurs: {
				required: true,
				minlength: 3
			},
			tipoSucursal: {
				required: true,
			},
			plazaID: {
				required: true
			},
			centroCostoID: {
				required: true
			},
			IVA: {
				required: true,
				number: true
			},
			tasaISR: {
				required: true,
				number: true
			},

			estadoID: {
				required: true
			},
			municipioID: {
				required: true
			},
			calle: {
				required: true,
			},
			coloniaID: {
				required: true,
			},
			CP: {
				required: true,
			},
			difHorarMatriz: {
				required: true,
				number: true
			},
			extTelefonoPart: {
				number: true
			},
			localidadID:{
				required : true,
			},
			promotorCaptaID:{
				required : function() {return $('#muestraEjec').val() == 'N';}
			},
			claveSucCNBV:{
				required:function() {return $('#claveSucCNBV').is(':visible');}
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
			horaInicioOper:{
				required: true,
				horahhmm:horaInicioOper,
				maxlength: 5,
			},
			horaFinOper:{
				required: true,
				horahhmm:horaFinOper,
				maxlength: 5,
			}
		},
		messages: {
			nombreSucurs: {
				required: 'Especifique Nombre de la Sucursal.'
			},

			tipoSucursal: {
				required: 'Especifique Tipo de la Sucursal.'

			},
			plazaID: {
				required: 'Especifique Plaza.'
			},
			centroCostoID: {
				required: 'Especifique Centro de Costo.'
			},
			IVA: {
				required: 'Especifique el IVA.',
				number: 'Solo Números'
			},
			tasaISR: {
				required: 'Especifique el ISR.',
				number: 'Solo Números'
			},

			estadoID: {
				required: 'Especifique el Estado.'
			},
			municipioID: {
				required: 'Especifique el Municipio.'
			},
			calle: {
				required: 'Especifique la Calle.'
			},
			coloniaID: {
				required: 'Especifique la Colonia.'
			},
			CP: {
				required: 'Especifique el C.P.'
			},
			difHorarMatriz: {
				required: 'Especifique la Diferencia Horaria.',
				number: 'Solo Números'
			},
			extTelefonoPart: {
				number: 'Sólo Números(Campo opcional).'
			},
			promotorCaptaID:{
				required: 'Especifique el Ejecutivo de Captación.'
			},
			claveSucCNBV:{
				required:'Especifique la Clave de la Sucursal.'
			},
			localidadID:{
				required : 'Especificar la Localidad'
			},
			latitud:{
				required: 'Especifique la Latitud de la Sucursal',
				digito: 'Ingrese una Latitud correcta',
				maxlength: 'Se permiten 10 caracteres',
			},
			longitud:{
				required: 'Especifique la Longitud de la Sucursal',
				digito: 'Ingrese una Longitud correcta',
				maxlength: 'Se permiten 11 caracteres',
			},
			horaInicioOper:{
				required: 'Especifique horario inicio de operaciones de Sucursal',
				horahhmm: 'Ingrese un horario correcto',
				maxlength: 'Se permiten 5 caracteres, formato valido 00:00',
			},
			horaFinOper:{
				required: 'Especifique horario inicio de operaciones de Sucursal',
				horahhmm: 'Ingrese un horario correcto',
				maxlength: 'Se permiten 5 caracteres 00:00, formato valido',
			}
		}
	});


	jQuery.validator.addMethod("digito", function(value, element) {
	  return this.optional(element) || /^[-]?\d*\.\d+$/.test(value);
	}, "Ingrese un valor correcto");

	jQuery.validator.addMethod("horahhmm", function(value, element) {
		var res = false;
		// Formato hh:mm
		res = this.optional(element) || /^\d{2}[:]\d{2}$/.test(value);
		var hora = value.split(':');
		var hh = parseInt(hora[0],10);
		var mm = parseInt(hora[1],10);
		if (hh < 0 || hh > 23) res = false;
		if (mm < 0 || mm > 59) res = false;
		if (hh==0 && mm==0) res= false;

		return res;
	}, "La hora indicada no es válida");
	//------------ Validaciones de Controles -------------------------------------

	function consultaEjeCaptacion(idControl) {
		var jqNumPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqNumPromotor).val();

		var promoBean={
			'sucursalID' : $('#sucursalID').val(),
			'promotorID' : numPromotor
		};
		if (numPromotor != '' && !isNaN(numPromotor) && esTab) {
			promotoresServicio.consulta(catTipoConPromCapta.promCaptacion, promoBean, function (promotores) {
				if (promotores != null){
					$('#descEjecutivoCapta').val(promotores.nombrePromotor);
				}else {
					mensajeSis("El Promotor Seleccionado No Existe");
					$('#descEjecutivoCapta').val('');
					$(jqNumPromotor).focus();
				}
			});
		}
	}

		function validaSucursal(control) {
		var numSucursal = $('#sucursalID').val();
		var gerente = "";
		var subgerente = "";

		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal)){
			habilitaBoton('agrega', 'submit');
			habilitaBoton('modifica', 'submit');
			sucursalesServicio.consultaSucursal(catTipoConsultaSucursal.principal,numSucursal,{ async: false, callback: function(sucursal) {
				if(sucursal!=null){
					dwr.util.setValues(sucursal);
					$('#descEjecutivoCapta').val('');
					esTab=true;
					$('#plazaID').val(sucursal.plazaID);
					consultaPlaza('plazaID');
					$('#centroCostoID').val(sucursal.centroCostoID);
					consultaCentroCostos('centroCostoID');

					gerente = sucursal.nombreGerente;
					subgerente = sucursal.subGerente;

					if(gerente == 0){
						$('#nombreGerente').val("");
						$('#nombGerente').val("");
					}
					else{
						$('#nombreGerente').val(sucursal.nombreGerente);
						consultaGerente('nombreGerente');
					}

					if(subgerente == 0){
						$('#subGerente').val("");
						$('#nomSubGerente').val("");
					}
					else{
						$('#subGerente').val(sucursal.subGerente);
						consultaSubGerente('subGerente');
					}

					$('#estadoID').val(sucursal.estadoID);
					consultaEstado('estadoID');
					$('#municipioID').val(sucursal.municipioID);
					$('#latitud').val(sucursal.latitud);
					$('#longitud').val(sucursal.longitud);
					$('#horaInicioOper').val(sucursal.horaInicioOper);
					$('#horaFinOper').val(sucursal.horaFinOper);


					consultaMunicipio('municipioID');
					consultaLocalidad('localidadID');
					consultaColonia('coloniaID');

					deshabilitaBoton('agrega', 'submit');
					habilitaBoton('modifica', 'submit');
					if(sucursal.poderNotarial=='S'){
						$('#png').show();
						$('#png1').show();
						$('#poderNotarial1').attr("checked",true);
					}else{
						$('#png').hide();
						$('#png1').hide();
						$('#poderNotarial2').attr("checked",true);
						$('#poderNotarial1').attr("checked",false);
					}
					$('#telefono').setMask('phone-us');
					$('#promotorCaptaID').val(sucursal.promotorCaptaID);
					consultaEjeCaptacion('promotorCaptaID');
				}else{
					limpiaCampos();
					$('#nomPlaza').val('');
					$('#descripcionCC').val('');
					$('#nombGerente').val('');
					$('#nomSubGerente').val('');
					$('#png').hide();
					$('#png1').hide();
					$('#fechaSucursal').val(parametroBean.fechaSucursal);
					habilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
				}
			}});
		}
	}

	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numEstado != '' && !isNaN(numEstado) && esTab){
			estadosServicio.consulta(tipConForanea,numEstado,{ async: false, callback: function(estado) {
				if(estado!=null){
					$('#nombreEstado').val(estado.nombre);
				}else{
					mensajeSis("No Existe el Estado");
					$('#estadoID').focus();
				}
			}});
		}
	}

	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();
		var numEstado =  $('#estadoID').val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMunicipio != '' && !isNaN(numMunicipio) && esTab){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,{ async: false, callback: function(municipio) {
				if(municipio!=null){
					$('#nombreMuni').val(municipio.nombre);
				}else{
					mensajeSis("No Existe el Municipio");
					$('#municipioID').focus();
					$('#municipioID').select();
				}
			}});
		}
	}

	function consultaGerente(idControl) {
		var jqGerente = eval("'#" + idControl + "'");
		var numGerente = $(jqGerente).val();
		var usuarioBeanCon = {
				'usuarioID':numGerente
		};
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numGerente != '' && !isNaN(numGerente) && esTab){
			usuarioServicio.consulta(tipConForanea,usuarioBeanCon,{ async: false, callback: function(gerente) {
				if(gerente!=null){
					$('#nombGerente').val(gerente.nombreCompleto);
				}else{
					mensajeSis("No Existe el Gerente");
					$('#nombreGerente').focus();
					$('#nombreGerente').select();
				}
			}});
		}
	}

	function consultaSubGerente(idControl) {
		var jqSubGerente = eval("'#" + idControl + "'");
		var numSubGerente = $(jqSubGerente).val();
		var usuarioBeanCon = {
				'usuarioID':numSubGerente
		};
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSubGerente != '' && !isNaN(numSubGerente) && esTab){
			usuarioServicio.consulta(tipConForanea,usuarioBeanCon,{ async: false, callback: function(subgerente) {
				if(subgerente!=null){
					$('#nomSubGerente').val(subgerente.nombreCompleto);
				}else{
					mensajeSis("No Existe el SubGerente");
					$('#subGerente').focus();
					$('#subGerente').select();
				}
			}});
		}
	}

	function consultaPlaza(idControl) {
		var jqPlaza = eval("'#" + idControl + "'");
		var numPlaza = $(jqPlaza).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		var plazaBeanCon = {
				'plazaID':$('#plazaID').val()
		};
		if(numPlaza != '' && !isNaN(numPlaza) && esTab){
			plazasServicio.consulta(tipConForanea,plazaBeanCon,{ async: false, callback: function(plaza) {
				if(plaza!=null){
					$('#nomPlaza').val((plaza.nombre).toUpperCase());
				}else{
					$('#plazaID').focus();
					mensajeSis("No Existe la Plaza");
				}
			}});
		}
	}

	function consultaCentroCostos(idControl) {
		var jqCentro = eval("'#" + idControl + "'");
		var numCentro = $(jqCentro).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var centroBeanCon = {
				'centroCostoID':$('#centroCostoID').val()
		};
		if(numCentro != '' && !isNaN(numCentro) && esTab){
			centroServicio.consulta(catTipoConsultaSucursal.foranea,centroBeanCon,{ async: false, callback: function(centro) {
				if(centro!=null){
					$('#descripcionCC').val(centro.descripcion);
				}else{
					$('#centroCostoID').focus();
					mensajeSis("No Existe el Centro de Costos");
				}
			}});
		}
	}

	function consultaDirecCompleta() {
		var ca =  $('#calle').val();
  		var nu =  $('#numero').val();
  		var co =  $('#colonia').val();
  		var cp =  $('#CP').val();
  		var nm =  $('#nombreMuni').val();
  		var ne =  $('#nombreEstado').val();
  		var dirCom =	(ca +", No." + nu +", Col. "+ co +", C.P. "+ cp +", "+ nm  + ", "+ ne +"." );
  		$('#direcCompleta').val(dirCom.toUpperCase());
	}

	// funcion para validar para ocultar  o habilitar  campo en caso de ser requerido

	function validaPromotor(){
		var tipoConsulta  = 5;
		var promotorBean = {
			'tipoPromotorID' : ''
		};
		promotoresServicio.consulta(tipoConsulta, promotorBean, { async: false, callback: function(promotorBean){
			if (promotorBean != null){
				$('#muestraEjec').val(promotorBean.aplicaPromotor);
				if (promotorBean.aplicaPromotor == 'N'){
					$('.promotorcap').show();
				}else{
					$('.promotorcap').hide();
					$('#ejecutivoCap').val("N");
					$('#promotorExtInv').val("N");
				}
			}
		}});
	}
});

function consultaTipInstFinanciera(){
	var numConsulta = 15;
	var paramBean = {
		'empresaID' : 1
	};
	parametrosSisServicio.consulta(numConsulta, paramBean, { async: false, callback: function(parametrosBean) {
		if (parametrosBean != null) {
				if(Number(parametrosBean.tipoInstitID)!=tipoInstFinancieras.sofom){
					$('td[name=td-claveCNBV]').show();
				} else {
					$('td[name=td-claveCNBV]').hide();
				}
		}
	}});
}

function validaHorarios(){
	 var horaIni=$('#horaInicioOper').val();
     var horaFin=$('#horaFinOper').val();
     if(horaIni>=horaFin){
	    mensajeSis("Horario de inicio operaciones no puede ser mayor o igual al horario fin");
		return false;
     }else{
     	return true;
     }
}

function limpiaCampos(){
	inicializaForma('formaGenerica','sucursalID');
	$('#nomPlaza').val('');
	$('#tipoSucursal').val('');
}

function Exito() {
	deshabilitaBoton('modifica','submit');
	deshabilitaBoton('agrega','submit');
	limpiaCampos();
}

function Error() {

}
