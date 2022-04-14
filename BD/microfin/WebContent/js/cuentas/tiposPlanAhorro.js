var parametroBean = consultaParametrosSession();
var tipoConsulta = 1;

$(document).ready(function(){
	var esTab = true;

	agregaFormatoControles('formaGenerica');
	inicializaCampos();

	$("#planID").focus();

	$("#planID").blur(function(){
		validaPlanID(this.Id);
	});

	$("#planID").bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "planID";
		parametrosLista[0] = $('#planID').val();

		lista('planID','2','1', camposLista,parametrosLista, 'listaTiposPlanAhorro.htm');
	});

	$("#nombre").blur(function(){
		calculaPrefijo();
	});

	$("#fechaInicio").change(function(){
		validaFechaInicio();
	});
	
	$("#diasDesbloqueo").blur(function (){
		$("#fechaLiberacion").val(sumaDias($("#fechaInicio").val(),$("#diasDesbloqueo").val()));
	});

	$("#fechaVencimiento").change(function(){
		validaFechaVencimiento();
		setTimeout("$('#fechaVencimiento').focus()",0);
	});

	$("#fechaLiberacion").change(function(){
		validaFechaLiberacion();
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			if( $("#fechaInicio").val()<parametroBean.fechaSucursal || 
				$("#fechaInicio").val()<parametroBean.fechaSucursal || 
				$("#fechaInicio").val()<parametroBean.fechaSucursal    ){
				validaFechaInicio();
				validaFechaVencimiento();
				validaFechaLiberacion();
			}else{
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','planID','consultaExitosa','consultaFallida');
			}
		}
	});

	$('#formaGenerica').validate({
		rules:{
			nombre:{
				required : true
			},
			fechaInicio:{
				required : true
			},
			fechaVencimiento:{
				required : true
			},
			diasDesbloqueo:{
				required : true,
				numeroPositivo : true
			},
			depositoBase:{
				required : true,
				numeroPositivo : true
			},
			noMaxDep:{
				required : true,
				numeroPositivo : true
			},
			prefijo:{
				required : true
			},
			serie:{
				required : true
			},
			tiposCuentas:{
				required : true
			},
			leyendaBloqueos:{
				required : true
			},
			leyendaTickets:{
				required : true
			}
		},
		messages:{
			nombre:{
				required : "Especificar un Nombre para el plan."
			},
			fechaInicio:{
				required : "Especificar una Fecha de Inicio."
			},
			fechaVencimiento:{
				required : "Especificar una Fecha de Vencimiento."
			},
			diasDesbloqueo:{
				required : "Especifique Días Desbloqueo.",
				numeroPositivo : "Días Desbloqueo Incorrecto."					
			},
			depositoBase:{
				required : "Especificar Monto del Depósito Base.",
				numeroPositivo : "Monto Incorrecto."
			},
			noMaxDep:{
				required : "Especificar un Numero de Folios por Cliente.",
				numeroPositivo : "Número de Folios Incorrecto."
			},
			prefijo:{
				required : "Especificar un Prefijo para el Plan."
			},
			serie:{
				required : "Especificar la serie para el Plan."
			},
			tiposCuentas:{
				required : "Especificar los Tipos de Cuentas para el Plan."
			},
			leyendaBloqueos:{
				required : "Especificar la Leyenda para Bloqueos."
			},
			leyendaTickets:{
				required : "Especificar Leyenda para la impresión de Tickets."
			}
		}
	});

	function calculaPrefijo(){
		var nomPlan = $("#nombre").val();
		var cadenaAux = nomPlan.split(' ');
		var prefijo = '';

		if (nomPlan!='') {
			for(var i=0;i<cadenaAux.length;i++){
				prefijo = prefijo+cadenaAux[i][0];
			}
		}

		$("#prefijo").val(prefijo);
	}

	function validaFechaLiberacion(){
		var fechaIni = $("#fechaInicio").val();
		var fechaVen = $("#fechaVencimiento").val();
		var fechaLib = $("#fechaLiberacion").val();
		if (fechaLib<parametroBean.fechaSucursal) {
			mensajeSis("La Fecha de Liberación no debe ser menor a la Fecha del Sistema.");
		}else if(fechaLib<fechaIni){
			mensajeSis("La Fecha de Liberación no debe ser menor a la Fecha de Inicio.");
		}else if(fechaLib<fechaVen){
			mensajeSis("La Fecha de Liberación no de ser menor a la Fecha de Vencimiento.");
		}
		setTimeout("$('#fechaLiberacion').focus()",0);
	}

	function validaFechaVencimiento(){
		var fechaIni = $("#fechaInicio").val();
		var fechaVen = $("#fechaVencimiento").val();
		if (fechaVen<parametroBean.fechaSucursal) {
			mensajeSis("La Fecha de Vencimiento no puede ser menor a la Fecha del Sistema.");
		}else if(fechaVen<fechaIni){
			mensajeSis("La Fecha de Vencimiento no puede ser menor a la Fecha de Inicio.");
		}
	}

	function validaFechaInicio(){
		if ($("#fechaInicio").val()<parametroBean.fechaSucursal) {
			mensajeSis("La Fecha de inicio no puede ser menor a la Fecha del Sistema.");
		}
		setTimeout("$('#fechaInicio').focus()",0);
	}

	function validaPlanID(control){
		var numPlanID = $("#planID").val();

		if (numPlanID != '' && !isNaN(numPlanID)) {
			if (numPlanID==0) {
				deshabilitaBoton('modifica', 'submit');
				habilitaBoton('agrega', 'submit');
				inicializaCampos();
				$('#tipoTransaccion').val(1);
			}else{
				deshabilitaBoton('agrega', 'submit'); 
				habilitaBoton('modifica', 'submit');
				$('#agrega').attr("hidden",true);
				$('#modifica').show();

				var planBeanCon = {};
				planBeanCon['planID'] =  $('#planID').val();
				
				tiposPlanAhorroServicio.consulta(tipoConsulta,planBeanCon,function(planBean){
					if (planBean!=null) {
						dwr.util.setValues(planBean);
						$("#diasDesbloqueo").val(planBean.diasDesbloqueo);
						if (planBean.tiposCuentas!=null) {
							var tiposCuentasCon = planBean.tiposCuentas.split(',');
							var tamanio = tiposCuentasCon.length;
							for (var i=0;i<tamanio;i++) {  
								var tipoCuenta = tiposCuentasCon[i];
								var jqPlazo = eval("'#tiposCuentas option[value="+tipoCuenta+"]'");  
								$(jqPlazo).attr("selected","selected");   
							}
						}
						$("#tipoTransaccion").val(2);
					}else{
						mensajeSis("El Plan de Ahorro no existe.");
						inicializaCampos();
						setTimeout("$('#planID').focus()",0);
					}
				});
			}
		}
	}
	
});

