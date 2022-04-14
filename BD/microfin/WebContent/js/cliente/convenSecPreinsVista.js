$(document).ready(function() {
	esTab = true;
	
	$('#tipoRegistro').focus();

	var catConvenSecPreins = {
		'alta' : '1',
		'altaIns':'2'
	};


	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------
	deshabilitaBoton('agrega', 'submit');
	inicializaForma('formaGenerica');
	
	$('#cantDis').hide();
	$('#cantOcupa').hide();
	$('#lblcantDis').hide();
	$('#lblcantOcupa').hide();
	
	$('#cantPre').hide();
	$('#cantIns').hide();
	$('#lblcantPre').hide();
	$('#lblcantIns').hide();
	
	
	$('#tipoRegistro').change(function(){
	if($('#tipoRegistro').val() == 'PAS' || $('#tipoRegistro').val() == 'PAG'){
		$('#cantDis').show();
		$('#cantOcupa').show();
		$('#lblcantDis').show();
		$('#lblcantOcupa').show();
		$('#cantPre').hide();
		$('#cantIns').hide();
		$('#lblcantPre').hide();
		$('#lblcantIns').hide();
	
	}
	});
	
	$('#tipoRegistro').change(function(){
	if($('#tipoRegistro').val() == 'IAS' || $('#tipoRegistro').val() == 'IAG'){
		$('#cantDis').hide();
		$('#cantOcupa').hide();
		$('#lblcantDis').hide();
		$('#lblcantOcupa').hide();
		$('#cantPre').show();
		$('#cantIns').show();
		$('#lblcantPre').show();
		$('#lblcantIns').show();
	
	}
	});
	
	 
	$('#tipoRegistro').change(function(){
	if($('#tipoRegistro').val() == 'IAG' || $('#tipoRegistro').val() == 'PAG'){
		consultaFechasGral();
	
	}
		else{
			if($('#tipoRegistro').val() == 'IAS' || $('#tipoRegistro').val() == 'PAS'){
			consultaFechasSecc();
			}
	}
});
		
	
	$('#fecha').change(function(){
		if($('#tipoRegistro').val() == 'IAG' || $('#tipoRegistro').val() == 'PAG'){
		consultaSucursalesGral();
		}
		else{
			if($('#tipoRegistro').val() == 'IAS' || $('#tipoRegistro').val() == 'PAS'){
				consultaSucursalesSecc();
			}
		}
		
	});
	

	
	$('#sucursalID').change(function(){
		if($('#tipoRegistro').val() == 'PAS' || $('#tipoRegistro').val() == 'PAG'){
			consultaLugares();
			}
		
		
	});
	
	$('#sucursalID').change(function(){
		if($('#tipoRegistro').val() == 'IAS' || $('#tipoRegistro').val() == 'IAG'){
			consultaLugaresIns();
			}
		
		
	});
		
	
	$(':text').focus(function() {
		esTab = false;
	});
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','noSocio','exitoConvenSecc','falloConvenSecc');
		}
	});

	
	$('#agrega').click(	function() {
		if($('#tipoRegistro').val() == 'PAG' || $('#tipoRegistro').val() == 'PAS'){
		$('#tipoTransaccion').val(catConvenSecPreins.alta); 
		}
		else{
			if($('#tipoRegistro').val() == 'IAG' || $('#tipoRegistro').val() == 'IAS'){
				$('#tipoTransaccion').val(catConvenSecPreins.altaIns);
			}

	}
	});
	
	$('#noTarjeta').bind('keypress', function(e){
		return validaAlfanumerico(e,this);		
	});
	$('#noTarjeta').blur(function(e){
		var longitudTarjeta=$('#noTarjeta').val().length; 
		if (longitudTarjeta<16){
			$('#noTarjeta').val("");
		}else{
			consultaClienteIDTarDeb('noTarjeta');	
		}
	});
	
