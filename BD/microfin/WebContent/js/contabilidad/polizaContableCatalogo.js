	var botonPrincipal = 0;
	$(document).ready(function(e) {
	
		esTab = true;
		press = false;
	
		$(':text').focus(function() {	
		 	esTab = false;
		 	press=false;
		});
	
		$(':text').bind('keydown',function(e){ 
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
				press=true;
			}
			if (e.which == 9 && e.shiftKey){
				press= false; //alert("44");
			}
		}); 
		
		$('#polizaID').focus();
		var parametroBean = consultaParametrosSession();   
		//Definicion de Constantes y Enums  
		var catTipoConsultaCtaContable = {
	  		'principal':1
		};	
		
		var catTipoTransaccionCtaContable = {
	  		'grabar':'6',
	  		'plantillaPoliza':'4'
		};
		
		var catTipoListaConConta = {
			'principal':1
		};
		
		var catTipoConsultaConConta = {
			'principal' : 1
		};
		var  catTipoConsultaEstatusFecha={
				'estatus' :4
		};	
		//------------ Metodos y Manejo de Eventos -----------------------------------------
	   deshabilitaBoton('grabar', 'submit');
	   deshabilitaBoton('imprimir', 'submit');
	   deshabilitaBoton('adjuntar', 'submit');
	   deshabilitaBoton('infAdicionalBtn', 'submit');
	   agregaFormatoControles('formaGenerica');
	   consultaMoneda();
		$.validator.setDefaults({
	      submitHandler: function(event) { 

	    	if(crearPoliza() != 1){
	            grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','polizaID','exitoPantalla','falloPantalla');
	    	}
	      }
	   });					
		
		$('#concepto').blur(function() {
	  		$('#desPlantilla').val($('#concepto').val());
		});
		
		$('#grabar').click(function(event) {
			if($('#plantilla').val()=='S'){
				$('#tipoTransaccion').val(catTipoTransaccionCtaContable.plantillaPoliza);		
			}else {
				$('#tipoTransaccion').val(catTipoTransaccionCtaContable.grabar);	
			}		
			$('#tipo').val('M');
			//crearPoliza();
		});	
		
		$('#grabar').attr('tipoTransaccion', '1');
		

		$('#polizaID').bind('keyup',function(e){
			if(this.value.length >= 2){ 
				var camposLista = new Array(); 
				var parametrosLista = new Array(); 
				camposLista[0] = "concepto";
				parametrosLista[0] = $('#polizaID').val();
				listaAlfanumerica('polizaID', '2', '1', camposLista, parametrosLista, 'polizaContListaVista.htm'); 
			};
		});
		
		$('#polizaID').blur(function() {
			 validaPoliza('polizaID');
			 $('#monedaID').val('PESOS');
			 $('#plantilla').val('N');

		});
		
		$('#conceptoID').bind('keyup',function(e){
			if(this.value.length >= 1){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "descripcion";			 			 
				parametrosLista[0] = $('#conceptoID').val();			
				listaAlfanumerica('conceptoID', 2, catTipoListaConConta.principal, camposLista,
						 parametrosLista, 'listaConceptosConta.htm');
			}
		});
		
		$('#conceptoID').blur(function() {
			  if(esTab){
				  if($('#conceptoID').val()!="" && $('#conceptoID').asNumber()>=0 && !isNaN($('#conceptoID').val() )){
					  consultaConceptoConta('conceptoID');  
				   }else{
				   		$('#conceptoID').focus();
					   $('#conceptoID').val("");
					   $('#concepto').val(""); 
					   setTimeout("$('#cajaLista').hide();", 200);
				   }
			   }
		});
		
	
	
		
		$('#fecha').change(function() { 
			var fechaelegida = $('#fecha').val(); 
			var fechaAplicacion = parametroBean.fechaAplicacion;
	  		if(esFechaValida(fechaelegida)){
	  			consultaEstatus(this.id);
				if(mayor(fechaelegida,fechaAplicacion)){
		  			mensajeSis("La fecha de la Póliza no debe ser mayor a la del Sistema");
		  			$('#fecha').val(fechaAplicacion);
		  			$('#fecha').focus();
		  		}
	  		}else{
	  			$('#fecha').val(fechaAplicacion);
	  		}
		});	
	
		$('#plantilla').click(function(event) {				
			if($('#plantilla').val()=='S'){
				$('#lbldes').show();
				$('#desPlantilla').show();	
				$('#desPlantilla').val($('#concepto').val());			
			}else {
				$('#lbldes').hide();
				$('#desPlantilla').hide();		
			}
		});	
		
		$('#plantilla').blur(function() {
			if($('#plantilla').val()=='S'){
				$('#lbldes').show();
				$('#desPlantilla').show();	
				$('#desPlantilla').val($('#concepto').val());			
			}else {
				$('#lbldes').hide();
				$('#desPlantilla').hide();		
			}
		});	

		$('#adjuntar').click(function() {		
			subirArchivosPoliza();
		});
	
		
	$('#imprimir').click(function() {	
		var poliza = $('#polizaID').val();	 
		var fecha =$('#fecha').val();
		window.open('RepPoliza.htm?polizaID='+poliza+'&fechaInicial='+fecha+
				'&fechaFinal='+fecha+'&nombreUsuario='+parametroBean.nombreUsuario);
	});	
		
	
	
		//------------ Validaciones de la Forma -------------------------------------
		$('#formaGenerica').validate({
			rules: {			 
				monedaID	: 'required',
				conceptoID	: 'required',
				fecha		: 'required',
				importe		: 'numeroPositivo',

				institucionID: {
					required: function() {return botonPrincipal == 1},
				},
				numCtaBancaria: {
					required: function() {return botonPrincipal == 1},
				},
				cuentaClabe: {
					required: function() {return botonPrincipal == 1},
				},
				tipoDoc: {
					required: function() {return botonPrincipal == 1},
				},
				numCheque: {
					required: function() {return botonPrincipal == 1},
				},
				pagadorID: {
					required: function() {return botonPrincipal == 1},
				},
				importe: {
					required: function() {return botonPrincipal == 1},
					number: true

				},
				referenciaDoc: {
					required: function() {return botonPrincipal == 1},
				},
				metodoPago: {
					required: function() {return botonPrincipal == 1},
				},
				monedaIDDoc: {
					required: function() {return botonPrincipal == 1},
				},
				tipoCambio: {
					required: function() {return botonPrincipal == 1},
				},
				instOrigenID: {
					required: function() {return botonPrincipal == 1 && ($('#metodoPago option:selected').text() =='TRANSFERENCIA')},
				},
				ctaClabeOrigen: {
					required: function() {return botonPrincipal == 1 && ($('#metodoPago option:selected').text() =='TRANSFERENCIA')},
					required: function() {return botonPrincipal == 1 && ($('#metodoPago option:selected').text() =='TRANSFERENCIA')},
					minlength: 18,
					maxlength: 18
				}

			},
			
			messages: {
				monedaID	: 'Especifique la Moneda',
				conceptoID	: 'Especifique el concepto',
				fecha		: 'Especifique la fecha',
				importe		: 'Cantidad Incorrecta',
				institucionID: {
					required: "Especifique Institución",
				},
				numCtaBancaria: {
					required: "Especifique Número de Cuenta Bancaria",
				},
				cuentaClabe: {
					required: "Especifique Cuenta Clabe",
				},
				tipoDoc: {
					required: "Especifique Tipo de Movimiento",
				},
				numCheque: {
					required: "Especifique Folio",
				},
				pagadorID: {
					required: "Especfique Pagador",
				},
				importe: {
					required: "Especifique Importe",
					number: "Solo números"
				},
				referenciaDoc: {
					required: "Especifique Referencia",
				},
				metodoPago: {
					required: "Especifique Método de Pago",
				},
				monedaIDDoc: {
					required: "Especifique Moneda",
				},
				tipoCambio: {
					required: "Especifique Tipo de Cambio",
				},
				instOrigenID: {
					required: "Especifique Institución de Origen",
				},
				ctaClabeOrigen: {
					required: "Especifique Cuenta Clabe de Origen",
					minlength: "Mínimo 18 caracteres",
					maxlength: "Máximo 18 caracteres"
				}
			}		
		}); 
		//------------ Validaciones de Controles ----------------------------------
	
		function validaPoliza(idControl) { 
			var jqPoliza = eval("'#" + idControl + "'");
			var numPoliza = $(jqPoliza).val();
			var conPrincipal = 1;
			var PolizaBeanCon = {
	  			'polizaID':numPoliza
			};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numPoliza != '' && !isNaN(numPoliza) && esTab){
				if(numPoliza=='0'){
					$('#fecha').val(parametroBean.fechaSucursal);   
					$('#conceptoID').val('');							
					$('#concepto').val('');
					$('#tipo').val('');	
					limpiaPolizaInfAdicional();
					botonPrincipal = 0;
					habilitaControl('conceptoID');					
					habilitaControl('concepto');	
				
					consultaDetalle();
					deshabilitaBoton('imprimir', 'submit');
					deshabilitaBoton('adjuntar', 'submit');
					deshabilitaBoton('infAdicionalBtn', 'submit');
					$('#divGridPolizaArchivo').html("");
					$('#divGridPolizaArchivo').hide();
					$('#informacionAdicional').hide();
					$('#detallePoliza').val("");
					$('#prorrateoHecho').val('N');										
					if($('#plantilla').val()=='S'){
						$('#lbldes').show();
						$('#desPlantilla').show();	
						$('#desPlantilla').val($('#concepto').val());			
					}else {
						$('#lbldes').hide();
						$('#desPlantilla').hide();		
					}
				} else {
					
					polizaServicio.consulta(conPrincipal, PolizaBeanCon, function(poliza){			
						if(poliza!=null){
							botonPrincipal = 1;	
							$('#polizaID').val(poliza.polizaID);				
							$('#fecha').val(poliza.fecha);
							$('#conceptoID').val(poliza.conceptoID);							
							$('#concepto').val(poliza.concepto);
							$('#tipo').val(poliza.tipo);
							consultaDetalle();
							consultaArchivosPoliza();		//consulta archivos de la poliza
							consultaPolizaInfAdicional();
							$('#informacionAdicional').show();
							deshabilitaControl('conceptoID');					
							deshabilitaControl('concepto');	
							habilitaBoton('imprimir', 'submit');
							habilitaBoton('adjuntar', 'submit');
							habilitaBoton('infAdicionalBtn', 'submit');
							if($('#plantilla').val()=='S'){
								$('#lbldes').show();
								$('#desPlantilla').show();	
								$('#desPlantilla').val($('#concepto').val());			
							}else {
								$('#lbldes').hide();
								$('#desPlantilla').hide();		
							}
						}else{	
							mensajeSis('No Existe la Poliza Contable. ');
							$('#polizaID').val('');
							$('#polizaID').focus();		
							deshabilitaBoton('grabar', 'submit');
							deshabilitaBoton('imprimir', 'submit');
							deshabilitaBoton('adjuntar', 'submit');
							deshabilitaBoton('infAdicionalBtn', 'submit');
		   				$('#fecha').val(parametroBean.fechaSucursal);  						
						}
					});
					deshabilitaBoton('grabar', 'submit');
				}					
			}  
		}
	
		function consultaConceptoConta(idControl){
			var conceptoConta = $('#conceptoID').val();		
			var tipoConsulta = catTipoConsultaConConta.principal;		
			setTimeout("$('#cajaLista').hide();", 200);	
			var conceptoContableBean = {
	      	'conceptoContableID':conceptoConta
			};		
				if(conceptoConta != '' && !isNaN(conceptoConta) && esTab){
					conceptoContableServicio.consulta(tipoConsulta, conceptoContableBean, function(conceptoContable){	
						if(conceptoContable!=null){
							$('#conceptoID').val(conceptoContable.conceptoContableID);							
							$('#concepto').val(conceptoContable.descripcion);						
						}else if($('#conceptoID').val() != 0){
							mensajeSis('No Existe el Concepto. '+conceptoConta);
							$('#conceptoID').val('');
							$('#concepto').val('');
							$('#conceptoID').focus();														
						}
					});
				}
		}
		
		
		function consultaDetalle(){	
			var params = {};
			params['tipoLista'] = 1;
			params['polizaID'] = $('#polizaID').val();
			
			$.post("gridPolizaContable.htm", params, function(data){
					if(data.length >0) {		
							$('#gridDetalle').html(data);
							$('#gridDetalle').show();
							 sumaCargosAbonos();
					}else{
							$('#gridDetalle').html("");
							$('#gridDetalle').show();
					}
			});
		}
		
		function consultaMoneda() {			
	  		dwr.util.removeAllOptions('monedaID');			
			monedasServicio.listaCombo(3, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
			});
		}
	   
		function validaIDs(){
			if (isNaN($("#polizaID").val())){
				mensajeSis("El número de Póliza debe ser un Numero Entero");
				$('#polizaID').val('');
				$('#polizaID').focus();
				return 1;
			}
			if($("#polizaID").asNumber()<0){
				mensajeSis("El número de Póliza debe ser un Numero Positivo");
				$('#polizaID').val('');
				$('#polizaID').focus();
				return 1;
			}
			if (isNaN($("#conceptoID").val())){
				mensajeSis("El número de Concepto debe ser un Numero Entero");
				$('#conceptoID').val('');
				$('#conceptoID').focus();
				return 1;
			}
			if($("#conceptoID").asNumber()<0){
				mensajeSis("El número de Concepto debe ser un Numero Positivo");
				$('#polizaID').val('');
				$('#conceptoID').focus();
				return 1;
			}
		}
	   //$('#fecha').val(parametroBean.fechaSucursal);  
	   
	   function crearPoliza(){	
			var mandar = verificarvacios();
			if(mandar!=1){   		  		
		   	quitaFormatoControles('gridDetalle');
				var numDetalle = $('input[name=consecutivoID]').length;
				$('#detallePoliza').val("");
				for(var i = 1; i <= numDetalle; i++){
					controlQuitaFormatoMoneda("cargos"+i+"");
					controlQuitaFormatoMoneda("abonos"+i+"");
					if(i == 1){
					$('#detallePoliza').val($('#detallePoliza').val() +
												$('#fecha').val() + ']' +
												document.getElementById("centroCostoID"+i+"").value + ']' +
												document.getElementById("cuentaCompleta"+i+"").value + ']' + 
												document.getElementById("referencia"+i+"").value + ']' + // agrega el instrumento 
												document.getElementById("referencia"+i+"").value + ']' + 
												document.getElementById("descripcion"+i+"").value + ']' + 
												$('#monedaID').val()+ ']' +  
												document.getElementById("RFC"+i+"").value + ']' + 
												document.getElementById("totalFactura"+i+"").value + ']' + 
												document.getElementById("folioUUID"+i+"").value + ']' + 
												document.getElementById("cargos"+i+"").value + ']' + 
												document.getElementById("abonos"+i+"").value+ ']');
					}else{
					$('#detallePoliza').val($('#detallePoliza').val() + '[' +
												$('#fecha').val() + ']' +
												document.getElementById("centroCostoID"+i+"").value + ']' +
												document.getElementById("cuentaCompleta"+i+"").value + ']' +
												document.getElementById("referencia"+i+"").value + ']' + // agrega el instrumento 
												document.getElementById("referencia"+i+"").value + ']' + 
												document.getElementById("descripcion"+i+"").value + ']' + 
												$('#monedaID').val()+ ']' +  
												document.getElementById("RFC"+i+"").value + ']' + 
												document.getElementById("totalFactura"+i+"").value + ']' + 
												document.getElementById("folioUUID"+i+"").value + ']' + 
												document.getElementById("cargos"+i+"").value + ']' + 
												document.getElementById("abonos"+i+"").value+ ']');			
					}	
				}
			}
			return mandar; 
		}
		
		
		// funcion para mostrar  ventana para adjuntar archivo
		var ventanaArchivosPoliza ="";
		function subirArchivosPoliza() {
			var url ="polizaFileUploadVista.htm?polizaID="+$('#polizaID').val();
			var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
			var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;
			ventanaArchivosPoliza = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
											"left="+leftPosition+
											",top="+topPosition+
											",screenX="+leftPosition+
											",screenY="+topPosition);	
		}		
	
		function mayor(fecha, fecha2){
			//0|1|2|3|4|5|6|7|8|9|
			//2 0 1 2 / 1 1 / 2 0
			var xMes=fecha.substring(5, 7);
			var xDia=fecha.substring(8, 10);
			var xAnio=fecha.substring(0,4);
	
			var yMes=fecha2.substring(5, 7);
			var yDia=fecha2.substring(8, 10);
			var yAnio=fecha2.substring(0,4);
			if (xAnio > yAnio){
				return true;
			}else{
				if (xAnio == yAnio){
					if (xMes > yMes){
						return true;
					}
					if (xMes == yMes){
						if (xDia > yDia){
							return true;
						}else{
							return false;
						}
					}else{
						return false;
					}
				}else{
					return false ;
				}
			} 
		}
		
		//funcion para validar la fecha
		function esFechaValida(fecha){
	
			if (fecha != undefined && fecha.value != "" ){
				var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
				if (!objRegExp.test(fecha)){
					mensajeSis("Formato de Fecha no válido (aaaa-mm-dd)");
					$('#fecha').val('');
					$('#fecha').focus();
					return false;
				}
	
				var mes=  fecha.substring(5, 7)*1;
				var dia= fecha.substring(8, 10)*1;
				var anio= fecha.substring(0,4)*1;
	
				switch(mes){
				case 1: case 3:  case 5: case 7:
				case 8: case 10:
				case 12:
					numDias=31;
					break;
				case 4: case 6: case 9: case 11:
					numDias=30;
					break;
				case 2:
					if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
					break;
				default:
					mensajeSis("Fecha introducida errónea");
				$('#fecha').val('');
				$('#fecha').focus();
				return false;
				}
				if (dia>numDias || dia==0){
					mensajeSis("Fecha introducida errónea");
					$('#fecha').val('');
					$('#fecha').focus();
					return false;
				}
				return true;
			}
		}
		function comprobarSiBisisesto(anio){
			if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
				return true;
			}
			else {
				return false;
			}
		}
		
		
		//consulta el estatus del periodo contable con la fecha que se ingresa 
		function consultaEstatus(idControl){
			var jqfecha = eval("'#" + idControl + "'");
			var fecha = $(jqfecha).val();	
			var tipoConsulta = catTipoConsultaEstatusFecha.estatus;		
			setTimeout("$('#cajaLista').hide();", 200);		
				var fechaBean = {
		      	'fecha':fecha
				};		
			if(fecha != '' ){
				periodoContableServicio.consulta(tipoConsulta, fechaBean, function(fechaEstatus){			
					if(fechaEstatus!=null){
						if(fechaEstatus.status=='C'){
							mensajeSis("El Período Contable para la Fecha Seleccionada se encuentra Cerrado");
							$(jqfecha).val(parametroBean.fechaSucursal);
							$(jqfecha).focus();
						}else{
							$('#conceptoID').focus();
						}
					}else{
						$('#conceptoID').focus();
					}
				});
			}
		}
		

			
	}); //cerrar Document
	function exitoPantalla() {
		//consulta archivos de la poliza
		var numPoliza = document.getElementById("polizaID").value;
		var conPrincipal = 1;
		var PolizaBeanCon = {
				'polizaID':numPoliza
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPoliza != '' && !isNaN(numPoliza) && esTab){ 
				polizaServicio.consulta(conPrincipal, PolizaBeanCon, function(poliza){			
					if(poliza!=null){
						$('#polizaID').val(poliza.polizaID);				
						$('#fecha').val(poliza.fecha);
						$('#conceptoID').val(poliza.conceptoID);							
						$('#concepto').val(poliza.concepto);
						deshabilitaGridPoliza();
						document.getElementById(consultaArchivosPoliza());		//consulta archivos de la poliza
						deshabilitaControl('conceptoID');					
						deshabilitaControl('concepto');	
						habilitaBoton('imprimir', 'submit');
						habilitaBoton('adjuntar', 'submit');	
						habilitaBoton('infAdicionalBtn', 'submit');
					}
				});
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('aplicaPro', 'submit');
								
		}  
	}
	
	function deshabilitaGridPoliza() {
		$('input[name=cargos]').each(function() {
			deshabilitaControl(this.id);		
		});
		$('input[name=abonos]').each(function() {
			deshabilitaControl(this.id);		
		});
		$('input[name=descripcion]').each(function() {
			deshabilitaControl(this.id);		
		});
		$('input[name=referencia]').each(function() {
			deshabilitaControl(this.id);		
		});
		$('input[name=cuentaCompleta]').each(function() {
			deshabilitaControl(this.id);		
		});
		$('input[name=centroCostoID]').each(function() {
			deshabilitaControl(this.id);		
		});
		$('input[name=consecutivoID]').each(function() {
			deshabilitaControl(this.id);		
		});
		$('input[id=agregaDetalle]').each(function() {
			deshabilitaControl(this.id);		
		});
		$('input[id=cargarCSV]').each(function() {
			deshabilitaControl(this.id);		
		});
		$('input[name=elimina]').each(function() {
			deshabilitaControl(this.id);		
		});
		$('input[name=agrega]').each(function() {
			deshabilitaControl(this.id);		
		});
	}
	
	function falloPantalla() {
	}
	//---------------------------------Funciones Grid de Movimientos-----------------
	function listaCentroCostos(idControl){
		var jq = eval("'#" + idControl + "'");
		
		$(jq).bind('keyup',function(e){
			var jqControl = eval("'#" + this.id + "'");
			var num = $(jqControl).val();
				
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = num;
			
			lista(idControl, '2', '1', camposLista, parametrosLista, 'listaCentroCostos.htm');
		});
	}
	
	//funcion para listar en el grid las cuentas contables
	function listaMaestroCuentas(idControl){
		var jqControl = eval("'#" + idControl+ "'");
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = $(jqControl).val();
		
		if($(jqControl).val() != '' && !isNaN($(jqControl).val() )){
			listaAlfanumerica(idControl, '1', '6', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
		else{
			listaAlfanumerica(idControl, '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}	
	
	//funcion para consultar la descripcion del estado  
	function maestroCuentasDescripcion(idControl) {
		var jq = eval("'#" + idControl + "'");	
		var jqDes = eval("'#desCuentaCompleta" + idControl.substr(14) + "'");
		var numCta = $(jq).val();
		var tipConForanea = 2;
		var ctaContableBeanCon = {
		  'cuentaCompleta':numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		if (numCta != '' && !isNaN(numCta) && esTab) {
			if(numCta.length >= 10){
				cuentasContablesServicio.consulta(tipConForanea,ctaContableBeanCon,function(ctaConta){
					if (ctaConta != null) {
						if(ctaConta.grupo != "E"){
							$(jqDes).val(ctaConta.descripcion);
						}  
						else{
							mensajeSis("Solo Cuentas Contables De Detalle");
							$(jq).val("");
							$(jqDes).val("");
							$(jq).focus();
						}
					} else {
						mensajeSis("La Cuenta Contable no existe.");
						$(jq).val("");
						$(jqDes).val("");
						$(jq).focus();
					}
				});
			}
		}
	}
	
	function cargosS(fila){
		var jqCargos = eval("'#"+"cargos"+fila+"'");
		var cargo = $(jqCargos).val();
		if(press){
			if(cargo > 0 && !isNaN(cargo) && esTab){
				$(jqCargos).select();
				
			}
			else 
			{	$(jqCargos).select();
				$(jqCargos).val('');
			}
		}
		$('#RFC'+fila).select();
	}
	
	function sumaCifrasControlCargos(fila){
		var jqCargos; 	
		var suma;
		var contador = 1;
		var cargo; 
		esTab=true; 
		suma= 0;
		var jqAbonos = eval("'#"+"abonos"+fila+"'");
	
		var abono = $(jqAbonos).val();
		if(press) {
			if(abono > 0 && !isNaN(abono) && esTab){ 
				$(jqAbonos).select(); 
			}
			else
			{	$(jqAbonos).select();
				$(jqAbonos).val('');
			}
		}

	  	$('input[name=cargos]').each(function() {
			jqCargos = eval("'#" + this.id + "'");
			cargo= $(jqCargos).asNumber(); 
			if(cargo != '' && !isNaN(cargo) && esTab){
				suma = suma + cargo;
				contador = contador + 1;	
			}
			else {
				$(jqCargos).val('0.00');
			}
		});
		$('#ciCtrlCargos').val(suma);
		agregaFormatoControles('gridDetalle');


		diferenciaCargosAbonos();
	}	
	
	
	function sumaCifrasControlAbonos(fila){
		var suma;
		var contador = 1;
		var jqAbonos;
		var abono;
		esTab=true;  
		suma= 0;
	  	$('input[name=abonos]').each(function() {
			jqAbonos = eval("'#" + this.id + "'");
			abono = $(jqAbonos).asNumber(); 
			if(abono != '' && !isNaN(abono) && esTab){
				suma = suma + abono;
				contador = contador + 1;
			}
			else{
				$(jqAbonos).val('0.00');
			}	
			if(abono = ''){
				$(jqAbonos).val('0.00');
			}
		});
		
		$('#ciCtrlAbonos').val(suma);
		agregaFormatoControles('gridDetalle');
		
		diferenciaCargosAbonos(fila);
	}	
	
	function diferenciaCargosAbonos(fila){
		var sumaCargos;
		var sumaAbonos;
		var diferencia;
		controlQuitaFormatoMoneda('ciCtrlCargos');
		controlQuitaFormatoMoneda('ciCtrlAbonos');
		
		sumaCargos= $('#ciCtrlCargos').asNumber();
		sumaAbonos= $('#ciCtrlAbonos').asNumber();
		
		
		diferencia= 0;
	  	if(sumaCargos>sumaAbonos){
	  		diferencia= (sumaCargos-sumaAbonos).toFixed(2);
	  		$('#diferencia').val(diferencia);
	  	}
	  	if(sumaCargos<sumaAbonos){
	  		diferencia= (sumaAbonos-sumaCargos).toFixed(2);
	  		$('#diferencia').val(diferencia);
	  	}
	  	if(sumaAbonos==sumaCargos){
	  		diferencia= 0;
	  		$('#diferencia').val(diferencia);
	  	}
	  	
	 	if($('#diferencia').asNumber() != 0){
			deshabilitaBoton('grabar', 'submit');
	  	}else{	
	  		habilitaBoton('grabar', 'submit');
	  		grabaTotalFactura(fila);	
	  	}
	 	
	 	
	 	var validaPartida=0;
	 	$('input[name=cargos]').each(function(){
  			var ID = this.id.substring(6);
  			
  			var jqCargo = eval("'#"+this.id+"'");
  			var jqAbono = eval("'#abonos"+ID+"'");
  			if(!$(jqCargo).is(':disabled')){
  				if($(jqCargo).asNumber()>0 || $(jqAbono).asNumber()>0){
  	  				validaPartida=1;
  	  			}
  			}
  			
  		});
	 	if(validaPartida==1){
  			if(!$('#prorrateoContable').is(':visible') && $('#prorrateoHecho').val()=='N'){
  				$('#aplicaPro').show(200);
  			}  			
  			validaPartida=0;
  		}else{
  			$('#aplicaPro').hide(200);
  		}
	 	
	  	//habilitaBoton('grabar', 'submit');
	  	actualizaFormatosMoneda('gridDetalle');
	}	
	
	/* Cancela las teclas [ ],intro en el formulario*/
	document.onkeypress = pulsarCorchete;  
	function pulsarCorchete(e) {
		tecla=(document.all) ? e.keyCode : e.which;
		if(tecla==91 || tecla==93 || tecla==13){
			
			return false; 
		}
		return true;  
	}
	
	
	/* funcion que identifica si existen valores tanto en cargos y abonos
	 	deja en 0 el  campo contrario y vuelve a calcular la diferencia */ 
	function consultaCargosAbonos(idControl){
		var numero= idControl.substr(6,idControl.length);
		var control=idControl.substr(0,6);
		
		if(control=='abonos'){
			var valoAbonos = $('#abonos'+numero).val();
			var valorCargos=$('#cargos'+numero).val();
			
			if(valorCargos !=0.00 && valoAbonos !=0){
				$('#cargos'+numero).val(0.00);	
				sumaCifrasControlAbonos(numero);
				sumaCifrasControlCargos(numero);			
			}  
					
		}
		if(control=='cargos'){
			var valoAbonos = $('#abonos'+numero).val();
			var valorCargos=$('#cargos'+numero).val();
			
			if(valorCargos !=0.00 && valoAbonos !=0){
				$('#abonos'+numero).val(0.00);		
				sumaCifrasControlCargos(numero);
				sumaCifrasControlAbonos(numero);
			}  
			
			
		}
		agregaFormatoControles('gridDetalle');
	}
	function sumaCargosAbonos(){
		var totalCargos=0.00;
		var totalAbonos=0.00;
		$('tr[name=renglon]').each(function(){

			var numero= this.id.substr(7,this.id.length);
			var jqCargos	=eval("'#cargos" + numero+ "'");	
			var jqAbonos	=eval("'#abonos" + numero+ "'");	


			totalCargos= parseFloat(totalCargos.toFixed(2))+ parseFloat($(jqCargos).asNumber());
			totalAbonos= parseFloat(totalAbonos.toFixed(2))+ parseFloat($(jqAbonos).asNumber());
			

		});
		
		$('#ciCtrlCargos').val( parseFloat(totalCargos.toFixed(2))); 
		$('#ciCtrlAbonos').val( parseFloat(totalAbonos.toFixed(2)));	
		$('#diferencia').val( parseFloat(totalCargos.toFixed(2)) - parseFloat(totalAbonos.toFixed(2)));
		actualizaFormatosMoneda('gridDetalle');
		 agregaFormatoControles('formaGenerica');
		  	


	}
	
	function cuadrarCargosAbonos(){
		var cargoBase = $('#ciCtrlCargos').asNumber(), abonoBase = $('#ciCtrlAbonos').asNumber();
		var sumaCargos = 0.00 , sumaAbonos = 0.00, ID=0;
		
		$('input[name=cargos]').each(function(){
			ID = this.id.substring(6);
			var evalCargo = eval("'#cargos"+ID+"'");
			var evalAbono = eval("'#abonos"+ID+"'");
			
			sumaCargos += $(evalCargo).asNumber();
			sumaAbonos += $(evalAbono).asNumber();			
		});
		if(parseFloat(sumaCargos.toFixed(2)) < parseFloat(cargoBase.toFixed(2))){
			
			var diferencia =  parseFloat(cargoBase.toFixed(2)) - parseFloat(sumaCargos.toFixed(2));
			var ultCampoID = sacaUltCampo('cargos');
			var ultCampo = eval("'#"+ultCampoID+"'");
			$(ultCampo).val(parseFloat($(ultCampo).asNumber() + parseFloat(diferencia.toFixed(2))).toFixed(2));
			
		}else if(parseFloat(sumaCargos.toFixed(2)) > parseFloat(cargoBase.toFixed(2))){
			
			var diferencia =  parseFloat(sumaCargos.toFixed(2)) - parseFloat(cargoBase.toFixed(2)) ;
			var ultCampoID = sacaUltCampo('cargos');
			var ultCampo = eval("'#"+ultCampoID+"'");
			$(ultCampo).val(parseFloat($(ultCampo).asNumber()-parseFloat(diferencia.toFixed(2))).toFixed(2));
		}
		
		if(parseFloat(sumaAbonos.toFixed(2)) < parseFloat(abonoBase.toFixed(2))){
			
			var diferencia = parseFloat(abonoBase.toFixed(2)) - parseFloat(sumaAbonos.toFixed(2));
			var ultCampoID = sacaUltCampo('abonos');
			var ultCampo = eval("'#"+ultCampoID+"'");
			$(ultCampo).val(parseFloat($(ultCampo).asNumber() + parseFloat(diferencia.toFixed(2))).toFixed(2));
			
		}else if(parseFloat(sumaAbonos.toFixed(2)) > parseFloat(abonoBase.toFixed(2))){
			
			var diferencia = parseFloat(sumaAbonos.toFixed(2)) - parseFloat(abonoBase.toFixed(2));
			var ultCampoID = sacaUltCampo('abonos');
			
			var ultCampo = eval("'#"+ultCampoID+"'");
			$(ultCampo).val(	parseFloat($(ultCampo).asNumber() - parseFloat(diferencia.toFixed(2))).toFixed(2)	);
		}
		actualizaFormatosMoneda('gridDetalle');

	}
	
	function sacaUltCampo(control){
		var numeroDetalle = $('input[name=consecutivoID]').length;		
		for(var i=numeroDetalle;i>0; i--){
			
			var jqValorCargoAbono = eval("'#"+control+i+"'");
			
			if($(jqValorCargoAbono).asNumber()>0){				
				return (control+i);
			}
		}
		return '';
	}
	//------------------------------FUNCIONES GIRD DE ARCHIVOS DE POLIZAS------------------------------
	// función para grid (archivos de la Poliza seleccionada)
		function consultaArchivosPoliza(){	
			var cero=0;
			var params = {};
			params['tipoLista'] = 2;
			params['polizaArchivosID'] =cero ;
			params['polizaID'] = $('#polizaID').val();
		
			$.post("polizaArchivosGridVista.htm", params, function(data){
					if(data.length >0) {		
							$('#divGridPolizaArchivo').html(data);
							$('#divGridPolizaArchivo').show();					
					}else{				
							$('#divGridPolizaArchivo').html("");
							$('#divGridPolizaArchivo').show();
					}
			});
		}
	
	
		//funcion para eliminar el documento 
		function  eliminaArchivo(PolizaArchivosID){
			var tipoTransaccionBaja = 1;
			var polizaArchivoBean = {
				'polizaArchivosID'	:PolizaArchivosID
			};
			$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
			$('#contenedorForma').block({
					message: $('#mensaje'),
				 	css: {border:		'none',
				 			background:	'none'}
			});
			polizaArchivosServicio.bajaArchivosPoliza(polizaArchivoBean,tipoTransaccionBaja,function(mensajeTransaccion) {
				if(mensajeTransaccion!=null){
					mensajeSis(mensajeTransaccion.descripcion);
					$('#contenedorForma').unblock(); 
					consultaArchivosPoliza();
		
				}else{				
					mensajeSis("Existio un Error al Borrar el Documento");			
				}
			});
		}
	
	
	
		// funcion para mostrar en pantalla o descargar un archivo de una poliza
		function verArchivo(id,recurso) {
			var parametros = "?recurso="+recurso;
			
			var pagina="polizaArchivosVer.htm"+parametros;
			var idrecurso = eval("'#recursoPolizaInput"+ id+"'");
			var extensionArchivo=  $(idrecurso).val().substring( $(idrecurso).val().lastIndexOf('.'));
			extensionArchivo = extensionArchivo.toLowerCase();
			if(extensionArchivo==".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg" || extensionArchivo == ".gif"){
				
				$('#imgPoliza').attr("src",pagina); 		
				$('#imagenPoliza').html(); 
				  $.blockUI({message: $('#imagenPoliza'),
					   css: { 
		           top:  ($(window).height() - 400) /2 + 'px', 
		           left: ($(window).width() - 400) /2 + 'px', 
		           width: '400px' 
		       } });  
				  $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
			}else{
				window.open(pagina,'_blank');
				$('#imagenPoliza').hide();
			}	
		} 
		// para deshabilitar el boton agregar cuando se consulta una poliza que ya existe
		function verificaDatos(){
			if($('#polizaID').val()!=0){
				deshabilitaBoton('agregaDetalle','boton' );
				deshabilitaBoton('cargarCSV','boton' );
			}else{
				habilitaBoton('agregaDetalle','boton' );
				habilitaBoton('cargarCSV','boton' );
				
			}
		}
		
		function verificarvacios(){
			var mostrarAlert= 1;
			var totalCargos=0;
			var totalAbonos=0;
			quitaFormatoControles('gridDetalle');
			var numDetalle = $('input[name=consecutivoID]').length;
			$('#detallePoliza').val("");
			
			for(var i = 1; i <= numDetalle; i++){
				controlQuitaFormatoMoneda("cargos"+i+"");
				controlQuitaFormatoMoneda("abonos"+i+"");
				
				var idcc = eval("'#centroCostoID"+i+"'");
				var valcc = $(idcc).val();
	 			if (valcc ==""){
	 				$(idcc).focus();
	 				$(idcc).val("");
					$(idcc).addClass("error");
					if(mostrarAlert == 1){
						mensajeSis("Especifique Centro de Costos.");
						mostrarAlert = 0;
					}	
	 				return 1; 
	 			}else{
	 				if (isNaN(valcc) || valcc<0){
	 					$(idcc).focus();
	 	 				$(idcc).val("");
	 					$(idcc).addClass("error");
	 					if(mostrarAlert == 1){
	 						mensajeSis("Especifique Centro de Costos Correcto.");
	 						mostrarAlert = 0;
	 					}	
	 				}
	 			} 			
				var idcco = eval("'#cuentaCompleta"+i+"'");
				var valcco = $(idcco).val();
	 			if (valcco ==""){
	 				$(idcco).focus();
	 				$(idcco).val("");
					$(idcco).addClass("error");
					if(mostrarAlert == 1){
						mensajeSis("Especifique Cuenta Contable.");
						mostrarAlert = 0;
					}
					return 1; 
	 			}else{
	 				if (isNaN(valcco) || valcco<0){
	 					$(idcco).focus();
	 	 				$(idcco).val("");
	 					$(idcco).addClass("error");
	 					if(mostrarAlert == 1){
	 	 					mensajeSis("Especifique una Cuenta Contable correcta.");
	 	 					mostrarAlert = 0;
	 					}
	 					return 1; 
	 				}
	 			}
	 			
	 			var idr = eval("'#referencia"+i+"'");
				var valr = $(idr).val();
	 			if (valr ==""){
	 				$(idr).focus();
	 				$(idr).val("");
					$(idr).addClass("error");
					if(mostrarAlert == 1){
						mensajeSis("Especifique Referencia.");
						mostrarAlert = 0;
					}
					return 1; 
	 			}
	 			
	 			var idd = eval("'#descripcion"+i+"'");
				var vald = $(idd).val();
	 			if (vald ==""){
	 				$(idd).focus();
	 				$(idd).val("");
					$(idd).addClass("error");
					if(mostrarAlert == 1){
						mensajeSis("Especifique Descripción.");
						mostrarAlert = 0;
					}
					return 1; 
	 			}

	 			var idcargos = eval("'#cargos"+i+"'");
				var valcargos = parseFloat($(idcargos).val());				

				var idabonos = eval("'#abonos"+i+"'");
				var valabonos = parseFloat($(idabonos).val());				
				
				if(valcargos==0 && valabonos==0){
					mensajeSis('Especifique un Cargo o Abono');
					$(idcargos).focus();
					$(idcargos).addClass("error");
					return 1;
				}
				}			
		}
		

		function mascara(fila){
			mascaraForma(fila,'-',patronFolio,true);
	    	
		}

		var patronFolio = new Array(8,4,4,4,12)
		function mascaraForma(d,sep,pat,nums){


		if(d.valant != d.value){

			valorFolio = d.value
			largo = valorFolio.length
			valorFolio = valorFolio.split(sep)
			valorFolio2 = ''
			for(r=0;r<valorFolio.length;r++){
				valorFolio2 += valorFolio[r]	
			}

			valorFolio = ''
			valorFolio3 = new Array()
			for(s=0; s<pat.length; s++){
				valorFolio3[s] = valorFolio2.substring(0,pat[s])
				valorFolio2 = valorFolio2.substr(pat[s])
			}
			for(q=0;q<valorFolio3.length; q++){
				if(q ==0){
					valorFolio = valorFolio3[q]
				}
				else{
					if(valorFolio3[q] != ""){
						valorFolio += sep + valorFolio3[q]
					
						}
				}
			}
			d.value = valorFolio
			d.valant = valorFolio
			}
		}
		
		function validaFolioUUID(fila){
			esTab=true; 
			expr = /^([0-9A-F]{8}[-][0-9A-F]{4}[-][0-9A-F]{4}[-][0-9A-F]{4}[-][0-9A-F]{12})$/;
			var jqFolioUUID = eval("'#"+fila+"'");
			
			var valFolioUUID = $(jqFolioUUID).val();
			if(valFolioUUID != '' && esTab){	
		    if (!expr.test(valFolioUUID)) { 
		      mensajeSis("El Folio UUID no es válido");
		      $(jqFolioUUID).focus();
		    	
		     }
			}
			}
		
		
		
		function validaRFC(fila){
			esTab=true; 
			expr = /^[a-zA-Z]{3,4}(\d{6})((\D|\d){3})?$/;
			
			var jqRFC = eval("'#"+fila+"'");
			var claveRFC = $(jqRFC).val();
		
			if(claveRFC != '' && esTab){	
			    if (!expr.test(claveRFC)) { 
			       mensajeSis("El RFC no es válido");
			       $(jqRFC).focus();
			    	
			    	
			     }
			}

			}
		
		function grabaTotalFactura(fila){
			 $('input[name=cargos]').each(function(){
				 
				var i = this.id.substring(6);
			
				totalCargos= $('#ciCtrlCargos').val();
		
			if(totalCargos != '0.00'){	
				
				var jqTotalFact = eval("'#totalFactura" + i + "'");
				$(jqTotalFact).val(totalCargos);
			  
			    	 }	     
		 }); 
			}
		
	 
	function validaCentroCostos(fila){
		esTab=true; 
		var jqCentro = eval("'#"+fila+"'");

		var numcentroCosto = $(jqCentro).val();
		var tipoLista=1;
		
		if(numcentroCosto != '' && !isNaN(numcentroCosto) && esTab){
				var centroBeanCon = {  
					'centroCostoID':numcentroCosto
			 }; 
			centroServicio.consulta(tipoLista,centroBeanCon,function(centro) { 
					if(centro!=null){								
					}else{
							mensajeSis('El Centro de Costo No Existe');
							$(jqCentro).val('');				
							$(jqCentro).focus();
					} 
				});
		}
	}

	function funcionExitoAdjunta(){
		consultaArchivosPoliza();
	}

		
