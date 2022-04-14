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
	var catTipoReporte ={
			'PDF':1
	};
	// ----------------------------------- Metodos y Eventos -----------------------------
	agregaFormatoControles('formaGenerica');
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

	$('#fechaInicioEmision').focus();
	//----- Listas Institucion inicial y final

	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		listaAlfanumerica('institucionID', '1', catTipoConsultaInstituciones.principal, 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#institucionID').blur(function() {		 
		consultaInstitucion(this.id);
	});
	
	$('#numCtaInstit').blur(function() {
		validaCuentaAhorro(this.id);
	});

	$('#sucursalID').bind('keyup',function(e){
		lista(this.id,'2',catTipoListaSucursal.principal,'nombreSucurs',$('#sucursalID').val(),'listaSucursales.htm');
	});
	
	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});

	$('#numCtaInstit').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionID').val();

		camposLista[1] = "cuentaAhoID";			
		parametrosLista[1] = $('#numCtaInstit').val();

		listaAlfanumerica('numCtaInstit', '2', '2', camposLista, parametrosLista, 'tesoCargaMovLista.htm');	       
	});

	// Consultanto cheques emitidos
	$('#numeroCheque').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "numeroCheque"; //DONDE MOSTRAR RESULTADO

		parametrosLista[0] = $('#institucionID').val()==''?0:$('#institucionID').val();//FILTROS
		parametrosLista[1] = $('#numCtaInstit').val()==''?0:$('#numCtaInstit').val();
		parametrosLista[2] = $('#numeroCheque').val();		
	
		lista('numeroCheque', '2', '5',  camposLista, parametrosLista, 'listaChequesEmitidos.htm');
	});
	
	
	$('#generar').click(function(){
		imprimir();
	});

	$('#fechaInicioEmision').change(function() {
		var fechaIni=1;
		var Xfecha= $('#fechaInicioEmision').val();
		if(esFechaValida(Xfecha, fechaIni)){
			if(Xfecha=='')$('#fechaInicioEmision').val(parametros.fechaAplicacion);

		}else{
			$('#fechaInicioEmision').val(parametros.fechaAplicacion);
		}
	});

	$('#fechaFinalEmision').change(function() {
		var fechaIni=2;
		var Yfecha= $('#fechaFinalEmision').val();
		if(esFechaValida(Yfecha, fechaIni)){
			if(Yfecha=='')$('#fechaFinalEmision').val(parametros.fechaAplicacion);

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
		var cuenta = $('#numCtaInstit').val();

		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
				'institucionID':numInstituto
		};
		if (numInstituto=='0' || $(jqInstituto).val()==''){
			$('#nombInstitucionIni').val('TODOS');
			$('#institucionID').val(0);
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
						alert("No existe la Institución"); 
						$('#nombInstitucionIni').val('TODOS');
						$('#institucionID').val(0);
						$('#institucionID').focus();
						$('#institucionID').select();
						$('#nombreCuenta').val('TODOS');
						$('#numCtaInstit').val(0);
						if(cuenta != ''){
							//validaCuentaAhorro();
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
					alert("No Existe la Sucursal.");
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
		var institucionID=$('#institucionID').val();
		var nombInstitucionIni = $('#nombInstitucionIni').val();
		var numCtaInstit=$('#numCtaInstit').val();
		var	tipoChequera=$('#tipoChequera').val();
		var sucursalID=$('#sucursalID').val();
		var nombreSucursal=$('#nombreSucursal').val();
		var fechaHora = $('#fechaInicioEmision').val();
		var seguir=true;
		var tipoReporte = catTipoReporte.PDF;
		if(fechaFin < fechaIni){
			alert("La Fecha Final de Dotación no debe ser menor que la Fecha Inicial de Dotación.");
			$('#fechaFinalEmision').focus();
			seguir=false;
		}
		if(seguir){
			var pagina ='ReporteChequesAsignados.htm?fechaInicioEmision='+fechaIni+
			'&fechaFinalEmision='+fechaFin+
			'&institucionID='+institucionID+
			'&nombreInstitucionBancaria='+nombInstitucionIni+
			'&numCtaInstit='+numCtaInstit+
			'&tipoChequera='+tipoChequera+
			'&sucursalID='+sucursalID+
			'&nombreSucursal='+nombreSucursal+
			'&fechaSistema='+fechaHora+
			'&tipoReporte='+tipoReporte;
			window.open(pagina,'_blank');
		}
	}

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha,fechaIni){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				if(fechaIni ==1){				
					alert("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicioEmision').val(parametros.fechaAplicacion); 	
					$('#fechaFinalEmision').val(parametros.fechaAplicacion);
					$('#fechaInicioEmision').focus();

				}else{
					alert("Formato de Fecha Final Incorrecto");
					$('#fechaFinalEmision').val(parametros.fechaAplicacion);
					$('#fechaFinalEmision').focus();
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
					$('#fechaInicioEmision').val(parametros.fechaAplicacion); 	
					$('#fechaFinalEmision').val(parametros.fechaAplicacion);
					$('#fechaInicioEmision').focus();

				}else{
					alert("Formato de Fecha Final Incorrecto");
					$('#fechaFinalEmision').val(parametros.fechaAplicacion);
					$('#fechaFinalEmision').focus();
				}

			return false;
			}
			if (dia>numDias || dia==0){
				if(fechaIni ==1){				
					alert("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicioEmision').val(parametros.fechaAplicacion); 	
					$('#fechaFinalEmision').val(parametros.fechaAplicacion);
					$('#fechaInicioEmision').focus();

				}else{
					alert("Formato de Fecha Final Incorrecto");
					$('#fechaFinalEmision').val(parametros.fechaAplicacion);
					$('#fechaFinalEmision').focus();
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
		$('#institucionID').val('0');
		$('#numCtaInstit').val('0');
		$('#sucursalID').val('0');
		$('#nombreCuenta').val('TODOS');
		$('#nombInstitucionIni').val('TODOS');
		$('#tipoChequera').val('A');
		$('#nombreSucursal').val('TODOS');
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
			var institucion=$('#institucionID').val();
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
					$('#numCtaInstit').val(0);
				}
				else{

					operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
						if(data!=null){
							$('#nombreCuenta').val(data.nombreCuentaInst);

						}else{
							$('#nombreCuenta').val('TODOS');
							$('#numCtaInstit').val(0);
						}
					});
				}
			}

		}
});