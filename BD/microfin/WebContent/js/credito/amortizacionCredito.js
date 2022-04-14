$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  	
	var catTipoConsultaCredito = { 
  		'principal'	: 1,
  		'foranea'	: 2
	};
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	 deshabilitaBoton('grabar', 'submit');
    deshabilitaBoton('imprimir', 'submit');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	agregaFormatoControles('formaGenerica');
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
            submitHandler: function(event) { 
                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID'); 
            }
    });				

	
	$('#generar').click(function() {		
		consultaGridAmortizaciones();
	});
	
	$('#grabar').click(function() {		
		//$('#tipoTransaccion').val(catTipoTransaccionCredito.modifica);
	});

	$('#imprimir').click(function() {
		//$('#tipoTransaccion').val(catTipoTransaccionCredito.modifica);
	});
	
	$('#creditoID').blur(function() { 
  		validaCredito(this.id); 
	});
	
	
	//------------ Validaciones de Controles -------------------------------------
	
		function validaCredito(control) {
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('imprimir', 'submit');
			
			var creditoBeanCon = { 
  				'creditoID':$('#creditoID').val()
			};
			creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
					if(credito!=null){
						dwr.util.setValues(credito);
						esTab=true;	
						$('#clienteID').val(credito.clienteID);
						consultaCliente('clienteID');
					}else{							
						alert("No Existe el Credito");
						$('#creditoID').focus();
						$('#creditoID').select();																				
					}
			});
		}
	}
	
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
					if(cliente!=null){	
						$('#clienteID').val(cliente.numero)							
						$('#nombreCliente').val(cliente.nombreCompleto);						
					}else{
						alert("No Existe el Cliente");
						$('#clienteID').focus();
						$('#clienteID').select();	
					}    	 						
			});
		}
	}
	
	function consultaGridAmortizaciones(){
		var params = {};
		quitaFormatoControles('formaGenerica');
		params['montoCredito'] = $('#montoCredito').val();
		params['tasaFija'] = $('#tasaFija').val();
		params['numAmortizacion'] = $('#numAmortizacion').val();
		params['frecuenciaCap'] = $('#periodicidadCap').val();
		params['tipoLista'] = 1;
		

		$.post("amortizacionGridCredito.htm", params, function(data){		
				if(data.length >0) {
					$('#gridAmortizacion').html(data);
					$('#gridAmortizacion').show(); 
					 alternaFilas('alternacolor');
				}else{
					$('#gridAmortizacion').html("");
					$('#gridAmortizacion').show();
				}
		});
		agregaFormatoControles('formaGenerica');
	}

		
		
});