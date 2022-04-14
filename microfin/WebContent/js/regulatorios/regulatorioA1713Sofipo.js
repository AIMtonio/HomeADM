var opcionMenuRegBean ;
var menuGradoEst		= {};
var menuCargo			= {};
var menuManifest		= {};
var menuOrgano			= {};
var menuPermanente		= {};
var menuTipoMovimiento	= {};
var esTab				= true;
var enteroCero          = 0;

var objetoA1713Bean     = {
	paisID	: 484,
	estadoID: '',
	municipioID: '',
	localidadID: '',
	coloniaID : '',
}

var catRegulatorioA1713 = { 
			'Excel'			: 2,		
			'Csv'			: 3,		
		};
 
var lisMenuRegulatorio = { 
			'Busqueda'		: 1,		
			'Combo'			: 2,	
			'TipoCargo'		: 15,
			'TipoBaja'		: 16,
			'Organo'		: 17,
		};

var catMenuRegulatorio = { 
			'GradoEst'			: 16,		
			'Cargo'				: 6,		
			'Manifest'			: 7,		
			'Organo'			: 8,
			'Permanente'		: 9,
			'TipoMovimiento'	: 17,
		};


/*=======================================
=            Funciones Vista            =
=======================================*/

/**
 *
 * Funcion para consulta de Estado
 *
 */
 function consultaEstado(idControl) {
	var jqEstado = eval("'#" + idControl + "'");
	var numEstado = $(jqEstado).val();	
	var numPais =  $('#paisID').val();
	

	var tipConForanea = 2;	
	setTimeout("$('#cajaLista').hide();", 200);		

	if(numEstado == '0'){
		mensajeSis("Especificar Estado");
				$('#nombreEstado').val('');
				$('#estadoID').val('');
				$('#estadoID').focus();
				return false;
	}

	if(numPais == ''){
				mensajeSis("Especificar Pais");
				$('#paisID').focus();
				$('#nombrePais').val('');
				return false;
	}

	if(numEstado != ''  && !isNaN(numEstado)){
		estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
			if(estado!=null){							
				$('#nombreEstado').val(estado.nombre);
				objetoA1713Bean.estadoID = $('#estadoID').val();
			}else{
				mensajeSis("No Existe el Estado");
				$('#estadoID').val('');
				$('#estadoID').focus();
				$('#estadoID').select();
			}    	 						
		});
	}
	else{
				$('#estadoID').val("");
		}

}


/**
 *
 * Funcion para consultar localidad
 *
 */
 function consultaLocalidad(idControl) {

	var jqLocalidad  = eval("'#" + idControl + "'");
	var numLocalidad = $(jqLocalidad).val();
	var numMunicipio =	$('#municipioID').val();
	var numEstado 	 =  $('#estadoID').val();	
	var numPais 	 =  $('#paisID').val();				
	var tipConPrincipal = 4;	


	setTimeout("$('#cajaLista').hide();", 200);


	if(numPais == ''){
		mensajeSis("Especificar Pais");
		$('#paisID').focus();
		return false;
	}

	if(numEstado == '')
	{
		mensajeSis("Especificar Estado");
		$('#estadoID').focus();
		return false;
	}
	
	if(numMunicipio == '')
	{
		mensajeSis("Especificar Municipio");
		$('#municipioID').focus();
		return false;
	}



	if(numLocalidad != '' && !isNaN(numLocalidad)){
		if(numEstado != '' && numMunicipio !=''){				
			localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
				if(localidad!=null){
					$('#nombreLocalidad').val(localidad.nombreLocalidad);
					objetoA1713Bean.localidadID = $('#localidadID').val();
				}else{
					mensajeSis("No Existe la Localidad");
					$('#localidadID').val("");
					$('#nombreLocalidad').val("");
					$('#localidadID').focus();
					$('#localidadID').select();
				}    	 						
			});
		}else{

			$('#localidadID').val("");
			$('#nombreLocalidad').val("");
			$('#localidadID').focus();
			$('#localidadID').select();
			
		}
		
	}
}



