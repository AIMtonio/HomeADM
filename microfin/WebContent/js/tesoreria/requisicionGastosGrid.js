$(document).ready(function() {
		esTab = true;
		
	 var montoCuenta = null;
	 
	
	 $('#requisicionID').focus();
	 
	 //Definicion de Constantes y Enums  
	var catTipoTransaccionConciliacion = {
  		'graba':'1',
  		'modifica':'2',
  		'elimina':'3'
	};
	
	var catTipoConsultaConciliacion = {
  		'principal':1,
  		'foranea':2
	};	

	var catTipoConsultaInstituciones = {
  		'principal':1, 
  		'foranea':2
	};
	
	var catTipoConsultaSucursales = {
  		'principal':1, 
  		'foranea':2,
  		'porCuentasAho':3
	};
	
	var catTipoTransaccionCtaAho = {
  		'grabar':'1'
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	deshabilitaBoton('grabar', 'submit')

	
	$('#requisicionID').blur(function() {
		validaRequisicion(this.id);
	});
	
	$('#requisicionID').click(function(){
		$('#requisicionID').select();
		$('#requisicionID').focus();
		deshabilitaBoton('grabar', 'submit');
	});
	

  
	$('#tipoGastoID').blur(function() {
		if($('#tipoGastoID').val() != '' && !isNaN($('#tipoGastoID').val()) && esTab){

			
			agregaNuevoDetalle();
		}
	});
  
  	
	function validaRequisicion(idControl){
		
		var jqRequisicion = eval("'#" + idControl + "'");
		var numRequisicion = $(jqRequisicion).val();
			
		if(numRequisicion == 0 && numRequisicion != '' && esTab){
			habilitaBoton('grabar', 'submit');

			$('#sucursalID').val(parametroBean.sucursal);
			$('#nombreSucursal').val(parametroBean.nombreSucursal);
			$('#usuarioID').val(parametroBean.numeroUsuario);   
			$('#nombreUsuario').val(parametroBean.nombreUsuario);
			$('#fechaSolicitada').val(parametroBean.fechaSucursal);
			$('#status').val("Alta");			
		}else{

		}
	}
	

consultaTiposCuenta();
	
//Fin del jquery
});

	function consultaTiposCuenta() {			
  		dwr.util.removeAllOptions('tipoCuentaID'); 
		dwr.util.addOptions('tipoCuentaID', {0:'SELECCIONAR'}); 
		tiposCuentaServicio.listaCombo(2, function(tiposCuenta){
		dwr.util.addOptions('tipoCuentaID', tiposCuenta, 'tipoCuentaID', 'descripcion');
		});
	}

