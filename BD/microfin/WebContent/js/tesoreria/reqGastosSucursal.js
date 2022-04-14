var cuentaclabeproveedorfac="";
$(document).ready(function() {
	// Definicion de Constantes y Enums	
	esTab = true;
	var parametroBean = consultaParametrosSession();	

	// si el usuario que esta accediendo al sistema es diferente de un rol de tesoreria, entonces
	// este usuario puede capturar requisiciones.
	//validarMostrarCapturar();

	$('#fechRequisicion').val(parametroBean.fechaSucursal);
	var noPresupuestado = eval("'#noPresupuestado'");
	var montoAuto = eval("'#montoAuto'");
	var montoDispon = eval("'#montoDispon'");
	var partidaPre = eval("'#partidaPre'");
	var camposRequeridos = "1";
	var existeFacturaProveedor = "0";
	var existeConcepto = "0";
	var divCajaLista = $('#cajaLista');

	agregaDisabled (noPresupuestado);
	agregaDisabled (montoAuto);
	agregaDisabled (montoDispon);
	agregaDisabled (partidaPre);

	$('#numReqGasID').focus();
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	agregaFormatoControles('formaGenerica');
	inicializaForma('formaGenerica', 'numReqGasID');	

	var catTipoTransaccionRequisicion = {
			'agregar'	:1,
			'modificar'	:2
	};

	var catTipoConsultaRequisicion = {
			'principal':1
	};

	var catTipoListaTipoRequisicion = {
			'principal':1
	};
	var catTipoConsultaCentroCosto ={
			'principal':1
	};	

	var catTipoListaTipoGasto = {
			'principal':1,
			'sucursal':2
	};

	var catTipoConsultaReq= {
			'principal':1,
			'foranea':2,
			'saldoDispon':4
	};
	var catTipoConsultaTipoGasto={
			'principal':1

	};
	var catTipoLista = {
			'combo':2
	};	

	var catStatusRequisicion = {
			'alta':		'Alta',
			'cancelada': 	'Cancelado',
			'autorizada':	'Autorizada',
			'procesada':	'Procesada'
	};
	
	var catTipoListaReqGastosSuc = {
			'estatusAlta':1,
			'estatusProcesado':2
	};

	var listaPersBloqBean = {
			'estaBloqueado'	:'N',
			'coincidencia'	:0
	};

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
	
		}
	});
	
		
	function envioFormulario(event){
		// si no se ha captura ningun detalle de requisión no se hace el submit
		if($('#numeroDetalle').asNumber()<=0 || $.trim('#numeroDetalle') == ''){
			mensajeSis("Debe de Capturarse por lo menos \n un Detalle de Requisición");
			return false;//event.preventDefault();
		}else{
			if($('#numReqGasID').val()!="" ){
				// antes de hacer el submit se valida que los campos que se sugieren como requeridos, no viajen vacios.
				camposRequeridos = validarCamposRequeridosPerfilBasico();
				if(camposRequeridos == "0"){
				//	desbloqueaDesembolso();
					$('#estatus').removeAttr('disabled');     
					if( $('#estatus').val()=='F'){
						if(existenAprobados('A')){
							grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','numReqGasID','funcionExito','funcionError');
						}
						else{
							mensajeSis("Imposible agregar Requisición. No existen movimientos aprobados");
						}		
					}else{
						grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','numReqGasID','funcionExito','funcionError');
					}
					deshabilitaBoton('agregar', 'submit');
					deshabilitaBoton('modificar', 'submit');
				}
			}
		}
	}

	$('#noFactura').blur(function(){
		//if(!existeFactura($('#noFactura').val(),$('#proveedorIDFact').val()) ){
			if (!divCajaLista.is(':visible')){
				if(existeFacturaProveedor =="0"){
					consultaFacturaProveedor(this.id);
				}
			}
			if($('#noFactura').val()=="" ||  $.trim('#noFactura') == ''){
				$('#proveedorIDFact').val("");
				$('#totalFactura').val("");
				$('#saldoFactura').val("");
				$('#descProveedorFact').val("");
			}
		//}
	});
	
	$('#noFactura').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "noFactura";
		camposLista[1] = "proveedorIDFact";
		parametrosLista[0] = $('#noFactura').val();
		parametrosLista[1] = $('#proveedorIDFact').val();
		listaAlfanumerica('noFactura', '1',5, camposLista, parametrosLista, 'listaFacturaProvVista.htm');
	});

	$('#noFactura').focus(function(){
		if (divCajaLista.is(':visible')){
			if(existeConcepto =="0"){
				var tipoDescrip = eval("'#descripcionTG'");
				consultaTipoGasto('tipoGastoID',tipoDescrip);
			}
		}		
	});

	$('#proveedorIDFact').bind('keyup',function(e){ 
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();		
			camposLista[0] = "apellidoPaterno"; 
			parametrosLista[0] = $('#proveedorIDFact').val();
			listaAlfanumerica('proveedorIDFact', '1', '1', camposLista, parametrosLista, 'listaProveedores.htm');
		}		
	});

	$('#proveedorIDFact').blur(function(){
		var proveedor = $('#proveedorIDFact').asNumber();
		if(proveedor>0){
			listaPersBloqBean = consultaListaPersBloq(proveedor, 'PRV', 0, 0);
			if(listaPersBloqBean.estaBloqueado!='S'){
				consultaProveedorFactura(this.id);
			} else {
				$('#cajaLista').hide();
				mensajeSis('El Proveedor se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
				$('#proveedorIDFact').focus();
				$('#proveedorIDFact').select();
				$('#proveedorIDFact').val("");
			}
		}
	});

	$('#tipoGastoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcionTG";
			parametrosLista[0] = $('#tipoGastoID').val();
			lista('tipoGastoID', '2', 1, camposLista, parametrosLista, 'requisicionTipoGastoListaVista.htm');
		}
	});

	$('#tipoGastoID').focus(function(){
		if (divCajaLista.is(':visible')){
			if(existeFacturaProveedor =="0"){
				consultaFacturaProveedor('noFactura');
			}
		}
	});

	$('#tipoGastoID').blur(function(){
		var tipoDescrip = eval("'#descripcionTG'");
		if(esTab) $('#cajaLista').hide();	
		// si se definiera que no se puede tener dos requisiciones de gasto individual del mismo 
		// tipo de gasto, descomentar esta parte
		//var existeGto = existeTipoGasto($('#tipoGastoID').val());
		/*if(existeGto==false) {
			if($('#tipoGastoID').val()=="" ||  $.trim('#tipoGastoID') == ''){
				$('#tipoGastoID').val("");
				$('#descripcionTG').val("");
				$('#proveedorID').val("");
				$('#descProveedor').val("");
				$('#observaciones').val("");
				$('#partidaPre').val("");
				$('#partidaPreID').val("");
				$('#montoDispon').val("");
				$('#montoPre').val("");
				$('#montoAuto').val("");
				$('#noPresupuestado').val("");
				$('#monAutorizado').val("");
				$('#status').val("");
			}else{*/
		if (!divCajaLista.is(':visible')){
			consultaTipoGasto('tipoGastoID',tipoDescrip);
			agregaFormatoControles('formaGenerica');
		}
		/*	}
		}*/
	});

	$('#numReqGasID').focus(function(){
		if (divCajaLista.is(':visible')){
			if(existeFacturaProveedor =="0"){
				consultaFacturaProveedor('noFactura');
			}
		}
	});
	 
	$('#numReqGasID').blur(function(){
		if($('#numReqGasID').val()!='' && !isNaN($('#numReqGasID').val()) && esTab == true){
			validaRequisicion('numReqGasID');
		}else{
			setTimeout("$('#cajaLista').hide();", 200);
			if($('#numReqGasID').val()==''){
				$('#numReqGasID').val("0");
				$('#numeroDetalle').val("0");
				habilitaBoton('agregar', 'submit');
				muestraBotones();
				//if($('#numeroDetalle').val()!=0){
					limpiaTablaDetalles();
				//}

				$('#aplicaPro').hide();
				$('#sucursalID').val(parametroBean.sucursal);
				$('#nombreSucursal').val(parametroBean.nombreSucursal);
				$('#usuarioID').val(parametroBean.numeroUsuario);   
				$('#nombreUsuario').val(parametroBean.nombreUsuario);   
				$('#fechRequisicion').val(parametroBean.fechaSucursal);				
				if($('#estatus').val()!='A'){ 
					$('#estatus').append('<option value="A" selected="true">Alta</option>'); 
				}
				$('#estatus').attr('disabled','true');
				$('#formaPago option[value=C]').attr('selected','true');				
			}
		}
	});

	$('#numReqGasID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "sucursalID";
		camposLista[1] = "descripcionSuc";
		parametrosLista[0] = parametroBean.sucursal;
		parametrosLista[1] = $('#numReqGasID').val();
		// si el usuario es de un perfil Tesoreria o administrador tesoreria 
		// muestra lista con estatus procesado filtrado por sucursal
			if(parametroBean.perfilUsuario ==parametroBean.rolTesoreria || parametroBean.perfilUsuario ==parametroBean.rolAdminTeso){ //--
			listaAlfanumerica('numReqGasID', '2', catTipoListaReqGastosSuc.estatusProcesado, camposLista, parametrosLista, 'reqGastosSucListaVista.htm');
		}else{
			listaAlfanumerica('numReqGasID', '0', catTipoListaReqGastosSuc.estatusAlta, camposLista, parametrosLista, 'reqGastosSucListaVista.htm');
		}	
	});

	$('#observaciones').blur(function(){
		ponerMayusculas(this);
	});

	$('#observaciones').focus(function(){
		if (divCajaLista.is(':visible')){
			if(existeFacturaProveedor =="0"){
				consultaFacturaProveedor('noFactura');
			}
		}
	});

	$('#agregar').click(function(event) {	
		if($('#numReqGasID').val()==0 && parametroBean.perfilUsuario!=parametroBean.rolTesoreria){ //--
			$('#estatus').val('P');
		}	 
		$('#tipoTransaccion').val(catTipoTransaccionRequisicion.agregar);	
		
		envioFormulario(event);
	});
	
	$('#modificar').click(function(event) {		 
		$('#tipoTransaccion').val(catTipoTransaccionRequisicion.modificar);
		envioFormulario(event);
	});	


	$('#formaPago').change(function() {		 

	});
	
	$('#formaPago').focus(function() {		 
		if($('#numReqGasID').val()=='' || isNaN($('#numReqGasID').val()) ){
			validaRequisicion('numReqGasID');
		}
	});

	$('#montoPre').blur(function() {		 
		if($('#montoPre').val()!=''){
			validaMontoPres();
			}
		if(esTab==true){
			$('#agreDetalle').focus();
		}
	});	

	$('#agreDetalle').click(function() {	
		if($.trim($('#tipoGastoID').val()) != '' && $('#tipoGastoID').val() != "" && $('#tipoGastoID').val() != "0"  ){
			if($.trim($('#proveedorID').val()) != '' && $('#proveedorID').val() != "" && $('#proveedorID').val() != "0"  ){
				$('#rTotalGasto').remove();
				agregaNuevoDetalle();
				//agregaDatosNuevoDetalle();
				//agregaTotales();//agrega inputs de totales
				agregaFormatoControles('formaGenerica');
				$('#contenedorDtlle').show();				
				if($('#prorrateoHecho').val()=='N'){
					$('#aplicaPro').show(300);	
				}
				
				$('#tipoGastoID').focus();
							
			}else{
				mensajeSis("Para agregar un nuevo detalle \n es necesario indicar un Proveedor");
				$('#proveedorID').focus();
				$('#aplicaPro').hide(300);
			}			
		}else{
			mensajeSis("Para agregar un nuevo detalle \n es necesario indicar un Concepto");
			$('#tipoGastoID').focus();
			$('#aplicaPro').hide(300);
		}	
	});	
	
	$('#agreDetalleFac').focus(function() {	
		if (divCajaLista.is(':visible')){
			if(existeFacturaProveedor =="0"){
				consultaFacturaProveedor('noFactura');
			}
		}
	});
	
	$('#aplicaPro').click(function(){
		$('#prorrateoContable').show(500);
		$('#aplicaPro').hide(500);
		limpiarCamposGrid();
		$('#prorrateoID').focus();
	});
	
	$('#cancelaProrrateo').click(function(){
		$('#prorrateoContable').hide(500);
		$('#aplicaPro').show(500);
		limpiarCamposGrid();
	});
	
	$('#prorrateoID').bind('keyup',function(){
		lista('prorrateoID','2','1','nombreProrrateo',$('#prorrateoID').val(),'prorrateoContableLista.htm');
	});
	
	$('#prorrateoID').blur(function(){
		if($('#prorrateoID').val()!=''){
			if(esTab){
				if(!isNaN($('#prorrateoID').val()) ){
					consultaMetodoProrrateo(this);
				}else{
					mensajeSis('Solo se Aceptan Números');					
					$('#prorrateoID').val('');
					$('#nombreProrrateo').val('');
					$('#descripcion').val('');
					$('#gridProrrateoContable').hide();
					$('#prorrateoID').focus();
				}
			}						
		}	
	});
	
	// se agregan los detalles cuando se ingresa un numero de factura
	$('#agreDetalleFac').click(function() {
		if($.trim($('#proveedorIDFact').val()) != '' && $('#noFactura').val() != "" && $('#totalFactura').val() != "0"  ){
			if (divCajaLista.is(':visible')){
				if(existeFacturaProveedor =="0"){
					consultaFacturaProveedor('noFactura');
				}
			}
			agregaDatosNuevoDetalleFactura('noFactura','proveedorIDFact');
			agregaFormatoControles('formaGenerica');
			ActualizaTotalesPre();
			$('#contenedorDtlle').show();
			if($('#prorrateoHecho').val()=='N'){
				$('#aplicaPro').show(200);
			}
		} else {
			mensajeSis("Para agregar factura \n es necesario indicar un Proveedor y No. Factura");
			$('#proveedorIDFact').focus();
			$('#aplicaPro').hide(300);
		}
	});
	
	
	$('#proveedorID').bind('keyup',function(e){ 
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();		
			camposLista[0] = "apellidoPaterno"; 
			parametrosLista[0] = $('#proveedorID').val();
			listaAlfanumerica('proveedorID', '1', '1', camposLista, parametrosLista, 'listaProveedores.htm');
		}		
	});

	$('#proveedorID').blur(function(){
		consultaProveedor(this.id);
	});

	$('#proveedorID').focus(function(){
		if (divCajaLista.is(':visible')){
			if(existeFacturaProveedor =="0"){
				consultaFacturaProveedor('noFactura');
			}
		}
	});
	
	
	//funcion para mostrar la lista de Centro de Constos en el Grid de Detalle Factura  lore			
		/*$('#centroCostoFact').bind('keyup',function(e){	
			var num = $('#centroCostoFact').val();				
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = num;
		
			lista('centroCostoFact', '2', '1', camposLista, parametrosLista, 'listaCentroCostos.htm');
		});*/
		$('#centroCostoDet').bind('keyup',function(e){			
			var num = $('#centroCostoDet').val();				
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = num;
		
			lista('centroCostoDet', '2', '1', camposLista, parametrosLista, 'listaCentroCostos.htm');
		});

	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			sucursalID :'required',
			numReqGasID: 'required',	
			usuarioID: 'required'
		},
		messages: {
			sucursalID :'La sucursal es requerida',
			numReqGasID: 'El número de requisición es requerido',	
			usuarioID: 'El usuario es requerido'
		}
	});
	
	
	// si el usuario que esta accediendo al sistema es diferente de un rol de tesoreria, entonces
	// este usuario puede capturar requisiciones.
		function validarMostrarCapturar(){
		parametroBean = consultaParametrosSession();
		if(parametroBean.perfilUsuario == parametroBean.rolTesoreria || parametroBean.perfilUsuario == parametroBean.rolAdminTeso){ //--
			setTimeout("$('#cajaLista').hide();", 200);
			$('#capturaDetalle').hide();	
			$('#capturaFactura').hide();
			deshabilitaBoton('agregar', 'submit');
			habilitaBoton('modificar', 'submit');
		}
	}
	
	
	function validaSucursal(control) {
		var numSucursal = $('#sucursalID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		sucursalesServicio.consultaSucursal(1,numSucursal,function(sucursal) { 
			if(sucursal!=null){
				$('#sucursalID').val(sucursal.sucursalID);
				$('#nombreSucurs').val(sucursal.nombreSucurs);
			}
		});
	}



		
	//-----------------------------------------------------------------------------------------------------/
	// se consulta el tipo de gasto y el presupuesto cuando es una requisicion sin factura
	function consultaTipoGasto(idControl,tipoDescrip){
		var jqTipoGasto = eval("'#" + idControl + "'");
		var numTipoGasto = $(jqTipoGasto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		if($.trim(numTipoGasto) != '' && !isNaN(numTipoGasto)  ){
			var RequisicionTipoGastoListaBean = {
					'tipoGastoID' : numTipoGasto
			};
			requisicionGastosServicio.consultaTipoGasto(catTipoConsultaTipoGasto.principal,RequisicionTipoGastoListaBean,function(tipoGastoCon){
				if(tipoGastoCon!=null){
					$(tipoDescrip).val(tipoGastoCon.descripcionTG);
					consultaPresupuesto();
					existeConcepto = "0";
					$('#noPresupuestado').val("0.00");
					$('#montoAuto').val("0.00");
				}else{
					mensajeSis("No existe el Tipo de Gasto");
					$(jqTipoGasto).val("");
					$(jqTipoGasto).focus();
					$(jqTipoGasto).select();
					$('#proveedorID').val("");
					$('#descripcionTG').val("");
					$('#descProveedor').val("");
					$('#observaciones').val("");
					$('#partidaPre').val("");
					$('#partidaPreID').val("");
					$('#montoDispon').val("");
					$('#montoPre').val("");
					$('#montoAuto').val("");
					$('#noPresupuestado').val("");
					$('#monAutorizado').val("");
					$('#status').val("");
					existeConcepto = "1";
				}	
			});				
		}else{	
			if($.trim(numTipoGasto) != '' ){
				mensajeSis("No existe el Tipo de Gasto");
				$(jqTipoGasto).val("");
				$(jqTipoGasto).focus();
				$(jqTipoGasto).select();
				$('#proveedorID').val("");
				$('#descripcionTG').val("");
				$('#descProveedor').val("");
				$('#observaciones').val("");
				$('#partidaPre').val("");
				$('#partidaPreID').val("");
				$('#montoDispon').val("");
				$('#montoPre').val("");
				$('#montoAuto').val("");
				$('#noPresupuestado').val("");
				$('#monAutorizado').val("");
				$('#status').val("");
				existeConcepto = "1";
			}
		}
	}// fin consultaTipoGasto
	
	// si se hace una requisicion por  factura se consulta su tipo de gasto	
	function consultaTipoGastoFactura(idControl,tipoDescrip){
		var jqTipoGasto = eval("'#" + idControl + "'");
		var numTipoGasto = $(jqTipoGasto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numTipoGasto != '' && !isNaN(numTipoGasto) ){
			var RequisicionTipoGastoListaBean = {
					'tipoGastoID' : numTipoGasto
			};
			requisicionGastosServicio.consultaTipoGasto(catTipoConsultaTipoGasto.principal,RequisicionTipoGastoListaBean,function(tipoGastoCon){
				if(tipoGastoCon!=null){
					$(tipoDescrip).val(tipoGastoCon.descripcionTG);
				}else{
					mensajeSis("No existe el Tipo de Gasto");
					$(jqTipoGasto).focus();
					$(jqTipoGasto).select();
					$(jqTipoGasto).val("");
				}	
			});				
		}
	}

	function consultaTipoGastoGrid(idControl,tipoDescrip){
		var jqTipoGasto = eval("'#" + idControl + "'");
		var numTipoGasto = $(jqTipoGasto).val();
		if(numTipoGasto != '' && !isNaN(numTipoGasto) ){
			var RequisicionTipoGastoListaBean = {
					'tipoGastoID' : numTipoGasto
			};
			requisicionGastosServicio.consultaTipoGasto(catTipoConsultaTipoGasto.principal,RequisicionTipoGastoListaBean,function(tipoGastoCon){
				if(tipoGastoCon!=null){
					$(tipoDescrip).val(tipoGastoCon.descripcionTG);
				}else{
					$(jqTipoGasto).focus();
				}	
			});				
		}
	}

	function consultaPresupuesto(){
		var concepto= $('#tipoGastoID').val();
		var fecha = $('#fechRequisicion').val();
		var sucursalID = $('#sucursalID').val();
		var PreSucursalBean = {
				'folio': 1,//no importante en cunsult foranea
				'conceptoPet':concepto,
				'sucursal': sucursalID,
				'fecha':fecha
		};
		presupSucursalServicio.consulta(catTipoConsultaReq.foranea, PreSucursalBean, 	function(preBean){
			if(preBean!=null){
				if(preBean.montoDispon!=0){
					$('#partidaPreID').val(preBean.folio);
					$('#observaciones').val(preBean.descripcionPet);
					$('#partidaPre').val(preBean.montoPet);
					$('#montoDispon').val(preBean.montoDispon);

					$('#montoDispon').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
					$('#montoPre').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
					$('#montoAuto').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
					$('#noPresupuestado').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
					$('#partidaPre').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
				}
				else{
					iniciaPresupuesto();    		  	
				}
			}
			else{
				iniciaPresupuesto();    	 
			}
		});
	}

	function iniciaPresupuesto(){
		$('#partidaPreID').val('0.00');
		$('#observaciones').val('');
		$('#partidaPre').val('0.00');
		$('#montoDispon').val('0.00');
		$('#montoPre').val('');
		$('#montoAuto').val('0.00');
		$('#noPresupuestado').val('0.00');
	}
	
	function validaMontoPres(){
		var montoAutorizado=0.00;
		var noPresupuestado=0.00;
		var montoSolicitado = $('#montoPre').asNumber();
		var montoDisponible = $('#montoDispon').asNumber();
		var factura = $('#noFactura').val();
		if(factura == 0 || factura ==''){  // si es por tipo de gasto consulta el presupuesto
			if(montoDisponible > montoSolicitado){
				montoAutorizado=montoSolicitado;
				noPresupuestado='0.00';
			}
			if(montoDisponible < montoSolicitado){
				montoAutorizado=montoDisponible;
				noPresupuestado= (montoAutorizado - montoSolicitado)* -1;
							
			} 
			//$('#montoAuto').val(montoAutorizado);
			$('#noPresupuestado').val(noPresupuestado);
			$('#noPresupuestado').val($('#noPresupuestado').asNumber());
			$('#partidaPre').formatCurrency({positiveFormat: '%n',negativeFormat: '%n',  roundToDecimalPlace: 2});
			$('#montoDispon').formatCurrency({positiveFormat: '%n',negativeFormat: '%n',  roundToDecimalPlace: 2});
			$('#montoPre').formatCurrency({positiveFormat: '%n',negativeFormat: '%n',  roundToDecimalPlace: 2});
			$('#montoAuto').formatCurrency({positiveFormat: '%n',negativeFormat: '%n',  roundToDecimalPlace: 2});
			$('#noPresupuestado').formatCurrency({positiveFormat: '%n',negativeFormat: '%n',  roundToDecimalPlace: 2});
		
		}
		else{
			consultaPresupuestoGastoPorFactura();
		}
		
	}

	// funcion para consultar el numero de requisicion ingresada  vvv
	function validaRequisicion(idControl){
		var jqRequisicion = eval("'#" + idControl + "'");
		var numRequisicion = $(jqRequisicion).val();
		if(numRequisicion == 0 ){
			validarMostrarCapturar();
			$(noFactura).val("");	
			$(proveedorID).val("");	
			$(descProveedor).val("");	
			$(tipoGastoID).val("");	
			$(descripcionTG).val("");
			$(observaciones).val("");

			$(partidaPre).val("");
			$(partidaPreID).val("");
			$(montoPre).val("");
			$(montoAuto).val("");
			$(montoDispon).val("");
			$(noPresupuestado).val("");
			$(monAutorizado).val("0.00");
			
			muestraBotones();
			$('#numeroDetalle').val("0");
			limpiaTablaDetalles();
			$('#sucursalID').val(parametroBean.sucursal);
			$('#nombreSucursal').val(parametroBean.nombreSucursal);
			$('#fechRequisicion').val(parametroBean.fechaSucursal);
			$('#usuarioID').val(parametroBean.numeroUsuario);   
			$('#nombreUsuario').val(parametroBean.nombreUsuario);   
			$('#prorrateoHecho').val('N');
			
			if($('#estatus').val()!='A'){ 
				$('#estatus').append('<option value="A" selected="true">Alta</option>'); 
			}
			$('#estatus').attr('disabled','true');
			$('#formaPago option[value=C]').attr('selected','true');
			setTimeout("$('#cajaLista').hide();", 200);
			habilitaBoton('agregar', 'submit');
			deshabilitaBoton('modificar', 'submit');			
			limpiarCamposGrid();			
			
			//validarMostrarCapturar();
		}else{
			var RequisicionBean = {
					'numReqGasID' : numRequisicion
			};
			reqGastosSucServicio.consulta(catTipoConsultaTipoGasto.principal,RequisicionBean,function(data){
				if(data!=null){
					$('#miTabla').html(""); 
					setTimeout("$('#cajaLista').hide();", 200);
					if(data.sucursalID == parametroBean.sucursal || parametroBean.perfilUsuario==parametroBean.rolTesoreria || parametroBean.perfilUsuario==parametroBean.rolAdminTeso){
						dwr.util.setValues(data);
						$('#nombreSucursal').val(data.sucursalDescr);
						$('#nombreUsuario').val(data.usuarioDescr);
						$('#rTotalGasto').remove();

						if( $('#estatus').val() =='F' ||  $('#estatus').val() =='C' ){
							escondeBotones();
							$('#estatus').attr('disabled','true');
							mensajeSis("La Requisición se encuentra Cancelada o Finalizada");
							$('#aplicaPro').hide();
							$(jqRequisicion).select();
							$(jqRequisicion).focus();
							$(jqRequisicion).val('');
						}else{
							muestraBotones();
							if(parametroBean.numeroUsuario==$('#usuarioID').val()){
								$('#estatus').removeAttr('disabled');
								$('#estatus option[value=A]').replaceWith('');
								muestraBotones();
							}
							if(parametroBean.perfilUsuario==parametroBean.rolTesoreria || parametroBean.perfilUsuario==parametroBean.rolAdminTeso){ 
								$('#agregar').show();
								$('#modificar').show();                        
								$('#capturaDetalle').hide(); 
								$('#capturaFactura').hide();
							}else{
								escondeBotones();	
								deshabilitaBoton('agregar', 'submit');
								deshabilitaBoton('modificar', 'submit');
							}
							$('#estatus').attr('disabled','true');
							if(parametroBean.perfilUsuario == parametroBean.rolTesoreria ){ //--
								pegaHtml(2, 'miTabla', data.estatus);
							}else{
								pegaHtml(catTipoConsultaReq.principal, 'miTabla',data.estatus);
							}														
						}	 	
						
						$('#tipoGasto').val(data.tipoGasto).selected = true;
						$('#aplicaPro').hide();
						deshabilitaBoton('agregar', 'submit');
						habilitaBoton('modificar', 'submit');
					}
					else{
						mensajeSis("La requisición no pertenece a esta sucursal");
						setTimeout("$('#cajaLista').hide();", 200);
						limpiaTablaDetalles();
						$(jqRequisicion).focus();
						$(jqRequisicion).select();
						$(jqRequisicion).val("");
						$('#aplicaPro').hide();
					}
				}else {
					mensajeSis("No existe la requisición: "+numRequisicion);	
					setTimeout("$('#cajaLista').hide();", 200);
					limpiaTablaDetalles();
					$(jqRequisicion).focus();
					$(jqRequisicion).select();
					$(jqRequisicion).val("");
					$('#aplicaPro').hide();
				}	
			});	
		}		
	}

	function escondeBotones(){
		$('#agregar').hide();
		$('#modificar').hide();		
		$('#capturaDetalle').hide();	
		$('#capturaFactura').hide();
	}
	function muestraBotones(){
		$('#agregar').show();
		$('#modificar').show();
		$('#capturaDetalle').show();
		$('#capturaFactura').show();
	}		
	
	//--------------------- Lista Centro costo Requisicion   lore---------------------------------
	function agregaNuevoDetalle(){  
				
		var numeroFila = document.getElementById("numeroDetalle").value;
		var nuevaFila = parseInt(numeroFila) + 1;		
		var permisosEscritura='readOnly="true"';
		var permisoAutorizacion ='readOnly="true"';
		var noPresupuestado = eval("'#noPresupuestado'");	
		var montoFueraPre = $(noPresupuestado).asNumber();

		if(parametroBean.numeroUsuario == $('#usuarioID').val()){
			permisosEscritura='';
		}
		if(parametroBean.perfilUsuario == parametroBean.rolTesoreria && montoFueraPre<=0){ //--
			permisoAutorizacion='';
		}

		if(parametroBean.perfilUsuario == parametroBean.rolAdminTeso){ //--
			permisoAutorizacion='';
		}

		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon" >';
		tds +='<td><input type="text" id="consecutivo'+nuevaFila+'"	name="numero" path="numero" size="2" autocomplete="off" value="'+nuevaFila+'"  disabled="true" />';
		tds +='<input type="hidden" id="detReqGasID'+nuevaFila+'"	name="ldetReqGasID" path="ldetReqGasID"  value="0"  /></td>';
		tds +='<td><input type="text" name="lcentroCostoID"	id="centroCostoID'+nuevaFila+'" path="centroCostoID" size="9" autocomplete="off"  readOnly="true" />';
		tds +='</td>';
		tds +='<td><input type="text" name="lnoFactura"	id="noFactura'+nuevaFila+'" path="noFactura" size="9" autocomplete="off"  readOnly="true" />';
		tds +='</td>';

		tds +='<td><input type="text" name="ltipoGastoID"	id="tipoGastoID'+nuevaFila+'" path="tipoGastoID" size="3" autocomplete="off"  readOnly="true" />';
		tds +='</td><td>';
		tds +='<input type="text" name="descripcionTG" id="descripcionTG'+nuevaFila+'" path="descripcionTG" size="25"	autocomplete="off"  disabled="true"/>';						  
		tds +='</td>';
		tds +='<td><input type="text" name="lproveedor"	id="proveedorID'+nuevaFila+'" path="proveedorID" size="3" autocomplete="off"  readOnly="true" />';
		tds +='</td><td>';
		tds +='<input type="text" name="descProveedor" id="descProveedor'+nuevaFila+'"  size="25"	autocomplete="off"  disabled="true"/>';						  
		tds +='</td>';
		
		tds +='<td> <textarea rows="2" cols="20"  name="lobservaciones" id="observaciones'+nuevaFila+'"  '+permisosEscritura+' maxlength= "50" onBlur=" ponerMayusculas(this)"/></td>';

		tds +='<td>';
		tds +='<input type="text" name="lpartidaPre"id="partidaPre'+nuevaFila+'" style="text-align:right;" esMoneda="true" path="partidaPre" size="10"	autocomplete="off"  readOnly="true"  />';
		tds +='<input type="hidden" name="lpartidaPreID" id="partidaPreID'+nuevaFila+'"  size="13"	 />';			
		tds +='<input type="hidden" name="totalDisponible"	id="totalDisponible'+nuevaFila+'" esMoneda="true" path="totalDisponible"  />';	
		tds +='</td> ';
		tds +='<td>';
		tds +='<input type="text" name="lmontoPre"	id="montoPre'+nuevaFila+'" style="text-align:right;" esMoneda="true" path="montoPre" size="13"autocomplete="off"  '+permisosEscritura+' onBlur="consultaPresupuestoDetalle('+nuevaFila+');" onkeyPress="return Validador(event);"/>';
		tds +='</td> ';
		tds +='<td>';
		tds +='<input type="text" name="lnoPresupuestado"	id="noPresupuestado'+nuevaFila+'"  style="text-align:right;" esMoneda="true" path="noPresupuestado" size="13"	autocomplete="off" readOnly="true"  />';
		tds +='</td>';
				
		tds +='<td>';
		if(parametroBean.perfilUsuario == parametroBean.rolTesoreria || parametroBean.perfilUsuario == parametroBean.rolAdminTeso){//--
			tds +='<input type="text" name="lmonAutorizado"  id="monAutorizado'+nuevaFila+'" style="text-align:right;" esMoneda="true" path="monAutorizado" size="13"	autocomplete="off" '+permisoAutorizacion+' onBlur="editarAutorizado(\''+nuevaFila+'\') " onkeyPress="return Validador(event);"/>';
		}else{
			tds +='<input type="text" name="lmonAutorizado" id="monAutorizado'+nuevaFila+'" style="text-align:right;" esMoneda="true" path="monAutorizado" size="13"	autocomplete="off" '+permisoAutorizacion+' />';
		}

		tds +='</td>';
		
		tds +='<td>';
		tds +='<select id="tipoDeposito'+nuevaFila+'" name="ltipoDeposito" path="tipoDeposito" tabindex="11" onchange="validaTipoDesembolsoInd('+nuevaFila+');">';
		tds +='<option value="C">Cheque</option>';
		tds +='<option value="S">Spei</option>';
		tds +='<option value="B">Banca Electrónica</option>';
		tds +='<option value="T">Tarjeta Empresarial</option>';
		tds +='</select>';
		tds +='</td> ';
		
		tds +='<td>';
		if(permisoAutorizacion == ''){
			tds +='';
			tds +='<select  name="lstatus" id="status'+nuevaFila+'"  onchange="validaAprobacion('+nuevaFila+');" path="status">';
			tds +='<option value="P">Pendiente</option>';
			tds +='<option value="A">Aprobado</option>';
			tds +='<option value="C">Cancelado</option>';
			tds +='</select>';
		} 
		if(permisoAutorizacion != ''){
			tds +='<input type="text" name="status"id="statusVista'+nuevaFila+'" path="status" size="11"	autocomplete="off" readOnly="true"  />';
			tds +='<input type="hidden" name="lstatus" id="status'+nuevaFila+'" path="status" size="11"	autocomplete="off" readOnly="true"  />';
		}         
		tds +='</td> ';
		
		if(permisoAutorizacion != ''){
			tds +='<td>';
			tds +='<input type="button" id="'+nuevaFila+'" name="eliminaDetalle" class="btnElimina" value="" onclick="eliminaDetalleReq(this)"/>';
			tds +='</td>';
		}
		
		tds += '</tr>';

		document.getElementById("numeroDetalle").value = nuevaFila;    	
		$("#miTabla").append(tds);
		
		agregaDatosNuevoDetalle( $('#tipoGastoID').val());
		
	}	

	function agregaDatosNuevoDetalle(varTipoGasto){
		var numeroFila = document.getElementById("numeroDetalle").value;
		var jqCentroCostoID = eval("'#centroCostoID" +numeroFila + "'");	
		var jqnoFactura = eval("'#noFactura" + numeroFila + "'");	
		var jqproveedorID = eval("'#proveedorID" + numeroFila + "'");	
		var jqdescProveedor = eval("'#descProveedor" + numeroFila + "'");	
		var jqtipoGastoID = eval("'#tipoGastoID" + numeroFila + "'");	
		var jq_descripcionTG = eval("'#descripcionTG" + numeroFila + "'");	
		var jq_observaciones = eval("'#observaciones" + numeroFila + "'");	
		var jq_partidaPreID = eval("'#partidaPreID" + numeroFila + "'");	
		var jq_totalDispon = eval("'#totalDisponible" + numeroFila + "'");	
		var jq_montoPre = eval("'#montoPre" + numeroFila + "'");	
		var jq_noPresupuestado = eval("'#noPresupuestado" + numeroFila + "'");	
		var jq_monAutorizado = eval("'#monAutorizado" + numeroFila + "'");	
					
		var nFactura = eval("'#noFactura'");	
		var proveedorID = eval("'#proveedorID'");	
		var descProveedor = eval("'#descProveedor'");	
		var tipoGastoID = eval("'#tipoGastoID'");	
		var descripcionTG = eval("'#descripcionTG'");	
		var observaciones = eval("'#observaciones'");	
		var partidaPre = eval("'#partidaPre'");
		var partidaPreID = eval("'#partidaPreID'");
		var montoDispon = eval("'#montoDispon'");	
		var montoPre = eval("'#montoPre'");	
		var noPresupuestado = eval("'#noPresupuestado'");	
		var monAutorizado = eval("'#monAutorizado'");		
		var montoAuto = eval("'#montoAuto'");	
		var disponible= $(montoDispon).asNumber();
		var jq_estatus = eval("'#status" + numeroFila + "'");
		var jq_estatusVi = eval("'#statusVista" + numeroFila + "'");
		
		$(jqCentroCostoID).val($('#centroCostoDet').val());
		$(jqproveedorID).val($(proveedorID).val());
		$(jqdescProveedor).val($(descProveedor).val());
		$(jqtipoGastoID).val($(tipoGastoID).val());
		$(jq_descripcionTG).val($(descripcionTG).val()); 
		$(jq_observaciones).val($(observaciones).val());	
		$(jq_totalDispon).val(disponible);
		$(jq_partidaPreID).val($(partidaPreID).val());
		$(jq_montoPre).val($(montoPre).val());
		$(jq_noPresupuestado).val($(noPresupuestado).val()); 	
		$(jq_monAutorizado).val("0");
		
		// se consulta el tipo de pago del proveedor
		consultaProveedorTipoPago($(proveedorID).val(), numeroFila); 
		
		// se consulta el presupuesto del gasto
		consultaPresupuestoDetalle( numeroFila);
				
		$(jq_estatus).val('P');
		$(jq_estatusVi).val("Pendiente");

		$('#centroCostoDet').val("");	
		$(noFactura).val("");	
		$(proveedorID).val("");	
		$(descProveedor).val("");	
		$(tipoGastoID).val("");	
		$(descripcionTG).val("");
		$(observaciones).val("");
		$(partidaPre).val("");
		$(partidaPreID).val("");
		$(montoPre).val("");
		$(montoAuto).val("");
		$(montoDispon).val("");
		$(noPresupuestado).val("");
		$(monAutorizado).val("0.00");
		agregaFormatoControles('formaGenerica');
		agregaTotales();//agrega inputs de totales
	}
	
	
	//agrega el detalle de la factura agregada
	function agregaDetalleFactura(numeroCiclos){
		
		$('#rTotalGasto').remove();
		for (var i = 0; i < numeroCiclos; i++){
			var numeroFila = document.getElementById("numeroDetalle").value;
			var nuevaFila = parseInt(numeroFila) + 1;		
			var permisosEscritura='readOnly="true"';
			var permisoAutorizacion ='readOnly="true"';
			var noPresupuestado = eval("'#noPresupuestado'");	
			var montoFueraPre = $(noPresupuestado).asNumber();

			if(parametroBean.perfilUsuario == parametroBean.rolTesoreria && montoFueraPre<=0){ //--
				permisoAutorizacion='';
			}
			if(parametroBean.perfilUsuario == parametroBean.rolAdminTeso){ //--
				permisoAutorizacion='';
			}

			var tds = '<tr id="renglon' + nuevaFila + '" name="renglon" >';
				tds +='<td><input type="text" id="consecutivo'+nuevaFila+'"	name="numero" path="numero" size="2" autocomplete="off" value="'+nuevaFila+'" disabled="true" />';
				tds +='<input type="hidden" id="detReqGasID'+nuevaFila+'" name="ldetReqGasID" path="ldetReqGasID"  value="0"  /></td>';
				tds +='<td><input type="text" name="lcentroCostoID"	id="centroCostoID'+nuevaFila+'" path="centroCostoID" size="9" autocomplete="off"  readOnly="true" /></td>';
				
				tds +='<td><input type="text" name="lnoFactura"	id="noFactura'+nuevaFila+'" path="noFactura" size="9" autocomplete="off" readOnly="true" />';
				tds +='</td>';
				tds +='<td><input type="text" name="ltipoGastoID"	id="tipoGastoID'+nuevaFila+'" path="tipoGastoID" size="3" autocomplete="off"  readOnly="true" />';
				tds +='</td><td>';
				tds +='<input type="text" name="descripcionTG" id="descripcionTG'+nuevaFila+'" path="descripcionTG" size="25"	autocomplete="off"  disabled="true"/>';						  
				tds +='</td>';
				tds +='<td><input type="text" name="lproveedor"	id="proveedorID'+nuevaFila+'" path="proveedorID" size="3" autocomplete="off"  readOnly="true" />';
				tds +='</td><td>';
				tds +='<input type="text" name="descProveedor" id="descProveedor'+nuevaFila+'"  size="25"	autocomplete="off"  disabled="true"/>';						  
				tds +='</td>';
				
				tds +='<td> <textarea rows="2" cols="20"  name="lobservaciones" id="observaciones'+nuevaFila+'"  '+permisosEscritura+' maxlength= "50" onBlur=" ponerMayusculas(this)" /></td>';
		
				tds +='<td>';
				tds +='<input type="text" name="lpartidaPre" id="partidaPre'+nuevaFila+'" style="text-align:right;" esMoneda="true" path="partidaPre" size="10"	autocomplete="off"  readOnly="true"  />';
				tds +='<input type="hidden" name="lpartidaPreID" id="partidaPreID'+nuevaFila+'"  size="13"	 />';			
				tds +='<input type="hidden" name="totalDisponible"	id="totalDisponible'+nuevaFila+'" esMoneda="true" path="totalDisponible"  />';	
				tds +='</td> ';
				tds +='<td>';
				tds +='<input type="text" name="lmontoPre"	id="montoPre'+nuevaFila+'" style="text-align:right;" esMoneda="true" path="montoPre" size="13" autocomplete="off"  '+permisosEscritura+'  onkeyPress="return Validador(event);"/>';
				tds +='</td> ';
				tds +='<td>';
				tds +='<input type="text" name="lnoPresupuestado"	id="noPresupuestado'+nuevaFila+'"  style="text-align:right;" esMoneda="true" path="noPresupuestado" size="13"	autocomplete="off" readOnly="true"  />';
				tds +='</td>';
				tds +='<td>';
				if(parametroBean.perfilUsuario == parametroBean.rolTesoreria || parametroBean.perfilUsuario == parametroBean.rolAdminTeso){ //--
					tds +='<input type="text" name="lmonAutorizado"id="monAutorizado'+nuevaFila+'" style="text-align:right;" esMoneda="true" path="monAutorizado" size="13"	autocomplete="off" '+permisoAutorizacion+' onBlur="editarAutorizado(\''+nuevaFila+'\') " onkeyPress="return Validador(event);"/>';
				}else{
					tds +='<input type="text" name="lmonAutorizado"id="monAutorizado'+nuevaFila+'" style="text-align:right;" esMoneda="true" path="monAutorizado" size="13"	autocomplete="off" '+permisoAutorizacion+' />';
				}
				tds +='</td>';
				
				tds +='<td>';
				tds +='<select id="tipoDeposito'+nuevaFila+'" name="ltipoDeposito" path="tipoDeposito" tabindex="11" onchange="validaTipoDesembolso('+nuevaFila+');">';
				tds +='<option value="C">Cheque</option>';
				tds +='<option value="S">Spei</option>';
				tds +='<option value="B">Banca Electrónica</option>';
				tds +='<option value="T">Tarjeta Empresarial</option>';
				tds +='</select>';
				tds +='</td> ';
								
				tds +='<td>';
				if(permisoAutorizacion == ''){
					tds +='';
					tds +='<select  name="lstatus" id="status'+nuevaFila+'"  onchange="validaAprobacion('+nuevaFila+');" path="status">';
					tds +='<option value="P">Pendiente</option>';
					tds +='<option value="A">Aprobado</option>';
					tds +='<option value="C">Cancelado</option>';
					tds +='</select>';
				} 
				if(permisoAutorizacion != ''){
					tds +='<input type="text" name="status" id="statusVista'+nuevaFila+'" path="status" size="11"	autocomplete="off" readOnly="true"  />';
					tds +='<input type="hidden" name="lstatus" id="status'+nuevaFila+'" path="status" size="11"	autocomplete="off" readOnly="true"  />';
				}         
				tds +='</td> ';
				
				if(permisoAutorizacion != ''){
					tds +='<td>';
					tds +='<input type="button" id="'+nuevaFila+'" name="eliminaDetalleFac" class="btnElimina" value="" onclick="eliminaDetalleReq(this)"/>';
					tds +='</td>';
				}
				
				tds += '</tr>';
			document.getElementById("numeroDetalle").value = nuevaFila;    	
			$("#miTabla").append(tds);				
		}	
		agregaTotales();//agrega inputs de totales
	}	

	// agrega el detalle de la factura agregada
	function agregaDatosNuevoDetalleFactura(idNumFactura, idProveedor){
		
		// si la factura existe
		if (existeFacturaProveedor== "0"){
			var montoDispon = eval("'#montoDispon'");	
			var noPresupuestado = eval("'#noPresupuestado'");	
			var estatus = eval("'#status'");
			
			var valorNoFactura =$('#noFactura').val();
			var valorProveedorID=$('#proveedorIDFact').val();
			var valorDesProveedor=$('#descProveedorFact').val();
			//var varcentroCostosFac=$('#centroCostoFact').val();
			
			var numeroFilaAnterior = $('#numeroDetalle').asNumber();
			var jqIdNumFactura	= eval("'#" + idNumFactura + "'");	
			var jqIdProveedor 	= eval("'#" + idProveedor + "'");	
			
			var facturaBeanDetFac = {
					'noFactura'	 :$(jqIdNumFactura).val(),
					'proveedorID':$(jqIdProveedor).val()
			};
			var listaDetalleFactura = 2;
				
			detfacturaProvServicio.listaDetalleFacturaProv(listaDetalleFactura, facturaBeanDetFac,function(detalleFactura) {
				if(detalleFactura!=null){
					agregaDetalleFactura(detalleFactura.length); 
					for (var i = 0; i < detalleFactura.length; i++){
						
						numeroFilaAnterior = numeroFilaAnterior+1;
						var jqCentroCostos = eval("'#centroCostoID" + numeroFilaAnterior + "'");		
						var jqtipoGastoID = eval("'#tipoGastoID" + numeroFilaAnterior + "'");	
						var jqtipoGasto ="tipoGastoID" + numeroFilaAnterior;	
						var jq_observaciones = eval("'#observaciones" + numeroFilaAnterior + "'");	
						var jqnoFactura = eval("'#noFactura" + numeroFilaAnterior + "'");	
						var jqproveedorID = eval("'#proveedorID" + numeroFilaAnterior + "'");
						var jqdescProveedor = eval("'#descProveedor" + numeroFilaAnterior + "'");
						
						var jq_descripcionTG = eval("'#descripcionTG" + numeroFilaAnterior + "'");	
						var jq_partidaPre = eval("'#partidaPre" + numeroFilaAnterior + "'");
						var jq_partidaPreID = eval("'#partidaPreID" + numeroFilaAnterior + "'");	
						var jq_totalDispon = eval("'#totalDisponible" + numeroFilaAnterior + "'");	
						var jq_montoPre = eval("'#montoPre" + numeroFilaAnterior + "'");	
						var jq_monAutorizado = eval("'#monAutorizado" + numeroFilaAnterior + "'");	
						var jq_estatusVi = eval("'#statusVista" + numeroFilaAnterior + "'");
						var jq_estatus = eval("'#status" + numeroFilaAnterior + "'");	
						
						var disponible= $(montoDispon).asNumber();

						var solicitado = $(montoPre).asNumber();
						var autorizado = solicitado; 
						var nuevoDisponible = disponible - solicitado;

						if(nuevoDisponible<=0){
							nuevoDisponible=0.00;
							autorizado = disponible;
						}
						
						
						
						$(jqtipoGastoID).val(detalleFactura[i].tipoGastoID);
						$(jq_observaciones).val(detalleFactura[i].descripcion);
						$(jq_montoPre).val(detalleFactura[i].importe);
						
						$(jqnoFactura).val(valorNoFactura);	
						$(jqproveedorID).val(valorProveedorID);
						$(jqdescProveedor).val(valorDesProveedor);				
						$(jq_descripcionTG).val(detalleFactura[i].descripcionGT);
						
						var jq_tipoDepositoC = eval("'#tipoDeposito" + numeroFilaAnterior + " option[value=C]'");
						var jq_tipoDepositoS = eval("'#tipoDeposito" + numeroFilaAnterior + " option[value=S]'");
						var jq_tipoDepositoT = eval("'#tipoDeposito" + numeroFilaAnterior + " option[value=T]'");
						var jq_tipoDepositoB = eval("'#tipoDeposito" + numeroFilaAnterior + " option[value=B]'");
						
						if(detalleFactura[i].tipoPago=="C"){						
							$(jq_tipoDepositoC).attr("selected",true);
						}	
						if(detalleFactura[i].tipoPago=="S"){
							$(jq_tipoDepositoS).attr("selected",true);
						}
						if(detalleFactura[i].tipoPago=="T"){
							$(jq_tipoDepositoT).attr("selected",true);
						}
						if(detalleFactura[i].tipoPago=="B"){
							$(jq_tipoDepositoB).attr("selected",true);
						}
						
						
						$(jq_totalDispon).val(disponible);
						$(jq_partidaPre).val(nuevoDisponible);
						$(jq_partidaPreID).val($(partidaPreID).val());
						$(jq_monAutorizado).val(autorizado); 
						$(jqCentroCostos).val(detalleFactura[i].centroCostoID);
						// se consulta el presupuesto por tipo de gasto
						
						consultaPresupuestoDetallePorFactura(detalleFactura[i].tipoGastoID,detalleFactura[i].importe,numeroFilaAnterior);
						
						var montoNopres =$(noPresupuestado).asNumber();
						
						if(parametroBean.perfilUsuario == parametroBean.rolTesoreria && montoNopres <= 0.00){ //--
							if($(estatus).val()=='A')	{
								$(jq_estatusVi).val("Aprobado");		
							}
							if($(estatus).val()=='P')	{
								$(jq_estatusVi).val("Pendiente");		
							}
							if($(estatus).val()=='C')	{
								$(jq_estatusVi).val("Cancelado");		
							}
						}
						else {
							$(estatus).val('P');
							$(jq_estatusVi).val("Pendiente");
						}
					
						$(jq_estatus).val($(estatus).val());
					//	$('#centroCostoFact').val("");
						$('#noFactura').val("");	
						$('#proveedorIDFact').val("");	
						$('#descProveedorFact').val("");	
						$('#totalFactura').val("");
						$('#saldoFactura').val("");
						$(montoDispon).val("");
						$(noPresupuestado).val("");
			
						agregaFormatoControles('formaGenerica');
					}				
				}
			});
		}	
		agregaFormatoControles('formaGenerica');
	}
	
	function agregaTotalesPre(){  //.lmkmdksjd lll
		var totalFilas = document.getElementById("numeroDetalle").value; 
		var totalMontoPre=0.00,totalNoPre=0.00,totalMonAut=0.00;
		for (var numeroFila = 1; numeroFila <= totalFilas; numeroFila++ ) {
			var jq_montoPre = eval("'#montoPre" + numeroFila + "'");	           //monto presupuestado
			var jq_noPresupuestado = eval("'#noPresupuestado" + numeroFila + "'"); //monto fuera de Presupusto	
			var jq_monAutorizado = eval("'#monAutorizado" + numeroFila + "'");		//monto Autorizado
			totalMontoPre 	= totalMontoPre+ $(jq_montoPre).asNumber();             //presupuestado+monto fuera de Presupuesto
			totalNoPre 		= totalNoPre + $(jq_noPresupuestado).asNumber();		//
			totalMonAut 	= totalMonAut+$(jq_monAutorizado).asNumber();
			
			
			//$(jq_monAutorizado).val($(jq_montoPre).asNumber());									//se autoriza por default el monto solicitado
		
			$('#totMontoPre').val(totalMontoPre);
			$('#totNoPresupuestado').val(totalNoPre);
			$('#totMonAutorizado').val(totalMonAut);
			agregaFormatoControles('formaGenerica');
		}
	}	
	
	function agregaTotales(){ 
		var tds = '<tr id="rTotalGasto" name="col" >';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td align="right"><label>TOTAL GASTO:</label></td>';
		tds +='<td></td>';
		tds +='<td>';
		tds +='<input type="text"	id="totMontoPre" style="text-align:right;"  esMoneda="true" path="montoPre" size="13"autocomplete="off" disabled="true"  />';
		tds +='</td> ';
		tds +='<td>';
		tds +='<input type="text" id="totNoPresupuestado" style="text-align:right;"  esMoneda="true" path="noPresupuestado" size="13"	autocomplete="off" disabled="true"  />';
		tds +='</td>';
		tds +='<td>';
		tds +='<input type="text" id="totMonAutorizado" style="text-align:right;"  esMoneda="true" path="monAutorizado" size="13"	autocomplete="off" disabled="true"  />';
		tds +='</td>';
		tds +='<td></td>';
		tds += '</tr>';
		$("#miTabla").append(tds);
		
		agregaTotalesPre();
	}		
	
	
	function removerDisabledEnSolicitado(){
		var totalFilas = document.getElementById("numeroDetalle").value; 
		var jq_solicitado;
		var jq_status;
		for (var numeroFila = 1; numeroFila <= totalFilas; numeroFila++ ) {
			jq_solicitado = eval("'#montoPre" + numeroFila + "'");
			jq_observaciones = eval("'#observaciones" + numeroFila + "'");
			jq_status = eval("'#status" + numeroFila + "'");
			if($(jq_status).val()=='P')
			{
				$(jq_solicitado).removeAttr('readOnly');
				$(jq_observaciones).removeAttr('readOnly');
			}
			if($(jq_status).val()!='P')
			{
				$(jq_solicitado).removeAttr('onBlur');
				$(jq_solicitado).removeAttr('onkeyPress');
			}
		}
		//return retorno;
	}

	function removerJavaScrSolicitado(){
		var totalFilas = document.getElementById("numeroDetalle").value; 
		var jq_solicitado;
		var jq_status;
		for (var numeroFila = 1; numeroFila <= totalFilas; numeroFila++ ) {
			jq_solicitado = eval("'#montoPre" + numeroFila + "'");
			jq_status = eval("'#status" + numeroFila + "'");

			if($(jq_status).val()=='P'){
				$(jq_solicitado).removeAttr('onBlur');
				$(jq_solicitado).removeAttr('onkeyPress');
			}
		}
		//return retorno;
	}

	// valida si en los detalles ya se encuentra agregado un mismo tipo de gasto
	function existeTipoGasto(idTipoGasto){
		var totalFilas = document.getElementById("numeroDetalle").value; 
		var jq_partidaPreID;
		var jq_numeroFactura;
		var retorno = false;
		var existeIgual ="";
		for (var numeroFila = 1; numeroFila <= totalFilas; numeroFila++ ) {
			jq_partidaPreID = eval("'#tipoGastoID" + numeroFila + "'");
			jq_numeroFactura = eval("'#noFactura" + numeroFila + "'");

			if($(jq_partidaPreID).val()!=""){
				if($(jq_partidaPreID).val()==idTipoGasto)
				{
					if($(jq_numeroFactura).val()==""||$(jq_numeroFactura).val() == "0" ){
						existeIgual = "S";
						retorno= true;
					}					
				}
			}
			if(numeroFila==totalFilas && existeIgual == "S"){
				mensajeSis("Ya existe una requisición de gastos para el concepto: "+ idTipoGasto);
				$('#tipoGastoID').focus();
				$('#tipoGastoID').select();
				$('#tipoGastoID').val("");
			}
		}
		return retorno;
	}

	

	function existenAprobados(aprobado){
		var totalFilas = document.getElementById("numeroDetalle").value; 
		var jq_status;
		var retorno = false;
		for (var numeroFila = 1; numeroFila <= totalFilas; numeroFila++ ) {
			jq_status = eval("'#status" + numeroFila + "'");
			if($(jq_status).val()==aprobado)
			{
				retorno= true;
			}
		}
		return retorno;
	}

	function pegaHtml(tipoConsulta, divReceptor, varEstatusReq){  
		var NumReqGasID = $('#numReqGasID').val();
		if(!isNaN(NumReqGasID)){
			var params = {};
			params['numReqGasID'] = NumReqGasID;
			params['tipoConsulta'] =  tipoConsulta;
			params['rolUsuario'] =  parametroBean.perfilUsuario;
			params['rolTesoreria'] =  parametroBean.rolTesoreria;//-- Enviando rolTesoreri paraque la lea el controlador
			params['rolTesoreriaAdmin'] =  parametroBean.rolAdminTeso;//-- Enviando rolAdminTeso paraque la lea el controlador
			var jqDiv = eval("'#" + divReceptor + "'");
			$.post("reqGastosSucursalGrid.htm", params, function(data){
				if(data.length > 0 && NumReqGasID != ''){
					$(jqDiv).html(data); 
					
					$('#numeroDetalle').val($('#numeroGrids').val());
					agregarDatosGrid();//agrega descripciones de tipos de gasto y centro de costo
					consultaProveedorRequisicion(); // consulta el nombre o razon social del proveedor
					agregaTotales();//agrega inputs de totales
				
					agregaFormatoControles('formaGenerica');
					$('#contenedorDtlle').show();
					if(parametroBean.numeroUsuario==$('#usuarioID').val()){
						removerDisabledEnSolicitado();
					}
					else{
						removerJavaScrSolicitado();
					}	
					if(parametroBean.perfilUsuario == parametroBean.rolTesoreria ){ //--
						if($('#numeroDetalle').asNumber() ==0){
							deshabilitaBoton('modificar', 'submit');//--
							mensajeSis('La requisición está fuera de presupuesto');//--	

						}
					}
					
				}else{
					mensajeSis('No se han encontrado movimientos con los datos proporcionados');
					$('#numReqGasID').val("");
				}
			}); 
		}
	}

	function agregarDatosGrid(){	
		var filas = $('#numeroDetalle').val();
		for (var i= 1; i<=filas; i++){
			var jqTipoGasto = eval("'tipoGastoID" + i + "'");
			var descripcionTG = eval("'#descripcionTG"+i+"'");
			consultaTipoGastoGrid(jqTipoGasto,descripcionTG);	
		}
	}	

	function agregaDisabledDesembolso(){	
		var filas = $('#numeroDetalle').val();
		for (var i= 1; i<=filas; i++){

		}
	}

	function agregaDisabled (idControl){
		$(idControl).css({'background-color' : '#E6E6E6',"color":"#6E6E6E"});
		$(idControl).css({'background-color' : '#E6E6E6', "color":"#6E6E6E"});      	
	}
	
	function consultaMetodoProrrateo(jqcontrol){
		deshabilitaBoton('aplicaProrrateo');
		var evalControl=eval("'#"+jqcontrol.id+"'");		
		var valorControl=$(evalControl).val();		
		var tipoLista=1;
		var estatusActiva='A', estatusInactiva='I';
		prorrateoBean={
				'prorrateoID' : valorControl
		};
		prorrateoContableServicio.consulta(tipoLista,prorrateoBean,function(prorrateo){
				if(prorrateo!=null){
					dwr.util.setValues(prorrateo);
					if(prorrateo.estatus==estatusActiva){
						var params={};
						params['tipoConsulta']=3;
						params['prorrateoID']=valorControl;
						consultaGridProrrateo(params);
					}else if(prorrateo.estatus==estatusInactiva){
						mensajeSis('La Caja se Encuentra Inactiva');
						$('#prorrateoID').focus();
						limpiarCamposGrid();
					}		
				}else{
					mensajeSis("El Método de Prorrateo no Existe");
					$('#prorrateoID').focus();
					$('#prorrateoID').val('');
					limpiarCamposGrid();
				}
		});
	}
	
	function limpiarCamposGrid(){
		$('#prorrateoID').val('');
		$('#nombreProrrateo').val('');
		$('#descripcion').val('');											
		deshabilitaBoton('aplicaProrrateo');
		$('#gridProrrateoContable').hide(500);
	}
	
	function consultaGridProrrateo(params){
		$('#gridProrrateoContable').hide();				
		$.post("prorrateoConsultaGrid.htm", params,function(data){
			if (data.length > 0){
				$('#gridProrrateoContable').html(data);
				$('#gridProrrateoContable').show(500);
				habilitaBoton('aplicaProrrateo');
			}
		});
	}
	
	$('#aplicaProrrateo').click(function(){
		var confirmar=confirm('Confirmar Aplicación de Prorrateo');
		if(confirmar){
			var nuevaFila=0;
			var factProrrateada='';						
			$('input[name=numero]').each(function(){
				
				var IDR = this.id.substring(11);
				
				var jqConse = eval("'#"+this.id+"'");
					
				var jqCenCosto = eval("'#centroCostoID"+IDR+"'");				
				var jqNoFactura	= eval("'#noFactura"+IDR+"'");
				var jqTipoGasto	=	eval("'#tipoGastoID"+IDR+"'");
				var jqDescripcionTG	= eval("'#descripcionTG"+IDR+"'");
				var jqProveedorID = eval("'#proveedorID"+IDR+"'");
				var jqDescProveedor	=	eval("'#descProveedor"+IDR+"'");
				var jqObservaciones	= eval("'#observaciones"+IDR+"'");
				var jqPartidaPre	= eval("'#partidaPre"+IDR+"'");
				var jqMontoPre		= eval("'#montoPre"+IDR+"'");
				var jqNoPresup		= eval("'#noPresupuestado"+IDR+"'");
				var jqMonAutori		= eval("'#monAutorizado"+IDR+"'");
				var jqTipoDeposito	= eval("'#tipoDeposito"+IDR+"'");
				var jqEstatusVista	= eval("'#statusVista"+IDR+"'");
				
				var valConse = $(jqConse).val();
				var valCenCosto = $(jqCenCosto).val();
				var valNoFactura = $(jqNoFactura).val();
				var valTipoGasto = $(jqTipoGasto).val();
				var valDescripcionTG = $(jqDescripcionTG).val();
				var valProveedorID = $(jqProveedorID).val();
				var valDescProveedor = $(jqDescProveedor).val();
				var valObservaciones = $(jqObservaciones).val();
				var valPartidaPre = $(jqPartidaPre).val();
				var valMontoPre = $(jqMontoPre).asNumber();
				var valNoPresup = $(jqNoPresup).asNumber();
				var valMonAutori = $(jqMonAutori).val();
				var valTipoDeposito = $(jqTipoDeposito).val();
				var valEstatusVista = $(jqEstatusVista).val();
				
				var permisosEscritura='readOnly="true"';
				var permisoAutorizacion ='readOnly="true"';
				var noPresupuestado = eval("'#noPresupuestado'");	
				var montoFueraPre = $(noPresupuestado).asNumber();
				var charEstatus	='';				
				if(parametroBean.perfilUsuario == parametroBean.rolTesoreria && montoFueraPre<=0){ //--
					permisoAutorizacion='';
				}
				if(parametroBean.perfilUsuario == parametroBean.rolAdminTeso){ //--
					permisoAutorizacion='';
				}
				
				if(valEstatusVista=='Pendiente'){
					charEstatus='P';
				}else if(valEstatusVista=='Aprobado'){
					charEstatus='A';
				}else if(valEstatusVista=='Cancelado'){
					charEstatus='C';
				}
				
				$('input[name=cenCostoID]').each(function(){
					
					var IDP = this.id.substring(10);
					
					var jqCentroCosto	= eval("'#"+this.id+"'");
					var jqPorcentaje	= eval("'#porcentajePro"+IDP+"'");
					
					valCentroCosto		= $(jqCentroCosto).asNumber();
					valPorcentaje		= $(jqPorcentaje).asNumber();
					
					var totalProrrateado= ((valMontoPre*valPorcentaje)/100);
					var totalNoPresup= ((valNoPresup*valPorcentaje)/100);
					
					
					
					nuevaFila++;
					factProrrateada += '<tr id="renglon' + nuevaFila + '" name="renglon" >';
					factProrrateada +='<td><input type="text" id="consecutivo'+nuevaFila+'"	name="numero" path="numero" size="2" autocomplete="off" value="'+nuevaFila+'" disabled="true" />';
					factProrrateada +='<input type="hidden" id="detReqGasID'+nuevaFila+'" name="ldetReqGasID" path="ldetReqGasID"  value="0"  /></td>';
					factProrrateada +='<td><input type="text" name="lcentroCostoID"	id="centroCostoID'+nuevaFila+'" path="centroCostoID" size="9" autocomplete="off"  readOnly="true" value="'+valCentroCosto+'" /></td>';
					
					factProrrateada +='<td><input type="text" name="lnoFactura"	id="noFactura'+nuevaFila+'" path="noFactura" size="9" autocomplete="off" readOnly="true" value="'+valNoFactura+'"/>';
					factProrrateada +='</td>';
					factProrrateada +='<td><input type="text" name="ltipoGastoID"	id="tipoGastoID'+nuevaFila+'" path="tipoGastoID" size="3" autocomplete="off"  readOnly="true" value="'+valTipoGasto+'"/>';
					factProrrateada +='</td><td>';
					factProrrateada +='<input type="text" name="descripcionTG" id="descripcionTG'+nuevaFila+'" path="descripcionTG" size="25"	autocomplete="off"  disabled="true" value="'+valDescripcionTG+'"/>';						  
					factProrrateada +='</td>';
					factProrrateada +='<td><input type="text" name="lproveedor"	id="proveedorID'+nuevaFila+'" path="proveedorID" size="3" autocomplete="off"  readOnly="true" value="'+valProveedorID+'"/>';
					factProrrateada +='</td><td>';
					factProrrateada +='<input type="text" name="descProveedor" id="descProveedor'+nuevaFila+'"  size="25"	autocomplete="off"  disabled="true" value="'+valDescProveedor+'"/>';						  
					factProrrateada +='</td>';
					
					factProrrateada +='<td> <textarea rows="2" cols="20"  name="lobservaciones" id="observaciones'+nuevaFila+'"  '+permisosEscritura+' maxlength= "50" onBlur=" ponerMayusculas(this)">'+valObservaciones+'</textarea></td>';
			
					factProrrateada +='<td>';
					factProrrateada +='<input type="text" name="lpartidaPre" id="partidaPre'+nuevaFila+'" style="text-align:right;" esMoneda="true" path="partidaPre" size="10"	autocomplete="off"  readOnly="true"  value="'+valPartidaPre+'"/>';
					factProrrateada +='<input type="hidden" name="lpartidaPreID" id="partidaPreID'+nuevaFila+'"  size="13"	 />';			
					factProrrateada +='<input type="hidden" name="totalDisponible"	id="totalDisponible'+nuevaFila+'" esMoneda="true" path="totalDisponible"  />';	
					factProrrateada +='</td> ';
					factProrrateada +='<td>';
					factProrrateada +='<input type="text" name="lmontoPre"	id="montoPre'+nuevaFila+'" style="text-align:right;" esMoneda="true" path="montoPre" size="13" autocomplete="off"  '+permisosEscritura+'  onkeyPress="return Validador(event);" value="'+totalProrrateado+'"/>';
					factProrrateada +='</td> ';
					factProrrateada +='<td>';
					factProrrateada +='<input type="text" name="lnoPresupuestado"	id="noPresupuestado'+nuevaFila+'"  style="text-align:right;" esMoneda="true" path="noPresupuestado" size="13"	autocomplete="off" readOnly="true" value="'+totalNoPresup+'" />';
					factProrrateada +='</td>';
					factProrrateada +='<td>';
					if(parametroBean.perfilUsuario == parametroBean.rolTesoreria || parametroBean.perfilUsuario == parametroBean.rolAdminTeso){ //--
						factProrrateada +='<input type="text" name="lmonAutorizado"id="monAutorizado'+nuevaFila+'" style="text-align:right;" esMoneda="true" path="monAutorizado" size="13"	autocomplete="off" '+permisoAutorizacion+' onBlur="editarAutorizado(\''+nuevaFila+'\') " onkeyPress="return Validador(event);" value="'+valMonAutori+'"/>';
					}else{
						factProrrateada +='<input type="text" name="lmonAutorizado"id="monAutorizado'+nuevaFila+'" style="text-align:right;" esMoneda="true" path="monAutorizado" size="13"	autocomplete="off" '+permisoAutorizacion+' value="'+valMonAutori+'"/>';
					}
					factProrrateada +='</td>';
					
					factProrrateada +='<td>';
					factProrrateada +='<select id="tipoDeposito'+nuevaFila+'" name="ltipoDeposito" path="tipoDeposito" tabindex="11" onchange="validaTipoDesembolso('+nuevaFila+');" >';					
					if(valTipoDeposito=='C'){
						factProrrateada +='<option value="C" selected>Cheque</option>';
						factProrrateada +='<option value="S">Spei</option>';
						factProrrateada +='<option value="B">Banca Electrónica</option>';
						factProrrateada +='<option value="T">Tarjeta Empresarial</option>';
					}else if(valTipoDeposito=='S'){
						factProrrateada +='<option value="C">Cheque</option>';
						factProrrateada +='<option value="S" selected>Spei</option>';
						factProrrateada +='<option value="B">Banca Electrónica</option>';
						factProrrateada +='<option value="T">Tarjeta Empresarial</option>';
					}else if(valTipoDeposito=='B'){
						factProrrateada +='<option value="C">Cheque</option>';
						factProrrateada +='<option value="S">Spei</option>';
						factProrrateada +='<option value="B" selected>Banca Electrónica</option>';
						factProrrateada +='<option value="T">Tarjeta Empresarial</option>';
					}else if(valTipoDeposito=='T'){
						factProrrateada +='<option value="C">Cheque</option>';
						factProrrateada +='<option value="S">Spei</option>';
						factProrrateada +='<option value="B">Banca Electrónica</option>';
						factProrrateada +='<option value="T" selected>Tarjeta Empresarial</option>';
					}					
					factProrrateada +='</select>';
					factProrrateada +='</td> ';					
					
					
					
					factProrrateada +='<td>';
					if(permisoAutorizacion == ''){
						factProrrateada +='';
						factProrrateada +='<select  name="lstatus" id="status'+nuevaFila+'"  onchange="validaAprobacion('+nuevaFila+');" path="status" value="'+charEstatus+'">';
						factProrrateada +='<option value="P">Pendiente</option>';
						factProrrateada +='<option value="A">Aprobado</option>';
						factProrrateada +='<option value="C">Cancelado</option>';
						factProrrateada +='</select>';
					} 
					if(permisoAutorizacion != ''){
						factProrrateada +='<input type="text" name="status"id="statusVista'+nuevaFila+'" path="status" size="11"	autocomplete="off" readOnly="true" value="'+valEstatusVista+'" />';
						factProrrateada +='<input type="hidden" name="lstatus" id="status'+nuevaFila+'" path="status" size="11"	autocomplete="off" readOnly="true"  value="'+charEstatus+'"/>';
					}         
					factProrrateada +='</td> ';
					
					if(permisoAutorizacion != ''){
						factProrrateada +='<td>';
						factProrrateada +='<input type="button" id="'+nuevaFila+'" name="eliminaDetalle" class="btnElimina" value="" onclick="eliminaDetalleReq(this)"/>';
						factProrrateada +='</td>';
					}					
					factProrrateada += '</tr>';								
				});
				var jqRenglon= eval("'#renglon"+IDR+"'");			
				$(jqRenglon).remove();
				
			});
			$('#rTotalGasto').remove();
			$('#numeroDetalle').val(nuevaFila);
			$("#miTabla").append(factProrrateada);
			agregaTotales();
			$('#prorrateoContable').hide();
			$('#prorrateoHecho').val('S');
			$('aplicaPro').hide();
		}						
	});
	
	
});