// ------------ Validaciones de la Forma
	
	$('#formaGenerica').validate({
		rules : {
			tipoRegistro: {
				required : true,
			},
			fecha: {
				required : true,
			},
			sucursalID: {
				required : true,
			},
			noSocio: {
				required : true,
			}

		},
		messages : {
			tipoRegistro:{
				required : 'Especifique el Tipo de Registro.',
			},
			fecha: {
				required : 'Especifique la Fecha ',
			},
			sucursalID: {
				required : 'Especifique la Sucursal ',
			},
			noSocio: {
				required : 'Especifique el Número de Socio',
			}
		}
	});
	
	$('#noSocio').blur(function() {
		consultaClienteCta(this.id);
	});
	
	$('#noSocio').bind('keyup',function(e) {
						if (this.value.length >= 1) {
							listaAlfanumerica('noSocio', '1',	'1', 'nombreCompleto',$('#noSocio').val(),'listaCliente.htm');
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
		 var longitudTarjeta=$('#noTarjeta').val().length;		 	
		 		if (longitudTarjeta == 16 ){
					consultaClienteIDTarDeb('noTarjeta');							
				}	
		 return true;	
		 
		 
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
				mensajeSis("El Número de Tarjeta es Incorrecto deben de ser 16 dígitos");
				$(jqControl).val("");
				$(jqControl).focus();
			}
			if($(jqControl).val().length == 16){
				tarjetaDebitoServicio.consulta(conNumTarjeta,TarjetaBeanCon,function(tarjetaDebito) {
					if(tarjetaDebito!=null){					
						if (tarjetaDebito.estatusId==7){
							$('#idCtePorTarjeta').val(tarjetaDebito.clienteID);
							$('#nomTarjetaHabiente').val(tarjetaDebito.nombreCompleto);
								if ($('#noTarjeta').val()!=""&& $('#idCtePorTarjeta').val()!=""){
									$('#noSocio').val($('#idCtePorTarjeta').val());
									$('#nombreCompleto').val($('#nomTarjetaHabiente').val());
									
									esTab=true;
									$('#noSocio').focus();
								}
								
								$('#idCtePorTarjeta').val("");
						}else{
								if (tarjetaDebito.estatusId==1){
									mensajeSis("La Tarjeta no se Encuentra Asociada a una Cuenta");
								}else
								if (tarjetaDebito.estatusId==6){
									mensajeSis("La Tarjeta no se Encuentra Activa");
								}else
								if (tarjetaDebito.estatusId==8){
									mensajeSis("La Tarjeta se Encuentra Bloqueada");
								}else
								if (tarjetaDebito.estatusId==9){
									mensajeSis("La Tarjeta se Encuentra Cancelada");
								}
								$(jqControl).focus();
								$(jqControl).val("");
								$('#idCtePorTarjeta').val("");
								$('#nomTarjetaHabiente').val("");
								$('#idCtePorTarjeta').val("");
								$('#nomTarjetaHabiente').val("");
								$('#noSocio').val("");
								$('#nombreCompleto').val("");
								deshabilitaBoton('agrega');
						}
					}else{
						mensajeSis("La Tarjeta de Identificación no existe.");
						$(jqControl).focus();
						$(jqControl).val("");
						$('#idCtePorTarjeta').val("");
						$('#nomTarjetaHabiente').val("");
						$('#noSocio').val("");
						$('#nombreCompleto').val("");
						deshabilitaBoton('agrega');
					}
					});	
				}
			}
		 }
		
	function consultaClienteCta(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente = 2;
		var rfc = '';
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente)) {
			clienteServicio.consulta(conCliente,numCliente,rfc,	function(cliente) {
								if (cliente != null) {
									$('#nombreCompleto').val(cliente.nombreCompleto);
									habilitaBoton('agrega', 'submit');
								} else {
									mensajeSis("No Existe el Cliente");
									$(jqCliente).focus();
									$(jqCliente).val('');
									deshabilitaBoton('agrega', 'submit');
								}
							});
		}
	}
	
	
	function consultaLugares() {
		var sucursal = $('#sucursalID').val();
		var fecha = $('#fecha').val();
		var conLugarDis = 1;
		var conLugarOcu = 1;
		var lugarBeanCon = {
	 		 	'sucursalID' : sucursal,
	 		 	'fecha': fecha
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (sucursal != '' && !isNaN(sucursal)) {
			convencionSeccionalServicio.consulta(conLugarDis,lugarBeanCon,function(lugarDis){
				convenSecPreinsServicio.consulta(conLugarOcu,lugarBeanCon,function(lugarOcu){
								if (lugarDis != null && lugarOcu !=null) {
									
									var lugares = lugarDis.cantSocio-lugarOcu.cantPreins;
									
									if(lugarOcu.cantPreins ==0){
										
									$('#cantDis').val(lugarDis.cantSocio);
									$('#cantOcupa').val(lugarOcu.cantPreins);
									}
									else if(lugarOcu.cantPreins !=0){
										$('#cantDis').val(lugares);
										$('#cantOcupa').val(lugarOcu.cantPreins);
									}
													
									if(lugares <= 50 && lugares !=0){
										mensajeSis("Solo quedan "+lugares+" disponibles");
									}
									 if(lugares ==0){
										mensajeSis("Ya no hay cupo para esa fecha");
										$('#tipoRegistro').focus();
										$('#tipoRegistro').val('');
										$('#fecha').val('');
										$('#sucursalID').val('');
										$('#noTarjeta').val('');
										$('#noSocio').val('');
										$('#nombreCompleto').val('');
										deshabilitaBoton('agrega', 'submit');
									
									}
									
									
								} else {
									$('#cantDis').val("");
									$('#cantOcupa').val("");
									
								}
							});
			});
		}
	}
	
	
	

	function consultaLugaresIns() {
		var sucursal = $('#sucursalID').val();
		var fecha = $('#fecha').val();
		var conLugarPre = 1;
		var conLugarIns = 2;
		var lugarBeanCon = {
	 		 	'sucursalID' : sucursal,
	 		 	'fecha': fecha
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (sucursal != '' && !isNaN(sucursal)) {
			convenSecPreinsServicio.consulta(conLugarPre,lugarBeanCon,function(lugarPre){
				convenSecPreinsServicio.consulta(conLugarIns,lugarBeanCon,function(lugarIns){
								if (lugarPre != null && lugarIns !=null) {
									
									var lugares = lugarPre.cantPreins-lugarIns.cantIns;
									
									if(lugarIns.cantIns ==0){
										
									$('#cantPre').val(lugarPre.cantPreins);
									$('#cantIns').val(lugarIns.cantIns);
									}
									else if(lugarIns.cantIns !=0){
										$('#cantPre').val(lugares);
										$('#cantIns').val(lugarIns.cantIns);
									}
													
									if(lugares <= 50 && lugares !=0){
										mensajeSis("Solo quedan "+lugares+" disponibles");
									}
									 if(lugares ==0){
										mensajeSis("Ya no hay cupo para esa fecha");
										$('#tipoRegistro').focus();
										$('#tipoRegistro').val('');
										$('#fecha').val('');
										$('#sucursalID').val('');
										$('#noTarjeta').val('');
										$('#noSocio').val('');
										$('#nombreCompleto').val('');
										deshabilitaBoton('agrega', 'submit');
									
									}
									
									
								} else {
									$('#cantPre').val("");
									$('#cantIns').val("");
									
								}
							});
			});
		}
	}

	function consultaFechasGral() {
		dwr.util.removeAllOptions('fecha');
		dwr.util.addOptions('fecha', {'' : 'SELECCIONAR'});
		var bean={};
		convencionSeccionalServicio.listaCombo(2,bean,function(fechas) {
					dwr.util.addOptions('fecha',fechas, 'fecha');
				});
	}
	
	function consultaFechasSecc() {
		dwr.util.removeAllOptions('fecha');
		dwr.util.addOptions('fecha', {'' : 'SELECCIONAR'});
		var bean={};
		convencionSeccionalServicio.listaCombo(3,bean,function(fechas) {
					dwr.util.addOptions('fecha',fechas, 'fecha');
				});
	}
	
	function consultaSucursalesGral() {
		var fec=$('#fecha').val();
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions('sucursalID', {'' : 'SELECCIONAR'});
		var bean={
		'fecha':fec
			};
		convencionSeccionalServicio.listaCombo(4,bean,function(sucursales) {
					dwr.util.addOptions('sucursalID',sucursales, 'sucursalID','nombreSucurs');
				});
	}
	
	
	function consultaSucursalesSecc() {
		var fec=$('#fecha').val();
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions('sucursalID', {'' : 'SELECCIONAR'});
		var bean={
		'fecha':fec
			};
		convencionSeccionalServicio.listaCombo(5,bean,function(sucursales) {
					dwr.util.addOptions('sucursalID',sucursales, 'sucursalID','nombreSucurs');
				});
	}
	

});


