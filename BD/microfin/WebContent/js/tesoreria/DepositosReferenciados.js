
var  catTipoFecha={
	'inicio' : 1,
	'fin' : 2,
};
var  catConstantes={
	'Entero_Cero' : '0',
	'CadeNona_Vacia' : '',
	'Str_No' : 'N',
	'Str_Si' : 'S',
};
$(document).ready(function() {
	esTab = true;
	var listaVisible=false;
	//Definicion de Constantes y Enums
	var catTipoTransaccion = {
			'procesa':'1',
			'limpia':'2',
			'guardaGrid':'3'
	};

	var catTipoConsultaTesoMvts = {
			'principal'	: 1,
			'foranea'	: 2
	};

	var catTipoConsultaInstituciones = {
			'principal':1,
			'foranea':2
	};

	var  catTipoConsultaEstatusFecha={
			'estatus' :4,
			'fecha' :6
	};

	var  catTipoConsultaFecha={
			'conFecha' :5
	};


    catTipoListaDepositos = {
		    'listaDepositos': '1'
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('enviar', 'submit');
	deshabilitaBoton('btnProcesar', 'submit');
	agregaFormatoControles('formaGenerica');

	var parametrosBean = consultaParametrosSession();
	fechaHabilInicio('fechaCargaInicial',parametroBean.fechaSucursal);
	fechaHabilInicio('fechaCargaFinal',parametroBean.fechaSucursal);
	$('#fechaSistema').val(parametroBean.fechaAplicacion);

	validaEjecucionMesAnterior();

	$('#institucionID').focus();

	$('#canales').hide();
	consultaCargaLayoutXLSDepRef();

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
	    submitHandler : function(event) {
				grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma','mensaje', 'true', 'institucionID',
		    			'funcionExito','funcionError');
	    }
	});

	$('#tipoReferenciaCredito').click(function(){
		$('#tipoReferenciaCredito').attr('checked',true);
		$('#tipoReferenciaCuenta').removeAttr('checked');
		$('#tipoReferenciaCliente').removeAttr('checked');
		$('#tipoCanal').val($('#tipoReferenciaCredito').val());
	});
	$('#tipoReferenciaCuenta').click(function(){
		$('#tipoReferenciaCredito').removeAttr('checked');
		$('#tipoReferenciaCuenta').attr('checked',true);
		$('#tipoReferenciaCliente').removeAttr('checked');
		$('#tipoCanal').val($('#tipoReferenciaCuenta').val());
	});
	$('#tipoReferenciaCliente').click(function(){
		$('#tipoReferenciaCredito').removeAttr('checked');
		$('#tipoReferenciaCuenta').removeAttr('checked');
		$('#tipoReferenciaCliente').attr('checked',true);
		$('#tipoCanal').val($('#tipoReferenciaCliente').val());
	});

	// se valida que la fecha de carga no sea superior a la fecha del sistema
	$('#fechaCargaInicial').change(function() {
		if($('#fechaCargaInicial').val().trim() != ""){
			comparaFechas(this.id,$('#fechaCargaInicial').val(),$('#fechaCargaFinal').val());
		}

	});

	// se valida que la fecha de carga no sea superior a la fecha del sistema
	$('#fechaCargaFinal').change(function() {
		if($('#fechaCargaFinal').val().trim() != ""){
			validarFecha(this.id);
			comparaFechas(this.id,$('#fechaCargaInicial').val(),$('#fechaCargaFinal').val());
		}
	});

	$('#fechaCarga').change(function() {
		var Xfecha= $('#fechaCarga').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaCarga').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Carga debe ser menor o igual a la Fecha del Sistema.")	;
				$('#fechaCarga').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaCarga').val(parametroBean.fechaSucursal);
		}
	});


	$('#procesar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.procesa);
	});


	$('#enviar').click(function() {
		if(comparaFechas('fechaCargaInicial',$('#fechaCargaInicial').val(),$('#fechaCargaFinal').val())
			&& validaCargaMesAnterior()){
			periodoContableFechaInicial('fechaCargaInicial');
		}
	});

	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#institucionID').blur(function() {
		ocultaGridDepositos(true);
		if( ($('#institucionID').val().trim() == '9' || $('#institucionID').val().trim() == '24') && $('#radioFormatoBanco').is(':checked') ){
			$('#canales').show();
			$('#radioFormatoBanco').attr('checked',true);
			$('#radioFormatoEstandar').attr('checked',false);
			$('#bancoEstandar').val($('#radioFormatoBanco').val());
		}else{
			$('#canales').hide();
			$('#radioFormatoBanco').attr('checked',false);
			$('#radioFormatoEstandar').attr('checked',true);
			$('#bancoEstandar').val($('#radioFormatoEstandar').val());
		}
		consultaInstitucion(this.id);

		if(isNaN($('#institucionID').val()) ){
			$('#institucionID').val("");
			$('#institucionID').focus();


		}
	});


	$('#cuentaBancaria').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionID').val();

		camposLista[1] = "cuentaAhoID";
		parametrosLista[1] = $('#cuentaBancaria').val();

		lista('cuentaBancaria', '2', '2', camposLista,parametrosLista, 'tesoCargaMovLista.htm');

	});

	$('#cuentaBancaria').blur(function() {
		if($('#cuentaBancaria').val() != '' ){
			consultaCuentaBan(this.id);
		}

		if(isNaN($('#cuentaBancaria').val()) ){
			$('#cuentaBancaria').val("");
			$('#cuentaBancaria').focus();


		}

	});

	// Funcion de Click a los radio para escoger el formato en el que se subira el archivo
	$('#radioFormatoBanco').click(function(){
		if($('#radioFormatoBanco').is(':checked')){
			$('#radioFormatoEstandar').attr('checked',false);
			$('#bancoEstandar').val($('#radioFormatoBanco').val());
			if( ($('#institucionID').val().trim() == '9' || $('#institucionID').val().trim() == '24') && $('#radioFormatoBanco').is(':checked') ){
				$('#canales').show();
			}
		}else{
			$('#canales').hide();
		}
	});

	$('#radioFormatoEstandar').click(function(){
		if($('#radioFormatoEstandar').is(':checked')){
			$('#radioFormatoBanco').attr('checked',false);
			$('#bancoEstandar').val($('#radioFormatoEstandar').val());
			$('#canales').hide();
		}else{
			if( ($('#institucionID').val().trim() == '9' || $('#institucionID').val().trim() == '24') && $('#radioFormatoBanco').is(':checked') ){
				$('#canales').show();
			}
		}
	});

	//------------ Validaciones de la Forma -------------------------------------
