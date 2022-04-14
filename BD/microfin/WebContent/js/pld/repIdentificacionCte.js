$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();   


	var catTipoRepIdentificacion = { 
		
			'PDF'		: 1,
	};	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('generar', 'submit');

	$(':text').focus(function() {	
		esTab = false;
	});

	$('#pdf').attr("checked",true) ; 
	
	$('#generar').click(function() {	
		generaPDF(); 
	});
	$('#clienteID').blur(function() {
		consultaCliente(this.id);
	});
	$('#clienteID').bind('keyup',function(e) { 
			lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
		});

	// ***********  Validacion de la forma ***********
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
  	$.validator.setDefaults({
        submitHandler: function(event) { 
               grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','generar');
        }
  	});

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
					$('#promotorID').val(cliente.promotorActual);
					consultaPromotor('promotorID');
					habilitaBoton('generar', 'submit');
				}else{

					alert("No Existe el "+ $('#alertSocio').val()+".");
					deshabilitaBoton('generar', 'submit');
					$('#clienteID').val('')	;	
					$('#nombreCliente').val('');
					$('#nombreCliente').val('');
					$('#promotorID').val('');
					$('#nombrePromotor').val('');			
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
						alert("No Existe el Promotor.");
						$(jqPromotor).val(0);
						$('#nombrePromotor').val('');
					}    	 						
				});
			}
	}

	function generaPDF() {	
		if($('#pdf').is(':checked')){	
			var tr= catTipoRepIdentificacion.PDF;
			
			var clienteID =$('#clienteID').val();
			var promotorID = $('#promotorID').val();
		
			/// VALORES TEXTO
			var nombreCliente = $('#nombreCliente').val();
			var nombrePromotor = $('#nombrePromotor').val();
			var nombreUsuario = parametroBean.nombreUsuario;
			var nombreSucursal = parametroBean.nombreSucursal;
			var direccionSucursal = parametroBean.edoMunSucursal;
			var fechaEmision = parametroBean.fechaSucursal;

			$('#ligaGenerar').attr('href','repIdentificacionCtePDF.htm?tipoReporte='+tr
					+'&clienteID='+clienteID+'&promotorID='+promotorID+'&nombreCliente='+nombreCliente+'&nombrePromotor='
					+nombrePromotor+'&nombreUsuario='+nombreUsuario+'&nombreSucursal='+nombreSucursal+'&direccionSucursal='+
					direccionSucursal+'&fechaSistema='+fechaEmision);
		}
	}
});