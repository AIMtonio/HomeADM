$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	var catTipoTransCajas= {
		'alta': 1,
		'modificar' : 3,
		'cierre' : 8,
		'apertura':9
	};
	var catLisCajas= {
		'principal': 1,
		'corporativo' : 3
	};
	var catConCajas= {
		'foranea' : 2,
		'corporativo' : 5,
		'atencion': 6
	};
	
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	$('#huellaDigital').val("N");
	$('#cajaID').focus();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
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
	    	    $('#sucursalID').removeAttr('disabled', 'disabled');
	  			$('#usuarioID').removeAttr('disabled', 'disabled');
	  		
	    	  grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cajaID');
	      }
	});

	$('#formaGenerica').validate({
		rules: {
			cajaID: {
				required: true
			},
			tipoCaja:{
				required: true	
			},
			usuarioID:{
				required: true	
			},
			sucursalID:{
				required: true	
			},
			limiteEfectivoMN:{
				required: true	
			},
			limiteDesembolsoMN:{
				required: true	
			},
			maximoRetiroMN:{
				required: true	
			}
			,nomImpresora :{
				required: true,	
				maxlength: 30
			}
			,descripcionCaja :{
				maxlength: 50
			} 
		},
		
		messages: {
			cajaID: {
				required: 'Especifique la Caja '
			},
			tipoCaja:{
				required: 'Especifique el tipo de Caja'
			},
			sucursalID:{
				required: 'Especifique la Sucursal'
			},
			usuarioID :{
				required: 'Especifique el Usuario'
			},
			limiteEfectivoMN:{
				required: 'Especifique el Limite de Efectivo'
			},
			limiteDesembolsoMN:{
				required: 'Especifique el Limite de Desembolso'
			},
			maximoRetiroMN:{
				required: 'Especifique el Máximo Retiro'
			},
			nomImpresora:{
				required: 'Especifique el Nombre de Impresora',
				maxlength: 'Máximo 30 caracteres.'
			}
			,
			descripcionCaja :{
				maxlength: 'Máximo 50 caracteres.'
			}
		}
	});
	
	
	
	$('#tipoLista').val(catLisCajas.principal);
	$('#tipoConsulta').val(catConCajas.foranea);
	$('#grabar').click(function(){
		$('#tipoTransaccion').val(catTipoTransCajas.alta);
	});
	$('#modificar').click(function(){
		$('#tipoTransaccion').val(catTipoTransCajas.modificar);
	});

		
	$('#cajaID').bind('keyup',function(e) {
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "cajaID";
			camposLista[1] = "sucursalID";
			parametrosLista[0] = $('#cajaID').val();
			parametrosLista[1] = parametros.sucursal;
			lista('cajaID', '1', '2', camposLista, parametrosLista, 'listaCajaVentanilla.htm');
		}
	});
	$('#cajaID').blur(function(){
		habilitaControl('huellaDigital');
		$('#tipoCaja').removeAttr('disabled');
		$('#tipoCaja').removeAttr('deshabilitado');
		
		if (Number(this.value) <= 0 || isNaN(this.value)){
			habilitaBoton('grabar', 'submit');
			deshabilitaBoton('modificar', 'submit');
			inicializaForma('formaGenerica', 'cajaID');
			$('#tipoCaja').val('CA');
			$('#usuarioID').removeAttr('disabled', 'disabled');
			$('#tipoCaja').removeAttr('disabled', 'disabled');
			$('#sucursalID').removeAttr('disabled', 'disabled');
			setTimeout("$('#cajaLista').hide();", 200);
			$('#tipoCaja').focus();
			
		}else{
			consultaCaja(this.id);
			deshabilitaBoton('grabar', 'submit');
			
		}
	});
	
	$('#usuarioID').blur(function (){
		consultaUsuario(this.value);
	});
	$('#usuarioID').bind('keyup',function(e) {
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreCompleto";
			camposLista[1] = "sucursalUsuario";
			parametrosLista[0] = $('#usuarioID').val();
			parametrosLista[1] = $('#sucursalID').val();
			lista('usuarioID', '1', '3', camposLista, parametrosLista, 'listaUsuarios.htm');
		}
	});
	$('#tipoCaja').change(function(){
		$('#sucursalID').val('');
		$('#desSucursal').val('');
		$('#usuarioID').val('');
		$('#limiteEfectivoMN').val('');
		$('#limiteDesembolsoMN').val('');
		$('#maximoRetiroMN').val('');
		$('#nomImpresora').val('');
		$('#descripcionCaja').val('');
		$('#nombreUsuario').val('');
		$('#descripcionCaja').val('');
		$('#nomImpresoraCheq').val('');
		var valor = $("#tipoCaja option:selected").val();
		if (valor == 'BG'){
			$('#tipoLista').val(catLisCajas.corporativo);
			$('#tipoConsulta').val(catConCajas.corporativo);
		}else if (valor == 'CA' || valor == 'CP' ){
			$('#tipoLista').val(catLisCajas.principal);
			$('#tipoConsulta').val(catConCajas.atencion);
		}
	});
	$('#sucursalID').focus(function (){
		$('#usuarioID').val('');
		$('#limiteEfectivoMN').val('');
		$('#limiteDesembolsoMN').val('');
		$('#maximoRetiroMN').val('');
		$('#nomImpresora').val('');
		$('#descripcionCaja').val('');
		$('#nombreUsuario').val('');
	});
	$('#sucursalID').blur(function (){
		consultaSucursal(this.value);
	});
	
	$('#sucursalID').bind('keyup',function(e) {
		var tipoLista = $('#tipoLista').val();
		if(this.value.length >= 1){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreSucurs";
			parametrosLista[0] = $('#sucursalID').val();
			lista('sucursalID', '1', tipoLista, camposLista, parametrosLista, 'listaSucursales.htm');
		}
	});
	
	//Funciones 
	function consultaCaja( idControl ) {
		var jqCajaID = eval("'#" + idControl + "'");
		var numCajaID = $(jqCajaID).val();
		var conPrincipal = 3;
		var CajasBeanCon = {
  			'cajaID': numCajaID,
  			'sucursalID' : parametros.sucursal
		};
		setTimeout("$('#cajaLista').hide();", 200);
		$('#nombreUsuario').val('');
		if(numCajaID != '' && !isNaN(numCajaID)){
			cajasVentanillaServicio.consulta(conPrincipal, CajasBeanCon ,function(cajasVentanilla){
				if(cajasVentanilla != null){
					deshabilitaControl('tipoCaja');
					habilitaControl('huellaDigital');
				//	$('#tipoCaja').attr('disabled', 'disabled');
					$('#usuarioID').attr('disabled', 'disabled');
					$('#sucursalID').attr('disabled', 'disabled');
					$('#tipoCaja').val(cajasVentanilla.tipoCaja);
					$('#usuarioID').val(cajasVentanilla.usuarioID);
					$('#sucursalID').val(cajasVentanilla.sucursalID);
					$('#nomImpresora').val(cajasVentanilla.nomImpresora);
					$('#nomImpresoraCheq').val(cajasVentanilla.nomImpresoraCheq);
					$('#limiteEfectivoMN').val(cajasVentanilla.limiteEfectivoMN);
					formatoMoneda('limiteEfectivoMN');
					$('#limiteDesembolsoMN').val(cajasVentanilla.limiteDesembolsoMN);
					formatoMoneda('limiteDesembolsoMN');
					$('#maximoRetiroMN').val(cajasVentanilla.maximoRetiroMN);
					formatoMoneda('maximoRetiroMN');
					$('#descripcionCaja').val(cajasVentanilla.descripcionCaja);	
					if (cajasVentanilla.usuarioID != 0){
						consultaUsuario(cajasVentanilla.usuarioID);	
					}
					consultaSucursal(cajasVentanilla.sucursalID);
					habilitaBoton('modificar', 'submit');
					$('#huellaDigital').val(cajasVentanilla.huellaDigital);
					$('#limiteEfectivoMN').focus();
				}
				else{
					habilitaControl('huellaDigital');
					$('#tipoCaja').removeAttr('disabled');
					mensajeSis("No Existe la Caja");
					inicializaForma('formaGenerica','cajaID');
					$('#cajaID').focus();
					deshabilitaBoton('modificar', 'submit');
				}
			});
		}else{
			$('#tipoCaja').removeAttr('disabled');
		}
	}
	
	function consultaUsuario(usuarioID){
		var conPrincipal = 1;
		var usuarioBean = {
			'usuarioID' : usuarioID
		};
		if(usuarioID != '' && !isNaN(usuarioID)){
			usuarioServicio.consulta(conPrincipal, usuarioBean, function(usuario){
				if (usuario != null){
					if(Number($('#sucursalID').val()) <= 0){
						mensajeSis('Seleccione primero la Sucursal donde se creará la caja.');
						$('#sucursalID').focus();
						$('#sucursalID').select();
					}else{
						if( Number($('#sucursalID').val()) != Number(usuario.sucursalUsuario) ){
							mensajeSis('El Usuario no pertenece a la Sucursal Seleccionada');
							$('#usuarioID').val('');
							$('#nombreUsuario').val('');
							$('#usuarioID').focus();
							$('#usuarioID').select();
						}else{
							
							$('#nombreUsuario').val(usuario.nombreCompleto);
							
						}
					}
				}else{
					mensajeSis('No Existe el Usuario');
					$('#nombreUsuario').val('');
				}
			});
		}
	}

	function consultaSucursal(sucursalID){
		var conForanea = 2;
		var tipoConsulta = parseInt($('#tipoConsulta').val());
		if(sucursalID != '' && !isNaN(sucursalID)){
			sucursalesServicio.consultaSucursal(conForanea, sucursalID, function(sucursal){
				if (sucursal != null){			
					var conForanea =  tipoConsulta;
					sucursalesServicio.consultaSucursal(conForanea, sucursalID, function(corporativo){
						if (corporativo != null){
							$('#desSucursal').val(sucursal.nombreSucurs);
						}else{
							mensajeSis("La Sucursal Capturada No Esta Disponible para el Tipo de Caja Seleccionado");
							$('#desSucursal').val('');
							$('#sucursalID').focus();
						}
					});

				}else{
					mensajeSis('No Existe la Sucursal');
					$('#sucursalID').focus();					
					$('#desSucursal').val('');
				}
			});
		}
	}

	function formatoMoneda(monto){
		var jqMonto = eval("'#" + monto + "'");
		$(jqMonto).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});	
	}
}); // Fin Jquery

	var nav4 = window.Event ? true : false;
	function IsNumber(evt){
		var key = nav4 ? evt.which : evt.keyCode;
		return (key <= 13 || (key >= 48 && key <= 57) || key == 46);
	}