//////////////////////////// FIN DE JQUERY ////////////////////////////////////////


function limpiaTablaDetalles(){
	var tds = '<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">';
	tds += '<tr><td></td>';
	tds += '<td><label>C. Costos</label></td>';
	tds += '<td><label>No. Factura</label></td>';
	tds += '<td colspan="2"><label>Tipo Gasto</label></td>';
	tds += '<td colspan="2"><label>Proveedor</label></td>';
	tds += '<td><label>Concepto/Observaciones</label></td>';
	tds += '<td><label>Monto<br>Disponible</label></td>';
	tds += '<td><label>Monto<br>Solicitado</label></td>';
	tds += '<td><label>Monto fuera<br>de Presupuesto</label></td>';
	tds += '<td><label>Monto<br>Autorizado</label></td>';
	tds += '<td><label>Tipo<br>Desembolso</label></td>';
	tds += '<td><label>Estatus</label></td>';
	tds += '</tr><tr id="rTotalGasto" name="col" ></tr>'; 
	tds += '</table>';

	$('#miTabla').replaceWith(tds);
	$('#contenedorDtlle').hide();
	$('#numeroDetalle').val('0');
	$('#estatus option[value=A]').attr('selected','true');           
}


//consulta el presupuesto a partir de los conceptos de la factura
function consultaPresupuestoFactura(concepto, fila,importe, filaSig, filaCiclo){
	var fecha = $('#fechRequisicion').val();
	var sucursalID = $('#sucursalID').val();
	importe = parseFloat(importe);
	var jqPartidaPreID = eval("'#partidaPreID" + fila + "'");
	var jqMontoDisponible = eval("'#partidaPre" + fila + "'");	
	var jqMontoAutorizado = eval("'#monAutorizado" + fila + "'");	
	var jqMontoFueraPre = eval("'#noPresupuestado" + fila + "'");	
	var jqMontoFueraPreSig = eval("'#noPresupuestado" + filaSig + "'");
	var jqMontoDisponibleSig = eval("'#partidaPre" + filaSig + "'");	
	var jqMontoFueraPreAct = eval("'#noPresupuestado" + filaCiclo + "'");	
	
	var PreSucursalBean = {
			'folio': 1,//no importante en consulta foranea
			'conceptoPet':concepto,
			'sucursal': sucursalID,
			'fecha':fecha
	};
	presupSucursalServicio.consulta(2, PreSucursalBean,function(preBean){
		if(preBean!=null){
			if(preBean.montoDispon!=0){
					$(jqPartidaPreID).val(preBean.folio);
					$(jqMontoAutorizado).val("0.00");
					$(jqMontoDisponible).val(preBean.montoDispon);
					if(parseFloat(importe) > parseFloat(preBean.montoDispon)){
						//$(jqMontoFueraPre).val(parseFloat(importe) - parseFloat(preBean.montoDispon));
						$(jqMontoFueraPreSig).val(importe); 
						}else
						{
						$(jqMontoFueraPre).val("0.00");
						$(jqMontoFueraPreSig).val("0.00");
	
					}
				
				disponiblePorPresupuesto(concepto,preBean.montoDispon );
				
				$(jqMontoAutorizado).formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
				$(jqMontoDisponible).formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
				$(jqMontoFueraPre).formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
			}else{
				$(jqMontoDisponible).val("0.00");
				$(jqMontoDisponibleSig).val("0.00");;
				$(jqMontoFueraPreAct).val(importe);

				$(jqMontoAutorizado).formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
				$(jqMontoDisponible).formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
				$(jqMontoFueraPre).formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
			}
		}else{
			$(jqMontoFueraPreAct).val(importe);
			$(jqMontoDisponible).val("0.00");
			$(jqMontoDisponibleSig).val("0.00");
			$(jqMontoAutorizado).formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
			$(jqMontoDisponible).formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
			$(jqMontoFueraPre).formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
		}
		ActualizaTotalesPre(); 
	});
}

