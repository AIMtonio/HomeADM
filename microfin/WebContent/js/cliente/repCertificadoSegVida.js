$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();   

	var catTipoRepVencimientos = { 
			'PDF'		: 1,
	};	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('imprimir', 'submit');
	$(':text').focus(function() {	
		esTab = false;
	});

    $('#clienteID').blur(function() {
		consultaCliente(this.id);
	});

	$('#imprimir').click(function() { 
			generaPDF();
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

    $('#clienteID').bind('keyup',function(e) { 
	if(this.value.length >= 2){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "nombreCliente";
		parametrosLista[0] = $('#clienteID').val();		
		listaAlfanumerica('clienteID', '3', '1', camposLista, parametrosLista, 'listaClientesSeguro.htm');
	}
	});


    function consultaCliente(idControl) {
	var jqCliente  = eval("'#" + idControl + "'");
	var varclienteID = $(jqCliente).val();	
	var foranea =2;
	
	var rfc = ' ';
	setTimeout("$('#cajaLista').hide();", 200);		
	if(varclienteID != '' && !isNaN(varclienteID)){
		clienteServicio.consulta(foranea,varclienteID,rfc,function(cliente){
					if(cliente!=null){		
						$('#clienteID').val(cliente.numero);
						$('#nombreCliente').val(cliente.nombreCompleto);
						consultaSeguroAyudaPago();
						habilitaBoton('imprimir', 'submit');
					}else{
						alert("No Existe el Cliente");
						inicializaForma('formaGenerica','clienteID');
						deshabilitaBoton('imprimir', 'submit');
						$(jqCliente).focus();
						$(jqCliente).val('');
					}    						
			});
		}
   }	

    function consultaSeguroAyudaPago(){
		    var numCliente= $('#clienteID').val();
			var conCertSedVida =4;
			var seguroVida={
					'seguroClienteID':0,
					'clienteID':numCliente
			};
			setTimeout("$('#cajaLista').hide();", 200);		
			if(numCliente != '' && !isNaN(numCliente)){
				seguroCliente.consulta(conCertSedVida,seguroVida,function(seguro){
						if(seguro!=null){		
							$('#seguroClienteID').val(seguro.seguroClienteID);							
							$('#montoSeguro').val(seguro.montoSegPagado);								
							var estatus = (seguro.estatus);
							if(estatus=="V"){
								$('#estatus').val('VIGENTE');
							}
							if(estatus=="C"){
								$('#estatus').val('COBRADO');
							}		
							$('#fechaInicio').val(seguro.fechaInicio); 
							$('#fechaFin').val(seguro.fechaVencimiento); 
							
						}else{										
							alert("El Socio no tiene un Seguro de Ayuda");
							inicializaForma('formaGenerica','clienteID');
							deshabilitaBoton('imprimir', 'submit');
							$('#clienteID').focus();
							$('#clienteID').val('');	
						}    						
				});
			}		 
	 }

	function generaPDF() {	
			var clienteID =$('#clienteID').val();
			var sucursal = parametroBean.sucursal;
			var fecha = parametroBean.fechaSucursal;
		    var direccion = parametroBean.direccionInstitucion;
            var pdf=1;		
			var nombreCliente = $('#nombreCliente').val();
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var rfcinstit    = parametroBean.rfcInst;
            var telInst  =  parametroBean.telefonoLocal;
            
			$('#ligaPDF').attr('href','repCertSegVida.htm?clienteID='+clienteID+'&sucursal='+sucursal+
					'&nombreCliente='+nombreCliente+'&fechaActual='+fecha+'&telefonoInst='+telInst+
					'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+
					'&direccionInstit='+direccion+'&RFCInstit='+rfcinstit+'&tipoReporte='+pdf);
		}
	});
