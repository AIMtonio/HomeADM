$(document).ready(function() {
	esTab = true;
	var tab2=false;

	//Definicion de Constantes y Enums  
	var catTipoTransaccionProveedores = {  
			'agrega':'1',
			'actualizacion':'2'
	};

	var catTipoConsultaFactura = {
			'anticipo':3,

	};
	var catTipoConsultaProveedor = {
			'principal':1,

	};
	var catTipoConsultaProveedores = {
			'principal'	: 1

	};
	var catTipoActualFactura = {
			'cancelaAnticipo':1
	};

	var listaPersBloqBean = {
			'estaBloqueado'	:'N',
			'coincidencia'	:0
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------	
	$('#proveedorID').focus();
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('cancela', 'submit');
	$('#gridAnticipoFactura').hide();   
	$('#divSaldoAnticipo').hide();   
	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$.validator.setDefaults({
		submitHandler: function(event) { 
			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','false',
			  'funcionExitoAnticipoFactura','funcionErrorAnticipoFactura');
		}
	});	

	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionProveedores.agrega);
		$('#tipoActualizacion').val(catTipoActualFactura.cancelaAnticipo);
		$('#gridAnticipoFactura').show();
		$('#divSaldoAnticipo').show();
	});

	$('#cancela').click(function() {	
		$('#tipoTransaccion').val(catTipoTransaccionProveedores.actualizacion);
		$('#tipoActualizacion').val(catTipoActualFactura.cancelaAnticipo);
		habilitaBotonCancelaAnticipo();
		$("#montoAnticipo").rules("remove");
		confirmarCancelar(event);	
	});	

	$('#montoAnticipo').blur(function() {	
		$('#montoAnticipo').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2
		});
		verificaMonto(this.id); 
		verificaMontoAnticipo(this.id);
		verificaMontoSaldo(this.id);
	});
	$('#noFactura').blur(function() {
		validaFacturaProveedor(this.id);
	});

	$('#noFactura').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "noFactura";
		camposLista[1] = "proveedorID";
		parametrosLista[0] = $('#noFactura').val();
		parametrosLista[1] = $('#proveedorID').val();
		listaAlfanumerica('noFactura', '1', 6, camposLista, parametrosLista, 'listaFacturaProvVista.htm');
	});	

	$('#proveedorID').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "primerNombre"; 
			camposLista[0] = "apellidoPaterno"; 
			parametrosLista[0] = $('#proveedorID').val();
			listaAlfanumerica('proveedorID', '1', '1', camposLista, parametrosLista, 'listaProveedores.htm');
			
		}
	});	

	$('#proveedorID').blur(function() {
		var proveedor = $('#proveedorID').asNumber();
		if(isNaN($('#proveedorID').val()) ){
			$('#proveedorID').val("");
			$('#proveedorID').focus();
		}else{
			if(tab2 == false){
				if(proveedor>0){
					listaPersBloqBean = consultaListaPersBloq(proveedor, 'PRV', 0, 0);
					if(listaPersBloqBean.estaBloqueado!='S'){
						consultaProveedor(this.id);
						$('#formaPago').val('');
						$('#gridAnticipoFactura').hide();
						$('#divSaldoAnticipo').hide();
					} else {
						setTimeout("$('#cajaLista').hide();", 200);
						mensajeSis('El Proveedor se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('cancela', 'submit');
						$('#proveedorID').val("");
						$('#nombreProv').val("");
						$('#proveedorID').focus();
					}
				}
			}
		}
	});

	$('#formaPago').change(function() {	
		validaTipoPago(this.id);
	});

	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

		rules: {
			noFactura: { 
				required: true
			},
			proveedorID: {
				required: true
			},
			montoAnticipo: {
				required: true,
				number: true
			}
		},		
		messages: {		
			noFactura: {
				required: 'Seleccionar Número de Factura'
			},
			proveedorID: {
				required: 'Especificar Proveedor.'
			},
			montoAnticipo: {
				required: 'Especificar Monto Anticipo.',
				number : 'Sólo Números.'
			}
		}		
	});



	//------------ Validaciones de Controles -------------------------------------

	
	function verificaMonto(idControl){
		var jqNumMonto = eval("'#" + idControl + "'");
		var monto = $(jqNumMonto).asNumber();
		if(monto == 0 && esTab){
			mensajeSis("El Monto de Anticipo debe ser Mayor a $ 0.00");
			$('#montoAnticipo').val('');
			$('#montoAnticipo').focus();
		}
		
	}
	function verificaMontoAnticipo(idControl){
		var jqNumMontoAnticipo = eval("'#" + idControl + "'");
		var montoAnticipo = $(jqNumMontoAnticipo).asNumber();
		if(montoAnticipo > $('#saldoAnticipo').asNumber()){
			mensajeSis("El Monto de Anticipo debe ser menor o igual al Saldo con Anticipos");
			$('#montoAnticipo').val('');
			$('#montoAnticipo').focus();
		}
	}
	function verificaMontoSaldo(idControl){
		var jqNumMontoAnticipo = eval("'#" + idControl + "'");
		var montoAnticipo = $(jqNumMontoAnticipo).asNumber();
		if(montoAnticipo > $('#saldoFactura').asNumber()){
			mensajeSis("El Monto de Anticipo debe ser menor o igual al Saldo de la Factura");
			$('#montoAnticipo').val('');
			$('#montoAnticipo').focus();
		}
	}

	/////////////////////funcion validar factura proveedor/////////////////////////////////////////////
	function validaFacturaProveedor(idControl) {
		var jqFactura  = eval("'#" + idControl + "'");
		var numFactura = $(jqFactura).val();
		
		var facturaBeanCon = { 
				'proveedorID':$('#proveedorID').val(),
				'noFactura'	:numFactura,
		};

		setTimeout("$('#cajaLista').hide();", 200);
				if(numFactura != '' ){
					facturaProvServicio.consulta(catTipoConsultaFactura.anticipo, facturaBeanCon,function(factura) {
						if(factura!=null){

							if(factura.estatusReq == null){
								mensajeSis("La Factura no se encuentra en una Requisición de Gastos");
								$('#gridAnticipoFactura').hide();
								$('#divSaldoAnticipo').hide();
								$('#noFactura').val('');
								$('#noFactura').focus();
								$('#totalFactura').val('');
								$('#saldoFactura').val('');
								$('#formaPago').val('');
								deshabilitaBoton('agrega', 'submit');
							}
							
							else if(factura.estatusReq == 'P'){
								mensajeSis("La Factura se encuentra en proceso de Requisición");
								$('#gridAnticipoFactura').hide();
								$('#divSaldoAnticipo').hide();
								$('#noFactura').val('');
								$('#noFactura').focus();
								$('#totalFactura').val('');
								$('#saldoFactura').val('');
								$('#formaPago').val('');
								deshabilitaBoton('agrega', 'submit');
							}
							else if(factura.estatusReq == 'C'){
								mensajeSis("La Factura se encuentra Cancelada");
								$('#gridAnticipoFactura').hide();
								$('#divSaldoAnticipo').hide();
								$('#noFactura').val('');
								$('#noFactura').focus();
								$('#totalFactura').val('');
								$('#saldoFactura').val('');
								$('#formaPago').val('');
								deshabilitaBoton('agrega', 'submit');
							}
							else if(factura.estatus == 'L'){
								consultaAnticipoFactura('noFactura');
								validaProveedor(idControl);
								$('#totalFactura').val(factura.totalFactura);
								$('#saldoFactura').val(factura.saldoFactura);
								agregaFormatoControles('formaGenerica');	
								deshabilitaBoton('agrega', 'submit');
								}
							else if(factura.estatus == 'V'){
							mensajeSis("La Factura se encuentra Vencida");
							$('#gridAnticipoFactura').hide();
							$('#divSaldoAnticipo').hide();
							$('#noFactura').val('');
							$('#noFactura').focus();
							$('#totalFactura').val('');
							$('#saldoFactura').val('');
							$('#formaPago').val('');
							deshabilitaBoton('agrega', 'submit');
							}
							else if(factura.estatus == 'A'){
							mensajeSis("La Factura se encuentra con estatus de Alta");
							$('#gridAnticipoFactura').hide();
							$('#divSaldoAnticipo').hide();
							$('#noFactura').val('');
							$('#noFactura').focus();
							$('#totalFactura').val('');
							$('#saldoFactura').val('');
							$('#formaPago').val('');
							deshabilitaBoton('agrega', 'submit');
						}
							else if(factura.estatus == 'C'){
							mensajeSis("La Factura se encuentra Cancelada");
							$('#gridAnticipoFactura').hide();
							$('#divSaldoAnticipo').hide();
							$('#noFactura').val('');
							$('#noFactura').focus();
							$('#totalFactura').val('');
							$('#saldoFactura').val('');
							$('#formaPago').val('');
							deshabilitaBoton('agrega', 'submit');
						}
							else {
								consultaAnticipoFactura('noFactura');
								validaProveedor(idControl);
								$('#totalFactura').val(factura.totalFactura);
								$('#saldoFactura').val(factura.saldoFactura);
								habilitaBoton('agrega', 'submit');
								agregaFormatoControles('formaGenerica');	
							}
					}
						else {
							//mensajeSis("El Número de Factura no Existe");
							$('#gridAnticipoFactura').hide();
							$('#divSaldoAnticipo').hide();
							$('#noFactura').val('');
							$('#noFactura').focus();
							$('#totalFactura').val('');
							$('#saldoFactura').val('');
							$('#formaPago').val("");
							deshabilitaBoton('agrega', 'submit');
						}

					});																	 				
				}
			}




	// funcion para consultar al proveedor
	function consultaProveedor(idControl) {
		inicializaForma('formaGenerica','proveedorID');	
		var jqProveedor  = eval("'#" + idControl + "'");
		var numProveedor = $(jqProveedor).val();	

		var proveedorBeanCon = { 
				'proveedorID'	:numProveedor
		};		
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProveedor != '' && !isNaN(numProveedor)){
			proveedoresServicio.consulta(catTipoConsultaProveedor.principal,proveedorBeanCon,function(proveedores) {
				if(proveedores!=null){
					esTab=true;
					var nombreCompleto ="";
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('cancela', 'submit');
					if(proveedores.estatus != 'A'){
						mensajeSis("El Proveedor Debe estar Activo");
						inicializaForma('formaGenerica','proveedorID');	
						$('#proveedorID').val('');
						$('#proveedorID').focus();
					}else{
						if(proveedores.tipoPersona == 'F' ){
							nombreCompleto = proveedores.primerNombre+" "+proveedores.segundoNombre+" "+proveedores.apellidoPaterno+" "
							+proveedores.apellidoMaterno;
						}
						if(proveedores.tipoPersona == 'M' ){
							nombreCompleto = proveedores.razonSocial;
						}
						$('#nombreProv').val(nombreCompleto);	
					}
				}
				else{
					mensajeSis("El Proveedor No Existe.");
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('cancela', 'submit');
					$('#proveedorID').val("");
					$('#proveedorID').focus();

				}
			});
		}	
	}
	
	function validaProveedor(idControl) {
		var jqFactura  = eval("'#" + idControl + "'");
		var numProveedor = $(jqFactura).val();

		var proveedorBeanCon = { 
				'proveedorID':$('#proveedorID').val()
		};
				
		setTimeout("$('#cajaLista').hide();", 200);
				//////////consulta de proveedores/////////////////////////////
				if(numProveedor != '' ){
				proveedoresServicio.consulta(catTipoConsultaProveedores.principal,proveedorBeanCon,function(proveedores) {
					if(proveedores!=null){
						$('#formaPago').val(proveedores.tipoPago);				
					}
				});
			}

		}

	function confirmarCancelar(event) {		
		$('#tipoTransaccion').val('2');
		confirmar=confirm("¿Desea cancelar el anticipo?"); 
		if (confirmar) {
		}else{
			event.preventDefault();
			}						
		}
	});

	// funcion que valida el tipo de pago
	function validaTipoPago(idControl){	
		var numProveedor = $("#proveedorID").val();		
		var valorFormaPago =$("#formaPago").val();
				
		var tipoConsul =3;
		var proveedorBeanCon = { 
			'proveedorID'	:numProveedor	
		};	
		setTimeout("$('#cajaLista').hide();", 200);	
		valorFormaPagoC = eval("'#formaPago" + " option[value=C]'");
		valorFormaPagoS = eval("'#formaPago" + " option[value=S]'");
		if(valorFormaPago=="S"){
			if(numProveedor != '' && !isNaN(numProveedor)){		
				proveedoresServicio.consulta(tipoConsul,proveedorBeanCon,function(proveedoresCta) {
					if(proveedoresCta!=null){
						if(proveedoresCta.cuentaClave == "" ||  $.trim(proveedoresCta.cuentaClave)==""){ 
							mensajeSis("El Proveedor No Tiene Parametrizado Pagos con SPEI");
							$(valorFormaPagoC).attr("selected",true);
						}else{
							$(valorFormaPagoS).attr("selected",true);
						}
						
					}else{
						mensajeSis("El Proveedor No Tiene Parametrizado Pagos con SPEI");
						$(valorFormaPagoC).attr("selected",true);

					}
				});
			}
		}
	} 
	
	// funcion que calcula el anticipo de la factura
	function calculaAnticipoFactura(idControl){
	
		var jqTotal  = eval("'#" + idControl + "'");
		var total = $(jqTotal).asNumber();
	
		var sumaAnticipos=0;
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqestatusAnticipo = eval("'estatusAnticipo" + numero+ "'");
			var jqmontoAnticipo = eval("'montoAnticipo" + numero+ "'");
			
			var valorestatusAnticipo=$('#'+jqestatusAnticipo).val();
			var valoremontoAnticipo=$('#'+jqmontoAnticipo).asNumber();
			if(valorestatusAnticipo != 'Cancelado'){
				sumaAnticipos=sumaAnticipos + valoremontoAnticipo;
			}
		});
		return total- sumaAnticipos; 
	}

	// funcion que habilita el boton cancela
	function habilitaBotonCancelaAnticipo(){
		var totalSeleccionados=0;
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqestatusCancela = eval("'estatus" + numero+ "'");
			
			if($('#'+jqestatusCancela).attr('checked')==true){
				totalSeleccionados = totalSeleccionados+1;	
				$('#estatus'+numero).val($('#anticipoFactID'+numero).val());
			}
		});
		
		if(totalSeleccionados > 0){
			habilitaBoton('cancela', 'submit');			
		}else {
			deshabilitaBoton('cancela', 'submit');
		}
		
	}
	
	// funcion para consultar los anticipos de los proveedores
	function consultaAnticipoFactura(idControl){
		var jqFactura  = eval("'#" + idControl + "'");
		var noFactura = $(jqFactura).val();
		if (noFactura != '' ){
			var params = {};
			params['tipoLista'] = 2;
			params['noFactura'] = noFactura;
			params['proveedorID'] = $('#proveedorID').val();
			
			      
			$.post("gridAnticipoFactura.htm", params, function(data){
			
				if(data.length >0) {
					agregaFormatoControles('formaGenerica');
					$('#gridAnticipoFactura').html(data);
					$('#gridAnticipoFactura').show();
					$('#divSaldoAnticipo').show();
					
					$('#saldoAnticipo').val(calculaAnticipoFactura('totalFactura'));
					$('#saldoAnticipo').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					var contador = 0;
					var jqMontoAntID ="";
					$('input[name=montoAnticipoGrid]').each(function() {	
						contador = contador + 1;
						jqMontoAntID = eval("'#montoAnticipo"+contador+"'");
						$(jqMontoAntID).formatCurrency({
									positiveFormat: '%n', 
									roundToDecimalPlace: 2	
						});
					});
					
				}else{
					$('#gridAnticipoFactura').html("");
					$('#gridAnticipoFactura').show();
					$('#divSaldoAnticipo').show();
				}
			});
		}else{
			$('#gridAnticipoFactura').hide();
			$('#gridAnticipoFactura').html('');
			$('#divSaldoAnticipo').hide();
			
		}
	}

	function funcionExitoAnticipoFactura (){
		consultaAnticipoFactura('noFactura');
		$('#totalFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#saldoFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#montoAnticipo').val('');
		$('#saldoAnticipo').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		deshabilitaBoton('cancela', 'submit');
	}

	function funcionErrorAnticipoFactura (){
		consultaAnticipoFactura('noFactura');
		$('#totalFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#saldoFactura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#montoAnticipo').val('');
		$('#saldoAnticipo').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		deshabilitaBoton('cancela', 'submit');
	}
