$(document).ready(function() {
	esTab = true;
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	var catTransaccionGiroTipoTarjeta = {  
	  		'grabar':1,
	  		'modifica':2	
	};
	
	var catListaTipoTar ={
		'activos' : 5
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	llenaComboTiposTarjetasDeb();
	consultaTiposCuenta();
	deshabilitaBoton('modifica','submit');
	deshabilitaBoton('grabar','submit');
	
	agregaFormatoControles('formaGenerica');

	$(':text').focus(function() {	
		esTab = false;
	});

	$('#tipoTarjetaDebID').focus();	
	
	$('#grabar').click(function() {	
	$('#tipoTransaccion').val(catTransaccionGiroTipoTarjeta.grabar);
	
	});

	$('#modifica').click(function() {	

		$('#tipoTransaccion').val(catTransaccionGiroTipoTarjeta.modifica);
		
		});

	$('#tipoTarjetaDebID').change(function() {
		consultaComboTipoCuenta(this.id);
	});
		
	$.validator.setDefaults({			
	      submitHandler: function(event) { 	    	  
	    		  grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoTarjetaDebID');
	    	 }
	   });	

	$('#formaGenerica').validate({
		rules : {
			tipoTarjetaDebID: {
				required : true,
			},
			tipoCuenta: {
				required : function() {return $('#tipoTarjetaDebID').val() != '';},
			}
		

		},
		messages : {
			tipoTarjetaDebID:{
				required: 'Especificar el tipo de tarjeta',
			},
			tipoCuenta:{
				required: 'Seleccionar el Tipo de Cuenta',
			}
		}
	});

	// funcion para llenar el combo de Tipos de Tarjeta
	function llenaComboTiposTarjetasDeb() {
		var tarDebBean = {
				'tipoTarjetaDebID' : '',
				'tipoTarjeta' : 'D'
		};
		dwr.util.removeAllOptions('tipoTarjetaDebID');
		dwr.util.addOptions('tipoTarjetaDebID', {'':'TODOS'});
		tipoTarjetaDebServicio.listaCombo(catListaTipoTar.activos, tarDebBean, function(tiposTarjetas){
			dwr.util.addOptions('tipoTarjetaDebID', tiposTarjetas, 'tipoTarjetaDebID', 'descripcion');
		});
	}
	
	function consultaTiposCuenta() {
		dwr.util.removeAllOptions('tipoCuenta');
		dwr.util.addOptions('tipoCuenta');
		tiposCuentaServicio.listaCombo(2, function(tiposCuenta){
			dwr.util.addOptions('tipoCuenta', tiposCuenta, 'tipoCuentaID', 'descripcion');
		});
	}	

	function consultaComboTipoCuenta() {
		var tipoTarID = $('#tipoTarjetaDebID').val();
		var numCon = 1;
		var TipoTarjetaBeanCon  = {
				'tipoTarjetaDebID' : tipoTarID
		};
		$('#tipoCuenta').val('');
		if(tipoTarID != '' && !isNaN(tipoTarID) && esTab){				
			tiposCuentaValidoTipoTarjetaServicio.listaConsulta(numCon, TipoTarjetaBeanCon,function(Cuenta) {
				if(Cuenta !=''){
					for (var i = 0; i < Cuenta.length; i++){
						var jqTipoCuenta = eval("'#tipoCuenta option[value="+Cuenta[i].tipoCuenta+"]'");
						$(jqTipoCuenta).attr("selected","selected");
						habilitaBoton('modifica','submit');
						deshabilitaBoton('grabar','submit');
					}
				}else {
					deshabilitaBoton('modifica','submit');
					habilitaBoton('grabar','submit');
				}
			});
		}else if (tipoTarID == '' ){
			mensajeSis("Seleccionar un Tipo de Tarjeta");
			$('#tipoTarjetaDebID').focus();	
			deshabilitaBoton('modifica','submit');
			deshabilitaBoton('grabar','submit');

		}
	}
});