$('#formaGenerica').validate({

	rules: {

			institucionID: {
				required: true,

			},

			cuentaAhoID: {
				required: true,

			},

			fechaCargaInicial: {
				required: true,
				date: true
			},

			fechaCargaFinal: {
				required: true,
				date: true
			},

			file: {
			required: true,	date: true
		}
	},

		messages: {

			institucionID : {
				required : 'Especificar la institución',

			},

			cuentaAhoID : {
				required : 'Especificar cuenta de ahorro',

			},

			fechaCargaInicial: {
				required:       'Especifique Fecha de Inicio..' ,
				date:           'Fecha Incorrecta'
			},
			fechaCargaFinal: {
				required:       'Especifique Fecha de Inicio..' ,
				date:           'Fecha Incorrecta'
			},

			file : {
			   required : 'Se requiere un archivo para subir',

				},

		}
	});




	//Método de consulta de Institución
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var InstitutoBeanCon = {
				'institucionID':numInstituto
		};

		if(numInstituto != '' && !isNaN(numInstituto)  ){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea, InstitutoBeanCon, function(instituto){
				if(instituto!=null){
					$('#nombreInstitucion').val(instituto.nombre);
					$('#cuentaAhoID').val("");
					$('#nombreBanco').val("");
					$('#cuentaBancaria').val("");

				}else{
					mensajeSis("No se encontró la Institución");
					$('#institucionID').focus();
					$('#institucionID').val("");
					$('#nombreInstitucion').val("");
					$('#cuentaAhoID').val("");
					$('#nombreBanco').val("");
					$('#cuentaBancaria').val("");
					deshabilitaBoton('enviar', 'submit');
				}
			});
		}
	}

	function consultaCuentaBan(idControl) {
		var jqCuentaBan= eval("'#" + idControl + "'");
		var numCuenta = $(jqCuentaBan).val();
		setTimeout("$('#cajaLista').hide();", 200);


		var tipoConsulta = 9;
		var DispersionBeanCta = {
				'institucionID': $('#institucionID').val(),
				'numCtaInstit': numCuenta
		};
		if(!isNaN(numCuenta)){
			operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
				if(data!=null){
					$('#cuentaAhoID').val(data.cuentaAhorro);
					$('#nombreBanco').val(data.nombreCuentaInst);
					habilitaBoton('enviar', 'submit');
				}else{
					$('#cuentaBancaria').focus();
					mensajeSis("No se encontró la cuenta bancaria.");
					$('#cuentaAhoID').val('');
					$('#nombreBanco').val('');
					$('#cuentaBancaria').val('');
					$('#cuentaBancaria').focus();
					deshabilitaBoton('enviar', 'submit');

				}
			});
		}
	}

	var parametrosBean = consultaParametrosSession();
	var rutaArchivos = parametrosBean.rutaArchivos;
	var ventanaArchivosCliente ="";
	function subirArchivos() {
		ocultaGridDepositos(true);
		var url ="archivoDepRefereSubArc.htm"+
		"?ins="+$('#institucionID').val()+"&ctaB="+$('#cuentaBancaria').val() +
		"&cta="+$('#cuentaAhoID').val()+"&fecIni="+$('#fechaCargaInicial').val()+
		"&be="+$('#bancoEstandar').val()+
		"&tAn="+$('#numTranAnt').val()+
		"&cargaXLS="+$('#cargaLayoutXLSDepRef').val()+
		"&fecFin="+$('#fechaCargaFinal').val()+"&tipC="+$('#tipoCanal').val();
		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

		ventanaArchivosCuenta = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
				"left="+leftPosition+
				",top="+topPosition+
				",screenX="+leftPosition+
				",screenY="+topPosition);

		//$.blockUI({message: "Favor de terminar el proceso"});

	}


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


