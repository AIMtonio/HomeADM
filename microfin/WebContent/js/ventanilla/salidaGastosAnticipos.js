$(document).ready(function(){
	var parametroBean = consultaParametrosSession();
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

	//deshabilitaBoton('graba','sumbit');
	
	
	$('#tipoAntGastoID').blur(function(){

		//consultarParametrosBean();
		limpiaFormulario(this.id);
		validaCatalogoAntGastos();	
		 inicializaCantidadEntradaSalida();
	});
	
	$('#tipoAntGastoID').change (function(){
		limpiaFormulario(this.id);
		validaCatalogoAntGastos();		
		 inicializaCantidadEntradaSalida();

	});
	$('#formaPagoOpera1').blur(function(){
		$('#cantSalMil').focus();		
	});
	
	$('#empleadoID').blur (function(){
		limpiaFormulario(this.id);
		consultaEmpleado('empleadoID');		
	});
	
	 $('#empleadoID').bind('keyup',function(e){
		 if(this.value.length >= 2){ 
			var camposLista = new Array(); 
		    var parametrosLista = new Array(); 
		    	camposLista[0] = "nombreCompleto";
		    	parametrosLista[0] = $('#empleadoID').val();
		 listaAlfanumerica('empleadoID', '2', '1', camposLista, parametrosLista, 'listaEmpleados.htm'); } });
	
	$('#montoGastoAnt').blur(function(){	
		var montoTransaccionAG=  $('#montoMAXTrans').asNumber();
		var montoMaxEfect=	$('#montoMAXEfect').asNumber();	
		
		if($('#montoGastoAnt').asNumber()>montoTransaccionAG){
			mensajeSis("El Monto No puede Exceder a " + cantidadFormatoMoneda(montoTransaccionAG,'$'));
			$('#montoGastoAnt').focus();
			deshabilitaBoton('graba','sumbit');
		}
		
		if($('#montoGastoAnt').asNumber()<=montoTransaccionAG){
			if($('#formaPagoOpera1').is(":checked")){
				if($('#montoGastoAnt').asNumber()>montoMaxEfect){
					$('#divCuentaCheques').show();
					mensajeSis("Ha Excedido El Monto Máximo de Efectivo");
					$('#formaPagoOpera2').attr('checked',true);
					$('#formaPagoOpera1').attr('checked',false);
					$('#entradaSalida').hide();
					$('#totales').hide();
					inicializaCantidadEntradaSalida();
					var tipoLista=2;
					var asignaChequeBean ={
							'sucursalID' : sucursalID,
							'cajaID'	 : numeroCaja
					};								
					asignarChequeSucurServicio.listaCombo(tipoLista,asignaChequeBean,function(chequesBean){
						if(chequesBean!=''){
							dwr.util.removeAllOptions('cuentaChequePago'); 
		  			  		dwr.util.addOptions('cuentaChequePago', {'':'SELECCIONAR'});
		  			  		dwr.util.addOptions('cuentaChequePago', chequesBean, 'institucionCta', 'descripLista');  
						}
					});		
					deshabilitaControl('formaPagoOpera1');
				}
			}else {
					if($('#montoGastoAnt').asNumber()<=montoMaxEfect){
						habilitaControl('formaPagoOpera1');
					}else{
						deshabilitaControl('formaPagoOpera1');
					}
			}			
		}
		if($('#montoGastoAnt').asNumber() ==0){
			deshabilitaBoton('graba','sumbit');			
		}
		
		
	});

	 // FUNCION CONSULTA DE LOS CAMPOS DEL CATALOGO DE TIPO DE GASTOS Y ANTICIPOS 
	 function validaCatalogoAntGastos() {
		 	var principal=1;
			var catalogoAntGastosBean = { 
					'tipoAntGastoID':$('#tipoAntGastoID').val()	  				
			};				
			
			catalogoGastosAntServicios.consulta(principal,catalogoAntGastosBean,function(tipoAntGastosBean) {
				if(tipoAntGastosBean != null){
					if(tipoAntGastosBean.reqNoEmp!='S'){
						$('#reqEmp').val("NO");
						//soloLecturaControl('empleadoID');
						$('#montoGastoAnt').focus();
						$('#beneCheque').val($('#nombreEmpleadoGA').val());
						$('#laber').hide();
						$('#empGas').hide();
						$('#separa').hide();
					}else{
						$('#laber').show();
						$('#empGas').show();
						$('#separa').show();
						$('#reqEmp').val("SI");
						//habilitaControl('empleadoID');
						$('#empleadoID').focus();
						$('#beneCheque').val('');
					}
					descoperacion=tipoAntGastosBean.descripcion;
					$('#instrumento').val(tipoAntGastosBean.tipoInstrumentoID);
					$('#naturaleza').val(tipoAntGastosBean.naturaleza);
					$('#montoMAXTrans').val(tipoAntGastosBean.montoMaxTransaccion);
					$('#montoMAXEfect').val(tipoAntGastosBean.montoMaxEfect);
					
				}else{								
					mensajeSis("No existe el Tipo de Anticipo/Gasto");
					
				}
			});		
	  }									
						

		// ////////////////funcion Consulta Empleado//////////////////
		function consultaEmpleado(control) {
			var principal=1;
			var numEmpleado = $('#empleadoID').val();
			setTimeout("$('#cajaLista').hide();", 200);
			if (numEmpleado != '' && !isNaN(numEmpleado) && esTab) {
			var empleadoBeanCon = {
					'empleadoID' : $('#empleadoID').val()
		
			};		
		empleadosServicio.consulta(principal,empleadoBeanCon, function(empleados) {
			if (empleados != null) {
				$('#nombreEmpleadoGA').val(empleados.nombreCompleto);
				$('#beneCheque').val($('#nombreEmpleadoGA').val());
		
			}else{
				mensajeSis("No Existe el Empleado");
				$('#empleadoID').focus();
				$('#empleadoID').val('');
				$('#nombreEmpleadoGA').val('');
				$('#montoGastoAnt').val('');
					}
				});
			}else{
				$('#empleadoID').focus();
				$('#empleadoID').val('');
				$('#nombreEmpleadoGA').val('');
				$('#montoGastoAnt').val('');
				
			}
		 }

		 
		 
		//fucnion para gregar formato moneda a una cantidad recibiendo como parametro la cantidad y el prefijo
		function cantidadFormatoMoneda(num,prefix)  {  
			num = Math.round(parseFloat(num)*Math.pow(10,2))/Math.pow(10,2) ; 
			prefix = prefix || '';  
			num += '';  
			var splitStr = num.split('.');  
			var splitLeft = splitStr[0];  
			var splitRight = splitStr.length > 1 ? '.' + splitStr[1] : '.00';  
			splitRight = splitRight + '00';  
			splitRight = splitRight.substr(0,3);  
			var regx = /(\d+)(\d{3})/;  
			while (regx.test(splitLeft)) {  
				splitLeft = splitLeft.replace(regx, '$1' + ',' + '$2');  
			}  
			return prefix + splitLeft + splitRight;  
		} 

	
		// Funcion para reiniciar todos los campos del formulario
		function limpiaFormulario(controlID){
			if($("#formaPagoOpera2").is(':checked')){
				$('#numeroTransaccion').val('');
				
				if(controlID == 'tipoAntGastoID'){
					$("#empleadoID").val('');
					$("#nombreEmpleadoGA").val('');
				}
				
				$("#montoGastoAnt").val('');
				$("#cuentaChequePago").val('');
				$("#folioUtilizar").val('');
				$("#numeroCheque").val('');
				$("#confirmeCheque").val('');
				$("#beneCheque").val('');
				$("#impCheque").hide(400);
				$("#impTicket").hide(400);
			}
			
		}
	
	
});// FIN DEL DOCUMENT
var parametroBean = consultaParametrosSession();

