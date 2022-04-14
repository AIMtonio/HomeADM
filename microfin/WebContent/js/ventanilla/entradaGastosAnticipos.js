$(document).ready(function(){	
	var numeroCaja=parametroBean.cajaID;
	var sucursalID=parametroBean.sucursal;
	//Definicion de Constantes y Enums

	

	$(':text').focus(function() {	
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	deshabilitaBoton('graba','sumbit');	
	
	$('#tipoDevAntGastoID').blur(function(){
		validaCatalogoAntGastos();
	});
	
	$('#tipoDevAntGastoID').change (function(){
		validaCatalogoAntGastos();
		
	});

	$('#empleadoIDDev').blur (function(){
		consultaEmpleado('empleadoIDDev');
	});
	
	$('#montoGastoDev').blur(function(){	
		var montoTransaccionAG=  $('#montoMAXTrans').asNumber();
		if($('#montoGastoDev').asNumber()>montoTransaccionAG){
			alert("El Monto No puede Exceder a " + cantidadFormatoMoneda(montoTransaccionAG,'$'));
		$('#montoGastoDev').focus();
		deshabilitaBoton('graba','sumbit');
		}else{
			$('#cantEntraMil').focus();
		}
	
		if($('#montoGastoDev').val()==''){
				deshabilitaBoton('graba','sumbit');			
		}
		
	});
	
	 $('#empleadoIDDev').bind('keyup',function(e){
		 if(this.value.length >= 2){ 
			var camposLista = new Array(); 
		    var parametrosLista = new Array(); 
		    	camposLista[0] = "nombreCompleto";
		    	parametrosLista[0] = $('#empleadoIDDev').val();
		 listaAlfanumerica('empleadoIDDev', '2', '1', camposLista, parametrosLista, 'listaEmpleados.htm'); } });
	

	
	// FUNCION CONSULTA DE LOS CAMPOS DEL CATALOGO DE TIPO DE GASTOS Y ANTICIPOS 
	 function validaCatalogoAntGastos() {
		 	var principal=1;
			var catalogoAntGastosBean = { 
					'tipoAntGastoID':$('#tipoDevAntGastoID').val()	  				
			};				
			if($('#tipoDevAntGastoID').asNumber() >0 ){
				catalogoGastosAntServicios.consulta(principal,catalogoAntGastosBean,function(tipoAntGastosBean) {
					if(tipoAntGastosBean != null){
						if(tipoAntGastosBean.reqNoEmp!='S'){
							$('#reqEmp').val("N");
							soloLecturaControl('empleadoIDDev');
							$('#montoGastoDev').focus();
							$('#label').hide();
							$('#empDev').hide();
							$('#separaDev').hide();
						}else{
							$('#label').show();
							$('#empDev').show();
							$('#separaDev').show();
							$('#reqEmp').val("S");
							habilitaControl('empleadoIDDev');
							$('#empleadoIDDev').focus();
						}
						descoperacion = tipoAntGastosBean.descripcion;

						$('#instrumento').val(tipoAntGastosBean.tipoInstrumentoID);
						$('#naturaleza').val(tipoAntGastosBean.naturaleza);
						$('#montoMAXTrans').val(tipoAntGastosBean.montoMaxTransaccion);
						$('#montoMAXEfect').val(tipoAntGastosBean.montoMaxEfect);
						
					}else{								
						alert("No existe el Tipo de Anticipo/Gasto");
						
					}
				});	
			}
				
	 	}										

							
				
		
		// ////////////////funcion Consulta Empleado//////////////////
		function consultaEmpleado(control) {
			var principal=1;
			var numEmpleado = $('#empleadoIDDev').val();
				setTimeout("$('#cajaLista').hide();", 200);
					if (numEmpleado != '' && !isNaN(numEmpleado) && esTab) {
						
						var empleadoBeanCon = {
									'empleadoID' : $('#empleadoIDDev').val()

							};

					empleadosServicio.consulta(principal,empleadoBeanCon, function(empleados) {
						if (empleados != null) {
							$('#nombreEmpleadoDev').val(empleados.nombreCompleto);
						}else{
							alert("No Existe el Empleado");
							$('#empleadoIDDev').focus();
							$('#empleadoIDDev').val('');
							$('#nombreEmpleadoDev').val('');
							$('#montoGastoDev').val('');
						}
					});

				}else{
					$('#empleadoIDDev').focus();
					$('#empleadoIDDev').val('');
					$('#nombreEmpleadoDev').val('');
					$('#montoGastoDev').val('');
					
				}
			}
	
	
	
});// FIN DEL DOCUMENT


var parametroBean = consultaParametrosSession();
function imprimeTicketDevGastoAnt() {	
	var simboloMoneda=parametroBean.simboloMonedaBase;
 	var principal=1;
	var catalogoAntGastosBean = { 
			'tipoAntGastoID':$('#tipoDevAntGastoID').val()	  				
	};				
	
	catalogoGastosAntServicios.consulta(principal,catalogoAntGastosBean,function(tipoAntGastosBean) {
		if(tipoAntGastosBean != null){
			operacion = tipoAntGastosBean.descripcion;
			
		}else{
			operacion='';
		}

		var imprimeTicketGastoAntBean ={
			    'folio' 	        	:$('#numeroTransaccion').val(),
		        'tituloOperacion'  		:'DEVOLUCION DE GASTOS/ANTICIPOS',
			    'empleadoID'            :$('#empleadoIDDev').val(),						  
			    'nombreEmpleado'    	:$('#nombreEmpleadoDev').val(),
		        'operacion'      	    :operacion,
	            'montoTotal'			:$('#montoGastoDev').val(),
	            'moneda'				:simboloMoneda,
	            'monto'					:$('#montoGastoDev').asNumber()
			};					
		imprimeTicketDevGastosAnticipo(imprimeTicketGastoAntBean);	
				
	});		
}




//LLENA EL COMBO CATALOGO GASTOS Y ANTICIPOS
function llenaComboGastosAnticipos() {		
	var tipoLista  = 4;
	dwr.util.removeAllOptions('tipoDevAntGastoID'); 		
	catalogoGastosAntServicios.listaCombo(tipoLista, function(tipoGastoAnt){				
	dwr.util.addOptions('tipoDevAntGastoID', tipoGastoAnt, 'tipoAntGastoID', 'descripcion');
	validaCatalogoAntGastosEnt();
	});
	
}


function validaCatalogoAntGastosEnt() {
 	var principal=1;
	var catalogoAntGastosBean = { 
			'tipoAntGastoID':$('#tipoDevAntGastoID').val()	  				
	};				
	if($('#tipoDevAntGastoID').asNumber() >0 ){
		catalogoGastosAntServicios.consulta(principal,catalogoAntGastosBean,function(tipoAntGastosBean) {
			if(tipoAntGastosBean != null){
				if(tipoAntGastosBean.reqNoEmp!='S'){
					$('#reqEmp').val("N");
					soloLecturaControl('empleadoIDDev');
					$('#label').hide();
					$('#empDev').hide();
					$('#separaDev').hide();
				}else{
					$('#label').show();
					$('#empDev').show();
					$('#separaDev').show();
					$('#reqEmp').val("S");
					habilitaControl('empleadoIDDev');
				}
				descoperacion = tipoAntGastosBean.descripcion;

				$('#instrumento').val(tipoAntGastosBean.tipoInstrumentoID);
				$('#naturaleza').val(tipoAntGastosBean.naturaleza);
				$('#montoMAXTrans').val(tipoAntGastosBean.montoMaxTransaccion);
				$('#montoMAXEfect').val(tipoAntGastosBean.montoMaxEfect);
				
			}else{								
				alert("No existe el Tipo de Anticipo/Gasto");
				
			}
		});	
	}
		
	}	