//	FIN VALIDACIONES DE REPORTES

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
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
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
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	/***********************************/
	// funcion para calcular el dia habil anterior
	function fechaHabilInicio(idcontrol,fecha){
		var jqControl = eval("'#"+idcontrol+"'");
		var diaFestivoBean = {
				'fecha':fecha,
				'numeroDias':1,
				'salidaPantalla':'S'
		};
		diaFestivoServicio.calculaDiaFestivo(2,diaFestivoBean,function(diaAnt) {
			if(diaAnt!=null){
				$(jqControl).val(diaAnt.fecha);

			}else{
				$(jqControl).val(parametroBean.fechaSucursal);

			}
		});

	}

	function validarFecha(idcontrol){
		var valorFechaSucursal = parametroBean.fechaSucursal;
		var anioFechaSucursal	= valorFechaSucursal.substr(0,4);
		var mesFechaSucursal = valorFechaSucursal.substr(5,2);
		var diaFechaSucursal = valorFechaSucursal.substr(8,2);

		var jqvalorFechaCarga	= eval("'#"+idcontrol+"'");
		var valorFechaCarga 	= $(jqvalorFechaCarga).val();
		if(valorFechaCarga == null || valorFechaCarga == ''){
			return;
		}
		var anioFechaCarga	= valorFechaCarga.substr(0,4);
		var mesFechaCarga = valorFechaCarga.substr(5,2);
		var diaFechaCarga = valorFechaCarga.substr(8,2);
		var separadorUnoFechaCarga = valorFechaCarga.substr(4,1);
		var separadorDosFechaCarga = valorFechaCarga.substr(7,1);

		if(separadorUnoFechaCarga == "-"){
			if(separadorDosFechaCarga == "-"){
				if(anioFechaCarga>anioFechaSucursal){
					mensajeSis("La fecha de Carga no puede ser superior \n a la fecha del sistema.");
					$(jqvalorFechaCarga).focus().select();
					fechaHabilInicio(idcontrol,valorFechaSucursal);
				}else{
					if(anioFechaCarga==anioFechaSucursal){
						if(mesFechaCarga>mesFechaSucursal){
							mensajeSis("La fecha de Carga no puede ser superior \n a la fecha del sistema.");
							$(jqvalorFechaCarga).focus().select();
							fechaHabilInicio(idcontrol,valorFechaSucursal);
						}else{
							if(mesFechaCarga==mesFechaSucursal){
								if(diaFechaCarga>diaFechaSucursal){
									mensajeSis("La fecha de Carga no puede ser superior \n a la fecha del sistema.");
									$(jqvalorFechaCarga).focus().select();
									fechaHabilInicio(idcontrol,valorFechaSucursal);
								}
							}
						}
					}
				}
			}else{
				mensajeSis("Formato de fecha incorrecto 'aaaa-mm-dd'");
				$(jqvalorFechaCarga).focus().select();
				fechaHabilInicio(idcontrol,valorFechaSucursal);
			}
		}else{
			mensajeSis("Formato de fecha incorrecto 'aaaa-mm-dd'");
			$(jqvalorFechaCarga).focus().select();
			fechaHabilInicio(idcontrol,valorFechaSucursal);
		}

	}


