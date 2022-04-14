	esTab = true;
	var parametroBean = consultaParametrosSession();   
	var MontoMaxCre =0;	 
	var MontoMinCre =0;	

	//Definicion de Constantes y Enums  
	var catTipoConCreditoGrup = {
	    'principal':1,
  		'soliLiberada':12
  	};
	
	var catTipoTranSolicitud = {
	  	'actualiza':3 
	};
		 
	var catTipoActSolicitud = {
  		'autoriza':1,
  		'regresaEjec':3,
  		'rechazo':4
  		
	};
	
	var catTipoLisSolicitud = {
		'gridFirmasOtor' :2,
  		'gridFirmasAut'  :6
	};
    $(document).ready(function() {
	
	$("#grupoID").focus();
	
	$('#fechaAutoriza').val(parametroBean.fechaSucursal);
	$('#sucursalLogeado').val(parametroBean.sucursal);
	
	deshabilitaBoton('guardarAutoriza', 'submit');
	deshabilitaBoton('guardarRechazo', 'submit');
 	deshabilitaBoton('guardarRegresar', 'submit');
 	
	deshabilitaBoton('rechazar', 'submit');
	deshabilitaBoton('regresarEjec', 'submit');
	deshabilitaBoton('autorizar', 'submit');
 	
	
	$(':text').focus(function() {
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
		esTab= true;
		}
	});
	
	agregaFormatoControles('formaGenerica');
	$.validator.setDefaults({
		submitHandler: function(event) {
      	  	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','grupoID','exitoAutorizacionSolicitudGrupal','errorAutorizacionSolicitudGrupal');
		}
	});
	
	$('#grupoID').bind('keyup',function(e){
	 if(this.value.length >= 2){ 
		 var camposLista = new Array(); 
		 var parametrosLista = new Array(); 
		 	camposLista[0] = "nombreGrupo";
		 	parametrosLista[0] = $('#grupoID').val();
		 	lista('grupoID', '2', '3', camposLista, parametrosLista, 'listaGruposCredito.htm'); }
 	});
	 
	$('#grupoID').blur(function() { 
		validaGrupo(this.id);
	});
	
	$('#rechazar').click(function() {
		habilitaBoton('guardarRechazo', 'submit');
		$('#eComentario').text('Motivo de Rechazo:');
		$('#comentarioEjecutivo').val('');
		$('#guardarRechazo').show();
		$('#guardarRegresar').hide();
		visualizaGridComentariosRechazoRegreso();
		$('#legendRegreso').text("Rechazar Solicitud");
		$('#legendRegreso').show();		
	});
	
	$('#regresarEjec').click(function() {
	 	habilitaBoton('guardarRegresar', 'submit');
		$('#eComentario').text('Motivo de Devolución:');
		$('#comentarioEjecutivo').val('');
		$('#guardarRegresar').show();	
		$('#guardarRechazo').hide();
		visualizaGridComentariosRechazoRegreso();
		$('#legendRegreso').text("Regresar Solicitud a Ejecutivo");
		$('#legendRegreso').show();
		$("#comentarioMesaControl").rules("remove");
		
	});
	
	$('#autorizar').click(function(event) {
		validaMontoSolicitado(event);	
		consultaCuenta(this.id);
		$('#comentarioMesaControl').val('');
		$('#comentarioEjecutivo').val('');
		visualizaGridComentariosAutoriza();
		validaCliente(this.id);
			
	});

	// Guardar el Rechazo de la Solicitud Grupal
	$('#guardarRechazo').click(function(event) {
		var coment = $('#comentarioEjecutivo').val();	
		if(coment == ""){
			mensajeSis("El Comentario esta Vacío");
			event.preventDefault();	
			$('#comentarioEjecutivo').focus();
		}else{
			$('#tipoTransaccion').val(catTipoTranSolicitud.actualiza);	
			$('#tipoActualizacion').val(catTipoActSolicitud.rechazo);
			solicitudCredito();
		}
	});
	
	// Guardar el Regreso de la Solicitud Grupal
	$('#guardarRegresar').click(function(event) {
		var coment = $('#comentarioEjecutivo').val();	
		if(coment == ""){
			mensajeSis("El Comentario esta Vacío");
			event.preventDefault();	
			$('#comentarioEjecutivo').focus();
		}else{	
			$('#tipoTransaccion').val(catTipoTranSolicitud.actualiza);	
			$('#tipoActualizacion').val(catTipoActSolicitud.regresaEjec);	
			solicitudCredito();
		}
	});
	
	// Guardar la Autorizacion de la Solicitud Grupal
	$('#guardarAutoriza').click(function(event) {
			$('#tipoTransaccion').val(catTipoTranSolicitud.actualiza);	
			$('#tipoActualizacion').val(catTipoActSolicitud.autoriza);	
			autorizaSolicitudCredito();
	});
	

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			grupoID:  {
				required:true
			},
			comentarioMesaControl : {
				maxlength : 100
			},
			comentarioEjecutivo : {
				maxlength : 100
			}
		
		},	
		messages: {			
			grupoID: {
				required: 'Especifique el Grupo'
			},
			comentarioMesaControl :{
				maxlength : 'Máximo 100 caracteres'
			},
			comentarioEjecutivo :{
				maxlength : 'Máximo 100 caracteres'
			}
			 
		}		
	});
	
	 
	//------------ Validaciones de Controles -------------------------------------


}); //FIN DE DOCUMENT
	//Funcion para Consultar el Grupo 
	function validaGrupo(idControl){
		$('#gridComentariosRechazoRegreso').hide();
	 	$('#gridComentariosAutoriza').hide();
	 	deshabilitaBoton('guardarAutoriza', 'submit');
		deshabilitaBoton('guardarRechazo', 'submit');
		deshabilitaBoton('guardarRegresar', 'submit');
		deshabilitaBoton('rechazar', 'submit');
		deshabilitaBoton('regresarEjec', 'submit');
		deshabilitaBoton('autorizar', 'submit');	
		$('#detalleFirmasAutoriza').val('');
		$('#listaIntegrantes').val('');

		var jqGrupo  = eval("'#" + idControl + "'");
		var grupo = $(jqGrupo).val();	 
		
		var grupoBeanCon = { 
				'grupoID':grupo,
				'usuario':parametroBean.numeroUsuario
		};	
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		if(grupo == 0 && esTab){
				inicializaForma('formaGenerica','grupoID');
				limpiaFormulario();
		}
		
		if(grupo != 0 && !isNaN(grupo) && esTab){
			$('#nombreGrupo').val('');	
			$('#ciclo').val('');
			
			gruposCreditoServicio.consulta(catTipoConCreditoGrup.principal,grupoBeanCon,function(grupos) {
			if(grupos!=null){
				esTab=true;  
				validaGrupoSolicitudesLiberadas('grupoID');

			}else{ 
				mensajeSis("El Grupo no Existe.");
				$(jqGrupo).focus();
				$(jqGrupo).val('');
				limpiaFormulario();
				}
			});	

		}
   }
	
	//Funcion para Consultar el Grupo con Solicitudes Liberadas
	function validaGrupoSolicitudesLiberadas(idControl){
		$('#gridComentariosRechazoRegreso').hide();
	 	$('#gridComentariosAutoriza').hide();
	 	deshabilitaBoton('guardarAutoriza', 'submit');
		deshabilitaBoton('guardarRechazo', 'submit');
		deshabilitaBoton('guardarRegresar', 'submit');
		deshabilitaBoton('rechazar', 'submit');
		deshabilitaBoton('regresarEjec', 'submit');
		deshabilitaBoton('autorizar', 'submit');	

		var jqGrupo  = eval("'#" + idControl + "'");
		var grupo = $(jqGrupo).val();	 
		
		var grupoBeanCon = { 
				'grupoID':grupo,
				'usuario':parametroBean.numeroUsuario
		};	
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		if(grupo == 0 && esTab){
				inicializaForma('formaGenerica','grupoID');
				limpiaFormulario();
		}
		
		if(grupo != 0 && !isNaN(grupo) && esTab){
			$('#nombreGrupo').val('');	
			$('#ciclo').val('');
			
			gruposCreditoServicio.consulta(catTipoConCreditoGrup.soliLiberada,grupoBeanCon,function(grupos) {
			if(grupos!=null && grupos.estatusSol=='L'){
				esTab=true;  
				$('#fechaAutoriza').val(parametroBean.fechaSucursal);
				$('#nombreGrupo').val(grupos.nombreGrupo);	
				$('#ciclo').val(grupos.cicloActual);
				$('#estatus').val(grupos.estatusSol);
				sucursalSolicitud = grupos.sucursalID;
				sucursalLogeado = parametroBean.sucursal;
				atiendeSucursal=grupos.promAtiendeSuc;			
				$('#atiendeSucursal').val(grupos.promAtiendeSuc);
				$('#sucursalSolicitud').val(grupos.sucursalID);
				               
                 if(sucursalLogeado != sucursalSolicitud && atiendeSucursal=='S'){
                	 mensajeSis("El Grupo no tiene Solicitudes en esta Sucursal.");
                	 $(jqGrupo).focus();
     				 $(jqGrupo).val('');
     				 limpiaFormulario();
                 }
                 else{
     				consultaIntegrantesGrid();
    				consultaFirmasOtorgadasSolGrid();
  
                 }

			}else{ 
				mensajeSis("El Grupo no tiene Solicitudes Liberadas.");
				$(jqGrupo).focus();
				$(jqGrupo).val('');
				limpiaFormulario();
				}
			});	

		}
   }
 
	//Funcion para Consultar de Producto de Credito
	function consultaProducCredito(idControl) {  
			var jqProdCred  = eval("'#" + idControl + "'");
			var ProdCred = $(jqProdCred).val();			
			var ProdCredBeanCon = {
	  			'producCreditoID':ProdCred 
			}; 
			setTimeout("$('#cajaListaContenedor').hide();", 200);
			var conPrincipal= 1;
				if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
					productosCreditoServicio.consulta(conPrincipal,ProdCredBeanCon,function(prodCred) {
						if(prodCred!=null){
							$('#descripProducto').val(prodCred.descripcion);
							 consultaFirmasAutorizarSolGrid();
							 MontoMaxCre =prodCred.montoMaximo;	
							 MontoMinCre = prodCred.montoMinimo;
						}
					});
				}				 					
		}
	
	
	//Funcion para Consultar los Integrantes del Grupo
	function consultaIntegrantesGrid(){
		$('#integrantesGrupo').val('');
		var params = {};		
	
		params['tipoLista'] = 12;
		params['grupoID'] = $('#grupoID').val();
		params['ciclo'] = $('#ciclo').val();

		$.post("integrantesSolicitudGrupoGridVista.htm", params, function(data){
			
			if(data.length >0) { 
				$('#integrantesGrupo').html(data);
				$('#integrantesGrupo').show();
				montoAutorizado(this.id);
				agregaFormatoControles('integrantesGrupo');
				var productCred = $('#prodCreditoID').val();
				$('#producCreditoID').val(productCred);
	
				consultaProducCredito('producCreditoID');	

			}else{
				$('#integrantesGrupo').html("");
				$('#integrantesGrupo').show();
			}			
		}); 

	}
	
	// Muestra el grid cuando cuando se rechaza o se regresa a ejecutivo  una solicitud de credito
	 function visualizaGridComentariosRechazoRegreso(){			
	 	 $('#gridComentariosRechazoRegreso').show();	
	 	 $('#gridComentariosAutoriza').hide();	 	 
	 }
	 
	// Muestra el grid para autorizar una solicitud de credito
	 function visualizaGridComentariosAutoriza(){	
		 $('#gridComentariosRechazoRegreso').hide();
	 	 $('#gridComentariosAutoriza').show();		 	
		}

  
	  //Valida Monto Solicitado 
	  function validaMontoSolicitado(event){
		  var montoAutor=0;
	  		$('input[name=montoAutori]').each(function() {
	  			var numero = this.id.substr(11, this.id.length);
	  			var montoAutori= eval("'#montoAutori" + numero + "'");
	  			var solicitud= eval("'#solicitudCre" + numero + "'");
	  			var checkSolicitud= eval("'#checkSolicitud" +numero+ "'");
	  			var montoAuto=$(montoAutori).asNumber();
	  			var soli=$(solicitud).asNumber();
	  			montoAutor=montoAuto;
	  			
			if(montoAutor > MontoMaxCre && ($(checkSolicitud).is(':checked')) == true){
				$('#montoProd').val(MontoMaxCre);
				$('#montoProd').formatCurrency({	positiveFormat: '%n', negativeFormat: '%n',  roundToDecimalPlace: 2	});
				var MontFormat = $('#montoProd').val();
				mensajeSis("El Monto Autorizado de la Solicitud " +soli +" no debe ser Mayor a "+ MontFormat);
				$(montoAutori).val('0.00');
  				$(montoAutori).focus();
				event.preventDefault();
				return false;
			}
			if(montoAutor < MontoMinCre && ($(checkSolicitud).is(':checked')) == true){
				$('#montoProd').val(MontoMinCre);
				$('#montoProd').formatCurrency({	positiveFormat: '%n', negativeFormat: '%n',  roundToDecimalPlace: 2	});
				var MontFormat = $('#montoProd').val();
				mensajeSis("El Monto Autorizado de la Solicitud " +soli +" no debe ser Menor a "+ MontFormat);

				$(montoAutori).val('0.00');
  				$(montoAutori).focus();
				event.preventDefault();
				return false;
			}
	  	});

	  }
	  
	  /*Funcion para validar que el cliente cuente
	  con una cuenta principal */
	 function consultaCuenta(idControl){
		    var tipoConsulta=15;
			$('input[name=cliente]').each(function() {
				var numero = this.id.substr(7, this.id.length);
				var cliente= eval("'#cliente" + numero + "'");
	  			var checkSolicitud= eval("'#checkSolicitud" +numero+ "'");
	  			var clien=$(cliente).asNumber();
	  			
	  		    var numClienteBean={
						'clienteID' :clien,
				};
	  			
	  			if(clien != '' && !isNaN(clien) && ($(checkSolicitud).is(':checked')) == true){
	  				cuentasAhoServicio.consultaCuentasAho(tipoConsulta, numClienteBean, function(cuenta) {
						if(cuenta==null){
							mensajeSis("El Cliente "+clien +" debe de tener una Cuenta Principal Activa.");
						 	 $('#gridComentariosAutoriza').hide();
						}
	  			});
			}
		});
	 }
	  	
	// Consulta las firmas pendientes a autorizar
	  	function consultaFirmasAutorizarSolGrid(){
			var params = {};		
			params['tipoLista'] = catTipoLisSolicitud.gridFirmasAut;    
			params['esquemaID'] = $('#esquemaSolicitud1').val();  
			params['productoCreditoID'] = $('#producCreditoID').val();
			params['usuario'] = parametroBean.numeroUsuario;
			
			$.post("firmasautorizaSolGridVista.htm", params, function(data){
				if(data.length >0) { 
					$('#gridFirmasAutoriza').html(data); 
					$('#gridFirmasAutoriza').show();
					
					consultaEstado();													
					//si no hay resultados se oculta el grid
					var numFilas= consultaFilas();
					if(numFilas==0){
						$('#gridFirmasAutoriza').html("");
						$('#gridFirmasAutoriza').show();					
					}
				}else{
					$('#gridFirmasAutoriza').html("");
					$('#gridFirmasAutoriza').hide();
				}			
			});
		 }
	  	
  	// consulta las firmas otorgadas 
  	function consultaFirmasOtorgadasSolGrid(){
  		$('#gridFirmasOtorgadas').html('');

		var params = {};		
		params['tipoLista'] = catTipoLisSolicitud.gridFirmasOtor;
		params['grupoID'] = $('#grupoID').val();
		params['usuario'] = parametroBean.numeroUsuario;
		
		$.post("firmasautorizadasSolGridVista.htm", params, function(data){
			
			if(data.length >0) { 
				$('#gridFirmasOtorgadas').html(data); 
				$('#gridFirmasOtorgadas').show();
				
				var numRenglones= consultaRenglones();
				if(numRenglones==0){
					$('#gridFirmasOtorgadas').html("");
					$('#gridFirmasOtorgadas').show();						
				}
			}else{
				$('#gridFirmasOtorgadas').html("");
				$('#gridFirmasOtorgadas').show();
			}			
		}); 
	}			

	// Habilita boton Guardar Atorizar
	function consultaEstado(){
		var numFilas=consultaFilas();
		var cuenta=cuentaSeleccionados();
		var estatus=$('#estatus').val();
			if(numFilas!=0 && cuenta!=0 && estatus =='L'){
				habilitaBoton('guardarAutoriza', 'submit');
  		}
			if(numFilas!=0 && cuenta==0){
				deshabilitaBoton('guardarAutoriza', 'submit');
  		}
			 funcionComparaEsquema();

  	}


	
	// Consulta las esquemas de solicitud de credito
	function funcionComparaEsquema(){
		var compararEsquema='';
		$('tr[name=renglon]').each(function() {
  			var numero = this.id.substr(7, this.id.length);
  			var esquemaSolicitud= eval("'#esquemaSolicitud" + numero + "'");
  			
			if(compararEsquema!= $(esquemaSolicitud).val() && compararEsquema!=''){
			  	mensajeSis("Las Solicitudes tienen Esquemas de Autorización Diferentes, " +
			  			"se deben Autorizar de manera Individual.");
			  			$('#gridFirmasAutoriza').hide();
			  			$('#gridFirmasOtorgadas').hide();
			  			$('#grupoID').focus();
			  	return false;
			  }
  			  compararEsquema = $(esquemaSolicitud).val();
  		});
	}
	//Consulta cuantas firmas estan seleccionadas para autorizar
	function cuentaSeleccionados(){	
	 	var totales=0;
		$('tr[name=filas]').each(function() {
		var numero= this.id.substr(5,this.id.length);
		var jqIdCredChe = eval("'checkFirma" + numero+ "'");
		if($('#'+jqIdCredChe).attr('checked')==true){
				totales++;		
				
			}	
		});
		return totales;
		
	}

	// Consulta total de filas (frid de firmas para autorizar)
	function consultaFilas(){
		var totales=0;
		$('tr[name=filas]').each(function() {
			totales++;	
		});
		return totales;
	}

	// Consulta total de filas (grid de firmas ya autorizadas)
	function consultaRenglones(){
		var totales=0;
		$('tr[name=renglones]').each(function() {
			totales++;
			
		});
		return totales;
	}

	// Funcion que habilita el check seleccionar solicitud 
	function habilitaBotonSolicitud(){
		var totalSeleccionados=0;
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqestatusCancela = eval("'checkSolicitud" + numero+ "'");
			
			if($('#'+jqestatusCancela).attr('checked')==true){
				totalSeleccionados = totalSeleccionados+1;	
				$('#checkSolicitud'+numero).val($('#solicitudCreditoID'+numero).val());
			}
		});
		
		if(totalSeleccionados > 0){
			habilitaBoton('rechazar', 'submit');
			habilitaBoton('regresarEjec', 'submit');
			habilitaBoton('autorizar', 'submit');
		 	$('#gridComentariosAutoriza').hide();	
			$('#comentarioMesaControl').val('');
		}else {
			deshabilitaBoton('rechazar', 'submit');
			deshabilitaBoton('regresarEjec', 'submit');
			deshabilitaBoton('autorizar', 'submit');
			$('#gridComentariosRechazoRegreso').hide();
		 	$('#gridComentariosAutoriza').hide();		 	
		}
		
	}

	// Funcion que valida si el estatus de la solicitud es INACTIVA
	function validaCheckInactiva(control){
		var check=eval("'#" + control + "'");
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var solicitudes= eval("'#solicitudCre" + numero + "'");
			var jqestatusInactiva = eval("'check" + numero+ "'");

			var solicitud=$(solicitudes).asNumber();
			if($('#'+jqestatusInactiva).attr('checked')==true){
				mensajeSis("La Solicitud: "+solicitud+" debe estar Liberada para su Autorización. ");

				$(check).attr('checked',false);
				
				deshabilitaBoton('rechazar', 'submit');
				deshabilitaBoton('regresarEjec', 'submit');
				deshabilitaBoton('autorizar', 'submit');
				$('#gridComentariosRechazoRegreso').hide();
			 	$('#gridComentariosAutoriza').hide();
			}
		});
		
	}
	 //Funcion para agregar valor 0.00 por default al campo Monto Autorizado
	 function montoAutorizado(control){
	 		$('input[name=montoAutori]').each(function() {
	 	});
	 		$('#montoAutori1').focus();
			$('#montoAutori1').select();
	 }
	 
	/* Funcion para verificar que el monto autorizado no sea
	 mayor al monto solicitado */
	  function validaMonto(control){
		    var montoAutoriza=0;
		    var montoSolicita=0;
		    var monto=eval("'#" + control + "'");

	  		$('input[name=montoAutori]').each(function() {
	  			var numero = this.id.substr(11, this.id.length);
	  			var montoAutori= eval("'#montoAutori" + numero + "'");
	  			var montoSoli=eval("'#montoSolici" + numero + "'");
	  			
	  			var cliente=eval("'#cliente" + numero + "'");
	  			var aporte=eval("'#aporte" + numero + "'");
	  			
	  			var montoAuto=$(montoAutori).asNumber();
	  			var montoSol=$(montoSoli).asNumber();
	  			
	  			montoAutoriza=montoAuto;
	  			montoSolicita=montoSol;

	  			
	  				if(montoAutoriza>montoSolicita){
	  					mensajeSis('El Monto Autorizado No Puede ser Mayor al Monto Solicitado.');
	  					$(monto).val('0.00');
		  				$(monto).focus();
	  				}
	  			  	consultaPorcentajeGarantiaLiquida(montoAutori,cliente,aporte);
				
	  		});
	  }
	 
  /* Funcion para verificar que el cliente
	 no sea 0 */
	  function validaCliente(control){
		  var check=eval("'#" + control + "'");
		    var clienteID=0;
	  		$('input[name=cliente]').each(function() {
	  			var numero = this.id.substr(7, this.id.length);
	  			var cliente=eval("'#cliente" + numero + "'");
	  			var checkSolicitud= eval("'#checkSolicitud" +numero+ "'");
	  			var cli=$(cliente).asNumber();
	  			clienteID=cli;
	  				if(clienteID=='0'&& ($(checkSolicitud).is(':checked')) == true){
			  			mensajeSis("Para continuar con el proceso de Autorización el Prospecto debe " +
	  					"ser Cliente y debe contar con una Cuenta Principal Activa.");
			  			$(check).is('checked',false);
			  			return false;
			  		}
	  		});
	  }
	  

	//Funcion para regresar/rechazar una solicitud de credito grupal
	 function solicitudCredito(){		  		
		 $('input[name=consecutivo]').each(function() {
				var numero=  this.id.substr(11,this.id.length);
				var jqSolicitud = eval("'solicitudCre" + numero+ "'");
				var jqMontoAutoriza = eval("'montoAutori" + numero+ "'");
				var jqAporte = eval("'aporte" + numero+ "'");
				var checkSolicitud= eval("'#checkSolicitud" +numero+ "'");
			
				if(($(checkSolicitud).is(':checked')) == true){
				$('#listaIntegrantes').val($('#listaIntegrantes').val()+"-"+
						$('#'+jqSolicitud).val()+"-"+
						$('#'+jqMontoAutoriza).asNumber()+"-"+
						$('#'+jqAporte).asNumber()+",");
				}
			});
	 	}
		 
		//Funcion para autorizar una solicitud de credito grupal
	 function autorizaSolicitudCredito(){		  		
		 $('input[name=consecutivo]').each(function() {
				var numero=  this.id.substr(11,this.id.length);
				var jqSolicitud = eval("'solicitudCre" + numero+ "'");
				var jqMontoAutoriza = eval("'montoAutori" + numero+ "'");
				var jqAporte = eval("'aporte" + numero+ "'");
				var checkSolicitud= eval("'#checkSolicitud" +numero+ "'");
			
				if(($(checkSolicitud).is(':checked')) == true){
				$('#listaIntegrantes').val($('#listaIntegrantes').val()+"-"+
						$('#'+jqSolicitud).val()+"-"+
						$('#'+jqMontoAutoriza).asNumber()+"-"+
						$('#'+jqAporte).asNumber()+",");
				}
			});
		 guardarDetalle();
	 	}
	 
		//Funcion para guardar las firmar autorizadas
	 function guardarDetalle(){	
		 $('input[name=numero]').each(function() {
				var numero=  this.id.substr(6,this.id.length);
				var jqEsquema= eval("'#esquema" + numero+ "'");
				var jqFirma = eval("'#numeroFirm" + numero+ "'");
				var jqOrgano = eval("'#organoA" + numero+ "'");
				var checkFirma= eval("'#checkFirma" +numero+ "'");
				
				if(($(checkFirma).is(':checked')) == true){
				$('#detalleFirmasAutoriza').val($('#detalleFirmasAutoriza').val()+"-"+
						$(jqEsquema).val()+"-"+
						$(jqFirma).val()+"-"+
						$(jqOrgano).val()+",");
				  }
									
				});
			}
			
	 
	/* Funcion  para limpiar todos los campos del formulario */
	function limpiaFormulario() {
		$('#nombreGrupo').val("");
		$('#descripProducto').val("");
		$('#ciclo').val("");
		$('#fechaAutoriza').val(parametroBean.fechaSucursal);
		deshabilitaBoton('guardarAutoriza', 'submit');
		deshabilitaBoton('guardarRechazo', 'submit');
		deshabilitaBoton('guardarRegresar', 'submit');
		deshabilitaBoton('rechazar', 'submit');
		deshabilitaBoton('regresarEjec', 'submit');
		deshabilitaBoton('autorizar', 'submit');	
		$('#integrantesGrupo').html("");
		$('#integrantesGrupo').hide();
		$('#gridComentariosRechazoRegreso').hide();
	 	$('#gridComentariosAutoriza').hide();	
		$('#comentarioMesaControl').val('');
		$('#comentarioEjecutivo').val('');
		$('#gridFirmasAutoriza').hide();
		$('#gridFirmasOtorgadas').hide();
	}
	
	


	/* FUNCION PARA OBTENER EL PORCENTAJE DE GARANTIA LIQUIDA PARA PRODUCTO DE CREDITO */
	function consultaPorcentajeGarantiaLiquida(controlID,cliente,aporte) {	
		var tipoCon = 5;
		var producCreditoID = $("#producCreditoID").val();
		var productoCreditoBean = {
				'producCreditoID'	:producCreditoID
		};							
		// verifica que el producto de credito en pantalla requiere garantia liquida 
		productosCreditoServicio.consulta(tipoCon,productoCreditoBean,function(respuesta) {
			if (respuesta != null && respuesta.requiereGarantia== 'S') {			
				
				var clienteID = $(cliente).val();						
				var calificaCli	= '';
				var monto = $(controlID).asNumber();

				// verifica que los datos necesario para la consulta NO esten vacios..
				if(parseInt(producCreditoID)>0 && clienteID != '' && parseFloat(monto) > 0){						
						tipoCon = 1;
						var bean = {
								'producCreditoID'	:producCreditoID,
								'clienteID'	:clienteID,
								'calificacion': calificaCli,
								'montoSolici'	:monto
						};	
						// obtiene el porcentaje de garantia liquida
						esquemaGarantiaLiqServicio.consulta(tipoCon,bean,function(respuesta) {
							if (respuesta != null) {	
								var aporteConsulta = ((monto*respuesta.porcentaje)/100 );
								$(aporte).val(aporteConsulta);			
								$(aporte).formatCurrency({	positiveFormat: '%n', negativeFormat: '%n',  roundToDecimalPlace: 2	});
							}
							else{
								$(aporte).val('0.00'); 
								mensajeSis("No existe un Esquema de Garantía Líquida para el Producto de Crédito, Calificación del cliente y Monto indicado");										
								$(controlID).focus();
								$(controlID).val('0.00');
								return false;
							}
						});	
					}
				}
			// si el producto de credito no requiere garantia liquida
			else{
				$(aporte).val('0.00'); 
			}
		});
			
	}

	// Consulta total de filas (grid de firmas para autorizar)
	function consultaRenglon(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;	
		});
		return totales;
	}

	
	/*Funcion de exito de autorizacion de la solicitud grupal */
	function exitoAutorizacionSolicitudGrupal() {
		$('#grupoID').focus();
		deshabilitaBoton('rechazar', 'submit');
		deshabilitaBoton('regresarEjec', 'submit');
		deshabilitaBoton('autorizar', 'submit');
	}
	
	
	/* Funcion de error de autorizacion de la solicitud grupal */
	function errorAutorizacionSolicitudGrupal() {
		$('#detalleFirmasAutoriza').val('');
		$('#listaIntegrantes').val('');
	}
	

	
