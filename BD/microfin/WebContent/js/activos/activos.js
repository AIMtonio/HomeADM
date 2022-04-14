var parametroBean = consultaParametrosSession();
$(document).ready(function() {
	/******* DEFINICION DE CONSTANTES Y NUMEROS DE CONSULTAS *******/
	$("#fechaAdquisicion").datepicker({
		showOn: "button",
		buttonImage: "images/calendar.png",
		buttonImageOnly: true,
		changeMonth: true,
		changeYear: true,
		dateFormat: 'yy-mm-dd',
		yearRange: '-100:+10'
	});

	$("#fechaAdquisicion").val(parametroBean.fechaSucursal);
	esTab = false;

	var catTipoTransaccion = {
		'agrega':'1',
		'modifica':'2'
	};

	/******* FUNCIONES CARGA AL INICIAR PANTALLA *******/
	inicializaPantalla();
	funcionCargaComboTiposActivos();
	$("#activoID").focus();

    /******* VALIDACIONES DE LA FORMA *******/
	$.validator.setDefaults({submitHandler: function(event) {
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','activoID','funcionExito', 'funcionError');
	}});

	$('#formaGenerica').validate({
		rules: {
			activoID: {
				required: true
			},
			tipoActivoID: {
				required: true
			},
			descripcion: {
				required: true,
				maxlength: 300
			},
			fechaAdquisicion: {
				required: true
			},
			proveedorID: {
            required : function() {
                           return $('tipoRegistro').val() != 'P';
                        }
			},
			numFactura: {
				required: true
			},
			moi: {
				required: true
			},
			depreciadoAcumulado: {
				required: true
			},
			totalDepreciar: {
				required: true
			},
			mesesUso: {
				required: true
			},
			polizaFactura: {
				required: true
			},
			fechaRegistro: {
				required: true
			},
			centroCostoID: {
				required: true
			},
			ctaContable: {
				required: true
			},
			estatus: {
				required: true
			},
			porDepFiscal: {
				required: true,
			},
			depFiscalSaldoInicio: {
				required: true,
			},
			depFiscalSaldoFin: {
				required: true,
			}
		},
		messages: {
			activoID: {
				required: 'Especifique Número'
			},
			tipoActivoID: {
				required: 'Especifique Tipo de Activo'
			},
			descripcion: {
				required: 'Especifique Descripción',
				maxlength:  'Máximo 300 Caracteres'
			},
			fechaAdquisicion: {
				required: 'Especifique Fecha de Adquisición'
			},
			proveedorID: {
				required: 'Especifique Proveedor',
			},
			numFactura: {
				required: 'Especifique No. Factura',
			},
			moi: {
				required: 'Especifique Monto Original Inversión(MOI)',
			},
			depreciadoAcumulado: {
				required: 'Especifique Depreciado Acumulado'
			},
			totalDepreciar: {
				required: 'Especifique Total por Depreciar'
			},
			mesesUso: {
				required: 'Especifique Meses de Uso'
			},
			polizaFactura: {
				required: 'Especifique Poliza Factura'
			},
			fechaRegistro: {
				required: 'Especifique la Fecha de Registro'
			},
			centroCostoID: {
				required: 'Especifique Centro de Costos'
			},
			ctaContable: {
				required: 'Especifique Cuenta Contable'
			},
			estatus: {
				required: 'Especifique Estatus'
			},
			porDepFiscal: {
				required: 'Especifique Porcentaje Dep. Fiscal'
			},
			depFiscalSaldoInicio: {
				required: 'Especifique Dep. Fis. Inicial'
			},
			depFiscalSaldoFin: {
				required: 'Especifique Dep. Fis. Final'
			}
		}
	});

	/******* MANEJO DE EVENTOS *******/
	$(':text').focus(function() {
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.agrega);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.modifica);
	});

	$('#activoID').bind('keyup', function(e){
		lista('activoID', '2', '1', 'descripcion', $('#activoID').val(),'listaActivos.htm');
	});

	$('#activoID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			consultaActivo(this.id);
		}
		$('#tipoActivoID').focus();
	});

	$('#tipoActivoID').bind('keyup', function(e){
		lista('tipoActivoID', '2', '3', 'descripcion', $('#tipoActivoID').val(),'listaTiposActivos.htm');
	});

	$('#tipoActivoID').change(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			funcionConsultaTipoActivo(this.id);
		}
	});

	$('#fechaAdquisicion').change(function(){
		var Xfecha= $('#fechaAdquisicion').val();
		var fechaSis= parametroBean.fechaSucursal;

		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaAdquisicion').val(fechaSis);
			if( mayor(Xfecha, fechaSis)){
				mensajeSis("La Fecha de Adquisicion no Puede ser Mayor a la Fecha del Sistema");
				$('#fechaAdquisicion').val(fechaSis);
				$('#fechaAdquisicion').focus();
			}else{
				$('#fechaAdquisicion').focus();
			}
		}else{
			$('#fechaAdquisicion').val(fechaSis);
			$('#fechaAdquisicion').focus();
		}
	});

	$('#proveedorID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "primerNombre";
		camposLista[0] = "apellidoPaterno";
		parametrosLista[0] = $('#proveedorID').val();

		listaAlfanumerica('proveedorID', '2', '1', camposLista, parametrosLista, 'listaProveedores.htm');
	});

	$('#proveedorID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			consultaProveedor(this.id);
		}
	});

	$('#moi').blur(function(){
		if(esTab){
			funcionValidaMOI(this.id);
		}
	});

	$('#depreciadoAcumulado').blur(function(){
		if(esTab){
			funcionValidaDepreciadoAcumulado(this.id);
		}
	});

	$('#totalDepreciar').blur(function(){
		if(esTab){
			funcionValidaTotalDepreciar(this.id);
		}
	});

	$('#centroCostoID').bind('keyup',function(e){
		lista('centroCostoID', '2', '1', 'descripcion', $('#centroCostoID').val(), 'listaCentroCostos.htm');
	});

	$('#centroCostoID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			funcionConsultaCentroCostos(this.id);
		}
	});

	$('#ctaContable').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = $('#ctaContable').val();
		listaAlfanumerica('ctaContable', '2', '6', camposLista, parametrosLista, 'listaCuentasContables.htm');
	});

	$('#ctaContable').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			funcionConsultaCuentaCompleta(this.id);
		}
	});

	/*******  FUNCIONES PARA VALIDACIONES DE CONTROLES *******/
	//FUNCIÓN CONSULTA LOS DATOS DEL TIPO DE ACTIVO
	function consultaActivo(idControl) {
		var jqNumero = eval("'#" + idControl + "'");
		var activoID = $(jqNumero).val();
		setTimeout("$('#cajaLista').hide();", 200);
		inicializaPantalla();
		var numCon=1;
		var BeanCon = {
				'activoID':activoID
			};

		if(activoID != '' && activoID == 0){
			$("#fechaAdquisicion").val(parametroBean.fechaSucursal);
			habilitaPantalla();
			habilitaBoton('agrega','submit');
			deshabilitaBoton('modifica','submit');
			$('#tipoActivoID').focus();

		}else if(activoID != '' && !isNaN(activoID) && activoID > 0){
			activosServicio.consulta(numCon,BeanCon,function(activoBean) {

				if(activoBean!=null){
					habilitaPantalla();
					$('#activoID').val(activoBean.activoID);
					$('#tipoActivoID').val(activoBean.tipoActivoID);
                    $('#tipoRegistro').val(activoBean.tipoRegistro);
					funcionConsultaTipoActivo('tipoActivoID');
					$('#descripcion').val(activoBean.descripcion);
					$('#fechaAdquisicion').val(activoBean.fechaAdquisicion);
					$('#proveedorID').val(activoBean.proveedorID);
					consultaProveedor('proveedorID');

					$('#numFactura').val(activoBean.numFactura);
					$('#numSerie').val(activoBean.numSerie);
					$('#moi').val(activoBean.moi);
					$('#depreciadoAcumulado').val(activoBean.depreciadoAcumulado);
					$('#totalDepreciar').val(activoBean.totalDepreciar);

					$('#mesesUso').val(activoBean.mesesUso);
					$('#numeroConsecutivo').val(activoBean.numeroConsecutivo);
					$('#porDepFiscal').val(activoBean.porDepFiscal);
					$('#depFiscalSaldoInicio').val(activoBean.depFiscalSaldoInicio);
					$('#depFiscalSaldoFin').val(activoBean.depFiscalSaldoFin);


					//VALIDA SI EL ACTIVO NO SE HA DEPRECIADO ES EDITABLE
					if(activoBean.esEditable != 'S'){
						deshabilitaControl("fechaAdquisicion");
						deshabilitaControl("mesesUso");
						$("#fechaAdquisicion").datepicker("destroy");
					}

					$('#polizaFactura').val(activoBean.polizaFactura);
					$('#centroCostoID').val(activoBean.centroCostoID);
					funcionConsultaCentroCostos('centroCostoID');
					$('#ctaContable').val(activoBean.ctaContable);
					funcionConsultaCuentaCompleta('ctaContable');
					$('#estatus').val(activoBean.estatus);


					if(activoBean.tipoRegistro == 'A'){//modificacion registro automatico activo
						deshabilitaControl("proveedorID");
						deshabilitaControl("numFactura");
						deshabilitaControl("moi");
						deshabilitaControl("depreciadoAcumulado");
						deshabilitaControl("totalDepreciar");
						deshabilitaControl("polizaFactura");
						deshabilitaControl("ctaContable");
					}else{
						//modificacion registro manual activo
						deshabilitaPantalla();

						//VALIDA SI EL ACTIVO NO SE HA DEPRECIADO ES EDITABLE
						if(activoBean.esEditable == 'S'){
							habilitaControl("moi");
							habilitaControl("depreciadoAcumulado");
							habilitaControl("totalDepreciar");
							habilitaControl("polizaFactura");
							habilitaControl("ctaContable");
							habilitaControl("porDepFiscal");
							habilitaControl("depFiscalSaldoInicio");
							habilitaControl("depFiscalSaldoFin");
							habilitaControl("centroCostoID");
							habilitaControl("numSerie");
							habilitaControl("descripcion");
							habilitaControl("tipoActivoID");
							habilitaControl("proveedorID");
							habilitaControl("numFactura");
							habilitaControl("fechaAdquisicion");
							habilitaControl("mesesUso");
							$("#fechaAdquisicion").datepicker({
								showOn: "button",
								buttonImage: "images/calendar.png",
								buttonImageOnly: true,
								changeMonth: true,
								changeYear: true,
								dateFormat: 'yy-mm-dd',
								yearRange: '-100:+10'
							});
						}
					}

					$("#fechaRegistro").val(activoBean.fechaRegistro);

					if(activoBean.estatus == 'VI'){
						habilitaControl('estatus');
						habilitaBoton('modifica','submit');
					}else{
						deshabilitaControl('estatus');
						deshabilitaBoton('modifica','submit');
					}

					deshabilitaBoton('agrega','submit');
					agregaFormatoControles('formaGenerica');
				}else{
					$(jqNumero).val('');
					$(jqNumero).focus();
					mensajeSis('No Existe el Activo');
				}
			});
		}else{
			if(isNaN(activoID)){
				$(jqNumero).val('');
				$(jqNumero).focus();
				mensajeSis('No Existe el Activo');
			}
		}
	}
	//FUNCIÓN CONSULTA PROVEEDORES
	function consultaProveedor(idControl) {
		var jqNumero = eval("'#" + idControl + "'");
		var proveedorID = $(jqNumero).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var numCon=1;
		var BeanCon = {
				'proveedorID':proveedorID
			};

		if(proveedorID != '' && !isNaN(proveedorID) && proveedorID > 0){
			proveedoresServicio.consulta(numCon,BeanCon,function(proveedores) {
				if(proveedores!=null){
					var nombreCompleto ="";
					if(proveedores.estatus != 'A'){
						$(jqNumero).val('');
						$('#nombreProveedor').val('');
						$(jqNumero).focus();
						mensajeSis("El Proveedor se encuentra Inactivo");
					}else{
						if(proveedores.tipoPersona == 'F' ){
							nombreCompleto = proveedores.primerNombre+" "+proveedores.segundoNombre+" "+proveedores.apellidoPaterno+" "
							+proveedores.apellidoMaterno;
						}
						if(proveedores.tipoPersona == 'M' ){
							nombreCompleto = proveedores.razonSocial;
						}
						$('#nombreProveedor').val(nombreCompleto);
					}
				}else{
					$(jqNumero).val('');
					$('#nombreProveedor').val('');
					$(jqNumero).focus();
					mensajeSis("El Proveedor No Existe.");
				}
			});
		}else{
            if($('#tipoRegistro').val() == 'P'){
                $(jqNumero).val('0');
                $('#nombreProveedor').val('Proveedor No Identificado');
            } else{
                if(isNaN(proveedorID)){
                    $(jqNumero).val('');
                    $('#nombreProveedor').val('');
                    $(jqNumero).focus();
                    mensajeSis('No Existe el Activo');
                }else{
                    if(proveedorID == 0 || proveedorID == ''){
                        $(jqNumero).val('');
                        $('#nombreProveedor').val('');
                    }
                }
            }
		}
	}

	// FUNCION CONSULTAR TIPO DE ACTIVO
	function funcionConsultaTipoActivo(idControl){
		var jqNumero = eval("'#" + idControl + "'");
		var tipoActivoID = $(jqNumero).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var numCon=1;
		var BeanCon = {
			'tipoActivoID':tipoActivoID
		};

		$('#clasificaActivoID').val("");
		$('#tiempoAmortiMeses').val("");
		if(tipoActivoID != '' && !isNaN(tipoActivoID) && tipoActivoID > 0){
			tiposActivosServicio.consulta(numCon,BeanCon,{ async: false, callback: function(tipoActivoBean) {
				if(tipoActivoBean!=null){
					$('#descripcionActivo').val(tipoActivoBean.descripcionCorta);
					$('#clasificaActivoID').val(tipoActivoBean.clasificaActivoID);
					$('#tiempoAmortiMeses').val(tipoActivoBean.tiempoAmortiMeses);
					$('#mesesUso').val(tipoActivoBean.tiempoAmortiMeses);
				}else{
					$(jqNumero).val('');
					$('#descripcionActivo').val('');
					$(jqNumero).focus();
					mensajeSis('No Existe el Tipo de Activo');
				}
			}});
		}else{
			if(isNaN(tipoActivoID)){
				$(jqNumero).val('');
				$('#descripcionActivo').val('');
				$(jqNumero).focus();
				mensajeSis('No Existe el Tipo de Activo');
			}else{
				if(tipoActivoID == '' || tipoActivoID == 0){
					$(jqNumero).val('');
					$('#descripcionActivo').val('');
				}
			}
		}
	}

	// FUNCION CONSULTA CENTRO DE COSTOS
	function funcionConsultaCentroCostos(idControl) {
		var jqNumCentroCosto = eval("'#" + idControl + "'");
		var numCentroCosto = $(jqNumCentroCosto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var numCon=1;
		var BeanCon = {
			'centroCostoID':numCentroCosto
		};

		if(numCentroCosto != '' && !isNaN(numCentroCosto) && numCentroCosto > 0){
			centroServicio.consulta(numCon,BeanCon,function(centro) {
				if(centro!=null){
					$('#descripcionCenCos').val(centro.descripcion);
				}else{
					if(isNaN(numCentroCosto)){
						$(jqNumCentroCosto).val('');
						$('#descripcionCenCos').val('');
						$(jqNumCentroCosto).focus();
						mensajeSis('No Existe el Centro de Costos');
					}else{
						if(numCentroCosto == 0 || numCentroCosto == ''){
							$(jqNumCentroCosto).val('');
							$('#descripcionCenCos').val('');
						}
					}
				}
			});
		}else{
			if(isNaN(numCentroCosto)){
				$(jqNumCentroCosto).val('');
				$('#descripcionCenCos').val('');
				$(jqNumCentroCosto).focus();
				mensajeSis('No Existe el Centro de Costos');
			}else{
				if(numCentroCosto == 0 || numCentroCosto == ''){
					$(jqNumCentroCosto).val('');
					$('#descripcionCenCos').val('');
				}
			}
		}
	}

	// FUNCION CUENTA CONTABLE
	function funcionConsultaCuentaCompleta(idControl) {
		var jqCtaContable = eval("'#" + idControl + "'");
		var numCtaContable = $(jqCtaContable).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var conPrincipal = 1;
		var CtaContableBeanCon = {
				'cuentaCompleta':numCtaContable
		};

		if(numCtaContable != '' && !isNaN(numCtaContable)){
			cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){
					$('#descripcionCtaCon').val(ctaConta.descripcion);
				}else{
					$(jqCtaContable).val();
					$(jqCtaContable).focus();
					$('#descripcionCtaCon').val("");
					mensajeSis("La Cuenta Contable no Existe.");
				}
			});
		}else{
			if(numCtaContable == 0 || numCtaContable == ''){
				$(jqCtaContable).val('');
				$('#descripcionCtaCon').val('');
			}
		}
	}

	function funcionValidaMOI(idControl) {
		var jqMonto = eval("'#" + idControl + "'");
		var monto = $(jqMonto).asNumber();

		if(monto != '' && !isNaN(monto) && monto > 0){
			$('#depreciadoAcumulado').val('0.00');
			$('#totalDepreciar').val(monto);
			$('#depFiscalSaldoInicio').val(monto);
			agregaFormatoControles('formaGenerica');
		}
	}

	function funcionValidaDepreciadoAcumulado(idControl) {
		var jqMonto = eval("'#" + idControl + "'");
		var monto = $(jqMonto).asNumber();
		if(monto != '' && !isNaN(monto) && monto > 0){
			if(monto > $('#moi').asNumber()){
				mensajeSis('El Depreciado Acumulado no puede ser Mayor al MOI');
				$(jqMonto).val('');
				$(jqMonto).focus();
			}else{
				var depreAcumu = $('#moi').asNumber() - monto;
				$('#totalDepreciar').val(depreAcumu);
				agregaFormatoControles('formaGenerica');
			}
		}else{
            var depreAcumu = $('#moi').asNumber();
            $('#totalDepreciar').val(depreAcumu);
            agregaFormatoControles('formaGenerica');
        }
	}

	function funcionValidaTotalDepreciar(idControl) {
		var jqMonto = eval("'#" + idControl + "'");
		var monto = $(jqMonto).asNumber();

		if(monto != '' && !isNaN(monto) && monto > 0){
			if(monto > $('#moi').asNumber()){
				mensajeSis('El Total por Depreciar no puede ser Mayor al MOI');
				$(jqMonto).val('');
				$(jqMonto).focus();
			}
		}
	}

	// FUNCION VALIDA FECHA FORMATO (YYYY-MM-DD)
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

	// FUNCION PARA COMPROBAR EL AÑO BISIESTO
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}

	// VALIDA SI FECHA > FECHA2: TRUE ELSE FALSE
	function mayor(fecha, fecha2){
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

	function habilitaPantalla(){
		habilitaControl("tipoActivoID");
		habilitaControl("descripcion");
		habilitaControl("fechaAdquisicion");
		habilitaControl("proveedorID");
		habilitaControl("numFactura");
		habilitaControl("numSerie");
		habilitaControl("moi");
		habilitaControl("depreciadoAcumulado");
		habilitaControl("totalDepreciar");
		habilitaControl("porDepFiscal");
		habilitaControl("depFiscalSaldoInicio");
		habilitaControl("depFiscalSaldoFin");
		habilitaControl("polizaFactura");
		habilitaControl("centroCostoID");
		habilitaControl("ctaContable");
		deshabilitaControl('estatus');
		deshabilitaControl("mesesUso");

		$("#fechaAdquisicion").datepicker({
			showOn: "button",
			buttonImage: "images/calendar.png",
			buttonImageOnly: true,
			changeMonth: true,
			changeYear: true,
			dateFormat: 'yy-mm-dd',
			yearRange: '-100:+10'
		});
		$('#estatus').val('VI');

	}

	function deshabilitaPantalla(){
		deshabilitaControl("tipoActivoID");
		deshabilitaControl("descripcion");
		deshabilitaControl("fechaAdquisicion");
		deshabilitaControl("proveedorID");
		deshabilitaControl("numFactura");
		deshabilitaControl("numSerie");
		deshabilitaControl("moi");
		deshabilitaControl("depreciadoAcumulado");
		deshabilitaControl("totalDepreciar");
		deshabilitaControl("porDepFiscal");
		deshabilitaControl("depFiscalSaldoInicio");
		deshabilitaControl("depFiscalSaldoFin");
		deshabilitaControl("polizaFactura");
		deshabilitaControl("centroCostoID");
 		deshabilitaControl("ctaContable");
		$("#fechaAdquisicion").datepicker("destroy");

	}

}); // FIN $(DOCUMENT).READY()


