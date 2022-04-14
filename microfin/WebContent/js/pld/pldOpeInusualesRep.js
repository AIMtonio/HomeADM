var TipoFormatoReporte = 1;

$(document).ready(function() {
	//Definicion de Constantes y Enums
	var catTipoActReporteInus = {
  		'generaArch':'3',
  		'grabaFolioSITI':'4'
  	};
	var catTipoTraFolioSITI = {
	  		'alta':'1'
		  };

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	 deshabilitaBoton('generarArchivo', 'submit');
	 deshabilitaBoton('reporteFinalizado', 'submit');
	 deshabilitaBoton('descargar', 'submit');

	 agregaFormatoControles('formaGenerica');
	 consultaOficialCumplimiento();
	 consultaFormatoReporte();
	 
	var clienteSofi = 15;  // Número de cliente que corresponde a SOFI EXPRESS.
	var numeroCliente = 0;
	numeroCliente = consultaClienteEspecifico();

	if (numeroCliente == clienteSofi) {
		$('#trOperaciones').show();
	}else{
		$('#trOperaciones').hide();
	}

	$.validator.setDefaults({
            submitHandler: function(event) {
            grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','fechaActual', 'exitoOpeInusuales', 'falloOpeInusuales');
            }
    });


	 var parametroBean = consultaParametrosSession();
      $('#fechaActual').val(parametroBean.fechaSucursal);

      $('#rutaArchivosPLD').val(parametroBean.rutaArchivosPLD);

      $('#generarArchivo').click(function(e) {
			if(validaRenglones()){
			$('#tipoActualizacion').val(catTipoActReporteInus.generaArch);
			$('#tipoTransaccion').val();
			guardarGridOperacionesIn(e);
		}
	});

  	$('#reporteFinalizado').click(function() {
  		var folioInterno=verificaSeleccionadosFolioInterno();
  		if(folioInterno !=0){
  			$('#divFolioSITI').hide();
  			inicializaForma('divFolioSITI');
  			mensajeSis("Usted a Cambiado la Seleccion de Operaciones a Enviar,  vuelva a generar el Archivo TXT");
  		}else{
  			$('#divFolioSITI').show();
  		}
	});
  	$('#guardar').click(function(event) {
  		var folioInterno=verificaSeleccionadosFolioInterno();
  		if(folioInterno !=0){
			mensajeSis("Usted a Cambiado la Seleccion de Operaciones a Enviar, vuelva a generar el Archivo TXT");
  			event.preventDefault();
  		}else{
  			$('#tipoActualizacion').val(catTipoActReporteInus.grabaFolioSITI);
  			$('#tipoTransaccion').val(catTipoTraFolioSITI.alta);
  		}

	});



	$('#generarNombre').click(function() {
		construyeNom();
		deshabilitaBoton('generarNombre', 'submit');
		habilitaBoton('generarArchivo', 'submit');
		var archivoGenerado=verificaFolioInterno();
	 	if(archivoGenerado !=0){
	 		habilitaBoton('reporteFinalizado', 'submit');
	 	}
	});

	$('#generarExcel').click(function(e) {
		$('#tipoActualizacion').val(catTipoActReporteInus.generaArch);
		$('#tipoTransaccion').val();
		guardarGridOperacionesIn(e);
		generaReporte();
	});


	$('#descargar').click(function() {
		descargarArchivo();
	});
  	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			fechaGeneracion: {
				required: true,
				date: true,
			},
		},
		messages: {
			fechaGeneracion: {
				required: 'Especifica Fecha.',
				date: 'Fecha incorrecta',
			},
		}
	});

	// se construye la cadena de datos del grid a guargar
	function guardarGridOperacionesIn(event){
		 var folioInterno= ($('#fechaActual').val()).replace('-','');
	      var folioIn= folioInterno.replace('-','');
 		var mandar = verificarvacios();

 		if(mandar!=1){
			var numFilas = consultaFilas();

			$('#datosOperInusuales').val("");
			for(var i = 1; i <= numFilas; i++){
				if($('#reportar'+i).attr('checked')==true ){
					if(i == 1){
						$('#datosOperInusuales').val($('#datosOperInusuales').val() +
						document.getElementById("opeInusualID"+i+"").value + ']' +
						folioIn);
					}else{
						$('#datosOperInusuales').val($('#datosOperInusuales').val() + '[' +
						document.getElementById("opeInusualID"+i+"").value + ']' +
						folioIn);

					}
				}//check
			}//for
		}
		else{
			mensajeSis("Faltan Datos");
			event.preventDefault();
		}
	}


	// verificamos que no existan campos vacios en el grid de operaciones inusuales
	function verificarvacios(){
		quitaFormatoControles('divOperInusuales');
		var numfilas = consultaFilas(); //aaa

		$('#datosOperInusuales').val("");
		for(var i = 1; i <= numfilas; i++){
 			var idopeInusual = document.getElementById("opeInusualID"+i+"").value;

 			if (idopeInusual ==""){
 				document.getElementById("opeInusualID"+i+"").focus();
				$(idopeInusual).addClass("error");
 				return 1;
 			}
		}
	}
	
	// Función para consultar el Cliente Especifico
	function consultaClienteEspecifico() {
		var numeroCliente = 0;
		paramGeneralesServicio.consulta(13, {
			async: false, callback: function (valor) {
				if (valor != null) {
					numeroCliente = valor.valorParametro;
				}
			}
		});
		return numeroCliente;
	}

}); //cerrar

	var catTipoConReporteInus = {
  		'principal'		: 1,
  		'nomArch'		: 2,
  		'generaArch'	: 1,

	};

