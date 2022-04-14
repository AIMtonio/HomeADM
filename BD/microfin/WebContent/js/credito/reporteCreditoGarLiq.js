$(document).ready(function() {
	esTab = true;

	var parametroBean = consultaParametrosSession();  
	//Definicion de Constantes y Enums 
	
	var catTipoConsultas = {
			'principal':1,
			'consulta' : 11,
			'foranea'  :2
	};
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#sucursal1').val(parametroBean.sucursal);
	validaSucursal1();
	
	$('#sucursal1').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursal1', '2', '4', 'nombreSucurs', $('#sucursal1').val(), 'listaSucursales.htm');
	});
	
	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '2', '1', 'nombreCompleto',$('#clienteID').val(),'listaCliente.htm');
	});
	
	
	$('#creditoID').bind('keyup',function(e){
		if($('#clienteID').asNumber()==0){
			lista('creditoID', '2', '1', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
		}else{
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "creditoID";
			camposLista[1] = "clienteID";
			parametrosLista[0] =$('#creditoID').val();
			parametrosLista[1] = $('#clienteID').val();
			lista('creditoID', '2', '13', camposLista, parametrosLista, 'ListaCredito.htm');

	}
		
	});
	$('#sucursal1').blur(function() { 
		if($('#sucursal1').val()=="0"|| $('#sucursal1').val()==""){
			$('#sucursal1').val(parametroBean.sucursal);
			validaSucursal1();
		}else{
			validaSucursal1();
		}
	});
	
	$('#creditoID').blur(function() { 
		if($('#creditoID').val()=="0"||$('#creditoID').val()==""){
			$('#nombreClienteCre').val('TODOS');
			$('#creditoID').val('0');
		}else{
			validaCredito();
		}

	});
	$('#clienteID').blur(function() { 
		if($('#clienteID').val()=="0"||$('#clienteID').val()==""){
			$('#nombreCliente').val('TODOS');
			$('#clienteID').val('0');
		}else{
			consultaCliente('clienteID');
		}
		
	});

	
	$('#generar').click(function() {	
		var credito = $('#creditoID').val();
		var sucursalInicial=$('#sucursal1').val();
		var sucursalFinal=$('#sucursal2').val();
		var Cliente=$('#clienteID').val();
		var nombreInstitucion=parametroBean.nombreInstitucion;
			$('#ligaGenerar').attr('href','RepCredGarLiq.htm?creditoID='+credito+ '&sucursalInicial='+sucursalInicial+'&sucursalFinal='+sucursalFinal+
														'&clienteID='+Cliente+'&nombreInstitucion='+nombreInstitucion+ 
														'&nomUsuario='+parametroBean.nombreUsuario+'&fechaEmision='+parametroBean.fechaSucursal);

	});


	//------------ Validaciones de la Forma -------------------------------------	

	$('#formaGenerica').validate({

		rules: {
		
		},
		messages: {
			
		}		
	});


	//------------ Validaciones de Controles -------------------------------------

	function validaCredito() {
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) ){
			var creditoBeanCon = { 
					'creditoID':$('#creditoID').val()
			};			

			if(numCredito==0){
				$('#nombreClienteCre').val('TODOS');
			}
			else{
				creditosServicio.consulta(catTipoConsultas.consulta,creditoBeanCon,function(credito) {
					if(credito!=null){
						if(credito.sucursal!=$('#sucursal1').val()){
							$('#sucursal1').val(credito.sucursal);
							var numSucursal = $('#sucursal1').val();
								sucursalesServicio.consultaSucursal(catTipoConsultas.principal,numSucursal,function(sucursal) { 
									if(sucursal!=null){
											$('#nombreSucursal1').val(sucursal.nombreSucurs);
									}
									});
						}
						
						if(credito.clienteID!=$('#clienteID').val()){
							$('#clienteID').val(credito.clienteID);
							var numCliente=$('#clienteID').val();
							clienteServicio.consulta(catTipoConsultas.foranea,numCliente,function(cliente) {
								if(cliente!=null){						
									$('#nombreCliente').val(cliente.nombreCompleto);
								}    	 						
							});
						}
						
						// consulta de productos de credito 
							var principal =1;
							var ProdCred = credito.producCreditoID;
							var ProdCredBeanCon = {
									'producCreditoID' : ProdCred
							};
								productosCreditoServicio.consulta(principal,ProdCredBeanCon,function(prodCred) {
											if (prodCred != null) {
												$('#nombreClienteCre').val(prodCred.descripcion);
											} 
										});
							
				
					}else{
						alert("No Existe el Credito");
						$('#creditoID').focus();
						$('#creditoID').val('0');
						$('#nombreClienteCre').val('TODOS');

					}
				});
			}

		}
	}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		setTimeout("$('#cajaLista').hide();", 200);		

		if(numCliente != '' && !isNaN(numCliente) && esTab){				
			if(numCliente==0){
				$('#nombreCliente').val("TODOS");
				
			}else{
			clienteServicio.consulta(catTipoConsultas.foranea,numCliente,function(cliente) {
				if(cliente!=null){			
					$('#clienteID').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#nombreClienteCre').val('TODOS');	
					$('#creditoID').val('0');
				}else{
					alert("No Existe el Cliente");
					$('#clienteID').focus();
					$('#clienteID').select();	
					$('#clienteID').val('0');
					$('#nombreCliente').val('TODOS');		
				}    	 						
			});
			}
		}
	}

	//Consulta el Nombre de La Sucursal Inicial
	function validaSucursal1() {
		var numSucursal = $('#sucursal1').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(catTipoConsultas.principal,numSucursal,function(sucursal) { 
				if(sucursal!=null){
						$('#nombreSucursal1').val(sucursal.nombreSucurs);
						$('#nombreClienteCre').val('TODOS');	
						$('#creditoID').val('0');
				}else{
					alert("No Existe la Sucursal");
					$('#sucursal1').focus();
					$('#sucursal1').val(parametroBean.sucursal);
					validaSucursal1();
					$('#nombreClienteCre').val('TODOS');	
					$('#creditoID').val('0');
				} 
				});
			}
		}	

//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

});















