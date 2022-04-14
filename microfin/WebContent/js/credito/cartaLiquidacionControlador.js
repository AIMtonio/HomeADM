var transaccion = {
	'alta': 1,
	'modifica': 2
};
var tieneCarta = false;
var parametrosBean = consultaParametrosSession();
var archivoCreditoBean;

$(document).ready(function() {
	var esTab = true;

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
		
	funcionIniciaPantalla();
	

	/* === I N S T I T U C I O N - Al hacer Tab valida y llena los campos necesarios === */ 
	$('#institucionID').blur(function() {
		funcionValidaInstitucion(this.id);
	});
	
	// Despliega la lista de instituciones
	$('#institucionID').bind('keyup',function(e) {
	    lista('institucionID', '2', '7', 'institucionID', $('#institucionID').val(), 'listaInstituciones.htm');
	});
	
	/* === C R E D I T O S - Al hacer Tab valida y llena los campos necesarios ===*/
	$('#creditoID').blur(function() {
		funcionValidarCredito(this.id);
		
	});
	
	// Despliega la lista de créditos
	$('#creditoID').bind('keyup',function(e) {
	    lista('creditoID', '2', '59', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});	
	
	// Ejecut el reporte PDF
	$('#reimprimir').click(function() {
		funcionVerArchivosCredito();
	});
	
	// Ejecuta el reporte PDF
	$('#imprimir').click(function() {
		funcionReportePDF();
	});
	
	$('#fechaVencimiento').change(function() {
		$('#fechaVencimiento').focus();
		funcionValidaFecha();
	});
	
	$('#fechaVencimiento').blur(function() {
		if(esTab) {
			funcionValidaFecha();
		}
		funcionValidarCampos();
	});
	
	$('#convenio').bind('keyup', function(e) {
		if(e.target.value.length >= 3) {			
			if(!funcionIsNumeric($('#convenio').val())) {
				mensajeSis('Solo se permite el formato numérico para este campo');
			}
		}
	});
	
	$('#convenio').blur(function() {
		funcionValidarCampos();
	});
	
	/* ===== Validaciones de la froma ===== 
	 * checar el mensaje de convenio
	 * */
	$('#formaGenerica').validate({
		rules: {
			creditoID: {
				required: true
			},
			fechaVencimiento: {
				required: true
			},
			institucionID: {
				required: true
			},
			convenio: {
				required: true,
				number:true
			}
		},
		messages: {
			creditoID: {
				required: 'Especificar Crédito'
			},
			fechaVencimiento: {
				required: 'Especificar Fecha Vencimiento'
			},
			institucionID: {
				required: 'Especificar Institución'
			},
			convenio: {
				required: 'Especificar Convenio',
				number: 'Escriba un número válido'
			}
		}
	});
	
	$('#generar').click(function(event) {
		if(tieneCarta) {
			mensajeSisRetro({
				mensajeAlert : 'El crédito '+ $('#creditoID').val()+' ya cuenta con una carta de liquidación, ¿Desea generar una nueva?',
				muestraBtnAceptar: true,
				muestraBtnCancela: true,
				muestraBtnCerrar: true,
				txtAceptar : 'Aceptar',
				txtCancelar : 'Cancelar',
				txtCabecera:  'Mensaje:',
				funcionAceptar : function(){
					funcionGrabaCartaLiq(event);
				},
				funcionCancelar : function(){},
				funcionCerrar   : function(){}
			});
		} else {
			funcionGrabaCartaLiq(event);
		}
		
	});
	
	/**
	 * *==========================================================================================
	 * 											FUNCIONES
	 * *==========================================================================================
	 **/
	
	
	function funcionValidaFecha() {
		var fechaVen 	= $('#fechaVencimiento').val();
		var fechaAplic 	= parametroBean.fechaAplicacion;
		
		if(!funcionFechaMayorQue(fechaVen, fechaAplic)){
			mensajeSis('La Fecha de Vencimiento es menor o igual a la Fecha del sistema');
			$('#fechaVencimiento').val(fechaAplic);
			$('#fechaVencimiento').focus();
		}
	}
	
	function funcionValidarCampos() {
		var creditoID 	= $('#creditoID').val();
		var fecha 	  	= $('#fechaVencimiento').val();
		var institucion = $('#institucionID').val();
		var convenio	= $('#convenio').val();
		
		if(creditoID != '' && fecha != '' && institucion != '' && convenio != '') {
			habilitaBoton('generar', 'button');
		}
	}
	
	function funcionIniciaPantalla() {
		agregaFormatoControles('formaGenerica');
		$('#creditoID').focus();
		deshabilitaBoton('reimprimir', 'button');
		deshabilitaBoton('generar', 'button');
	}
	
	function funcionGrabaCartaLiq(event) {
		habilitaBoton('reimprimir', 'button');
		$('#recurso').val(parametrosBean.rutaArchivos);
		$('#tipoTransaccion').val(transaccion.alta);
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'cartaLiquidaID', 'funcionExito', 'funcionError');
	}

	function funcionValidaInstitucion() {
		var tipoConsulta  = 1;
		var institucionID = $('#institucionID').val();
		
		if(institucionID != '' && !isNaN(institucionID) && esTab) {
			var institucionesBean = {
				'institucionID': institucionID
			};
			
			institucionesServicio.consultaInstitucion(tipoConsulta, institucionesBean, function(institucion) {
				if(institucion != null) {
					$('#institucion').val(institucion.nombre);
				} else {
					mensajeSis('No existe la Institución con ese ID');
					$('#institucionID').focus();
				}
			});
		}
	}

	function funcionValidarCredito() {
		var creditoID = $('#creditoID').val();

		if(creditoID != '' && !isNaN(creditoID) && esTab) {
			var cartaLiquidacionBean = {
				'creditoID': creditoID
			};
			
			var creditoBean = {
				'creditoID': creditoID	
			};
					
			cartaLiquidacionServicio.consulta(cartaLiquidacionBean, 1, function(cartaLiq) {
				if(cartaLiq != null) {
					$('#clienteID').val(cartaLiq.clienteID);
					$('#cliente').val(cartaLiq.cliente);
					$('#montoOriginal').val(cartaLiq.montoOriginal);
					$('#fechaVencimiento').val(cartaLiq.fechaVencimiento);					
					$('#institucionID').val(cartaLiq.institucionID);
					$('#institucion').val(cartaLiq.institucion);
					$('#convenio').val(cartaLiq.convenio);
					
					agregaFormatoControles('formaGenerica');
					tieneCarta = true;
					habilitaBoton('generar', 'submit');
					habilitaBoton('reimprimir', 'submit');
					
					
				} else {
					creditosServicio.consulta(50, creditoBean, function(credito) {
						var montoOriginal = 0;
						if(credito != null) {
							$('#clienteID').val(credito.clienteID);
							$('#cliente').val(credito.nombreCliente);
							$('#montoOriginal').val(credito.montoCredito);
							$('#fechaVencimiento').val('');					
							$('#institucionID').val('');
							$('#institucion').val('');
							$('#convenio').val('');
							agregaFormatoControles('formaGenerica');
						} else {
							mensajeSis('El Credito ' + $('#creditoID').val() + ' capturado no existe');
							funcionInicializaFormulario();	
							$('#creditoID').focus();
						}
					});
					tieneCarta = false;
					deshabilitaBoton('generar', 'submit');
					deshabilitaBoton('reimprimir', 'submit');
				}
			});
		}
	}
	
	
	function funcionFechaMayorQue(fecha, fecha2){
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
	
	function funcionIsNumeric(input){ 
	    var RE = /^-{0,1}\d*\.{0,1}\d+$/; 
	    return (RE.test(input)); 
	} 
	
	function funcionVerArchivosCredito() {
		var tipoConsulta = 2;
		var creditoID = $('#creditoID').val();
		var tipoDocumento = 9995;
		var recurso = "";
		var archivoCredID;
		var parametros = "";
		var pagina = "";
		
		cartaLiquidacionBean = {
			'creditoID': creditoID
		}
		cartaLiquidacionServicio.consulta(cartaLiquidacionBean, tipoConsulta, function(cartaLiq) {
			if(cartaLiq != null) {
				recurso = parametrosBean.rutaArchivos + cartaLiq.recurso;
				archivoCredID = cartaLiq.archivoIdCarta;
				
				parametros = "?creditoID="+creditoID+"&tipoDocumentoID="+
				tipoDocumento+"&recurso="+cartaLiq.recurso+"&archivoCreditotID="+archivoCredID;
				
				pagina = "creditoVerArchivos.htm" + parametros;
				window.open(pagina, '_blank'); 
			}
		});
		
	}
});

function funcionReportePDF() {
	var creditoID = $('#creditoID').val();
	var recurso = parametrosBean.rutaArchivos;
	var cartaLiquidaID = "";
	var clienteID = $('#clienteID').val();
	var cliente = $('#cliente').val();
	var fechaVencimiento = $('#fechaVencimiento').val();
	var parametros = "";
	var pagina = "";
	
	var cartaLiq = {
		'creditoID': creditoID
	}
	
	cartaLiquidacionServicio.consulta(cartaLiq, 1, function(carta) {
		cartaLiquidaID = carta.cartaLiquidaID;
		parametros = '?creditoID='+creditoID+'&cartaLiquidaID='+cartaLiquidaID+
			'&recurso='+recurso+'&clienteID='+clienteID+'&cliente='+cliente+'&fechaVencimiento='+fechaVencimiento;
		pagina = 'reporteCartaLiquidacion.htm' + parametros;
		window.open(pagina, '_blank')
	});
}

function funcionExito() {
	$('#imprimir').trigger('click');
	funcionInicializaFormulario();	
}

function funcionError() {
	funcionInicializaFormulario();
	$('#creditoID').focus();
}


function funcionInicializaFormulario()
{
	$('#clienteID').val('');
	$('#cliente').val('');
	$('#montoOriginal').val('');
	$('#fechaVencimiento').val('');					
	$('#institucionID').val('');
	$('#institucion').val('');
	$('#convenio').val('');
	
	deshabilitaBoton('reimprimir', 'button');
	deshabilitaBoton('generar', 'submit');
}
