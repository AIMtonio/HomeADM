var tipoFecha="";
var tipoPerido="";
var gerenteGeneral="";
var presidenteConsejo="";
var jefeContabilidad="";
var directorFinanzas="";
var ban=0;
var error=0;
var permiteExcel = "N";
$(document).ready(function (){

	var ejecucionBalanzaContable = 'N';
	var userEjecucionBalanzaContable = '';

	esTab = true;
	parametros = consultaParametrosSession();

	var ban=0;
	var catTipoConsultaCentro = {
  	'principal'	: 1,
  	'foranea'	: 2
	};

	// Definicion de Constantes y Enums
	consultaEjercicio();
	consultaTipoReporteFinan();
	muestraBotonExcel();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$('#fecha').val(parametros.fechaSucursal);
	$('#finEjercicio').attr("disabled", true);
	$('#descripcionI').attr("disabled", true);
	$('#descripcionF').attr("disabled", true);

	$(':text').focus(function() {
		esTab = false;
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#numeroEjercicio').blur(function() {
		esTab = true;
		consultaEjercicioFecha();

	});

	$('#numeroPeriodo').blur(function() {
		consultaPeriodosFecha();
	});

	$('#estadoFinanID').blur(function() {

	});


	$('#tipoBalanza').change(function(){
		if($(this).val()!=3){
			deshabilitaControl('finPeriodo2');
			habilitaControl('numeroEjercicio');
			habilitaControl('finEjercicio');
			habilitaControl('numeroPeriodo');
		}else{
			habilitaControl('finPeriodo2');
			deshabilitaControl('numeroEjercicio');
			deshabilitaControl('finEjercicio');
			deshabilitaControl('numeroPeriodo');
		}
	});


	$('#tipoConsulta').click(function() {
		$('#tipoConsulta2').attr("checked",false);
		$('#numeroEjercicio').attr("disabled",true);
		$('#numeroPeriodo').attr("disabled", true);
		$('#numeroEjercicio').val(1);
		$('#finEjercicio').val("");
		if($('#tipoConsulta').is(':checked')){
			$('#fecha').attr("disabled", false);
			$('#fecha').focus();
			$('#fecha').val(parametros.fechaSucursal);
			$(".ui-datepicker-trigger").show();
			$("#numeroPeriodo").val(37);
		}

	});



	$('#tipoConsulta2').click(function() {
		$('#tipoConsulta').attr("checked",false);
		$('#fecha').attr("disabled",true);
		if($('#tipoConsulta2').is(':checked')){
			$('#numeroEjercicio').attr("disabled",false);
			$('#numeroPeriodo').attr("disabled",false);
			$('#numeroEjercicio').focus();
			$(".ui-datepicker-trigger").hide();
			$('#fecha').val("");
		}
	});


	$('#cifras').click(function() {
		$('#cifras2').attr("checked",false);
		if($('#cifras').is(':checked')){
			$('#cifras2').focus();
		}
	});

	$('#cifras2').click(function() {
		$('#cifras').attr("checked",false);
		if($('#cifras2').is(':checked')){
			$('#pantalla').focus();
		}
	});

	$('#pantalla').click(function() {
		$('#pdf').attr("checked",false);
		$('#excel').attr("checked",false);
		if($('#pantalla').is(':checked')){
			$('#pdf').focus();
		}
	});

	$('#pdf').click(function() {
		$('#pantalla').attr("checked",false);
		$('#excel').attr("checked",false);
		if($('#pdf').is(':checked')){
			$('#excel').focus();
		}
	});

	$('#excel').click(function() {
		$('#pantalla').attr("checked",false);
		$('#pdf').attr("checked",false);
		if($('#excel').is(':checked')){
			$('#generar').focus();
		}
	});


	$('#generar').click(function() {
		validaCentroCostos(this.id);
		if(error == 0){
		enviarDatosReporte1();
		}
	});

	$('#fecha').change(function() {
		var Xfecha= $('#fecha').val();
		if($("#tipoConsulta").is(':checked')) {
			if(esFechaValida(Xfecha)){
				if(Xfecha==''){
					$('#fecha').val(parametros.fechaSucursal);
					$('#cifras').focus();
				}
				else{
					var Yfecha= parametros.fechaAplicacion;
					if(mayor(Xfecha, Yfecha)){
						mensajeSis("La Fecha es Mayor a la Fecha del Sistema")	;
						$('#fecha').val(parametros.fechaSucursal);
						$('#fecha').focus();
					}else{
						if($('#tipoConsulta').attr('checked')==true) {
							consultarFechaEnPeriodosCerrados();
						}
						$('#fecha').focus();
					}
				}
			}
        }else{
			$('#fecha').val("");
		}

	});

	$('#ccinicial').bind('keyup',function(e){
			lista('ccinicial', '2', '1', 'descripcion', $('#ccinicial').val(), 'listaCentroCostos.htm');
		});
	$('#ccinicial').blur(function() {
  	  		consultaCentroCostos('I');

	});
	$('#ccfinal').bind('keyup',function(e){
			lista('ccfinal', '2', '1', 'descripcion', $('#ccfinal').val(), 'listaCentroCostos.htm');
		});
	$('#ccfinal').blur(function() {
  		consultaCentroCostos('F');
	});
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {


			fecha: {
				date: true
			}
		},
		messages: {

			fecha: {
				date : 'Fecha Incorrecta'
			}
		}
	});