// Funciones para del reporte
function exitoOpeInusuales(){

	if(	$('#tipoActualizacion').val()==3){
		consultaListaOperInuasuales();		// consultar el grid de operaciones inusuales
	}else{

		consultaListaOperInuasuales();		// consultar el grid de operaciones inusuales
	}
	habilitaBoton('descargar', 'submit');
	/*Genera y descarga el archivo en xml*/
	if($('#tipoActualizacion').val()==3){
		if(Number(TipoFormatoReporte) == 2){
			generaReporteXML();
		}
	}
}

function falloOpeInusuales(){

}



//---Funcion construyeNombre  (2693966130906.002)
function construyeNom() {
	var valorFecha= $('#fechaActual').val();
	var repInuausalesBeanCon = {
				'fecha':valorFecha
		};
	setTimeout("$('#cajaLista').hide();", 200);
	if (valorFecha != '') {
		opeInusualesServicio.consulta(2,repInuausalesBeanCon, function(arch) {
					if (arch != null) {
						$('#nombreArchivo').val(arch.nombreArchivo);
					}
					else{
						mensajeSis("Error al Generar el Nombre del Archivo");
					}
				});
	}
}

//Consulta Lista de Operaciones Inusuales para ser reportadas con con estatus 3
consultaListaOperInuasuales();
function consultaListaOperInuasuales(){
	agregaFormatoControles('divOperInusuales');
	var params = {};
	params['tipoLista'] = 2;
	$.post("pldOpeInusualesGridVista.htm", params, function(data){
		if(data.length >0) {
			$('#divOperInusuales').html(data);
			$('#divOperInusuales').show();

			seleccionar();
			verificaSiHaySeleccionados();

		}else{
			$('#divOperInusuales').html("");
			$('#divOperInusuales').show();
		}

	});

}


//por cada renglon selecciona las operaciones inusuales ya reportadas(Si  es que ya tienen folio Interno)
function seleccionar(){
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIDFolio = eval("'folioInterno" + numero+ "'");

		var valorFolioReportado= document.getElementById(jqIDFolio).value;

		if(valorFolioReportado !='' && valorFolioReportado !=0){
			$('#reportar'+numero).attr('checked',true);
		}else{
			$('#reportar'+numero).attr('checked',false);
		}
	});

}