//funcion que hace un ciclo para hacer la resta al disponible por presupuesto
function disponiblePorPresupuesto(varTipoGasto, disponible){
	var elementos = document.getElementsByName("renglon"); 
	var solicitado =0;
	for (var numero = 1; numero <= elementos.length; numero++ ) {  
		var jqPartidaPreID = eval("'#partidaPre" + numero+ "'");
		var jqTipoGastoID = eval("'#tipoGastoID" + numero + "'");
		var jqMontoPre = eval("'#montoPre" + numero + "'");
		var jqMontoFuePre = eval("'#noPresupuestado" + numero + "'");
		
		if(varTipoGasto == $(jqTipoGastoID).val()){  
			solicitado = $(jqMontoPre).asNumber();
			if(parseFloat(disponible)>0){
				$(jqPartidaPreID).val(disponible);
				if(disponible>solicitado){ 
					$(jqMontoFuePre).val("0.0");
				}else{
					if(disponible==solicitado){
						$(jqMontoFuePre).val("0.0");
					}else{
						if(solicitado>disponible){
							$(jqMontoFuePre).val(solicitado-disponible);
						}
					}
				}	
				disponible = disponible - solicitado;			
			}			
			else{
				$(jqPartidaPreID).val("0.00");
				$(jqMontoFuePre).val(solicitado);
			}
			
		}
	}
	
	agregaFormatoControles('formaGenerica');
}

