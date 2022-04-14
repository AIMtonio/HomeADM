$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	
	$('#periodo').focus();
	$('#clienteID').val('0');
	$('#nombreCliente').val('TODOS');
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


	$('#periodo').bind('keyup',function(e){ 
		setTimeout("$('#cajaLista').hide();", 200);	

			lista('periodo', '2', '3', 'anio', $('#periodo').val(), 'listaEdoCtaPeriodo.htm');			       
  });

	 

	$('#clienteID').blur(function() {
		if($('#clienteID').val()=='' || $('#clienteID').val()== null){
			$('#nombreCliente').val('TODOS');
		}else{consultaCliente(this.id);}
		
	});
	
	$('#periodo').blur(function() {
		if($('#periodo').val()=='' || $('#periodo').val()== null){
				$('#clienteID').val(0);
				$('#nombreCliente').val('TODOS');
				$('#estatus').val('TODOS');
			}
		
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
	    var clienteID = $('#clienteID').val();
	    var estatus = $('#estatus').val();

		
		var pagina ='repEstadoCExcel.htm?periodo='+periodo
		+ '&clienteID='+clienteID
		+'&estatus='+estatus
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