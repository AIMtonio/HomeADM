
$(document).ready(function (){
	esTab = true;
	$('#importar').focus();
	$('#importar').attr("checked",true);
	$('#habilitadoProsa').attr("checked",true);
	$('#trServiceCode').hide();
	$('#trLoteTarVirtual').hide();
	parametros = consultaParametrosSession();	
	$('#fechaRegistro').val(parametroBean.fechaSucursal); // fechas actual del sistema
	$('#sucursalID').val(parametroBean.numeroUsuario); // usuario de sesion

	var catListaTipoTar = {
		'activos' : 5
	};
	
	var catListaServiceCode = {
			'serviceCode' : 9
	};
	
	var catTipoTransaccion = {  
			'Validacion':'1',
			'altaTarjeta':'4',
			'altaLote':'9',
			'altaLoteSAFI':'10'
	};

	var catTipoConsulBitacora = {  
			'conBitacoraFallidos':'1',
			'conBitacoraExito':'2'
	};

	var catTipoConsulLote = {
		'loteTarjetas' : '22'
	};
	var catListas = {
		'sucursal' 	: 6,
		'folios'	: 3,
		'cajas'		: 6,
	}
	
	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	agregaFormatoControles('formaGenerica');

	//------------ Metodos y Manejo de Eventos ----------
	deshabilitaBoton('procesar', 'submit');
	deshabilitaBoton('verBitacora', 'submit');
	deshabilitaBoton('cancelar', 'submit');
	$('#tipTarjeta').hide();
	$('#tipoTarjetaDebID').hide();
	$('#numTarjeta').hide();
	$('#numTarjetas').hide();
	$('#sucursal').hide();
	$('#sucursalSolicita').hide();
	$('#desSucursal').hide();
	$('#adicional').hide();
	$('#esAdicional').hide();

	llenarComboTipoTarjeta();
	llenarComboServiceCode();

	$.validator.setDefaults({
		submitHandler: function(event) { 	

			if( $('#generar').attr('checked') ){

				if($('#desSucursal').val()!='')	{
					if($('#numTarjetas').val()==0){
				    	alert("El número de tarjetas a generar debe ser mayor a cero");
				   	    $('#numTarjetas').focus();
				  	    $('#numTarjetas').val('');
				  	    return false;
		    		}
				}else{
					alert("Indique una sucursal");
					$('#sucursalSolicita').focus();
					$('#sucursalSolicita').val('');
					return false;
				}	
			}
			inicializaLimpia($('#formaGenerica'));
			deshabilitaBoton('procesar', 'submit');
			
		}
	});

	agregaFormatoControles('formaGenerica');

	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','loteDebSAFIID',
					'funcionExito','funcionError');
		}
	});

	$('#sucursalSolicita').blur(function (){ consultaSucursal(this.id); });

	document.getElementById("numTarjetas").onkeyup = function() {soloNum(this,this.id)};
	
	$('#sucursalSolicita').bind('keyup',function(e) {
		lista('sucursalSolicita', '1', '1', 'nombreSucurs', $('#sucursalSolicita').val(), 'listaSucursales.htm');

	});
	
	$('#tipoTarjetaDebID').bind('keyup',function(e){
		lista('tipoTarjetaDebID', '1', '1', 'tipoTarjetaDebID', $('#tipoTarjetaDebID').val(), 'tipoTarjetasDevLista.htm');
	});
	
	$('#generar').click(function() {	
		$('#importar').attr("checked",false);
		deshabilitaBoton('cancelar', 'submit');
		mostarGrid();
	});
	$('#importar').click(function() {	
		$('#generar').attr("checked",false);
		deshabilitaBoton('cancelar', 'submit');
		mostarGrid();
	});
	
	$('#habilitadoSAFI').click(function() {	
		$('#habilitadoProsa').attr("checked",false);
		deshabilitaBoton('cancelar', 'submit');
		mostarGrid();
	});
	$('#habilitadoProsa').click(function() {	
		$('#habilitadoSAFI').attr("checked",false);
		deshabilitaBoton('cancelar', 'submit');
		mostarGrid();
	});

	$('#cancelar').click(function(){
		$('#importar').focus();
		$('#regCorrectos').val("");
		$('#regIncorrectos').val("");
		$('#ruta').val("");
		$('#bitCargaID').val("");
		$('#importar').val("");
		$('#generar').val("");
		$('#numTarjetas').val("");
		$('#tipoTarjetaDebID').val("");
		$('#numeroServicio').val("");
		$('#sucursalSolicita').val("");
		$('#desSucursal').val('');
		$('#esAdicional').val("");
		$('#vigencia').val('');
		$('#gridBitacoraCargaLote').html("");
		deshabilitaBoton('verBitacora', 'submit');
		deshabilitaBoton('procesar', 'submit');
		deshabilitaBoton('cancelar', 'submit');
		inicializaLimpia($('#formaGenerica'));
		

	});

	$('#procesar').click(function(){
		
		if($('#importar').is(':checked') && $('#habilitadoProsa').is(':checked')){	
			$('#tipoTransaccion').val(catTipoTransaccion.altaTarjeta);
			deshabilitaBoton('cancelar', 'submit');
			inicializaLimpia($('#formaGenerica'));
			$('#regCorrectos').val("");
			$('#regIncorrectos').val("");
			$('#ruta').val("");
			$('#gridBitacoraCargaLote').html("");
			
			$('#importar').attr('checked')== false;
			$('#generar').attr('checked')== false;
		}
		
		if($('#generar').is(':checked') && $('#habilitadoProsa').is(':checked')){	
			$('#tipoTransaccion').val(catTipoTransaccion.altaLote);
			deshabilitaBoton('cancelar', 'submit');
			inicializaLimpia($('#formaGenerica'));
			$('#regCorrectos').val("");
			$('#regIncorrectos').val("");
			$('#ruta').val("");
			$('#gridBitacoraCargaLote').html("");
			
			$('#importar').attr('checked')== false;
			$('#generar').attr('checked')== false;
		}
		
		if($('#generar').is(':checked') && $('#habilitadoSAFI').is(':checked')){	
			$('#tipoTransaccion').val(catTipoTransaccion.altaLoteSAFI);
			deshabilitaBoton('cancelar', 'submit');
			inicializaLimpia($('#formaGenerica'));
			$('#regCorrectos').val("");
			$('#regIncorrectos').val("");
			$('#ruta').val("");
			$('#gridBitacoraCargaLote').html("");
			
			$('#importar').attr('checked')== false;
			$('#generar').attr('checked')== false;
		}
		
		
	});

	$('#adjuntar').click(function() {
		var tipocheck = 0;
		$('#regCorrectos').val("");
		$('#regIncorrectos').val("");
		$('#ruta').val("");
		$('#bitCargaID').val("");
		$('#gridBitacoraCargaLote').html("");
		if($('#importar').attr('checked')== false && $('#generar').attr('checked')==false){
			alert(" Seleccionar alguna opción para lote de tarjetas");
			$('#importar').focus();
		}else{
			if($('#importar').attr('checked')== true){
				tipocheck= 2;
				subirArchivos(tipocheck);	
			}
			else{
				tipocheck= 3;
				subirArchivos(tipocheck);
			}
		}
		deshabilitaBoton('procesar', 'submit');
		deshabilitaBoton('verBitacora', 'submit');
		deshabilitaBoton('cancelar', 'submit');
	});


	$('#verBitacora').click(function() {
		consultaGridBitacoraLote();
	});

	$('#numTarjetas').blur(function() {

			if ($('#tipoTarjetaDebID').val() == '' && esTab==true){
				alert("Seleccione un tipo de tarjeta");
				$('#tipoTarjetaDebID').focus();
				$('#numTarjetas').val('');
			}
			else if ($('#numTarjetas').val() == '' && esTab==true){
				alert("Ingrese un número de tarjetas a generar");
				$('#numTarjetas').focus();
				$('#numTarjetas').val('');
			}
			else if (esTab==true){
				soloNum(this,this.id);			
			}

			
		});
	
	
	$("#esAdicional").change(function() {
		if($('#habilitadoProsa').is(':checked')){
			habilitaBoton('procesar', 'submit');
			$('#procesar').focus();
			llenarFolios();
		}
	});


	$("#esVirtual").change(function() {
		if($('#habilitadoSAFI').is(':checked')){
			habilitaBoton('procesar', 'submit');
			$('#procesar').focus();
			llenarFolios();
		}
	});
	
	$('#formaGenerica').validate({
		rules: {

			tipoTarjetaDebID : {
				required : function(){ return $('#generar').attr('checked') == true }
			},
			sucursalSolicita : {
				required :  function(){ return $('#generar').attr('checked') == true }
			},
			numTarjetas : {
				required :  function(){ return $('#generar').attr('checked') == true }
			},
			esAdicional : {
				required :  function(){ return $('#generar').attr('checked') == true }
			},
			numeroServicio: {
				required: function(){return $('#habilitadoSAFI').attr('checked') == true }
			},
			esVirtual:{
				required: function(){return $('#habilitadoSAFI').attr('checked') == true}
			}
		},	
		messages: {
			tipoTarjetaDebID: {
					required: "Seleccione un producto de tarjeta"
			},
			sucursalSolicita: {
					required: "Ingrese un sucursal"
			},
			numTarjetas: {
					required: "Ingrese un número de tarjetas"
			},
			esAdicional: {
					required: "Seleccione una opción"
			},
			vigencia:{
				required: "Seleccione la vigencia"
			}
			,
			numeroServicio: {
				required: "Seleccione un código de servicio"
			},
			esVirtual:{
				required: "Seleccione una opción de tarjetas virtuales"
			}
		}		
	});

	

	function mostarGrid() {
		
		if($('#importar').is(':checked')){			
				$('#tipTarjeta').hide(); 
				$('#tipoTarjetaDebID').hide();
				$('#trServiceCode').hide();
				$('#numTarjeta').hide();
				$('#numTarjetas').hide();
				$('#sucursal').hide();
				$('#sucursalSolicita').hide();
				$('#desSucursal').hide();
				$('#adicional').hide();
				$('#esAdicional').hide();
				$('#tipoTarjetaDebID').val('');
				$('#numTarjetas').val('');
				$('#sucursalSolicita').val('');
				$('#desSucursal').val('');
				$('#esAdicional').val('');
				$('#rutalb').show();
				$('#adjuntar').show();
				$('#ruta').show();	
				$('#regisCorrectos').show();
				$('#regCorrectos').show();			
				$('#regisIncorrectos').show();	
				$('#regIncorrectos').show();	
				$('#cancelar').show();	
				$('#procesar').show();	
				$('#verBitacora').show();
				$('#trLoteTarVirtual').hide();
				deshabilitaBoton('procesar', 'submit');				
			}
				
			if($('#generar').is(':checked')){		
				$('#rutalb').hide();
				$('#adjuntar').hide();
				$('#ruta').hide();	
				$('#regisCorrectos').hide();
				$('#regCorrectos').hide();			
				$('#regisIncorrectos').hide();	
				$('#regIncorrectos').hide();
				$('#ruta').val('');
				$('#regCorrectos').val('');
				$('#regIncorrectos').val('');	
				$('#cancelar').hide();	
				$('#procesar').show();	
				$('#verBitacora').hide();
				$('#tipTarjeta').show();
				$('#tipoTarjetaDebID').show();
				$('#numTarjeta').show();
				$('#numTarjetas').show();
				$('#sucursal').show();
				$('#sucursalSolicita').show();
				$('#desSucursal').show();
				$('#adicional').show();
				$('#esAdicional').show();
				deshabilitaBoton('procesar', 'submit');
			}
			
			if($('#habilitadoSAFI').is(':checked')){
				$('#importar').attr("checked",false);
				$('#generar').attr("checked",true);
				$('#tdImportar').hide();
				$('#tdImportar1').hide();
				$('#rutalb').hide();
				$('#adjuntar').hide();
				$('#ruta').hide();	
				$('#regisCorrectos').hide();
				$('#regCorrectos').hide();			
				$('#regisIncorrectos').hide();	
				$('#regIncorrectos').hide();
				$('#ruta').val('');
				$('#regCorrectos').val('');
				$('#regIncorrectos').val('');	
				$('#cancelar').hide();	
				$('#procesar').show();	
				$('#verBitacora').hide();
				$('#tipTarjeta').show();
				$('#tipoTarjetaDebID').show();
				$('#numTarjeta').show();
				$('#numTarjetas').show();
				$('#sucursal').show();
				$('#sucursalSolicita').show();
				$('#desSucursal').show();
				$('#adicional').show();
				$('#esAdicional').show();
				$('#trServiceCode').show();
				$('#trLoteTarVirtual').show();
				deshabilitaBoton('procesar', 'submit');
			}
			
			if($('#habilitadoProsa').is(':checked')){
				$('#tdImportar1').show();
				$('#tdImportar').show();
				$('#trServiceCode').hide();
				$('#trLoteTarVirtual').hide();
			}
	}

	function llenarComboTipoTarjeta(){
		var tarDebBean = {
				'tipoTarjeta' :'D',
				'tipoTarjetaDebID' : ''
		};
		dwr.util.removeAllOptions('tipoTarjetaDebID');
		dwr.util.addOptions('tipoTarjetaDebID', {'':'SELECCIONAR'});
		tipoTarjetaDebServicio.listaCombo(catListaTipoTar.activos, tarDebBean, function(tipoTarjetaDebIDs){
			dwr.util.addOptions('tipoTarjetaDebID', tipoTarjetaDebIDs, 'tipoTarjetaDebID', 'descripcion');
		});
	}
	
	function llenarComboServiceCode(){
		var tarDebBean = {
				'tipoTarjeta' :'',
				'tipoTarjetaDebID' : ''
		};
		dwr.util.removeAllOptions('numeroServicio');
		dwr.util.addOptions('numeroServicio', {'':'SELECCIONAR'});
		tipoTarjetaDebServicio.listaCombo(9,tarDebBean ,function(beanLista){
			dwr.util.addOptions('numeroServicio', beanLista, 'numeroServicio', 'descripcion');
		});
	};

	function soloNum(campo,idcampo){
		if(esTab==true){
			if($('#numTarjetas').val()==0){
	    	alert("El número de tarjetas a generar debe ser mayor a cero");
	   	    $('#numTarjetas').focus();
	  	    $('#numTarjetas').val('');
	    	
	    } 
		}
		 
		if (!/^([0-9])*$/.test(campo.value)){
			
	    	alert("Ingrese solo números");
	   	    $('#numTarjetas').focus();
	  	    $('#numTarjetas').val('');
	  	    deshabilitaBoton('procesar', 'submit');
	    } 
	    else{
	    	llenarFolios();
	    	
	    }  
  	}

  	function consultaSucursal(idControl) {	
  	
		var jqSucID = eval("'#" + idControl + "'");
     	var numSucID = $(jqSucID).val();
		var tipoConsulta = 2;
		var CajasBeanCon1 = {
			   'sucursalID':numSucID
		 };
		setTimeout("$('#cajaLista').hide();", 200);	
		if (esTab==true ){
		if (numSucID != '' && !isNaN(numSucID)) {			
			sucursalesServicio.consultaSucursal(tipoConsulta,numSucID, function(sucursal) {	
				if (sucursal != null) {
					deshabilitaControl('desSucursal');
					$('#desSucursal').val(sucursal.nombreSucurs);
					
				} else {					
					alert("La Sucursal No Existe.");
					$('#sucursalSolicita').focus();
					$('#sucursalSolicita').val('');	
					$('#desSucursal').val('');	
				}
			});
		}
		else{
			alert("Indique una Sucursal.");
			$('#sucursalSolicita').focus();
			$('#sucursalSolicita').val('');	
			$('#desSucursal').val('');	
		}
		}
	}

  	
  function llenarFolios(){
  		var conNumTarjeta=22;
  		var conNumTarSAFI = 23;
  		var TarjetaBeanCon = {
				'loteDebitoID' : '0'
			};
  		
  		if($('#habilitadoSAFI').is(':checked')){
  			conNumTarjeta = conNumTarSAFI;
  		}
  		
		tarjetaDebitoServicio.consulta(conNumTarjeta,TarjetaBeanCon,function(tarjetaDebito) {
			if(tarjetaDebito!=null){
				if(tarjetaDebito.folioFinal==''){
					var max=0;
				}else{
					var max=parseInt(tarjetaDebito.folioFinal);
					var inicial =  parseInt(max)+ parseInt(1);
					var folfin = $('#numTarjetas').asNumber() + parseInt(max);
					$('#folioInicial').val(inicial);
					$('#folioFinal').val(folfin);
					var loteTarDebSAFI=parseInt(tarjetaDebito.loteDebitoID);
					var loteTarDebSAFISig = parseInt(loteTarDebSAFI) + parseInt(1);
					$('#loteDebitoSAFIID').val(loteTarDebSAFISig);
				}
				
			}
			else{
				var max=0;
				var inicial=1;
				var folfin = $('#numTarjetas').asNumber() + parseInt(max);
				$('#folioInicial').val(inicial);
				$('#folioFinal').val(folfin);

			}

		});
	}

	function subirArchivos(tipocheck) {
		var tipoboton = tipocheck;
		var url ="creaImpotTarjetasSubirArch.htm"+
		"?fechaRegistro="+$('#fechaRegistro').val()+'&tipocheck='+tipoboton;
		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

		ventanaArchivosCuenta = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
				"left="+leftPosition+
				",top="+topPosition+
				",screenX="+leftPosition+
				",screenY="+topPosition);	
		//$.blockUI({message: "Favor de terminar el proceso"});
		
	}

	function consultaGridBitacoraLote(){
		if($('#loteDebitoID').val()!= ""){

			var params = {};
			var lote=$('#loteDebitoID').val();
			$('#bitCargaID').val(lote);
			params['tipoLista'] = catTipoConsulBitacora.conBitacoraFallidos;
			params['bitCargaID'] =$('#bitCargaID').val();

			$.post("bitacoraCargaLoteGridVista.htm", params, function(data){		
				if(data.length >0) {
					$('#gridBitacoraCargaLote').html(data);
					$('#gridBitacoraCargaLote').show();
					
				}else{
					$('#gridBitacoraCargaLote').html("");
					$('#gridBitacoraCargaLote').show(); 
				}
			});
		}	
	}


