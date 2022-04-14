var contFilas=0;
var esTab = true;
var parametroBean = consultaParametrosSession();
var diasBase = parametroBean.diasBaseInversion;
var diaHabilSiguiente = '1'; // indica dia habil Siguiente
var montoIn=0;
var catTipoConsulta = {
  		'principal'		:1, 
  		'institucion'	:2
};

var catOperacFechas = {
  		'sumaDias'		:1,
  		'restaFechas'	:2
};

var catTipoTransaccion = {
  		'agrega' 	: 1,
  		'modifica'	: 2
};

//Inicializando campos
$('#inversionID').focus();
$('#diasBase').val(diasBase);
$('#fechaInicio').val(parametroBean.fechaSucursal);
deshabilitaBoton('agregarDCC', 'submit');
eliminarTodasDistribucionCC();
exito();

$(document).ready(function() {
	deshabilitaBoton('agrega', 'submit');
	ocultarCampos();
	agregaFormatoControles('formaGenerica');
	
	$(':text').bind('keydown',function(e){
        if (e.which == 9 && !e.shiftKey){
              esTab= true;
        }
	 });

	
	//Funciones internas
function validaInversion(idControl){
		
		var jqFolio = eval("'#" + idControl + "'");
		var numFolio = $(jqFolio).val();
		eliminarTodasDistribucionCC();
		//Limpiar forma
		$('#formaGenerica input[name=clasificacionInver]').attr('checked', false);
		$('#formaGenerica input[name=tipoTitulo]').attr('checked', false);
		$('#formaGenerica input[name=tipoRestriccion]').attr('checked', false);
		$('#formaGenerica input[name=tipoDeuda]').attr('checked', false);
		
		if(numFolio == 0 && numFolio != '' && esTab){
			
			$('#tasaISR').val('0.60');
			$('#tasaISR').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 4});
			
			$('#diasBase').val(diasBase);
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			habilitaBoton('agrega', 'submit');
			
			
		}else if(numFolio != '' && !isNaN(numFolio) && esTab){
			var tipoConsulta = 1;
			var tasasInversionBean = {
					'inversionID' :	$('#inversionID').val()
			}; 
			
			invBancariaServicioScript.consultaInversionBancaria(tipoConsulta, tasasInversionBean, function(inversionBancaria){
				if(inversionBancaria != null){
					consultaDetalle();
					dwr.util.setValues(inversionBancaria);
					
					$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#tasaNeta').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 4});
					$('#interesGenerado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#totalRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					
					
					var Clafi=inversionBancaria.clasificacionInver;
					if(Clafi=='I'){
						$('#pregTipoTitulo').show();
			    		$('#opTipoTitulo').show();
			    		$('#pregRestriccion').show();
			    		$('#opRestriccion').show();
			    		$('#pregTipoDeuda').show();
			    		$('#opTipoDeuda').show();
					}
					else
						if(Clafi=='R'){
						ocultarCampos();
						var tipoDeuda=inversionBancaria.tipoDeuda;
						//console.log(tipoDeuda);
		            	$('#pregTipoDeuda').show();
		            	$('#opTipoDeuda').show();
					}
						else{
							ocultarCampos();
						}
					
					consultaInstitucion("institucionID");
					consultaCuentaAho();
				}else{
					alert("Inversion no encontrada");
					inicializaForma('formaGenerica', idControl);
					$('#inversionID').focus()
				}
			});
			deshabilitaBoton('agrega', 'submit');
		}
		
	}
	
	function calculaRendimiento(){
		deshabilitaBoton('agregarDCC', 'submit');
		
		var beanInversion = creaBeanInversion();
		
		invBancariaServicioScript.calculaRendimiento(beanInversion, function(rendimiento){
				if(rendimiento != null){
					$('#tasaNeta').val(rendimiento.tasaNeta);
					$('#interesGenerado').val(rendimiento.interesGenerado);
					$('#interesRetener').val(rendimiento.interesRetener);
					$('#interesRecibir').val(rendimiento.interesRecibir);
					$('#totalRecibir').val(rendimiento.totalRecibir);

					$('#tasaNeta').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 4});
					$('#interesGenerado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#totalRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					habilitaBoton('agregarDCC', 'submit');
				}
		});
		
	}
	
	function consultaCuentaAho(){
		var numInstituto = $('#institucionID').val();
		var numCtaInstit  = $('#numCtaInstit').val();
		var tipoConsulta = 6;
		var DispersionBeanCta = {
			'institucionID': numInstituto,
			'cuentaAhorro': numCtaInstit
			};		
		if(numCtaInstit != '' && !isNaN(numCtaInstit) && esTab){
			operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
				if(data!=null){
					$('#numCtaInstit').val(data.numCtaInstit);
					$('#totalCuenta').val(data.saldoCuenta);
					$('#monedaID').val(data.tipoMoneda);
					$('#totalCuenta').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					//$('#tasaISR').val(parametroBean.tasaISR);
					$('#tasaISR').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 4});
				}else{
					alert("No se encontro dato alguno....");
					$('#numCtaInstit').focus()
					$('#numCtaInstit').val('')
					$('#totalCuenta').val('')
				}
			});
		}
	}

	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
			
		var InstitutoBeanCon = {
  				'institucionID':numInstituto
		};
	 
		if(numInstituto != '' && !isNaN(numInstituto) && esTab){
			institucionesServicio.consultaInstitucion(catTipoConsulta.institucion,InstitutoBeanCon,function(instituto){
					if(instituto!=null){							
						$('#nombreCompleto').val(instituto.nombre);
					}else{
						alert("No existe la Institución"); 
						$('#institucionID').focus()
						$('#institucionID').val('')
						$('#nombreCompleto').val('')
					}    						
				});
			}
		}
	
	
	/*+ Consulta la fecha de vencimiento +*/
	$('#plazo').change(function(){
		if($('#fechaInicio').val()!= ''){				
			if($('#plazo').val() != 0){
				var opeFechaBean = {
					'primerFecha':$('#fechaInicio').val(),
					'numeroDias':$('#plazo').val()
				};
				operacionesFechasServicio.realizaOperacion(opeFechaBean,catOperacFechas.sumaDias,function(data) {
					if(data!=null){						
						$('#fechaVencimiento').val(data.fechaResultado);
						fechaHabil($('#fechaVencimiento').val(), 'plazo');
					}else{
						alert("A ocurrido un error Interno al Consultar Fechas...");
					}
				});
			}			
		}else{
			alert("Error al Consultar la Fecha de la Sucursal");
			$('#inversionID').focus();
			$('#inversionID').select();
		}
		
	});	
	
	function fechaHabil(fechaPosible, idControl){
		
		var diaFestivoBean = {
				'fecha':fechaPosible,
				'numeroDias':0,
				'salidaPantalla':'S'
		};
		
		diaFestivoServicio.calculaDiaFestivo(1,diaFestivoBean, function(data) {
				if(data!=null){
					$('#fechaVencimiento').val(data.fecha);
					var opeFechaBean = {
						'primerFecha': $('#fechaVencimiento').val(),
						'segundaFecha': $('#fechaInicio').val()
					};
					operacionesFechasServicio.realizaOperacion(opeFechaBean,catOperacFechas.restaFechas, function(data) {
						if(data!=null){						
							$('#plazo').val(data.diasEntreFechas);
						}else{
							alert("A ocurrido un error Interno al Consultar Fechas...");
						}
					});
				}else{
					alert("A ocurrido un error al calcular Dias Festivos..."); 
				}
		});
		
	}
	
	function fechaHabilInicio(fechaPosible){
		
		var diaFestivoBean = {
				'fecha':fechaPosible,
				'numeroDias':0,
				'salidaPantalla':'S'
		};
		
		diaFestivoServicio.calculaDiaFestivo(1,diaFestivoBean, function(data) {
				if(data!=null){
					$('#fechaInicio').val(data.fecha);
				}else{
					alert("A ocurrido un error al calcular Dias Festivos..."); 
				}
		});
		
	}
	
	function creaBeanInversion(){
		var tasasInversionBean = {
				'tasa' :	$('#tasa').val(),
				'tasaISR' :	$('#tasaISR').val(),
				'monto' :	$('#monto').asNumber(),
				'plazo' :	$('#plazo').asNumber(),
				'diasBase' :	diasBase
		};
		return tasasInversionBean;
	}
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			institucionID:	'required',
			numCtaInstit:	'required',
			tipoInversion:	'required',
			monto:			'required',
			tasa:			'required',
			tasaISR:		'required',
			plazo:			'required',
			fechaInicio:	'required',
			fechaVencimiento:	'required'
		},
		
		messages: {
			institucionID:	'Campo Requerido',
			numCtaInstit:	'Campo Requerido',
			tipoInversion:	'Campo Requerido',
			monto:			'Campo Requerido',
			tasa:			'Campo Requerido',
			tasaISR:		'Campo Requerido',
			plazo:			'Campo Requerido',
			fechaInicio:	'Campo Requerido',
			fechaVencimiento:	'Campo Requerido'
		}
	});
	
	
	
	
});

