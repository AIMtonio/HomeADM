$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();  
	//Definicion de Constantes y Enums  
	var catTipoTransaccionConocimientoCte = {
			'agrega':'1',
			'modifica':'2'	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica'); 
 	deshabilitaBoton('generar', 'submit');

 	validaEmpresaID();

	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionConocimientoCte.modifica);
	});	



	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);

	});


	$('#generar').click(function() {	
		  generaReporteRequisicion(); 
	});
	$('#numeroTarjeta').bind('keypress', function(e){
		return validaAlfanumerico(e,this);		
	});
	$('#numeroTarjeta').blur(function(e){
		var longitudTarjeta=$('#numeroTarjeta').val().length; 
		if (longitudTarjeta<16){
			$('#numeroTarjeta').val("");
		}else{
			consultaClienteIDTarDeb('numeroTarjeta');	
		}
	});
	
	//Función para poder ingresar solo números o letras 
	function validaAlfanumerico(e,elemento){//Recibe al evento 
		var key;
		if(window.event){//Internet Explorer ,Chromium,Chrome
			key = e.keyCode; 
		}else if(e.which){//Firefox , Opera Netscape
				key = e.which;
		}
		 if (key > 31 && (key < 48 ||  key > 57) && (key <65 || key >90) && (key<97 || key >122)) //Comparación con código ascii
		    return false;
		 var longitudTarjeta=$('#numeroTarjeta').val().length;		 	
		 		if (longitudTarjeta == 16 ){
					consultaClienteIDTarDeb('numeroTarjeta');							
				}	
		 return true;	
		 
		 
	}
		
	function generaReporteRequisicion(){
		var tipoReporte = 2;
		var tipoLista = 0;
		var cliente= $('#clienteID').val();
		var sucursal = $('#nombreSucursal').val();
		var fechaEmision = parametroBean.fechaSucursal;
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var nombreUsuario = parametroBean.nombreUsuario; 

		/// VALORES TEXTO
 		$('#ligaGenerar').attr('href','repPerfilCliente.htm?'
				+'clienteID='+cliente
				+'&nombreInstitucion='+nombreInstitucion
				+'&fechaSistema='+fechaEmision
				+'&nombreSucursal='+sucursal
				+'&tipoReporte='+tipoReporte
				+'&tipoLista='+tipoLista
				+'&nombreUsuario='+nombreUsuario);


	}

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
					$('#sucursal').val(cliente.sucursalOrigen);	 	
					validaSucursal() ;
					$('#promotorID').val(cliente.promotorActual);
					consultaPromotor('promotorID');
					habilitaBoton('generar', 'submit');
				}else{

					alert("No Existe el Cliente");
					deshabilitaBoton('generar', 'submit');
					$('#clienteID').val('')	;	
					$('#nombreCliente').val('');
					$('#nombreCliente').val('');
					$('#sucursal').val('');
					$('#promotorID').val('');
					$('#nombrePromotor').val('');
					$('#nombreSucursal').val('');				
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
						alert("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotor').val('');
					}    	 						
				});
			}
	}

	function validaSucursal() {
		var numSucursal = $('#sucursal').val();
		var consultaPrincipal=1;
		if(numSucursal != '' && !isNaN(numSucursal)){

			sucursalesServicio.consultaSucursal(consultaPrincipal,numSucursal,function(sucursal) { 
				if(sucursal!=null){

					$('#nombreSucursal').val(sucursal.nombreSucurs);

				}else{
					alert("No Existe la Sucursal");
					$('#sucursal').val(0);
					$('#nombreSucursal').val('');
				} 
			});
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
	
	function consultaClienteIDTarDeb(control){
		var jqControl=	eval("'#" + control + "'");
		var numeroTar=$(jqControl).val();
		var numTarIdenAccess=numeroTar.replace(/[%&(=?¡'{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\]/gi, '');
			numTarIdenAccess=numTarIdenAccess.replace(/[_]/gi,'');
			numTarIdenAccess=numTarIdenAccess.replace(/[' ']/gi,''); // Quitamos los espacios en blanco
			numeroTar=numTarIdenAccess;
			
		$(jqControl).val(numeroTar);
		var conNumTarjeta=20;
		var TarjetaBeanCon = {
				'tarjetaDebID'	:numeroTar
			};
		if(numeroTar != '' && numeroTar > 0){
			if ($(jqControl).val().length>16){
				alert("El Número de Tarjeta es Incorrecto deben de ser 16 dígitos");
				$(jqControl).val("");
				$(jqControl).focus();
			}
			if($(jqControl).val().length == 16){
				tarjetaDebitoServicio.consulta(conNumTarjeta,TarjetaBeanCon,function(tarjetaDebito) {
					if(tarjetaDebito!=null){					
						if (tarjetaDebito.estatusId==7){
							$('#idCtePorTarjeta').val(tarjetaDebito.clienteID);
							$('#nomTarjetaHabiente').val(tarjetaDebito.nombreCompleto);
							if ($('#numeroTarjeta').val()!=""&& $('#idCtePorTarjeta').val()!=""){
								$('#clienteID').val($('#idCtePorTarjeta').val());
								esTab=true;
								consultaCliente('clienteID');
							}
							$('#numeroTarjeta').val("");
							$('#idCtePorTarjeta').val("");
							$('#clienteID').focus();
						}else{
								if (tarjetaDebito.estatusId==1){
									alert("La Tarjeta no se Encuentra Asociada a una Cuenta");
								}else
								if (tarjetaDebito.estatusId==6){
									alert("La Tarjeta no se Encuentra Activa");
								}else
								if (tarjetaDebito.estatusId==8){
									alert("La Tarjeta se Encuentra Bloqueada");
								}else
								if (tarjetaDebito.estatusId==9){
									alert("La Tarjeta se Encuentra Cancelada");
								}
								$(jqControl).focus();
								$(jqControl).val("");
								$('#idCtePorTarjeta').val("");
								$('#nomTarjetaHabiente').val("");
								$('#clienteID').val('')	;	
								$('#nombreCliente').val('');
								$('#sucursal').val('');
								$('#promotorID').val('');
								$('#nombrePromotor').val('');
								$('#nombreSucursal').val('');		
								deshabilitaBoton('generar','button');
						}
					}else{
						alert("La Tarjeta de Identificación no existe.");
						$(jqControl).focus();
						$(jqControl).val("");
						$('#idCtePorTarjeta').val("");
						$('#nomTarjetaHabiente').val("");
						$('#clienteID').val('')	;	
						$('#nombreCliente').val('');
						$('#sucursal').val('');
						$('#promotorID').val('');
						$('#nombrePromotor').val('');
						$('#nombreSucursal').val('');	
						deshabilitaBoton('generar','button');
					}
					});	
				}
			}
		 }
});
