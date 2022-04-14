var esTab = false;
var parametroBean = consultaParametrosSession();
var catTipoConsultaCredito = {
	'principal'	: 1
};
var var_SucursalID = 0;
var var_RestringReporte = "N";
$(document).ready(function() {

	inicializarPantalla();

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#formaGenerica').validate({
		rules : {
			fechaInicio : {
				required : true
			},
			fechaFinal : {
				required : true
			}
		},
		messages : {
			fechaInicio : {
				required : 'La Fecha de Inicio es Requerida.',
			},
			fechaFinal : {
				required : 'La Fecha Fin es Requerida.',
			}
		}
	});
	$('#generar').click(function() {
		generaReporte();
	});

	$('#fechaInicio').change(function() {
		var Xfecha = $('#fechaInicio').val();
		if (esFechaValida(Xfecha)) {
			if (Xfecha == '') {
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}

			var Yfecha = $('#fechaFinal').val();
			if (mayor(Xfecha, Yfecha)) {
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			} else {
				if ($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Inicio es Mayor a la Fecha del Sistema.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
					$('#fechaInicio').focus();
				} else if ($("#sucursalID").val() == 0) {
					fechaFinal = sumaMesesFechaHabil($('#fechaInicio').val(), 1);
					if (fechaFinal > parametroBean.fechaSucursal) {
						fechaFinal = parametroBean.fechaSucursal;
					}
					if ($('#fechaFinal').val() > fechaFinal) {
						$('#fechaFinal').val(fechaFinal);
					}
				}
			}

		} else {
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFinal').change(function() {
		if (!validacion.esFechaValida($('#fechaInicio').val())) {
			$('#fechaInicio').val('');
			$('#fechaInicio').focus();
		} else {
			var Xfecha = $('#fechaInicio').val();
			var Yfecha = $('#fechaFinal').val();
			if (esFechaValida(Yfecha)) {
				if (Yfecha == '') {
					$('#fechaFinal').val(parametroBean.fechaSucursal);
				}
				if (mayor(Xfecha, Yfecha)) {
					mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaFinal').val(parametroBean.fechaSucursal);
					$('#fechaFinal').focus();
				} else {
					if ($('#fechaFinal').val() > parametroBean.fechaSucursal) {
						mensajeSis("La Fecha de Fin  es Mayor a la Fecha del Sistema.");
						$('#fechaFinal').val(parametroBean.fechaSucursal);
						$('#fechaFinal').focus();
					} else if ($('#sucursalID').asNumber()==0 && $('#fechaFinal').val() > fechaFinal) {
						$('#fechaFinal').val(fechaFinal);
					}
				}
			} else {
				$('#fechaFinal').val(parametroBean.fechaSucursal);
			}
		}
	});

	/**
	 * Consulta la lista de coordinadores
	 */
	$('#coordinadorID').bind('keyup',function(e){
		var tipoLista = 18;
		lista('coordinadorID', '2', tipoLista, 'nombreCompleto', $('#coordinadorID').val(), 'listaUsuarios.htm');
	});

	/**
	 * Consulta el coordinador
	*/
	$('#coordinadorID').blur(function() {
		if(esTab){
			consultaUsuario(this.id);
		}
	});

	/**
	 * Consulta la lista de promotores
	 */
	$('#promotorID').bind('keyup',function(e){
		var tipoListaProm = 0;
		var camposLista = new Array();
		var parametrosLista = new Array();
		//Cuando es por sucursal
		if(var_SucursalID > 0){
			camposLista[0] = "nombrePromotor";
			camposLista[1] = "sucursalID";
			parametrosLista[0] = $('#promotorID').val();
			parametrosLista[1] = var_SucursalID;
			tipoListaProm = 2;
		}else{
			//Cuando no es por sucursal
			camposLista[0] = "nombrePromotor";
			camposLista[1] = "sucursalID";
			parametrosLista[0] = $('#promotorID').val();
			parametrosLista[1] = 0;
			tipoListaProm = 10;
		}
		lista('promotorID', '2', tipoListaProm, camposLista, parametrosLista, 'listaPromotores.htm');
	});

	/**
	 * Consulta el promotr
	*/
	$('#promotorID').blur(function() {
		if(esTab){
			consultaPromotor(this.id);
		}
	});

	//Funciones
	consultaSucursales();
	//Objetos de inicio
	$('#coordinadorID').val(0);
	$('#nombreCoordinador').val('TODOS');
	$('#promotorID').val(0);
	$('#nombrePromotor').val('TODOS');
	deshabilitaControl('promotorID');
	consultaParametrosSistema();
});

	function inicializarPantalla() {
		$('#fechaInicio').val(parametroBean.fechaSucursal);
		$('#fechaFinal').val(parametroBean.fechaSucursal);
		agregaFormatoControles('formaGenerica');
		$('#fechaInicio').focus();
	}

	function generaReporte() {
		if ($("#formaGenerica").valid() && var_RestringReporte == "S") {
			var fechaInicio = $("#fechaInicio").val();
			var fechaFinal = $("#fechaFinal").val();
			var usuario = parametroBean.claveUsuario;
			var nombreInstitucion = parametroBean.nombreInstitucion;
			var tipoReporte = 1;
			var tipoLista = 1;
			var rep_sucursalID = $('#sucursalID').val();
			var rep_nombreSucursal = $("#sucursalID option:selected").text();
			var rep_coordinadorID = $('#coordinadorID').val();
			var rep_nombreCoordinador = $('#nombreCoordinador').val();
			var rep_promotorID = $('#promotorID').val();
			var rep_nombrePromotor = $('#nombrePromotor').val();
			var liga = 'repOperacionBasicaUnidad.htm?' +
				'fechaInicio=' + fechaInicio +
				'&fechaFin=' + fechaFinal +
				'&usuario=' + usuario +
				'&parFechaEmision=' + parametroBean.fechaSucursal +
				'&nombreInstitucion=' + nombreInstitucion +
				'&sucursalID='+ rep_sucursalID +
				'&nombreSucursal='+ rep_nombreSucursal +
				'&coordinadorID='+ rep_coordinadorID +
				'&nombreCoordinador='+ rep_nombreCoordinador +
				'&promotorID='+ rep_promotorID +
				'&nombrePromotor='+ rep_nombrePromotor +
				'&tipoReporte=' + tipoReporte +
				'&tipoLista=' + tipoLista;
				window.open(liga, '_blank');
		}else{
			mensajeSis("El reporte solo aplica cuando la restricción de reportes se encuentra activa.");
		}
	}

	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd)");
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
				mensajeSis("Fecha Introducida Errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha Introducida Errónea");
				return false;
			}
			return true;
		}
	}
	function mayor(fecha, fecha2){

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
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}

	/**
	 * Funcion para llenar el combo de sucursales
	*/
	function consultaSucursales() {
		var sucursalBean = {
			'sucursalID' : ''
		};
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions('sucursalID', {
			'0' : 'TODAS'
		});
		sucursalesServicio.listaCombo(2, sucursalBean, function(sucursales) {
			if (sucursales != null) {
				dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
			}
		});
	}

	/**
	 * Consulta el usuario
	 */
	function consultaUsuario(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();
		var conUsuario = 21;
		var usuarioBeanCon = {
			'usuarioID': numUsuario
		  };
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) && numUsuario > 0){
			//Se habilita el campo cuando es mayor a cero
			habilitaControl('promotorID');
			usuarioServicio.consulta(conUsuario,usuarioBeanCon,function(usuarioBean){
						if(usuarioBean!=null){
							var_SucursalID = 0;
							$('#nombreCoordinador').val(usuarioBean.nombreCompleto);
							var_SucursalID = usuarioBean.sucursalUsuario;
							$('#promotorID').focus();
						}else{
							mensajeSis("El Usuario no existe o no es un Coordinador.");
							$('#nombreCoordinador').val('');
							$('#coordinadorID').focus();
						}
				});
			}
			else{
				if(numUsuario == 0){
					$('#coordinadorID').val(0);
					$('#nombreCoordinador').val('TODOS');
					$('#promotorID').val(0);
					$('#nombrePromotor').val('TODOS');
					deshabilitaControl('promotorID');
				}else{
					mensajeSis("El Usuario no existe o no es un Coordinador.");
				}
			}
		}

		/**
		 * Consulta el promotor
		*/
		function consultaPromotor(idControl) {
			var jqPromotor = eval("'#" + idControl + "'");
			var numPromotor = $(jqPromotor).val();
			var tipoConsultaPromotor = 0;
			//Cuando la consulta es por Surcusal
			if(var_SucursalID > 0){
				tipoConsultaPromotor = 9;
			}else{
				//Cuando no lo es
				tipoConsultaPromotor = 4;
			}
			var promotorBean = {
				'promotorID' : numPromotor,
				'sucursalID' : var_SucursalID
			};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numPromotor != '' && !isNaN(numPromotor) && numPromotor > 0){
					promotoresServicio.consulta(tipoConsultaPromotor,promotorBean, function(promotor) {
						if(promotor!=null){
							$('#nombrePromotor').val(promotor.nombrePromotor);

						}else{
							mensajeSis("El Promotor no Existe o no se encuentra Activo");
							$('#nombrePromotor').val('');
							$('#promotorID').focus();
						}
				});
			}else{
				if(numPromotor == 0){
					$('#promotorID').val(0);
					$('#nombrePromotor').val('TODOS');
				}else{
					mensajeSis("El Promotor no Existe o no se encuentra Activo");
				}
			}
		}

	//Consulta para ver si la bandera de restrinccion reporte se encuentra activo
	function consultaParametrosSistema() {
		var numEmpresaID = 1;
		var tipoCon = 1;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean, { async: false, callback:function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				var_RestringReporte = parametrosSisBean.restringeReporte;
			}
		}});
	}