//	---------- Funcion para enviar los datos al reporte-------------
	function enviarDatosReporte1(){
		var tipoReporte = 0;
		var tipoLista = 0;
		var tipoConsulta ="";
		var fecha = '1900-01-01';
		var fechaFin ='1900-01-01';
		var ejercicio =$('#numeroEjercicio').val();
		var periodo = $('#numeroPeriodo').val();
		var finPeriodo=$('#finPeriodo').val();
		var cifras ='';
		var nombreUsuario=parametros.nombreUsuario;
		var nombreInstitucion=parametros.nombreInstitucion;
		var fechaSistema=parametros.fechaSucursal;
		var rfc =parametros.rfcInst;
		var DirecInstitucion =parametros.direccionInstitucion;
		var balanceContable = "1";
		var estadoResultados = "2";
		var estadoFlujoEfec = "4";
		var estadoVariacion = "5";
		var estadoResultadosMes= "6";
		var estadoFinanID   = $('#estadoFinanID').val();
		var ccInicial =$('#ccinicial').val();
		var ccFinal=$('#ccfinal').val();
		var ccInicialDes=$('#descripcionI').val();
		var ccFinalDes=$('#descripcionF').val();

		gerenteGeneral=parametros.gerenteGeneral;
		presidenteConsejo=parametros.presidenteConsejo;
		jefeContabilidad=parametros.jefeContabilidad;
		directorFinanzas= parametros.directorFinanzas;
		validaEjecucionBalanzaContable();

		if( ejecucionBalanzaContable != 'N'){
			var mensaje = "Existe una Ejecución de la Balanza Contable en el Sistema, la cual fue solicitada por el usuario: "+ userEjecucionBalanzaContable+". Favor de Intentar mas Tarde.";
			if(userEjecucionBalanzaContable == ''){
				mensaje = "Existe una Ejecución de la Balanza Contable en el Sistema. Favor de Intentar mas Tarde.";
			}
			mensajeSis(mensaje);
			return ;
		}

		if($('#tipoConsulta').attr('checked')==true ){
			tipoConsulta="D";
		}
		else{
			if($('#tipoConsulta2').attr('checked')==true ){
				tipoConsulta="P";
			}
		}

		if($('#tipoConsulta').attr('checked')==false && $('#tipoConsulta2').attr('checked')==false ){
			mensajeSis("No ha seleccionado Ninguna Opción de Consulta Balanza");
		}else{
			 if(ccFinal != '' && ccFinalDes != '')
					if(ccInicial == '' ){
						mensajeSis('Favor de Especificar el Centro de Costos Inicial');
						$('#ccinicial').focus();
						ban++;
					}

				if(ccInicial != '' && ccInicialDes != '')
					if(ccFinal == '' ){
						mensajeSis('Favor de Especificar el Centro de Costos Final');
						$('#ccfinal').focus();
						ban++;
					}
			 if(ccInicial!='' && ccInicialDes!='' && ccFinal!='' && ccFinalDes!='' ){
					ccInicialDes='';
					ccInicialDes= ' '+$('#ccinicial').val()+' - '+$('#descripcionI').val();
					ccFinalDes='';
					ccFinalDes= ' '+$('#ccfinal').val()+' - '+$('#descripcionF').val();


					}else{
						ccInicial='0';
						ccFinal='0';
						ccInicialDes='TODOS';
						ccFinalDes='TODOS';


					}
			if($('#tipoConsulta').attr('checked')==true){
				tipoConsulta="D";
				ejercicio=$('#numeroEjercicio').val('');
				periodo=$('#numeroPeriodo').val('');
				$('#finEjercicio').val('');
				$('#finPeriodo').val('');
				ejercicio=0;
				periodo=0;


				if($('#fecha').val() ==0){
					mensajeSis("La fecha esta vacia");
					$('#fecha').focus();
					$('#fecha').select();
					event.preventDefault();
				}else{
					fecha = $('#fecha').val();


					if($('#cifras').attr('checked')==false && $('#cifras2').attr('checked')==false){
						mensajeSis("No ha seleccionado Ninguna Opción de Cifras");
					}
					else{
						if($('#cifras').is(':checked')){
							cifras = $('#cifras').val();
						}

						if($('#cifras2').is(':checked')){
							cifras = $('#cifras2').val();
						}
						if($('#pantalla').attr('checked')==false && $('#pdf').attr('checked')==false && $('#excel').attr('checked')==false ){
							mensajeSis("No ha seleccionado Ninguna Opción Para la Presentación del Reporte");
						}
						else{
							if($('#pantalla').is(':checked')){
								tipoReporte = 1;

							}
							if($('#pdf').is(':checked')){
								tipoReporte = 2;
							}
							if($('#excel').is(':checked')){
								tipoReporte = 3;
							}
							if($('#cifras').is(':checked')){
								cifras = $('#cifras').val();
							}

							if($('#cifras2').is(':checked')){
								cifras = $('#cifras2').val();
							}

							if($('#tipoConsulta').is(':checked')){
								tipoConsulta=$('#tipoConsulta').val();
							}

							if($('#tipoConsulta2').is(':checked')){
								tipoConsulta=$('#tipoConsulta2').val();
							}

							if($('#estadoFinanID').val()== balanceContable){
								var pagina='repFinancieroPDF.htm?ejercicio='+ejercicio+'&periodo='+periodo+'&fecha='+fecha
								+'&fechaFin='+fechaFin+'&tipoConsulta='+tipoConsulta
								+'&cifras='+cifras+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+'&usuario='+
								nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaSistema='+fechaSistema+'&rfc='+rfc
								+'&DirecInstitucion='+DirecInstitucion+'&estadoFinanID='+estadoFinanID
								+'&gerenteGeneral='+gerenteGeneral+'&presidenteConsejo='+presidenteConsejo+'&jefeContabilidad='+ jefeContabilidad
								+'&directorFinanzas='+directorFinanzas+ '&ccInicial='+ccInicial+'&ccFinal='+ccFinal+ '&ccInicialDes='+ccInicialDes+'&ccFinalDes='+ccFinalDes;
								window.open(pagina,'_blank');
							}
							if($('#estadoFinanID').val()== estadoResultados){
								var pagina='repEstadoResulFinancieroPDF.htm?ejercicio='+ejercicio+'&periodo='+periodo+'&fecha='+fecha
								+'&fechaFin='+fechaFin+'&tipoConsulta='+tipoConsulta
								+'&cifras='+cifras+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+'&usuario='+
								nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaSistema='+fechaSistema+'&rfc='+rfc
								+'&DirecInstitucion='+DirecInstitucion+'&estadoFinanID='+estadoFinanID
								+'&gerenteGeneral='+gerenteGeneral+'&presidenteConsejo='+presidenteConsejo+'&jefeContabilidad='+ jefeContabilidad
								+'&directorFinanzas='+directorFinanzas+ '&ccInicial='+ccInicial+'&ccFinal='+ccFinal+ '&ccInicialDes='+ccInicialDes+'&ccFinalDes='+ccFinalDes;
								window.open(pagina,'_blank');

							}

							if($('#estadoFinanID').val()== estadoResultadosMes){
								var pagina='repEstadoResulFinancieroPDF.htm?ejercicio='+ejercicio+'&periodo='+periodo+'&fecha='+fecha
								+'&fechaFin='+fechaFin+'&tipoConsulta='+"X"
								+'&cifras='+cifras+'&tipoReporte='+tipoReporte+'&tipoLista='+2+'&usuario='+
								nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaSistema='+fechaSistema+'&rfc='+rfc
								+'&DirecInstitucion='+DirecInstitucion+'&estadoFinanID='+estadoFinanID
								+'&gerenteGeneral='+gerenteGeneral+'&presidenteConsejo='+presidenteConsejo+'&jefeContabilidad='+ jefeContabilidad
								+'&directorFinanzas='+directorFinanzas+'&ccInicial='+ccInicial+'&ccFinal='+ccFinal+ '&ccInicialDes='+ccInicialDes+'&ccFinalDes='+ccFinalDes;
								window.open(pagina,'_blank');

							}
							if($('#estadoFinanID').val()== estadoFlujoEfec){
								var pagina='repFlujosEfectivoPDF.htm?ejercicio='+ejercicio+'&periodo='+periodo+'&fecha='+fecha
								+'&fechaFin='+fechaFin+'&tipoConsulta='+tipoConsulta
								+'&cifras='+cifras+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+'&usuario='+
								nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaSistema='+fechaSistema+'&rfc='+rfc
								+'&DirecInstitucion='+DirecInstitucion+'&estadoFinanID='+estadoFinanID
								+'&gerenteGeneral='+gerenteGeneral+'&presidenteConsejo='+presidenteConsejo+'&jefeContabilidad='+ jefeContabilidad
								+'&directorFinanzas='+directorFinanzas+ '&ccInicial='+ccInicial+'&ccFinal='+ccFinal+ '&ccInicialDes='+ccInicialDes+'&ccFinalDes='+ccFinalDes;
								window.open(pagina,'_blank');

							}
							if($('#estadoFinanID').val()== estadoVariacion){
								var pagina='repEstadoVariacionesPDF.htm?ejercicio='+ejercicio+'&periodo='+periodo+'&fecha='+fecha
								+'&fechaFin='+fechaFin+'&tipoConsulta='+tipoConsulta
								+'&cifras='+cifras+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+'&usuario='+
								nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaSistema='+fechaSistema+'&rfc='+rfc
								+'&DirecInstitucion='+DirecInstitucion+'&estadoFinanID='+estadoFinanID
								+'&gerenteGeneral='+gerenteGeneral+'&presidenteConsejo='+presidenteConsejo+'&jefeContabilidad='+ jefeContabilidad
								+'&directorFinanzas='+directorFinanzas+ '&ccInicial='+ccInicial+'&ccFinal='+ccFinal+ '&ccInicialDes='+ccInicialDes+'&ccFinalDes='+ccFinalDes;
								window.open(pagina,'_blank');

							}

						}
					}
				}
			}	else{
				if($('#tipoConsulta2').attr('checked')==true){
					tipoConsulta="P";
					if($('#numeroEjercicio').val()== 0){
						mensajeSis("La ejercicio esta vacio");
						event.preventDefault();

					}else{
						ejercicio	 = $('#numeroEjercicio').val();

						if($('#numeroPeriodo').val()== ''){
							mensajeSis("El periodo esta vacio");
							event.preventDefault();

						}
						else{


							fecha = $('#finEjercicio').val();
							fechaFin = $('#inicioEjercicio').val();
							if($('#cifras').attr('checked')==false && $('#cifras2').attr('checked')==false){
								mensajeSis("No ha seleccionado Ninguna Opción de Cifras");
							}
							else{
								if($('#cifras').is(':checked')){
									cifras = $('#cifras').val();
								}

								if($('#cifras2').is(':checked')){
									cifras = $('#cifras2').val();
								}
								if($('#pantalla').attr('checked')==false && $('#pdf').attr('checked')==false &&
									(permiteExcel="S" && $('#excel').attr('checked')==false)
								){
									mensajeSis("No ha seleccionado Ninguna Opción Para la Presentación del Reporte");
								}
								else{
									if($('#pantalla').is(':checked')){
										tipoReporte = 1;

									}
									if($('#pdf').is(':checked')){
										tipoReporte = 2;
									}

									if(permiteExcel="S" && $('#excel').is(':checked')){
										tipoReporte = 3;
									}

									if($('#cifras').is(':checked')){
										cifras = $('#cifras').val();
									}

									if($('#cifras2').is(':checked')){
										cifras = $('#cifras2').val();
									}

									if($('#tipoConsulta').is(':checked')){
										tipoConsulta=$('#tipoConsulta').val();
									}

									if($('#tipoConsulta2').is(':checked')){
										tipoConsulta=$('#tipoConsulta2').val();
									}
									if($('#numeroPeriodo').val()== 37){
										fechaAct=fecha;
									}
									else{
										fechaAct=finPeriodo;
									}

									$('#numeroPeriodo').change(function(){
										if($('#numeroPeriodo').val() != 37 || $('#numeroPeriodo').val() != 0){
											fechaAct=finPeriodo;
										}

									});

									if($('#numeroPeriodo').val() == 0){

										fechaAct=$('#finEjercicio').val();
									}

									if($('#estadoFinanID').val()== balanceContable){
										var pagina='repFinancieroPDF.htm?ejercicio='+ejercicio+'&periodo='+periodo+'&fecha='+fechaAct
										+'&fechaFin='+fechaFin+'&tipoConsulta='+tipoConsulta
										+'&cifras='+cifras+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+'&usuario='+
										nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaSistema='+fechaSistema+'&rfc='+rfc
										+'&DirecInstitucion='+DirecInstitucion+'&estadoFinanID='+estadoFinanID
										+'&gerenteGeneral='+gerenteGeneral+'&presidenteConsejo='+presidenteConsejo+'&jefeContabilidad='+ jefeContabilidad
										+ '&ccInicial='+ccInicial+'&ccFinal='+ccFinal+ '&ccInicialDes='+ccInicialDes+'&ccFinalDes='+ccFinalDes;
										window.open(pagina,'_blank');
									}
									if($('#estadoFinanID').val()== estadoResultados){
										var pagina='repEstadoResulFinancieroPDF.htm?ejercicio='+ejercicio+'&periodo='+periodo+'&fecha='+fechaAct
										+'&fechaFin='+fechaFin+'&tipoConsulta='+tipoConsulta
										+'&cifras='+cifras+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+'&usuario='+
										nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaSistema='+fechaSistema+'&rfc='+rfc
										+'&DirecInstitucion='+DirecInstitucion+'&estadoFinanID='+estadoFinanID
										+'&gerenteGeneral='+gerenteGeneral+'&presidenteConsejo='+presidenteConsejo+'&jefeContabilidad='+ jefeContabilidad
										+ '&ccInicial='+ccInicial+'&ccFinal='+ccFinal+ '&ccInicialDes='+ccInicialDes+'&ccFinalDes='+ccFinalDes;
										window.open(pagina,'_blank');
									}

									if($('#estadoFinanID').val()== estadoResultadosMes){
										var pagina='repEstadoResulFinancieroPDF.htm?ejercicio='+ejercicio+'&periodo='+periodo+'&fecha='+fecha
										+'&fechaFin='+fechaFin+'&tipoConsulta='+"X"
										+'&cifras='+cifras+'&tipoReporte='+tipoReporte+'&tipoLista='+2+'&usuario='+
										nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaSistema='+fechaSistema+'&rfc='+rfc
										+'&DirecInstitucion='+DirecInstitucion+'&estadoFinanID='+estadoFinanID
										+'&gerenteGeneral='+gerenteGeneral+'&presidenteConsejo='+presidenteConsejo+'&jefeContabilidad='+ jefeContabilidad
										+ '&ccInicial='+ccInicial+'&ccFinal='+ccFinal+ '&ccInicialDes='+ccInicialDes+'&ccFinalDes='+ccFinalDes;
										window.open(pagina,'_blank');

									}
									if($('#estadoFinanID').val()== estadoFlujoEfec){
										var pagina='repFlujosEfectivoPDF.htm?ejercicio='+ejercicio+'&periodo='+periodo+'&fecha='+fechaAct
										+'&fechaFin='+fechaFin+'&tipoConsulta='+tipoConsulta
										+'&cifras='+cifras+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+'&usuario='+
										nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaSistema='+fechaSistema+'&rfc='+rfc
										+'&DirecInstitucion='+DirecInstitucion+'&estadoFinanID='+estadoFinanID
										+'&gerenteGeneral='+gerenteGeneral+'&presidenteConsejo='+presidenteConsejo+'&jefeContabilidad='+ jefeContabilidad
										+ '&ccInicial='+ccInicial+'&ccFinal='+ccFinal+ '&ccInicialDes='+ccInicialDes+'&ccFinalDes='+ccFinalDes;
										window.open(pagina,'_blank');
									}
									if($('#estadoFinanID').val()== estadoVariacion){
										var pagina='repEstadoVariacionesPDF.htm?ejercicio='+ejercicio+'&periodo='+periodo+'&fecha='+fechaAct
										+'&fechaFin='+fechaFin+'&tipoConsulta='+tipoConsulta
										+'&cifras='+cifras+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+'&usuario='+
										nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaSistema='+fechaSistema+'&rfc='+rfc
										+'&DirecInstitucion='+DirecInstitucion+'&estadoFinanID='+estadoFinanID
										+'&gerenteGeneral='+gerenteGeneral+'&presidenteConsejo='+presidenteConsejo+'&jefeContabilidad='+ jefeContabilidad
										+ '&ccInicial='+ccInicial+'&ccFinal='+ccFinal+ '&ccInicialDes='+ccInicialDes+'&ccFinalDes='+ccFinalDes;
										window.open(pagina,'_blank');
									}
								}
							}
						}
					}
				}
			}
		}
	}




	function consultaEjercicioFecha() {
		var conEjercicio =2;
		var ejercicioContableBean = {
				'numeroEjercicio':$('#numeroEjercicio').val(),
		};
		setTimeout("$('#cajaLista').hide();", 200);
		ejercicioContableServicio.consulta(conEjercicio,ejercicioContableBean,function(ejercicio){
			if(ejercicio!=null){
				$('#finEjercicio').val(ejercicio.finEjercicio);
				$('#inicioEjercicio').val(ejercicio.inicioEjercicio);
				esTab= true;
				consultaPeriodos();
			}
		});
	}

	function consultaPeriodosFecha() {
		var conForanea=3;
		var periodoBean = {
				'numeroEjercicio':$('#numeroEjercicio').val(),
				'numeroPeriodo':$('#numeroPeriodo').val(),
		};
		setTimeout("$('#cajaLista').hide();", 200);
		periodoContableServicio.consulta(conForanea,periodoBean,function(periodo){
			if(periodo!=null){
				$('#finPeriodo').val(periodo.finPeriodo);
				$('#inicioPeriodo').val(periodo.inicioPeriodo);
			}
		});
	}

	function consultaEjercicio() {
		dwr.util.removeAllOptions('numeroEjercicio');
		ejercicioContableServicio.listaCombo(1, function(ejercicio){
			dwr.util.addOptions('numeroEjercicio', ejercicio, 'numeroEjercicio', 'numeroEjercicio');
		});
	}

	function consultaPeriodos() {
		dwr.util.removeAllOptions('numeroPeriodo');
		var PeriodoBeanCon = {
				'numeroEjercicio': $('#numeroEjercicio').val()
		};
		dwr.util.addOptions('numeroPeriodo', {37:'TODOS'});
		periodoContableServicio.listaCombo(PeriodoBeanCon,5, function(periodos){
			dwr.util.addOptions('numeroPeriodo', periodos, 'numeroPeriodo', 'finPeriodo');
			consultaEjercicioCierre();
		});
	}
	function consultaTipoReporteFinan(){

		dwr.util.removeAllOptions('estadoFinanID');
		var BeanCon = {
				'estadoFinanID': $('#estadoFinanID').val()
		};
		dwr.util.addOptions('estadoFinanID');
		tipoEstaFinancierosServicio.listaCombo(BeanCon,2, function(estadosFinancieros){
			dwr.util.addOptions('estadoFinanID', estadosFinancieros, 'estadoFinanID', 'descripcion');
		});
	}

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
					mensajeSis("Formato de Fecha Incorrecto");
					$('#fecha').focus();
					$('#fecha').select();
					$('#fecha').val(parametros.fechaSucursal);
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
				if (comprobarSiBisisesto(anio)){ numDias=29;}else{ numDias=28;};
				break;
			default:
					mensajeSis("Formato de Fecha Incorrecto");
					$('#fecha').focus();
					$('#fecha').select();
					$('#fecha').val(parametros.fechaSucursal);

			return false;
			}
			if (dia>numDias || dia==0){
					mensajeSis("Formato de Fecha Incorrecto");
					$('#fecha').focus();
					$('#fecha').select();
					$('#fecha').val(parametros.fechaSucursal);
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
	function consultaCentroCostos(control) {
		var numcentroCosto = 0;
		if (control == 'I'){
		 numcentroCosto = $('#ccinicial').val();
		}
		if (control == 'F'){
		numcentroCosto = $('#ccfinal').val();

			}
		setTimeout("$('#cajaLista').hide();", 200);
			if(numcentroCosto != '' && !isNaN(numcentroCosto ) && esTab ){
					var centroBeanCon = {
  					'centroCostoID':numcentroCosto
				 };
				centroServicio.consulta(catTipoConsultaCentro.principal,centroBeanCon,function(centro) {
						if(centro!=null){
							if (control == 'I'){
								$('#descripcionI').val(centro.descripcion);
								validaCentroCostos(control);
								ban=0;
								}
							if (control == 'F'){
								 $('#descripcionF').val(centro.descripcion);
								validaCentroCostos(control);
								ban=0;
								}

						}else{
							if (control == 'I'){
							 $('#ccinicial').focus();
							 $('#ccinicial').val('');
							 $('#descripcionI').val('');
							 mensajeSis("El Centro de Costo no Existe");
							}
							if (control == 'F'){
							 $('#ccfinal').focus();
							 $('#ccfinal').val('');
							 $('#descripcionF').val('');
							 mensajeSis("El Centro de Costo no Existe");
							}
						}
					});
			} if(numcentroCosto != '' && !isNaN(numcentroCosto ) ){}
			else{
			if (control == 'I'){
				$('#descripcionI').val('');
				}
			if (control == 'F'){
				 $('#descripcionF').val('');

				}
			}

		}


function validaCentroCostos(control){
	var numcentroCosto = 0;


	if($('#ccinicial').val() != ''  && !isNaN($('#ccinicial').val()) )
		if($('#ccfinal').val() != ''  && !isNaN($('#ccfinal').val()) )
			if($('#ccinicial').val() > $('#ccfinal').val()){
				$('#ccfinal').focus();
				error = 1;
				mensajeSis('El Centro de Costos Inicial Debe Ser Menor o Igual al Centro de Costos Final');

				if(control == 'I'){
					$('#ccfinal').val($('#ccinicial').val());
					numcentroCosto = $('#ccfinal').val();
				}
				if(control == 'F'){
					$('#ccinicial').val($('#ccfinal').val());
					numcentroCosto = $('#ccinicial').val();
				}
				var centroBeanCon = {
	  					'centroCostoID':numcentroCosto
					 };
					centroServicio.consulta(catTipoConsultaCentro.principal,centroBeanCon,function(centro) {
							if(centro!=null){
									$('#descripcionI').val(centro.descripcion);
									 $('#descripcionF').val(centro.descripcion);

									}
					});
			}else{
				error = 0;
			}
	if(control == 'generar'){
	if($('#ccinicial').val() != '' && $('#ccfinal').val()== '' ){
		$('#ccfinal').focus();
		error = 1;
		mensajeSis('El Centro de Costos Final esta vacío');
	}else if( $('#ccinicial').val()== '' && $('#ccfinal').val() != ''){
		$('#ccinicial').focus();
		 error = 1;
		mensajeSis('El Centro de Costos Inicial esta vacío');
	}
	}
	return error;
	}


	function muestraBotonExcel(){
		  var tipoConsulta = 32;
		   var bean = {
					'empresaID'		: 1
				};

			paramGeneralesServicio.consulta(tipoConsulta, bean,function(paramGenerales){
				if(paramGenerales!=null){
					permiteExcel = paramGenerales.valorParametro;
					if(permiteExcel == 'S'){
						$('#excel').show();
						$('#lblExcel').show();
					}else{
						$('#excel').hide();
						$('#lblExcel').hide();
					}
				}else{
					mensajeSis("No existe un valor parametrizado para el boton Excel");
					permiteExcel = "N";
				}

			   });
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

	function validaEjecucionBalanzaContable(){
		paramGeneralesServicio.consulta(53,{},{async: false, callback:function(parametro) {
			if (parametro != null) {
				ejecucionBalanzaContable = parametro.valorParametro;
				if( ejecucionBalanzaContable == 'S' ){
					consultaUsuarioBalanza();
				}
			} else {
				ejecucionBalanzaContable = 'N';
				mensajeSis('Ha ocurrido un error al consultar Si existe una ejecución de Balanza Contable en el Sistema.');
			}
		}});
	}

	function consultaUsuarioBalanza(){
		paramGeneralesServicio.consulta(54,{},{async: false, callback:function(parametro) {
			if (parametro != null) {
				userEjecucionBalanzaContable = parametro.valorParametro;
			} else {
				userEjecucionBalanzaContable = '';
				mensajeSis('Ha ocurrido un error al consultar el Usuario que ejecuto la Balanza Contable en el Sistema.');
			}
		}});
	}

	function consultaEjercicioCierre() {
		var conForanea=6;
		var periodoBean = {
				'numeroEjercicio':$('#numeroEjercicio').val(),
		};
		setTimeout("$('#cajaLista').hide();", 200);
		periodoContableServicio.consulta(conForanea,periodoBean,function(periodo){
			if(periodo!=null){
				if(periodo.status == "N"){
					$('#numeroPeriodo option[value="0"]').remove();
				}else{
					dwr.util.addOptions('numeroPeriodo', {0:'CIERRE EJERCICIO'});
				}
			}
		});
	}

	function consultarFechaEnPeriodosCerrados() {
		if(esFechaValida($('#fecha').val())){
			var conEstatus=4;
			var fechaCam=$('#fecha').val().split("-");
			var fecha_cam=fechaCam[0]+'-'+fechaCam[1]+'-01';
			var periodoBean = {
				'fecha':fecha_cam
			};
			periodoContableServicio.consulta(conEstatus,periodoBean,function(periodo){
				if(periodo!=null) {
					if(periodo.status=='C'){
						//Verificar que la fecha sea de un periodo abierto
						mensajeSis("La Fecha de Consulta Pertence a un Periodo Cerrado, favor de obtener el Estado Financiero especificando el Periodo Contable");
						$('#tipoConsulta2').attr("checked",true);
						$('#tipoConsulta2').trigger("click");
					}
				}
			});
		}
		else{
			$('#fecha').focus();
		}
	}

});