//dar click en el boton Seleccionar todo
function seleccionarTodo() {
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
			$('#reportar'+numero).attr('checked',true);
	});
	verificaSiHaySeleccionados();
}
//al dar clic en el boton quitar todo
function quitarTodo() {
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
			$('#reportar'+numero).attr('checked',false);
	});
	verificaSiHaySeleccionados();
}

// al dar clic en enviar habilita boton generar reporte, y si cambia la seleccion de las operaciones a enviar oculta el form
//para enviar el Folio SITI
function verificaSiHaySeleccionados(){
	var folioInterno=verificaSeleccionadosFolioInterno();
	var archivoGenerado=verificaFolioInterno();
		if(folioInterno !=0){
			$('#divFolioSITI').hide();
			inicializaForma('divFolioSITI');
		}

	var numSeleccionados=cuentaSeleccionados();
 	if(numSeleccionados==0){
 		deshabilitaBoton('generarArchivo', 'submit');
 		deshabilitaBoton('reporteFinalizado', 'submit');
 		$('#divFolioSITI').hide();
 		inicializaForma('divFolioSITI');
 	}else if($('#nombreArchivo').val()!=''){
 		habilitaBoton('generarArchivo', 'submit');
 	}

 	if(archivoGenerado !=0 && $('#nombreArchivo').val()!=''){
 		habilitaBoton('reporteFinalizado', 'submit');
 	}

}


//cuenta cuantas operaciones estan seleccionadas
function cuentaSeleccionados(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdReportar = eval("'reportar" + numero+ "'");
		if($('#'+jqIdReportar).attr('checked')==true){
			totales++;

		}
	});
	return totales;
}


//cuenta total de filas del grid de Operaciones inusuales
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;

	});
	return totales;
}



// verifica si se cambia la seleccion  de operaciones
function verificaSeleccionadosFolioInterno(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdReportar = eval("'reportar" + numero+ "'");
		var jqIdFolioInterno = eval("'folioInterno" + numero+ "'");
		var valorFolioInterno=$('#'+jqIdFolioInterno).val();

		if(($('#'+jqIdReportar).attr('checked')==true && valorFolioInterno==0 )|| ($('#'+jqIdReportar).attr('checked')==false && valorFolioInterno !=0)){
			totales++;
		}
	});
	return totales;
}


//indica que ya se puede registrar el folio SITI ya que se ha generado una rchivo
function verificaFolioInterno(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdReportar = eval("'reportar" + numero+ "'");
		var jqIdFolioInterno = eval("'folioInterno" + numero+ "'");
		var valorFolioInterno=$('#'+jqIdFolioInterno).val();

		if(($('#'+jqIdReportar).attr('checked')==true && valorFolioInterno!=0 )){
			totales++;
		}
	});
	return totales;
}

function generaReporte(){
	var tipoReporte 		= 2; // reporte op. inusuales
	var tituloReporte 		= 'REPORTE DE OPERACIONES INUSUALES AL DÍA '+ $('#fechaActual').val() + '.';
	var fechaActual 		= $('#fechaActual').val();
	var operaciones 		= $("#operaciones option:selected").val();
	var periodoID 			= $('#periodoID').val();
	var periodoInicio 		= $('#periodoInicio').val();
	var periodoFin 		 	= $('#periodoFin').val();
	var archivo 		 	= $('#archivo').val();

	var tipoActualizacion 	= $('#tipoActualizacion').val();
	var usuario 	 		= parametroBean.claveUsuario;
	var nombreInstitucion 	= parametroBean.nombreInstitucion;
	var datosOperInusuales 	= $('#datosOperInusuales').val();
	
	var descOperaciones;
	if(operaciones == ""){
		descOperaciones = 'TODOS';
	}else{
		descOperaciones = $("#operaciones option:selected").html();
	}

	var liga = 'reporteSITIExcel.htm?'+
			'tituloReporte='+tituloReporte+
			'&fechaGeneracion='+fechaActual+
			'&operaciones='+operaciones+
			'&descOperaciones='+descOperaciones+
			'&periodoID='+periodoID+
			'&periodoInicio='+periodoInicio+
			'&periodoFin='+periodoFin+
			'&archivo='+archivo+
			'&tipoActualizacion='+tipoActualizacion+
			'&datosOperInusuales='+datosOperInusuales+
			'&fechaSistema='+fechaActual+
			'&nombreUsuario='+usuario.toUpperCase()+
			'&tipoReporte='+tipoReporte+
			'&nombreInstitucion='+nombreInstitucion.toUpperCase();
	window.open(liga, '_blank');
}
/**
 * Regresa el número de renglones seleccionados de un grid.
 * @returns Número de renglones seleccionados de la tabla.
 *
 */