/**
 *
 * Función para consultar País
 *
 */
 function consultaPais(idControl){
	var jqPais = eval("'#" + idControl + "'");
	var numPais = $(jqPais).val();
	var conPais = 3;

	$('#cajaLista').hide();

	if (numPais != '' && !isNaN(numPais)) {
		paisesServicio.consultaPaises(conPais, numPais,
			function(pais) {
				if (pais != null) {
					$('#nombrePais').val(pais.nombre);
					objetoA1713Bean.paisID = $('#paisID').val();
				} else {
					mensajeSis("No Existe el País");
					$('#paisID').val("");

					$('#paisID').focus();
					$('#paisID').select();
					
				}
			});
	}else{
		$('#nombrePais').val('');
		$('#paisID').val('');
	}
}




/**
 *
 * Función para consultar Municipio
 *
 */
 function consultaMunicipio(idControl) {
	var jqMunicipio = eval("'#" + idControl + "'");
	var numMunicipio = $(jqMunicipio).val();	
	var numEstado =  $('#estadoID').val();
	var tipConForanea = 2;	

	var numPais =  $('#paisID').val();
	setTimeout("$('#cajaLista').hide();", 200);	


	if(numPais == ''){
		mensajeSis("Especificar Pais");
		$('#paisID').focus();
		return false;
	}

	if(numEstado == '') {
		mensajeSis("Especificar Estado");
		$('#estadoID').focus();
		return false;
	}


	if(numMunicipio != '' && !isNaN(numMunicipio) && $(jqMunicipio).asNumber()>0){
		municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
					if(municipio!=null){							
						$('#nombreMunicipio').val(municipio.nombre);
						objetoA1713Bean.municipioID = $('#municipioID').val();
															
					}else{
						mensajeSis("No Existe el Municipio");
						$('#municipioID').val("");					
						$('#municipioID').focus();
						$('#municipioID').select();
					}    	 						
			});
		}
		else{
			$('#municipioID').val("");	
			
		}

	}





/**
 *
 * Función para consultar colonia
 *
 */

 function consultaColonia(idControl) {
		
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();		
		var numEstado =  $('#estadoID').val();	
		var numMunicipio =	$('#municipioID').val();
		var numLocalidad =	$('#localidadID').val();
		var numPais =	$('#paisID').val();
		var tipConPrincipal = 1;	
		
		setTimeout("$('#cajaLista').hide();", 200);


		if(numPais == ''){
				mensajeSis("Especificar Pais");
				$('#paisID').focus();
				return false;
			}
		if(numEstado == '')
			{
					mensajeSis("Especificar Estado");
				$('#estadoID').focus();
				return false;
			}
		
		if(numMunicipio == '')
			{
				mensajeSis("Especificar Municipio");
				$('#municipioID').focus();
				return false;
			}
		
		if(numLocalidad == '')
			{
				mensajeSis("Especificar Localidad");
				$('#localidadID').focus();
				return false;
			}


		if(numColonia != '' && !isNaN(numColonia)){
			coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
				if(colonia!=null){							
					$('#nombreColonia').val(colonia.asentamiento);
					$('#codigoPostal').val(colonia.codigoPostal);
					objetoA1713Bean.coloniaID = $('#coloniaID').val();
				}else{
					mensajeSis("No Existe la Colonia");
					$('#nombreColonia').val("");
					$('#coloniaID').val("");
					$('#coloniaID').focus();
					$('#coloniaID').select();
				}    	 						
			});
		}
		else{
			$('#nombreColonia').val("");			
		}



	}



/**
 *
 * Función para cargar los menus del registro
 *
 */