function validarFormatoFecha(idcontrol, separador){
	var resultado = false ;
	var jqvalorFechaCarga	= eval("'#"+idcontrol+"'");
	var linea	= $(jqvalorFechaCarga).val();
	var arreglo = null;
	var dia = 0 ;
	var mes = 0 ;
	var anio = 0 ;
	var	fecha 	= null;
	var	fecha2 	= null;
	try{

		arreglo = linea.trim().split("-");
		dia 	= Number(arreglo[2]);
		mes 	= Number(arreglo[1]);
		anio 	= Number(arreglo[0]);
		fecha2 	= new Date(anio,mes,0);
		if(dia <= fecha2.getDate()){
				resultado = true;
		}
		else{
			resutado = false;
			}
	}catch(err){
		resutado = false;

		}
		return resultado;
	}
	function comparaFechas(idControl,fechaIni,fechaFin){
		var jqControl = eval("'#"+idControl+"'");
		var valorFechaSucursal = parametroBean.fechaSucursal;
		var xYear=fechaIni.substring(0,4);
		var xMonth=fechaIni.substring(5, 7);
		var xDay=fechaIni.substring(8, 10);
		var yYear=fechaFin.substring(0,4);
		var yMonth=fechaFin.substring(5, 7);
		var yDay=fechaFin.substring(8, 10);
		if (yYear<xYear ){
    		mensajeSis("La Fecha Final debe ser Mayor a la Fecha Inicial.");
    		fechaHabilInicio(idControl,valorFechaSucursal);
    		$(jqControl).focus().select();
    		return false;
		}else{
			if (xYear == yYear){
				if (yMonth<xMonth){

					mensajeSis("La Fecha Final debe ser Mayor a la Fecha Inicial.");
					fechaHabilInicio(idControl,valorFechaSucursal);
					$(jqControl).focus().select();
		    		return false;
				}else{
					if (xMonth == yMonth){
						if (yDay<xDay){
							mensajeSis("La Fecha Final debe ser Mayor a la Fecha Inicial.");
							fechaHabilInicio(idControl,valorFechaSucursal);
							$(jqControl).focus().select();
	    		    		return false;

						}
					}
				}
			}
		}
	return true;
    }




//consulta el estatus del periodo contable con la fecha inicial que se ingresa
	function periodoContableFechaInicial(idControl){
		var jqfecha = eval("'#" + idControl + "'");
		var fecha = $(jqfecha).val();

		var tipoConsulta = catTipoConsultaEstatusFecha.estatus;
		setTimeout("$('#cajaLista').hide();", 200);
			var fechaBean = {
	      	'fecha':fecha,

			};
		if(fecha != '' ){
			periodoContableServicio.consulta(tipoConsulta, fechaBean, function(fechaEstatus){
				if(fechaEstatus!=null){
					if(fechaEstatus.status=='C'){
						mensajeSis("El Período Contable para la Fecha Seleccionada se encuentra Cerrado");
						$(jqfecha).focus();
					}else{
						periodoContableFechaFinal('fechaCargaFinal');
					}
				}else{
					mensajeSis("No Existe Periodo contable Vigente");
				}

			});
		}
	}

	//consulta el estatus del periodo contable con la fecha final que se ingresa
function periodoContableFechaFinal(idControl){
		var jqfecha = eval("'#" + idControl + "'");
		var fecha = $(jqfecha).val();

		var tipoConsulta = catTipoConsultaEstatusFecha.estatus;
		setTimeout("$('#cajaLista').hide();", 200);
			var fechaBean = {
	      	'fecha':fecha,
			};
		if(fecha != '' ){
			periodoContableServicio.consulta(tipoConsulta, fechaBean, function(fechaEstatus){
				if(fechaEstatus!=null){
					if(fechaEstatus.status=='C'){
						mensajeSis("El Período Contable para la Fecha Seleccionada se encuentra Cerrado");
						$(jqfecha).focus();
					}else{
						consultaEjeCierreMes();
					}
				}
			});
		}
	}

//consulta en parametros de sistema si se permiten hacer movimientos cuando el mes esta cerrado
function consultaEjeCierreMes(){

	var tipoConsulta = 1;
	var parametroBean = {
			'empresaID'	: 1
		};
	parametrosSisServicio.consulta(tipoConsulta, parametroBean, function(parametroBean) {
		if (parametroBean.tesoMovsCieMes == 'S'){
			enviarArchivo();

				}
				else{
					validaEjeCierreMes('fechaCargaInicial');
				}
		});
	}


//valida si la fecha corresponde a un mes que ya está cerrado.
function validaEjeCierreMes(idControl){
	var jqfecha = eval("'#" + idControl + "'");
	var Xfecha= $(jqfecha).val();
	var Yfecha=  parametroBean.fechaSucursal;
	if(esFechaValida(Xfecha)){
		if(Xfecha=='')$('#fechaCargaInicial').val(parametroBean.fechaSucursal);

		if ( menor(Xfecha, Yfecha) )
		{
			mensajeSis("No se permite realizar Operaciones de Meses anteriores al mes Actual");
		}else{
			enviarArchivo();
		}
	}else{

		mensajeSis("La Fecha no es valida");
		$('#fechaCargaInicial').val(parametroBean.fechaSucursal);
	}
	}


