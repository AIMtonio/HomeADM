$(document).ready(function() {
	esTab = false;

//	Definicion de Constantes y Enums
	var catTipoTransaccionCtaAho = {
			'grabar':1
	};

	var catTipoConsultaCtaFirma = {
			'principal':1,
			'foranea':2
	};

	var serverHuella = new HuellaServer({
		fnGrabarHuella : function(datos){
			mensajeSis(datos.mensajeRespuesta);
			$('#cuentaAhoID').focus();
			$('#cuentaAhoID').blur();
		}
	});

//	------------ Metodos y Manejo de Eventos -----------------------------------------


	deshabilitaBoton('registro','button');
	$('#cuentaAhoID').focus();

	$(':text').focus(function() {
		esTab = false;
	});


	var parametrosBean = consultaParametrosSession();
	var funcionHuella = parametrosBean.funcionHuella;

	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma',
					'mensaje', 'true','cuentaAhoID','funcionResultadoExitoso','funcionResultadoFallido');

	}

	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});



	$('#registro').click(function(){
		funcionMostrarFirma($('#cuentaAhoID').val(),$('#nombreCliente').val(),$('#tipoCuenta').val());
	});

	$('#cuentaAhoID').blur(function() {
			consultaCtaAho(this.id);
	});

	$('#cuentaAhoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#cuentaAhoID').val();
			lista('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}
	});

//	------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			cuentaAhoID: 'required'
		},

		messages: {
			cuentaAhoID: 'Especifique la Cuenta de Ahorro'
		}
	});


//	------------ Validaciones de Controles -------------------------------------
	//Funcion que consulta la cuenta de ahorro indicada
	function consultaCtaAho(control) {
		var numCta = $('#cuentaAhoID').val();
		var tipConCampos= 4;
		var CuentaAhoBeanCon = {
				'cuentaAhoID'	:numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCta != '' && !isNaN(numCta) ){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){
					$('#tipoCuenta').val(cuenta.descripcionTipoCta);
					$('#cuentaAhoID').val(cuenta.cuentaAhoID);
					$('#numCliente').val(cuenta.clienteID);
					consultaClientePantalla('numCliente');
					consultaClienteEstatus('numCliente');
					consultaFirmantes();
				}else{
					mensajeSis("No Existe la cuenta de ahorro");
					$('#tipoCuenta').val("");
					$('#numCliente').val("");
					$('#nombreCliente').val("");
					$('#cuentaAhoID').val("");
					$('#cuentaAhoID').focus();
					$('#gridFirmantes').html("");
					$('#gridFirmantes').hide();
					deshabilitaBoton('registro','button');
				}
			});
		}else{
			if(isNaN(numCta) && esTab){
				mensajeSis("No Existe la cuenta de ahorro");
				$('#tipoCuenta').val("");
				$('#numCliente').val("");
				$('#nombreCliente').val("");
				$('#cuentaAhoID').val("");
				$('#cuentaAhoID').focus();
				$('#gridFirmantes').html("");
				$('#gridFirmantes').hide();
				deshabilitaBoton('registro','button');
			}
		}
	}

	//Funcion que consulta el cliente relacionado con la cuenta de ahorro
	function consultaClientePantalla(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente =5;
		var rfc = ' ';
		var tipoFisica = 'FISICA';
		var tipoMoral	= 'MORAL';
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
				if(cliente!=null){
					var tipo = (cliente.tipoPersona);
					if(tipo=="F"){
						$('#nombreCliente').val(cliente.nombreCompleto);
					}
					if(tipo=="M"){
						$('#nombreCliente').val(cliente.razonSocial);
					}
					if(tipo=="A"){
						$('#nombreCliente').val(cliente.nombreCompleto);
					}

				}else{
					mensajeSis("No Existe el Cliente");
					$('#nombreCliente').val("");
					$(jqCliente).focus();
					$('#gridFirmantes').html("");
					$('#gridFirmantes').hide();
					deshabilitaBoton('registro','button');
				}
			});
		}
	}

	function consultaFirmantes(){
		var params = {};
		params['tipoLista'] = catTipoConsultaCtaFirma.foranea;
		params['cuentaAhoID'] = $('#cuentaAhoID').val();
		params['personaID'] = "";
		$.post("gridFirmantes.htm", params, function(data){
			if(data.length >0) {
				$('#gridFirmantes').html(data);
				$('#gridFirmantes').show();
				// si la lista devolvio personas relacionadas, se muestra el boton de imprimir
				if($('#numeroPersonasRegistradas').asNumber()>0 ){
						if($('#estatus').val() =="I"){
							mensajeSis("El Cliente se Encuentra Inactivo");
							deshabilitaBoton('registro','button');
							$('#cuentaAhoID').focus();
						}else
							if(funcionHuella=="S"){
								habilitaBoton('registro','button');
							}else{
					  			deshabilitaBoton('registro','button');
					  		}

				}else{
					if($('#numeroPersonasRegistradas').asNumber()==0){
						mensajeSis("No Existen Firmantes");
						deshabilitaBoton('registro','button');
						$('#cuentaAhoID').focus();
					}
				}
			}else{
				$('#gridFirmantes').html("");
				$('#gridFirmantes').show();
				deshabilitaBoton('registro','button');
			}

		});
	}


	function consultaClienteEstatus(idControl) {
		var jqClienteH  = eval("'#" + idControl + "'");
		var numClienteH = $(jqClienteH).val();
		if (numClienteH != '' && !isNaN(numClienteH)) {
				clienteServicio.consulta(1,numClienteH,function(clienteH) {
					if (clienteH != null) {
						$('#estatus').val(clienteH.estatus);
					} else {
						limpiaForm($('#formaGenerica'));
						mensajeSis("No Existe el Cliente");
						$('#numCliente').focus();
						$('#numCliente').select();
						$('#estatus').val("");

					}
				});
		}
	}


	function funcionMostrarFirma(idCuenta,nomCliente,nomCta){
		$('#apletHuella').width(800);
		$('#apletHuella').height(700);
		var firmanteBeanCon = {
				'cuentaAhoID' : idCuenta
		};
		if(!serverHuella.estaConectado){
            mensajeSis("La aplicación de Huella Digital no se está ejecutando en este equipo."+
                         " Revise que la aplicación se encuentre activa y vuelva a intentarlo");
            return false;
        }

		cuentasFirmaServicio.lista(catTipoConsultaCtaFirma.foranea, firmanteBeanCon, function(firmantesLista){

			for (var i = 0; i < firmantesLista.length; i++){
				if(i == 0){
					serverHuella.enrolamientoCuenta(
										firmantesLista[i].nombreCompleto,
                						idCuenta,
                						nomCta,
                				 		firmantesLista[i].personaID,
                				 		firmantesLista[i].dedoHuellaUno,
                				 		firmantesLista[i].dedoHuellaDos,
                				 		firmantesLista[i].tipoFirmante );
				}else{
					serverHuella.cargaFirmantes(
                                                    firmantesLista[i].nombreCompleto,
                                                    firmantesLista[i].tipoFirmante,
                                                    firmantesLista[i].personaID,
                                                    firmantesLista[i].dedoHuellaUno,
                                                    firmantesLista[i].dedoHuellaDos,
                                                    firmantesLista[i].huellaUno,
                                                    firmantesLista[i].huellaDos
                                                );
				}


			}


		 });
	}


});


//-- funciones de exito y fallido
function funcionResultadoExitoso(){
	deshabilitaBoton('registro','button');
}
function funcionResultadoFallido(){
	deshabilitaBoton('registro','button');}
