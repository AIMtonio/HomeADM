$(document).ready(function() {
	var parametroBean = consultaParametrosSession(); 
	$('#tipoTarjetaDeb').focus();
	$('#tipoTarjetaDeb').attr("checked",false);
	$('#tipoTarjetaCred').attr("checked",false); 
    $('#lineaCredito').hide();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	var catTarjetasExist = {
			'tarjetasExist' :20,
			'tarjetasCredExist' :6	
	};
	
	var catTipoRepBitTarDeb = { 
			'PDF'		: 1,	
	};

	deshabilitaBoton('consultar','submit');
	
	
	$.validator.setDefaults({			
	      submitHandler: function(event) { 	    	  
	    		   	  
	    		  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tarjetaDebID', 
	    				  'funcionExitoBitEstaTar','funcionErrorBitEstaTar');
	      }
	      
	   });	
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){ 
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#pdf').attr("checked",true) ; 
	

	$('#tarjetaDebID').blur(function() {
		if ($("#tipoTarjetaDeb").is(':checked')){
			consultaTarjeta();
		}
		else if ($("#tipoTarjetaCred").is(':checked')) {
			consultaTarjetaCred();
		}
	});
	$('#coorporativo').blur(function() {
		consultaTarCoorpo(this.id);

	});
	
	$('#consultar').click(function() {
		
		if($("#tipoTarjetaDeb").is(':checked')) {  
	          consultaBitacoraEstatus();	
	        } 
        else if($("#tipoTarjetaCred").is(':checked')){
        	consultaBitStatusTarCred();
        }
        else{  
           mensajeSis("Selecciona el tipo de tarjeta");
        } 

	});	

	$('#tarjetaDebID').bind('keyup',function(e){ 
		if($("#tipoTarjetaDeb").is(':checked')) {  
	           lista('tarjetaDebID', '1', '15','tarjetaDebID', $('#tarjetaDebID').val(),'tarjetasDevitoLista.htm');	
	        } 
        else if($("#tipoTarjetaCred").is(':checked')){
        	lista('tarjetaDebID', '1', '12','tarjetaDebID', $('#tarjetaDebID').val(),'tarjetasCreditoLista.htm');
        }
        else{  
           mensajeSis("Selecciona el tipo de tarjeta");
        } 
		 
	});

		


	//------------ Validaciones de Controles -------------------------------------
	//Consulta de Tarjetas
	function consultaTarjeta() {
		var tarjetaDebID =$('#tarjetaDebID').val();
		var TarjetaDebitoCon = {
			'tarjetaDebID': $('#tarjetaDebID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (Number(tarjetaDebID) != ''  && !isNaN(tarjetaDebID)) {
			tarjetaDebitoServicio.consulta(catTarjetasExist.tarjetasExist, TarjetaDebitoCon,function(tarjetasExist){
			if(tarjetasExist !=null   ){
				habilitaBoton('consultar','submit');
				$('#tarjetaDebID').val(tarjetasExist.tarjetaDebID);
				$('#estatus').val(tarjetasExist.descripcion);
				$('#clienteID').val(tarjetasExist.clienteID);
				$('#nombreCompleto').val(tarjetasExist.nombreCompleto);
				$('#coorporativo').val(tarjetasExist.coorporativo);
				$('#cuentaAho').val(tarjetasExist.cuentaAhoID);
				$('#nombreTipoCuenta').val(tarjetasExist.tipoCuentaID);
				$('#tipotarjetaID').val(tarjetasExist.tipoTarjetaDebID);
				$('#nombreTarjeta').val(tarjetasExist.nombreTarjeta);
				if (tarjetasExist.coorporativo == '' || tarjetasExist.coorporativo == 0 || tarjetasExist.coorporativo == null ) {
					$('#cteCorpTr').hide();
				}else {
					$('#cteCorpTr').show();
					consultaTarCoorpo('coorporativo');
				}
				
				$('#gridBitEstatusTarDeb').hide();
				$('#consultar').focus();
				$('#generar').hide();
			
			}else  {
				mensajeSis("El Número de Tarjeta no Existe");
				$('#tarjetaDebID').focus();
				$('#tarjetaDebID').val('');
				$('#estatus').val('');
				$('#clienteID').val('');
				$('#nombreCompleto').val('');
				$('#coorporativo').val('');
				$('#cuentaAho').val('');
				$('#nombreTipoCuenta').val('');
				$('#nombreTarjeta').val('');
				$('#tipotarjetaID').val('');
                $('#nombreCoorp').val('');
                deshabilitaBoton('consultar','submit');
				$('#gridBitEstatusTarDeb').hide();
				$('#generar').hide();
				$('#tarjetaDebID').val('');
			}});
		}else if(isNaN(tarjetaDebID)){
			$('#tarjetaDebID').val('');
			$('#estatus').val('');
			$('#clienteID').val('');
			$('#nombreCompleto').val('');
			$('#coorporativo').val('');
			$('#cuentaAho').val('');
			$('#nombreTipoCuenta').val('');
			$('#nombreTarjeta').val('');
			$('#tipotarjetaID').val('');
            $('#nombreTarjeta').val('');
            $('#nombreCoorp').val('');
			$('#tarjetaDebID').focus();
		    deshabilitaBoton('consultar','submit');

		}
		else if(Number(tarjetaDebID)== ''){
			$('#tarjetaDebID').val('');
			$('#estatus').val('');
			$('#clienteID').val('');
			$('#nombreCompleto').val('');
			$('#coorporativo').val('');
			$('#cuentaAho').val('');
			$('#nombreTipoCuenta').val('');
			$('#nombreTarjeta').val('');
			$('#tipotarjetaID').val('');
            $('#nombreTarjeta').val('');
            $('#nombreCoorp').val('');
            deshabilitaBoton('consultar','submit');
			$('#gridBitEstatusTarDeb').hide();
			$('#generar').hide();
		}
	
	}	





	//Consulta de Tarjetas
	function consultaTarjetaCred() {
		var tarjetaDebID =$('#tarjetaDebID').val();
		var TarjetaCreditoCon = {
			'tarjetaDebID': $('#tarjetaDebID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (Number(tarjetaDebID) != ''  && !isNaN(tarjetaDebID)) {
			tarjetaCreditoServicio.consulta(catTarjetasExist.tarjetasCredExist, TarjetaCreditoCon,function(tarjetasCredExist){
			if(tarjetasCredExist !=null   ){
				habilitaBoton('consultar','submit');
				$('#tarjetaDebID').val(tarjetasCredExist.tarjetaID);
				$('#estatus').val(tarjetasCredExist.descripcion);
				$('#clienteID').val(tarjetasCredExist.clienteID);
				$('#nombreCompleto').val(tarjetasCredExist.nombreCompleto);
				$('#coorporativo').val(tarjetasCredExist.coorporativo);
				$('#productoID').val(tarjetasCredExist.productoID);
				$('#descripcionProd').val(tarjetasCredExist.descripcionProd);
				$('#tipotarjetaID').val(tarjetasCredExist.tipoTarjetaID);
				$('#nombreTarjeta').val(tarjetasCredExist.nombreTarjeta);
			
				if (tarjetasCredExist.coorporativo == '' || tarjetasCredExist.coorporativo == 0 || tarjetasCredExist.coorporativo == null ) {
					$('#cteCorpTr').hide();
				}else {
					$('#cteCorpTr').show();
					consultaTarCoorpo('coorporativo');

				}
				
				$('#gridBitEstatusTarDeb').hide();
				$('#consultar').focus();
				$('#generar').hide();
				
			
			}else  {
				
				mensajeSis("El Número de Tarjeta no Existe");
				$('#tarjetaDebID').focus();
				$('#tarjetaDebID').val('');
				$('#estatus').val('');
				$('#clienteID').val('');
				$('#nombreCompleto').val('');
				$('#coorporativo').val('');
				$('#productoID').val('');
				$('#descripcionProd').val('');
				$('#nombreTarjeta').val('');
				$('#tipotarjetaID').val('');
                $('#nombreCoorp').val('');
                deshabilitaBoton('consultar','submit');
				$('#gridBitEstatusTarDeb').hide();
				$('#generar').hide();
				$('#tarjetaDebID').val('');
				
			}});
		}else if(isNaN(tarjetaDebID)){
			$('#tarjetaDebID').val('');
			$('#estatus').val('');
			$('#clienteID').val('');
			$('#nombreCompleto').val('');
			$('#coorporativo').val('');
			$('#productoID').val('');
			$('#descripcionProd').val('');
			$('#nombreTarjeta').val('');
			$('#tipotarjetaID').val('');
            $('#nombreTarjeta').val('');
            $('#nombreCoorp').val('');
			$('#tarjetaDebID').focus();
		    deshabilitaBoton('consultar','submit');
		}
		else if(Number(tarjetaDebID)== ''){
			$('#tarjetaDebID').val('');
			$('#estatus').val('');
			$('#clienteID').val('');
			$('#nombreCompleto').val('');
			$('#coorporativo').val('');
			$('#productoID').val('');
			$('#descripcionProd').val('');
			$('#nombreTarjeta').val('');
			$('#tipotarjetaID').val('');
            $('#nombreTarjeta').val('');
            $('#nombreCoorp').val('');
            deshabilitaBoton('consultar','submit');
			$('#gridBitEstatusTarDeb').hide();
			$('#generar').hide();
		}
	
	}	










	function consultaTarCoorpo(idControl) {
		var jqCoorpo = eval("'#" + idControl + "'");
		var coorporativo = $(jqCoorpo).val();
		var consulTarCoorpo = 12;
		setTimeout("$('#cajaLista').hide();", 200);
		if (  Number(coorporativo)>0  && !isNaN(coorporativo) ) {
			clienteServicio.consulta(consulTarCoorpo, coorporativo,"",function(cliente) {
				if (cliente != null) {
				
					$('#coorporativo').val(cliente.numero);
					$('#nombreCoorp').val(cliente.nombreCompleto);
				} else {
					mensajeSis("No Existe el Corporativo relacionado.");
					$('#coorporativo').val('');
					$('#nombreCoorp').val('');
				}
			});
		}else{
			$('#coorporativo').val('');
			$('#nombreCoorp').val('');
		}
	}
	

	$('#formaGenerica').validate({
		rules: {
			
			descripcion: {
				required: true,
				maxlength: 500
				
			},	
		},
		
		messages: {
		
			descripcion: {
				required: 'Especificar el Motivo de Bloqueo',
				maxlength: 'Máximo 500 Caracteres'				
			},	

		}		
	});
	


	$('#generar').click(function() {
      var tr =catTipoRepBitTarDeb.PDF;
		var tarjetaDebID = $("#tarjetaDebID").val();
		var fechaEmision = parametroBean.fechaSucursal;
		var nombreUsuario = parametroBean.claveUsuario; 
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		if ($("#tipoTarjetaDeb").is(':checked')){
			$('#ligaGenerar').attr('href','ReporteBitacoraEstatusTarDeb.htm?'+'&tarjetaDebID='+
				tarjetaDebID+'&tipoReporte='+tr+'&fechaEmision='+fechaEmision+'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion);
		}
		else if ($("#tipoTarjetaCred").is(':checked')) {
			$('#ligaGenerar').attr('href','ReporteBitacoraEstatusTarCred.htm?'+'&tarjetaDebID='+
				tarjetaDebID+'&tipoReporte='+tr+'&fechaEmision='+fechaEmision+'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion);
		}

		
	});	
	
	
	function consultaBitacoraEstatus(){
		var tarjetaDebID = $("#tarjetaDebID").val();
		if (tarjetaDebID != '' ){
			var params = {};
			params['tipoLista'] = 1;
			params['tarjetaID'] = tarjetaDebID;
			      
			$.post("gridBitacoraEstatusTarDeb.htm", params, function(data){
				
				if(data.length >0) {
					
					$('#gridBitEstatusTarDeb').html(data);
					$('#gridBitEstatusTarDeb').show();
					$('#generar').show();
				
				}else{
					$('#gridBitEstatusTarDeb').html("");
					$('#gridBitEstatusTarDeb').show();
					
				}
			});
		}else{
			$('#gridBitEstatusTarDeb').hide();
			$('#gridBitEstatusTarDeb').html('');
			
		}
	}

/*Consultabitacora de tarjeta de credito*/
function consultaBitStatusTarCred(){
		var tarjetaDebID = $("#tarjetaDebID").val();
		if (tarjetaDebID != '' ){
			var params = {};
			params['tipoLista'] = 1;
			params['tarjetaID'] = tarjetaDebID;
			      
			$.post("gridBitacoraEstatusTarCred.htm", params, function(data){
				if(data.length >0) {
					$('#gridBitEstatusTarDeb').html(data);
					$('#gridBitEstatusTarDeb').show();
					$('#generar').show();
				
				}else{
					$('#gridBitEstatusTarDeb').html("");
					$('#gridBitEstatusTarDeb').show();
				}
			});
		}else{
			$('#gridBitEstatusTarDeb').hide();
			$('#gridBitEstatusTarDeb').html('');
			
		}
	}

	
});




function lipiaCampos() {
	$('#tarjetaDebID').val('');
	$('#estatus').val('');
	$('#tarjetaHabiente').val('');
	$('#nombreCli').val('');
	$('#descripcion').val('');
	$('#motivoBloqID').val('');
	$('#tipotarjetaID').val('');
	$('#nombreTarjeta').val('');
	$('#clienteID').val('');
	$('#productoID').val('');
	$('#descripcionProd').val('');
	$('#nombreCompleto').val('');

}
$('#tipoTarjetaDeb').click(function() {	
	lipiaCampos();
	$('#tipoTarjetaCred').attr("checked",false);
	$('#tipoTarjeta').val('1');
	$('#tarjetaDebID').focus();
	$('#cuentaAhorro').show();
	$('#lineaCredito').hide();

	
});
$('#tipoTarjetaCred').click(function() {
	lipiaCampos();	
	$('#tipoTarjetaDeb').attr("checked",false);
	$('#tipoTarjeta').val('2');
	$('#tarjetaDebID').focus();
	$('#cuentaAhorro').hide();
	$('#lineaCredito').show();

	
});



	//funcion que se ejecuta cuando el resultado fue exito
	function funcionExitoBitEstaTar(){
			$('#tarjetaDebID').focus();
			$('#tarjetaDebID').val('');
			$('#estatus').val('');
			$('#clienteID').val('');
			$('#nombreCompleto').val('');
			$('#coorporativo').val('');
			$('#cuentaAho').val('');
			$('#nombreTipoCuenta').val('');
			$('#nombreTarjeta').val('');
			$('#tipotarjetaID').val('');
            $('#nombreTarjeta').val('');
            $('#nombreCoorp').val('');
			$('#gridBitEstatusTarDeb').hide();
			$('#generar').hide();
			deshabilitaBoton('consultar','submit');	
	}

	// funcion que se ejecuta cuando el resultado fue error
	// diferente de cero
	function funcionErrorBitEstaTar(){
			$('#tarjetaDebID').focus();
			$('#tarjetaDebID').val('');
			$('#estatus').val('');
			$('#clienteID').val('');
			$('#nombreCompleto').val('');
			$('#coorporativo').val('');
			$('#cuentaAho').val('');
			$('#nombreTipoCuenta').val('');
			$('#nombreTarjeta').val('');
			$('#tipotarjetaID').val('');
            $('#nombreTarjeta').val('');
            $('#nombreCoorp').val('');
			$('#gridBitEstatusTarDeb').hide();
			$('#generar').hide();
			deshabilitaBoton('consultar','submit');			
	}