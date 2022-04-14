$(document).ready(function () {

	agregaFormatoControles('formaGenerica');
	$('#fechaInicial').focus();

	$('#fechaInicial').val(parametroBean.fechaSucursal);
	$('#fechaFinal').val(parametroBean.fechaSucursal);

	$('#usuarioID').val(0);
	$('#sucursalID').val(0);
	$('#remesadoraID').val(0);
	$('#nombreUsuario').val('TODOS');
	$('#sucursal').val('TODAS');
	$('#remesadora').val('TODAS');

	$('#fechaInicial').change(e => validaFechaInicial(e.target.value));

	$('#fechaFinal').change(e => validaFechaFinal(e.target.value));

	$('#remesadoraID').bind('keyup', function (e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombre";
		parametrosLista[0] = $('#remesadoraID').val();
		listaAlfanumerica('remesadoraID', '1', '1', camposLista, parametrosLista, 'listaCatalogoRemesadora.htm');
	});

	$('#remesadoraID').blur(function () {

		ocultaLista();
		var remesadoraID = $('#remesadoraID').val();

		if (+remesadoraID > 0) {

			var bean = {
				'remesaCatalogoID': remesadoraID
			};

			catalogoRemesasServicio.consulta(1, bean, function (remesadora) {

				if (remesadora != null) {
					$('#remesadora').val(remesadora.nombreCorto);
				} else {
					mensajeSis("El número de remesadora ingresado no existe.");
					$('#remesadoraID').focus();
					$('#remesadoraID').val('0');
					$('#remesadora').val('TODAS');
				}
			});
		} else {

			$('#remesadoraID').val('0');
			$('#remesadora').val('TODAS');
		}
	});

	$('#sucursalID').bind('keyup', function (e) {
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalID', 2, 1, 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});

	$('#sucursalID').blur(function () {

		ocultaLista();
		var sucursalID = $('#sucursalID').val();

		if (+sucursalID > 0) {

			sucursalesServicio.consultaSucursal(1, sucursalID, function (sucursal) {

				if (sucursal != null) {

					$('#sucursal').val(sucursal.nombreSucurs);
				} else {
					mensajeSis("El número de sucursal ingresado no existe.");
					$('#sucursalID').focus();
					$('#sucursalID').val('0');
					$('#sucursal').val('TODAS');
				}
			});
		} else {
			$('#sucursalID').val('0');
			$('#sucursal').val('TODAS');
		}
	});

	$('#usuarioID').bind('keyup', function (e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = 'usuarioID';
		camposLista[0] = 'nombreCompleto';
		parametrosLista[0] = $('#usuarioID').val();
		parametrosLista[1] = $('#nombreUsuario').val();

		lista('usuarioID', 1, 14, camposLista, parametrosLista, 'listaUsuarios.htm');
	});

	$('#usuarioID').blur(function () {

		ocultaLista();
		var usuarioID = $('#usuarioID').val();

		if (+usuarioID > 0) {

			var usuarioBeanCon = {
				'usuarioID': usuarioID
			};

			usuarioServicio.consulta(1, usuarioBeanCon, function (usuario) {

				if (usuario != null) {
					$('#nombreUsuario').val(usuario.nombreCompleto);
				} else {
					mensajeSis('El usuario ingresado no existe.');
					$('#usuarioID').focus();
					$('#usuarioID').val(0);
					$('#nombreUsuario').val('TODOS');
				}
			});
		} else {

			$('#usuarioID').val(0);
			$('#nombreUsuario').val('TODOS');
		}
	});

	$('#generar').click(function () {

		//AUDITORIA DEL REPORTE
		var fechaSistema = parametroBean.fechaAplicacion;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var usuarioSistema = parametroBean.claveUsuario;

		//PARAMETROS DEL REPORTE
		var fechaInicial = $('#fechaInicial').val();
		var fechaFinal = $('#fechaFinal').val();
		var remesadoraID = $('#remesadoraID').val() || 0;
		var remesadora = $('#remesadora').val() || 'TODAS';
		var sucursalID = $('#sucursalID').val() || 0;
		var sucursal = $('#sucursal').val() || 'TODAS';
		var usuarioID = $('#usuarioID').val() || 0;
		var nombreUsuario = $('#nombreUsuario').val() || 'TODOS';
		var tipoReporte = $('#excel').is(':checked') ? 1 : 0;

		if (validaFechaInicial(fechaInicial) == false || validaFechaFinal(fechaFinal) == false) {
			return;
		}

		if (isNaN(remesadoraID)) {
			mensajeSis("El campo Remesadora debe contener un valor númerico.");
			$('#remesadoraID').focus();
			return;
		}

		if (isNaN(sucursalID)) {
			mensajeSis("El campo Sucursal debe contener un valor númerico.");
			$('#sucursalID').focus();
			return;
		}

		if (isNaN(usuarioID)) {
			mensajeSis("El campo Usuario debe contener un valor númerico.");
			$('#usuarioID').focus();
			return;
		}

		var pagina = 'repRemesasPagadas.htm?' +
			'remesadoraID=' + remesadoraID +
			'&remesadora=' + remesadora +
			'&sucursalID=' + sucursalID +
			'&sucursal=' + sucursal +
			'&usuarioID=' + usuarioID +
			'&nombreUsuario=' + nombreUsuario +
			'&fechaInicial=' + fechaInicial +
			'&fechaFinal=' + fechaFinal +
			'&fechaSistema=' + fechaSistema +
			'&presentacion=' + tipoReporte +
			'&usuarioSistema=' + usuarioSistema +
			'&nombreInstitucion=' + nombreInstitucion +
			'&tipoRep=' + tipoReporte;

		window.open(pagina, '_blank');
	});

	function validaFechaInicial(fechaInicial) {

		if (validacion.esFechaValida(fechaInicial)) {

			if (fechaInicial > parametroBean.fechaSucursal || fechaInicial > $('#fechaFinal').val()) {

				if (fechaInicial > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha Inicial no puede ser mayor a la fecha del sistema");
					$('#fechaInicial').val(parametroBean.fechaSucursal);
				} else {
					mensajeSis("La Fecha Inicial no puede ser mayor a la Fecha Final");
					$('#fechaInicial').val($('#fechaFinal').val());
				}

				$('#fechaInicial').focus();
				return false;
			}
		} else {

			mensajeSis("Formato de Fecha Inicial no válido <br> (aaaa-mm-dd)");
			$('#fechaInicial').val(parametroBean.fechaSucursal);
			$('#fechaInicial').focus();
			return false;
		}
	}

	function validaFechaFinal(fechaFinal) {

		if (validacion.esFechaValida(fechaFinal)) {

			if (fechaFinal > parametroBean.fechaSucursal || fechaFinal < $('#fechaInicial').val()) {

				if (fechaFinal > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha Final no puede ser mayor a la fecha del sistema");
					$('#fechaFinal').val(parametroBean.fechaSucursal);
				} else {
					mensajeSis("La Fecha Final no puede ser menor a la Fecha Inicial");
					$('#fechaFinal').val($('#fechaInicial').val());
				}

				$('#fechaFinal').focus();
				return false;
			}
		} else {

			mensajeSis("Formato de Fecha Final no válido <br> (aaaa-mm-dd)");
			$('#fechaFinal').val(parametroBean.fechaSucursal);
			$('#fechaFinal').focus();
			return false;
		}
	}

	function ocultaLista() {
		setTimeout("$('#cajaLista').hide();", 200);
	}
});