function ocultarCampos(){
	$('#pregTipoTitulo').hide();
	$('#opTipoTitulo').hide();
	$('#pregRestriccion').hide();
	$('#opRestriccion').hide();
	$('#pregTipoDeuda').hide();
	$('#opTipoDeuda').hide();
}

function agregarDistribucionCC(){
	var isrCal=$("#tasaISR").val();
	var aBancario=$("#diasBase").val();

	if(isrCal=== undefined || isrCal== null || isrCal.length <= 0){
		alert("Defina la Tasa ISR")
	}
	else
		if(aBancario=== undefined || aBancario== null || aBancario.length <= 0){
			alert("Defina el año Bancario")
		}
	else
		if($('#distribucionCC tr').length==1 || ValidarTabla())
	{
		var trs=$("#distribucionCC tr").length;
		//var idNuevo="idtr"+contFilas;
		contFilas=contFilas+1;
		var nuevaFila=
			"<tr id=\"tr"+contFilas+"\">"+
			"<td align=\"center\"><input id=\"ccD"+contFilas+"\"				name=\"ccD\" 				type=\"text\"	value=\"\"		onblur=\"consultaCC("+contFilas+");\" 				onkeyup=\"consultaCCKeyUP("+contFilas+");\" size='10'></td>"+
			"<td align=\"center\"><input id=\"montoD"+contFilas+"\" 			name=\"montoD\" 			type=\"text\"	value=\"\"		onblur=\"calculaDistribucionCC("+contFilas+");\" 	onkeyup=\"montoKeyup("+contFilas+");\" esMoneda=\"true\" ></td>"+
			"<td align=\"center\"><input id=\"interesGD"+contFilas+"\" 			name=\"interesGD\"			type=\"text\"	value=\"\"		disabled=\"true\"></td>"+
			"<td nowrap=\"nowrap\" align=\"center\"><input id=\"impuestoRetenerD"+contFilas+"\" 	name=\"impuestoRetenerD\" 	type=\"text\"	value=\"\" 		disabled=\"true\">&nbsp;<label>%</label></td>"+
			"<td align=\"center\"><input id=\"totalRecibir"+contFilas+"\" 		name=\"totalRecibirD\"		type=\"text\"	value=\"\"		disabled=\"true\" esMoneda=\"true\" ></td>"+
			"<td nowrap=\"nowrap\">"+
			"<input type=\"button\" name=\"elimina\" value=\"\" class=\"btnElimina\" onclick=\"eliminarDistribucionCC('tr"+contFilas+"')\"/>"+
			"<input type=\"button\" name=\"agrega\" value=\"\" class=\"btnAgrega\" onclick=\"agregarDistribucionCC()\"/>"+
			"</td>"+
			"</tr>";
		$("#distribucionCC").append(nuevaFila);
		$("#ccD"+contFilas).focus();
		agregaFormatoControles('formaGenerica');
	}
		else{
			alert("Hay campos en la tabla de Distribución por Centro de costos que estan vacíos.");
		}
}