function inicializaLimpia(limforma) {
	
	$(':input', limforma).each(function() {
		var type = this.type;
		if (type == 'select')
			this.selectedIndex = -1;
	});
}



});
function limpiar(){
		$('#regisCorrectos').val('');
		$('#regIncorrectos').val('');
		$('#tipoTarjetaDebID').val('');
		$('#numeroServicio').val('');
		$('#sucursalSolicita').val('');
		$('#desSucursal').val('');
		$('#numTarjetas').val('');
		$('#esAdicional').val('');
		$('#vigencia').val('');
		$('#folioInicial').val('');
		$('#folioFinal').val('');
		$('#tipoTarjetaDebID').focus();
		$('#numeroServicio').focus();
		$('#esVirtual').val('');
	}
function deshabilitaProcesar(){	
	if($('#regCorrectos').val()==0 && $('#regIncorrectos').val()!=0){
		deshabilitaBoton('procesar', 'submit');
		habilitaBoton('verBitacora', 'submit');
		habilitaBoton('cancelar', 'submit');
	}else{
		habilitaBoton('procesar', 'submit');
		deshabilitaBoton('verBitacora', 'submit');
		habilitaBoton('cancelar', 'submit');
	}
	if($('#regCorrectos').val()==0 && $('#regIncorrectos').val()==0){
		deshabilitaBoton('procesar', 'submit');
		deshabilitaBoton('verBitacora', 'submit');
		deshabilitaBoton('cancelar', 'submit');
	}
}

function  mostrarDatosResultado(){
	var lote = $('#resultadoArchivoTran').val();
	datos = lote.split('|');
	$('#loteDebitoID');val(datos[0]);
	$('#regCorrectos').val(datos[1]);
	$('#regIncorrectos').val(datos[2]);

}

/**
 * Funcion de  de exito que se ejecuta cuando despues de grabar
 * la transaccion y esta fue exitosa.
 */
function funcionExito(){
	if($('#habilitadoSAFI').is(':checked') && ($('#esVirtual').val() == 'N')){
		//Solicita al controlador la descarga del layout
		var pagina = 'ReporteTarDebTipos.htm?tipoReporte='+2+'&loteDebSAFIID='+$('#loteDebitoSAFIID').val();
		window.open(pagina,'_blank');
	}
	limpiar();
}

/**
 * Funcion de error que se ejecuta cuando después de grabar
 * la transacción marca error.
 */
function funcionError(){
	
}