function Validador(e) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46 || key == 0) {
		if (key==8|| key == 46 ||  key == 0)	{ 
			return true;
		}
		else
			mensajeSis("Sólo se pueden ingresar números");
		return false;
	}
}	

function editarAutorizado(fila){
	var jq_partidaPre = eval("'#partidaPre" + fila + "'");	//disponible
	var jq_montoPre = eval("'#montoPre" + fila + "'");	//solicitado
	var jq_noPresupuestado = eval("'#noPresupuestado" + fila + "'");	//fuer de presspto
	var jq_totalDispon = eval("'#totalDisponible" + fila + "'");	
	var jq_monAutorizado = eval("'#monAutorizado" + fila + "'");	
	var jq_factura = eval("'#noFactura" + fila + "'");	
	var jq_provee = eval("'#proveedorID" + fila + "'");	
	var jq_estatus =	eval("'#status" + fila + "'");	
	var jq_estatusA =	eval("'#status" + fila + " option[value=A]'");	
	var jq_estatusP =	eval("'#status" + fila + " option[value=P]'");	
 
	var disponibleAntes =$(jq_partidaPre).asNumber();
	var totalDisponible =$(jq_totalDispon).asNumber();
	var solicitado		=$(jq_montoPre).asNumber();
	var autorizado		= $(jq_monAutorizado).asNumber();
	if(autorizado > 0){
		if(autorizado > solicitado){
			mensajeSis("No puede Aprobar una Cantidad Mayor a la Solicitada.");
			$(jq_monAutorizado).val(solicitado);
			$(jq_estatusA).attr("selected",true);
			// se cambian todos los detalles de la factura
			validarFacturaEstatus($(jq_factura).val(),$(jq_provee).val(),fila);
		}
		else { 
			if(autorizado == solicitado){
				$(jq_monAutorizado).val(solicitado);
				$(jq_estatusA).attr("selected",true);
				// se cambian todos los detalles de la factura
				if($.trim($(jq_factura).val())!='' && $(jq_factura).val()!='' && $(jq_factura).val()!=null ){

					validarFacturaEstatus($(jq_factura).val(),$(jq_provee).val(),fila);
				}
			}else{
				var nuevoDisponible = 0;
				var fueraPresup=0;
				if(solicitado > totalDisponible){
					fueraPresup=solicitado-totalDisponible;
					nuevoDisponible=0;
					
				}
					if(solicitado <= totalDisponible){
						nuevoDisponible = totalDisponible - autorizado; 
						if(nuevoDisponible < 0){
							nuevoDisponible =0;
							
						}
					}
				
				if(disponibleAntes!=nuevoDisponible){
					$(jq_estatusA).attr("selected",true); 
				}
				if(autorizado == 0){
					if($(jq_estatus).val()=="A"){
						$(jq_estatusP).attr("selected",true);
					}
				}else{
					if($.trim($(jq_factura).val())!='' && $(jq_factura).val()!='' && $(jq_factura).val()!=null ){
						if(solicitado>autorizado){
							$(jq_monAutorizado).val(solicitado);
							$(jq_estatusA).attr("selected",true);
						}
					}else{
						if(solicitado>autorizado){
							$(jq_estatusA).attr("selected",true);
						}
					}
				}    	
				if(parametroBean.perfilUsuario==parametroBean.rolTesoreria){ //--
					if(fueraPresup>0){
						$(jq_estatusP).attr("selected",true); 
					}
				}
				if($.trim($(jq_factura).val())!='' && $(jq_factura).val()!='' && $(jq_factura).val()!=null ){
					// se cambian todos los detalles de la factura 

					validarFacturaEstatus($(jq_factura).val(),$(jq_provee).val(),fila);
				}
				ActualizaTotalesPre();
			}
		}
		agregaFormatoControles('formaGenerica');
	}
	else{
		agregaFormatoControles('formaGenerica');
	}
}


