$(document).ready(function() {
	esTab = true;


	var parametroBean = consultaParametrosSession();  

	var catTipoConsulta ={
			'principal':1
	};

	var catTipoReporte ={
			'PDF':1,
			'Excel':2
	};
	deshabilitaBoton('generar','submit');

	
	/* == Métodos y manejo de eventos ====  */
	$('#solicitudCreID').focus().select();

	agregaFormatoControles('formaGenerica');

    $('#solicitudCreID').blur(function() {
		consultaDatosSolicitud();
	});

	$('#solicitudCreID').bind('keyup',function(e){
		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#solicitudCreID').val();

			lista('solicitudCreID', '1', '1', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}				       
	});

	$('#pdf').attr("checked",true) ; 

	$(':text').focus(function() {	
		esTab = false;
	});
 	
	$('#generar').click(function() { 
		imprimir();
	});

	function imprimir(){
		var productoCreditoID=$('#productoCreditoID').asNumber();
		var nombreProducto=$('#descripProducto').val();
		var nombreSucursal=$('#nombreSucursal').val();
		var solicitudCreId=$('#solicitudCreID').val();
		var fechaSis = parametroBean.fechaSucursal;
		var nombreUsuario = parametroBean.claveUsuario; 
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var interesado = $('#interesado').val();
		var seguir=true;
		var tipoReporte = $('input:radio[name=tipoReporte]:checked').val();
		if(seguir){
			var pagina ='historicoSolCreReporte.htm?nombreSucursal='+nombreSucursal+
			'&fechaSistema='+fechaSis+
			'&usuario='+nombreUsuario+
			'&solicitudCreID='+solicitudCreId+
			'&nombreInstitucion='+nombreInstitucion+
			'&tipoReporte='+tipoReporte;
			window.open(pagina,'_blank');
		}
	}


	function consultaDatosSolicitud(){
	setTimeout("$('#cajaListaContenedor').hide();", 200);
	if(isNaN($('#solicitudCreID').val()) ){
		inicializaForma('contenedorForma', 'solicitudCreID');
		$('#solicitudCreID').focus().select();
	}else{
		if( $.trim($('#solicitudCreID').val())!= "" && $.trim($('#solicitudCreID').val())!= "0" ){
			var SolCredBeanCon = {
					'solicitudCreditoID':$('#solicitudCreID').val(),
					'usuario': parametroBean.numeroUsuario
			}; 
			solicitudCredServicio.consulta(1, SolCredBeanCon,function(solicitud) {
				if (solicitud != null && solicitud.solicitudCreditoID != 0) {				
					var ProdCredBeanCon = {
							'producCreditoID':solicitud.productoCreditoID 
					}; 
					$('#clienteID').val(solicitud.clienteID);
					$('#clienteDes').val(solicitud.nombreCompletoCliente);

					setTimeout("$('#cajaLista').hide();", 200);
					habilitaBoton('generar','submit');

					productosCreditoServicio.consulta(1,ProdCredBeanCon,function(prodCred) {
						if(prodCred!=null){
								$('#productoCreID').val(prodCred.producCreditoID);
								$('#productoCreDes').val(prodCred.descripcion);
						}else{							
							mensajeSis('No Existe el Producto de Crédito');
							limpiaFormaGenerica();

						}
					});
				}else{
					mensajeSis('No existe la Solicitud');
			      limpiaFormaGenerica();
				}
			});
			
		}else if ($.trim($('#solicitudCreID').val()) == "0"){
			limpiaFormaGenerica();
		}
	}
}

function limpiaFormaGenerica(){
	$('#clienteID').val('');
	$('#clienteDes').val('');
	$('#productoCreID').val('');
	$('#productoCreDes').val('');
	deshabilitaBoton('generar', 'submit');
	$('#solicitudCreID').focus().select();
}



});