function imprimeTicketGastoAnt() {		 
	var simboloMoneda=parametroBean.simboloMonedaBase;
 	var principal=1;
	var catalogoAntGastosBean = { 
			'tipoAntGastoID':$('#tipoAntGastoID').val()	  				
	};				
	
	catalogoGastosAntServicios.consulta(principal,catalogoAntGastosBean,function(tipoAntGastosBean) {
		if(tipoAntGastosBean != null){
			operacion = tipoAntGastosBean.descripcion;
			
		}else{
			operacion='';
		}

		var imprimeTicketDevGastoAntBean ={
			    'folio' 	        	:$('#numeroTransaccion').val(),
		        'tituloOperacion'  		:'GASTOS/ANTICIPOS POR COMPROBAR',
			    'empleadoID'            :$('#empleadoID').val(),						  
			    'nombreEmpleado'    	:$('#nombreEmpleadoGA').val(),
		        'operacion'      	    :operacion,
	            'montoTotal'			:$('#montoGastoAnt').val(),
	            'moneda'				:simboloMoneda,
	            'monto'					:$('#montoGastoAnt').asNumber()
			};					
		imprimeTicketGastosAnticipoSalida(imprimeTicketDevGastoAntBean);	
				
	});		
}







		
								


//LLENA EL COMBO CATALOGO GASTOS Y ANTICIPOS
 function llenaComboGastosAnticiposSalida() {		
	var tipoLista  = 3;	
	dwr.util.removeAllOptions('tipoAntGastoID'); 
	catalogoGastosAntServicios.listaCombo(tipoLista, function(tipoGastoAnt){
		if(tipoGastoAnt != null){
			dwr.util.removeAllOptions('tipoAntGastoID'); 
			dwr.util.addOptions('tipoAntGastoID', tipoGastoAnt, 'tipoAntGastoID', 'descripcion');
		}	
		validaCatalogoAntGastosSal();
	});
}

	//funcion que valida si requiere de empleado y los montos de la operacion esto por si se saltan el combo 
 function validaCatalogoAntGastosSal() {
	 	var principal=1;
		var catalogoAntGastosBean = { 
				'tipoAntGastoID':$('#tipoAntGastoID').val()	  				
		};				
		
		catalogoGastosAntServicios.consulta(principal,catalogoAntGastosBean,function(tipoAntGastosBean) {
			if(tipoAntGastosBean != null){
				if(tipoAntGastosBean.reqNoEmp!='S'){
					$('#reqEmp').val("NO");
					$('#beneCheque').val($('#nombreEmpleadoGA').val());
					$('#laber').hide();
					$('#empGas').hide();
					$('#separa').hide();
				}else{
					$('#laber').show();
					$('#empGas').show();
					$('#separa').show();
					$('#reqEmp').val("SI");
					$('#beneCheque').val('');
				}
				
				descoperacion=tipoAntGastosBean.descripcion;
				$('#instrumento').val(tipoAntGastosBean.tipoInstrumentoID);
				$('#naturaleza').val(tipoAntGastosBean.naturaleza);
				$('#montoMAXTrans').val(tipoAntGastosBean.montoMaxTransaccion);
				$('#montoMAXEfect').val(tipoAntGastosBean.montoMaxEfect);
				
			}else{								
				mensajeSis("No existe el Tipo de Anticipo/Gasto");
				
			}
		});		
  }			