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
		'vencimientoAnt':11
	};
	
	var catTipoConsulta = {
			'vencimiento':9
		};
	 
	var catTipoLista ={
			'vencimiento' : 11
	};
	
	deshabilitaBoton('cancela', 'submit');	
	agregaFormatoControles('formaGenerica');
	$('#esAnclaje').val('');
	$('#anclajeHijo').val('');
	
	
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			var cedeMadre = $('#esAnclaje').val();
			var cedeHijo  = $('#anclajeHijo').val();
			if( cedeMadre == ''){
				 var confirmar = confirm("¿Está Seguro de Vencer Anticipadamente el CEDE?");
				 if(confirmar == true){
					grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cedeID');
					deshabilitaBoton('cancela', 'submit');
				}	
			}else {
				var confirmar = confirm("El CEDE " +$('#cedeID').val()+ " es parte de un Anclaje, al Vencer Anticipadamente" +
						" se vencerán todos los Anclajes Relacionados al CEDE. CEDE Madre: " +cedeMadre+ 
						" ANCLAJES: "+cedeHijo+" ¿Está Seguro de Vencer Anticipadamente el CEDE?");
				 if(confirmar == true){
					grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cedeID');
					deshabilitaBoton('cancela', 'submit');
				}	
				
			}
			
		
		}
	});
	
	$('#cedeID').bind('keyup',function(e){				
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "nombreCliente";		
		 parametrosLista[0] = $('#cedeID').val();			
		lista('cedeID', 2, catTipoLista.vencimiento, camposLista, parametrosLista, 'listaCedes.htm');		
	});

	$('#cedeID').blur(function(){
		if(esTab){

			validaCede(this.id);
		}
		
	});

	$('#cancela').click(function() {	
		$('#tipoTransaccion').val(catTipoTransaccion.vencimientoAnt);
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
			cedesServicio.consulta(catTipoConsulta.vencimiento, cedeBean, function(cedesCon){
				if(cedesCon!=null){
					habilitaBoton('cancela', 'submit');
					estatus = cedesCon.estatus;
					
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
					
					$('#interesGenerado').val(cedesCon.saldoProvision);
					$('#valorGatReal').val(cedesCon.valorGatReal);
					$('#estatus').val(estatus);
					
					
					
					ponerFormatoMoneda();
					consultaCliente(cedesCon.clienteID);
					consultaTipoCede();
					diasTranscurridos(cedesCon.inicioPeriodo, parametroBean.fechaSucursal);
					validaCedeAnclaje();
					
					
					diasBase = parametroBean.diasBaseInversion;		
					salarioMinimo = parametroBean.salMinDF; 
					var salarioMinimoGralAnu = parametroBean.salMinDF * 5 * parametroBean.diasBaseInversion; // Salario minimo General Anualizado
					// SI EL MONTO DE CEDE es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF), 
					// entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
					// si no es CERO
					interRetener = cedesCon.interesRetener;
					
					$('#interesRetener').val(interRetener);
					$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					
					
					var interGenerado =$('#interesGenerado').asNumber();
					var interRecibir = (interGenerado - interRetener);
					
					$('#interesRecibir').val(interRecibir);
					$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					
					total = $('#monto').asNumber() + interRecibir; 
					
					$('#totalRecibir').val(total);
					$('#totalRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					
					
					
					if(estatus == 'C'){
						mensajeSis("El CEDE se encuentra Cancelado");
						deshabilitaBoton('cancela', 'submit');
						$(jqCede).focus();
					}
					
					if(estatus == 'P'){		
						mensajeSis("El CEDE se encuentra Pagado (Abonado a Cuenta)");
						deshabilitaBoton('cancela', 'submit');
						$(jqCede).focus();
					}
						
					if(estatus == 'A'){		
						mensajeSis("El CEDE no esta Autorizado");
						deshabilitaBoton('cancela', 'submit');
						$(jqCede).focus();
					}
						
					
					if(estatus == 'N'){
						if(cedesCon.fechaInicio == parametroBean.fechaSucursal){														
							mensajeSis("El CEDE es del día de hoy, utilice la pantalla de Cancelación");
							deshabilitaBoton('cancela', 'submit');
							$(jqCede).focus();
						}
					}
				}else{
					mensajeSis('El CEDE no Existe');
					deshabilitaBoton('cancela', 'submit');
					inicializaForma('formaGenerica','cedeID');
					$(jqCede).focus();
					$(jqCede).select();
				}		
			});				
		}else {
			deshabilitaBoton('cancela', 'submit');
			inicializaForma('formaGenerica','cedeID');
			$(jqCede).focus();
			$(jqCede).val('');
			$(jqCede).select();
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
     * para que no se realicen vencimiento anticipados de CEDES el día Sábado */
	function validaSabadoDomingo(){
		var fecha = parametroBean.fechaSucursal;
		var diaInhabil = $('#diaInhabil').val();
		var cede = $('#cedeID').val();
		var estatus = $('#estatus').val();
		var diasTranscurridos = $('#diasTrans').val();
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
				&& diasTranscurridos >1){
			var sabado = 'Sábado y Domingo';	
			diaFestivoServicio.calculaDiaFestivo(3,diaInhabilBean,function(data){
				if(data!=null){
					$('#esDiaHabil').val(data.esFechaHabil);
					if($('#esDiaHabil').val() == noEsFechaHabil){
						mensajeSis("El Tipo de CEDE " +tipoCedeID +  " Tiene Parametrizado Día Inhábil: " + sabado + 
								" por tal Motivo No se Puede Realizar el Vencimiento Anticipado de CEDE.");
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
	
	//Función para calcular los días transcurridos entre dos fechas
	function diasTranscurridos(fInicio,fActual) {	
		var fechaInicio = new Date(fInicio);
	    var fechaActual = new Date(fActual);
	    var tiempo = fechaActual.getTime() - fechaInicio.getTime();
	    var dias = Math.floor(tiempo / (1000 * 60 * 60 * 24));
	    $('#diasTrans').val(dias);
		
	 }	

	
	function validaCedeAnclaje() {
		
		var cedeAnc = $('#cedeID').val();
		var tipConsulta = 3;
		setTimeout("$('#cajaLista').hide();", 200);
		if(cedeAnc != '' && !isNaN(cedeAnc)) {
				//preguntar si se ecnuentra en CEDEANCLAJE
				var cedeBean = {
					'cedeAnclajeID': cedeAnc
				};
				cedesAnclajeServicio.consulta(tipConsulta, cedeBean, function(cedeAncla) {
					if(cedeAncla != null && cedeAncla.cedeID != '0') {
						$('#esAnclaje').val(cedeAncla.cedeOriID);
						consultaAnclajeHijo();
					} else {
						$('#esAnclaje').val('');
					}
				});
			
		}

	}
	
	function consultaAnclajeHijo(){

		var cedeMadre = $('#esAnclaje').val();
		var tipConsulta = 4;
		setTimeout("$('#cajaLista').hide();", 200);
		if(cedeMadre != '' && !isNaN(cedeMadre)) {
				//preguntar si se ecnuentra en CEDEANCLAJE
				var cedeBean = {
					'cedeAnclajeID': cedeMadre
				};
				cedesAnclajeServicio.consulta(tipConsulta, cedeBean, function(cedeAncla) {
					if(cedeAncla != null && cedeAncla.cedeID != '0') {
						$('#anclajeHijo').val(cedeAncla.cedeOriID);
					} else {
						$('#anclajeHijo').val('');
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