function cargarMenus(){

	// Combo Profesion
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.GradoEst,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean16) {
				dwr.util.removeAllOptions('tituloPofID');
				dwr.util.addOptions('tituloPofID', {'':'SELECCIONAR'}); 
  				dwr.util.addOptions('tituloPofID', opcionesMenuRegBean16, 'codigoOpcion', 'descripcion');

			});

	//Combo Organo al que pertenece
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.Organo,
						'tipoInstitID' : tipoInstitucion,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Organo,opcionMenuRegBean,function(opcionesMenuRegBean8) {
				
				dwr.util.removeAllOptions('organoID');
				dwr.util.addOptions('organoID', {'':'SELECCIONAR'}); 
  				dwr.util.addOptions('organoID', opcionesMenuRegBean8, 'codigoOpcion', 'descripcion');

			});


	//Combo Cargo
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.Cargo,
						'tipoInstitID' : tipoInstitucion,
						'descripcion': ''
						};

	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.TipoCargo,opcionMenuRegBean,function(opcionesMenuRegBean6) {
				dwr.util.removeAllOptions('cargoID');
				dwr.util.addOptions('cargoID', {'':'SELECCIONAR'}); 
  				dwr.util.addOptions('cargoID', opcionesMenuRegBean6, 'codigoOpcion', 'descripcion');
			});
	
	
	//Combo Motivo de Baja
	opcionMenuRegBean = {
						'tipoInstitID' : tipoInstitucion,
						'descripcion': ''
						};

	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.TipoBaja,opcionMenuRegBean,function(opcionesMenuRegBean6) {
				dwr.util.removeAllOptions('causaBajaID');
				dwr.util.addOptions('causaBajaID', {'':'SELECCIONAR'}); 
  				dwr.util.addOptions('causaBajaID', opcionesMenuRegBean6, 'codigoOpcion', 'descripcion');
			});



	//Combo Manifestación de Cumplimiento
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.Manifest,
						'descripcion': ''
						};

	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean7) {
				dwr.util.removeAllOptions('manifestacionID');
				dwr.util.addOptions('manifestacionID', {'':'SELECCIONAR'}); 
  				dwr.util.addOptions('manifestacionID', opcionesMenuRegBean7, 'codigoOpcion', 'descripcion');
			});

	
	//Combo Permanente o Suplente
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.Permanente,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean9) {
				dwr.util.removeAllOptions('permanenteSupID');
				dwr.util.addOptions('permanenteSupID', {'':'SELECCIONAR'}); 
  				dwr.util.addOptions('permanenteSupID', opcionesMenuRegBean9, 'codigoOpcion', 'descripcion');
			});



	//Combo Tipo de Movimiento
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.TipoMovimiento,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean17) {
			menuTipoMovimiento = opcionesMenuRegBean17;
				dwr.util.removeAllOptions('tipoMovimientoID');
				dwr.util.addOptions('tipoMovimientoID', {'':'SELECCIONAR'}); 
  				dwr.util.addOptions('tipoMovimientoID', opcionesMenuRegBean17, 'codigoOpcion', 'descripcion');

			});

}



/**
 *
 * Funcion para cargar la información default
 *
 */

function consultaRegistroRegulatorioA1713(){	
	var fecha 	= $('#fecha').val();
	
	var params 	= {};
	params['tipoLista'] = 1;
	params['fecha'] 		= fecha;




}



/**
 *
 * Función para generar el reporte en exel o csv
 *
 */

function generaReporte(tipoReporte){
		   var fecha = $('#fecha').val();
		   
		   var url='';

		   url = 'reporteRegulatorioA1713.htm?tipoReporte=' + tipoReporte + '&fecha='+fecha;
		   window.open(url);
		   
	   };



/**
 *
 * Función para inicializar el formulario
 *
 */

function inicializaFormulario(){
	$('#tipoMovimientoID').val('');
	$('#nombreFuncionario').val('');
	$('#rfcFuncionario').val('');
	$('#curpFuncionario').val('');
	$('#tituloPofID').val('');
	$('#telefono').val('');
	$('#correoElectronico').val('');
	$('#paisID').val('');
	$('#nombrePais').val('');
	$('#estadoID').val('');
	$('#nombreEstado').val('');
	$('#municipioID').val('');
	$('#nombreMunicipio').val('');
	$('#localidadID').val('');
	$('#nombreLocalidad').val('');
	$('#coloniaID').val('');
	$('#nombreColonia').val('');
	$('#codigoPostal').val('');
	$('#calle').val('');
	$('#numeroExt').val('');
	$('#numeroInt').val('');
	$('#fechaMovimiento').val('');
	$('#inicioGestion').val('');
	$('#conclusionGestion').val('');
	$('#organoID').val('');
	$('#cargoID').val('');
	$('#permanenteSupID').val('');
	$('#causaBajaID').val('');
	$('#manifestacionID').val('');

	deshabilitaBoton('agrega');
	deshabilitaBoton('modifica');
	deshabilitaBoton('elimina');
	
}
		

/**
 *
 * Funcion de exito
 *
 */
 function funcionExito(){
 	inicializaFormulario();
 	deshabilitaBoton('agrega');
 	deshabilitaBoton('modifica');
	deshabilitaBoton('elimina');
 }

 function funcionError(){

 }


