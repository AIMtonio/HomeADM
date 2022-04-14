//Definicion de Constantes y Enums
var catTipoActReporteInternas = {
		'generaArch':'5',
};
var parametroBean = consultaParametrosSession();
var TipoFormatoReporte = 1;

	$(document).ready(function() {
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('generarArchivo', 'submit');
	deshabilitaBoton('descargar', 'submit');
	consultaOficialCumplimiento();
	consultaFormatoReporte();

	$.validator.setDefaults({
            submitHandler: function(event) {
                grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','fechaActual', 'exitoOpeInternas', 'falloOpeInternas');
            }
    });

	$('#fechaActual').val(parametroBean.fechaSucursal);
	$('#periodoFin').val(parametroBean.fechaSucursal);
	$('#rutaArchivosPLD').val(parametroBean.rutaArchivosPLD);

	$('#generarArchivo').click(function(e) {
		mensajeSisRetro({
			mensajeAlert : 'Una vez que se Genere el Reporte, las Operaciones ya no se volverán a mostrar en futuros archivos de Operaciones Internas Preocupantes, incluyendo el Reporte en Excel.<br>¿Desea continuar?',
			muestraBtnAceptar: true,
			muestraBtnCancela: true,
			muestraBtnCerrar: false,
			txtAceptar : 'Aceptar',
			txtCancelar : 'Cancelar',
			txtCabecera:  'Mensaje:',
			funcionAceptar : function(e){
				$('#tipoActualizacion').val(catTipoActReporteInternas.generaArch);
				grabaFormaTransaccionRetrollamada(e, 'formaGenerica', 'contenedorForma', 'mensaje','false','numTransaccion', 'exitoOpeInternas', 'falloOpeInternas');
			},
			funcionCancelar : function(e){
				e.preventDefault();
			}
		});
	});

	$('#generarNombre').click(function() {
		construyeNom();
		deshabilitaBoton('generarNombre', 'submit');
		habilitaBoton('generarArchivo', 'submit');
	});

	$('#generarExcel').click(function(e) {
		$('#tipoActualizacion').val(catTipoActReporteInternas.generaArch);
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

	//---Funcion construyeNombre  (2693966130906.002)
	function construyeNom() {
		var valorFecha= $('#fechaActual').val();
		var repInuausalesBeanCon = {
					'fecha':valorFecha
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if (valorFecha != '') {
			opIntPreocupantesServicio.consulta(2,repInuausalesBeanCon, function(arch) {
						if (arch != null) {
							$('#nombreArchivo').val(arch.nombreArchivo);
						}
						else{
							mensajeSis("Error al Generar el Nombre del Archivo");
						}
					});
		}
	}


}); //cerrar

function exitoOpeInternas(){
	habilitaBoton('descargar', 'submit');
	/*Genera y descarga el archivo en xml*/
	if($('#tipoActualizacion').val()==catTipoActReporteInternas.generaArch){
		if(Number(TipoFormatoReporte) == 2){
			generaReporteXML();
		}
	}
}

function falloOpeInternas(){

}

//para descargar el archivo  txt
function descargarArchivo(){
	var ruta=$('#rutaArchivosPLD').val();
	var nombreArchivo=$('#nombreArchivo').val();
	var pagina='exportaInternasTxt.htm?ruta='+ruta+'&nombreArchivo='+nombreArchivo;
	window.open(pagina);
}

function generaReporte(){
	var tipoReporte 		= 3; // reporte op. internas preocupantes
	var tituloReporte 		= 'REPORTE DE OPERACIONES INTERNAS PREOCUPANTES AL DÍA '+ $('#fechaActual').val() + '.';
	var fechaActual 		= $('#fechaActual').val();
	var periodoID 			= $('#periodoID').val();
	var periodoInicio 		= $('#periodoInicio').val();
	var periodoFin 		 	= $('#periodoFin').val();
	var archivo 		 	= $('#archivo').val();

	var tipoActualizacion 	= $('#tipoActualizacion').val();
	var usuario 	 		= parametroBean.claveUsuario;
	var nombreInstitucion 	= parametroBean.nombreInstitucion;
	var datosOperInusuales 	= $('#datosOperInusuales').val();

	var liga = 'reporteSITIExcel.htm?'+
			'tituloReporte='+tituloReporte+
			'&fechaGeneracion='+fechaActual+
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
function generaReporteXML(){
	var tipoReporte = 2;
	var lista_Campos = "";
	var lista_ValoresMostrar = "";

	var periodoID 			= $('#periodoID').val();
	var periodoInicio 		= $('#periodoInicio').val();
	var periodoFin 		 	= $('#periodoFin').val();

	// PARAMETROS DEL REPORTE
	lista_Campos += "&valorParam=" + 0; // CATEGORIA
	lista_Campos += "&valorParam=" + 0; // SUCURSAL
	lista_Campos += "&valorParam=" + ''; //NOMBRE
	lista_Campos += "&valorParam=" + 5; //NUMLIS
	var liga = 'repDinamicoXML.htm?reporteID=' + tipoReporte + lista_Campos;
	window.open(liga, '_blank');
}