/*funcion valida fecha formato (yyyy-MM-dd)*/
function esFechaValida(fecha){

	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
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


function menor(fecha, fecha2){ // valida si fecha < fecha2
	var xMes=fecha.substring(5, 7);
	var xDia=fecha.substring(8, 10);
	var xAnio=fecha.substring(0,4);

	var yMes=fecha2.substring(5, 7);
	var yDia=fecha2.substring(8, 10);
	var yAnio=fecha2.substring(0,4);

	if (xAnio < yAnio){
		return true;
	}else{
		if (xAnio == yAnio){
			if (xMes < yMes){
				return true;
			}
		}else{
			return false ;
		}
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

// envia archivo de deposito referenciado
	function enviarArchivo(){
	if($('#institucionID').val()!="" && $('#institucionID').val()!= " "){
		if($('#cuentaBancaria').val()!="" && !isNaN($('#cuentaBancaria').val())){
			if($.trim($('#fechaCargaInicial').val())!="" && $.trim($('#fechaCargaFinal').val())!= ""){
				if(validarFormatoFecha('fechaCargaInicial', '-')){
					if(validarFormatoFecha('fechaCargaFinal', '-')){
						if(comparaFechas('fechaCargaInicial',$('#fechaCargaInicial').val(),$('#fechaCargaFinal').val())){
							subirArchivos();
						}
					}else{
						mensajeSis("Formato incorrecto para la fecha final");
					}
				}else{
					mensajeSis("Formato incorrecto para la fecha inicial");
				}
			}else{
				mensajeSis("Especificar el Rango de Fechas de Carga.");
				$('#fechaCargaInicial').focus();
			}
		}else{
			mensajeSis("Especificar Cuenta Bancaria");
			$('#cuentaBancaria').focus();
		}

	}else{
		mensajeSis("Especificar Institución");
		$('#institucionID').focus();
	}

	}

	//Apartir de aqui funciones del Grid que muestra los Depositos Referenciados del Archivo
	$('#btnProcesar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.guardaGrid);
		listaAplica();
	});

});
function listaAplica(){
	$('#listaAplicaRef').val('');
	$('tr[name=renglon]').each(function(index) {
		if(index>=0){
			var consecutivo = "#"+$(this).find("input[name^='consecutivo']").attr("id");
			var jqConse = "#"+$(this).find("input[name^='consecutivo']").attr("id");
			var jqRef = "#"+$(this).find("input[name^='referencia']").attr("id");
			var jqFecha = "#"+$(this).find("input[name^='fecha']").attr("id");
			var jqFech= ($(jqFecha).val()).replace(/-/g,'');
			var jqNumCtInst = "#"+$(this).find("input[name^='numCtaInstit']").attr("id");
			var jqmonto = "#"+$(this).find("input[name^='monto']").attr("id");
			var jqNat = "#"+$(this).find("input[name^='naturaleza']").attr("id");
			var jqDesc = "#"+$(this).find("input[name^='descripcion']").attr("id");
			var jqDep = "#"+$(this).find("input[name^='deposito']").attr("id");
			var jqMov = "#"+$(this).find("input[name^='tipoMov']").attr("id");
			var jqMon = "#"+$(this).find("input[name^='moneda']").attr("id");
			var jqCan = "#"+$(this).find("input[name^='canal']").attr("id");
			var jqTran = "#"+$(this).find("input[name^='transaccion']").attr("id");
			var jqMenVal = "#"+$(this).find("input[name^='validacion']").attr("id");
			var jqNumVal = "#"+$(this).find("input[name^='numVal']").attr("id");
			var jqNumIdenArchivo = "#"+$(this).find("input[name^='numIdenArchivo']").attr("id");
			var jqNumTran = "#"+$(this).find("input[name^='numTran']").attr("id");
			var jqFolioCargaID = "#"+$(this).find("input[name^='folioCargaID']").attr("id");
			var jqCheq = "#"+$(this).find("input[name^='seleccionaCheck']").attr("id");
			if($(jqCheq).attr('checked')==true){
				$('#listaAplicaRef').val($('#listaAplicaRef').val()+"["+
						$(jqConse).val()+"]"+
						$(jqRef).val()+"]"+
						jqFech+"]"+
						$(jqNumCtInst).val()+"]"+
						$(jqmonto).asNumber()+"]"+
						$(jqNat).val()+"]"+
						$(jqDesc).val()+"]"+
						$(jqDep).val()+"]"+
						$(jqMov).val()+"]"+
						$(jqMon).val()+"]"+
						$(jqCan).val()+"]"+
						$(jqTran).val()+"]"+
						$(jqMenVal).val()+"]"+
						$(jqNumVal).val()+"]"+
						$(jqNumIdenArchivo).val()+"]"+
						$(jqNumTran).val()+"]"+
						$(jqFolioCargaID).val()+"]");
			}
		}
	});
}// fin de funcion listaAplica

