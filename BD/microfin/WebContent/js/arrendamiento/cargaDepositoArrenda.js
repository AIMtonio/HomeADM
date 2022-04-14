$(document).ready(function() {
	esTab = true;
	var listaVisible=false;
	//Definicion de Constantes y Enums  
	var catTipoTransaccion = {   
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

	var  catTipoConsultaEstatusFecha={
			'estatus' :4
	};	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('enviar', 'submit');
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();
	fechaHabilInicio('fechaCargaInicial',parametroBean.fechaSucursal);
	fechaHabilInicio('fechaCargaFinal',parametroBean.fechaSucursal);
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

	// se valida que la fecha de carga no sea superior a la fecha del sistema
	$('#fechaCargaInicial').change(function() {
		if($('#fechaCargaInicial').val().trim() != ""){
			comparaFechas(this.id,$('#fechaCargaInicial').val(),$('#fechaCargaFinal').val());
		}
	});

	// se valida que la fecha de carga no sea superior a la fecha del sistema
	$('#fechaCargaFinal').change(function() {
		if($('#fechaCargaFinal').val().trim() !=""){
			validarFecha(this.id);
			comparaFechas(this.id,$('#fechaCargaInicial').val(),$('#fechaCargaFinal').val());
		}
	});
	
	$('#fechaCargaFinal').blur(function() {
		if($('#fechaCargaFinal').val().trim() !=""){
			validarFecha(this.id);
			comparaFechas(this.id,$('#fechaCargaInicial').val(),$('#fechaCargaFinal').val());
		}
		if((isNaN($('#institucionID').val()) || $('#institucionID').val() == '') 
				|| (isNaN($('#cuentaBancaria').val()) || $('#cuentaBancaria').val() == '') ){
			if (esTab) {
				$('#institucionID').focus();
			}
		}
	});

	$('#fechaCarga').change(function() {
		var Xfecha= $('#fechaCarga').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaCarga').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Carga debe ser menor o igual a la Fecha del Sistema.")	;
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
		periodoContableFechaInicial('fechaCargaInicial');
	});
	
	$('#enviar').blur(function() {
		if (esTab) {
			$("#institucionID").focus();
		}
	});

	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#institucionID').blur(function() {
		if( ($('#institucionID').val().trim() == '9' || $('#institucionID').val().trim() == '24') && $('#radioFormatoBanco').is(':checked') ){
			$('#canales').show();
		}else{
			$('#canales').hide();
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
				required : 'Especificar la institucion',
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
					mensajeSis("No se encontro la Institucion");
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
					mensajeSis("No se encontro la cuenta bancaria.");
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
		//	var dominio = document.domain; 
		var url ="depRefereSubArcArrenda.htm"+
		"?ins="+$('#institucionID').val()+"&ctaB="+$('#cuentaBancaria').val() +
		"&cta="+$('#cuentaAhoID').val()+"&fecIni="+$('#fechaCargaInicial').val()+
		"&be="+$('#bancoEstandar').val()+
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
			mensajeSis("formato de fecha no valido (aaaa-mm-dd)");
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
			mensajeSis("Fecha introducida erronea.");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida erronea.");
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
					mensajeSis("El Periodo Contable para la Fecha Seleccionada se encuentra Cerrado");
					$(jqfecha).focus();
				}else{
					periodoContableFechaFinal('fechaCargaFinal');
				}
			}else{
				mensajeSis("No Existe Periodo contable Vigente...");
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
					mensajeSis("El Periodo Contable para la Fecha Seleccionada se encuentra Cerrado");
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
		}else{
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
			mensajeSis("Formato de Fecha No Valido (aaaa-mm-dd)");
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
			mensajeSis("Fecha introducida erronea.");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida erronea.");
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
						if(comparaFechas('enviar',$('#fechaCargaInicial').val(),$('#fechaCargaFinal').val())){
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
	
	
});