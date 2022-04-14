$(document).ready(function() {
	var catTipoTransaccion = {
		'actualizacionConfiguracionServicio' : 1,
		'actualizacionCatalogoServicios' : 2
	};

	esTab = false;

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':button, :submit').focus(function() {
		esTab = false;
	});

	$(':button, :submit').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('input:checkbox').focus(function() {
		esTab = false;
	});

	$('input:checkbox').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$(':text, :button, :submit, :input:checkbox').blur(function() {
		if($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout(function() {
				$('#btnActualizarServicios').focus();
			}, 0);
		}
	});

	$('#cContaServicio').bind('keyup',function(e){
		listaMaestroCuentas(this.id);
	});

	$('#cContaComision').bind('keyup',function(e){
		listaMaestroCuentas(this.id);
	});

	$('#cContaIVAComisi').bind('keyup',function(e){
		listaMaestroCuentas(this.id);
	});

	function listaMaestroCuentas(idControl){
		var jqControl = eval("'#" + idControl+ "'");
		
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = $(jqControl).val();
		
		if($(jqControl).val() != '' && !isNaN($(jqControl).val() )){
			lista(idControl, '2', '6', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
		else{
			lista(idControl, '2', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}	
	
	$('#cContaServicio').blur(function(e) {
		setTimeout("$('#cajaLista').hide();", 200);
		var cuentaContable = $(this).val();

		$("#descCContaServicio").val("");
		if(cuentaContable != null && cuentaContable.length > 0) {
			//Consultamos la configuracion del servicio
			var tipoConsulta = 1;
			var cuentaContableBean = {
				'cuentaCompleta':cuentaContable
			};
					
			cuentasContablesServicio.consulta(tipoConsulta, cuentaContableBean, function(cuentaContableBeanResponse) {
				if(cuentaContableBeanResponse!=null) {
					$("#descCContaServicio").val(cuentaContableBeanResponse.descripcion);
				}
			});
		}		
	});

	$('#cContaComision').blur(function(e) {
		setTimeout("$('#cajaLista').hide();", 200);
		var cuentaContable = $(this).val();

		$("#descCContaComision").val("");
		if(cuentaContable != null && cuentaContable.length > 0) {
			//Consultamos la configuracion del servicio
			var tipoConsulta = 1;
			var cuentaContableBean = {
				'cuentaCompleta':cuentaContable
			};
					
			cuentasContablesServicio.consulta(tipoConsulta, cuentaContableBean, function(cuentaContableBeanResponse) {
				if(cuentaContableBeanResponse!=null) {
					$("#descCContaComision").val(cuentaContableBeanResponse.descripcion);
				}
			});
		}		
	});

	$('#cContaIVAComisi').blur(function(e) {
		setTimeout("$('#cajaLista').hide();", 200);
		var cuentaContable = $(this).val();

		$("#descCContaIVAComisi").val("");
		if(cuentaContable != null && cuentaContable.length > 0) {
			//Consultamos la configuracion del servicio
			var tipoConsulta = 1;
			var cuentaContableBean = {
				'cuentaCompleta':cuentaContable
			};
								
			cuentasContablesServicio.consulta(tipoConsulta, cuentaContableBean, function(cuentaContableBeanResponse) {
				if(cuentaContableBeanResponse!=null) {
					$("#descCContaIVAComisi").val(cuentaContableBeanResponse.descripcion);
				}
			});
		}		
	});

	$("#ventanillaAct").click(function() {
		
		if(!$("#ventanillaAct").attr('checked')){
			$("#cobComVentanillaOculto").val("N");
			$("#cobComVentanilla").removeAttr('checked');
		}
		
		$("#cobComVentanilla").attr('disabled', !$("#ventanillaAct").attr('checked'));
		var montosActivos = $("#ventanillaAct").attr('checked') && $("#cobComVentanilla").attr('checked');
		$("#mtoCteVentanilla").attr('disabled', !montosActivos);
		$("#mtoUsuVentanilla").attr('disabled', !montosActivos);	
	});

	$("#cobComVentanilla").click(function() {
		var cobracomisionventanilla =  $("#ventanillaAct").attr('checked') && $("#cobComVentanilla").attr('checked')
		
		if(cobracomisionventanilla){
			$("#cobComVentanillaOculto").val("S");			
		}else{
			$("#cobComVentanillaOculto").val("N");	
		}
		var montosActivos = $("#ventanillaAct").attr('checked') && $("#cobComVentanilla").attr('checked');
		$("#mtoCteVentanilla").attr('disabled', !montosActivos);
		$("#mtoUsuVentanilla").attr('disabled', !montosActivos);		
	});

	$("#bancaLineaAct").click(function() {
		if(!$("#bancaLineaAct").attr('checked')){
			$("#cobComBancaLineaOculto").val("N");
			$("#cobComBancaLinea").removeAttr('checked');
		}
		$("#cobComBancaLinea").attr('disabled', !$("#bancaLineaAct").attr('checked'));
		var montosActivos = $("#bancaLineaAct").attr('checked') && $("#cobComBancaLinea").attr('checked');
		$("#mtoCteBancaLinea").attr('disabled', !montosActivos);
	});

	$("#cobComBancaLinea").click(function() {
		var cobracomisionBancaLinea =  $("#bancaLineaAct").attr('checked') && $("#cobComBancaLinea").attr('checked')
		
		if(cobracomisionBancaLinea){
			$("#cobComBancaLineaOculto").val("S");			
		}else{
			$("#cobComBancaLineaOculto").val("N");	
		}
		var montosActivos = $("#bancaLineaAct").attr('checked') && $("#cobComBancaLinea").attr('checked');
		$("#mtoCteBancaLinea").attr('disabled', !montosActivos);
	});


	$("#bancaMovilAct").click(function() {
		if(!$("#bancaMovilAct").attr('checked')){
			$("#cobComBancaMovilOculto").val("N");	
			$("#cobComBancaMovil").removeAttr('checked');
		}
		
		$("#cobComBancaMovil").attr('disabled', !$("#bancaMovilAct").attr('checked'));
		var montosActivos = $("#bancaMovilAct").attr('checked') && $("#cobComBancaMovil").attr('checked');
		$("#mtoCteBancaMovil").attr('disabled', !montosActivos);
	});

	$("#cobComBancaMovil").click(function() {
		var cobracomisionBancaMovil =  $("#cobComBancaMovil").attr('checked') && $("#cobComBancaMovil").attr('checked')
		
		if(cobracomisionBancaMovil){
			$("#cobComBancaMovilOculto").val("S");			
		}else{
			$("#cobComBancaMovilOculto").val("N");	
		}
		
		var montosActivos = $("#bancaMovilAct").attr('checked') && $("#cobComBancaMovil").attr('checked');
		$("#mtoCteBancaMovil").attr('disabled', !montosActivos);
	});

	$(".moneda").blur(function() {
		var valor = parseFloat($(this).val());
		if(isNaN(valor)) {
			return;
		}

		valor = valor.toFixed(2);
		if(valor > 9999.99 || valor < -999.99) {
			return;
		}

		$(this).val(valor);
	});

	$.consultaConfiguracionServicio = function(servicioID, clasificacionServ) {
		//Consultamos la configuracion del servicio
		var tipoConsulta = 1;
		var pslConfigServicioBean = {
				'servicioID':servicioID,
				'clasificacionServ':clasificacionServ
		};
				
		pslConfigServicioServicio.consulta(tipoConsulta, pslConfigServicioBean, function(configServicioBean) {
			$("#txtServicioID").val(configServicioBean.servicioID);
			$("#servicioID").val(configServicioBean.servicioID);
			$("#servicio").val(configServicioBean.servicio);
			$("#clasificacionServ").val(configServicioBean.clasificacionServ);
			$("#nomClasificacion").val(configServicioBean.nomClasificacion);
			$("#cContaServicio").val(configServicioBean.CContaServicio);
			$("#descCContaServicio").val(configServicioBean.descCContaServicio);
			$("#cContaComision").val(configServicioBean.CContaComision);
			$("#descCContaComision").val(configServicioBean.descCContaComision);
			$("#cContaIVAComisi").val(configServicioBean.CContaIVAComisi);
			$("#descCContaIVAComisi").val(configServicioBean.descCContaIVAComisi);
			$("#nomenclaturaCC").val(configServicioBean.nomenclaturaCC);
			$("#nombreCentroCosto").val('');
			if ($("#nomenclaturaCC").val() == '&SO') {
				$("#nombreCentroCosto").val('CENTRO DE COSTOS DE LA SUCURSAL ORIGEN');
			}
			if ($("#nomenclaturaCC").val() == '&SC') {
				$("#nombreCentroCosto").val('CENTRO DE COSTOS DE LA SUCURSAL DEL CLIENTE');
			}

			$("#ventanillaAct").attr('checked', configServicioBean.ventanillaAct=='S');			
			$("#bancaLineaAct").attr('checked', configServicioBean.bancaLineaAct=='S');
			$("#bancaMovilAct").attr('checked', configServicioBean.bancaMovilAct=='S');

			$("#cobComVentanilla").attr('checked', configServicioBean.cobComVentanilla=='S');			
			$("#cobComBancaLinea").attr('checked', configServicioBean.cobComBancaLinea=='S');
			$("#cobComBancaMovil").attr('checked', configServicioBean.cobComBancaMovil=='S');
			
			$("#cobComVentanillaOculto").val(configServicioBean.cobComVentanilla);
			$("#cobComBancaLineaOculto").val(configServicioBean.cobComBancaLinea);
			$("#cobComBancaMovilOculto").val(configServicioBean.cobComBancaMovil);
			
			$("#mtoCteVentanilla").val(configServicioBean.mtoCteVentanilla);
			$("#mtoCteBancaLinea").val(configServicioBean.mtoCteBancaLinea);
			$("#mtoCteBancaMovil").val(configServicioBean.mtoCteBancaMovil);
			$("#mtoUsuVentanilla").val(configServicioBean.mtoUsuVentanilla);


			$("#cobComVentanilla").attr('disabled', !$("#ventanillaAct").attr('checked'));
			$("#mtoCteVentanilla").attr('disabled', !($("#ventanillaAct").attr('checked') && $("#cobComVentanilla").attr('checked')));
			$("#mtoUsuVentanilla").attr('disabled', !($("#ventanillaAct").attr('checked') && $("#cobComVentanilla").attr('checked')));

			$("#cobComBancaLinea").attr('disabled', !$("#bancaLineaAct").attr('checked'));
			$("#mtoCteBancaLinea").attr('disabled', !($("#bancaLineaAct").attr('checked') && $("#cobComBancaLinea").attr('checked')));

			$("#cobComBancaMovil").attr('disabled', !$("#bancaMovilAct").attr('checked'));
			$("#mtoCteBancaMovil").attr('disabled', !($("#bancaMovilAct").attr('checked') && $("#cobComBancaMovil").attr('checked')));
		});
		
		//Consultamos la configuracion de los productos del servicio
		var tipoLista = 2;
		var pslConfigProductoBean = {
			'servicioID':servicioID,
			'clasificacionServ':clasificacionServ,
			'tipoLista':tipoLista
		};
		
		$.post("pslConfigProductoGridVista.htm", pslConfigProductoBean, function(data) {
			$("#divConfigProductos").html(data);
			$('#btnGuardar').attr('tabindex', $('#indiceTab').val());
		});

		habilitaBoton('btnGuardar', 'submit');
	}
	
	//Funcion que recarga la tabla con de configuraciones de servicio.
	function listaVistaConfiguracionServicios() {
		var params = {};
		params['tipoLista'] = 1;	
	
		$.post("pslConfigServicioGridVista.htm", params, function(data) {
			$("#divConfigServicios").html(data);
		});
	}
	
	function consultaUltimaFechaActualizacion() {
		//Consultamos la configuracion del servicio
		var tipoConsulta = 1;
		var pslParamBrokerBean = {
			'llaveParametro': '',
			'valorParametro': ''
		};
				
		pslParamBrokerServicio.consulta(tipoConsulta, pslParamBrokerBean, function(paramBrokerBeanResponse) {
			$("#fechaUltimaActualizacion").text(paramBrokerBeanResponse.fechaUltimaActualizacion);
		});
	}
	
	$.recargaGridServicios = function() {
		consultaUltimaFechaActualizacion();
		listaVistaConfiguracionServicios();
	};
	$.recargaGridServicios();
	
	$("#btnActualizarServicios").click(function(){
		$("#tipoTransaccion").val(catTipoTransaccion.actualizacionCatalogoServicios);
	});
	
	$('#btnGuardar').click(function(){
		$("#tipoTransaccion").val(catTipoTransaccion.actualizacionConfiguracionServicio);
	});
	
	$('#sucOrigen').click(function(){
		$("#nomenclaturaCC").val('&SO');
		$("#nombreCentroCosto").val('CENTRO DE COSTOS DE LA SUCURSAL ORIGEN');
	});
	
	$('#sucCliente').click(function(){
		$("#nomenclaturaCC").val('&SC');
		$("#nombreCentroCosto").val('CENTRO DE COSTOS DE LA SUCURSAL DEL CLIENTE');
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			deshabilitaBoton('btnGuardar', 'submit');
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false',null, 'callBackRecargaGridServicios', 'callBackRecargaGridServicios');
		}
    });

	$('#formaGenerica').validate({
		rules: {
			cContaServicio: {'required':function(){ return $("#tipoTransaccion").val()==1; }, 'number':function(){ return $("#tipoTransaccion").val()==1; }, 'minlength':function(){ return $("#tipoTransaccion").val()==1?8:0; }, 'maxlength':function(){ return $("#tipoTransaccion").val()==1?25:50; } },
			cContaComision: {'required':function(){ return $("#tipoTransaccion").val()==1; }, 'number':function(){ return $("#tipoTransaccion").val()==1; }, 'minlength':function(){ return $("#tipoTransaccion").val()==1?8:0; }, 'maxlength':function(){ return $("#tipoTransaccion").val()==1?25:50; } },
			cContaIVAComisi: {'required':function(){ return $("#tipoTransaccion").val()==1; }, 'number':function(){ return $("#tipoTransaccion").val()==1; }, 'minlength':function(){ return $("#tipoTransaccion").val()==1?8:0; }, 'maxlength':function(){ return $("#tipoTransaccion").val()==1?25:50; } },
			nomenclaturaCC: {'required':function(){ return $("#tipoTransaccion").val()==1; }, 'minlength':function(){ return $("#tipoTransaccion").val()==1?1:0; }},
			mtoCteVentanilla: {'number':function(){ return $("#tipoTransaccion").val()==1; }, "min":function(){ return $("#tipoTransaccion").val()==1?0:-99999999; }, "max":function(){ return $("#tipoTransaccion").val()==1?9999.99:99999999; }},
			mtoCteBancaLinea: {'number':function(){ return $("#tipoTransaccion").val()==1; }, "min":function(){ return $("#tipoTransaccion").val()==1?0:-99999999; }, "max":function(){ return $("#tipoTransaccion").val()==1?9999.99:99999999; }},
			mtoCteBancaMovil: {'number':function(){ return $("#tipoTransaccion").val()==1; }, "min":function(){ return $("#tipoTransaccion").val()==1?0:-99999999; }, "max":function(){ return $("#tipoTransaccion").val()==1?9999.99:99999999; }},
			mtoUsuVentanilla: {'number':function(){ return $("#tipoTransaccion").val()==1; }, "min":function(){ return $("#tipoTransaccion").val()==1?0:-99999999; }, "max":function(){ return $("#tipoTransaccion").val()==1?9999.99:99999999; }},
			productos: { 'required': function(){ return $("#tipoTransaccion").val()==1; } }
		},
		
		messages: {
			cContaServicio: {'required':'Especifique la cuenta contable del servicio', 'number':'La cuenta contable debe ser numerica', 'minlength': 'Verifique la cuenta contable', 'maxlength': 'Longitud máxima 25 caracteres'},
			cContaComision: {'required':'Especifique la cuenta contable de la comision', 'number':'La cuenta contable debe ser numerica', 'minlength': 'Verifique la cuenta contable', 'maxlength': 'Longitud máxima 25 caracteres'},
			cContaIVAComisi: {'required':'Especifique la cuenta contable del IVA por comision', 'number':'La cuenta contable debe ser numerica', 'minlength': 'Verifique la cuenta contable', 'maxlength': 'Longitud máxima 25 caracteres'},
			nomenclaturaCC: {'required':'Especifique el centro de costo para el servicio', 'minlength': 'Especifique el centro de costo para el servicio'},
			mtoCteVentanilla: {'number':'Especifique valor numerico', "min":'Especifique un valor mayor a cero', "max":"Especifique un valor menor a 9999.99"},
			mtoCteBancaLinea: {'number':'Especifique valor numerico', "min":'Especifique un valor mayor a cero', "max":"Especifique un valor menor a 9999.99"},
			mtoCteBancaMovil: {'number':'Especifique valor numerico', "min":'Especifique un valor mayor a cero', "max":"Especifique un valor menor a 9999.99"},
			mtoUsuVentanilla: {'number':'Especifique valor numerico', "min":'Especifique un valor mayor a cero', "max":"Especifique un valor menor a 9999.99"},
			productos: { 'required': 'Especifique nombre de producto' }
		}		
	});
	
	// ------------ Metodos -------------------------------------
	
	
   
    function inicializaPantalla() {
    	$('#btnActualizarServicios').focus();
	}
	inicializaPantalla();
}); //Fin de JQuery


function callBackRecargaGridServicios() {
	var numeroMensaje = $('#numeroMensaje').val();
	var nombreControl = $('#nombreControl').val();

	//Actualizacion del catalgo de servicios
	if($("#tipoTransaccion").val() == 2) {
		if(numeroMensaje != 0) {
			$('#btnActualizarServicios').focus();
			if($('#servicioID').val()!='' && $('#servicioID').val()>0) {
				habilitaBoton('btnGuardar', 'submit');
			}
			return;
		}

		$.recargaGridServicios();
		$('#divConfigProductos').html('');
		inicializaForma('formaGenerica');
		return;
	}


	//Actualizacion de configuracion del servicio
	habilitaBoton('btnGuardar', 'submit');
	if(numeroMensaje != 0) {
		if(nombreControl != null || nombreControl != "") {
			$('#' + nombreControl).focus();
			return;
		}	
	}
	$('#divConfigProductos').html('');
	inicializaForma('formaGenerica');
}


function ayudaCentroCostos(){	
	var data;
	
				       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura Centro Costo:</legend>'+
			'<table id="tablaLista">'+
					'<tr align="left">'+
						'<td id="encabezadoLista">&SO</td><td id="contenidoAyuda"><b>Sucursal Origen</b></td>'+
					'</tr>'+
					'<tr>'+
						'<td id="encabezadoLista" >&SC</td><td id="contenidoAyuda"><b>Sucursal Cliente</b></td>'+
					'</tr>'+ 
			'</table>'+
			'<br>'+
	 '<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+  
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplos: </legend>'+
			'<table id="tablaLista">'+
				'<tr>'+
						'<td id="encabezadoAyuda"><b>Ejemplo 1: </b></td>'+ 
						'<td id="contenidoAyuda">&SO</td>'+
				'</tr>'+
				'<tr>'+
						'<td id="encabezadoAyuda"><b>Ejemplo 2:</b></td>'+ 
						'<td id="contenidoAyuda">&SC</td>'+
				'</tr>'+
				'<tr>'+
						'<td id="encabezadoAyuda"><b>Ejemplo 3:</b></td>'+ 
						'<td id="contenidoAyuda">15</td>'+
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