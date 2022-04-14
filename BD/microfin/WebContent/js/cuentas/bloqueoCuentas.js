$(document).ready(function() {
		esTab = true;

	// variables 
	var parametroBean = consultaParametrosSession();
	
	// asignacion de variables
	$('#fechaBlo').val(parametroBean.fechaSucursal);  
	//Definicion de Constantes y Enums 
		
	var catTipoActTipoCtaAho = {
  		'bloqueaCuenta' :4,
  	};	
		
	//------------ Metodos y Manejo de Eventos -----------------------------------------
 
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
      submitHandler: function(event) { 
    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','bloquear', 
    			  'funcionExitoBloqueoCta','funcionErrorBloqueoCta');
      }
   });					
	
	// se cargan los valores de la pantalla
	consultaCtaAho();
	    
	$(':text').bind('keydown',function(e){ 
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	
	$('#bloquear').click(function() {		
		$('#tipoTransaccion').val(catTipoActTipoCtaAho.bloqueaCuenta); 
	});
	
		
	$('#cuentaAhoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#cuentaAhoID').val();
			lista('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'cuentasAhoBloqueoVista.htm');
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
			numeroCuenta: 'Especifique total de cuentas a bloquear',
		}		
	});	
	
	//------------ Validaciones de Controles -------------------------------------
	function consultaCtaAho() {	
		var CuentaAhoBeanCon = {
			'ctaBloqueo':' ',
			'saldoBloqueo':' '
		};
		var conCtaAho =17;
		cuentasAhoServicio.consultaCuentasBloq(conCtaAho,CuentaAhoBeanCon,function(ctaBloq){
			if(ctaBloq!=null){						
				$('#numeroCuenta').val(ctaBloq.ctaBloqueo);	
				$('#saldo').val(ctaBloq.saldoBloqueo);
				$('#saldo').formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});						
				if(ctaBloq.saldoBloqueo >0 && ctaBloq.ctaBloqueo >0 ){
					habilitaBoton('bloquear', 'submit');
				}else{
					deshabilitaBoton('bloquear', 'submit');
					$('#saldo').val(0);
				}
			}    						
		});
	}
			
});

// funcion que se ejecuta cuando el resultado fue exito
function funcionExitoBloqueoCta(){
	deshabilitaBoton('bloquear', 'submit');
	$('#saldo').val(0);
	$('#numeroCuenta').val(0);
}

// funcion que se ejecuta cuando el resultado fue error
// diferente de cero
function funcionErrorBloqueoCta(){
	
}