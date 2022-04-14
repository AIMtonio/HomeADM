	$(document).ready(function() {
		esTab = true;
		var tab2=false;
		$('#fecha').val(parametroBean.fechaSucursal);

		
		//Definicion de Constantes y Enums  
		var catTipoTransaccion = {  
				'autorizar':'7',
				'cancelar':'8',
				
				
		};

		//------------ Metodos y Manejo de Eventos -----------------------------------------
		deshabilitaBoton('autorizar');
		deshabilitaBoton('cancelar');
 
		 
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

	
	
		consultaSpei();
		consultaSpeiRecepciones();
		consultaSpeiSaldo();

		//------------ Validaciones de la Forma -------------------------------------

		$('#formaGenerica').validate({

			rules: {
				
			},		
			messages: {		
				
				
			}		
		});



		//------------ Validaciones de Controles -------------------------------------


	});
		
		// funcion para consultar spei pendientes
		function consultaSpei(){
			 var params = {};
			  params['tipoLista'] = 2;
				$.post("gridConsultaSpei.htm", params, function(data){
				
					if(data.length >0) {
						agregaFormatoControles('gridConsultaSPEI');
						$('#gridConsultaSPEI').html(data);
						$('#gridConsultaSPEI').show();
					
												
					}else{
						$('#gridConsultaSPEI').html("");
						$('#gridConsultaSPEI').hide();
				
					}
				});
		}
		

		function consultaSpeiRecepciones(){
			 var params = {};
			  params['tipoLista'] = 3;
				$.post("gridConsultaSpeiRecepcion.htm", params, function(data){
				
					if(data.length >0) {
						agregaFormatoControles('gridConsultaRecepSPEI');
						$('#gridConsultaRecepSPEI').html(data);
						$('#gridConsultaRecepSPEI').show();
					
												
					}else{
						$('#gridConsultaRecepSPEI').html("");
						$('#gridConsultaRecepSPEI').hide();
				
					}
				});
		}
		
		
		function consultaSpeiSaldo(){
			var numEmpresa = 1;	
	
			 var params = {
				'empresaID'	:numEmpresa
			 };
			  params['tipoLista'] = 4;
				$.post("gridConsultaSpeiSaldo.htm", params, function(data){
				
					if(data.length >0) {
						agregaFormatoControles('gridConsultaSaldoSPEI');
						$('#gridConsultaSaldoSPEI').html(data);
						$('#gridConsultaSaldoSPEI').show();
					
												
					}else{
						$('#gridConsultaSaldoSPEI').html("");
						$('#gridConsultaSaldoSPEI').hide();
				
					}
				});
		}

	
	function funcionExitoAutoriza (){
		consultaSpeiPendienteExito();
		deshabilitaBoton('autorizar');
		deshabilitaBoton('cancelar');
	}

	function funcionErrorAutoriza (){
		deshabilitaBoton('autorizar');
		deshabilitaBoton('cancelar');
	
	}
