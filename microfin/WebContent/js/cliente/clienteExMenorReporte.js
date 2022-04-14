
$(document).ready(function() {
var parametroBean = consultaParametrosSession();  
deshabilitaBoton('generar','submit');


	var Con_SocioExMenor={
		'principal' :1
	};
	/* == Métodos y manejo de eventos ====  */
	agregaFormatoControles('formaGenerica');

	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '2', '1','clienteID', $('#clienteID').val(), 'listaExMenores.htm');
	});

	$('#clienteID').blur(function() {
		validaCliente('clienteID');
	});
	
	$('#generar').click(function() { 
		generaReporte();
	});
	

	
	
	/* ====================== FUNCIONES ============================ */
	//funcion que genera el reporte 
	function generaReporte() {
			var cliente = $("#clienteID").val();	
			var sucursal = parametroBean.sucursal;
			var nombreInstitucion=parametroBean.nombreInstitucion;
			var tipoReporte=1;
			
			$('#ligaGenerar').attr('href','repExMenorCta.htm?clienteID='+ cliente +'&sucursalID='+sucursal+'&nombreInstitucion='
					+nombreInstitucion+'&tipoReporte='+tipoReporte);
	}
	
	//funcion para validar cliente
	function validaCliente (idControl){
		var jqcliente = eval("'#" + idControl + "'");
		var numCliente = $(jqcliente).val();
		
		setTimeout("$('#cajaLista').hide();", 200);
		var ExMenorBeanCon = {
				'clienteID' : numCliente
			};
		if (numCliente != '' && !isNaN(numCliente) && numCliente != 0) {
			clienteExMenorServicio.consulta(Con_SocioExMenor.principal, ExMenorBeanCon, function(cliente) {
				if (cliente != null) {
					if(cliente.estatusRetiro !=null && cliente.estatusRetiro!="N"){
						alert("La Cuota del Socio Indicado ha sido Retirada");
						$('#clienteID').focus();					
						$('#clienteIDDes').val('');
						$('#clienteID').val('');
						deshabilitaBoton('generar','submit');
					}else if (cliente.estatusRetiro ==null){
						alert("No Existe Información para el Socio Consultado  ");
						$('#clienteID').focus();					
						$('#clienteIDDes').val('');
						$('#clienteID').val('');
						deshabilitaBoton('generar','submit');
					}else if(cliente.estatusRetiro !=null && cliente.estatusRetiro =="N"){
						consultaCliente('clienteID');
					}
				} else {
					alert("No Existe Información para el Socio Consultado  ");
					$('#clienteID').focus();					
					$('#clienteIDDes').val('');
					$('#clienteID').val('');
					deshabilitaBoton('generar','submit');
					
				}
			});
		}
	}
	
	
	
	//funcion para consultar nombre del cliente
	function consultaCliente (idControl){
		var jqcliente = eval("'#" + idControl + "'");
		var numCliente = $(jqcliente).val();
		var conCliente = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		
		if (numCliente != '' && !isNaN(numCliente) && numCliente != 0) {
			clienteServicio.consulta(conCliente, numCliente, function(cliente) {
				if (cliente != null) {
					$('#clienteIDDes').val(cliente.nombreCompleto);
					$('#generar').focus();
					habilitaBoton('generar','submit');
		
				} else {
					alert("No Existe el Cliente");
					$('#clienteID').focus();					
					$('#clienteIDDes').val('');
					$('#clienteID').val('');
					deshabilitaBoton('generar','submit');
					
				}
			});
		}
	}
	// funcion para obtener la hora del sistema
	function hora(){
		 var Digital=new Date();
		 var hours=Digital.getHours();
		 var minutes=Digital.getMinutes();
		 var seconds=Digital.getSeconds();
		
		 if (minutes<=9)
			 minutes="0"+minutes;
		 if (seconds<=9)
			 seconds="0"+seconds;
		return  hours+":"+minutes+":"+seconds;
	 }
	    

	
	
	
});