function eliminarDistribucionCC(id){
	var montoCC=$("#montoD"+id).asNumber();
	montoIn=montoIn-montoCC;
	$("#"+id).remove();
	var montoInversion=$("#monto").asNumber();
	var montoCC=$("#montoD"+id).asNumber();
	var montoTo=sumaDCC();
	if(montoTo<=montoInversion){
		//Si el monto actual es igual al monto de la inversion deshabilitar el boton de agregar
		if(montoTo==montoInversion)
			deshabilitaBoton('agregarDCC', 'submit');
		else
			habilitaBoton('agregarDCC', 'submit');
	}
}

function eliminarTodasDistribucionCC(){
	$("#distribucionCC").find("tr:gt(0)").remove();
	montoIn=0;
}

function calculaDistribucionCC(id){
	
	var montoInversion=$("#monto").asNumber();
	var montoCC=$("#montoD"+id).asNumber();
	var montoTo=sumaDCC();
	if(montoTo<=montoInversion){
		//Si el monto actual es igual al monto de la inversion deshabilitar el boton de agregar
		if(montoTo==montoInversion)
			deshabilitaBoton('agregarDCC', 'submit');
	if(montoInversion>=montoCC){
	var tasasInversionBean = {
			'tasa' :		$('#tasa').val(),
			'tasaISR' :		$('#tasaISR').val(),
			'monto' :		$("#montoD"+id).asNumber(),
			'plazo' :		$('#plazo').asNumber(),
			'diasBase' :	$('#diasBase').val()
	};
	
	invBancariaServicioScript.calculaRendimiento(tasasInversionBean, function(rendimiento){
			if(rendimiento != null){
				$('#interesGD'+id).val(rendimiento.interesGenerado);
				$('#impuestoRetenerD'+id).val(rendimiento.interesRetener);
				$('#totalRecibir'+id).val(rendimiento.totalRecibir);

				$('#interesGD'+id).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
				$('#impuestoRetenerD'+id).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
				$('#totalRecibir'+id).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			}
	});
	}
	else{
		alert("El Monto Por Distribución Por CC No Puede Ser Mayor Al Monto de la Inversión.")
	}}
	else{
		alert("Has superado el monto de la inversión, cambiar el Monto de la distribución de CC.");
		var resttotal=montoInversion-(montoTo-montoCC);
		$('#montoD'+id).val(resttotal);
		$('#montoD'+id).focus();
	}
}

