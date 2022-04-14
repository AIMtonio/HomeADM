var sucursalID="";
var nombreSucursal="";

var estatusCheque ="";
$(document).ready(function() {
	esTab = true;
	parametros = consultaParametrosSession();

	var catTipoConsulta = {
			'principal'	: 1		  		
	};

	var catTipoListaSucursal = {
			'principal' :1,
			'combo': 2
	};
	var catTipoConsultaInstituciones = {
			'principal':1, 
			'foranea':2
	};

	// ----------------------------------- Metodos y Eventos -----------------------------
	agregaFormatoControles('formaGenerica');
	inicializaCampos();
	$('#fechaInicioEmision').focus();

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


	//----- Listas Institucion inicial y final

	$('#institucionBancaria').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		listaAlfanumerica('institucionBancaria', '1', '1', 'nombre', $('#institucionBancaria').val(), 'listaInstituciones.htm');
	});

	$('#institucionBancaria').blur(function() {		 
		consultaInstitucion(this.id);
	});
	
	$('#numeroCuentaBancaria').blur(function() {
		validaCuentaAhorro(this.id);
	});

	$('#sucursalID').bind('keyup',function(e){
		lista(this.id,'2',catTipoListaSucursal.principal,'nombreSucurs',$('#sucursalID').val(),'listaSucursales.htm');
	});
	
	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});

	$('#numeroCuentaBancaria').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionBancaria').val();

		camposLista[1] = "cuentaAhoID";			
		parametrosLista[1] = $('#numeroCuentaBancaria').val();

		listaAlfanumerica('numeroCuentaBancaria', '2', '2', camposLista, parametrosLista, 'tesoCargaMovLista.htm');	       
	});

	// Consultanto cheques emitidos
	$('#numeroCheque').bind('keyup',function(e){
		var camposLista = new Array();
		camposLista[0] = "beneficiarioCan"; 
		camposLista[1] = "institucionIDCan"; 
		camposLista[2] = "numCtaBancariaCan";
		camposLista[3] = "sucursalID"; 
		camposLista[4] = "fechaInicio"; 
		camposLista[5] = "fechaFinal"; 
		camposLista[6] = "tipoChequera"; 

		var parametrosLista = new Array();
		parametrosLista[0] = $('#numeroCheque').val();	
		parametrosLista[1] = $('#institucionBancaria').val()==''?0:$('#institucionBancaria').val();
		parametrosLista[2] = $('#numeroCuentaBancaria').val()==''?0:$('#numeroCuentaBancaria').val();
		parametrosLista[3] = $('#sucursalID').val()==''?0:$('#sucursalID').val();	
		parametrosLista[4] = $('#fechaInicioEmision').val();
		parametrosLista[5] = $('#fechaFinalEmision').val();	
		parametrosLista[6] = $('#tipoChequera').val();	
	
		lista('numeroCheque', '2', '5',  camposLista, parametrosLista, 'listaChequesEmitidos.htm');
	});
	
	$('#numeroCheque').blur(function(e){
		setTimeout("$('#cajaLista').hide();", 200);	
	});
	
	
	$('#generar').click(function(){
		imprimir();
	});

	$('#fechaInicioEmision').change(function() {
		var Xfecha= $('#fechaInicioEmision').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicioEmision').val(parametros.fechaAplicacion);
			}
			var Yfecha= $('#fechaFinalEmision').val();
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicioEmision').val(parametros.fechaAplicacion);
			}else{
				if($('#fechaInicioEmision').val() > parametros.fechaAplicacion) {
					mensajeSis("La Fecha de Inicio es Mayor a la Fecha del Sistema.");
					$('#fechaInicioEmision').val(parametros.fechaAplicacion);
				}
			}

		}else{
			$('#fechaInicioEmision').val(parametros.fechaAplicacion);
		}
	});

	$('#fechaFinalEmision').change(function() {
		var Xfecha= $('#fechaInicioEmision').val();
		var Yfecha= $('#fechaFinalEmision').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha==''){
				$('#fechaFinalEmision').val(parametros.fechaAplicacion);
			}
			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFinalEmision').val(parametros.fechaSucursal);
			}else{
				if($('#fechaFinalEmision').val() > parametros.fechaAplicacion) {
					mensajeSis("La Fecha de Fin  es Mayor a la Fecha del Sistema.");
					$('#fechaFinalEmision').val(parametros.fechaAplicacion);
				}				
			}

		}else{
			$('#fechaFinalEmision').val(parametros.fechaAplicacion);
		}

	});
	$('#formaGenerica').validate({

		rules: {	
			fechaInicioEmision: {
				date: true

			},
			fechaFinalEmision: {
				date: true

			},
		},		
		messages: {		
			fechaInicioEmision: {
				date: 'Fecha Incorrecta.',

			},
			fechaFinal: {
				date: 'Fecha Incorrecta.',

			},
		}		
	});
