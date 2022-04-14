$(document).ready(function (){
	deshabilitaBoton('grabar', 'submit');

	var catTipoTransaccionUsuario = {
  		'agrega':'1',
  		'modifica':'2',
	};

	var parametrosSesion =	consultaParametrosSession();
	var usuarioLogueado	=	parseInt(parametrosSesion.numeroUsuario);
	var nombreUsrLogueado = parametrosSesion.nombreUsuario;
	var sucursalLogueada =	parseInt(parametrosSesion.sucursal);
	var nombreSucLogueada = parametrosSesion.nombreSucursal;

	var fechaSolicitud = parametrosSesion.fechaAplicacion;
	var conSolicitud = 1;
	var solSaldoSucursalBeanCon = {
			'usuarioID' : usuarioLogueado,
			'sucursalID': sucursalLogueada,
		};
	var existeSol;

	cargarDatosPantalla();

	$('#montoSolicitado').blur(
		function(){
			var monto = $('#montoSolicitado').val().replace(/,/g, '');
			if(monto > 0 && !isNaN(monto) ) {
				habilitaBoton('grabar', 'submit');
			} else{
				deshabilitaBoton('grabar', 'submit');
			}
	});

    $('#comentarios').keyup(function() {
        $('#lblCaracteres').html('Caracteres ' + $('#comentarios').val().length + "/300");
    });

	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','montoSolicitado','funcionExitoSolSaldo','funcionFalloSolSaldo');

		}
    });	


    $('#grabar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionUsuario.agrega);
	});
	
	
	//---------------------- Validaciones de la Forma -------------------------
	$('#formaGenerica').validate({
		rules: {
			montoSolicitado: {
				required: true,			
				number: true
			},
			comentarios: {
				maxlength: 300,
			}
		},		
		messages: {
			montoSolicitado: {
				required: 'Especifique Monto',
				number: 'Cantidad Incorrecta'
			},
			comentarios: {
				maxlength: 'Máximo 300 Caracteres'
			}
		}		
	});

	//----------------------------- Funciones ----------------------------------
	
	function cargarDatosPantalla(){
		$('#usuarioID').val(usuarioLogueado);
		$('#nomUsuario').val(nombreUsrLogueado);
		$('#sucursalID').val(sucursalLogueada);
		$('#nomSucursal').val(nombreSucLogueada);


		if ($('#usuarioID').val() != 0 || $('#usuarioID').val() != '' ) {		
			solSaldoSucursalServicio.consulta(solSaldoSucursalBeanCon , conSolicitud, function(solSaldoSucursal){
				if(solSaldoSucursal != null){
					existeSol = solSaldoSucursal.montoSolicitado;
					$('#canCreDesem').val(solSaldoSucursal.canCreDesem);
					$('#monCreDesem').val(solSaldoSucursal.monCreDesem);

					$('#canInverVenci').val(solSaldoSucursal.canInverVenci);
					$('#monInverVenci').val(solSaldoSucursal.monInverVenci);
					
					$('#canChequeEmi').val(solSaldoSucursal.canChequeEmi);
					$('#monChequeEmi').val(solSaldoSucursal.monChequeEmi);

					$('#canChequeIntReA').val(solSaldoSucursal.canChequeIntReA);
					$('#monChequeIntReA').val(solSaldoSucursal.monChequeIntReA);

					$('#canChequeIntRe').val(solSaldoSucursal.canChequeIntRe);
					$('#monChequeIntRe').val(solSaldoSucursal.monChequeIntRe);

					$('#saldosCP').val(solSaldoSucursal.saldosCP);
					$('#saldosCA').val(solSaldoSucursal.saldosCA);
					
					$('#montoSolicitado').val(solSaldoSucursal.montoSolicitado);
					$('#comentarios').val(solSaldoSucursal.comentarios);
	
					if (existeSol != '') {
						deshabilitaControl('montoSolicitado');
						deshabilitaControl('comentarios');
						deshabilitaBoton('grabar', 'submit');
					}else{
						$('#montoSolicitado').focus();
						$('#montoSolicitado').select();
					}
					agregaFormatoControles('formaGenerica');
				}
			});
		}
	}

});

function funcionExitoSolSaldo(){
	deshabilitaControl('montoSolicitado');
	deshabilitaControl('comentarios');
	
	deshabilitaBoton('grabar', 'submit');
}

function funcionFalloSolSaldo(){
	
}