// valida si el monto autorizado que se esta indicando corresponde a una factura
// los estatus se cambian a autorizado y los montos se ponen por default lo solicitado.
function validarFacturaEstatus(numeroFactura,provee,fila){ 
	setTimeout("$('#cajaLista').hide();", 200);
	var contador = 1;
	var jqNoFact ;
	var jqProve;
	var jq_estatus ;
	var jq_estatusA ;
	var jq_estatusC ;
	var jq_estatusP ;
	var jq_MonSol ;
	var elementos = document.getElementsByName("renglon"); 
	for (var numero = 1; numero <= elementos.length; numero++ ) { 
		jqNoFact 	= eval("'#noFactura" + contador + "'");
		jqProve 	= eval("'#proveedorID" + contador + "'");
		jq_monAut  = eval("'#monAutorizado" + contador + "'");
		jq_MonSol  = eval("'#montoPre" + contador + "'");
		jq_estatus  = eval("'#status" + fila + "'");
		jq_estatusA = eval("'#status" + contador + " option[value=A]'");	
		jq_estatusP = eval("'#status" + contador + " option[value=P]'");	
		jq_estatusC = eval("'#status" + contador + " option[value=C]'");	
		if($.trim($(jqNoFact).val()) == numeroFactura && $.trim($(jqProve).val())==provee){
			if($(jq_estatus).val()=="A"){
				$(jq_estatusA).attr("selected",true);
				if(contador != fila && $(jq_monAut).asNumber() == 0 ){
					$(jq_monAut).val($(jq_MonSol).val());
				}$(jq_monAut).val($(jq_MonSol).val());
			}
			if($(jq_estatus).val()=="C"){
				$(jq_estatusC).attr("selected",true);  
				$(jq_monAut).val(0);
			}
			if($(jq_estatus).val()=="P"){
				$(jq_estatusP).attr("selected",true); 
				$(jq_monAut).val("0.00");
				if($(jq_monAut).asNumber()>0){
					$(jq_estatusP).attr("selected",true); 
					if($(jq_MonSol).asNumber()>$(jq_monAut).asNumber()){
						$(jq_monAut).val($(jq_MonSol).val());
						$(jq_estatusA).attr("selected",true);
					}
				}else{
					$(jq_estatusP).attr("selected",true); 
					$(jq_monAut).val("0.00");
				}
			}
		} 
		contador = contador +1;
	}
	// se actualiza el disponible 
	actualizaMontoDisponibleAutorizado(fila);
}