//	Consulta Institucion
	function consultaInstitucion(idControl) {

		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		var cuenta = $('#numeroCuentaBancaria').val();

		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
				'institucionID':numInstituto
		};
		if (numInstituto=='0' || $(jqInstituto).val()==''){
			$('#nombInstitucionIni').val('TODOS');
			$('#institucionBancaria').val(0);
			if(cuenta != ''){
			} 
		}
		else{
			if(numInstituto != '' && !isNaN(numInstituto) ){
				institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
					if(instituto!=null){							
						$('#nombInstitucionIni').val(instituto.nombre);
						if(cuenta != ''){
						}
					}else{
						mensajeSis("No existe la Institución"); 
						$('#nombInstitucionIni').val('TODOS');
						$('#institucionBancaria').val(0);
						$('#institucionBancaria').focus();
						$('#institucionBancaria').select();
						$('#nombreCuenta').val('TODOS');
						$('#numeroCuentaBancaria').val(0);
						if(cuenta != ''){
						}
					}    						
				});
			}
		}

	}

	function consultaSucursal(idControl){
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).asNumber();
		var conSucursal=2;
		setTimeout("$('#cajaLista').hide();", 200);		 
		if(numSucursal > 0 && esTab==true){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal.toString(),function(sucursal) {
				if(sucursal!=null){
					$('#nombreSucursal').val(sucursal.nombreSucurs);
				}else{
					mensajeSis("No Existe la Sucursal.");
					$(jqSucursal).focus();
					$(jqSucursal).val("0");
					$('#nombreSucursal').val("TODOS");
				}
			});
		}else{
			$(jqSucursal).val("0");
			$('#nombreSucursal').val("TODOS");
		}
	}

	function imprimir(){
		var fechaIni=$('#fechaInicioEmision').val();
		var fechaFin=$('#fechaFinalEmision').val();
		var institucionBancaria=$('#institucionBancaria').val();
		var nombInstitucionIni = $('#nombInstitucionIni').val();
		var numeroCuentaBancaria=$('#numeroCuentaBancaria').val();
		var	tipoChequera=$('#tipoChequera').val();
		var numeroCheque=$('#numeroCheque').val();
		var estatus=$('#estatus').val();
		var sucursalEmision=$('#sucursalID').val();
		var nomSucursalEmision=$('#nombreSucursal').val();
		var fechaHora = $('#fechaInicioEmision').val();
		var seguir=true;
		if(fechaFin < fechaIni){
			mensajeSis("La Fecha Final de Emisión no debe ser menor que la Fecha Inicial de Emisión");
			$('#fechaFinalEmision').focus();
			seguir=false;
		}
		if(tipoChequera == ""){
			mensajeSis("Elegir el Tipo de Chequera para el Reporte.");
			$('#tipoChequera').focus();
			seguir=false;
		}
		if(seguir){
		var pagina ='RepChequesEmision.htm?fechaInicioEmision='+fechaIni+
		'&fechaFinalEmision='+fechaFin+
		'&institucionBancaria='+institucionBancaria+
		'&nombreInstitucionBancaria='+nombInstitucionIni+
		'&numeroCuentaBancaria='+numeroCuentaBancaria+
		'&tipoChequera='+tipoChequera+
		'&numeroCheque='+numeroCheque+
		'&estatus='+estatus+
		'&sucursalEmision='+sucursalEmision+
		'&nombreSucursalEmision='+nomSucursalEmision+
		'&fechaSistema='+fechaHora;
		window.open(pagina,'_blank');
		}
	}

	  /*=== Validaciones para la forma ====  */
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
	
	/*==== Funcion valida fecha formato (yyyy-MM-dd) =====*/
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
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
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


	function inicializaCampos(){	
		$('#institucionBancaria').val('0');
		$('#numeroCuentaBancaria').val('0');
		$('#tipoChequera').val('A');
		$('#sucursalID').val('0');
		$('#numeroCheque').val('0');
		$('#estatus').val('T');	
		$('#nombreCuenta').val('TODOS');
		$('#nombInstitucionIni').val('TODOS');
		$('#nombreSucursal').val('TODAS');
		$('#fechaInicioEmision').val(parametros.fechaAplicacion);
		$('#fechaFinalEmision').val(parametros.fechaAplicacion);
	}
	 function hora(){	
		 var Digital=new Date();
		 var hours=Digital.getHours();
		 var minutes=Digital.getMinutes();
		 var seconds=Digital.getSeconds();
		 if (minutes<=9)
		 minutes="0"+minutes;
		 if (seconds<=9)
		 seconds="0"+seconds;
		return  hours+":"+minutes;
	 }
	 
	 function validaCuentaAhorro(idControl){
			var tipoConsulta = 9;
			var institucion=$('#institucionBancaria').val();
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
					$('#numeroCuentaBancaria').val(0);
				}
				else{

					operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
						if(data!=null){
							$('#nombreCuenta').val(data.nombreCuentaInst);

						}else{
							$('#nombreCuenta').val('TODOS');
							$('#numeroCuentaBancaria').val(0);
						}
					});
				}
			}

		}
});