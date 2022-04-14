$(document).ready(function() {
		esTab = true;

	// variables 
	var parametroBean = consultaParametrosSession();
	
	// asignacion de variables
	$('#fechaBlo').val(parametroBean.fechaSucursal);  
	//Definicion de Constantes y Enums 
		
	var catTipoActTipoCtaAho = {
  		'desbloqueoCta' :5,
  	};	
		
	//------------ Metodos y Manejo de Eventos -----------------------------------------
 
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
      submitHandler: function(event) { 
    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','desbloquear', 
    			  'funcionExitoDesbloqueoCta','funcionErrorDesbloqueoCta');
      }
   });					
	
	// se cargan los valores de la pantalla
	consultaCtaDesb();
	    
	$(':text').bind('keydown',function(e){ 
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	
	$('#desbloquear').click(function() {		
		$('#tipoTransaccion').val(catTipoActTipoCtaAho.desbloqueoCta); 
	});
	
		
	$('#cuentaAhoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#cuentaAhoID').val();
			lista('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'desbloqueoMasivoCuentas.htm');
		}				       
	});	
	
	$('#clienteID').blur(function() {
  		consultaCliente(this.id);
	});
// validaciones de la form
	$('#formaGenerica').validate({
		rules: {
			numeroCuenta: 'required',
			saldo:        'required',
		},
		
		messages: {
			numeroCuenta: 'Especifique total de cuentas a desbloquear',
		}		
	});	
	
	//------------ Validaciones de Controles -------------------------------------
	function consultaCtaDesb() {	
		var cuentaAhoBeanCon = {
			'cuentaDesbloq':' ',
			'saldoDesbloq':' '
		};
		var cuentaDesblo =18;

			cuentasAhoServicio.consultaCuentasDesbloq(cuentaDesblo,cuentaAhoBeanCon,function(ctaDesbloq){
						if(ctaDesbloq!=null){						
							$('#numeroCuenta').val(ctaDesbloq.cuentaDesbloq);	
							$('#saldo').val(ctaDesbloq.saldoDesbloq);
							$('#saldo').formatCurrency({
								positiveFormat: '%n', 
								roundToDecimalPlace: 2	
							});					
				if(ctaDesbloq.saldoDesbloq >0 && ctaDesbloq.cuentaDesbloq >0 ){
					habilitaBoton('desbloquear', 'submit');
				}else{
					deshabilitaBoton('desbloquear', 'submit');
					$('#saldo').val(0.0);
				}
			}    						
		});
	}
		
});
// funcion que se ejecuta cuando el resultado fue exito
function funcionExitoDesbloqueoCta(){
	deshabilitaBoton('desbloquear', 'submit');
	$('#saldo').val(0);
	$('#numeroCuenta').val(0);
}

// funcion que se ejecuta cuando el resultado fue error
function funcionErrorDesbloqueoCta(){
	
}