function consultaTiposCuentas(){
	var tipoCon=9;
	dwr.util.removeAllOptions('tiposCuentas');
	tiposCuentaServicio.listaCombo(tipoCon, function(cuentas){
		dwr.util.addOptions('tiposCuentas', cuentas, 'tipoCuentaID', 'descripcion');
	});
}

function inicializaCampos(){
	$("#nombre").val('');
	$("#fechaInicio").val(parametroBean.fechaSucursal);
	$("#fechaVencimiento").val('');
	$("#fechaLiberacion").val('');
	$("#depositoBase").val('');
	$("#maxDep").val('');
	$("#prefijo").val('');
	$("#serie").val('00');
	$("#leyendaBloqueo").val('');
	$("#leyendaTicket").val('');
	$("#diasDesbloqueo").val('');
	deshabilitaBoton('modifica','submit');
	$('#modifica').attr("hidden",true);
	consultaTiposCuentas();
}

function consultaExitosa(){
	inicializaCampos();
}

function consultaFallida(){
	
}
function sumaDias(fecha,suma){
	var mes=  fecha.substring(5, 7)*1;
	var dia= fecha.substring(8, 10)*1;
	var anio= fecha.substring(0,4)*1;
	var diaS = "";
	var mesS = "";
    for (var i = 1; i <= suma; i++) {
   		if (mes==2 && dia==28 && anio%4!=0){
        	mes=mes+1;
			dia=0;
        }else{
			if (mes==2 && dia==29 && anio%4==0){
            	mes=mes+1;
				dia=0;
            }else{
            	if (dia==30 && (mes==4 || mes==6 || mes==9 || mes==11) ){
                	mes=mes+1;
					dia=0;
                }else{
                	if (dia==31 && (mes==1 || mes==3 || mes==5 || mes==7 || mes==8 || mes==10)){
                    	mes=mes+1;
						dia=0;
                    }else{
                    	if (dia==31 && mes==12){
                        	dia=0;
                            mes=1;
                            anio=anio+1;
                        }
                    }
                }
            }
        }
        dia=dia+1;
	}
    dia < 10 ? diaS = "0"+dia : diaS = ""+dia;
    mes < 10 ? mesS = "0"+mes : mesS = ""+mes;
    return (anio+'-'+mesS+'-'+diaS)
}