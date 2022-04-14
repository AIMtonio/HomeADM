var esTab = true;

//Definicion de Constantes y Enums
var catTipoTransaccionReporte = {
		'generaArch':'2'
	};

var catTipoConsultaReelevantes = {
  		'principal'	: 1

	};
var TipoFormatoReporte = 1;
$(document).ready(function() {

		//------------ Metodos y Manejo de Eventos -----------------------------------------
		$('#periodoID').focus();
		deshabilitaBoton('generarNombre', 'submit');
		deshabilitaBoton('generarArchivo', 'submit');
		deshabilitaBoton('generarExcel', 'submit');
		deshabilitaBoton('descargar', 'submit');
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
        			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','fechaGeneracion', 'exito', 'fallo');
	            }
	    });

		consultaPeriodo();
		var parametroBean = consultaParametrosSession();
		$('#fechaGeneracion').val(parametroBean.fechaSucursal);
		$('#rutaArchivosPLD').val(parametroBean.rutaArchivosPLD);
		$('#anioGeneracion').val(generaYear(parametroBean.fechaSucursal));

		agregaFormatoControles('formaGenerica');

		$('#periodoID').change(function() {
			if($('#periodoID').val().trim()=='0'){
				inicializar();
			} else {
				consultaFecha(this.id);
				$('#archivo').val("");
				$('#periodoOculto').val($('#periodoID').val());
				habilitaBoton('generarNombre', 'submit');
				habilitaBoton('generarExcel', 'submit');
				deshabilitaBoton('descargar',  'submit');
	    	 	deshabilitaBoton('generarArchivo', 'submit');
	      	}
		});

	      $('#generarNombre').click(function() {
	    	  construyeNom('periodoFin');
	    	  deshabilitaBoton('generarNombre', 'submit');
	    	  habilitaBoton('generarArchivo', 'submit');

	  	});


	  	$('#generarArchivo').click(function(event) {
	  		if($('#archivo').val().trim()!=''){
				$('#tipoTransaccion').val(catTipoTransaccionReporte.generaArch);
	  		} else {
	  			event.preventDefault();
	  			mensajeSis('El Nombre del Archivo esta vacío.');
				habilitaBoton('generarNombre', 'submit');
				deshabilitaBoton('generarArchivo', 'submit');
	  		}
		});

	  	$('#generarExcel').click(function() {
			generaReporte();
		});

		$('#descargar').click(function() {
			descargarArchivo('periodoFinOculto','archivoOculto');
		});

		$('#anioGeneracion').change(function() {
			$('#anioGeneracion').val(generaYear($('#anioGeneracion').val()));
			if($('#periodoID').asNumber()!=0){
				actFechasPeriodo();
				$('#archivo').val("");
				$('#periodoOculto').val($('#periodoID').val());
				habilitaBoton('generarNombre', 'submit');
				habilitaBoton('generarExcel', 'submit');
				deshabilitaBoton('generarArchivo', 'submit');
				deshabilitaBoton('descargar',  'submit');
			}
		});

	  //------------ Validaciones de la Forma -------------------------------------

		$('#formaGenerica').validate({

			rules: {

				fechaGeneracion: {
					required: true,
					date: true,
				},

				periodoID: {
					required: true
				},

				periodoInicio: {
					required: true
				},

				periodoFin: {
					required: true
				},

				archivo: {
					required: true
				},
			},
			messages: {


				fechaGeneracion: {
					required: 'Especifica Fecha.',
					date: 'Fecha incorrecta',
				},

				periodoID: {
					required: 'Especifica Periodo'
				},

				periodoInicio: {
					required: 'Especifica Fecha.',
					date: 'Fecha incorrecta',
				},

				periodoFin: {
					required: 'Especifica Fecha.',
					date: 'Fecha incorrecta',
				},

				archivo: {
					required: 'Especifica Nombre del Archivo.'
				},


			}
		});


		//----------Funcion consultaFecha---------------------//
		function consultaFecha(idControl) {
			var jqFecha = eval("'#" + idControl + "'");
			var numFecha = $(jqFecha).val();
			var conFecha = 1;
			var PeriodosReelevantesBeanCon = {
	  				'periodoReeID':numFecha
				};
			var periodoYear = $('#anioGeneracion').val().trim();
			setTimeout("$('#cajaLista').hide();", 200);
			if (numFecha != ''  && esTab) {
				periodosReelevantesServicio.consulta(conFecha,
						PeriodosReelevantesBeanCon, { async: false, callback:function(periodos) {
							if (periodos != null) {
								$('#periodoInicio').val(generaFechaPeriodo(periodos.mesDiaInicio,periodoYear));
								$('#periodoFin').val(generaFechaPeriodo(periodos.mesDiaFin,periodoYear));
							} else {
								mensajeSis("No existe el periodo "+ numFecha);
							}
						}});
			}
		}


		function consultaPeriodo() {
	  		dwr.util.removeAllOptions('periodoID');
			dwr.util.addOptions('periodoID', {0:'SELECCIONAR'});
			periodosReelevantesServicio.listaCombo(1, function(periodo){
				dwr.util.addOptions('periodoID', periodo, 'periodoReeID', 'descripcion');
			});
		}



		//----------Funcion construyeNombre---------------------//
		function construyeNom(idControl) {
			var jqArch = eval("'#" + idControl + "'");
			var numArch = $(jqArch).val();
			var conArch = 3;
			var ReporteReelevantesBeanCon = {
	  				'periodoFin':numArch
				};
			setTimeout("$('#cajaLista').hide();", 200);
			if (numArch != ''  && esTab) {
				reporteReelevantesServicio.consulta(conArch,
						ReporteReelevantesBeanCon, function(arch) {
							if (arch != null) {
								$('#archivo').val(arch.archivo);
								$('#periodoFinOculto').val($('#periodoFin').val());
								$('#archivoOculto').val($('#archivo').val());
							} else {
								mensajeSis("No existe el periodo.");
							}
						});
			}
			habilitaBoton('generarArchivo', 'submit');
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

});