/**
 *
 * Consulta registro ID
 *
 */
 function consultaRegistro(){

 	$('#cajaLista').hide();

 	if(parseInt($('#registroID').val()) == 0){
 		inicializaFormulario();	
 		habilitaBoton('agrega');
 		deshabilitaBoton('modifica');
 		deshabilitaBoton('elimina');
 		$('#tipoMovimientoID').focus();
 		return false;
 	}

 	if($('#registroID').val() != '' & !isNaN($('#registroID').val())){

 		var consultaBean = {
 			fecha: $('#fecha').val(),
 			registroID: $('#registroID').val()
 		}

 		regulatorioA1713Servicio.consulta(1,consultaBean,function(registroA1713){
 			
 			if(registroA1713 != null){

 				objetoA1713Bean = registroA1713;

 				dwr.util.setValues(registroA1713);
	 			consultaPais('paisID');
	 			consultaEstado('estadoID');
	 			consultaMunicipio('municipioID');
	 			consultaLocalidad('localidadID');
	 			consultaColonia('coloniaID');
	 			habilitaBoton('modifica');
	 			habilitaBoton('elimina');
	 			deshabilitaBoton('agrega');

	 			$('#tipoMovimientoID').focus();
 			}else{
 				mensajeSis('El Registro no Existe');

 				deshabilitaBoton('modifica');
	 			deshabilitaBoton('elimina');
	 			deshabilitaBoton('agrega');
	 			$('#registroID').focus();
 			}
 			
 		})
 	}else{
 		$('#registroID').val('');
 		inicializaFormulario();	
 		deshabilitaBoton('agrega');
 		deshabilitaBoton('modifica');
 		deshabilitaBoton('elimina');
 	}

 }


function generaReporte(tipoReporte){
		   var fecha = $('#fecha').val();		   
		   var url = 'reporteRegulatorioA1713.htm?tipoReporte=' + tipoReporte + '&fecha='+fecha + '&tipoEntidad='+tipoInstitucion;
		   window.open(url);
		   
};
/*=====  End of Funciones Vista  ======*/



