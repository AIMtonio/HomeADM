$(document).ready(function() {
	$("#clienteID").focus();
	esTab = false;
	var parametroBean = consultaParametrosSession();  
	
	var catTipoConsultas = {
			'principal':1,
			'consulta' : 11,
			'foranea'  :2
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica'); 
 	deshabilitaBoton('generar', 'submit');

 	validaEmpresaID();
 	
 	$(':text').focus(function() {
		esTab = false;
	});

 	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		if(esTab){
		consultaCliente(this.id);
	}
	});

	$('#creditoID').bind('keyup',function(e){
		if($('#clienteID').asNumber()>0){
		
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "creditoID";
			camposLista[1] = "clienteID";
			parametrosLista[0] =$('#creditoID').val();
			parametrosLista[1] = $('#clienteID').val();
			lista('creditoID', '2', '42', camposLista, parametrosLista, 'ListaCredito.htm');

	}
		
	});
	$('#creditoID').blur(function() { 
		if(esTab ){
		if($('#creditoID').val()=="0"||$('#creditoID').val()==""){
			$('#nombreClienteCre').val('TODOS');
			$('#creditoID').val('0');
		}else{
			validaCredito();
		}
		}

	});

	$('#generar').click(function() {	
		  
		  if($('#clienteID').val()!=""){
				generaReporte();	
			}else{
				alert("Especifique Cliente");
				$('#clienteID').val('')	;	
				$('#nombreCliente').val('');
				$('#nombreClienteCre').val('');	
				$('#creditoID').val('');
				$("#clienteID").focus();	
				deshabilitaBoton('generar', 'submit');
			}
	});
	// ------------ Validaciones de la Forma
	$('#formaGenerica').validate({
		rules : {
			clienteID : {
				required : true
			}
		},
		
		messages : {
			clienteID : {
				required : 'Especifique Cliente',
				
			}
		}
	});
		
	function generaReporte(){
		var tipoReporte = 2;
		var tipoLista = 0;
		var cliente= $('#clienteID').val();
		var credito = $('#creditoID').val();
		var fechaEmision = parametroBean.fechaSucursal;
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var nombreUsuario = parametroBean.nombreUsuario; 

		/// VALORES TEXTO
 		
 		window.open('reporteSaldosSocios.htm?'
				+'clienteID='+cliente
				+'&creditoID='+credito
				+'&nombreInstitucion='+nombreInstitucion
				+'&fechaSistema='+fechaEmision
				+'&tipoReporte='+tipoReporte
				+'&tipoLista='+tipoLista
				+'&nombreUsuario='+nombreUsuario);


	}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		

		if(numCliente != '' && !isNaN(numCliente) && esTab ){
			clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero)	;						
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#nombreClienteCre').val('TODOS');	
					$('#creditoID').val('0');
					habilitaBoton('generar', 'submit');
				}else{

					alert("No Existe el Cliente");
					deshabilitaBoton('generar', 'submit');
					$('#clienteID').val('')	;	
					$('#nombreCliente').val('');
					$('#nombreClienteCre').val('');	
					$('#creditoID').val('');
					$("#clienteID").focus();
									
				}    	 						
			});
		}else{
			if(isNaN(numCliente) && esTab ){

				alert("No Existe el Cliente");
				deshabilitaBoton('generar', 'submit');
				$('#clienteID').val('')	;	
				$('#nombreCliente').val('');
				$('#nombreClienteCre').val('');	
				$('#creditoID').val('');
				$("#clienteID").focus();
			}
		}
	}	

	
	function validaEmpresaID() {
		var numEmpresaID = 1;
		var tipoCon = 1;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				if(parametrosSisBean.servReactivaCliID !=null){
					 if(parametrosSisBean.tarjetaIdentiSocio=="S"){
							$('#tarjetaIdentiCA').show();
							$('#numeroTarjeta').val("");
							$('#idCtePorTarjeta').val("");
							$('#nomTarjetaHabiente').val("");
							$("#numeroTarjeta").focus();
						}else{
							$("#clienteID").focus();
							$('#tarjetaIdentiCA').hide();
							$('#numeroTarjeta').val("");
							$('#idCtePorTarjeta').val("");
							$('#nomTarjetaHabiente').val("");
						}
				}else{
					
				}
			}
		});
	}
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
	

});
