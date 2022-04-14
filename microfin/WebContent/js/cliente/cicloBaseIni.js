$(document).ready(function() {
	var catTipoConsultaProspec = {
	  		'principal':1
	};	
	var parametroBean = consultaParametrosSession();
	
	esTab = false;
	// Definicion de Constantes y Enums
	var Enum_Tra_Cliente = {
		'cicloBaseIA' : '1',
		'cicloBaseIM' : '2'		
	};


	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------
	deshabilitaBoton('modifica', 'submit'); 
	
	agregaFormatoControles('formaGenerica');
	$('#tipoTransaccion').val(Enum_Tra_Cliente.cicloBaseIA);
	$('#clienteID').focus(); 
	
	$(':text').focus(function() {
		esTab = false;
	});

	$('#graba').attr('tipoTransaccion', '1');
	$('#modifica').attr('tipoTransaccion', '2');
	$('#graba').click(function() {
		$('#tipoTransaccion').val(Enum_Tra_Cliente.cicloBaseIA);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(Enum_Tra_Cliente.cicloBaseIM);
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			if(validaprocli()){
				mensajeSis('El Cliente y Prospeto estan vacios');
				$('#clienteID').focus();
				$('#clienteID').select();
				return false;
			}
			
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'false','graba','Exito','Error');
			deshabilitaBoton('graba', 'submit');
			habilitaBoton('modifica', 'submit');
			
		}
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	
	$('#clienteID').bind('keyup',function(e) { 
				lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

/*
	$('#clienteID').bind('keyup',function(e){
		if($('#clienteID').val().length<3){		
			$('#cajaListaCte').hide();
		}
	});*/

	$('#buscarMiSuc').click(function(){
		listaCte('clienteID', '3', '19', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	
	$('#clienteID').blur(function() {
		if(esTab){
			var clie = Number($('#clienteID').val());
			if(clie != 0){
				consultaCliente($('#clienteID').val());
			}
		}		
	});



	$('#prospectoID').blur(function() {
		var pros = Number($('#prospectoID').val());
		
		if(pros !=0 ){
			consultaProspecto($('#prospectoID').val());
		}
		
	});
	
	$('#prospectoID').bind('keyup',function(e){
		if(Number($('#clienteID').val())==0)
		{lista('prospectoID', '1', '1', 'prospectoID', $('#prospectoID').val(), 'listaProspecto.htm');}
	});	
	

	
	$('#productoCreditoID').blur(function() { 
		if(esTab){
			consultaProductoCredito($('#productoCreditoID').val()); 
		}		
	});
	
	$('#productoCreditoID').bind('keyup',function(e){
		lista('productoCreditoID', '1', '1', 'descripcion', $('#productoCreditoID').val(), 'listaProductosCredito.htm');
	});
	

	
	
	// ------------ Validaciones de la Forma
	$('#formaGenerica').validate({
		rules : {
		
			productoCreditoID : {
				required : true,
				
			},
			cicloBaseIni : {
				required : true,
				numeroPositivo : true
			},
		},
	
		messages : {
			productoCreditoID : {
				required : 'Especificar Producto de Credito'
				
			},
			cicloBaseIni : {
				required : 'Especifique Ciclo Base Inicial',
				numeroPositivo : 'Especifique un numero entero positivo'
			},
	
		
		}
	});
	// ------------ Validaciones de Controles-------------------------------------
	
	

	// ------------ Consultas Sencillas para llenar las cajas --------------------
	function consultaCiclo(numCliente,numProspecto,numProd){
		var ncliente = numCliente;
		var nprospecto = numProspecto;
		var nprod = numProd;
		if(numCliente==''){ncliente='0';}
		
		if(numProspecto==''){nprospecto='0';}
		
		if(numProd==''){nprod='0';}
		
		cicloBaseIniServicio.consultaCicloBaseIni(1,ncliente,nprospecto, nprod,function(cliente) {
			if(cliente!=null){
				$('#cicloBaseIni').val(cliente.cicloBaseIni);
				deshabilitaBoton('graba', 'submit');
				habilitaBoton('modifica', 'submit');	
			}
			else{$('#cicloBaseIni').val('0');
				deshabilitaBoton('modifica', 'submit');
				habilitaBoton('graba', 'submit');}
		});
		
	}
	
	function consultaCliente(numCliente) {
		
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente) ) {
			clienteServicio.consulta(1,numCliente,function(cliente) {
				if (cliente != null) {
					$('#nombreCompleto').val(cliente.nombreCompleto);
					clienteServicio.consulta(10,numCliente,function(cliente2){
						if(cliente2 != null){
							var numeroProspecto = (cliente2.prospectoID);
							$('#prospectoID').val(numeroProspecto);
							var prospectosBeanCon ={
						 		 	'prospectoID' : cliente2.prospectoID
							};	
							prospectosServicio.consulta(1,prospectosBeanCon,function(prospectos) {
								if(prospectos == null || prospectos == undefined){mensajeSis('Error con el prospecto relacionado');}
								else{$('#nombreProspecto').val(prospectos.nombreCompleto);}
							});
						}
						else{
							$('#prospectoID').val('0');
							$('#nombreProspecto').val('');
						}
					});
					$('#productoCreditoID').focus();
					$('#productoCreditoID').select();
					
				} else {
					limpiaForm($('#formaGenerica'));
					mensajeSis("No Existe el Cliente");
					$('#clienteID').focus();
					$('#clienteID').select();
				}
				
				$('#productoCreditoID').val('');
				$('#descripcion').val('');
				$('#cicloBaseIni').val('');
			});
			
		}
		else{
			
			$('#prospectoID').val('');
			$('#productoCreditoID').val('');
			$('#nombreProspecto').val('');
			$('#descripcion').val('');
			$('#cicloBaseIni').val('');
			
		}
	}

	
	function consultaProspecto(numProspecto) {
		
		setTimeout("$('#cajaLista').hide();", 200);
		var pros =Number( $('#prospectoID').val());
		var clie =Number( $('#clienteID').val());
		if(pros==0 && clie==0){
			mensajeSis('El Cliente y Prospeto estan vacios');
			$('#clienteID').focus();
			$('#clienteID').select();
			return;
		}
		if(numProspecto != '' && !isNaN(numProspecto) ){	
			var prospectoBeanCon ={
		 		 	'prospectoID' : numProspecto 
			};		
			prospectosServicio.consulta(1,prospectoBeanCon,function(prospectos) {
				if(prospectos!=null){
					//esta variable y este if son para validar que el prospecto corresponda con el cliente 
					var clienteID = Number($('#clienteID').val());
					var clientepID = Number(prospectos.cliente); 
					if(clientepID!= clienteID && clienteID!=0  ){
						mensajeSis("El prospecto no corresponde con el cliente");
						$('#prospectoID').val('');
						$('#prospectoID').focus();
						$('#prospectoID').select();
					}else{
						$('#nombreProspecto').val(prospectos.nombreCompleto);
						$('#clienteID').val(prospectos.cliente);
						clienteServicio.consulta(1,prospectos.cliente,'',function(cliente) {
							if(cliente == null || cliente == undefined){
								$('#nombreCompleto').val('');
							}
							else{
								
								$('#nombreCompleto').val(cliente.nombreCompleto);
							}
						});
						
						
						
						$('#productoCreditoID').val('');
						$('#descripcion').val('');
						$('#cicloBaseIni').val('');
					}
					
				}else {
					mensajeSis("No Existe el prospecto");
					$('#prospectoID').focus();
					$('#prospectoID').select();
				}
			});			
		}
		else{
			
			$('#clienteID').val('');
			$('#nombreCompleto').val('');
			
			$('#productoCreditoID').val('');
			$('#descripcion').val('');
			$('#cicloBaseIni').val('');
			
		}
	} 
	
	function consultaProductoCredito(numProCre){
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProCre != '' && !isNaN(numProCre)){
			var prodCreditoBeanCon = { 
	  				'producCreditoID':numProCre
				};
	
		productosCreditoServicio.consulta(1,prodCreditoBeanCon,function(prodCred) {
			if(prodCred!=null){
				$('#descripcion').val(prodCred.descripcion);
				consultaCiclo( $('#clienteID').val(),$('#prospectoID').val()  ,$('#productoCreditoID').val()   );
			}else {
				mensajeSis("No Existe el Producto de Crédito");
				$('#productoCreditoID').focus();
				$('#productoCreditoID').select();
			}
		});
		
		
		}else{$('#cicloBaseIni').val('');}
	}

	function validaprocli(){
		var clienten = Number($('#clienteID').val());
		var prospecton = Number($('#prospectoID').val());
		if(clienten>0){return false;}
		if(prospecton>0){return false;}

		return true;
	}
	/***********************************/
	
});//	FIN VALIDACIONES DE REPORTES

function Exito(){
	
}
function Error(){
	deshabilitaBoton('graba','submit');
	deshabilitaBoton('modifica','submit');
	$('#nombreCompleto').val('');
	$('#nombreProspecto').val('');
	$('#prospectoID').val('');
	$('#descripcion').val('');
	$('#productoCreditoID').val('');
	$('#cicloBaseIni').val('');
	
}