function exitoConvenSecc() {
	$('#tipoRegistro').val('');
	$('#sucursalID').val('');
	$('#fecha').val('');						
	$('#noTarjeta').val('');
	$('#noSocio').val('');
	$('#nombreCompleto').val('');
	$('#cantDis').val('');
	$('#cantOcupa').val('');
	$('#cantDis').hide();
	$('#cantOcupa').hide();
	$('#lblcantDis').hide();
	$('#lblcantOcupa').hide();
	
	$('#cantPre').hide();
	$('#cantIns').hide();
	$('#lblcantPre').hide();
	$('#lblcantIns').hide();
	
	deshabilitaBoton('agrega', 'submit');
}

function falloConvenSecc(){
	$('#tipoRegistro').val('');
	$('#sucursalID').val('');
	$('#fecha').val('');						
	$('#noTarjeta').val('');
	$('#noSocio').val('');
	$('#nombreCompleto').val('');
	$('#cantDis').val('');
	$('#cantOcupa').val('');
	$('#cantDis').hide();
	$('#cantOcupa').hide();
	$('#lblcantDis').hide();
	$('#lblcantOcupa').hide();
	
	$('#cantPre').hide();
	$('#cantIns').hide();
	$('#lblcantPre').hide();
	$('#lblcantIns').hide();
	deshabilitaBoton('agrega', 'submit');
	
}



