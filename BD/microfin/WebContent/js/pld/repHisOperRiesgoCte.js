$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();
    consultaProcesoEscalamiento();
	deshabilitaBoton('generar', 'submit');

	var catTipoRepVencimientos = { 
		'PDF'		: 1,
		'EXCEL'		: 2
	};
	
	inicializa();

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);
	});

	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#procesoEscalamientoID').blur(function(e) {
		activaTipoPresentacion();
	});

	$('#procesoEscalamientoID').change(function(e) {
	    activaTipoPresentacion();
	});
	
	$('#fechaInicio').change(function() {
		var fechaInicial= $('#fechaInicio').val().trim();
		if(esFechaValida(fechaInicial)){
			if(fechaInicial==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var fechaFinal= $('#fechaFin').val().trim();
			if (fechaInicial > fechaFinal){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var fechaInicial= $('#fechaInicio').val().trim();
		var fechaFinal= $('#fechaFin').val().trim();
		if(esFechaValida(fechaFinal)){
			if(fechaFinal==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if (fechaInicial > fechaFinal){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}
			if (fechaFinal > parametroBean.fechaSucursal){
				mensajeSis("La Fecha de Final es mayor a la Fecha del Sistema.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#generar').click(function() { 
		generaPDF();
	});

	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var varclienteID = $(jqCliente).val();	
		var conCliente =5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);	
		if(varclienteID != '' && !isNaN(varclienteID) && Number(varclienteID)!=0 && esTab){
			clienteServicio.consulta(conCliente,varclienteID,rfc,function(cliente){
				if(cliente!=null){
					if(cliente.esMenorEdad != 'S'){
						$('#clienteID').val(cliente.numero)	;						
						$('#nombreCliente').val(cliente.nombreCompleto);
						habilitaBoton('generar', 'submit');
					}else{
						mensajeSis("El " + $('#alertSocio').val() + " Es Menor de Edad.");
						$(jqCliente).focus();
						$(jqCliente).val('');
						deshabilitaBoton('generar', 'submit');
					}
				}else{
					mensajeSis("No Existe el "  + $('#alertSocio').val() + ".");
					$(jqCliente).focus();
					$(jqCliente).val('');
					deshabilitaBoton('generar', 'submit');
				}    						
			});
		} else if(esTab) {
			mensajeSis("Ingrese un "  + $('#alertSocio').val() + ".");
			$('#clienteID').val('');
			$('#clienteID').focus();
			$('#nombreCliente').val('');
		}
	}

	function generaPDF() {
		var ligaGenerar			= '';
		var tipoReporte			= $('input:radio[name=tipoReporte]:checked').val();
		var clienteID			= $('#clienteID').asNumber();
		var fechaSistema		= parametroBean.fechaSucursal;
		var usuario				= parametroBean.claveUsuario;
		var nombreCliente		= encodeURIComponent($('#nombreCliente').val().trim());
	    var nombreInstitucion	= parametroBean.nombreInstitucion; 
	    var fechaInicio			= $('#fechaInicio').val();
	    var operProcesoID		= $("#procesoEscalamientoID option:selected").val();
	    var operProcesoDesc		= $("#procesoEscalamientoID option:selected").text();
	    var fechaFin			= $('#fechaFin').val();
		if(clienteID != 0){
			ligaGenerar = 'reporteHisOperacionesRiesgoCtePLD.htm?' + 
				'&fechaSistema=' 	+ fechaSistema +
				'&clienteID=' 		+ clienteID +
				'&nombreCliente=' 	+ nombreCliente.toUpperCase() +
				'&nomUsuario=' 		+ usuario.toUpperCase() +
				'&nomInstitucion='	+ nombreInstitucion.toUpperCase() +
				'&fechaInicio='		+ fechaInicio +
				'&fechaFin=' 		+ fechaFin +
				'&operProcesoID=' 	+ operProcesoID +
				'&descripcion=' 	+ operProcesoDesc +
				'&tipoReporte=' 	+ tipoReporte;

			window.open(ligaGenerar, '_blank');
		} else {
			mensajeSis("Ingrese un "  + $('#alertSocio').val() + ".");
			$('#clienteID').val('');
			$('#clienteID').focus();
			$('#nombreCliente').val('');
		}
	}
	
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
				mensajeSis("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea");
				return false;
			}
			return true;
		}
	}
	function inicializa(){
	    $('#procesoEscalamientoID').focus();
		$('#clienteID').val('');
		$('#nombreCliente').val('');
		$('#fechaInicio').val(parametroBean.fechaSucursal);
		$('#fechaFin').val(parametroBean.fechaSucursal);
		habilitaBoton('generar');
	}

	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}

	// funcion para llenar el combo de procesos de escalamiento
	function consultaProcesoEscalamiento() {
		var tipoReporte = 2;
		dwr.util.removeAllOptions('procesoEscalamientoID');
		dwr.util.addOptions('procesoEscalamientoID', {
			'0': 'TODAS'
		});
		procesoEscalamientoInternoServicio.listaCombo(tipoReporte, function(procesoEscala) {
			dwr.util.addOptions('procesoEscalamientoID', procesoEscala, 'procesoEscalamientoID', 'descripcion');
		});
	}

	function activaTipoPresentacion(){
		var operProcesoID = $("#procesoEscalamientoID option:selected").val();
		if(operProcesoID == '0' || operProcesoID == 'EVALPERIODO'){
			deshabilitaControl('tipoReportePDF');
			deshabilitaControl('tipoReporteEXCEL');
			$('#tipoReporteEXCEL').attr('checked', true);
		} else {
			habilitaControl('tipoReportePDF');
			habilitaControl('tipoReporteEXCEL');
			$('#tipoReportePDF').attr('checked', true);
		}
	}
});