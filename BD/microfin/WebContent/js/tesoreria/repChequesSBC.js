var sucursalID="";
var nombreSucursal="";
var producto="";
var nombreProducto="";
var estatusCheque ="";
$(document).ready(function() {
	esTab = true;

	var catTipoConsulta = {
			'principal'	: 1		  		
	};

	var catTipoListaSucursal = {
			'combo': 2
	};
	var catTipoConsultaInstituciones = {
			'principal':1, 
			'foranea':2
	};
	parametros = consultaParametrosSession();
	$('#nombreUsuario').val(parametros.claveUsuario); // parametros del sesion para el reporte
	$('#nombreInstitucion').val(parametros.nombreInstitucion);
	$('#fechaSistema').val(parametroBean.fechaSucursal);

	// ----------------------------------- Metodos y Eventos -----------------------------
	agregaFormatoControles('formaGenerica');
	cargaSucursales();
	inicializaCampos();

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) { 

		}
	});	


	$('#clienteIDIni').bind('keyup',function(e){
		lista('clienteIDIni', '3', '1', 'nombreCompleto', 
				$('#clienteIDIni').val(), 'listaCliente.htm');
	});

	$('#clienteIDIni').blur(function() {
		consultaClienteInicial(this.id);
	});



	//----- Listas Institucion inicial y final

	$('#institucionIDIni').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		listaAlfanumerica('institucionIDIni', '1', '1', 'nombre', $('#institucionIDIni').val(), 'listaInstituciones.htm');
	});

	$('#institucionIDIni').blur(function() {		 
		consultaInstitucion(this.id);
	});


	// Cuenta Bancaria Inicio
	$('#noCuentaInstituIni').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionIDIni').val();

		camposLista[1] = "cuentaAhoID";			
		parametrosLista[1] = $('#noCuentaInstituIni').val();

		listaAlfanumerica('noCuentaInstituIni', '2', '2', camposLista, parametrosLista, 'tesoCargaMovLista.htm');	       
	});


	$('#noCuentaInstituIni').blur(function() {
		validaCuentaAhorro(this.id);
	});


	$('#pdf').click(function() {	
		$('#excel').attr("checked",false);
	});
	$('#excel').click(function() {	
		$('#pdf').attr("checked",false);
	});
	$('#generar').click(function(){		
		enviaDatosReporteChequesSBC(); 

	});

	$('#fechaInicial').change(function() {
		var fechaIni=1;
		var Xfecha= $('#fechaInicial').val();
		if(esFechaValida(Xfecha, fechaIni)){
			if(Xfecha=='')$('#fechaInicial').val(parametros.fechaAplicacion);

		}else{
			$('#fechaInicial').val(parametros.fechaAplicacion);
		}
	});

	$('#fechaFinal').change(function() {
		var fechaIni=2;
		var Yfecha= $('#fechaFinal').val();
		if(esFechaValida(Yfecha, fechaIni)){
			if(Yfecha=='')$('#fechaFinal').val(parametros.fechaAplicacion);

		}else{
			$('#fechaFinal').val(parametros.fechaAplicacion);
		}

	});
	$('#formaGenerica').validate({

		rules: {	
			fechaInicial: {
				date: true

			},
			fechaFinal: {
				date: true

			},
		},		
		messages: {		
			fechaInicial: {
				date: 'Fecha Incorrecta.',

			},
			fechaFinal: {
				date: 'Fecha Incorrecta.',

			},

		}		
	});


	function consultaClienteInicial(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente == '' || numCliente==0){
			$(jqCliente).val(0);
			$('#nombreClienteIni').val('TODOS');
		}
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteIDIni').val(cliente.numero)							
					$('#nombreClienteIni').val(cliente.nombreCompleto);
					validaClientes();
				}else{
					if(numCliente!=0){
						alert("No Existe el Cliente");
						$('#clienteIDIni').focus();
						$('#clienteIDIni').select();
						$('#clienteIDIni').val(0);
						$('#nombreClienteIni').val("TODOS");

					}
				}    	 						
			});
		}
	}



