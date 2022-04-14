$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	
	var catTipoListaTipoInversion = {
			'principal':1
		};
	var catTipoConsultaTipoInversion = {
			'principal':1,
			'general':3
		};
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
  
//	$('#pdf').attr("checked",true);
//	$('#pantalla').attr("checked",false);
	$('#reporte').val(1);
	$('#clienteID').val(0);
	$('#nombreCliente').val('TODOS');
	$(':text').focus(function() {	
	 	esTab = false;
	});


	var parametroBean = consultaParametrosSession();
	$('#fecha').val(parametroBean.fechaSucursal);
	
	//------------ Validaciones de la Forma -------------------------------------
 
	function validaCliente() {
		var numCliente = $('#clienteID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		esTab=true;
		if(numCliente == ''|| numCliente == 0){
			$('#clienteID').val(0);
			$('#nombreCliente').val('TODOS');
		}else
		if (numCliente != '' && !isNaN(numCliente)) {
				clienteServicio.consulta(2,numCliente,function(cliente) {
					if (cliente != null) {
						$('#nombreCliente').val(cliente.nombreCompleto);
					} else {
						alert("No Existe el Cliente");
						$('#clienteID').val(0);
						$('#nombreCliente').val('TODOS');
					}
				});
		}
	}
	 
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
		$('#requerimientoID').change(function() { 
			var reqto = $('#requerimientoID').val();
			if(reqto == 1){
				$('#reporte').val(1);
			}else if(reqto == 2){
				$('#reporte').val(3);
			}else if(reqto == 3){
				$('#reporte').val(5);
			}
		});
		
		$('#clienteID').bind('keyup',function(e) { 
			lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
		});
	
		$('#clienteID').blur(function() {
			esTab=true;
			validaCliente();
		});

		$('#imprimir').click(function() {	
			var clienteID = $('#clienteID').val();
			var tipoReporte = $('#reporte').val();
			var requerimientoID = $('#requerimientoID').val();
			
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var nombreUsuario = parametroBean.nombreUsuario;
			var direccion = parametroBean.direccionInstitucion;
			var rfcinstit    = parametroBean.rfcInst;
			var telInst  =  parametroBean.telefonoLocal;
			var gerente  =  parametroBean.gerenteSucursal;
			var nomCortoInst = parametroBean.nombreCortoInst;
			var fecha = parametroBean.fechaAplicacion;
			
			$('#ligaImp').attr('href','ReqtosCobranzaReporte.htm?requerimientoID='+requerimientoID+'&clienteID='+clienteID+
					'&tipoReporte='+tipoReporte+'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaActual='+fecha+
					'&direccionInstit='+direccion+'&RFCInstit='+rfcinstit+'&telefonoInst='+telInst+'&gerenteSucursal='+gerente+'&nombreCortoInst='+nomCortoInst); 
		});
	
});