//FUNCION INICIALIZA PANTALLA
function inicializaPantalla(){
	inicializaForma('formaGenerica','activoID');
	agregaFormatoControles('formaGenerica');
	$('#estatus').val('');
	$("#fechaRegistro").val(parametroBean.fechaSucursal);
	$("#sucursalID").val(parametroBean.sucursal);

	deshabilitaBoton('agrega','submit');
	deshabilitaBoton('modifica','submit');
	$("#fechaAdquisicion").datepicker("destroy");

}

function funcionCargaComboTiposActivos(){
	dwr.util.removeAllOptions('tipoActivoID');
	tiposActivosServicio.listaComboTiposActivos(2, function(beanLista){
		dwr.util.addOptions('tipoActivoID', {'':'SELECCIONAR'});
		dwr.util.addOptions('tipoActivoID', beanLista, 'tipoActivoID', 'descripcionCorta');
	});
}

//FUNCIÓN SOLO ENTEROS SIN PUNTOS NI CARACTERES ESPECIALES
function validaSoloNumero(e,elemento){//Recibe al evento
	var key = '';
	if(window.event){//Internet Explorer ,Chromium,Chrome
		key = e.keyCode;
	}else if(e.which){//Firefox , Opera Netscape
		key = e.which;
	}

	 if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja
	    return false;
	 return true;
}

//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	inicializaPantalla();
	funcionCargaComboTiposActivos();
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
	agregaFormatoControles('formaGenerica');
}