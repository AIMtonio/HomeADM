$(document).ready(function() {		
	esTab = true;

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});
	//Definicion de Constantes y Enums  		
	var catTipoTranAsociaCeuntaTC = {
  		'alta':1,
  		'actualizacion':3,  		
  	};
	
	var catTipoActAsociaCeuntaTC = {
	  		'asociaCuentasTC':1,
	  	};
	var catTipoConAsociaCeuntaTC = {
	  		'principal'			:1,
	  		'tarjetaCuentaTipo'	:3,
	  		'tipoTarjeta'		:4,
	  		'tarDebCuenta'		:18
	};
	
	var catTipoCtasCon ={
		'conTiposCuentas' : 1
	};
	
	var catTipoConCtaAho ={
		'cuentaAhoAsocia' : 23
	};
	var catEstatusTD ={
		'cancelada' : 9,
		'expirada'	: 10,
		'bloqueada' : 8,
		'activa'	:7,
		'asociada'	:6
	};
	var catListaTipoTar ={
		'activos' : 5
	};
	expedienteBean = {
			'clienteID' : 0,
			'tiempo' : 0,
			'fechaExpediente' : '1900-01-01',
	};
	listaPersBloqBean = {
			'estaBloqueado'	:'N',
			'coincidencia'	:0
	};
	var esCliente 			='CTE';
	var esUsuario			='USS';
	//------------ Metodos y Manejo de Eventos -----------------------------------------
   deshabilitaBoton('procesar', 'submit');
   $('#imprimir').hide();
   $('#opcRelacion').val('T');
   validaEmpresaID();
   
	agregaFormatoControles('formaGenerica');

	$('#tipoTarjetaDebID').focus();
	if($('#flujoCliSolCue').val() != undefined){
		if(!isNaN($('#flujoCliSolCue').val())){
			var SolCuentaFlu = Number($('#flujoCliSolCue').val());
			if(SolCuentaFlu > 0){
				$('#cuentaAhoID').val($('#flujoCliSolCue').val());
				consultaDatosCuentaAho('cuentaAhoID');
			}else{
				$('#cuentaAhoID').val();
				$('#cuentaAhoID').focus().select();
			}
		}
	}
	
	$.validator.setDefaults({
      submitHandler: function(event) { 
    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoTarjetaDebID',
	    			'funcionExitoTransaccion','funcionFalloTransaccion'); 
      }
   });		
	
	$('#procesar').click(function() {
		$('#tipoTransaccion').val(catTipoTranAsociaCeuntaTC.actualizacion);
		$('#tipoActualizacion').val(catTipoActAsociaCeuntaTC.asociaCuentasTC);	
	});
	
	$('#imprimir').click(function() { 
		generaReporte();
	});
	
	$('#cuentaAhoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#cuentaAhoID').val();
			camposLista[1] = "lisTipoCuentas";
			parametrosLista[1] = $('#tipoTarjetaDebID').val();
			lista('cuentaAhoID', '2', '12', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}
	});
	
	$('#cuentaAhoID').blur(function() {
		if (this.value != '' ) {
			if ($('#tipoTarjetaDebID').val() != '' ){
				consultaDatosCuentaAho(this.id);
			}else{
				$('#tipoTarjetaDebID').focus();
				mensajeSis("Especifique el Tipo de Tarjeta");
			}
		}
	});
	
	$('#tarjetaDebID').blur(function() {
		 
		if(identificador==1){
			if (longitudTarjeta<16){
				$('#tarjetaDebID').val("");
			}else {
				
					var numeroTar=$('#tarjetaDebID').val();
					var numTarIdenAccess=numeroTar.replace(/[%&(=?¡'{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\]/gi, '');
						numTarIdenAccess=numTarIdenAccess.replace(/[_]/gi,'');
						numTarIdenAccess=numTarIdenAccess.replace(/[' ']/gi,''); // Quitamos los espacios en blanco
						numeroTar=numTarIdenAccess;
						
						$('#tarjetaDebID').val(numeroTar);
						var longitudTarjeta=$('#tarjetaDebID').val().length;
						if (longitudTarjeta==16){
							consultaDatosTarjetaDebito();
						}else{
							$('#tarjetaDebID').val("");
							$('#tarjetaDebID').focus();
							mensajeSis("El Número de Tarjeta debe Tener 16 Digítos");
						}				
			}
		}else{
			var longitudTarjeta=$('#tarjetaDebID').val().length;
			if (longitudTarjeta==16){
				consultaDatosTarjetaDebito();
			}else{
				$('#tarjetaDebID').val("");
				$('#tarjetaDebID').focus();
				mensajeSis("El Número de Tarjeta debe Tener 16 Digítos");
			}
		}
	});
	
	 $('#tarjetaDebID').bind('keypress', function(e){
			 if(identificador==1){
				 return validaAlfanumerico(e,this);	
			 }
				
		});

    $('#relacionT').click(function() {
    	$('#opcRelacion').val('T');
		esTab = true;
		consultaDatosCuentaAho('cuentaAhoID');
	});
    $('#relacionA').click(function() {
		$('#opcRelacion').val('A');
		$('#tarjetaDebID').val('');
   	$('#nombreTarjeta').val('');
   	$('#tipoCobro').removeAttr('disabled');
		$('#tipoCobro').val('');
		esTab = true;
		consultaDatosCuentaAho('cuentaAhoID');
   	$('#tarjetaDebID').focus();

		$('#imprimir').hide();
	});
    
    $('#tipoTarjetaDebID').change(function() {
    	limpiarFormularioAsociaTarjeta();
    	consultaTipoCuentas(this.value);
    	consultaTipoTarjetaDebito();
    	deshabilitaBoton('procesar', 'submit');
    	$('#imprimir').hide();
    	$('#gridTarDebConsulta').html("");
		$('#gridTarDebConsulta').hide();

	});
    
    // conseguimos la fecha del sistema
    var parametroBean = consultaParametrosSession();
    $('#fechaActivacion').val(parametroBean.fechaSucursal);	
    consultaParamCaja();
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			tipoTarjetaDebID: 'required',
			cuentaAhoID: 'required',
			nombreTarjeta: {
				required: true,
				maxlength: 40				
			},
			tarjetaDebID: {
				required : true
				
			},
			tipoCobro: {
				required: function() {return $('#tipoCobro option[value=""]').attr('selected')==true;}
			}
		},
		
		messages: {
			tipoTarjetaDebID: 'Especifique el Tipo de Tarjeta',
			cuentaAhoID: 'Especifique la Cuenta de Ahorro',
			nombreTarjeta: {
				required: 'Especificar Nombre',
				maxlength: 'Máximo 40 Caracteres'				
			},	
			tarjetaDebID: {
				required: 'Especifique el Número de Tarjeta',
			
			},
			tipoCobro: {
				required: "Especifique el Tipo de Cobro"
			}			
		}		
	});	
	
	/* ====================== FUNCIONES ============================ */
	
	function consultaTipoCuentas(valor){
		var TipoTarjetaBeanCon  = {
			'tipoTarjetaDebID' : valor
		};
		$('#lisTipoCuentas').val('');
		if (!isNaN(valor) && valor != '' ){
			tiposCuentaValidoTipoTarjetaServicio.listaConsulta(catTipoCtasCon.conTiposCuentas, TipoTarjetaBeanCon,function(tiposCuentas) {
				if(tiposCuentas != null){
					for (var i = 0; i < tiposCuentas.length; i++){
						if (i == 0){
							$('#lisTipoCuentas').val(tiposCuentas[i].tipoCuenta);	
						}else {
							$('#lisTipoCuentas').val( $('#lisTipoCuentas').val() + ", "+ tiposCuentas[i].tipoCuenta);
						}
					}
				}
			});
		}
	}
	
	function consultaSolicitudNominativa() {
		var numeroTarjeta = $('#tarjetaDebID').val();
		var cuentaID = $('#cuentaAhoID').val();
		var clienteID =  $('#clienteID').val();
		var tipoTarjeta = $('#tipoTarjetaDebID').val();
		if (numeroTarjeta != '' && cuentaID != '' && clienteID !=''){
			
		}
	}	
	
	function validaAlfanumerico(e,elemento){//Recibe al evento 
		var key;
		if(window.event){//Internet Explorer ,Chromium,Chrome
			key = e.keyCode; 
		}else if(e.which){//Firefox , Opera Netscape
				key = e.which;
		}
		 if (key > 31 && (key < 48 ||  key > 57) && (key <65 || key >90) && (key<97 || key >122)) //Comparación con código ascii
		    return false;
		 return true;	
		 
		 
	}
	

	
	function consultaDatosTarjetaDebito(){
		
		var numeroTarjeta=$('#tarjetaDebID').val();
		var cero=0;
		var cuentaID= $('#cuentaAhoID').val();	
		var tipoTarjeta= $('#tipoTarjetaDebID').val();
		var var_clienteID= $('#clienteID').val();
	
		if(tipoTarjeta !='' && cuentaID!='' && numeroTarjeta.length == 16){

			var tarjetaDebito = {
				'tarjetaDebID':numeroTarjeta,
				'loteDebitoID':cero,
				'cuentaAhoID':cuentaID,
				'tipoTarjetaDebID':tipoTarjeta,
				'clienteID':var_clienteID
			};			
			setTimeout("$('#cajaLista').hide();", 200);
			tarjetaDebitoServicio.consulta(catTipoConAsociaCeuntaTC.tarjetaCuentaTipo,tarjetaDebito,function(tarjetaDebito) {
				if(tarjetaDebito!=null){
					if (tarjetaDebito.estatus == catEstatusTD.cancelada){
						$('#tarjetaDebID').focus();
						mensajeSis("La Tarjeta de Débito se Encuentra Cancelada");
						deshabilitaBoton('procesar', 'submit');		
						$('#imprimir').hide();
					}else if (tarjetaDebito.estatus == catEstatusTD.expirada){
						$('#tarjetaDebID').focus();
						mensajeSis("La Tarjeta de Débito se Encuentra Expirada");
						deshabilitaBoton('procesar', 'submit');		
						$('#imprimir').hide();
					}else if (tarjetaDebito.estatus == catEstatusTD.bloqueada){
						$('#tarjetaDebID').focus();
						mensajeSis("La Tarjeta de Débito se Encuentra Bloqueada");
						deshabilitaBoton('procesar', 'submit');		
						$('#imprimir').hide();
					}else if (tarjetaDebito.estatus == catEstatusTD.activa){
						deshabilitaBoton('procesar', 'submit');		
						mensajeSis("La Tarjeta de Débito se Encuentra Activa");
						$('#imprimir').show();
					}else if (tarjetaDebito.estatus == catEstatusTD.asociada){
						deshabilitaBoton('procesar', 'submit');		
						$('#imprimir').show();
					}else{
						$('#nombreTarjeta').val(tarjetaDebito.nombreTarjeta);
						$('#imprimir').hide();
						habilitaBoton('procesar', 'submit');

					}

				}else{
					habilitaBoton('procesar', 'submit');
					$('#imprimir').hide();
				}
			});		
		
		}
	}	
	
	function consultaTipoTarjetaDebito() {
		var tipoTarjetaBeanCon = {
			'tipoTarjetaDebID' : $('#tipoTarjetaDebID').val()
		};
		tipoTarjetaDebServicio.consulta(3,tipoTarjetaBeanCon,function(TipoTarDeb) {
			if(TipoTarDeb!=null){
				$('#identificacionSocio').val(TipoTarDeb.identificacionSocio);
				
			}
		});
		
	}
		
	
	
	// funcion para consultar el tipo de tarjeta		//ttt
	function consultaTipoTarjeta(){
		var numeroTarjeta=$('#tarjetaDebID').val();
		var tipoTarjeta= $('#tipoTarjetaDebID').val();	
		var cero=0; 

		
		var tarjetaDebito = { 
				'tarjetaDebID':numeroTarjeta,
				'loteDebitoID':cero,
				'cuentaAhoID':cero,
				'tipoTarjetaDebID':tipoTarjeta,
				'clienteID':cero
			};	
			
			setTimeout("$('#cajaLista').hide();", 200);
			tarjetaDebitoServicio.consulta(catTipoConAsociaCeuntaTC.tipoTarjeta,tarjetaDebito,function(tarjetaDebito) {
				if(tarjetaDebito!=null){
					habilitaBoton('procesar', 'submit');
					var tipoTarjetaConsulta=tarjetaDebito.tipoTarjetaDebID;
					var tipoTarjeta= $('#tipoTarjetaDebID').val();
					if(tipoTarjetaConsulta != tipoTarjeta){
						mensajeSis("El Número de Tarjeta no corresponde con el Tipo de tarjeta Seleccionado");
					}					
				}else{

				}
			});
	}
	// funcion para llenar el combo de Tipos de Tarjeta
	llenaComboTiposTarjetasDeb();
	function llenaComboTiposTarjetasDeb() {
		var tarDebBean = {
				'tipoTarjetaDebID' : '',
				'tipoTarjeta' : 'D'
		};
		dwr.util.removeAllOptions('tipoTarjetaDebID');
		dwr.util.addOptions('tipoTarjetaDebID', {"":'SELECCIONAR'});
		tipoTarjetaDebServicio.listaCombo(catListaTipoTar.activos, tarDebBean, function(tiposTarjetas){
			dwr.util.addOptions('tipoTarjetaDebID', tiposTarjetas, 'tipoTarjetaDebID', 'descripcion');
		});
	}
	
	// funcion para consultar  datos de la cuenta de ahorro
	function consultaDatosCuentaAho(idControl) {
		var jqCtaAho = eval("'#" + idControl + "'");
		var numCtaAho = $(jqCtaAho).val();
		var tiposCuentas = $('#lisTipoCuentas').val();
		var CuentaAhoBeanCon = {
		'cuentaAhoID' : numCtaAho,
		'lisTipoCuentas' : $('#tipoTarjetaDebID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCtaAho != '' && !isNaN(numCtaAho) && esTab) {
			cuentasAhoServicio.consultaCuentasAho(catTipoConCtaAho.cuentaAhoAsocia, CuentaAhoBeanCon, function(ctaAho) {
				if (ctaAho != null) {
					$('#clienteID').val(ctaAho.clienteID);
					var cliente = $('#clienteID').asNumber();
					if (cliente > 0) {
						listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, numCtaAho, 0);
						if (listaPersBloqBean.estaBloqueado != 'S') {
							expedienteBean = consultaExpedienteCliente(cliente);
							if (expedienteBean.tiempo <= 1) {
								if (alertaCte(cliente) != 999) {
									$('#tipoCuentaID').val(ctaAho.tipoCuentaID);
									consultaTiposCuentaServicio('tipoCuentaID');
									if ($('#tipoCuentaID').val() == '') {
										$('#nombreTarjeta').val('');
									}
									if ($('#relacionT').is(':checked')) {
										consultaCliente('clienteID');
									}
									consultaTarjetaDebAsociada();
									consultaTarjetasPorCtaJS();
								} else {
									limpiarFormularioAsociaTarjeta();
									$('#tipoTarjetaDebID').focus();
									$('#tipoTarjetaDebID').val('');
									mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar.');
								}
							}
						} else {
							limpiarFormularioAsociaTarjeta();
							$('#tipoTarjetaDebID').focus();
							$('#tipoTarjetaDebID').val('');
							mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						}
					}
				} else {
					$('#tipoCuentaID').val('');
					$('#descripcionTipoCuenta').val('');
					$('#tarjetaDebID').val('');
					$('#nombreTarjeta').val('');
					$('#relacionT').attr('checked', 'true');
					$('#gridTarDebConsulta').html("");
					$('#gridTarDebConsulta').hide();
					$(jqCtaAho).focus();
					mensajeSis("La Cuenta de Ahorro No Puede Asociarse con el Tipo de Tarjeta Seleccionado.");
				}
			});
		}
	}
	// funcion para consultar el nombre del cliente de la cuenta de ahorro
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente =1;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
						if(cliente!=null){
							$('#nombreTarjeta').val(cliente.nombreCompleto);
						}else{
							$(jqCliente).focus();
							mensajeSis("No Existe el Cliente");
							
						}
				});
			}
	}
	// funcion que consulta datos del Tipo de Cuenta de Ahorro
	function consultaTiposCuentaServicio(idControl){
		var jqTipoCuenta  = eval("'#" + idControl + "'");
		var numTipoCuenta = $(jqTipoCuenta).val();
		var conTipoCuenta =1;
		var numTipoCuentaAho = {
				'tipoCuentaID':numTipoCuenta
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoCuenta != '' && !isNaN(numTipoCuenta)){
			tiposCuentaServicio.consulta(conTipoCuenta,numTipoCuentaAho,function(tipoCuenta){
						if(tipoCuenta!=null){
							$('#tipoCuentaID').val(tipoCuenta.tipoCuentaID);
							$('#descripcionTipoCuenta').val(tipoCuenta.descripcion);
						}else{
							$(jqTipoCuenta).focus();
							mensajeSis("No el tipo de Cuenta");
						}    						
				});
			}
	}
	
	
	/* Funcion para generar el reporte */
	function generaReporte() {	
		var tarjetaDebID = $("#tarjetaDebID").val();
		var tipoReporte = 1;
		var fechaSis = parametroBean.fechaSucursal;
		var nombreInstitucion = parametroBean.nombreInstitucion; 	

			$('#ligaGenerar').attr('href','reporteTarDebCaratula.htm?tarjetaDebID='+tarjetaDebID +'&fechaSistema='+fechaSis
					+'&tipoReporte='+tipoReporte+'&nombreInstitucion='+nombreInstitucion);
		
	}
	
	/* Funcion para verificar si una cuenta d ahorro ya tiene asignada una tarjeta de debito */
	function consultaTarjetaDebAsociada (){
		var cuentaID = $('#cuentaAhoID').val();
		var tipoTarjeta = $('#tipoTarjetaDebID').val();
		var tipoRelacion = $('#opcRelacion').val();
		
		if(tipoTarjeta !='' && cuentaID!=''){
			
			var tarjetaDebito = {
				'cuentaAhoID':cuentaID,
				'relacion'	: tipoRelacion ,
				'tipoTarjetaDebID'	: tipoTarjeta 
			};
			setTimeout("$('#cajaLista').hide();", 200);
			tarjetaDebitoServicio.consulta(catTipoConAsociaCeuntaTC.tarDebCuenta,tarjetaDebito,function(tarjetaDebito) {
				if(tarjetaDebito!=null){
					if($('#tipoTarjetaDebID').val()==tarjetaDebito.tipoTarjetaDebID){
						$('#tipoTarjetaDebID').val(tarjetaDebito.tipoTarjetaDebID);
						$("#tarjetaDebID").val(tarjetaDebito.tarjetaDebID);	
						$("#tipoCobro").val(tarjetaDebito.tipoCobro);
						
						if(tarjetaDebito.relacion == 'T'){
							$('#relacionT').attr('checked', 'true');
							$("#tarjetaDebID").attr('disabled', true);
							$("#nombreTarjeta").attr('disabled', true);
							$("#tipoCobro").attr('disabled', true);
						}
						if(tarjetaDebito.relacion == 'A'){
							$('#relacionA').attr('checked', 'true');
							$('#nombreTarjeta').val(tarjetaDebito.nombreTarjeta);
							$("#tarjetaDebID").removeAttr('disabled');
							$("#nombreTarjeta").removeAttr('disabled');
							$("#tipoCobro").removeAttr('disabled');
							$("#tarjetaDebID").focus();
						}
						$('#imprimir').show();
						$("#imprimir").focus();
						deshabilitaBoton('procesar', 'submit');
					}else{
						$("#tarjetaDebID").val('');
						if ( $('#relacionA').is(':checked') ){
							$('#nombreTarjeta').val('');
						}
						$("#tarjetaDebID").attr('disabled', false);
						$("#nombreTarjeta").attr('disabled', false);
						$("#tipoCobro").attr('disabled', false);
						$("#relacionT").attr('disabled', false);
						$("#relacionA").attr('disabled', false);
						$('#tipoCobro').val("0").selected = true;
						habilitaBoton('procesar', 'submit');	
						$('#imprimir').hide();
						$("#tarjetaDebID").focus();
					}
				}
				else{
					$("#tarjetaDebID").val('');
					if ( $('#relacionA').is(':checked') ){
						$('#nombreTarjeta').val('');
					}
					$("#tarjetaDebID").attr('disabled', false);
					$("#nombreTarjeta").attr('disabled', false);
					$("#tipoCobro").attr('disabled', false);
					$("#relacionT").attr('disabled', false);
					$("#relacionA").attr('disabled', false);
					$('#tipoCobro').val("0").selected = true;

					$('#imprimir').hide();
					$("#tarjetaDebID").focus();
				}
			});		
		
		}
	}
	
	function consultaTarjetasPorCtaJS(){
		var cuentaAhoID = $("#cuentaAhoID").val();
			if (cuentaAhoID != ''){
				var params = {};
					params['tipoLista'] = 16;
					params['cuentaAhoID'] = cuentaAhoID;
					
					$.post("gridTarDebConsulta.htm", params, function(data){
				    if(data.length >0) {
						$('#gridTarDebConsulta').html(data);
						$('#gridTarDebConsulta').show();
				    	}else{
							$('#gridTarDebConsulta').html("");
							$('#gridTarDebConsulta').show();
				    		}
					});
			}else{
				$('#gridTarDebConsulta').hide();
				$('#gridTarDebConsulta').html('');

				}
	}

	
	function validaEmpresaID() {
		 identificador=0;
		var numEmpresaID = 1;
		var tipoCon = 1;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
			if (parametrosSisBean != null) {
					 if(parametrosSisBean.tarjetaIdentiSocio=="S"){
						    identificador=1;
						}else{
							 identificador=0;
						}
				
			}
		});
	}
	
	