// funcion para contar el número de registros del grid
function totalFilasGrid(){
	var totalFilas=0;
	$('tr[name=renglon]').each(function() {
		totalFilas = totalFilas+1;
	});
	return totalFilas;
}

// funcion para contar el número de registros exitosos
function totalExitosos(){
	var totalExitos=0;
	$('input[name=consecutivo]').each(function() {
		var numero=  this.id.substr(11,this.id.length);
		var jqVal = eval("'validacion" + numero+ "'");
		var jqNumVal = eval("'numVal" + numero+ "'");
		if($('#'+jqVal).val()=="CORRECTO" || $('#'+jqNumVal).val()==3 || $('#'+jqNumVal).val()==4){
			totalExitos = totalExitos+1;
		}
	});
	return totalExitos;
}

// funcion para contar el número de registros fallidos
function totalFallidos(){
	var totalFallido=0;
	$('input[name=consecutivo]').each(function() {
		var numero=  this.id.substr(11,this.id.length);
		var jqVal = eval("'validacion" + numero+ "'");
		var jqNumVal = eval("'numVal" + numero+ "'");
		if($('#'+jqVal).val()!="CORRECTO" && $('#'+jqVal).val() != undefined){
			totalFallido = totalFallido+1;
		}
	});
	return totalFallido;
}

function cambiaColor(){
	var colorGreen = '#D0F5A9';
	$('input[name=consecutivo]').each(function() {
		var numero=  this.id.substr(11,this.id.length);
		var jqTr = eval("'renglon" + numero+ "'");
		var jqConse = eval("'consecutivo" + numero+ "'");
		var jqRef = eval("'referencia" + numero+ "'");
		var jqFecha = eval("'fecha" + numero+ "'");
		var jqmonto = eval("'monto" + numero+ "'");
		var jqVal = eval("'validacion" + numero+ "'");
		var jqNumVal = eval("'numVal" + numero+ "'");

		if($('#'+jqVal).val()=="CORRECTO" || $('#'+jqNumVal).val()==3 || $('#'+jqNumVal).val()==4){
			$('#'+jqTr).attr('bgcolor',colorGreen);
			$('#'+jqConse).attr('style','background-color: '+colorGreen);
			$('#'+jqRef).attr('style','background-color: '+colorGreen);
			$('#'+jqFecha).attr('style','text-align:center; background-color: '+colorGreen);
			$('#'+jqmonto).attr('style','text-align:right; background-color: '+colorGreen);
			$('#'+jqVal).attr('style','background-color: '+colorGreen);
		}
	});
}

function deshabIncorrectos(){
	$('input[name=consecutivo]').each(function() {
		var numero=  this.id.substr(11,this.id.length);
		var jqConse = eval("'consecutivo" + numero+ "'");
		var jqRef = eval("'referencia" + numero+ "'");
		var jqFecha = eval("'fecha" + numero+ "'");
		var jqmonto = eval("'monto" + numero+ "'");
		var jqVal = eval("'validacion" + numero+ "'");
		var jqCheq = eval("'seleccionaCheck" + numero+ "'");
		var jqNumVal = eval("'numVal" + numero+ "'");

		if($('#'+jqVal).val()=="CORRECTO" || $('#'+jqNumVal).val()==3 || $('#'+jqNumVal).val()==4){
			$('#'+jqCheq).attr('checked',true);
		} else {
			$('#'+jqConse).attr('disabled', 'disabled');
			$('#'+jqRef).attr('disabled', 'disabled');
			$('#'+jqFecha).attr('disabled', 'disabled');
			$('#'+jqmonto).attr('disabled', 'disabled');
			$('#'+jqVal).attr('disabled', 'disabled');
			$('#'+jqCheq).attr('disabled', 'disabled');
		}

	});
}
function ocultaGridDepositos(limpia){
	$('#formaGrid').hide();
	$('#gridDepositoArchivo').hide();
	if(limpia){
		$('#gridDepositoArchivo').html("");
	}
}