function generaReporte(){
	var tipoReporte 		= 1; // reporte relevantes
	var tituloReporte 		= 'REPORTE DE OPERACIONES RELEVANTES DEL PERIODO '+
							$('#periodoID option:selected').text() + ' DEL AÑO '+$('#periodoFin').val().substring(0, 4) +
							'.';
	var fechaGeneracion 	= $('#fechaGeneracion').val();
	var periodoID 			= $('#periodoID').val();
	var periodoInicio 		= $('#periodoInicio').val();
	var periodoFin 		 	= $('#periodoFin').val();
	var operaciones 		= $("#operaciones option:selected").val();
	var archivo 		 	= 'ReporteExcelSITI';
	var sucursal			= $('#sucursalID').val();
	var nombreSucursal		= $('#nombreSucursal').val();
	var usuario				= parametroBean.claveUsuario;
	var nombreInstitucion	= parametroBean.nombreInstitucion;

	var descOperaciones;
	if(operaciones == ""){
		descOperaciones = 'TODOS';
	}else{
		descOperaciones = $("#operaciones option:selected").html();
	}
	
	var liga = 'reporteSITIExcel.htm?'+
			'tituloReporte='+tituloReporte+
			'&fechaGeneracion='+fechaGeneracion+
			'&periodoID='+periodoID+
			'&periodoInicio='+periodoInicio+
			'&periodoFin='+periodoFin+
			'&operaciones='+operaciones+
			'&descOperaciones='+descOperaciones+
			'&archivo='+archivo+
			'&fechaSistema='+fechaGeneracion+
			'&sucursalID='+sucursal+
			'&nombreSucursal='+nombreSucursal+
			'&nombreUsuario='+usuario.toUpperCase()+
			'&tipoReporte='+tipoReporte+
			'&nombreInstitucion='+nombreInstitucion;
	window.open(liga, '_blank');
}

function inicializar(){
	limpiaFormaCompleta('formaGenerica', true, [ 'fechaGeneracion', 'anioGeneracion' ]);
	deshabilitaBoton('generarArchivo', 'submit');
	deshabilitaBoton('generarNombre', 'submit');
	deshabilitaBoton('generarExcel', 'submit');
	deshabilitaBoton('descargar', 'submit');
}

function exito(){
	habilitaBoton('descargar', 'submit');
	/*Genera y descarga el archivo en xml*/
	if($('#tipoTransaccion').val()==catTipoTransaccionReporte.generaArch){
		if(Number(TipoFormatoReporte) == 2){
			generaReporteXML();
		}
	}
}

function fallo(){
}

function descargarArchivo(idControl, idArchivo) {
	var jqArch = eval("'#" + idControl + "'");
	var numArch = $(jqArch).val();
	var jqArch2 = eval("'#" + idArchivo + "'");
	var numArch2 = $(jqArch2).val();
	var ReporteReelevantesBeanCon = {
			  'periodoInicio':numArch,
			  'periodoFin':numArch2,
		};

	var parametros = "?periodoFin="+numArch+"&archivo="+numArch2;
	var pagina="exportaReelevantesTxt.htm"+parametros;

	window.open(pagina);
};


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

	var lista_Campos = "";
	var lista_ValoresMostrar = "";

	var periodoID 			= $('#periodoID').val();
	var periodoInicio 		= $('#periodoInicio').val();
	var periodoFin 		 	= $('#periodoFin').val();

	// PARAMETROS DEL REPORTE

	lista_Campos += "&valorParam=" + 1;//EmpresaID
	lista_Campos += "&valorParam=" + periodoFin;//Periodo
	lista_Campos += "&valorParam=" + 1;//NumConsulta

	var liga = 'repDinamicoXML.htm?reporteID=' + 3
		+ lista_Campos;
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

function generaYear(fecha){
	return fecha.substring(0, 4);
}

function generaFechaPeriodo(fecha,periodoYear){
	if(fecha.trim() != ''){
		var anio= fecha.substring(0,4);
		var mes = fecha.substring(5,7);
		var dia = fecha.substring(8,10);
		return (periodoYear + '-' + mes + '-' +dia);
	} else {
		return '';
	}
}

function actFechasPeriodo(){
	var periodoYear = $('#anioGeneracion').val().trim();
	$('#periodoInicio').val(generaFechaPeriodo($('#periodoInicio').val(),periodoYear));
	$('#periodoFin').val(generaFechaPeriodo($('#periodoFin').val(),periodoYear));
}