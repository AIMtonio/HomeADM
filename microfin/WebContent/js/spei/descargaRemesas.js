$(document).ready(
	function() {
		esTab = true;
		var tab2 = false;

		var parametrosBean = consultaParametrosSession();
		$('#fecha').val(parametroBean.fechaSucursal);
		agregaFormatoControles('formaGenerica');

		//Definicion de Constantes y Enums
		var catTipoTransaccion = {
			'grabar' : '1',
		};

		//------------ Metodos y Manejo de Eventos -----------------------------------------
		deshabilitaBoton('grabar');
		$('#speiSolDesID').focus();

		$(':text').focus(function() {
			esTab = false;
		});

		$(':text').bind('keydown', function(e) {
			if (e.which == 9 && !e.shiftKey) {
				esTab = true;
			}
		});

		$.validator.setDefaults({
			submitHandler : function(event) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica',
						'contenedorForma', 'mensaje', 'false',
						'speiSolDesID', 'funcionExitoSol',
						'funcionErrorSol');
			}
		});

		$('#grabar').click(function() {
			$('#tipoTransaccion').val(catTipoTransaccion.grabar);
		});

		$('#speiSolDesID').bind('keyup',function(e) {
			lista('speiSolDesID', '2', '1', 'speiSolDes', $('speiSolDesID').val(),'listaDescargaRemesa.htm');
				});

		$('#speiSolDesID').blur(function() {
			if(isNaN($('#speiSolDesID').val()) ){
				$('#speiSolDesID').focus();
				limpiaCampos();
				}else{
					consultaDescarga();
			}
		});

		$('#actualizar').click(function() {
			consultaSolDescargas();

		});


		consultaSolDescargas();

		//------------ Validaciones de la Forma -------------------------------------

		$('#formaGenerica').validate({

			rules: {
				speiSolDesID:{required: true
				},
				nombreUsuario:{required: true
				},
				fechaRegistro:{required: true
				},
				estatus:{required: true
				},

			},
			messages: {
				speiSolDesID:{
					required:'Especificar Solicitud de Descarga'
				},
				nombreUsuario:{
					required:'Especificar Nombre de Usuario'
				},
				fechaRegistro:{
					required:'Especificar Fecha de Registro'
				},
				estatus:{
					required:'Especificar Estatus'
				},

			}
		});

		//------------ Validaciones de Controles -------------------------------------

	});

// funcion para consultar solicitud de descargas
function consultaSolDescargas() {
bloquearPantalla();
var params = {};
params['tipoLista'] = 2;
$.post("gridSolDescargas.htm", params, function(data) {

	if (data.length > 0) {
		agregaFormatoControles('gridSolDescargas');
		$('#gridSolDescargas').html(data);
		$('#gridSolDescargas').show();
		habilitaBoton('actualizar');

			if($('#speiSolDesID1').val() == undefined ){
				mensajeSis("No se tienen Solicitudes de Descargas");
				deshabilitaBoton('actualizar');

			}
			desbloquearPantalla();
	} else {
		$('#gridSolDescargas').html("");
		$('#gridSolDescargas').hide();
		mensajeSis("No se tienen Solicitudes de Desacrgas");
		deshabilitaBoton('actualizar');
		desbloquearPantalla();
	}
});

}

function consultaDescarga() {
var numSol = $('#speiSolDesID').val();

var tipConPantalla = 1;
var SolBeanCon = {
	'speiSolDesID' : numSol
};
setTimeout("$('#cajaLista').hide();", 200);
if (numSol != '' && !isNaN(numSol)) {
	if (numSol == '0') {
		$('#usuario').val(parametroBean.numeroUsuario);
		$('#nombreUsuario').val(parametroBean.nombreUsuario);
		$('#fechaRegistro').val(parametroBean.fechaSucursal);
		$('#fechaProceso').val(parametroBean.fechaSucursal);
		$('#estatus').val('P');
		$('#muestraEstatus').val('PENDIENTE');

		habilitaBoton('grabar', 'submit');
	} else {
		deshabilitaBoton('grabar', 'submit');
		descargaRemesasServicio.consulta(tipConPantalla, SolBeanCon,{ async: false, callback:
				function(solicitud) {
					if (solicitud != null) {
						$('#usuario').val(solicitud.usuario);
						$('#fechaRegistro').val(solicitud.fechaRegistro);

						if (solicitud.fechaProceso == '1900-01-01') {
							$('#fechaProceso').val('');
						} else {
							$('#fechaProceso').val(solicitud.fechaProceso);
						}

						$('#estatus').val(solicitud.estatus);
						consultaUsuario();
						if (solicitud.estatus == 'P') {
							$('#muestraEstatus').val('PENDIENTE');
						}
						if (solicitud.estatus == 'R') {
							$('#muestraEstatus').val('PROCESADA');
						}

					} else {
						mensajeSis("No Existe la Solicitud de Descarga");
						$('#speiSolDesID').focus();
						limpiaCampos();

					}
}
				});
		}

}
}

function consultaUsuario() {
setTimeout("$('#cajaLista').hide();", 200);
var numUsuario = $('#usuario').val();

if (numUsuario != '' && !isNaN(numUsuario)) {
	var usuarioBeanCon = {
		'usuarioID' : numUsuario
	};
	usuarioServicio.consulta(1, usuarioBeanCon, function(usuario) {
		if (usuario != null) {
			$('#nombreUsuario').val(usuario.nombreCompleto);

		} else {

		}
	});

}
}

function limpiaCampos(){

$('#speiSolDesID').val('');
$('#nombreUsuario').val('');
$('#usuario').val('');
$('#fechaRegistro').val('');
$('#fechaProceso').val('');
$('#muestraEstatus').val('');
$('#estatus').val('');
}

function funcionExitoSol() {
deshabilitaBoton('grabar');
}

function funcionErrorSol() {
deshabilitaBoton('grabar');
}