function verificaSeleccionados(){
	var totalSeleccionados=0;

	$('tr[name=renglon]').each(function() {

		var numero= this.id.substr(7,this.id.length);
		var jqSeleccionados= eval("'seleccionaCheck" + numero+ "'");

		if($('#'+jqSeleccionados).attr('checked')==true){
			$('#seleccionado'+numero).val('S');
			totalSeleccionados = totalSeleccionados+1;
		} else {
			$('#seleccionado'+numero).val('N');
		}

	});
	if(totalSeleccionados > 0){
		habilitaBoton('btnProcesar', 'submit');
	}else {

		deshabilitaBoton('btnProcesar', 'submit');
	}
}

function numTransaccionAnt(){
	$('input[name=consecutivo]').each(function() {
		var jqTransaccion = eval("'transaccion" +1+ "'");
		if($('#'+jqTransaccion).val()!=''){
			$('#numTranAnt').val($('#'+jqTransaccion).val());
		}
	});
}



function consultaGridDepositosRefe(numTransaccion, numErr, Archi, ControlID){
	var params = {};
	params['tipoLista'] = catTipoListaDepositos.listaDepositos;
	params['institucionID'] = $('#institucionID').val();
	params['cuentaAhoID'] = $('#cuentaBancaria').val();
	params['numTransaccion'] = numTransaccion;
	bloquearPantalla();
	if(numErr != 999){
		$.post("depositoArchivoGrid.htm", params, function(data){
			if(data.length >0) {
				ocultaGridDepositos(false);
				$('#gridDepositoArchivo').html(data);
				$('#tdBtnProcesar').hide();

				var total = totalFilasGrid();
				$('#totalRegistros').val(total);
				var totalExito= totalExitosos();
				$('#totalExitosos').val(totalExito);
				var totalFalla= totalFallidos();
				$('#totalFallidos').val(totalFalla);

				if(total>0){
					$('#formaGrid').show();
					$('#gridDepositoArchivo').show();
					$('#tdBtnProcesar').show();
					cambiaColor();
					deshabIncorrectos();
					verificaSeleccionados();
					numTransaccionAnt();
				}else{
					mensajeSis("No Existen Depositos para Aplicar.");
					ocultaGridDepositos(true);
				}
			}
			desbloquearPantalla();
		});
	} else {
		mensajeSis("Error al cargar el Archivo. Verifique el Formato.");
		ocultaGridDepositos(true);
		desbloquearPantalla();
	}
}
//funcion que habilita el boton Aplicar Pagos
function seleccionarDeposito(){
	var totalSeleccionados=0;
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqaplicaPago= eval("'seleccionaCheck" + numero+ "'");
		if($('#'+jqaplicaPago).attr('checked')==true){
			$('#seleccionado'+numero).val('S');
			totalSeleccionados = totalSeleccionados+1;
			$('#seleccionaCheck'+numero).val($('#folioCargaID'+numero).val());
		} else {
			$('#seleccionado'+numero).val('N');
		}
	});

	if(totalSeleccionados > 0){
		habilitaBoton('btnProcesar', 'submit');
	}else {
		mensajeSis("Debe Seleccionar un Registro");
		deshabilitaBoton('verDeposito', 'submit');
		deshabilitaBoton('btnProcesar', 'submit');
	}

}

/***********************************/
//funcion para calcular el dia habil anterior
function fechaHabilInicio(idcontrol,fecha){
	var jqControl = eval("'#"+idcontrol+"'");
	var diaFestivoBean = {
			'fecha':fecha,
			'numeroDias':1,
			'salidaPantalla':'S'
	};
	diaFestivoServicio.calculaDiaFestivo(2,diaFestivoBean,function(diaAnt) {
		if(diaAnt!=null){
			$(jqControl).val(diaAnt.fecha);
		}else{
			$(jqControl).val(parametroBean.fechaSucursal);
		}
	});

}

function consultaCargaLayoutXLSDepRef(){

	var tipoConsulta = 31;
	var parametroBean = { 
		'empresaID'	: 1		
	};		

	$('#cargaLayoutXLSDepRef').val('N');
	parametrosSisServicio.consulta(tipoConsulta, parametroBean, function(parametroBean) {
		if(parametroBean != null){
			$('#cargaLayoutXLSDepRef').val(parametroBean.cargaLayoutXLSDepRef);
		}
	});
}

function funcionExito(){
	deshabilitaBoton('enviar', 'submit');
	var valorFechaSucursal = parametroBean.fechaSucursal;

	$('#institucionID').val('');
	$('#nombreInstitucion').val('');
	$('#cuentaBancaria').val('');
	$('#nombreBanco').val('');
	$('#listaAplicaRef').val('');

	fechaHabilInicio('fechaCargaInicial',valorFechaSucursal);
	fechaHabilInicio('fechaCargaFinal',valorFechaSucursal);

	$('#radioFormatoBanco').attr('checked',false);
	$('#radioFormatoEstandar').attr('checked',true);
	$('#tipoReferenciaCredito').attr('checked',true);
	$('#tipoReferenciaCuenta').attr('checked',false);
	$('#tipoReferenciaCliente').attr('checked',false);

	ocultaGridDepositos(true);
}