function getRenglonesSelec(){
	var numRenglones=0;
	$('#miTabla >tbody >tr[name^="renglon"]').each(function() {
		var jqCheq = "#"+$(this).find("input[name^='reportar']").attr("id");
		if($(jqCheq).attr('checked')==true){
			numRenglones++;
		}
	});
	return numRenglones;
}
/**
 * Regresa el número de renglones de un grid.
 * @returns Número de renglones de la tabla.
 *
 */
function getRenglones(){
	// Renglones en el grid (todos).
	var numRenglones = $('#miTabla >tbody >tr[name^="renglon"]').length;
	return numRenglones;
}
/**
 * Valida si existen operaciones para poder generar el reporte.
 * @returns true or false si Número de renglones de la tabla existen o estan seleccionados.
 *
 */
function validaRenglones(){
	// Renglones en el grid (todos).
	var numRenglones = getRenglones();

	// Si no hay operaciones en el grid, se regresa 0.
	if(numRenglones == 0){
		mensajeSis('No Existen Operaciones Inusuales a Reportar.');
	} else {
		// Si existen operaciones, se valida que haya al menos uno seleccionado.
		numRenglones = getRenglonesSelec();
		if(numRenglones == 0){
			mensajeSis('Seleccione al Menos una Operación para Generar el Reporte.');
		}
	}
	return (numRenglones > 0 ? true : false);
}


function descargarArchivo(){
	var ruta=$('#rutaArchivosPLD').val();
	var nombreArchivo=$('#nombreArchivo').val();
	var pagina='exportaInusualesTxt.htm?ruta='+ruta+'&nombreArchivo='+nombreArchivo;
	window.open(pagina);
}


//El boton de 'Descargar Archivo PLD' solo esta disponible para el usuario que es Oficial de Cumplimiento
function consultaOficialCumplimiento(){
	var tipoConsulta = 19;
	var idUsuarioSesion = consultaParametrosSession().numeroUsuario * 1;
	var ParametrosSisBean = {
			'empresaID'	:1
	};

	parametrosSisServicio.consulta(tipoConsulta,ParametrosSisBean,function(parametrosSisBean) {
		if (parametrosSisBean != null) {
			var oficialCumplimiento =  parametrosSisBean.oficialCumID * 1;

			if(oficialCumplimiento === idUsuarioSesion){
				$('#descargar').show();
			}else{
				$('#descargar').hide();
			}
		}
	});
}

function generaReporteXML(){
	var tipoReporte = 1;
	var lista_Campos = "";
	var lista_ValoresMostrar = "";

	var periodoID 			= $('#periodoID').val();
	var periodoInicio 		= $('#periodoInicio').val();
	var periodoFin 		 	= $('#periodoFin').val();

	lista_Campos += "&valorParam=" + ''; // Nombre
	lista_Campos += "&valorParam=" + 3; // NumList
	
	var liga = 'repDinamicoXML.htm?reporteID=' + tipoReporte + lista_Campos;
	window.open(liga, '_blank');
}

function consultaFormatoReporte(){
	var tipoConsulta = 34;
	paramGeneralesServicio.consulta(tipoConsulta,{ async: false, callback: function(valor){
		if(valor!=null){
			TipoFormatoReporte = valor.valorParametro;
		} else {
			TipoFormatoReporte = 1;
		}
	}});
}