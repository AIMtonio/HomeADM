		var catEstatusTD ={
			'expirada'	: 10,
			'cancelada' : 9,		
			'bloqueada' : 8,
			'activa'	:7,
			'asociada'	:6
		};

	//Definicion de Constantes y Enums  		
		var catTipoTranAsociaCeuntaTC = {
	  		'alta':1,
	  		'altaLineaCred':5, 
	  		'altaCuentaClabe' :6 		
	  	};

		var catTipoActAsociaCeuntaTC = {
		  		'asociaCuentasTC':1,
		  	};

	var tarjetaCreditoID;
			// funcion para llenar el combo de Tipos de Tarjeta
		

		function validadorNum(e){
			key=(document.all) ? e.keyCode : e.which;
			if (key < 48 || key > 57){
				if (key==8 || key == 0){
					return true;
				}
				else 
		  		return false;
			}
		}

		function llenaComboTiposTarjetasCred() {
			var tarDebBean = {
					'tipoTarjeta' :'C',
					'tipoTarjetaDebID' : ''
			};

			dwr.util.removeAllOptions('tipoTarjetaDebID');
			dwr.util.addOptions('tipoTarjetaDebID', {"":'SELECCIONAR'});
			tipoTarjetaDebServicio.listaCombo(5, tarDebBean, function(tiposTarjetas){
			dwr.util.addOptions('tipoTarjetaDebID', tiposTarjetas, 'tipoTarjetaDebID', 'descripcion');
			});
		}
		
		function bloqueaCampos() {
			$("#tarjetaDebID").attr('disabled', true);
			$("#diaCorte").attr('disabled', true);
			$("#diaPago").attr('disabled', true);
			$("#tipoPago").attr('disabled', true);
			$("#tipoCorte").attr('disabled', true);
		}

		function desBloqueaCampos() {
			$("#tarjetaDebID").removeAttr('disabled');
			$("#tarjetaDebID").removeAttr('readonly');
			$("#diaCorte").removeAttr('disabled');
			$("#diaPago").removeAttr('disabled');
			$("#tipoPago").removeAttr('disabled');
			$("#tipoCorte").removeAttr('disabled');
			$("#tipoCorte").val('');
			$("#tipoPago").val('');
			$("#tarjetaDebID").val('');
			$("#cuentaClabe").val('');
			$("#diaPago").val('');
			$("#diaCorte").val('');
			$('#gridTarDebConsulta').hide();
			$('#gridTarDebConsulta').html('');
			habilitaBoton('procesar');
			deshabilitaBoton('imprimir');
			

		}


		function consultaProspecto(cliente) {
			var clienteID = $('#clienteID').val();
			setTimeout("$('#cajaLista').hide();", 200);
			if(!isNaN($('#clienteID').val()) && $('#clienteID').val()!=''){
				clienteServicio.consulta(2,clienteID,function(prospectos) {
					if (prospectos !='' && prospectos !=null) {
						$('#nombreCompleto').val(prospectos.nombreCompleto);
						consultaLineaCredito(function(){
							consultaTarjetasPorLinea();	
							$("#tarjetaDebID").focus();
						});		

					}
					else{
						mensajeSis("El Usuario no Existe");
						$('#clienteID').focus();
					}
				});
			}
						
		} 


	// CONSULTA DE LINEA DE CREDITO
		function consultaLineaCredito(callback) {
			var lineaCreditoBean ={
				clienteID : $('#clienteID').val(),
				tipoTarjetaDeb : $('#tipoTarjetaDebID').val()
			}
			setTimeout("$('#cajaLista').hide();", 200);
			lineaTarjetaCreditoServicio.consulta(1,lineaCreditoBean,function(lineaCredito) {
				if (lineaCredito !='' && lineaCredito!=null) {
					if (lineaCredito.estatus=='9') {
						desBloqueaCampos();
						tarjetaCreditoID =lineaCredito.tarjetaCredID;
						$('#tipoTransaccion').val(catTipoTranAsociaCeuntaTC.altaLineaCred);
						deshabilitaBoton('imprimir');
						$('#procesar').val('Procesar');
					}
				   else{	   	
						bloqueaCampos();
						$('#procesar').val('Modificar');
						habilitaBoton('imprimir');
						habilitaBoton('procesar');
						$('#tipoTransaccion').val(catTipoTranAsociaCeuntaTC.altaCuentaClabe);
						$('#tarjetaDebID').val(lineaCredito.tarjetaCredID);
						$('#tipoCorte').val(lineaCredito.tipoCorte);
						$('#tipoPago').val(lineaCredito.tipoPago);
						$('#cuentaClabe').val(lineaCredito.cuentaClabe);
						if (lineaCredito.tipoCorte=='D') {
							$('#diaCorte').val(lineaCredito.diaCorte);
						}

						if (lineaCredito.tipoPago=='D') {
							$('#diaPago').val(lineaCredito.diaPago);
						}
				    }
				}
				else{
					$('#tipoTransaccion').val(catTipoTranAsociaCeuntaTC.altaLineaCred);
					desBloqueaCampos();
					$('#tarjetaDebID').focus();
					$('#procesar').val('Procesar');
					

				}
				callback();	
			});		
			
		} 

	// lista del grid
		function consultaTarjetasPorLinea(){
			var lineaCredID = tarjetaCreditoID;
			var cliente 	= $("#clienteID").val();
			if (lineaCredID != ''){
				var params = {
					tipoLista : 15,
					lineaCreditoID:lineaCredID,
					clienteID : cliente

				};

				$.post("gridTarCredConsulta.htm", params, function(data){
				    if(data.length >0) {
						$('#gridTarDebConsulta').html(data);
						$('#gridTarDebConsulta').show();
						
						if ($('#tarjetaDebID').val()!='') {
							$("#cuentaClabe").focus();
						}
						else{
							$("#tarjetaDebID").focus();
						}
						
				    }
				    else{
						$('#gridTarDebConsulta').html("");
						$('#gridTarDebConsulta').show();
						$("#tarjetaDebID").focus();
			    	}
				});
			}
			else{
				$('#gridTarDebConsulta').hide();
				$('#gridTarDebConsulta').html('');
				$("#clienteID").focus();

			}
		}


	// CONSULTA DE TARJETA DE CREDITO
		function consultaTarjetaCredito() {
			var TarjetaDebitoCon = {
				tarjetaDebID: $('#tarjetaDebID').val(),
				tipoTarjetaDebID: $('#tipoTarjetaDebID').val(),
				
			};
			tarjetaCreditoServicio.consulta(11, TarjetaDebitoCon,function(tarjeta){
				if (tarjeta !='' && tarjeta !=null) {
					$('#tarjetaDebID').val(tarjeta.tarjetaCredID);
					
					if (tarjeta.estatus==catEstatusTD.expirada) {
						mensajeSis("Número de Tarjeta se Encuentra Experida");
						$('#tarjetaDebID').focus();	
						deshabilitaBoton('procesar');
					}
					if (tarjeta.estatus==catEstatusTD.cancelada) {
						mensajeSis("Número de Tarjeta se Encuentra Cancelada");	
						$('#tarjetaDebID').focus();
						deshabilitaBoton('procesar');
					}
					if (tarjeta.estatus==catEstatusTD.bloqueada) {
						mensajeSis("Número de Tarjeta se Encuentra Bloqueada");	
						$('#tarjetaDebID').focus();
						deshabilitaBoton('procesar');
					}
					if (tarjeta.estatus==catEstatusTD.activa) {
						mensajeSis("Número de Tarjeta se Encuentra Activa");	
						$('#tarjetaDebID').focus();
						deshabilitaBoton('procesar');
					}
					if (tarjeta.estatus==catEstatusTD.asociada) {
						mensajeSis("Número de Tarjeta se Encuentra Asiganada");	
						$('#tarjetaDebID').focus();
						deshabilitaBoton('procesar');
					}


				}
				else{
					mensajeSis("Número de Tarjeta No Existe");
					$('#tarjetaDebID').val('');
					$('#tarjetaDebID').focus();
				}
			});
		
		} 



	$(document).ready(function() {
			agregaFormatoControles('formaGenerica');
			$('#tipoTarjetaDebID').focus();
			llenaComboTiposTarjetasCred();
			$("#diaCorte").attr('disabled', true);
			$("#diaPago").attr('disabled', true);
			esTab = true;
			var tab2=false;

			var parametrosBean = consultaParametrosSession();
			$('#fecha').val(parametroBean.fechaSucursal);
			$('#usuarioVerifica').val(parametroBean.numeroUsuario);
			deshabilitaBoton('procesar');
			deshabilitaBoton('imprimir');
			
			

		//LISTA DE CLIENTES

		$('#clienteID').bind('keyup',function(e) { 
				lista('clienteID', '1', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
		 });

		$('#clienteID').blur(function() {
			if ($('#clienteID').val()!='' && $('#clienteID').val()!=null) {
				consultaProspecto($('#clienteID').val());

			}
			else{
				$('#nombreCompleto').val('');
				$('#clienteID').val('');

			}
		});

		$('#tipoTarjetaDebID').change(function() {
			desBloqueaCampos();
			$("#nombreCompleto").val('');
			$("#clienteID").val('');
			$("#procesar").val('Procesar');
			deshabilitaBoton('procesar');
			$("#clienteID").focus();
		});
		$('#tarjetaDebID').change(function() {
			if ($('#tarjetaDebID').val()!='' && $('#tarjetaDebID').val()!=null) {
				consultaTarjetaCredito();

			}
		});

		$('#tipoCorte').change(function() {
			if ($('#tipoCorte').val()=='D' ) {
				$("#diaCorte").removeAttr('disabled');
				$('#diaCorte').focus();	
				$("#diaCorte").val('');
			}
			else{
				$("#diaCorte").attr('disabled', true);
				$("#diaCorte").val('');
			}
		});
		$('#tipoPago').change(function() {
			if ($('#tipoPago').val()=='D') {
				$("#diaPago").removeAttr('disabled');	
				$('#diaPago').focus();
				$("#diaPago").val('');
			}
			else{
				$("#diaPago").attr('disabled', true);
				$("#diaPago").val('');
			}
			

		});

		$('#diaPago').blur(function() {
			if ($('#diaPago').val()!='' && $('#tipoPago').val()=='D') {
				if ($("#diaPago").val()>28) {
					mensajeSis("El día de pago debe ser igual o menor a 28");
					$("#diaPago").val('');
					$('#diaPago').focus();
				}
			}
		});


		$('#diaCorte').blur(function() {
			if ($('#diaCorte').val()!='' && $('#tipoCorte').val()=='D') {
				if ($("#diaCorte").val()>28) {
					mensajeSis("El día de corte debe ser igual o menor a 28");
					$("#diaCorte").val('');
					$('#diaCorte').focus();
				}
			}
		});

		$('#cuentaClabe').blur(function() {
			var cuentaclabe = $('#cuentaClabe').val();
			if (cuentaclabe != '') {
				var institucion = cuentaclabe.substr(0, 3);
				var tipoConsulta = 3;
				var DispersionBean = {
						'institucionID' : institucion
				};
				if (cuentaclabe.length == 18) {
						institucionesServicio.consultaInstitucion( tipoConsulta, DispersionBean,
								function(data) {
									if (data == null || data =='') {
										mensajeSis('La Cuenta Clabe No Coincide con Ninguna Institución Financiera Registrada.');
										$('#cuentaClabe').focus();
										$('#cuentaClabe').val('');
									}
								});

				} 
				else {
					mensajeSis("La Cuenta Clable debe de Tener 18 Caracteres.");
					$('#cuentaClabe').focus();
				}
			}
			
		});



		
	/* Funcion para generar el reporte */
		function generaReporte() {	
			var tarjetaDebID = $("#tarjetaDebID").val();
			var tipoReporte = 1;
			var fechaSis = parametroBean.fechaSucursal;
			var nombreInstitucion = parametroBean.nombreInstitucion; 	

				$('#ligaGenerar').attr('href','reporteTarCredCaratula.htm?tarjetaDebID='+tarjetaDebID +'&fechaSistema='+fechaSis
						+'&tipoReporte='+tipoReporte+'&nombreInstitucion='+nombreInstitucion);
			
		}


			//------------ Metodos y Manejo de Eventos -----------------------------------------
			deshabilitaBoton('autorizar');
		

			
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
		    			'funcionExitoAutoriza','funcionErrorAutoriza'); 
	      }
	   });	


		$('#procesar').click(function() {
			$('#tipoActualizacion').val(catTipoActAsociaCeuntaTC.asociaCuentasTC);	
		});

		$('#imprimir').click(function() { 
			generaReporte();
		});


		$('#formaGenerica').validate({

			rules: {
				tarjetaDebID:{
					required:true,
					maxlength:16
				},
				tipoTarjetaDebID: 'required',
				clienteID: 'required',
				tipoCorte: 'required',
				tipoPago: 'required',
				diaCorte: {
					required: function() {return $('#tipoCorte option[value="D"]').attr('selected')==true;},
					maxlength: 2,
				},
				diaPago: {
					required: function() {return $('#tipoPago option[value="D"]').attr('selected')==true;},
					maxlength: 2,
				},
				cuentaClabe: {
					required: function() {if ($('#tipoTransaccion ')=='6') {
											return true;
										}
										else{
											return false;	
										}
									},
				
				}
			},		
			messages: {
				tarjetaDebID: {
					required:'Especifique el número de tarjeta',
					maxlength :'Debe tener máximo 16 Caracteres',
				
				},		
				tipoTarjetaDebID: 'Especifique el Tipo de Tarjeta',
				clienteID: 'Especifique Cliente',
				tipoCorte: 'Especifique el Tipo de Corte',
				tipoPago: 'Debe tener máximo 2 caracteres',
				diaCorte: {
					required:'Especifique el Día de Corte',
					maxlength :'Máximo 2 Caractares',
				},
				diaPago: {
					required:'Especifique el Día de Pago',
					maxlength :'Debe tener máximo 2 Caracteres',
				
				},
				cuentaClabe: {
				  required:'Especifique la Cuenta Clabe',
				  
				}
			}		
		});



			//------------ Validaciones de Controles -------------------------------------


	});
	
	function funcionExitoAutoriza (){
		desBloqueaCampos();
		$('#clienteID').focus();
		
	}

	function funcionErrorAutoriza (){
		$('#tarjetaDebID').focus();
	}