function funcionError(){
	deshabilitaBoton('enviar', 'submit');
	$('#institucionID').val('');
	$('#nombreInstitucion').val('');
	$('#cuentaBancaria').val('');
	$('#nombreBanco').val('');
	$('#listaAplicaRef').val('');

	$('#radioFormatoBanco').attr('checked',false);
	$('#radioFormatoEstandar').attr('checked',true);
	$('#tipoReferenciaCredito').attr('checked',true);
	$('#tipoReferenciaCuenta').attr('checked',false);
	$('#tipoReferenciaCliente').attr('checked',false);

	ocultaGridDepositos(true);
}

function validaEjecucionMesAnterior(){
	var numConsulta = 103;
	paramGeneralesServicio.consulta(numConsulta,{},{async: false, callback:function(parametro) {
		if (parametro != null) {
			$('#depRefMesAnterior').val(parametro.valorParametro);
		} else {
			$('#depRefMesAnterior').val(catConstantes.Str_No);
		}
	}});
}

function validaCargaMesAnterior(){
	var fechaSisInicio = generaTipoFecha($('#fechaSistema').val(),catTipoFecha.inicio);
	var fechaSisFin = generaTipoFecha($('#fechaSistema').val(),catTipoFecha.fin);
	if($('#depRefMesAnterior').val() === catConstantes.Str_No){
		if(!((fechaSisInicio <= $('#fechaCargaInicial').val() && $('#fechaCargaInicial').val() <= fechaSisFin)
			&& (fechaSisInicio <= $('#fechaCargaFinal').val() && $('#fechaCargaFinal').val() <= fechaSisFin))){
			mensajeSis('No se puede Aplicar Depósitos en Meses Anteriores a la Fecha del Sistema.');
			return false;
		} else {
			return true;
		}
	} else {
		return true;
	}
}

function generaTipoFecha(fecha,tipo){
	var fechaGenerada ='1900-01-01';
	var anio= fecha.substring(0,4);
	var mes = fecha.substring(5,7);
	var dia = fecha.substring(8,10);
	if(fecha.trim() != ''){
		fechaGenerada = (anio + '-' + mes + (tipo === catTipoFecha.inicio ? '-01' : '-31'));
	} else {
		fechaGenerada = '1900-01-01';
	}
	return fechaGenerada;
}

//FUNCION PARA MOSTRAR MENSAJES DE AYUDA
function descripcionCampo(idCampo){	
	var data;	
	switch(idCampo) {
	    case 'formatoBanco':
	    	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 			
			'<table id="tablaLista">'+
				'<tr align="center">'+
				'<td id="contenidoAyuda" align="center">'+
				'<b> Formato de banco Estandar '+
				'</b>'+
				'</td>'+
				'</tr>'+
				'<tr>'+
				'<td>'+
					'<table id="tablaLista">'+
						'<tr>'+
							'<td id="encabezadoAyuda"><b>'+
							'NumCtaInstit'+
							'</b></td>'+
							'<td id="encabezadoAyuda"><b>'+
							'Fecha(yyyy-MM-dd)'+
							'</b></td>'+
							'<td id="encabezadoAyuda"><b>'+
							'ReferenciaDeposito'+
							'</b></td>'+
							'<td id="encabezadoAyuda"><b>'+
							'Descripcion'+
							'</b></td>'+
							'<td id="encabezadoAyuda"><b>'+
							'Naturaleza'+
							'</b></td>'+
							'<td id="encabezadoAyuda"><b>'+
							'Monto'+
							'</b></td>'+
							'<td id="encabezadoAyuda"><b>'+
							'MontoPendienteAplicar'+
							'</b></td>'+
							'<td id="encabezadoAyuda"><b>'+
							'Canal'+
							'</b></td>'+
							'<td id="encabezadoAyuda"><b>'+
							'TipoDeposito'+
							'</b></td>'+
							'<td id="encabezadoAyuda"><b>'+
							'Moneda'+
							'</b></td>'+
						'</tr>'+
					'</table>'+
				'</td>'+
				'</tr>'+
			'</table>'+
			'</fieldset>'; 
	        break;
	    default:
	    	data = "";
	} 
	
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
             top:  ($(window).height() - 400) /2 + 'px', 
             left: ($(window).width() - 700) /2 + 'px', 
             width: '700px' 
         } });  
$('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}
