$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	$('#periodo').focus();
	$('#clienteID').val('0');
	$('#nombreCliente').val('TODOS');
	$('#productoCreditoID').val('0'); 
    $('#nombreProducto').val('TODOS');
    $('#excel').attr("checked",true) ;
    
	$(':text').focus(function() {	
		esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	/***********************************/
    $('#clienteID').bind('keyup',function(e){
    	setTimeout("$('#cajaLista').hide();", 200);	
			lista('clienteID', '2', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#productoCreditoID').bind('keyup',function(e){ 
		setTimeout("$('#cajaLista').hide();", 200);	
				lista('productoCreditoID', '2', '1', 'descripcion', $('#productoCreditoID').val(), 'listaProductosCredito.htm');			       
	});
	
	$('#periodo').bind('keyup',function(e){ 
		setTimeout("$('#cajaLista').hide();", 200);	
		if(this.value.length >= 2){
			lista('periodo', '2', '3', 'anio', $('#periodo').val(), 'listaEdoCtaPeriodo.htm');
		}				       
  });

	 

	$('#clienteID').blur(function() {
		if($('#clienteID').val()=='' || $('#clienteID').val()== null){
			$('#nombreCliente').val('TODOS');
		}else{
		consultaCliente(this.id);}
	});

	$('#periodo').blur(function() {
		if($('#periodo').val()=='' || $('#periodo').val()== null){
			$('#clienteID').val(0);
			$('#nombreCliente').val('TODOS');
			$('#productoCreditoID').val(0);
			$('#nombreProducto').val('TODOS');
		}
	});

	$('#productoCreditoID').blur(function() {
		if($('#productoCreditoID').val()=='' || $('#productoCreditoID').val()== null){
			$('#nombreProducto').val('TODOS');
		}else{consultaProductosCredito(this.id);};
	});
	
	$('#generar').click(function() {
		generaExcel();
	}); 
	
	/* Funcion para generar el reporte en Excel */
	function generaExcel(){	
		if($('#excel').is(':checked')){	
		var nombreUsuario=parametroBean.claveUsuario;
		var nombreInstitucion=parametroBean.nombreInstitucion;
		var fechaEmision=parametroBean.fechaSucursal;
		var tipoReporte = 1;
		var periodo = $('#periodo').val();
	    var productoCreditoID = $('#productoCreditoID').val();
	    var clienteID = $('#clienteID').val();

		
		var pagina ='repSATExcel.htm?periodo='+periodo+
		'&productoCreditoID='+productoCreditoID
		+ '&clienteID='+clienteID
		+ '&nombreInstitucion='+nombreInstitucion+'&usuario='+nombreUsuario.toUpperCase()		
		+ '&tipoReporte='+tipoReporte+'&fechaEmision='+fechaEmision;
	window.open(pagina);
		}

	}
	

});

function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente = 6;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numCliente == '' || numCliente==0){
			$(jqCliente).val(0);
			$('#nombreCliente').val('TODOS');
		}
		else
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
				if(cliente!=null){	
					if(cliente.esMenorEdad != "S"){
							$('#clienteID').val(cliente.numero);	
							$('#nombreCliente').val(cliente.nombreCompleto);	
					}else{
						mensqjeSis("El Cliente es Menor de Edad.");
						$('#clienteID').focus();
						$('#clienteID').select();
						$("#nombreCliente").val('');
					}  
				}else{
					mensajeSis("No Existe el Cliente");
					$('#clienteID').focus();
					$(jqCliente).val(0);
					$('#nombreCliente').val('TODOS');
				}    						
			});
		}
	} 

function consultaProductosCredito(idControl) {
		var jqProducto  = eval("'#" + idControl + "'");
		var numProducto = $(jqProducto).val();	
		var conForanea =2;
		var ProductoCreditoCon = { 
				'producCreditoID':numProducto
		};
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numProducto == '' || numProducto==0){
			$(jqProducto).val(0);
			$('#nombreProducto').val('TODOS');
		}
		else
		if(numProducto != '' && !isNaN(numProducto)){
			productosCreditoServicio.consulta(conForanea,ProductoCreditoCon,function(productos){
				if(productos!=null){
					agregaFormatoControles('formaGenerica');
					$('#nombreProducto').val(productos.descripcion);
				}else{
					mensajeSis("No Existe el Producto de crédito");
					$('#productoCreditoID').focus();
					$(jqProducto).val(0);
					$('#nombreProducto').val('TODOS');
				}    						
			});
		}
	}


function limpiaFormulario(){
	$('#clienteID').val('');
	$('#nombreCliente').val('');
	$('#creditoID').val('');
	$('#productoCreditoID').val('');
	$('#nombreProducto').val('');
	$('#sucursalID').val('');
	$('#nombreSucursal').val('');
	$('#estatus').val("0").selected = true;
}