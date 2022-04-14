	var cargoCuenta			= 1;
	var devolucionGarLiq	= 5;
	var desemboCred 		= 7;
	var aplicaPolizaRiesgo 	= 9;
	var tranferenciaCuenta	=10;
	var devAportacionSocial	=13;
	var aplicaSegVidaAyuda	=15;
	var pagoServifun		=25;
	var cobroApoyoEscolar	=26;
	var haberesExmenor		=40;
	
	var varAppletHuella = document.apletHuellaName;
	
	var catGrabaTransaccion={
		'grabar':1	
	};
	var catListaCombo={
			'combo':3	
		};
	
	var funcionHuella = parametroBean.funcionHuella;
	var firmasVerificadas = "FALSE"; 	
	$('#huellaRequiere').val("");
	


	function cierraVerificacionHuella(resultado) {
		$('#apletHuella').width(1);
		$('#apletHuella').height(1);
		if(firmasVerificadas == "TRUE"){
		  $('#huellaRequiere').val('N');	
		  $('#requiereFirmante').val('N');
		}else{
			$('#huellaRequiere').val('S');
			$('#requiereFirmante').val('S');
			}
	}
	
	function informaResultadoGrabarHuella(mensajeResultado) {
		varAppletHuella.informaResultadoGrabarHuella(mensajeResultado);
	}

	function grabaHuella(tipoPersona, personaID, manoSeleccionada, dedoSeleccionado, huella) {
				
	    var huellaArray = [];
	    for(var i = 0, n = huella.length; i < n;) {
	    	huellaArray[i] = huella[i];
	    }		
		
	    
		var huellaDigitalBean ={
				'tipoPersona' : tipoPersona,
				'personaID' : personaID,
				'manoSeleccionada' : manoSeleccionada,
				'dedoSeleccionado' : dedoSeleccionado,
				'huella' : huellaArray
		};	
				
		huellaDigitalServicio.grabaTransaccion(catGrabaTransaccion.grabar, huellaDigitalBean, function(mensajeTransaccion){
			  var mensajeRespuesta;
			  if (mensajeTransaccion != null) {			    
				  mensajeRespuesta = mensajeTransaccion.descripcion;
			  }else{
				  mensajeRespuesta = "La Huella Digital no pudo Ser Registrada en SAFI. Web";
			  }
			  informaResultadoGrabarHuella(mensajeRespuesta);
			 });				
	}

	//Funcion para mostrar los firmantes
	function funcionMostrarFirma(idCuenta,nomCliente,nomCta){
			var firmanteBeanCon = {
					'cuentaAhoID' : idCuenta
			};
			 if (varAppletHuella != null){
			cuentasFirmaServicio.listaHuellasCombo(catListaCombo.combo, firmanteBeanCon, function(firmantesLista){
				  if(firmantesLista != null){
					  if(firmantesLista.length >= 1){
					  	$('#apletHuella').width(800);
						$('#apletHuella').height(700);
						$('#requiereFirmante').val('N');
					  }
					  	var Verificacion='VERIFICACION';
					    varAppletHuella.estableceModoOperacion(Verificacion,nomCliente,idCuenta, nomCta);
						for (var i = 0; i < firmantesLista.length; i++){
							varAppletHuella.cargaFirmantes(firmantesLista[i].nombreCompleto, firmantesLista[i].tipoFirmante,
														   firmantesLista[i].personaID, firmantesLista[i].dedoHuellaUno,
														   firmantesLista[i].dedoHuellaDos,
														   firmantesLista[i].huellaUno, firmantesLista[i].huellaDos);
		
						}
						$('#requiereFirmante').val('N');

				  }else{
			  		  mensajeSis("La Cuenta No tiene Firmantes Favor de Verificar");
					  $('#requiereFirmante').val('S');
					  $('#apletHuella').width(1);
					  $('#apletHuella').height(1);
				  }
			 });	
			 }else{				  
				    mensajeSis("No se ha Cargado Correctamente el Dispositivo de Huella");

			 }
		}
	
	
	function funcionMostrarFirmaCliente(nomCliente,idCuenta){
		var IDCta='N/A';
		var nomCta="";
		var TipoPersona="C";
	
		var CteBeanCon = {
				'personaID' : idCuenta
		};
		 if (varAppletHuella != null ) {
		huellaDigitalServicio.consulta(1, CteBeanCon, function(CteBean){
			  if (CteBean != null){
			  var Verificacion='VERIFICACION';
				$('#apletHuella').width(800);
				$('#apletHuella').height(700);
				
		    varAppletHuella.estableceModoOperacion(Verificacion,nomCliente,IDCta, nomCta);
				varAppletHuella.cargaFirmantes(nomCliente,TipoPersona,
						CteBean.personaID,  CteBean.dedoHuellaUno,CteBean.dedoHuellaDos,
						CteBean.huellaUno,CteBean.huellaDos);
			}else{
				$('#huellaRequiere').val('N');	
				$('#apletHuella').width(1);
				$('#apletHuella').height(1);
			}
		 });
		 }else{	
			    mensajeSis("No se ha Cargado Correctamente el Dispositivo de Huella");
			  }
	}

		//función para consultar si el cliente ya tiene huella digital registrada
		function muestraFirma(){
			idCuenta=ctaOperacion();
			var tipConCampos= 4;
			var CuentaAhoBeanCon = {
					'cuentaAhoID'	:idCuenta,
					'clienteID':''
				};
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){	
							var numCliente = cuenta.clienteID;											
							clienteServicio.consulta(1,numCliente,function(cliente) {
								funcionMostrarFirma(idCuenta,cliente.nombreCompleto,cuenta.descripcionTipoCta);
							});
							
						}else{
								clienteServicio.consulta(1,idCuenta,function(cliente) {		
								funcionMostrarFirmaCliente(cliente.nombreCompleto,idCuenta);});
						}
				});	
		}
		
		
		//Operaciones que requieren de autentificación de Huella Digital 
			function ctaOperacion(){
	NumeroCta='';
	switch($('#tipoOperacion').asNumber()){
		case cargoCuenta :			
			NumeroCta=$('#cuentaAhoIDCa').val();	
		break;
		case devolucionGarLiq:
			NumeroCta=$('#cuentaAhoIDDG').val();
		break;			
		case desemboCred :
			NumeroCta=$('#cuentaAhoIDDC').val();
		break;
		case tranferenciaCuenta :
			NumeroCta=$('#cuentaAhoIDT').val();
		break;
		
		case devAportacionSocial :
			NumeroCta=$('#clienteIDDAS').val(); //Se utiliza al cliente ya que en la pantalla no se muestra la cuenta
		break;
		
		case aplicaSegVidaAyuda :
			NumeroCta=$('#clienteIDASVA').val();//Se utiliza al cliente ya que en la pantalla no se muestra la cuenta
		break;
		case pagoServifun :
			NumeroCta=$('#clienteServifunID').val();//
		break;
		case haberesExmenor :
			NumeroCta=$('#clienteIDMenor').val();//Se utiliza al cliente ya que en la pantalla no se muestra la cuenta
		break;
		
		case cobroApoyoEscolar :
			NumeroCta=$('#clienteIDApoyoEsc').val();//Se utiliza al cliente ya que en la pantalla no se muestra la cuenta
		break;
	}
	return NumeroCta;
}
			