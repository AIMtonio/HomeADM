$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();   

	deshabilitaBoton('generar', 'submit');

	var catTipoRepVencimientos = { 
			'PDF'		: 1
	};
	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$('#clienteID').focus();
	$('#pdf').attr("checked",true) ; 



	$(':text').focus(function() {	
		esTab = false;
	});


	

	$('#pdf').click(function() {
		if($('#pdf').is(':checked')){	
			$('#tdPresenacion').show('slow');
		}
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);

	});
	


	$('#generar').click(function() { 

		if($('#pdf').is(":checked") ){
			generaPDF();
		}


	});

	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var varclienteID = $(jqCliente).val();	
		var conCliente =5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(varclienteID != '' && !isNaN(varclienteID)){
			clienteServicio.consulta(conCliente,varclienteID,rfc,function(cliente){
						if(cliente!=null){
							if(cliente.esMenorEdad != 'S'){
								$('#clienteID').val(cliente.numero)	;						
								$('#nombreCliente').val(cliente.nombreCompleto);	
								habilitaBoton('generar', 'submit');
							}else{
								mensajeSis("El " + $('#alertSocio').val() + " Es Menor de Edad.");
								$(jqCliente).focus();
								$(jqCliente).val('');
								deshabilitaBoton('generar', 'submit');
							}
							
						}else{
							mensajeSis("No Existe el "  + $('#alertSocio').val() + ".");
							$(jqCliente).focus();
							$(jqCliente).val('');
							deshabilitaBoton('generar', 'submit');
						}    						
				});
			}
	}	

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});


$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	function generaPDF() {	
		if($('#pdf').is(':checked')){	
		 
			var tr= catTipoRepVencimientos.PDF; 
				
			var clienteID =$('#clienteID').val();
			var fechaEmision = parametroBean.fechaSucursal;
			var usuario = 	parametroBean.claveUsuario;
		
			/// VALORES TEXTO
			var nombreCliente = $('#nombreCliente').val();
			
		    var nombreInstitucion =  parametroBean.nombreInstitucion; 
		    var nombreSucursal=parametroBean.nombreSucursal;

			if(nombreCliente=='0'){
				nombreCliente='';
				
			}else{
				nombreCliente = $("#clienteID option:selected").html();
			}
		
			$('#ligaGenerar').attr('href','reporteNivelRiesgosPLD.htm?'+'clienteID='+clienteID	
					+'&fechaEmision='+fechaEmision+
					'&nomUsuario='+usuario+
					'&nomInstitucion='+nombreInstitucion+'&nomSucursal='+ nombreSucursal);
			$('#nombreCliente').val('');
			$('#clienteID').val('');
			$('#clienteID').focus();
			deshabilitaBoton('generar', 'submit');
			
			
		}
	}
});