function consultaCC(id){
	console.log(id);
}

function consultaCCKeyUP(id){
	//var numcentroCosto= $('#ccD'+id).val();
	var jq = eval("'#ccD" + id + "'");
	
	$(jq).bind('keyup',function(e){
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();
			
		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "descripcion"; 
		parametrosLista[0] = num;
		
		lista(this.id , '2', '1', camposLista, parametrosLista, 'listaCentroCostos.htm');
	});
}

function montoKeyup(id){
	var jq = eval("'#montoD" + id + "'");
	
	$(jq).bind('keyup',function(e){
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();
		var montoInversion=$("#monto").asNumber();
		var montoCC=$("#montoD"+id).asNumber();
		var montoTo=sumaDCC();
		if(montoTo<=montoInversion){
			//Si el monto actual es igual al monto de la inversion deshabilitar el boton de agregar
			if(montoTo==montoInversion)
				deshabilitaBoton('agregarDCC', 'submit');
			else
				habilitaBoton('agregarDCC', 'submit');
		}else{
			deshabilitaBoton('agregarDCC', 'submit');
		}
	});
}


function sumaDCC(){
	montoIn=0;
	 $("#distribucionCC tr").each(function (index)
			 {
				 if(index>0){
					 var montoTC=$(this).find("input[name=montoD]").asNumber();
					//console.log("Monto+: "+montoTC);
					 if(montoTC > 0){
						 	montoIn=montoIn+montoTC;
				 			//console.log("MontoT:"+montoIn);
						 }
					 }
		        });
	 return montoIn;
}

function ValidarTabla(){
	var i=0;
	var EsCorrecta=true;
	$("#distribucionCC tr").each(function (index) 
			{
			 if(index>0){
				 var montoTC=$(this).find("input[name=montoD]").val();
				 var ccDT=$(this).find("input[name=ccD]").val();
				 if(montoTC=== undefined || montoTC== null || montoTC.length <= 0){
					 EsCorrecta= false;
					 return false;
					 }
				 else
					 if(ccDT=== undefined || ccDT== null || ccDT.length <= 0){
						 EsCorrecta= false;
						 return false;
						 }
				 }
			 });
		 return EsCorrecta;
}

function exito(){
	var inversionVal=$('#inversionID').val();
	$('#formaGenerica input[type=text]').each(function() {
        $(this).val('');
    });
	$('#inversionID').focus();
	$('#inversionID').val(inversionVal);
	$('#diasBase').val(diasBase);
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#tasaISR').val('0.60');
	ocultarCampos();
	deshabilitaBoton('agregarDCC', 'submit');
	deshabilitaBoton('agregar', 'submit');
	eliminarTodasDistribucionCC();
	$('#formaGenerica input[name=clasificacionInver]').attr('checked', false);
	$('#formaGenerica input[name=tipoTitulo]').attr('checked', false);
	$('#formaGenerica input[name=tipoRestriccion]').attr('checked', false);
	$('#formaGenerica input[name=tipoDeuda]').attr('checked', false);
}

function error(){
	
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

/*funcion valida fecha formato (yyyy-MM-dd)*/
function esFechaValida(fecha){

	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			alert("formato de fecha no válido (aaaa-mm-dd)");
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
			alert("Fecha introducida errónea.");
		return false;
		}
		if (dia>numDias || dia==0){
			alert("Fecha introducida errónea.");
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