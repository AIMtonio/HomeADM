	esTab = true;
	var listaVisible=false;
	//Definicion de Constantes y Enums  
	var catTipoTransaccionTesoMvts = {   
			'procesa':'1',
			'limpia':'2'	};

	var catTipoConsultaTesoMvts = {
			'principal'	: 1,
			'foranea'	: 2
	};	

	var catTipoConsultaInstituciones = {
			'principal':1, 
			'foranea':2
	};

	var diaHabilAnterior = '2'; // Indica Dia habil Anterior
	
	var  catTipoConsultaEstatusFecha={
			'estatus' :4,
			'fecha' :5
	};
	var catFormatoBancos = {
		'BANCO' : 'B',
		'ESTANDAR': 'E'
	};
	var catBancos = {
		'BANAMEX' : 9,
		'BANORTE' : 24,
		'BANCOMER': 37
	};

$(document).ready(function() {
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	parametroBean = consultaParametrosSession();
	limpiarCampos();
	
	$('#fechaCarga').val(parametroBean.fechaAplicacion);
	$('#institucionID').focus();
	

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
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'institucionID');
		}
	});
	
	$('#obtenerArchivo').click(function() {		
		periodoContableFechaInicial('fechaCargaInicial');
	});

	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '1', '1', 'nombre',$('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#institucionID').blur(function() {
		if($('#institucionID').val() != '' && !isNaN($('#institucionID').val()) ){
			consultaInstitucion(this.id);
			ocultaTRVersion();
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
		listaVisible=true;
	});

	$('#cuentaBancaria').blur(function() {
		 
			if($('#cuentaBancaria').val() != '' ){
				consultaCuentaBan(this.id);	
			} 
		 
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
	

	// Funcion de Click a los radio para escoger el formato en el que se subira el archivo
	$('#radioFormatoBanco').click(function(){ 
		if($('#radioFormatoBanco').is(':checked')){  
			$('#radioFormatoEstandar').attr('checked',false);
			$('#bancoEstandar').val($('#radioFormatoBanco').val());
			ocultaTRVersion();
		}
	});

	$('#radioFormatoEstandar').click(function(){ 
		if($('#radioFormatoEstandar').is(':checked')){  
			$('#radioFormatoBanco').attr('checked',false);
			$('#bancoEstandar').val($('#radioFormatoEstandar').val());
			ocultaTRVersion();
		}
	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			institucionID: 'required',
			cuentaAhoID: 'required',
			fechaCargaInicial: {
				required: true,
				date: true
			},
			fechaCargaFinal: {
				required: true,
				date: true
			},
			file: 'required'
		},

		messages: {
			institucionID: 'Especifique la Institución.',
			cuentaAhoID: 'Especifique Cuenta de Ahorro.',
			fechaCargaInicial: {
				required:       'Especifique Fecha de Inicio.',
				date:           'Fecha Incorrecta.'
			},
			fechaCargaFinal: {
				required:       'Especifique Fecha de Inicio.',
				date:           'Fecha Incorrecta.'
			},
			file: 'Se requiere un Archivo para subir.'
		}
	});


	// Funciones

	//Método de consulta de Institución
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var institutoBeanCon = {
				'institucionID':numInstituto
		};
		if(numInstituto != '' && !isNaN(numInstituto) ){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea, institutoBeanCon, function(instituto){
				if(instituto!=null){							
					$('#nombreInstitucion').val(instituto.nombre);		
					$('#cuentaBancaria').val("");
					$('#nombreBanco').val("");
				}else{
					mensajeSis("No Existe la Institución."); 
					limpiarCampos();
					$(jqInstituto).focus();
					$(jqInstituto).select();
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
		if(  !isNaN($('#cuentaBancaria').val())){		
			operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
				if(data!=null){
					$('#cuentaAhoID').val(data.cuentaAhorro);
					$('#nombreBanco').val(data.nombreCuentaInst);
				}else{
					mensajeSis("La Cuenta Indicada no esta Asociada con la Institución.");
					$(jqCuentaBan).focus();
					$(jqCuentaBan).select();
				}
			});
		}
	}
	
	
	
	//consulta el estatus del periodo contable con la fecha inicial que se ingresa 
	function periodoContableFechaInicial(idControl){	
		
		var jqfecha = eval("'#" + idControl + "'");
		var fecha = $(jqfecha).val();	
	 
		var tipoConsulta = catTipoConsultaEstatusFecha.fecha;		
		setTimeout("$('#cajaLista').hide();", 200);		
			var fechaBean = {
	      	'fecha':fecha,
	      	
			};		
		if(fecha != '' ){
			periodoContableServicio.consulta(tipoConsulta, fechaBean, function(fechaEstatus){	
				if(fechaEstatus!=null){
						periodoContableFechaFinal('fechaCargaFinal');
					}
				else{
					mensajeSis("No Existe Periodo contable Vigente.");
				}
			});
		}
	}
	
	//consulta el estatus del periodo contable con la fecha final que se ingresa 
function periodoContableFechaFinal(idControl){
		var jqfecha = eval("'#" + idControl + "'");
		var fecha = $(jqfecha).val();	
	
		var tipoConsulta = catTipoConsultaEstatusFecha.fecha;		
		setTimeout("$('#cajaLista').hide();", 200);		
			var fechaBean = {
	      	'fecha':fecha,
			};		
		if(fecha != '' ){
			periodoContableServicio.consulta(5, fechaBean, function(fechaEstatus){			
				if(fechaEstatus!=null){
						consultaEjeCierreMes();
				}
			});
		}
	}


//consulta en parametros de sistema si la fecha corresponde a un mes que ya está cerrado.
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



function validaEjeCierreMes(idControl){
	var jqfecha = eval("'#" + idControl + "'");
	var Xfecha= $(jqfecha).val(); 
	var Yfecha=  parametroBean.fechaSucursal;
	if(esFechaValida(Xfecha)){
		if(Xfecha=='')$('#fechaCargaInicial').val(parametroBean.fechaSucursal);

		if ( menor(Xfecha, Yfecha) )
		{
			mensajeSis("No se permite realizar Operaciones de Meses anteriores al mes Actual.");
		}else{
			enviarArchivo();
		}
	}else{
		
		mensajeSis("La Fecha no es valida.");
		$('#fechaCargaInicial').val(parametroBean.fechaSucursal);
	}
	}



	// envia archivo de conciliacion 
	function enviarArchivo(){

		if($('#institucionID').val()!="" && $('#institucionID').val()!= " "){
			if($('#cuentaBancaria').val()!="" && !isNaN($('#cuentaBancaria').val())){
				if($.trim($('#fechaCargaInicial').val())!="" && $.trim($('#fechaCargaFinal').val())!= ""){
					if($('#radioFormatoBanco').is(':checked')||$('#radioFormatoEstandar').is(':checked')){  
						if(validarFormatoFecha('fechaCargaInicial', '-')){
							if(validarFormatoFecha('fechaCargaFinal', '-')){
							if(comparaFechas('enviar',$('#fechaCargaInicial').val(),$('#fechaCargaFinal').val())){
						
								subirArchivos();
							}
							}else{
								mensajeSis("Formato incorrecto para la Fecha Final.");
							}
						}else{
							mensajeSis("Formato incorrecto para la Fecha Inicial.");
						}
					}else{
						mensajeSis("Especifique Formato.");
						$('#radioFormatoEstandar').focus();	
					}
				}else{
					mensajeSis("Especifique el Rango de Fechas de Carga.");
					$('#fechaCargaInicial').focus();
				}	
			}else{
				mensajeSis("Especifique Cuenta Bancaria.");
				$('#cuentaBancaria').focus();
			}		   
		}else{
			mensajeSis("Especifique Institución.");
			$('#institucionID').focus();
		}
	}
	
	
	
	
	// Funcion para Abrir Ventana procesar informacion del Archivo
	function subirArchivos() {
		var url ="tesoMovsConciliaSubirArch.htm"+
		"?ins="+		$('#institucionID').val()+
		"&ctaB="+		$('#cuentaBancaria').val() +
		"&version="+	getVersionFormato() +
		"&fec="+		$('#fechaCarga').val()+
		"&be="+			$('#bancoEstandar').val()+
		"&fecI="+		$('#fechaCargaInicial').val()+
		"&fecF="+		$('#fechaCargaFinal').val();
		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

		ventanaArchivosCuenta = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
				"left="+leftPosition+
				",top="+topPosition+
				",screenX="+leftPosition+
				",screenY="+topPosition);	
	}

	// Funcion para limpiar los campos de la pantalla 
	function limpiarCampos(){ 
		agregaFormatoControles('formaGenerica');
		inicializaForma('formaGenerica','institucionID' );

		fechaHabilInicio('fechaCargaInicial',parametroBean.fechaSucursal);
		fechaHabilInicio('fechaCargaFinal',parametroBean.fechaSucursal);

		// se inicializa los radio para que quede por default el formato Estandar
		if($('#radioFormatoBanco').is(':checked')){  
			$('#radioFormatoBanco').attr('checked',false);
			$('#radioFormatoEstandar').attr('checked',true);
		}
		if($('#radioFormatoEstandar').is(':checked')){  
			$('#radioFormatoBanco').attr('checked',false);
		}	
	}

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
		var anioFechaCarga	= valorFechaCarga.substr(0,4);
		var mesFechaCarga = valorFechaCarga.substr(5,2);
		var diaFechaCarga = valorFechaCarga.substr(8,2);
		var separadorUnoFechaCarga = valorFechaCarga.substr(4,1);
		var separadorDosFechaCarga = valorFechaCarga.substr(7,1);

		if(separadorUnoFechaCarga == "-"){
			if(separadorDosFechaCarga == "-"){
				if(anioFechaCarga>anioFechaSucursal){  
					mensajeSis("La Fecha de Carga no puede ser superior \n a la Fecha del Sistema.");
					$(jqvalorFechaCarga).focus().select();
					fechaHabilInicio(idcontrol,valorFechaSucursal);
				}else{
					if(anioFechaCarga==anioFechaSucursal){ 
						if(mesFechaCarga>mesFechaSucursal){ 
							mensajeSis("La Fecha de Carga no puede ser superior \n a la Fecha del Sistema.");
							$(jqvalorFechaCarga).focus().select();
							fechaHabilInicio(idcontrol,valorFechaSucursal);
						}else{
							if(mesFechaCarga==mesFechaSucursal){
								if(diaFechaCarga>diaFechaSucursal){
									mensajeSis("La Fecha de Carga no puede ser superior \n a la Fecha del Sistema.");
									$(jqvalorFechaCarga).focus().select();
									fechaHabilInicio(idcontrol,valorFechaSucursal);	        
								}
							}
						}	
					}
				}
			}else{
				mensajeSis("Formato de Fecha incorrecto 'aaaa-mm-dd'.");
				$(jqvalorFechaCarga).focus().select();
				fechaHabilInicio(idcontrol,valorFechaSucursal);
			}
		}else{
			mensajeSis("Formato de Fecha incorrecto 'aaaa-mm-dd'.");
			$(jqvalorFechaCarga).focus().select();
			fechaHabilInicio(idcontrol,valorFechaSucursal);
		}

	}
	
	
