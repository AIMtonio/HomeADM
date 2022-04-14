$(document).ready(function (){

	esTab = true;
	parametros = consultaParametrosSession();
	$('#nombreUsuario').val(parametros.claveUsuario); // parametros del sesion para el reporte
	$('#nombreInstitucion').val(parametros.nombreInstitucion);
	$('#fechaEmision').val(parametroBean.fechaSucursal);
	$('#institucionID').val(0); 
	$('#cuentaBancaria').val(0); 
	$('#clienteID').val(0);
	$('#desnombreInstitucion').val('TODAS');
	$('#nombreCuenta').val('TODAS');	
	$('#nombreCliente').val('TODOS');	
	
	// Definicion de Constantes y Enums

	var catTipoListaSucursal = {
			'combo': 2
	};

	var catTipoConsultaCentro = { 
		  	'principal'	: 1,
		  	'foranea'	: 2
			};
	var catTipoConsultaInstituciones = {
			'principal':1, 
			'foranea':2
		};
	var catFormatoReporte = {
			'pdf'   :1,
			'excel' :2
			
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$.validator.setDefaults({
		submitHandler: function(event) { 

		}
	});		
	agregaFormatoControles('formaGenerica');	
	cargaSucursales();	

	$('#fechaInicial').val(parametros.fechaAplicacion); 	
	$('#fechaFinal').val(parametros.fechaAplicacion);
	
	var fechaSis = parametroBean.fechaSucursal;
	$('#fechaInicial').change(function(){	
		if($('#fechaFinal').val()> fechaSis){
			alert("La Fecha no Puede ser Mayor a la del Sistema");
			$('#fechaInicial').val(parametros.fechaAplicacion);
		}
	});
	$('#fechaFinal').change(function(){	
		if($('#fechaFinal').val()> fechaSis){
			alert("La Fecha no Puede ser Mayor a la del Sistema");
			$('#fechaFinal').val(parametros.fechaAplicacion);
		}
	});
	
	$('#fechaInicial').change(function(){
		validafechaIni();
	});
	$('#fechaFinal').change(function(){
		validafechaFin();
	});
	
	function validafechaIni(){	
	if($('#fechaInicial').val()>$('#fechaFinal').val()){
	alert("La Fecha de Inicio es Mayor a la Fecha de Fin");
	$('#fechaInicial').val(parametros.fechaAplicacion);
	}
	}
	
	function validafechaFin(){	
		if($('#fechaInicial').val()>$('#fechaFinal').val()){
		alert("La Fecha de Inicio es Mayor a la Fecha de Fin");
		$('#fechaFinal').val(parametros.fechaAplicacion);		
		}
		}


	$(':text').focus(function() {	
		esTab = false;
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#generar').click(function(){		
			if($('#pdf').is(':checked')){
				enviaDatosRepPDF();
			}else if($('#excel').is(':checked')){
				enviaDatosRepExcel();
			}					
	});
	$('#fechaInicial').change(function() {
		var fechaIni=1;
		var Xfecha= $('#fechaInicial').val();
		if(esFechaValida(Xfecha, fechaIni)){
			if(Xfecha=='')$('#fechaInicial').val(parametroBean.fechaSucursal);
			
		}else{
			$('#fechaInicial').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFinal').change(function() {
		var fechaIni=2;
		var Yfecha= $('#fechaFinal').val();
		if(esFechaValida(Yfecha, fechaIni)){
			if(Yfecha=='')$('#fechaFinal').val(parametroBean.fechaSucursal);

		}else{
			$('#fechaFinal').val(parametroBean.fechaSucursal);
		}

	});	

	
	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('institucionID', '2', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	  $('#institucionID').blur(function() {
	   	consultaInstitucion(this.id);  
	   	
	   	if($('#institucionID').val() == 0){
	   		$('#desnombreInstitucion').val("TODAS");
	   	}
	   	
	  });
	
	$('#cuentaBancaria').bind('keyup',function(e){
	    	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "institucionID";
			parametrosLista[0] = $('#institucionID').val();
			listaAlfanumerica('cuentaBancaria', '2', '3', camposLista,parametrosLista, 'ctaNostroLista.htm');	       
	});	

	$('#clienteID').bind('keyup',function(e) { 
		listaAlfanumerica('clienteID', '2', '13', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});		
	
	$('#clienteID').blur(function(){
		consultaCliente(this.id);
	});
	
//	------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({	
		rules: {
			institucionID: {
				required: true,				

			},
			fechaInicial: {
				date: true

			},
			fechaFinal: {
				date: true

			},
			cuentaBancaria: {
				required: true,				
			},
			clienteID: {
				required: true,
			}
			
		},		
		messages: {
			institucionID: {
				required:'Especificar Institución'				
			},
			fechaInicial: {
				date: 'Fecha Incorrecta'

			},
			fechaFinal: {
				date: 'Fecha Incorrecta'

			},
			cuentaBancaria: {
				required:'Especificar No. de Cuenta',				
			},
			clienteID: {
				required:'Especificar Cliente'
			}
		}		
	});

		
	function enviaDatosRepExcel(){
		var nombreusuario 		= $('#nombreUsuario').val();
		var nombreInstitucion	= $('#nombreInstitucion').val();
		var fechaEmision 		= $('#fechaEmision').val();	
		var fechaInicial		= $('#fechaInicial').val();
		var fechaFinal	 		= $('#fechaFinal').val();
		var sucursal			= $("#sucursalID option:selected").val();	
		var institucionID		= $('#institucionID').val();
		var cuentaBancaria		= $('#cuentaBancaria').val();
		var clienteID			= $('#clienteID').val();
		var estado				= $("#estado option:selected").val();	
		var tipoReporte			= 2;
		var tipoLista			= catFormatoReporte.excel;
		var desnombreInstitucion = $('#desnombreInstitucion').val();
		var nombreCuenta		=$('#nombreCuenta').text();
		var nombreCliente		=$('#nombreCliente').text();
		var descestado			=$("#estado option:selected").text();
		var dessucursalID		=$("#sucursalID option:selected").text();
	
			if(isNaN($("#institucionID").val())){			
				$("#institucionID").focus();
			}
			else{
				if($("#institucionID").val()==''){
					alert("La Institución está vacía");
					$("#institucionID").focus();
				}
				else{
					if($("#cuentaBancaria").val()==''){
						alert("La Cuenta Bancaria esta Vacía");
						$("#cuentaBancaria").focus();
					}
					else{
						if(institucionID=='0'){
							desinstitucionID='TODAS';			
						}
						else{
							institucionID = $('#institucionID').val();
							valorInstitucion=institucionID;
						}
						if(cuentaBancaria=='0'){
							descuentaBancaria='TODAS';
						}
						else{
							cuentaBancaria = $('#cuentaBancaria').val();
							descuentaBancaria=cuentaBancaria;
						}
						if(clienteID=='0'){
							desclienteID='TODOS';
						}
						else{
							clienteID = $("#clienteID").val();
							desclienteID ='TODOS';
						}
						if(sucursalID=='0'){
							nombreSucursal='TODAS';
						}
						
						if(estado=='0'){
							descestado='TODAS';
						}
						
						var pagina ='reporteDepositosref.htm?tipoReporte='+tipoReporte+'&nombreUsuario='+nombreusuario+'&nombreInstitucion='+
						nombreInstitucion+'&fechaInicial='+fechaInicial+'&fechaFinal='+ fechaFinal+'&fechaEmision='+fechaEmision+'&sucursalID='+sucursal+
						'&institucionID='+institucionID+'&cuentaBancaria='+cuentaBancaria+'&clienteID='+clienteID+'&estado='+estado+'&tipoLista='+tipoLista+
						'&desnombreInstitucion='+desnombreInstitucion+'&nombreCuenta='+nombreCuenta+'&nombreCliente='+nombreCliente+'&descestado='+descestado+
						'&dessucursalID='+dessucursalID+'&descuentaBancaria='+descuentaBancaria;														
						window.open(pagina,'_blank');
					}
				}
			}
		}
	
	function enviaDatosRepPDF(){
		var nombreusuario 		= $('#nombreUsuario').val();
		var nombreInstitucion	= $('#nombreInstitucion').val();
		var fechaEmision 		= $('#fechaEmision').val();	
		var fechaInicial		= $('#fechaInicial').val();
		var fechaFinal	 		= $('#fechaFinal').val();
		var sucursal			= $("#sucursalID option:selected").val();
		var institucionID		= $('#institucionID').val();
		var cuentaBancaria		= $('#cuentaBancaria').val();
		var clienteID			= $('#clienteID').val();
		var estado				= $("#estado option:selected").val();
		var tipoReporte			= 1;
		var tipoLista			= catFormatoReporte.pdf;
		var desnombreInstitucion = $('#desnombreInstitucion').val();
		var nombreCuenta		=$('#nombreCuenta').text();
		var nombreCliente		=$('#nombreCliente').text();
		var descestado			=$("#estado option:selected").text();
		var dessucursalID		=$("#sucursalID option:selected").text();
	

		if($('#fechaFinal').val()<$('#fechaInicial').val()){
			alert("La Fecha de Inicio es Mayor a la Fecha de Fin");
			$('#fechaFinal').focus();
		}else{
			if(isNaN($("#institucionID").val())){			
				$("#institucionID").focus();
			}
			else{
				if($("#institucionID").val()==''){
					alert("La Institución está vacía");
					$("#institucionID").focus();
				}
				else{
					if($("#cuentaBancaria").val()==''){
						alert("La Cuenta Bancaria esta Vacía");
						$("#cuentaBancaria").focus();
					}
					else{
						if(institucionID=='0'){
							desinstitucionID='TODAS';			
						}
						else{
							institucionID = $('#institucionID').val();
							valorInstitucion=institucionID;
						}
						if(cuentaBancaria=='0'){
							descuentaBancaria='TODAS';
						}
						else{
							cuentaBancaria = $('#cuentaBancaria').val();
							descuentaBancaria=cuentaBancaria;
						}
						if(clienteID=='0'){
							desclienteID='TODOS';
						}
						else{
							clienteID = $("#clienteID").val();
							desclienteID =clienteID;
						}
						if(sucursalID=='0'){
							nombreSucursal='TODAS';
						}
						else{
							nombreSucursal = $("#sucursalID option:selected").html();
						}
						
						if(estado=='0'){
							descestado='TODOS';
						}
						else{
							descestado= $("#estado option:selected").html();
						}
						
						var pagina ='reporteDepositosref.htm?tipoReporte='+tipoReporte+'&nombreUsuario='+nombreusuario+'&nombreInstitucion='+
						nombreInstitucion+'&fechaInicial='+fechaInicial+'&fechaFinal='+ fechaFinal+'&fechaEmision='+fechaEmision+'&sucursalID='+sucursal+
						'&institucionID='+institucionID+'&cuentaBancaria='+cuentaBancaria+'&clienteID='+clienteID+'&estado='+estado+'&tipoLista='+tipoLista+
						'&desnombreInstitucion='+desnombreInstitucion+'&nombreCuenta='+nombreCuenta+'&nombreCliente='+nombreCliente+'&descestado='+descestado+
						'&dessucursalID='+dessucursalID+'&descuentaBancaria='+descuentaBancaria+'&desclienteID='+desclienteID;														
						window.open(pagina,'_blank');
					}
				}
			}
		}
	}
		

	function cargaSucursales(){
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'TODAS'});
		sucursalesServicio.listaCombo(catTipoListaSucursal.combo, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}


//	FIN VALIDACIONES DE REPORTES

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha,fechaIni){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				if(fechaIni ==1){				
					alert("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicial').val(parametros.fechaAplicacion); 	
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaInicial').focus();

				}else{
					alert("Formato de Fecha Final Incorrecto");
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaFinal').focus();
				}
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
				if(fechaIni ==1){				
					alert("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicial').val(parametros.fechaAplicacion); 	
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaInicial').focus();

				}else{
					alert("Formato de Fecha Final Incorrecto");
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaFinal').focus();
				}

			return false;
			}
			if (dia>numDias || dia==0){
				if(fechaIni ==1){				
					alert("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicial').val(parametros.fechaAplicacion); 	
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaInicial').focus();

				}else{
					alert("Formato de Fecha Final Incorrecto");
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaFinal').focus();
				}
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
	
	   //Funcion de consulta para obtener el nombre de la institucion	
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		if(numInstituto!='' && !isNaN(numInstituto)){
				institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){		
					if(instituto!=null){							
						$('#desnombreInstitucion').val(instituto.nombre);
					}else{						
						$('#institucionID').val(0);
						$('#desnombreInstitucion').val("TODAS");
					}    						
				});
		}else{
			$('#institucionID').val('');
			$('#desnombreInstitucion').val("");
		}
	}	
	
	function consultaCliente(idControl) {	
			var jqCliente = eval("'#" + idControl + "'");
			var numCliente = $(jqCliente).val();
			setTimeout("$('#cajaLista').hide();", 200);

			if (numCliente != '' && !isNaN(numCliente) && esTab) {
				clienteServicio.consulta(1, numCliente, function(cliente) {
					if (cliente != null) {					
						$('#nombreCliente').val(cliente.nombreCompleto);			

					} else {
						$('#clienteID').val(0);
						$('#nombreCliente').val('TODOS');						
					}
				});
			}
		}
		
	

}); // Fin Document