$(document).ready(function() {
	parametros = consultaParametrosSession();
	esTab = true;
	$('#excel').click();
	deshabilitaBoton('agrega');
 	deshabilitaBoton('modifica');
 	deshabilitaBoton('elimina');

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	var paramSesion = consultaParametrosSession();
	var fechaDeSistema = paramSesion.fechaSucursal;
	$('#fecha').val(fechaDeSistema);


	

	cargarMenus(); 
	
	//consultaRegistroRegulatorioA1713();

	$(':text').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
				

			});

	$(':text').focus(function() {
		esTab = false;
		
	});


	/*=============================================
	=            Funciones de Registro            =
	=============================================*/

	$('#reporteD0842').click(function(event){
		
		setTimeout(function(){
			$('#excel').click();
		},30);
	});

	$('#registroD0842').click(function(event){
		setTimeout(function(){
			$('#registroID').focus();
		},30);
		
	})

		
	$('#fechaMovimiento').change(function(event){
		if(!esTab){
			$('#fechaMovimiento').focus();
		}
	});

	$('#inicioGestion').change(function(event){
		if(!esTab){
			$('#inicioGestion').focus();
		}
	});
	
	$('#conclusionGestion').change(function(event){
		if(!esTab){
			$('#conclusionGestion').focus();
		}
	});



	$('#tipoMovimientoID').change(function(event){
		$('#paisID').val('484');
		consultaPais('paisID');

		if(parseInt($('#tipoMovimientoID').val()) == 2 || parseInt($('#tipoMovimientoID').val()) == 3){
			$('#manifestacionID').val(2);
			habilitaControl("causaBajaID");
			$('#causaBajaID').val('');
		}else{
			$('#manifestacionID').val(1);
			deshabilitaControl("causaBajaID");
			$('#causaBajaID').val('0');
		}

		deshabilitaControl("manifestacionID");

	});



	$('#fechaMovimiento').blur(function(event){
		if(parametroBean.fechaAplicacion < $('#fechaMovimiento').val()){
			mensajeSis('Fecha de Movimiento es Mayor a la Fecha Actual');
			$('#fechaMovimiento').val('');			
			$('#fechaMovimiento').focus();			
		}


		if($('#inicioGestion').val() != '' & $('#inicioGestion').val() > $('#fechaMovimiento').val()){
			mensajeSis('Fecha de Movimiento es Menor a la Fecha Inicio de Gestión');
			$('#fechaMovimiento').val('');			
			$('#fechaMovimiento').focus();			
		}


	});

	$('#inicioGestion').blur(function(event){
		if(parametroBean.fechaAplicacion < $('#inicioGestion').val()){
			mensajeSis('Fecha de Inicio de Gestión es Mayor a la Fecha Actual');
			$('#inicioGestion').val('');			
			$('#inicioGestion').focus();			
		}


		if($('#conclusionGestion').val()!= '' & $('#conclusionGestion').val() != '1900-01-01'){
			if($('#conclusionGestion').val() < $('#inicioGestion').val()){
				mensajeSis('Fecha de Inicio es Mayor a la Fecha de Conclusión de la Gestión');
				$('#inicioGestion').val('');			
				$('#inicioGestion').focus();			
			}
		}

		if($('#inicioGestion').val() > $('#fechaMovimiento').val()){
			mensajeSis('Fecha de Inicio de Gestión es Mayor a la Fecha de Movimiento');
			$('#inicioGestion').val('');			
			$('#inicioGestion').focus();			
		}
		

	});


	$('#conclusionGestion').blur(function(event){
		if(parametroBean.fechaAplicacion < $('#conclusionGestion').val() & $('#conclusionGestion').val() != ''){
			mensajeSis('Fecha de Fin de Gestión es Mayor a la Fecha Actual');
			$('#conclusionGestion').val('');			
			$('#conclusionGestion').focus();			
		}


		if($('#inicioGestion').val()!= '' & $('#inicioGestion').val() != '1900-01-01'){
			if($('#conclusionGestion').val() != '' & $('#conclusionGestion').val() < $('#inicioGestion').val() ){
				mensajeSis('Fecha de Conlusión es Menor a la Fecha de Inicio de la Gestión');
				$('#conclusionGestion').val('');			
				$('#conclusionGestion').focus();			
			}
		}

	});
	
	/*=====  End of Funciones de Registro  ======*/
	
	

	/*============================================
	=            Asignación de Listas            =
	============================================*/
		$('#registroID').keyup(function(event){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "fecha";
			camposLista[1] = "nombreFuncionario";
			
			
			parametrosLista[0] = $('#fecha').val();
			parametrosLista[1] = $('#registroID').val();

			lista('registroID', '3', '2', camposLista, parametrosLista , 'registroA1713Lista.htm');	
		});

		$('#registroID').blur(function(event){
			
			consultaRegistro();

		});




		$('#paisID').keyup(function(event){
			var paisvalue = $('#paisID').val();
			
			lista('paisID', '3', '2', 'nombre',paisvalue, 'listaPaises.htm');	
		});

		$('#paisID').blur(function(event){
			if(objetoA1713Bean.paisID != $('#paisID').val()){
				$('.paisID').val('');
			}
			consultaPais('paisID');
		});




		$('#estadoID').keyup(function(event){
			var estadoValue = $('#estadoID').val();

			lista('estadoID', '2', '1', 'nombre',estadoValue, 'listaEstados.htm');
		});

		$('#estadoID').blur(function(event){
			if(objetoA1713Bean.estadoID != $('#estadoID').val()){
				$('.estadoID').val('');
			}
			consultaEstado('estadoID');
		});


		$('#municipioID').keyup(function(event){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "estadoID";
			camposLista[1] = "nombre";
			
			
			parametrosLista[0] = $('#estadoID').val();
			parametrosLista[1] = $('#municipioID').val();
			
			lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
		});

		$('#municipioID').blur(function(event){
			if(objetoA1713Bean.municipioID != $('#municipioID').val()){
				$('.municipioID').val('');
			}
			consultaMunicipio('municipioID');
		});




		$('#localidadID').keyup(function(event){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "estadoID";
			camposLista[1] = 'municipioID';
			camposLista[2] = "nombreLocalidad";
			
			
			parametrosLista[0] = $('#estadoID').val();
			parametrosLista[1] = $('#municipioID').val();
			parametrosLista[2] = $('#localidadID').val();
			
			lista('localidadID', '2', '3', camposLista, parametrosLista,'listaLocalidades.htm');
		});

		$('#localidadID').blur(function(event){
			consultaLocalidad('localidadID');
		});


		$('#coloniaID').keyup(function(event){
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

		$('#coloniaID').blur(function(event){
			if(objetoA1713Bean.coloniaID != $('#coloniaID').val()){
				$('.coloniaID').val('');
			}
			consultaColonia('coloniaID');
		});



	
	
	/*=====  End of Asignación de Listas  ======*/
	



	$('#fecha').blur(function() {
			if($('#capturaInfo').is(':visible')){
				
				$('#registroID').focus();
			}else{
				$('#excel').focus();
			}
			  
	});
			
			

	$('#fecha').change(function (){
		   var fechaActual = parametroBean.fechaAplicacion;	
		   var fechaSeleccionado = $('#fecha').val();
		   inicializaFormulario();
		   $('#registroID').val('');

		   if(this.value > fechaActual){
			   mensajeSis("La fecha Indicada es Mayor a la Fecha Actual del Sistema.");
			   $('#fecha').val(fechaActual);
			   $('#fecha').focus();
		   }else{
		   		if($('#capturaInfo').is(':visible')){
					$('#registroID').focus();
				}else{

					$('#excel').click();
				}
		   }

		   

			
	});


	$('#curpFuncionario').blur(function(event){
		if($('#rfcFuncionario').val() != '' && $('#curpFuncionario').val() != ''  ){
			if($('#curpFuncionario').val().substr(0,9) != $('#rfcFuncionario').val().substr(0,9)){
				mensajeSis('La CURP ingresada no corresponde con el RFC');
				$('#curpFuncionario').focus();
			}
		}
	});

	$('#rfcFuncionario').blur(function(event){
		if($('#rfcFuncionario').val() != '' && $('#curpFuncionario').val() != ''  ){
			if($('#curpFuncionario').val().substr(0,9) != $('#rfcFuncionario').val().substr(0,9)){
				mensajeSis('La CURP ingresada no corresponde con el RFC');
				$('#curpFuncionario').focus();
			}
		}
	});

	$('#agrega').click(function(event){
		$('#tipoTransaccion').val(1);
		$('#tipoInstitID').val(3);

	});
	$('#modifica').click(function(event){
		$('#tipoTransaccion').val(2);
		$('#tipoInstitID').val(3);		
	});
	$('#elimina').click(function(event){
		if($('#formaGenerica').valid()){
			mensajeSisRetro({
				mensajeAlert : '¿Confirma Eliminar el Registro Actual?',
				muestraBtnAceptar: true,
				muestraBtnCancela: true,
				txtAceptar : 'Eliminar',
				txtCancelar : 'Cancelar',
				funcionAceptar : function(){
					$('#tipoTransaccion').val(3);
					$('#tipoInstitID').val(3);
					$('#formaGenerica').submit();
				},
				funcionCancelar : function(){
					
				}
			});
		}
		
		return false;
	
	});
		


	$('#generar').click(function(event){
		if($('#excel').is(':checked')){
				generaReporte(catRegulatorioA1713.Excel);
		}
		if($('#csv').is(':checked')){
				generaReporte(catRegulatorioA1713.Csv);
		}		
	});
	

	

	//------------ Validaciones de Controles -------------------------------------
	
	$.validator.setDefaults({
	    submitHandler: function(event) {
    
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','registroID','funcionExito','funcionError');
					//Si la respuesta es éxitosa se habilita el botón generar	


	    }
	 });

	$('#formaGenerica').validate({
		rules: {
			fecha:{
				required: true,
				date: true
			} ,
			registroID: {
				required: true,
			},
			tipoMovimientoID: {
				required: true,
			},
			nombreFuncionario: {
				required: true,
				maxlength: 250,
				alfanumerico: true,

			},
			rfcFuncionario: {
				required: true,
				maxlength:13,
				minlength: 13,
				rfc: true,
			},
			curpFuncionario: {
				required: true,
				maxlength: 18,
				minlength: 18,
				curp: true,
			},
			tituloPofID: {
				required: true,
			},
			telefono: {
				required: true,
				digits: true
			},
			correoElectronico: {
				required: true,
				email: true
			},
			paisID: {
				required: true,
			},

			estadoID: {
				required: true,
			},

			municipioID: {
				required: true,
			},

			localidadID: {
				required: true,
			},

			coloniaID: {
				required: true,
			},

			nombreColonia: {
				required: true,
			},
			codigoPostal: {
				required: true,
				digits: true,
				minlength: 4,
				maxlength: 5
			},
			calle: {
				required: true,
				alfanumerico: true,
				maxlength: 250
			},
			numeroExt: {
				required: true,
				alfanumerico: true,
				maxlength: 10
			},
			numeroInt: {
				required: true,
				alfanumerico: true,
				maxlength: 10
			},
			fechaMovimiento: {
				required: true,
				date: true,
			},
			inicioGestion: {
				required: true,
				date: true,
			},
			conclusionGestion: {
				required: true,
				date: true,
			},
			organoID: {
				required: true,
			},
			cargoID: {
				required: true,
			},
			permanenteSupID: {
				required: true,
			},
			causaBajaID: {
				required: true,
			},
			manifestacionID: {
				required: true,
			},
			

		},		
		messages: {
			fecha:{
				required: 'Seleccione una fecha',
				date: 'Ingrese una fecha válida'
			},
			registroID: {
				required: 'El Registro es requerido',
			},
			tipoMovimientoID: {
				required: 'El tipo de Movimiento es requerido',
			},
			nombreFuncionario: {
				required: 'Ingrese el nombre del funcionario',
				maxlength: 'Máximo 250 caracteres',
				alfanumerico: 'Ingrese un nombre válido',

			},
			rfcFuncionario: {
				required: 'Ingrese el RFC',
				maxlength: 'Máximo 13 caracteres',
				minlength: 'Ingrese un RFC válido',
				rfc: 'Ingrese un RFC válido',
			},
			curpFuncionario: {
				required: 'Ingrese la CURP',
				maxlength: 'Máximo 18 caracteres',
				minlength:  'Ingrese una CURP válida',
				curp: 'Ingrese una CURP válida',
			},
			tituloPofID: {
				required: 'Seleccione una profesión',
			},
			telefono: {
				required: 'Ingrese un número de teléfono',
				digits: 'Ingrese un teléfono válido'
			},
			correoElectronico: {
				required: 'Ingrese el correo electrónico',
				email: 'Ingrese un correo válido'
			},
			paisID: {
				required: 'Ingrese un país',
			},

			estadoID: {
				required: 'Ingrese un estado',
			},

			municipioID: {
				required: 'Ingrese un municipio',
			},

			localidadID: {
				required: 'Ingrese una localidad',
			},

			coloniaID: {
				required: 'Ingrese una colonia',
			},
			nombreColonia: {
				required: 'Ingrese el nombre de la colonia',
			},
			codigoPostal: {
				required: 'Ingrese el código postal',
				digits: 'Ingrese un código válido',
				minlength: 'Ingrese un código válido',
				maxlength: 'Ingrese un código válido'
			},
			calle: {
				required: 'Ingrese el nombre de la calle',
				alfanumerico: 'Ingrese una calle válida',
				maxlength: 'Máximo 250 caracteres'
			},
			numeroExt: {
				required: 'Ingrese el numero exterior',
				alfanumerico: 'Ingrese un dato válido',
			},
			numeroInt: {
				required: 'Ingrese el número interior',
				alfanumerico: 'Ingrese un dato válido',
			},
			fechaMovimiento: {
				required: 'Ingrese la fecha de movimiento',
				date: 'Ingrese una fecha válida',
			},
			inicioGestion: {
				required: 'Ingrese la fecha de Inicio de gestión',
				date: 'Ingrese una fecha válida',
			},
			conclusionGestion: {
				required: 'Ingrese la fecha de fin de gestión',
				date: 'Ingrese una fecha válida',
			},
			organoID: {
				required: 'Seleccione un organo',
			},
			cargoID: {
				required: 'Seleccione un cargo',
			},
			permanenteSupID: {
				required: 'Seleccione una opción',
			},
			causaBajaID: {
				required: 'Seleccione la causa de baja',
			},
			manifestacionID: {
				required: 'Seleccione la manifestación del Cumplimiento',
			},
			
		}		
	});



	$.validator.addMethod("alfanumerico", function(value, element) {
        return this.optional(element) || /^[a-z0-9\s]+$/i.test(value);
    }, "Ingrese solo letras");

    $.validator.addMethod("rfc", function(value, element) {
        return this.optional(element) || /^[a-z0-9]+$/i.test(value);
    }, "Ingrese un rfc válido");

    $.validator.addMethod("curp", function(value, element) {
        return this.optional(element) || /^[a-z0-9]+$/i.test(value);
    }, "Ingrese un rfc válido");

});// cerrar