function validarFormatoFecha(idcontrol, separador){
	var resultado = true ;
	var jqvalorFechaCarga	= eval("'#"+idcontrol+"'");
	var linea	= $(jqvalorFechaCarga).val();
	var arreglo = null;
	var dia = 0 ;
	var mes = 0 ;
	var anio = 0 ;
	var	fecha2 	= null;
	try{
		
		arreglo = linea.trim().split("-");
		dia 	= Number(arreglo[2]);
		mes 	= Number(arreglo[1]);
		anio 	= Number(arreglo[0]);
		fecha2 	= new Date(anio,mes,0);
		
		if(dia <= fecha2.getDate() ){
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
});


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
var parametroBean = consultaParametrosSession();

function ocultaTRVersion(){
	var institucionID = $('#institucionID').asNumber();
	var formatoBanco = ($('#radioFormatoBanco').is(':checked') ? catFormatoBancos.BANCO : catFormatoBancos.ESTANDAR);
	if(formatoBanco === catFormatoBancos.ESTANDAR){
		$('#trVersion').hide();
	} else {
		switch(institucionID){
			case catBancos.BANAMEX:
			case catBancos.BANORTE:
			case catBancos.BANCOMER:
				$('#trVersion').show();
				break;
			default:
				$('#trVersion').hide();
				break;
		}
	}
}
function getVersionFormato(){
	return $('input[name=versionFormato]:checked').val();
}