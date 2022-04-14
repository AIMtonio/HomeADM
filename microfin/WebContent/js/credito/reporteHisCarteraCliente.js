var Var_TipoDocumento=55;
$(document).ready(function() {
	
	/*   ============ METODOS  Y MANEJO DE EVENTOS =============   */
	
	/* consulta parametros de usuario y sesion */
	var parametrosBean = consultaParametrosSession();
	var descripcionCliente = $('#tipoCliente').val();
	   

	/*esta funcion esta en forma.js */
	deshabilitaBoton('generar');

	/* lista de ayudas para clientes */
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '2', '12', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	}); 
	$('#clienteID').blur(function() {		
  		consultaCliente(this.id);
	});
	
	$('#generar').click(function() { 
		generaReporte();
	});
	


	/* =============== VALIDACIONES DE LA FORMA ================= */
		$('#formaGenerica').validate({			
			rules: {
				clienteID :{
					required:true
				}
			},		
			messages: {
				clienteID :{
					required:'Especificar '+ descripcionCliente
				},			
			}		
		});

		
		
/* =================== FUNCIONES ========================= */
	

		/* Consulta el cliente */
		function consultaCliente(idControl) {
			var tipoCon = 1;
			var estatusInactivo = 'I';
			var jqCliente = eval("'#" + idControl + "'");
			var numCliente = $(jqCliente).val();
			var tamanio = $(jqCliente).val().length;
			setTimeout("$('#cajaLista').hide();", 200);
			
			
			// si no esta vacio y es un numero ejecutara la consulta del cliente
			if (numCliente != '' && numCliente != '0' && !isNaN(numCliente) && parseInt(tamanio) < 11) {	
				clienteServicio.consulta(tipoCon, numCliente, function(cliente) {
					if (cliente != null) {
						$('#estatus').val('0');
						$('#clienteID').val(cliente.numero);
						$('#clienteIDDes').val(cliente.nombreCompleto);						
						
							if(cliente.estatus == estatusInactivo){
								mensajeSis("El " + descripcionCliente + " se encuentra Inactivo.");
								 $(jqCliente).focus();
								 $(jqCliente).select();
								deshabilitaBoton('generar');
							}
							else{
								if(cliente.edad < 18){
									mensajeSis("El " + descripcionCliente + " es Menor de Edad.");
									$(jqCliente).focus();
									$(jqCliente).select();
									deshabilitaBoton('generar');
								}else{
									habilitaBoton('generar');
								}
							}
					}else{
						mensajeSis("El " + descripcionCliente + " No Existe.");
						$('#clienteID').val('');
						$('#clienteIDDes').val('');	
						$('#estatus').val('0');
						 $(jqCliente).focus();
						 deshabilitaBoton('generar');
					}
				});
			}
			else{
				$('#clienteID').val('');
				$('#clienteIDDes').val('');	
				$('#estatus').val('0');
				 $(jqCliente).focus();
				 deshabilitaBoton('generar');
			}
		}
		

		function generaReporte() {					
				var clienteID = $('#clienteID').val();	
				var clienteIDDes = $('#clienteIDDes').val();	
				var ClienteConCaracter = clienteIDDes;
				clienteIDDes = ClienteConCaracter.replace(/\&/g, "%26");
				var estatus = $('#estatus').val();	
				var estatusDes = $('#estatus option:selected').html();	
				var tipoReporte = 1;
				var fechaSis = parametroBean.fechaSucursal;
				var nombreUsuario = parametroBean.claveUsuario; 
				var nombreInstitucion = parametroBean.nombreInstitucion;
				var nombreSucursal = parametroBean.nombreSucursal;	

				$('#ligaGenerar').attr('href','historicoCarteraCliente.htm?clienteID='+clienteID +'&tipoReporte='+tipoReporte +'&estatus='+
						estatus+'&fechaSistema='+fechaSis+'&nombreUsuario='+nombreUsuario+ '&nombreCliente='+clienteIDDes+					
						'&nombreInstitucion='+nombreInstitucion+'&nombreSucurs='+nombreSucursal+'&descripcion='+estatusDes);			
		}
		
}); // fin de jquery
	
		