//	Consulta Institucion
	function consultaInstitucion(idControl) {

		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		var cuenta = $('#noCuentaInstituIni').val();

		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
				'institucionID':numInstituto
		};
		if (numInstituto=='0' || $(jqInstituto).val()==''){
			$('#nombInstitucionIni').val('TODOS');
			$('#institucionIDIni').val(0);
			if(cuenta != ''){
				validaCuentaAhorro();
			} 
		}
		else{
			if(numInstituto != '' && !isNaN(numInstituto) ){
				institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
					if(instituto!=null){							
						$('#nombInstitucionIni').val(instituto.nombre);
						validaInstitucion();
						if(cuenta != ''){
							validaCuentaAhorro();
						}
					}else{
						alert("No existe la Institución"); 
						$('#nombInstitucionIni').val('TODOS');
						$('#institucionIDIni').val(0);
						$('#institucionIDIni').focus();
						$('#institucionIDIni').select();
						$('#nombreCuenta').val('TODOS');
						$('#noCuentaInstituIni').val(0);
						if(cuenta != ''){
							validaCuentaAhorro();
						}
					}    						
				});
			}
		}

	}



	function validaCuentaAhorro(idControl){

		var tipoConsulta = 9;
		var institucion=$('#institucionIDIni').val();
		var jsCuenta = eval("'#" + idControl + "'");
		var cuenta=$(jsCuenta).val();

		if(institucion=='')institucion=0;


		if(cuenta != '' && !isNaN(cuenta)  ){
			setTimeout("$('#cajaLista').hide();", 200);	
			var DispersionBeanCta = {
					'institucionID': institucion,
					'numCtaInstit': cuenta
			};

			if (cuenta=='0' || cuenta=='' ){
				$('#nombreCuenta').val("TODOS");
				$('#noCuentaInstituIni').val(0);
			}
			else{

				operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
					if(data!=null){

						$('#nombreCuenta').val(data.nombreCuentaInst);

					}else{
						alert("No existe el numero de Cuenta.");
						$('#nombreCuenta').val('TODOS');
						$('#noCuentaInstituIni').val(0);
						if($('#institucionIDIni').val()!=''){
							$('#noCuentaInstituIni').focus();
							$('#noCuentaInstituIni').select();
						}
					}
				});
			}
		}

	}



	function validaClientes(){

	}

	function validaInstitucion(){

	}

	function cargaSucursales(){
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'TODOS'});
		sucursalesServicio.listaCombo(catTipoListaSucursal.combo, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}

	function enviaDatosReporteChequesSBC(){
		var tipoRep = "";
		sucursalID		= $("#sucursalID option:selected").val();
		nombreSucursal		= $("#sucursalID option:selected").val();
		estatusCheque = $("#estatusCheque option:selected").val();
		var fechaIni=$('#fechaInicial').val();
		var fechaFin=$('#fechaFinal').val();

		if($('#clienteIDIni')==""){
			$('#clienteIDIni').val(0);
			$('#nombreClienteIni').val('TODOS');
		}

		if($('#institucionIDIni').val()==""){
			$('#nombInstitucionIni').val('TODOS');
			$('#institucionIDIni').val(0);
			$('#nombreCuenta').val('TODOS');
			$('#noCuentaInstituIni').val(0);
		}
		
		if($('#noCuentaInstituIni').val()==""){
			$('#nombreCuenta').val('TODOS');
			$('#noCuentaInstituIni').val(0);
		}

		if(estatusCheque ==0){
			estatusCheque ='';
		}

		if(sucursalID=='0'){
			nombreSucursal='TODOS';
		}
		else{
			nombreSucursal = $("#sucursalID option:selected").html();
		}

		if(fechaFin < fechaIni){
			alert("La Fecha Final no debe ser menor que la Fecha Inicial");
			$('#fechaFinal').focus();

		}else{
			if($('#excel').attr("checked")==false && $('#pdf').attr("checked")==false){
				alert("No ha seleccionado Ninguna Opción Para la Presentación del Reporte");
			}
			else{

				if($('#excel').is(':checked')){
					tipoRep = 2;
					imprimir(tipoRep);

				}
				if($('#pdf').is(':checked')){
					tipoRep = 1;
					imprimir(tipoRep);
				}
			}
		}
	}

	function imprimir(tipoReporte){

		var clienteIni=$('#clienteIDIni').val();
		var nombreClienteIni =$('#nombreClienteIni').val();
		var nombreCuenta=$('#nombreCuenta').val();
		var noCuentaInstituIni=$('#noCuentaInstituIni').val();
		var nombInstitucionIni=$('#nombInstitucionIni').val();
		var institucionIDIni=$('#institucionIDIni').val();
		var fechaIni=$('#fechaInicial').val();
		var fechaFin=$('#fechaFinal').val();


		var pagina ='repChequesSBCPDF.htm?clienteIDIni='+clienteIni+
		'&nombreInstitucion='+$('#nombreInstitucion').val()+'&tipoReporte='+tipoReporte
		+'&nombreUsuario='+$('#nombreUsuario').val()+'&fechaSistema='+$('#fechaSistema').val()+'&nombreClienteIni='+
		nombreClienteIni+'&sucursalID='+sucursalID+'&nombreSucursal='+
		nombreSucursal+'&estatusCheque='+estatusCheque+'&institucionIDIni='+institucionIDIni+'&nombInstitucionIni='+nombInstitucionIni+
		'&noCuentaInstituIni='+noCuentaInstituIni +'&fechaInicial='+fechaIni+'&fechaFinal='+fechaFin;
		window.open(pagina,'_blank');
	}

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

	function inicializaCampos(){	
		$('#clienteIDIni').val(0);
		$('#nombreClienteIni').val('TODOS');		
		$('#nombreCuenta').val('TODOS');
		$('#noCuentaInstituIni').val(0);		
		$('#nombInstitucionIni').val('TODOS');
		$('#institucionIDIni').val(0);
		$('#fechaInicial').val(parametros.fechaAplicacion);
		$('#fechaFinal').val(parametros.fechaAplicacion);

	}
});