// valida que alguno de los movimientos que no esta autorizado entonces muestra botones.
function validarNoAutorizados(numeroFactura,fila){ 
	setTimeout("$('#cajaLista').hide();", 200);
	var contador = 1;
	var elementos = document.getElementsByName("renglon"); 
	for (var numero = 1; numero <= elementos.length; numero++ ) { 
		jq_estatus  = eval("'#status" + fila + "'");
		if($(jq_estatus).val() == "P"){
			contador = contador +1;
		}
	}
	if(contador == 1 ){
		escondeBotones();
	}
}


// actualiza el dispobinle si cambia el monto autorizado
function actualizaMontoDisponibleAutorizado(fila){ 
	var jqTipoGastoSol = eval("'#tipoGastoID" + fila + "'");
	var contador = 0;
	var disponible = 0; 

	var elementos = document.getElementsByName("renglon"); 
	for (var numero = 1; numero <= elementos.length; numero++ ) {	
		var jqTipoGastoID = eval("'#tipoGastoID" + numero + "'");
		var jqDisponSol = eval("'#partidaPre" + numero + "'");
		var disponibleSol = $(jqDisponSol).asNumber();
		var jqMontoAut = eval("'#monAutorizado" + numero + "'");
		var jqmontoPre = eval("'#montoPre" + numero + "'");
		
		
		if($(jqTipoGastoSol).val() == $(jqTipoGastoID).val()){ 
			if(disponibleSol>0){
				var autorizado = $(jqMontoAut).asNumber();
				if(contador == 0){
					$(jqDisponSol).val(disponibleSol);
					disponible =disponibleSol;
				}else{
					$(jqDisponSol).val(disponible);
				}
				if($(jqMontoAut).asNumber()>0 ){
					disponible = disponible - autorizado;
				}else{
					disponible = disponible - $(jqmontoPre).asNumber();
				}
				contador = contador+1;
			}			
		}
	}
	ActualizaTotalesPre();
	agregaFormatoControles('formaGenerica');
}


function ActualizaTotalesPre(){
	var totalFilas = document.getElementById("numeroDetalle").value; 
	var  totalMontoPre=0.00,totalNoPre=0.00,totalMonAut=0.00;
	for (var numeroFila = 1; numeroFila <= totalFilas; numeroFila++ ) {
		var jq_montoPre = eval("'#montoPre" + numeroFila + "'");	
		var jq_noPresupuestado = eval("'#noPresupuestado" + numeroFila + "'");	
		var jq_monAutorizado = eval("'#monAutorizado" + numeroFila + "'");	
		totalMontoPre +=  $(jq_montoPre).asNumber();  
		totalNoPre += $(jq_noPresupuestado).asNumber();
		totalMonAut += $(jq_monAutorizado).asNumber();
		$('#totMontoPre').val(totalMontoPre);
		$('#totNoPresupuestado').val(totalNoPre);
		$('#totMonAutorizado').val(totalMonAut);
	}
	/*
	$('#totMontoPre').val(totalMontoPre);
	$('#totNoPresupuestado').val(totalNoPre);
	$('#totMonAutorizado').val(totalMonAut);
	*/
	agregaFormatoControles('formaGenerica');
}	

function validaAprobacion(fila){
	var jq_estatus =eval("'#status" + fila + "'");	
	var jq_monAutorizado = eval("'#monAutorizado" + fila + "'");
	var jq_noPresupuestado = eval("'#noPresupuestado" + fila + "'");	
	var jq_factura = eval("'#noFactura" + fila + "'");	
	var jq_provee = eval("'#proveedorID" + fila + "'");	
	var totalMonAut = $(jq_monAutorizado).asNumber();
	var fueraPresup = $(jq_noPresupuestado).asNumber();

	if( $(jq_estatus).val()=='A' && totalMonAut <= 0 ){
		mensajeSis("Imposible autorizar monto con cantidad menor o igual a $0.00");
		var select =	eval("'#status" + fila + " option[value=P]'");
		$(select).attr('selected','true');	
	}else{
		validarFacturaEstatus($(jq_factura).val(),$(jq_provee).val(),fila);
	}

	if( $(jq_estatus).val()=='A' && totalMonAut > 0 &&  fueraPresup == 0){
		// se cambian todos los detalles de la factura
		validarFacturaEstatus($(jq_factura).val(),$(jq_provee).val(),fila);
	}

	
	if(parametroBean.perfilUsuario==parametroBean.rolTesoreria){ //--
		if( $(jq_estatus).val()=='A' && fueraPresup > 0 ){
			var select =	eval("'#status" + fila + " option[value=P]'");
			$(select).attr('selected','true');	
			mensajeSis("No cuenta con los privilegios para autorizar monto fuera de presupuesto");

		}  
	} 
	
	if( $(jq_estatus).val()=='C'){
		// se cambian todos los detalles de la factura
		validarFacturaEstatus($(jq_factura).val(),$(jq_provee).val(),fila);
	}

	if( $(jq_estatus).val()=='P'){
		// se cambian todos los detalles de la factura
		validarFacturaEstatus($(jq_factura).val(),$(jq_provee).val(),fila);
	}	
}

//valida si el tipo de desembolso que se esta indicando corresponde a una factura
//los tipo de desembolso para cada detalle que corresponda a esa factura sera el mismo 
function validaTipoDesembolso(fila){	
	setTimeout("$('#cajaLista').hide();", 200);
	var jq_factura = eval("'#noFactura" + fila + "'");	
	var jq_proveedorID = "proveedorID" + fila ;	
	var jq_proveedor =eval("'#proveedorID" + fila + "'");	
	var contador = 1;
	var jqNoFact ;
	var jqProv;
	var jq_tipoDeposito ;
	var jq_tipoDepositoC ;
	var jq_tipoDepositoS ;
	var jq_tipoDepositoB ;
	var jq_tipoDepositoT ;
	var contadorciclo = 0;

	

	var numeroFactura = $(jq_factura).val();
	var proveedor =$(jq_proveedor).val();
	if($.trim(numeroFactura)== ""){
		validaTipoDesembolsoInd(fila);	

	}else{
		var elementos = document.getElementsByName("renglon"); 
		for (var numero = 1; numero <= elementos.length; numero++ ) { 
			jqNoFact 	= eval("'#noFactura" + contador + "'");
			jqProv	    = eval("'#proveedorID" + contador + "'");
			jq_tipoDeposito  = eval("'#tipoDeposito" + fila + "'");
			jq_tipoDepositoC = eval("'#tipoDeposito" + contador + " option[value=C]'");
			jq_tipoDepositoS = eval("'#tipoDeposito" + contador + " option[value=S]'");
			jq_tipoDepositoB = eval("'#tipoDeposito" + contador + " option[value=B]'");
			jq_tipoDepositoT = eval("'#tipoDeposito" + contador + " option[value=T]'");
			if($.trim($(jqNoFact).val()) == numeroFactura && $.trim($(jqProv).val())== proveedor ){
				contadorciclo = contadorciclo +1;
				if($(jq_tipoDeposito).val()=="C"){
					$(jq_tipoDepositoC).attr("selected",true);				
				}
				if($(jq_tipoDeposito).val()=="S"){//se valida que el proveedor tenga una cuenta clabe si se selecciona tipo desembolso spei
										
					consultaClabeProveedor(jq_proveedorID, jq_tipoDepositoS,jq_tipoDepositoC,
							$(jq_tipoDeposito).val(),contadorciclo );	
		
				}
				if($(jq_tipoDeposito).val()=="B"){
					$(jq_tipoDepositoB).attr("selected",true);
				}
				if($(jq_tipoDeposito).val()=="T"){
					$(jq_tipoDepositoT).attr("selected",true);
				}				
			} 
			contador = contador +1;
			cuentaclabeproveedorfac="";
			
		}
	}
		
	
} // fin validaTipoDesembolso

// se valida que el proveedor tenga una cuenta clabe si se selecciona tipo desembolso spei
function validaTipoDesembolsoInd(fila){	
	setTimeout("$('#cajaLista').hide();", 200);
	var jq_proveedorID = "proveedorID" + fila ;	
	var jq_tipoDeposito ;
	var jq_tipoDepositoC ;
	var jq_tipoDepositoS ;
	var cuentaClabeProv="";
	
	
	var jqProveedor  = eval("'#" + jq_proveedorID + "'");
	var numProveedor = $(jqProveedor).val();	
	var tipoConsul =3;
	var proveedorBeanCon = { 
		'proveedorID'	:numProveedor
	};		
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	
	
	jq_tipoDeposito  = eval("'#tipoDeposito" + fila + "'");
	jq_tipoDepositoC = eval("'#tipoDeposito" + fila + " option[value=C]'");
	jq_tipoDepositoS = eval("'#tipoDeposito" + fila + " option[value=S]'");
	
	if($(jq_tipoDeposito).val()=="S"){
		
	
		if(numProveedor != '' && !isNaN(numProveedor) && esTab){
			proveedoresServicio.consulta(tipoConsul,proveedorBeanCon,function(proveedoresCta) {
				if(proveedoresCta!=null){
					esTab=true; 
					
					if(proveedoresCta.cuentaClave == "" ||  $.trim(proveedoresCta.cuentaClave)==""){ 
						mensajeSis("El Proveedor No Tiene Parametrizado Pagos con SPEI");
						$(jq_tipoDepositoC).attr("selected",true);
					}else{
						$(jq_tipoDepositoS).attr("selected",true);
					}
					
				}else{
					mensajeSis("El Proveedor No Tiene Parametrizado Pagos con SPEI");
					$(jq_tipoDepositoC).attr("selected",true);

				}
			});
		}
	}
} // fin validaTipoDesembolso