function consultaParamCaja(){
	var numEmpresaID = 1;
	var tipoCon = 1;
	var ParametrosCajaBean = {
			'empresaID'	:numEmpresaID
	};
		
	parametrosCajaServicio.consulta(tipoCon,ParametrosCajaBean,function(parametros) {
		if (parametros != null) {
			if(parametros.permiteAdicional == 'N'){
				deshabilitaControl('relacionA');
			}
			else{
				habilitaControl('relacionA');
			}
		}

	});
}
	
	
});//fin

function Validador(e) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46) {
		if (key==8|| key == 46)	{ 
			return true;
		}
		else
		return false;
	}
}
// función para cargar los valores de la lista recibe el
// el control que es el campo donde secargara el valor y el valorCompleto es un valor extra. que se podra usar en cualquier campo
function cargaValorListaTarjetaDeb(control, valor,valorCompleto) {	
	consultaSesion();
	jqControl = eval("'#" + control + "'");
	$(jqControl).val(valor);
	$(jqControl).focus();
	setTimeout("$('#cajaLista').hide();", 200);
	$('#numeroTar').val(valorCompleto);
}


function funcionExitoTransaccion (){
	$('#imprimir').show();
	deshabilitaBoton('procesar','submit');
	var cuentaAhoID = $("#cuentaAhoID").val();
	if (cuentaAhoID != ''){
		var params = {};
			params['tipoLista'] = 16;
			params['cuentaAhoID'] = cuentaAhoID;
			
			$.post("gridTarDebConsulta.htm", params, function(data){
		    if(data.length >0) {
				$('#gridTarDebConsulta').html(data);
				$('#gridTarDebConsulta').show();
				
		    	}else{
					$('#gridTarDebConsulta').html("");
					$('#gridTarDebConsulta').show();
		    		}
			});
	}else{
		$('#gridTarDebConsulta').hide();
		$('#gridTarDebConsulta').html('');

		}
	
}

function funcionFalloTransaccion (){

}

// funcion que limpia el formulario

function limpiarFormularioAsociaTarjeta(){
	$('#tarjetaDebID').val('');
	$('#nombreTarjeta').val('');
	$('#cuentaAhoID').val('');
	$('#tipoCuentaID').val('');
	$('#descripcionTipoCuenta').val('');
	$('#nombreTarjeta').val('');	

}




