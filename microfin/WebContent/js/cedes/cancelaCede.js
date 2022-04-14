var esTab = true;

$(document).ready(function() {
	var parametroBean = consultaParametrosSession();	
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$('#cedeID').focus();
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
		 	
	var catTipoTransaccion = {
		'cancela':10
	};
	
	var catTipoConsulta = {
			'principal':1
		};
	
	var catTipoLista ={
			'cancela' : 10
	};
	
	deshabilitaBoton('cancela', 'submit');	
	agregaFormatoControles('formaGenerica');

	
	$.validator.setDefaults({
		submitHandler: function(event) { 
		 var confirmar = confirm("¿Está Seguro de que Desea Cancelar el CEDE?");
			 if(confirmar == true){
				grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cedeID');
				deshabilitaBoton('cancela', 'submit');
			}
		}
	});
	
	$('#cedeID').bind('keyup',function(e){				
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "nombreCliente";		
		 parametrosLista[0] = $('#cedeID').val();			
		lista('cedeID', 2, catTipoLista.cancela, camposLista, parametrosLista, 'listaCedes.htm');		
	});

	$('#cedeID').blur(function(){
		if(esTab){
			validaCede(this.id);
		}
	});

	$('#cancela').click(function() {	
		$('#tipoTransaccion').val(catTipoTransaccion.cancela);
	});
	
			
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			cedeID:{
				required: true,
			}
		},		
		messages: {
			cedeID:{
				required:'Especifique Número de Cede',
			}
		}
	});
	

	//------------ Funciones ------------------------------------------------------

	function validaCede(idControl){
		var jqCede = eval("'#" + idControl + "'");
		var numCede = $(jqCede).val();			
		var cedeBean = {
			'cedeID' : numCede
		};
		if(numCede != 0 && numCede != '' && !isNaN(numCede) && esTab){
			cedesServicio.consulta(catTipoConsulta.principal, cedeBean, function(cedesCon){
				if(cedesCon!=null){
					habilitaBoton('cancela', 'submit');
					estatus = cedesCon.estatus;
	
					if(cedesCon.cedeMadreID > 0){
						esAnclaje ='S';
					}else{
						esAnclaje='N';
					}
					
					$('#clienteID').val(cedesCon.clienteID);
					$('#cuentaAhoID').val(cedesCon.cuentaAhoID);
					$('#tipoCedeID').val(cedesCon.tipoCedeID);
					$('#tipoPagoInt').val(cedesCon.tipoPagoInt);
					
					$('#monto').val(cedesCon.monto);
					$('#plazo').val(cedesCon.plazo);
					$('#plazoOriginal').val(cedesCon.plazoOriginal);
					$('#fechaInicio').val(cedesCon.fechaInicio);
					$('#fechaVencimiento').val(cedesCon.fechaVencimiento);
					
					$('#tasaFija').val(cedesCon.tasaFija);
					$('#tasaISR').val(cedesCon.tasaISR);
					$('#tasaNeta').val(cedesCon.tasaNeta);
					$('#valorGat').val(cedesCon.valorGat);
					
					$('#interesGenerado').val(cedesCon.interesGenerado);
					$('#interesRetener').val(cedesCon.interesRetener);
					$('#interesRecibir').val(cedesCon.interesRecibir);
					$('#valorGatReal').val(cedesCon.valorGatReal);
					$('#totalRecibir').val(cedesCon.totalRecibir);
					$('#estatus').val(estatus);
					
					ponerFormatoMoneda();
					consultaCliente(cedesCon.clienteID);
					consultaTipoCede();
							
					
					if(estatus == 'C'){
						mensajeSis("El CEDE se encuentra Cancelado");
						deshabilitaBoton('cancela', 'submit');
						$('#cedeID').focus();
					}
					
					if(estatus == 'P'){		
						mensajeSis("El CEDE se encuentra Pagado (Abonado a Cuenta)");
						deshabilitaBoton('cancela', 'submit');
						$('#cedeID').focus();
					}
						
					
					if(estatus == 'A' || estatus == 'N'){
						if(cedesCon.fechaInicio != parametroBean.fechaSucursal){														
							mensajeSis("El Cede no es del Día de Hoy");
							deshabilitaBoton('cancela', 'submit');
							$('#cedeID').focus();
						}
					}
				}else{
					mensajeSis('El CEDE no Existe');
					deshabilitaBoton('cancela', 'submit');
					inicializaForma('formaGenerica','cedeID');
					$('#cedeID').focus();
					$(jqCede).select();
				}
			
			});				
		}else{
				deshabilitaBoton('cancela', 'submit');
				inicializaForma('formaGenerica','cedeID');
				$('#cedeID').focus();
				$('#cedeID').val('');
		}
	}	

	function consultaCliente(numCliente) {	
		var conCliente = 5;	
		var rfc = '';
		if(numCliente!='0'){
			setTimeout("$('#cajaLista').hide();", 200);		
			if(numCliente != '' && !isNaN(numCliente)){
				clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
							if(cliente!=null){
								$('#nombreCompleto').val(cliente.nombreCompleto);	
							}    			
							else{
								mensajeSis("El Cliente no Existe");
								deshabilitaBoton('cancela', 'submit');
							}	
					});
				}
			}		
		}
	
	
	function consultaTipoCede(){
		var tipoCede = $('#tipoCedeID').val();
		var conPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		
		var tipoCedeBean = {
                'tipoCedeID':tipoCede,               
        };		
			if(tipoCedeBean != 0){
				tiposCedesServicio.consulta(conPrincipal, tipoCedeBean, function(tipoCede){
					if(tipoCede!=null){
						$('#descripcion').val(tipoCede.descripcion);
						$('#diaInhabil').val(tipoCede.diaInhabil);
						validaSabadoDomingo();
					}
				});
			}
		}
	
	/* Valida el tipo de CEDES cuando se encuentre parametrizado dia inhábil: Sabado y Domingo
     * para que no se cancelen CEDES el día Sábado */
	function validaSabadoDomingo(){
		var fecha = parametroBean.fechaSucursal;
		var diaInhabil = $('#diaInhabil').val();
		var cede = $('#cedeID').val();
		var estatus = $('#estatus').val();
		var fechaInicio = $('#fechaInicio').val();
		var sabDom	='SD';
		var noEsFechaHabil = 'N';
		var vigente = 'N';
		var tipoCedeID = $('#tipoCedeID').val();
		
		var diaInhabilBean = {
				'fecha': fecha,
				'numeroDias': 0,
				'salidaPantalla':'S',
		};
		if (diaInhabil == sabDom && cede > 0 && estatus == vigente 
				&& fechaInicio == fecha){
			var sabado = 'Sábado y Domingo';	
			diaFestivoServicio.calculaDiaFestivo(3,diaInhabilBean,function(data){
				if(data!=null){
					$('#esDiaHabil').val(data.esFechaHabil);
					if($('#esDiaHabil').val() == noEsFechaHabil){
						mensajeSis("El Tipo de CEDE " +tipoCedeID +  " Tiene Parametrizado Día Inhábil: " + sabado + 
								" por tal Motivo No se Puede Cancelar el CEDE.");
						$('#cedeID').focus();
						$('#cedeID').select();
						$('#diaInhabil').val('');
						$('#esDiaHabil').val('');
						deshabilitaBoton('cancela', 'submit');						
					}
				}
			});
		}		
	}
	
	function ponerFormatoMoneda(){
		$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#tasaNeta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});		
		$('#interesGenerado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});		
		$('#totalRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});		
	}
	


});	