function consultaProveedor(idControl) { 
	var jqProveedor  = eval("'#" + idControl + "'");
	var numProveedor = $(jqProveedor).val();	
	var tipoConsul =1;
	var proveedorBeanCon = { 
		'proveedorID'	:numProveedor
	};		
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if(numProveedor != '' && !isNaN(numProveedor) && esTab){
		proveedoresServicio.consulta(tipoConsul,proveedorBeanCon,function(proveedores) {
			if(proveedores!=null){
				esTab=true;
				var nombreCompleto ="";
				if(proveedores.tipoPersona == 'F' ){
					nombreCompleto = proveedores.primerNombre+" "+proveedores.segundoNombre+" "+proveedores.apellidoPaterno+" "
						+proveedores.apellidoMaterno;
				}
				if(proveedores.tipoPersona == 'M' ){
					nombreCompleto = proveedores.razonSocial;
				}
				$('#descProveedor').val(nombreCompleto);
				$('#tipoProveedor').val(proveedores.tipoProveedorID);
				$('#observaciones').focus();
			}
			else{
				mensajeSis("El Proveedor No Existe");
				$('#proveedorID').focus();
				$('#proveedorID').select();
				$('#proveedorID').val("");
			}
		});
	}
}
		
	
//funcion para validar si una factura ya habia sido agregada	
function existeFactura(idFactura, idProveedor){
	var totalFilas = document.getElementById("numeroDetalle").value; 
	var jq_numeroFactura;
	var retorno = false;
	var existeIgual ="";
	for (var numeroFila = 1; numeroFila <= totalFilas; numeroFila++ ) {
		jq_numeroFactura = eval("'#noFactura" + numeroFila + "'");
		jq_numeroProv = eval("'#proveedorID" + numeroFila + "'");
					
		if($(jq_numeroFactura).val()!="" && $(jq_numeroProv).val() !=""){ 
			if($(jq_numeroFactura).val()==idFactura && $(jq_numeroProv).val() ==idProveedor)
			{
				existeIgual = "S";
				retorno= true;					
			}
		}
		if(numeroFila==totalFilas && existeIgual == "S"){
			mensajeSis("Ya existe una factura con el numero:"+ idFactura+
					"\ny el proveedor:"+idProveedor);
			$('#proveedorIDFact').focus();
			$('#proveedorIDFact').select();
			$('#noFactura').val("");
		}
	}
	return retorno;
}

function consultaFacturaProveedor(idControl) {
	var jqFactura  = eval("'#" + idControl + "'");
	var numFactura = $(jqFactura).val();	
	var tipoConsultaPrincipal =1;
	var facturaBeanCon = { 
		'noFactura'	:numFactura,
		'proveedorID':$('#proveedorIDFact').val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if($.trim(numFactura) != '' && esTab){
		var fechaAplicacion = parametroBean.fechaAplicacion;
		$('#fechaFactura').val(fechaAplicacion);
		habilitaBoton('agrega', 'submit');	
		facturaProvServicio.consulta(tipoConsultaPrincipal, facturaBeanCon,function(factura) {
			if(factura!=null){
				if(factura.estatus == 'A' || factura.estatus == 'P' || factura.estatus == 'V'){
					existeFacturaProveedor ="0";
					$('#proveedorIDFact').val(factura.proveedorID);
					$('#totalFactura').val(factura.totalFactura);
					$('#saldoFactura').val(factura.totalFactura);

					$('#totalFactura').formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
					$('#saldoFactura').formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
					
					esTab= true;
					deshabilitaBoton('agrega', 'submit');	
					if(existeFactura(numFactura,factura.proveedorID)==true){
						$('#noFactura').focus();
						$('#noFactura').select();
						$('#noFactura').val("");
						$('#proveedorIDFact').val("");
						$('#totalFactura').val("");
						$('#saldoFactura').val("");
						$('#descProveedorFact').val("");
					}else{
						consultaProveedorFactura('proveedorIDFact');	
					}
				}else{
					if(factura.estatus == 'R'){
						existeFacturaProveedor = "1";
						mensajeSis("La Factura seleccionada se encuentra en \nproceso de Requisición.");
						$('#noFactura').focus();
						$('#noFactura').select();
						$('#noFactura').val("");
						$('#proveedorIDFact').val("");
						$('#totalFactura').val("");
						$('#saldoFactura').val("");
						$('#descProveedorFact').val("");
					}else{
						existeFacturaProveedor = "1";
						mensajeSis("Debe seleccionar una factura con un \n estatus diferente al pagado o cancelado");
						$('#noFactura').focus();
						$('#noFactura').select();
						$('#noFactura').val("");
						$('#proveedorIDFact').val("");
						$('#totalFactura').val("");
						$('#saldoFactura').val("");
						$('#descProveedorFact').val("");
					}
					
				} 
			}else{
				existeFacturaProveedor = "1";
				mensajeSis("La Factura no Existe");
				$('#noFactura').focus();
				$('#noFactura').select();
				$('#noFactura').val("");
				$('#proveedorIDFact').val("");
				$('#totalFactura').val("");
				$('#saldoFactura').val("");
				$('#descProveedorFact').val("");
			}
		});																	 				
	}
}

// funcion para consultar el proveedor de la factura
function consultaProveedorFactura(idControl) { 
	var jqProveedor  = eval("'#" + idControl + "'");
	var numProveedor = $(jqProveedor).val();	
	var tipoConsul =1;
	var proveedorBeanCon = { 
		'proveedorID'	:numProveedor
	};		
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if(numProveedor != '' && !isNaN(numProveedor) && esTab){
		proveedoresServicio.consulta(tipoConsul,proveedorBeanCon,function(proveedores) {
			if(proveedores!=null){
				esTab=true;
				var nombreCompleto ="";
				if(proveedores.tipoPersona == 'F' ){
					nombreCompleto = proveedores.primerNombre+" "+proveedores.segundoNombre+" "+proveedores.apellidoPaterno+" "
						+proveedores.apellidoMaterno;
				}
				if(proveedores.tipoPersona == 'M' ){
					nombreCompleto = proveedores.razonSocial;
				}
				$('#descProveedorFact').val(nombreCompleto);
			}
			else{
				mensajeSis("El Proveedor No Existe");
				$('#proveedorIDFact').focus();
				$('#proveedorIDFact').select();
				$('#proveedorIDFact').val("");
			}
		});
	}
}

// funcion para consultar el presupuesto tipos de gasto de la factura
function consultaPresupuestoGastoPorFactura(){ 
	var RequisicionGastoBean = {
			'requisicionID' : $('#noFactura').val(),
			'tipoGastoID' : 	$('#proveedorID').val(),
		'sucursalID':		parametroBean.sucursal
	}; 
	/* esta consulta muestra el presupuesto*/
	requisicionGastosServicio.consulta(3,RequisicionGastoBean,function(tipoGastoCon){
	if(tipoGastoCon!=null){
		$('#noPresupuestado').val(tipoGastoCon.monto);
	}else{
		//iniciaPresupuesto();    		
		}	
	});				
}

//funcion para validar los campos que son requeridos. para el perfil basico
function validarCamposRequeridosPerfilBasico(){
	var existenVacios = "0";
	//monto Solicitado
	if(existenVacios ==  "0") {
		$('input[name=lmontoPre]').each(function() {		
			var jqMonto = eval("'#" + this.id + "'");	
			var monto = $(jqMonto).val();	
			var montoNumer = $(jqMonto).asNumber();
			if($.trim(monto) == '' && existenVacios ==  "0"){
				mensajeSis('El Monto Solicitado es requerido.');
				$(jqMonto).focus();
				existenVacios="1";
				return;
			}	
			else if(montoNumer <=0 && existenVacios ==  "0"){
				mensajeSis('El monto Solicitado debe ser mayor a $0.00');
				$(jqMonto).focus();
				existenVacios="1";
				return;
			}
		});
	}
	
	// Observaciones
	if(existenVacios ==  0) {
		$('textarea[name=lobservaciones]').each(function() {		
			var jqObservaciones = eval("'#" + this.id + "'");		
			var varObservaciones = $(jqObservaciones).val();
			if($.trim(varObservaciones) == '' && existenVacios == "0"){
				mensajeSis('Es requerido indicar una Observación.');
				$(jqObservaciones).focus();
				existenVacios="1";
					return;
				}			 
			});
		}
		return existenVacios;
}
		
// eliminar detalles de requisicion
function eliminaDetalleReq(control){	
	var contador = 0 ;
	var numeroID = control.id;
	var numeroFactura = 0 ;
	var proveddor=0;
	var jqNoFactura = eval("'#noFactura" + numeroID + "'");
	var jqProveedor	=eval("'#proveedorID" + numeroID + "'");
	var jqtipoGastoID = eval("'#tipoGastoID" + numeroID + "'");
	var valortipoGastoID = $(jqtipoGastoID).val();
	
	// si la fila que se va a eliminar corresponde a una factura, se pregunta si desea eliminar todos los
	// renglones relacionados a la factura indicada
	var jqNoFact = "";
	var jqProve ="";
	if($.trim($(jqNoFactura).val())!= "" &&  $.trim($(jqNoFactura).val())!= "0"){
		numeroFactura = $.trim($(jqNoFactura).val());
		proveddor	  = $.trim($(jqProveedor).val());
		$('tr[name=renglon]').each(function() {
			numero= this.id.substr(7,this.id.length);
			jqNoFact = eval("'#noFactura" + numero + "'");
			jqProve	 = eval("'#proveedorID"+numero+"'");
			if(numero !=numeroID && $.trim($(jqNoFact).val())== numeroFactura || $.trim($(jqProve).val())==proveddor){
				contador = parseInt(contador+1);
			}
		});
		if(contador >= 1){
			confirmarEliminarDetalleFactura(numeroFactura,proveddor,control);
		}else{
			eliminarDetalle(control.id);
		}
	}else{
		// si el renglon seleccionado no corresponde a alguna factura, 
		// se elimina la fila seleccionada
		eliminarDetalle(control.id);
	}
	// se consulta el disponible por concepto al eliminar un detalle
	disponiblePorPresupuestoEliminarFilas(valortipoGastoID);
	$('#rTotalGasto').remove();
	agregaTotalesJS();
	ActualizaTotalesPre();

}

function eliminarDetalle(control){	
	var contador = 0 ;
	var numeroID = control;
	
	var jqRenglon = eval("'#renglon" + numeroID + "'");
	var jqNumero = eval("'#consecutivo" + numeroID + "'");
	var jqDetReqGasID = eval("'#detReqGasID" + numeroID + "'");
	var jqcentroCostoID = eval("'centroCostoID" + numero + "'");
	
	var jqNoFactura = eval("'#noFactura" + numeroID + "'");
	var jqTipoGastoID = eval("'#tipoGastoID" + numeroID + "'");
	
	var jqDescripcionTG = eval("'#descripcionTG" + numeroID + "'");
	var jqProveedorID = eval("'#proveedorID" + numeroID + "'");
	var jqDescProveedor = eval("'#descProveedor" + numeroID + "'");
	var jqObservaciones = eval("'#observaciones" + numeroID + "'");
	var jqPartidaPre = eval("'#partidaPre" + numeroID + "'");
	
	var jqPartidaPreID = eval("'#partidaPreID" + numeroID + "'");
	var jqTotalDisponible= eval("'#totalDisponible" + numeroID + "'");
	var jqMontoPre = eval("'#montoPre" + numeroID + "'");
	var jqNoPresupuestado = eval("'#noPresupuestado" + numeroID + "'");
	
	var jqMonAutorizado = eval("'#monAutorizado" + numeroID + "'");
	var jqStatus = eval("'#status" + numeroID + "'");
	var jqStatusVista = eval("'#statusVista" + numeroID + "'");
	var jqTipoDeposito = eval("'#tipoDeposito" + numeroID + "'");
	
	var jqEliminaDetalle = eval("'#" + numeroID + "'");
	
	// si el renglon seleccionado no corresponde a alguna factura, 
	// se elimina la fila seleccionada
	$(jqNumero).remove();
	$(jqDetReqGasID).remove();
	$(jqcentroCostoID).remove();
	$(jqNoFactura).remove();
	$(jqTipoGastoID).remove();
	$(jqDescripcionTG).remove();
	
	$(jqProveedorID).remove();
	$(jqDescProveedor).remove();
	$(jqObservaciones).remove();
	$(jqPartidaPre).remove();
	$(jqPartidaPreID).remove();

	$(jqTotalDisponible).remove();
	$(jqMontoPre).remove();
	$(jqNoPresupuestado).remove();
	$(jqMonAutorizado).remove();
	$(jqTipoDeposito).remove();

	$(jqStatus).remove();
	$(jqStatusVista).remove();
	$(jqEliminaDetalle).remove();
	$(jqRenglon).remove();
				
	// se asigna el numero de detalle que quedan
	var elementos = document.getElementsByName("renglon");
	$('#numeroDetalle').val(elementos.length);	

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglon]').each(function() {
		numero= this.id.substr(7,this.id.length);
		var jqRenglonCiclo = eval("'renglon" + numero+ "'");	
		var jqNumeroCiclo = eval("'consecutivo" + numero + "'");
		var jqDetReqGasIDCiclo = eval("'detReqGasID" + numero + "'");
		var jqcentroCostoID = eval("'centroCostoID" + numero + "'");
		var jqNoFacturaCiclo = eval("'noFactura" + numero + "'");
		var jqTipoGastoIDCiclo = eval("'tipoGastoID" + numero + "'");

		var jqDescripcionTGCiclo = eval("'descripcionTG" + numero + "'");
		var jqProveedorIDCiclo = eval("'proveedorID" + numero + "'");
		var jqDescProveedorCiclo = eval("'descProveedor" + numero + "'");
		var jqObservacionesCiclo = eval("'observaciones" + numero + "'");
		var jqPartidaPreCiclo = eval("'partidaPre" + numero + "'");
		
		var jqPartidaPreIDCiclo = eval("'partidaPreID" + numero + "'");
		var jqTotalDisponibleCiclo= eval("'totalDisponible" + numero + "'");
		var jqMontoPreCiclo = eval("'montoPre" + numero + "'");
		var jqNoPresupuestadoCiclo = eval("'noPresupuestado" + numero + "'");
		var jqTipoDepositoCiclo = eval("'tipoDeposito" + numero + "'");

		var jqMonAutorizadoCiclo = eval("'monAutorizado" + numero + "'");
		var jqStatusCiclo = eval("'status" + numero + "'");
		var jqStatusVistaCiclo = eval("'statusVista" + numero + "'");
		var jqEliminaDetalleCiclo = eval("'" + numero + "'");
		
		document.getElementById(jqNumeroCiclo).setAttribute('value',  contador);
		
		document.getElementById(jqRenglonCiclo).setAttribute('id', "renglon" + contador);
		document.getElementById(jqNumeroCiclo).setAttribute('id', "consecutivo" + contador);
		document.getElementById(jqDetReqGasIDCiclo).setAttribute('id', "detReqGasID" + contador);
		
		document.getElementById(jqcentroCostoID).setAttribute('id', "centroCostoID" + contador);
		document.getElementById(jqNoFacturaCiclo).setAttribute('id', "noFactura" + contador);
		document.getElementById(jqTipoGastoIDCiclo).setAttribute('id', "tipoGastoID" + contador);
		
		document.getElementById(jqDescripcionTGCiclo).setAttribute('id', "descripcionTG" + contador);
		document.getElementById(jqProveedorIDCiclo).setAttribute('id', "proveedorID" + contador);
		document.getElementById(jqDescProveedorCiclo).setAttribute('id', "descProveedor" + contador);
		document.getElementById(jqObservacionesCiclo).setAttribute('id', "observaciones" + contador);
		document.getElementById(jqPartidaPreCiclo).setAttribute('id', "partidaPre" + contador);
		
		document.getElementById(jqPartidaPreIDCiclo).setAttribute('id', "partidaPreID" + contador);
		document.getElementById(jqTotalDisponibleCiclo).setAttribute('id', "totalDisponible" + contador);
		document.getElementById(jqMontoPreCiclo).setAttribute('id', "montoPre" + contador);
		document.getElementById(jqNoPresupuestadoCiclo).setAttribute('id', "noPresupuestado" + contador);

		document.getElementById(jqTipoDepositoCiclo).setAttribute('id', "tipoDeposito" + contador);
		document.getElementById(jqMonAutorizadoCiclo).setAttribute('id', "monAutorizado" + contador);
		document.getElementById(jqStatusCiclo).setAttribute('id', "status" + contador);
		document.getElementById(jqStatusVistaCiclo).setAttribute('id', "statusVista" + contador);
		document.getElementById(jqEliminaDetalleCiclo).setAttribute('id',  contador);	

		contador = parseInt(contador + 1);	
	});
	
}

