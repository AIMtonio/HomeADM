
$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();  
	//Definicion de Constantes y Enums  
	var catTipoTransaccionConocimientoCte = {
			'agrega':'1',
			'modifica':'2'	};

	var catTipoConsultaConocimientoCte = {
			'principal'	:	1,
			'foranea'	:	2
	};	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica'); 
 	deshabilitaBoton('generar', 'submit');



	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionConocimientoCte.modifica);
	});	



	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);

	});

	$('#clienteID').focus();

	$('#generar').click(function() {	
		
		  generaReporteRequisicion(); 
	});

	function generaReporteRequisicion(){
		var tipoReporte = 2;
		var tipoLista = 0;
		var cliente= $('#clienteID').val();
		var fechaSistema = parametroBean.fechaSucursal;
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var usuario=parametroBean.claveUsuario;
		
		/// VALORES TEXTO
	 	 
		$('#ligaGenerar').attr('href','repExigibleCart.htm?'
				+'clienteID='+cliente
				+'&nombreInstitucion='+nombreInstitucion
				+'&fechaSistema='+fechaSistema
				+'&usuario='+usuario.toUpperCase()
				+'&tipoReporte='+tipoReporte
				+'&tipoLista='+tipoLista);


	}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		

		if(numCliente != '' && !isNaN(numCliente) ){
			clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero)	;						
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#sucursal').val(cliente.sucursalOrigen);	 	
					validaSucursal() ;
					$('#promotorID').val(cliente.promotorActual);
					consultaPromotor('promotorID');
					EstatusCred('clienteID');
				}else{

					alert("No Existe el Cliente");
					deshabilitaBoton('generar', 'submit');
					$('#clienteID').val('')	;	
					$('#nombreCliente').val('');
					$('#nombreCliente').val('');
					$('#sucursal').val('');
					$('#promotorID').val('');
					$('#nombrePromotor').val('');
					$('#nombreSucursal').val('');				
				}    	 						
			});
		}
	}	


	function consultaPromotor(idControl) {
		var jqPromotor = eval("'#" + idControl + "'"); 
		var numPromotor = $(jqPromotor).val();	
		var tipConForanea = 2;	
		var promotor = {
				'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor == '' || numPromotor==0){
			$(jqPromotor).val(0);

		}
		else	

			if(numPromotor != '' && !isNaN(numPromotor) ){ 
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) { 
					if(promotor!=null){							
						$('#nombrePromotor').val(promotor.nombrePromotor); 

					}else{
						alert("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotor').val('');
					}    	 						
				});
			}
	}


	function validaSucursal() {
		var numSucursal = $('#sucursal').val();
		var consultaPrincipal=1;
		if(numSucursal != '' && !isNaN(numSucursal)){

			sucursalesServicio.consultaSucursal(consultaPrincipal,numSucursal,function(sucursal) { 
				if(sucursal!=null){

					$('#nombreSucursal').val(sucursal.nombreSucurs);

				}else{
					alert("No Existe la Sucursal");
					$('#sucursal').val(0);
					$('#nombreSucursal').val('');
				} 
			});
		}	
	}
	
	function EstatusCred (idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var EstatusBeanCon = {
  				'clienteID':numCliente
				};
		if(numCliente != '' && !isNaN(numCliente) ){
			clienteServicio.consultaEsta(13,EstatusBeanCon,function(cliente) {
				if (cliente.estatusCred>0){
					habilitaBoton('generar', 'submit');
				}else {
					deshabilitaBoton('generar', 'submit');
					alert("El Cliente no tiene Créditos con Estatus Vigente o Vencido");
				}
			});
		}
	}

});