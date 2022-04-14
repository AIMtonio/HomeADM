$(document).ready(function (){

	esTab = true;
	parametros = consultaParametrosSession();
	var ban=0;
	var ban1=0;
	var error = 0;
	var ejecucionBalanzaContable = 'N';
	var userEjecucionBalanzaContable = '';

	var catTipoConsultaCentro = {
		'principal'	: 1,
		'foranea'	: 2
	};
	// Definicion de Constantes y Enums
	consultaEjercicio();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	habilitaControl('pdf');
	habilitaControl('pantalla');
	deshabilitaControl('numeroEjercicio');
	deshabilitaControl('finEjercicio');
	deshabilitaControl('numeroPeriodo');
	$('#tipoConsulta3').focus();

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#numeroEjercicio').click(function() {
		esTab = true;
		consultaEjercicioFecha();
	});

	$('#numeroEjercicio').blur(function() {
		esTab = true;
		consultaEjercicioFecha();
	});

	$('#numeroPeriodo').blur(function() {
		consultaPeriodosFecha();
		$('#saldoCero').focus();
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
		$('#tipoConsulta3').attr("checked",false);
		$('#numeroEjercicio').attr("disabled",true);
		$('#finEjercicio').attr("disabled", true);
		$('#numeroPeriodo').attr("disabled", true);
		if($('#tipoConsulta').is(':checked')){
			$('#fecha').attr("disabled", false);
			$('#fecha').focus();
			$('#fecha').val(parametros.fechaSucursal);
		}
	});

	$('#tipoConsulta3').click(function() {
		$('#tipoConsulta2').attr("checked",false);
		$('#tipoConsulta').attr("checked",false);
		$('#numeroEjercicio').attr("disabled",true);
		$('#finEjercicio').attr("disabled", true);
		$('#numeroPeriodo').attr("disabled", true);
		if($('#tipoConsulta3').is(':checked')){
			$('#fecha').attr("disabled", false);
			$('#fecha').focus();
			$('#fecha').val(parametros.fechaSucursal);
		}
	});

	$('#tipoConsulta2').click(function() {
		$('#tipoConsulta').attr("checked",false);
		$('#tipoConsulta3').attr("checked",false);
		$('#fecha').attr("disabled",true);
		if($('#tipoConsulta2').is(':checked')){
			$('#numeroEjercicio').attr("disabled",false);
			$('#finEjercicio').attr("disabled",false);
			$('#numeroPeriodo').attr("disabled",false);
			$('#numeroEjercicio').focus();
		}
	});

	$('#saldoCero').click(function() {
		$('#saldoCero2').attr("checked",false);
		if($('#saldoCero').is(':checked')){
			$('#saldoCero2').focus();
		}
	});

	$('#saldoCero2').click(function() {
		$('#saldoCero').attr("checked",false);
		if($('#saldoCero2').is(':checked')){
			$('#cifras').focus();
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

	$('#tipoBalanza1').click(function() {
		$('#tipoBalanza2').attr("checked",false);
		if($('#tipoBalanza1').is(':checked')){
			$('#excel').attr("checked",true);
			$('#pdf').attr("checked",false);
			$('#pantalla').attr("checked",false);
			deshabilitaControl('pdf');
			deshabilitaControl('pantalla');
		}
	});

	$('#tipoBalanza2').click(function() {
		$('#tipoBalanza1').attr("checked",false);
		if($('#tipoBalanza2').is(':checked')){
			habilitaControl('pdf');
			habilitaControl('pantalla');
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

	$('#excel').blur(function() {
		$('#generar').focus();
	});

	$('#generar').click(function() {
		validaCentroCostos(this.id);
		if(error == 0){
			if($('#tipoConsulta').attr('checked')==true || $('#tipoConsulta3').attr('checked')==true){
				enviarDatosReporte1();
			}else{
				enviarDatosReporte2();
			}
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

	$('#cuentaIni').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#cuentaIni').val();
			listaAlfanumerica('cuentaIni', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});

	$('#cuentaFin').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#cuentaFin').val();
			listaAlfanumerica('cuentaFin', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});

	$('#cuentaIni').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
			cuentaDescripcion('I');

	});

	$('#cuentaFin').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
			 cuentaDescripcion('F');
	});

	$('#nivelDetalle').blur(function() {
		var nivelDetalle=$('#nivelDetalle').val();
		var contador=nivelDetalle.length;
		var boolean=false;
		for(var i=0; i<contador; i++){
			if(nivelDetalle.charCodeAt(i) == 88){
			}
			else{
				boolean=true;
			}
		}
		if(boolean){
			$('#nivelDetalle').val('');
			mensajeSis('Nivel de Detalle Incorrecto');
		}
	});

	$('#fecha').blur(function() {
		var Xfecha= $('#fecha').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')
				$('#fecha').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaAplicacion;
			if( mayor(Xfecha, Yfecha)){
				mensajeSis("La Fecha es Mayor a la Fecha del Sistema");
				$('#fecha').val(parametroBean.fechaSucursal);
				$('#fecha').focus();
			} else {
				if($('#tipoConsulta').attr('checked')==true) {
					consultarFechaEnPeriodosCerrados();
				} else {
					$('#saldoCero').focus();
				}
			}
		} else {
			$('#fecha').val(parametroBean.fechaSucursal);
			$('#fecha').focus();
		}

	});

	$('#fecha').change(function(){
		var Xfecha= $('#fecha').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')
				$('#fecha').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaAplicacion;
			if( mayor(Xfecha, Yfecha)){
				mensajeSis("La Fecha es Mayor a la Fecha del Sistema");
				$('#fecha').val(parametroBean.fechaSucursal);
				$('#fecha').focus();
			} else {
				if($('#tipoConsulta').attr('checked')==true) {
					consultarFechaEnPeriodosCerrados();
				} else {
					('#saldoCero').focus();
				}
			}
		} else {
			$('#fecha').val(parametroBean.fechaSucursal);
			$('#fecha').focus();
		}
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

	// ---------- Funcion para enviar los datos al reporte-------------
	function enviarDatosReporte1(){
		var tipoReporte = 0;
		var tipoLista = 0;
		var tipoConsulta ='';
		var fecha = '1900-01-01';
		var ejercicio = 0;
		var periodo = 0;
		var saldCero ='';
		var cifras ='';
		var ccInicial =$('#ccinicial').val();
		var ccFinal=$('#ccfinal').val();
		var ccInicialDes=$('#descripcionI').val();
		var ccFinalDes=$('#descripcionF').val();
		var cuentaIni=$('#cuentaIni').val();
		var cuentaFin=$('#cuentaFin').val();
		var desCuentaIni=$('#descripcionCtaIni').val();
		var desCuentaFin=$('#descripcionCtaFin').val();
		var nivelDetalle=$('#nivelDetalle').val();
		var nombreUsuario=parametros.nombreUsuario;
		var nombreInstitucion=parametros.nombreInstitucion;
		var fechaEmision=parametros.fechaSucursal;
		var fechaFin = $('#inicioEjercicio').val();
		var tipoBalanza=$('input[name=tipoBalanza]:checked').val();
		var claveUsuario = parametros.claveUsuario;
		var fechaSistema = new Date();

		var segundos  = fechaSistema.getSeconds();
		var minutos = fechaSistema.getMinutes();
		var horas = fechaSistema.getHours();

		if(fechaSistema.getHours()<10){
			horas = "0"+fechaSistema.getHours();
		}
		if(fechaSistema.getMinutes()<10){
			minutos = "0"+fechaSistema.getMinutes();
		}
		if(fechaSistema.getSeconds()<10){
			segundos = "0"+fechaSistema.getSeconds();
		}

		var horaEmision = horas+":"+minutos+":"+segundos;


		validaEjecucionBalanzaContable();

		if( ejecucionBalanzaContable != 'N'){
			var mensaje = "Existe una Ejecución de la Balanza Contable en el Sistema, la cual fue solicitada por el usuario: "+ userEjecucionBalanzaContable+". Favor de Intentar mas Tarde.";
			if(userEjecucionBalanzaContable == ''){
				mensaje = "Existe una Ejecución de la Balanza Contable en el Sistema. Favor de Intentar mas Tarde.";
			}
			mensajeSis(mensaje);
			return ;
		}

		 if($('#tipoConsulta').attr('checked')==false && $('#tipoConsulta2').attr('checked')==false && $('#tipoConsulta3').attr('checked')==false){
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
			 if(cuentaFin != '' && desCuentaFin != '')
					if(cuentaIni == ''  && ban==0){
						mensajeSis('Favor de Especificar la Cuenta Contable Inicial');
						$('#cuentaFin').focus();
						ban1++;
					}

				if(cuentaIni != '' && desCuentaIni != '')
					if(cuentaFin == '' && ban ==0){
						mensajeSis('Favor de Especificar la Cuenta Contable Final');
						$('#cuentaFin').focus();
						ban1++;
					}


			$('#numeroEjercicio').val('');
			$('#numeroPeriodo').val('');
			$('#finEjercicio').val('');
			$('#finPeriodo').val('');

		if($('#tipoConsulta').is(':checked') || $('#tipoConsulta3').is(':checked')){

			if($('#tipoConsulta3').is(':checked')){
				tipoConsulta = $('#tipoConsulta3').val();
			}else{
				tipoConsulta = $('#tipoConsulta').val();
			}

			if($('#fecha').val() ==0){
				mensajeSis("La fecha esta vacia");
				event.preventDefault();
			}else{
				fecha = $('#fecha').val();

				if($('#saldoCero').attr('checked')==false && $('#saldoCero2').attr('checked')==false){
					mensajeSis("No ha seleccionado Ninguna Opción de Cuentas con Saldo Cero");
				}
				else{
					if($('#saldoCero').is(':checked')){
						saldCero = $('#saldoCero').val();
					}

					if($('#saldoCero2').is(':checked')){
						saldCero = $('#saldoCero2').val();
					}
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
						if($('#pantalla').attr('checked')==false && $('#pdf').attr('checked')==false && $('#excel').attr('checked')==false){
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
								tipoLista = 2;
							}

								if(ban == 0 && ban1==0){
									var pagina='RepBalanzaContable.htm?ejercicio='+ejercicio+'&periodo='+periodo+'&fecha='+fecha+'&tipoConsulta='+tipoConsulta+
									'&saldoCero='+saldCero+'&cifras='+cifras+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+'&nombreUsuario='+
									nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaEmision='+fechaEmision+'&fechaFin='+fechaFin
									+ '&ccInicial='+ccInicial+'&ccFinal='+ccFinal+ '&ccInicialDes='+ccInicialDes+'&ccFinalDes='+ccFinalDes
									+'&cuentaIni='+cuentaIni+'&cuentaFin='+cuentaFin+'&nivelDetalle='+nivelDetalle+'&tipoBalanza='+tipoBalanza
									+'&claveUsuario='+claveUsuario+'&horaEmision='+horaEmision;
									window.open(pagina,'_blank');
								}

							}
						}
					}
				}
			}
		}
	}

	function enviarDatosReporte2(){
		var tipoReporte = 0;
		var tipoLista = 0;
		var tipoConsulta ='';
		var fecha = $('#finEjercicio').val();
		var fechaFin = $('#inicioEjercicio').val();
		var ejercicio = 0;
		var periodo = 0;
		var saldCero ='';
		var cifras ='';
		var finPeriodo=$('#finPeriodo').val();
		var fechaAct='';
		var ccInicial =$('#ccinicial').val();
		var ccFinal=$('#ccfinal').val();
		var ccInicialDes=$('#descripcionI').val();
		var ccFinalDes=$('#descripcionF').val();
		var cuentaIni=$('#cuentaIni').val();
		var cuentaFin=$('#cuentaFin').val();
		var desCuentaIni=$('#descripcionCtaIni').val();
		var desCuentaFin=$('#descripcionCtaFin').val();
		var nivelDetalle=$('#nivelDetalle').val();
		var nombreUsuario=parametros.nombreUsuario;
		var nombreInstitucion=parametros.nombreInstitucion;
		var fechaEmision=parametros.fechaSucursal;
		var tipoBalanza=$('input[name=tipoBalanza]:checked').val();
		var claveUsuario = parametros.claveUsuario;
		var fechaSistema = new Date();

		var segundos  = fechaSistema.getSeconds();
		var minutos = fechaSistema.getMinutes();
		var horas = fechaSistema.getHours();

		if(fechaSistema.getHours()<10){
			horas = "0"+fechaSistema.getHours();
		}
		if(fechaSistema.getMinutes()<10){
			minutos = "0"+fechaSistema.getMinutes();
		}
		if(fechaSistema.getSeconds()<10){
			segundos = "0"+fechaSistema.getSeconds();
		}

		var horaEmision = horas+":"+minutos+":"+segundos;

		validaEjecucionBalanzaContable();

		if( ejecucionBalanzaContable != 'N'){
			mensajeSis("Existe una Ejecución de la Balanza Contable en el Sistema, la cual fue solicitada por el usuario: "+ userEjecucionBalanzaContable+". Favor de Intentar mas Tarde.");
			return ;
		}

		if($('#tipoConsulta3').attr('checked')==false  && $('#tipoConsulta').attr('checked')==false && $('#tipoConsulta2').attr('checked')==false){
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

			 //oooo
			if(cuentaFin != '' && desCuentaFin != '')
					if(cuentaIni == ''  && ban==0){
						mensajeSis('Favor de Especificar la Cuenta Contable Inicial');
						$('#cuentaFin').focus();
						ban1++;
					}

				if(cuentaIni != '' && desCuentaIni != '')
					if(cuentaFin == '' && ban ==0){
						mensajeSis('Favor de Especificar la Cuenta Contable Final');
						$('#cuentaFin').focus();
						ban1++;
					}



				$('#fecha').val('');

			if($('#tipoConsulta2').is(':checked')){
				 tipoConsulta = $('#tipoConsulta2').val();
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

						if($('#numeroPeriodo').val()== 37){
							fechaAct=fecha;
						}else if($('#numeroPeriodo').val()== 0){
							fechaAct=fecha;
						}else{
							fechaAct=finPeriodo;
						}

						periodo = $('#numeroPeriodo').val();

						if($('#saldoCero').attr('checked')==false && $('#saldoCero2').attr('checked')==false){
							mensajeSis("No ha seleccionado Ninguna Opción de Cuentas con Saldo Cero");
						}
						else{
							if($('#saldoCero').is(':checked')){
								saldCero = $('#saldoCero').val();
							}

							if($('#saldoCero2').is(':checked')){
								saldCero = $('#saldoCero2').val();
							}
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
								if($('#pantalla').attr('checked')==false && $('#pdf').attr('checked')==false && $('#excel').attr('checked')==false){
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
										tipoLista = 2;
									}

									if(ban==0 && ban1==0){
										var pagina='RepBalanzaContable.htm?ejercicio='+ejercicio+'&periodo='+periodo+'&fecha='+fechaAct+'&tipoConsulta='+tipoConsulta+
										'&saldoCero='+saldCero+'&cifras='+cifras+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista+'&nombreUsuario='+
										nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaEmision='+fechaEmision+'&fechaFin='+fechaFin
										+ '&ccInicial='+ccInicial+'&ccFinal='+ccFinal+ '&ccInicialDes='+ccInicialDes+'&ccFinalDes='+ccFinalDes
										+'&cuentaIni='+cuentaIni+'&cuentaFin='+cuentaFin +'&nivelDetalle='+nivelDetalle+'&tipoBalanza='+tipoBalanza
										+'&claveUsuario='+claveUsuario+'&horaEmision='+horaEmision;
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
			dwr.util.addOptions('numeroPeriodo', {0:'CIERRE EJERCICIO'});
		});
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
				 mensajeSis("El Centro de Costo no Existe");
					if (control == 'I'){
					 $('#ccinicial').focus();
					 $('#ccinicial').val('');
					 $('#descripcionI').val('');
					}
					if (control == 'F'){
					 $('#ccfinal').focus();
					 $('#ccfinal').val('');
					 $('#descripcionF').val('');
					}
				}
			});
		} if(numcentroCosto != '' && !isNaN(numcentroCosto ) ){}
			else{
				ban=0;
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
				mensajeSis('El Centro de Costos Inicial Debe Ser Menor o Igual al Centro de Costos Final');
				$('#ccfinal').focus();
				error = 1;
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
				error=0;
			}

		if(control == 'generar'){
			if($('#ccinicial').val() != '' && $('#ccfinal').val()== '' ){
				mensajeSis('El Centro de Costos Final esta vacío');
				$('#ccfinal').focus();
				 error = 1;
			}
			else if( $('#ccinicial').val()== '' && $('#ccfinal').val() != ''){
				mensajeSis('El Centro de Costos Inicial esta vacío');
				$('#ccinicial').focus();
				 error = 1;
			}
		}

		return error;
	}

	function ValidaCuentaContable(control){
		var numCtaContable = '';
		var cuentaContaI=$('#cuentaIni').val();
		var cuentaContaF=$('#cuentaFin').val();
		var conForanea = 2;
		if(!isNaN(cuentaContaI) && !isNaN(cuentaContaF) && cuentaContaI != '' && cuentaContaF !=''){
			if(cuentaContaI>cuentaContaF){
				mensajeSis("La Cuenta Contable Inicial Debe ser Menor o Igual a la Cuenta Contable Final");

				if (control == 'I'){
					numCtaContable = $('#cuentaIni').val();
					$('#cuentaFin').val($('#cuentaIni').val());
				}
				if (control == 'F'){
					numCtaContable = $('#cuentaFin').val();
					$('#cuentaIni').val($('#cuentaFin').val());

				}

				var CtaContableBeanCon = {
					'cuentaCompleta':numCtaContable
				};
				cuentasContablesServicio.consulta(conForanea,CtaContableBeanCon,function(ctaConta){
					if(ctaConta!=null){
						$('#descripcionCtaIni').val(ctaConta.descripcion);
						$('#descripcionCtaFin').val(ctaConta.descripcion);
					}
				});

			}
		}
	}

	function cuentaDescripcion(control){

		var numCtaContable = '';
		if (control == 'I'){
			numCtaContable = $('#cuentaIni').val();
		}
		if (control == 'F'){
			numCtaContable = $('#cuentaFin').val();
		}
		var conForanea = 2;
		var CtaContableBeanCon = {
			'cuentaCompleta':numCtaContable
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaContable != '' && !isNaN(numCtaContable ) && esTab){
			cuentasContablesServicio.consulta(conForanea,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){
					if (control == 'I'){
						$('#descripcionCtaIni').val(ctaConta.descripcion);
						ValidaCuentaContable(control);
						ban1=0;
					}
					if (control == 'F'){
						$('#descripcionCtaFin').val(ctaConta.descripcion);
						ValidaCuentaContable(control);
						ban1=0;
					}
				}else{
					mensajeSis("No existe la cuenta contable");
					if (control == 'I'){
						$('#cuentaIni').focus();
						$('#descripcionCtaIni').val('');
						$('#cuentaIni').val('');
					}
					if (control == 'F'){
						$('#cuentaFin').focus();
						$('#descripcionCtaFin').val('');
						$('#cuentaFin').val('');
					}
				}

			});
		}else{
			if(numCtaContable != '' && !isNaN(numCtaContable )){
			}else{
				ban1=0;
				if(control == 'I')
					$('#descripcionCtaIni').val('');
				if(control == 'F')
					$('#descripcionCtaFin').val('');
			}
		}
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
						mensajeSis("La Fecha de Consulta Pertence a un Periodo Cerrado, favor de obtener la balanza especificando el Periodo Contable");
						$('#tipoConsulta2').attr("checked",true);
						$('#tipoConsulta2').trigger("click");
					}
					else{
						$('#saldoCero').focus();
					}
				}
				else{
					$('#saldoCero').focus();
				}
			});
		}
		else{
			$('#fecha').focus();
		}
	}

	///VALIDACIONES DE FECHA
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				$('#fecha').val(parametros.fechaSucursal);
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
				if (comprobarSiBisisesto(anio)){ numDias=29;}else{ numDias=28;};
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

});

function ayuda(){
	var data;
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all" >'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Nivel de Detalle a Mostrar:</legend>'+
			'<div id="ContenedorAyuda">'+
			'<table id="tablaLista">'+
				'<tr>'+
					'<td class="label"><label>Especifique con una "X" el Número de Dígitos o Segmentos</label></td>'+
				'</tr>'+
				'<tr>'+
					'<td class="label"><label>a Mostrar como Nivel de Detalle de la Balanza Contable</label></td>'+
				'</tr>'+

			'</table>'+
			'<br>'+
			'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
			'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo:</legend>'+

			'<table id="tablaLista">'+
				'<tr>'+
					'<td class="label"><label>XXXX</label></td>'+
					'<td class="label" align="left"><label>Mostrará las Cuentas Contables a Nivel de 4 Posiciones</label></td>'+
				'</tr>'+

			'</table>'+
			'</div></div>'+
			'</fieldset>'+
			'</fieldset>';

	$('#ContenedorAyuda').html(data);
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: {
				top:  ($(window).height() - 400) /2 + 'px',
				left: ($(window).width() - 400) /2 + 'px',
				width: '400px'
			} });
	$('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}
var nivelDetalle=$('#nivelDetalle').val();

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