//funcion que hace un ciclo para hacer la resta al disponible por presupuesto cuando se elimina un concepto
function disponiblePorPresupuestoEliminarFilas(valortipoGastoID){ 
	var contador = 0;
	var disponible = 0; 
	$('input[name=lpartidaPre]').each(function() {
		numero= this.id.substr(10,this.id.length); 
		var jqTipoGastoID = eval("'#tipoGastoID" + numero + "'");
		var jqDisponSol = eval("'#partidaPre" + numero + "'");
		var disponibleSol = $(jqDisponSol).asNumber();
		var jqMontoPre = eval("'#montoPre" + numero + "'");

		if(valortipoGastoID == $(jqTipoGastoID).val()){ 
			consultaPresupuestoFactura(valortipoGastoID, numero,$(jqMontoPre).asNumber(), numero,numero);
			var solicitado = $(jqMontoPre).asNumber();
			if(contador == 0){
				$(jqDisponSol).val(disponibleSol);
				disponible =disponibleSol;
			}else{
				$(jqDisponSol).val(disponible);
			}
			disponible = disponible - solicitado;
			contador = contador+1;
		}
	});
	// se actualizan los totales
	ActualizaTotalesPre();
	agregaFormatoControles('formaGenerica');
}


//eliminar detalles de requisicion
function eliminaDetalleFactura(numeroFactura,proveddor,control){	
	var contador = 0 ;
	var jqNoFact ;
	var jqProvedor;
	var numero= 0;
	
	// se eliminan los detalles relacionados al numero de factura
	$('tr[name=renglon]').each(function() { 
		numero= this.id.substr(7,this.id.length); 
		jqNoFact 	= eval("'#noFactura" + numero + "'");
		jqProvedor=eval("'#proveedorID" + numero + "'");
		if($.trim($(jqNoFact).val()) == numeroFactura && $.trim($(jqProvedor).val()) == proveddor){
			eliminarDetalle(numero); 
		}
	});
	
 	// se asigna el numero de detalle que quedan
	var elementos = document.getElementsByName("renglon");
	$('#numeroDetalle').val(elementos.length);

	//Reordenamiento de Controles
		contador = 1;
	$('tr[name=renglon]').each(function() {
		numero= this.id.substr(7,this.id.length);
		var jqRenglonCiclo = eval("'renglon" + numero+ "'");	
		var jqNumeroCiclo = eval("'consecutivo" + numero + "'");
		var jqDetReqGasIDCiclo = eval("'detReqGasID" + numero + "'");	
		
		var jqcentroCostoID = eval("'centroCostoID" + numero + "'");
		var jqNoFacturaCiclo = eval("'noFactura" + numero + "'");
		
		var jqTipoGastoIDCiclo = eval("'tipoGastoID" + numero + "'");

		var jqDescripcionTGCiclo = eval("'descripcionTG" + numero + "'");
		var jqProveedorIDCiclo = eval("'proveedorID" + numero + "'");
		var jqDescProveedorCiclo = eval("'descProveedor" + numero + "'");
		var jqObservacionesCiclo = eval("'observaciones" + numero + "'");
		var jqPartidaPreCiclo = eval("'partidaPre" + numero + "'");
		
		var jqPartidaPreIDCiclo = eval("'partidaPreID" + numero + "'");
		var jqTotalDisponibleCiclo= eval("'totalDisponible" + numero + "'");
		var jqMontoPreCiclo = eval("'montoPre" + numero + "'");
		var jqNoPresupuestadoCiclo = eval("'noPresupuestado" + numero + "'");
		var jqTipoDepositoCiclo = eval("'tipoDeposito" + numero + "'");
		
		var jqMonAutorizadoCiclo = eval("'monAutorizado" + numero + "'");
		var jqStatusCiclo = eval("'status" + numero + "'");
		var jqStatusVistaCiclo = eval("'statusVista" + numero + "'");
		var jqEliminaDetalleCiclo = eval("'" + numero + "'");
		
		document.getElementById(jqNumeroCiclo).setAttribute('value',  contador);
		
		document.getElementById(jqRenglonCiclo).setAttribute('id', "renglon" + contador);
		document.getElementById(jqNumeroCiclo).setAttribute('id', "consecutivo" + contador);
		document.getElementById(jqDetReqGasIDCiclo).setAttribute('id', "detReqGasID" + contador);
		
		document.getElementById(jqcentroCostoID).setAttribute('id', "centroCostoID" + contador);
		document.getElementById(jqNoFacturaCiclo).setAttribute('id', "noFactura" + contador);
		document.getElementById(jqTipoGastoIDCiclo).setAttribute('id', "tipoGastoID" + contador);
		
		document.getElementById(jqDescripcionTGCiclo).setAttribute('id', "descripcionTG" + contador);
		document.getElementById(jqProveedorIDCiclo).setAttribute('id', "proveedorID" + contador);
		document.getElementById(jqDescProveedorCiclo).setAttribute('id', "descProveedor" + contador);
		document.getElementById(jqObservacionesCiclo).setAttribute('id', "observaciones" + contador);
		document.getElementById(jqPartidaPreCiclo).setAttribute('id', "partidaPre" + contador);
		
		document.getElementById(jqPartidaPreIDCiclo).setAttribute('id', "partidaPreID" + contador);
		document.getElementById(jqTotalDisponibleCiclo).setAttribute('id', "totalDisponible" + contador);
		document.getElementById(jqMontoPreCiclo).setAttribute('id', "montoPre" + contador);
		document.getElementById(jqNoPresupuestadoCiclo).setAttribute('id', "noPresupuestado" + contador);
		
		document.getElementById(jqTipoDepositoCiclo).setAttribute('id', "tipoDeposito" + contador);
		document.getElementById(jqMonAutorizadoCiclo).setAttribute('id', "monAutorizado" + contador);
		document.getElementById(jqStatusCiclo).setAttribute('id', "status" + contador);
		document.getElementById(jqStatusVistaCiclo).setAttribute('id', "statusVista" + contador);
		document.getElementById(jqEliminaDetalleCiclo).setAttribute('id',  contador);	

		contador = parseInt(contador + 1);	
	});
}


//funcion para confirmar eliminar todos los detalles de factura 
function confirmarEliminarDetalleFactura(numeroFactura,proveddor,control) {	
	var confirmar; 
	confirmar=confirm("Se eliminaran todos los detalles correspondientes \nal número de factura: "+numeroFactura+" y proveedor: "+ proveddor+"\n¿Deseas continuar?"); 
	if (confirmar == true) {
		eliminaDetalleFactura(numeroFactura,proveddor,control);  	
	}					
}


//funcion para consultar el proveedor de la factura cuando se consulta una requisicion
function consultaProveedorRequisicion() {  
	var contador = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	var elementos = document.getElementsByName("renglon"); 
	for (var numero = 1; numero <= elementos.length; numero++ ) { 
		consultaProveedorDescripcion(contador); 
		contador = contador +1;
	}
}


function consultaProveedorDescripcion(numero) { 
	var jqProveedor  = eval("'#proveedorID" + numero + "'");
	var jqDescripcionProv = eval("'#descProveedor" + numero + "'");
	var numProveedor = $(jqProveedor).val();	
	var tipoConsul =1;
	var proveedorBeanCon = { 
		'proveedorID'	:numProveedor
	};		
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if(numProveedor != '' && !isNaN(numProveedor) && esTab){
		proveedoresServicio.consulta(tipoConsul,proveedorBeanCon,function(proveedores) {
			if(proveedores!=null){
				esTab=true;
				var nombreCompleto ="";
				if(proveedores.tipoPersona == 'F' ){
					nombreCompleto = proveedores.primerNombre+" "+proveedores.segundoNombre+" "+proveedores.apellidoPaterno+" "
						+proveedores.apellidoMaterno;
				}
				if(proveedores.tipoPersona == 'M' ){
					nombreCompleto = proveedores.razonSocial;
				}
				$(jqDescripcionProv).val(nombreCompleto);
			}
		});
	}
}
		

function cargaValorListaFacturaProv(control, factura, proveedor) {	
	jqControl = eval("'#" + control + "'");
	$(jqControl).val(factura);
	$('#proveedorIDFact').val(proveedor);
	$(jqControl).focus();
	setTimeout("$('#cajaLista').hide();", 200);
}

//funcion que hace un ciclo para hacer la resta al disponible por presupuesto cuando se modifica el solicitado
function consultaPresupuestoDetalle(fila){	
	var jqtipo= eval("'#tipoGastoID" + fila + "'");
	var varTipoGasto = $(jqtipo).val();
	var numeroFilaAnterior =0;
 	// se asigna el numero de detalle que quedan
	var numeroFilas = $('#numeroDetalle').val();
	for (var i = 1; i <= numeroFilas; i++){
		var jqtipoGastoID = eval("'#tipoGastoID" + i + "'");	
		var jqnoFactura = eval("'#noFactura" + i + "'");	
		if($(jqnoFactura).val() == null || $(jqnoFactura).val() == ''){
			if( varTipoGasto == $(jqtipoGastoID).val()){ 
				if(numeroFilaAnterior == 0 ){
					numeroFilaAnterior = i;
				}
				var montoPre= eval("'#montoPre" + i + "'");
				var solicitado = $(montoPre).asNumber();
				// se consulta el presupuesto por tipo de gasto
				consultaPresupuestoFactura(varTipoGasto, numeroFilaAnterior,solicitado, i,i);
				numeroFilaAnterior = i ;
			}
		}
		agregaFormatoControles('formaGenerica');
		ActualizaTotalesPre();
	}				
}

//funcion que hace un ciclo para hacer la resta al disponible por presupuesto cuando se carga una factura
function consultaPresupuestoDetallePorFactura(gast, solicitado,fila){	
	var varTipoGasto = gast;
	var numeroFilas = $('#numeroDetalle').val();
		consultaPresupuestoFactura(varTipoGasto, fila,solicitado, fila,fila);
		agregaFormatoControles('formaGenerica');
		ActualizaTotalesPre();
		if(fila == numeroFilas){
			agregaFormatoControles('formaGenerica');
			ActualizaTotalesPre();
			
		}			
}

//funcion para consultar la cuenta clabe del proveedor
function consultaClabeProveedor(idControl,jq_tipoDepositoS,jq_tipoDepositoC,valor,contadorciclo ) { 
	var jqProveedor  = eval("'#" + idControl + "'");
	var numProveedor = $(jqProveedor).val();	
	var tipoConsul =3;
	var proveedorBeanCon = { 
			'proveedorID'	:numProveedor
	};
	
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if(numProveedor != '' && !isNaN(numProveedor) && esTab){
		proveedoresServicio.consulta(tipoConsul,proveedorBeanCon,function(proveedoresCta) {
			if(proveedoresCta!=null){
				esTab=true; 
				
				cuentaclabeproveedorfac=proveedoresCta.cuentaClave;				
				if(valor== 'S'){
					if(proveedoresCta.cuentaClave != "" || proveedoresCta.cuentaClave !=$.trim(proveedoresCta.cuentaClave)){
						$(jq_tipoDepositoS).attr("selected",true);
						
					}else{
						if(contadorciclo==1  ){
							mensajeSis("El Proveedor No Tiene Parametrizado Pagos con SPEI ");
						}
						$(jq_tipoDepositoC).attr("selected",true);
					}
					
				}
				
			}else{
				cuentaclabeproveedorfac="";
				if(valor== 'S'){
					if(contadorciclo==1  ){
						mensajeSis("El Proveedor No Tiene Parametrizado Pagos con SPEI ");
					}					
					$(jq_tipoDepositoC).attr("selected",true);
				}
			}
		});
	}
	return cuentaclabeproveedorfac;
}

//funcion para consultar el tipo de pago del proveedor  lore
function consultaProveedorTipoPago(numProveedor, fila ) { 
	var jq_tipoDepositoC = eval("'#tipoDeposito" + fila + " option[value=C]'");
	var jq_tipoDepositoS = eval("'#tipoDeposito" + fila + " option[value=S]'");
	var jq_tipoDepositoT = eval("'#tipoDeposito" + fila + " option[value=T]'");
	var jq_tipoDepositoB = eval("'#tipoDeposito" + fila + " option[value=B]'");
	var tipoConsul =3;
	var proveedorBeanCon = { 
		'proveedorID'	:numProveedor
	};		
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if(numProveedor != '' && !isNaN(numProveedor) && esTab){
		proveedoresServicio.consulta(tipoConsul,proveedorBeanCon,function(proveedores) {
			if(proveedores!=null){;
				if(proveedores.tipoPago=="C"){						
					$(jq_tipoDepositoC).attr("selected",true);
				}
				if(proveedores.tipoPago=="S"){
					$(jq_tipoDepositoS).attr("selected",true);
				}
				if(proveedores.tipoPago=="T"){
					$(jq_tipoDepositoT).attr("selected",true);
				}
				if(proveedores.tipoPago=="B"){
					$(jq_tipoDepositoB).attr("selected",true);
				}
			}
			else{
				mensajeSis("El Proveedor No Existe");
				$('#jqProveedor').select();
				$('#proveedorID').val("");
			}
		});
	}
}


function agregaTotalesJS(){
	var tds = '<tr id="rTotalGasto" name="col"  >';
	tds +='<td></td>';
	tds +='<td></td>';
	tds +='<td></td>';
	tds +='<td></td>';
	tds +='<td></td>';
	tds +='<td></td>';
	tds +='<td></td>';
	tds +='<td align="right"><label>TOTAL GASTO:</label></td>';
	tds +='<td></td>';
	tds +='<td>';
	tds +='<input type="text"	id="totMontoPre" style="text-align:right;"  esMoneda="true" path="montoPre" size="13"autocomplete="off" disabled="true"  />';
	tds +='</td> ';
	tds +='<td>';
	tds +='<input type="text" id="totNoPresupuestado" style="text-align:right;"  esMoneda="true" path="noPresupuestado" size="13"	autocomplete="off" disabled="true"  />';
	tds +='</td>';
	tds +='<td>';
	tds +='<input type="text" id="totMonAutorizado" style="text-align:right;"  esMoneda="true" path="monAutorizado" size="13"	autocomplete="off" disabled="true"  />';
	tds +='</td>';
	tds +='<td></td>';
	tds += '</tr>';
	$("#miTabla").append(tds);
	
	
}	

function funcionExito(){
}

function funcionError(){
	limpiaTablaDetalles();
	habilitaBoton('agregar', 'submit');
}
