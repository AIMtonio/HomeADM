$(document).ready(function() {
	
	var ticektRemesa = new Object();
	
	$('#clienteID').val('');
	$('#usuarioID').val('');
	
	$('#referencia').focus();
	agregaFormatoControles('formaGenerica');

	$('#referencia').bind('keyup', function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = 'referencia';
		parametrosLista[0] = $('#referencia').val();
		lista('referencia', 2,1, camposLista, parametrosLista, 'remesasPagadasLista.htm' );
	});

	$('#referencia').blur(function(){
		buscaDatosPagoRemesa();
	});

	$('#reimprimir').click(function(){
		reimprimirPagoRemesa(ticektRemesa);
	});

	$.validator.setDefaults({
		submitHandler: function(event){
			deshabilitaBoton('reimprimir', 'submit');
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', false, 'referencia');
		}
	});

	$("#formaGenerica").validate({
		rules:{
			referencia:{
				required:true
			}
		}, messages: {
			referencia:{
				required: "Especifique la referencia"
			}
		}

	});

	function buscaDatosPagoRemesa(){
		var referencia = $('#referencia').val();
		remesasPagadasServicio.consulta(1, referencia, function(remesa){

			ticektRemesa = new Object();
			if (remesa == null){
				//limpiaFormulario();
				//mensajeSis("El Pago de la Remesa con Referencia [" + referencia + "] No Ha Sido Realizado.");
			} else {
				limpiaFormulario();
				remesasPagadasServicio.consulta(2, referencia, function(datosDinero){
					desplegaDatosRemesa(remesa[0], datosDinero);
				} );
			}
		});
	}

	function desplegaDatosRemesa(remesa, datosDinero){
		ticektRemesa.referencia = remesa.referencia;
		ticektRemesa.remesadora = remesa.remesadora;
		ticektRemesa.monto = remesa.monto;
		ticektRemesa.moneda = remesa.moneda;
		ticektRemesa.beneficiario = remesa.cliente;
		ticektRemesa.folio = remesa.numeroTrasnaccion;
		ticektRemesa.monedas = '';

		switch (remesa.formaPago) {
		case 'R':
			ticektRemesa.formaPago = 'RETIRO EN EFECTIVO'
			break;
		case 'D':
			ticektRemesa.formaPago = 'DEPOSITO CUENTA'
			break;
		case 'C':
			ticektRemesa.formaPago = 'CHEQUE'
			break;
		default:
			ticektRemesa.formaPago = ''
		}

		var denominacionesTicket = new Array();

		$('#nombreCliente').val(remesa.cliente);
		$('#clienteID').val(remesa.clienteID);
		$('#direccion').val(remesa.direccion);
		$('#numeroTelefono').val(remesa.numeroTelefono);
		$('#monto').val(remesa.monto);
		$('#referencia').val(remesa.referencia);
		$('#remesadora').val(remesa.remesadora);
		$('#usuario').val(remesa.usuario);
		$('#usuarioID').val(remesa.usuarioID);
		$('input:radio[name="formaPago"]').filter('[value="'+ remesa.formaPago +'"]').attr('checked', true);
		$('#totalSalidaEfectivo').val(remesa.monto);
		$('#numeroReimpresinoes').val(remesa.numeroReimpresiones);
		datosDinero.forEach(function(d, index){
			//console.log('valor: ' + d.valor + ', cantidad: ' + d.cantidad);
			$('#cantidad' + d.valor).val(d.cantidad);
			$('#monto' + d.valor).val(d.monto);
			var i = 0;
			if (d.valor == 1){
				ticektRemesa.monedas = '\t\t\t\t' + d.cantidad + ' = ' + d.monto;
			} else {
				denominacionesTicket.push(d.valor + '\t\t\tX\t' + d.cantidad + ' = ' + d.monto);
			}
			i++;
		});

		ticektRemesa.billetes = denominacionesTicket;
		habilitaBoton('reimprimir', 'submit');
		agregaFormatoControles('formaGenerica');
	}
	
	function limpiaFormulario(){
		$('#cliente').val('');
		$('#clienteID').val('');
		$('#direccion').val('');
		$('#numeroTelefono').val('');
		$('#monto').val('');
		$('#referencia').val('');
		$('#remesadora').val('');
		$('#usuario').val('');
		$('#usuarioID').val('');
		$('input:radio[name="formaPago"]').attr('checked', false);
		$('.cantidad').val('0');
		$('.monto').val('0.00');
		$('#totalSalidaEfectivo').val('0');
		$('#numeroReimpresinoes').val('0');
	}

	
});
