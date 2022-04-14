var EstatusCond = '';
$(document).ready(function() {
	
	$("#creditoID").focus();
	
		esTab = true;
	 	var tab2=false;
	
	
	var catTipoActCreditoAut = {
  		'autoriza':12,
  		'condiciona':31
	};	
	
	var catTipoTranCreditoAut = {
  		'agrega':1,
  		'modifica':2 
	};
	
	var catTipoOperacionCredAut = {
	  		'autorizarCred':1, //autorizar credito individual
	  		'actDocEnt':2 		//documentos entregados
	};
	
	validaMonitorSolicitud();
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
   deshabilitaBoton('autorizar', 'submit');
   deshabilitaBoton('grabar', 'submit');
   deshabilitaBoton('expediente', 'submit');
   deshabilitaBoton('condicionar', 'submit');
//   validaEmpresaID(); //Funcion para consultar si se requiere huella registrada.
	agregaFormatoControles('formaGenerica');
	$(':text').focus(function() {	
	 	esTab = false;
	});

	
	$.validator.setDefaults({
      submitHandler: function(event) { 
      
      grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','InicializarExitoPantalla','ErrorAutorizacion');
     
      }
   });		
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#condicionar').click(function() {			
		$('#estCondicionado').val('S');
		$('#tipoTransaccion').val(1);	
		$('#tipoActualizacion').val(catTipoActCreditoAut.condiciona);
			
	});
	
	$('#autorizar').click(function() {			
		$('#fechaAutoriza').removeAttr('disabled');
		$('#tipoTransaccion').val(catTipoConsultaCreditoAut.actualizaAut);	 
		$('#tipoActualizacion').val(catTipoActCreditoAut.autoriza);
		$('#tipoOperacion').val(catTipoOperacionCredAut.autorizarCred);
			
	});

	$('#grabar').click(function() {		
		$('#tipoTransaccion').val(catTipoConsultaCreditoAut.actualizaAut);	 
		$('#tipoActualizacion').val(1);
		$('#tipoOperacion').val(catTipoOperacionCredAut.actDocEnt);
		guardarGriDocumentos();
						
	});

	$('#expediente').click(function() {	
		consultaTipodocumento('creditoID');
	});
	
	
	$('#creditoID').change(function() {	
		if(isNaN($('#creditoID').val()) ){
			$('#creditoID').val("");
			inicializaForma('formaGenerica','creditoID');
			tab2 = false;
		}else{
			tab2=true;
			esTab = true;	
			consultaCredito(this.id); 
		}
	});
	
	$('#creditoID').blur(function() {		
		if(isNaN($('#creditoID').val()) ){
			$('#creditoID').val("");
			inicializaForma('formaGenerica','creditoID');
			tab2 = false;
		 }else{ 
			if(tab2 == false){
				esTab = true;
				consultaCredito(this.id); 
		 	}
		}
	});
	
	$('#creditoID').bind('keyup',function(e){
		lista('creditoID', '2', 47, 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});
	

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clienteID: 'required',
			usuarioAutoriza: 'required',
			fechaAutoriza: 'required'				
		},
		
		messages: {
			clienteID: 'Especifique numero de cliente',
			usuarioAutoriza: 'Especifique el Usuario',
			fechaAutoriza:'Especifique Fecha de registro'
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
function consultaSaldoCta(idControl) {
		var jqnumCta  = eval("'#" + idControl + "'");
		var numCta = $(jqnumCta).val();	 
        var conCta = 5;   
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteID').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);
        
        if(numCta != '' && !isNaN(numCta)){
                cuentasAhoServicio.consultaCuentasAho(conCta,CuentaAhoBeanCon,function(cuenta) {
                	if(cuenta!=null){                 	               		
						$('#montoCredito').val(cuenta.saldoDispon);            
                	}else{
                		mensajeSis("No Existe la Cuenta de Ahorro");
                	}
                });                                                                                                                        
        }
   }	
	
function consultaTipodocumento(idControl) {
	var ConsulCantDoc = 1;
	var jqCredito  = eval("'#" + idControl + "'");
	var credito = $(jqCredito).val();	 
	
	var creditoBeanCon = {
		'creditoID'	:credito
	};
	setTimeout("$('#cajaLista').hide();", 200);		
	
	if(credito != '' && !isNaN(credito )){
		creditoArchivoServicio.consulta(ConsulCantDoc,creditoBeanCon,function(credito) {
			if(credito!=null){	
				Par_TipoDocumento= credito.numeroDocumentos;
					if(Par_TipoDocumento ==0 || Par_TipoDocumento==null ){
							mensajeSis("No hay documentos digitalizados");
						}else{
							if($('#creditoID').val()==null || $('#creditoID').val()==''){
								mensajeSis("No existe un número de crédito para el expediente");								
								}
						
								else{
									var creditoID = $('#creditoID').val();								
									var usuario = 	parametroBean.nombreUsuario;
									var nombreInstitucion =  parametroBean.nombreInstitucion;
									var fechaEmision = parametroBean.fechaSucursal;
									
									var pagina='creditoArchivoPDF.htm?creditoID='+creditoID+'&clienteID='+$('#clienteID').val()+
									'&nombreCliente='+$('#nombreCliente').val()+'&estatus='+$('#estatus').val()+'&grupoID=0'+
									'&nombreGrupo='+
									'&productoCreditoID='+$('#producCreditoID').val()+'&nombreProducto='+$('#nombreProd').val()+
									'&ciclo=0'+'&cuentaID='+$('#cuentaID').val()+'&descripcionCta='+$('#desCuenta').val()
									+'&nombreusuario='+usuario+'&nombreInstitucion='+nombreInstitucion+'&parFechaEmision='+fechaEmision;
									window.open(pagina,'_blank');
									}
								}
							}
				else{
						mensajeSis("No hay documentos digitalizados");
						
					
					}    	 						
			});
		} 
	}
	
// se construye la cadena de datos del grid a guargar
	function guardarGriDocumentos(){		
		var mandar = verificarVacios();

		if(mandar!=1){   		  		
			var numDocEnt =consultaFilas(); //$('input[name=consecutivo]').length;
	
			$('#datosGridDocEnt').val("");
			for(var i = 1; i <= numDocEnt; i++){				
				if(i == 1){
					$('#datosGridDocEnt').val($('#datosGridDocEnt').val() +
					document.getElementById("creditoID"+i+"").value + ']' +
					document.getElementById("clasificaTipDocID"+i+"").value + ']' +
					document.getElementById("docAceptado"+i+"").value + ']' +
					document.getElementById("tipoDocumentoID"+i+"").value + ']' +
					document.getElementById("comentarios"+i+"").value);
				}else{
					$('#datosGridDocEnt').val($('#datosGridDocEnt').val() + '[' +
					document.getElementById("creditoID"+i+"").value + ']' +
					document.getElementById("clasificaTipDocID"+i+"").value + ']' +	
					document.getElementById("docAceptado"+i+"").value + ']' +
					document.getElementById("tipoDocumentoID"+i+"").value + ']' +
					document.getElementById("comentarios"+i+"").value);
				}	
			}
						 
		}
		else{
			mensajeSis("Faltan Datos");
			event.preventDefault();
		}
	}	
	
//verificamos que no existan campos vacios en el grid de documentos
	function verificarVacios(){	
		quitaFormatoControles('documentosEnt');
		var numDoc = consultaFilas();
		 
		$('#datosGridDocEnt').val("");
		for(var i = 1; i <= numDoc; i++){
			
			var idDocAcep = document.getElementById("docAceptado"+i+"").value;
			if (idDocAcep ==""){ 				
				document.getElementById("docAceptado"+i+"").focus();
				$(idDocAcep).addClass("error");
				return 1; 
			} 					
			var idcde = document.getElementById("comentarios"+i+"").value;
			if (idcde ==""){ 				
				if(idDocAcep =="" || idDocAcep =="S"){
					document.getElementById("comentarios"+i+"").focus();
	 				$(idcde).addClass("error");
	 					return 1; 
				}
				
				if(idDocAcep =="N"){
					document.getElementById("comentarios"+i+"").value = "X";
				}

			}
				
		}
	}
	
	
	//Consulta para ver si se requiere que el cliente tenga registrada su huella Digital
//	function validaEmpresaID() {
//		var numEmpresaID = 1;
//		var tipoCon = 1;
//		var ParametrosSisBean = {
//				'empresaID'	:numEmpresaID
//		};
//		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
//			if (parametrosSisBean != null) {
//				if(parametrosSisBean.reqhuellaProductos !=null){
//						huellaProductos=parametrosSisBean.reqhuellaProductos;
//				}else{
//					huellaProductos="N";
//				}
//			}
//		});
//	}
	
});
//Definicion de Constantes y Enums  
var catTipoConsultaCreditoAut = {
		'principal':1,
		'foranea':2,
		'actualizaAut':3 ,
		'condicionaCred': 25,
		'creCondiciona': 27
};	

function validaMonitorSolicitud() {
	var catTipoConsultaCreditoAut = {
		'principal':1,
		'foranea':2,
		'actualizaAut':3 ,
		'condicionaCred': 25,
		'creCondiciona': 27
	};	
	
	// seccion para validar si la pantalla fue llamada desde la pantalla de Monitor de Solicitud 
	if ($('#monitorSolicitud').val() != undefined) {
		var credito = $('#numSolicitud').val();
		var creditoID = 'creditoID';
		$('#creditoID').val(credito);
		consultaCredito(creditoID);
	}
}



function consultaCredito(idControl) {
	
	var jqCredito  = eval("'#" + idControl + "'");
	var credito = $(jqCredito).val();
	var tipoConDes = 27;	 
	
	var creditoBeanCon = {
		'creditoID'	:credito
	};
	var var_estatus;
	setTimeout("$('#cajaLista').hide();", 200);
	
	if(credito != '' && !isNaN(credito) ){
		credito = parseInt(credito); 
		creditosServicio.consulta(tipoConDes, creditoBeanCon,function(creditos) {
			
				if(creditos!=null){
					esTab=true;   
					var creditosID=creditos.creditoID;					
					$('#creditoID').val(creditos.creditoID);							
					$('#lineaCreditoID').val(creditos.lineaCreditoID); 						
					$('#clienteID').val(creditos.clienteID);
					consultaCliente('clienteID');
					$('#cuentaID').val(creditos.cuentaID);
					consultaCtaAho('cuentaID');
					consultaHuellaCliente();
					$('#montoCredito').val(creditos.montoCredito);
					$('#fechaInicio').val(creditos.fechaInicio);
					$('#fechaVencimien').val(creditos.fechaVencimien);
					$('#producCreditoID').val(creditos.producCreditoID);
					$('#solicitudCreditoID').val(creditos.solicitudCreditoID);
					
					
					consultaUsuario('usuarioAutoriza');
					
					var_estatus=(creditos.estatus);
					EstatusCond = creditos.estCondicionado;
					validaEst(EstatusCond);
					validaEstatus(var_estatus);												
					consultaProducCredito('producCreditoID', creditos.grupoID);						
					consultaGridDocEnt(creditosID);										
					if(creditos.comentarioMesaControl !=null){						
						$('#divComentarios').show();
						$('#comentarioMesaControl').val(creditos.comentarioMesaControl);
						
					}else{
						$('#divComentarios').show();
						$('#comentarioMesaControl').hide();
						$('#Comentariolbl').hide();
						$('#separador').hide();
						$('#comentarioCond').show();
						
						}
						
				}else{ 
					mensajeSis("El Credito no Existe");
					$(jqCredito).focus();
					deshabilitaBoton('autorizar', 'submit');
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('expediente', 'submit');
					$(jqCredito).select();	
					$('#documentosEnt').html("");
					$('#documentosEnt').hide();
					$('#fieldsetDocEnt').hide();
					$('#divComentarios').hide();
					inicializaForma('formaGenerica');						
				}
		});										
													
	}
}

function consultaCliente(idControl) {
	var jqCliente  = eval("'#" + idControl + "'");
	var numCliente = $(jqCliente).val();	
	var conCliente =1;
	var rfc = ' ';
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numCliente != '' && !isNaN(numCliente)){
		clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
					if(cliente!=null){							
						$('#nombreCliente').val(cliente.nombreCompleto);	
						estatusCliente=cliente.estatus;	
					}else{
						mensajeSis("No Existe el Cliente");
						$(jqCliente).focus();
					}    						
			});
		}
}
// función para consultar si el cliente ya tiene huella digital registrada
//
	function consultaHuellaCliente(){
		var numCliente=$('#clienteID').val();
		if(numCliente != '' && !isNaN(numCliente )){
			var clienteIDBean = { 
				'personaID':$('#clienteID').val()								
				};   			   	
			huellaDigitalServicio.consulta(1,clienteIDBean,function(cliente) {
				if (cliente==null){
					var huella=parametroBean.funcionHuella;
					if(huella =="S" && huellaProductos=="S"){
					mensajeSis("El Cliente no tiene Huella Registrada.\nFavor de Verificar.");
					$('#creditoID').focus();	
					valida="S";
					}else{
						valida="N";
					}
				}else{
					valida="N";
				}
			});
		}
	}





function consultaCtaAho(idControl) {
	var jqCtaAho  = eval("'#" + idControl + "'");
	var numCtaAho = $(jqCtaAho).val();	
	var CuentaAhoBeanCon = {
		'cuentaAhoID'	:numCtaAho
	};
	var conCtaAho =4;
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numCtaAho != '' && !isNaN(numCtaAho) && esTab){
		cuentasAhoServicio.consultaCuentasAho(conCtaAho,CuentaAhoBeanCon,function(ctaAho){
					if(ctaAho!=null){						
						$('#desCuenta').val(ctaAho.tipoCuentaID);	
						consultaTipoCta('desCuenta');			
					}else{
						mensajeSis("No Existe la Cuenta de Ahorro");
						$(jqCtaAho).focus();
					}    						
			});
	}	
}

function consultaTipoCta(idControl) { 
	var jqTipoCta = eval("'#" + idControl + "'");
	var numTipoCta = $(jqTipoCta).val();	
	var conTipoCta=2;
	var TipoCuentaBeanCon = { 
			'tipoCuentaID':numTipoCta
	};
	
	setTimeout("$('#cajaLista').hide();", 200); 
	if(numTipoCta != '' && !isNaN(numTipoCta)){
		tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,function(tipoCuenta) {
					if(tipoCuenta!=null){		
						$('#desCuenta').val(tipoCuenta.descripcion);
					}else{
						$(jqTipoCta).focus();
					}    						 
			});
		}
}  

function consultaUsuario(idControl) {
	var jqUsuario = eval("'#" + idControl + "'");
	var numUsuario = $(jqUsuario).val();	
	var conUsuario=2;  
		var UsuarioBeanCon = {
			'usuarioID'	:numUsuario
		};
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numUsuario != '' && !isNaN(numUsuario) && esTab){ 
		usuarioServicio.consulta(conUsuario,UsuarioBeanCon,function(usuario) {
					if(usuario!= null){
						// $('#usuarioAutoriza').val(usuario.usuarioAutoriza);					
						$('#nombreUsuario').val(usuario.nombreCompleto);								
					}else{
						mensajeSis("No Existe el Usuario");
						$(jqUsuario).focus();
					}    						
			});
		}
	}

function validaEstatus(var_estatus) {
	var estatusVigente 		="V";
	var estatusPagado 		="P";
	var estatusCancelado 	="C";
	var estatusInactivo 	="I";
	var estatusAutorizado	="A";
	var estatusVencido 		="B";
	var estatusCastigado 	="K";


	if(var_estatus == estatusVigente){
		 deshabilitaBoton('autorizar', 'submit');
		 deshabilitaBoton('grabar', 'submit');
		 deshabilitaBoton('condicionar', 'submit');
		 $('#estatus').val('VIGENTE');
	}
	if(var_estatus == estatusPagado){
		 deshabilitaBoton('autorizar', 'submit');
		 deshabilitaBoton('grabar', 'submit');
		 deshabilitaBoton('condicionar', 'submit');
		 $('#estatus').val('PAGADO');
	}
	if(var_estatus == estatusCancelado){
		 deshabilitaBoton('autorizar', 'submit');
		 deshabilitaBoton('grabar', 'submit');
		 deshabilitaBoton('condicionar', 'submit');
		 $('#estatus').val('CANCELADO');
	}
	if(var_estatus == estatusInactivo){
		 habilitaBoton('autorizar', 'submit');
		 $('#estatus').val('INACTIVO');
		 $('#fechaAutoriza').val(parametroBean.fechaSucursal); 
		 $('#usuarioAutoriza').val(parametroBean.numeroUsuario);   
		 $('#nombreUsuario').val(parametroBean.nombreUsuario);       
	}	
	if(var_estatus == estatusAutorizado){
		 deshabilitaBoton('autorizar', 'submit');
		 deshabilitaBoton('grabar', 'submit');
		 deshabilitaBoton('condicionar', 'submit');
		 $('#estatus').val('AUTORIZADO');
	}	
	if(var_estatus == estatusVencido ){
		 deshabilitaBoton('autorizar', 'submit');
		 deshabilitaBoton('grabar', 'submit');
		 deshabilitaBoton('condicionar', 'submit');
		 $('#estatus').val('VENCIDO');
	}	
	if(var_estatus == estatusCastigado){
		 deshabilitaBoton('autorizar', 'submit');
		 deshabilitaBoton('grabar', 'submit');
		 deshabilitaBoton('condicionar', 'submit');
		 $('#estatus').val('CASTIGADO');
	}	
	
}

function validaEst(EstatusCond) {
	var CondicionadoSI 		="S";
	var CondicionadoNO 		="N";
	

	if(EstatusCond == CondicionadoSI){
		 deshabilitaBoton('autorizar', 'submit');
		 deshabilitaBoton('grabar', 'submit');
		 deshabilitaBoton('condicionar', 'submit');
	}
	if(EstatusCond == CondicionadoNO){
		 habilitaBoton('autorizar', 'submit');
		 habilitaBoton('condicionar', 'submit');
	}	
	
}

function consultaProducCredito(idControl, grupoID) { 
	var jqProdCred  = eval("'#" + idControl + "'");
	var ProdCred = $(jqProdCred).val();			
	var ProdCredBeanCon = {
			'producCreditoID':ProdCred 
	}; 
	setTimeout("$('#cajaLista').hide();", 200);	 

		if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
			productosCreditoServicio.consulta(catTipoConsultaCreditoAut.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					esTab=true;	
					
					if(prodCred.esGrupal == 'S' && grupoID > 0){ 
						mensajeSis("Producto de Crédito Reservado para Créditos Grupales.");
						deshabilitaBoton('autorizar', 'submit');
						$('#creditoID').focus();
						$('#nombreCliente').val("");
						$('#desCuenta').val("");
						
					 deshabilitaBoton('autorizar', 'submit');
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('expediente', 'submit');
					deshabilitaBoton('condicionar', 'submit');
					
						
					inicializaForma('formaGenerica');
					var creditoID=0;
					consultaGridDocEnt(creditoID);
						 
						tab2=false;
					
					}else{
							$('#nombreProd').val(prodCred.descripcion);
						}
						
				}else{							
					mensajeSis("No Existe el Producto de Credito");					
					$('#producCreditoID').focus();
					$('#producCreditoID').select();																					
				}
		});
		}				 					
}

//grid de documentos entregados

function consultaGridDocEnt(creditoID){	
	
	$('#datosGridDocEnt').val('');
	var params = {};
	params['tipoLista'] = 1;	
	params['creditoID'] = creditoID;
	
	
	$.post("creditoDocEntGridVista.htm", params, function(data){
		if(data.length >0) {	
		
			$('#documentosEnt').html(data);
			$('#documentosEnt').show();	
			$('#fieldsetDocEnt').show();
		
		
			var ver = habilitaBotonAutorizar(); 			
			if(ver==0){
				habilitaBoton('autorizar', 'submit');	
				habilitaBoton('condicionar', 'submit');				
			}else{
				deshabilitaBoton('autorizar', 'submit');
				deshabilitaBoton('condicionar', 'submit');	
			}	
		
			var numFilas=consultaFilas();		
			if(numFilas == 0 ){
				$('#documentosEnt').html("");
				$('#documentosEnt').hide();	
				$('#fieldsetDocEnt').hide();
				$('#divComentarios').hide();
				
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('expediente', 'submit');
			}else{
				habilitaBoton('grabar', 'submit');
				habilitaBoton('expediente', 'submit');				
			}
			
			var estadoCredito= $('#estatus').val();
			if(estadoCredito!='INACTIVO'){
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('autorizar', 'submit');
				deshabilitaBoton('condicionar', 'submit');
				
				var numFilas=consultaFilas();				
				for(var i = 1; i <= numFilas; i++){
					var jqIdComentario = eval("'comentarios" + i+ "'");
					deshabilitaControl(jqIdComentario);														
				}								
			}
			$("#numeroDocumento").val(consultaFilas());	
			hasChecked();
			if(estatusCliente=='I'){
					mensajeSis("El Cliente se encuentra Inactivo");
					$('#creditoID').focus();
					$('#documentosEnt').html("");
					$('#documentosEnt').hide();	
					$('#fieldsetDocEnt').hide();
					$('#divComentarios').hide();
					
			}
			
//			if (valida=="S"){
//				mensajeSis("El Cliente no tiene Huella Registrada.\nFavor de Verificar.");
//				$('#creditoID').focus();
//				$('#documentosEnt').html("");
//				$('#documentosEnt').hide();	
//				$('#fieldsetDocEnt').hide();
//				$('#divComentarios').hide();
//			}
			$('#expediente').focus();								
		}else{				
			$('#documentosEnt').html("");
			$('#documentosEnt').hide();
			$('#fieldsetDocEnt').hide();			
		}
	});
}



  function InicializarExitoPantalla() {	
	if( $('#tipoOperacion').val() == 1){
		deshabilitaBoton('autorizar', 'submit');
		deshabilitaBoton('grabar', 'submit');

	}else{	
		tab2=true;
		esTab = true;		
		consultaCredito('creditoID');			
	}		
  }
  
  function ErrorAutorizacion() {  
	$('#fechaAutoriza').attr('disabled','disabled');
		deshabilitaBoton('autorizar', 'submit');
		 tab2 = false;  
  }
  
  // Consulta el número de filas del grid de documentos entregados
  function consultaFilas(){
		var totales=0;
		$('tr[name=renglons]').each(function() {
			totales++;
			
		});
		return totales;
	}
  // verifica cuantos documentos no han sido aceptados del crédito
  function habilitaBotonAutorizar(){	
		var contador=0;
		$('input[name=docAceptado]').each(function() {	
			var jqIdDocAceptado =  eval("'#"+ this.id +"'");  
			var noAceptado='N';
			 var valor = $(jqIdDocAceptado).val();
			if(valor==noAceptado){
				contador++;
			}
		});		
		return contador; 
	}
  //Si se da clic en el campo docAceptado del grid de Documentos Entregados cambia el valor a S
  function realiza(control){	
	  var  si='S';
	  var no='N';
		if($('#'+control).attr('checked')==true){
		document.getElementById(control).value = si;		
		}else{
			document.getElementById(control).value = no;
	 }
			
  }
  
  //al cargar el grid de documentos verifica cuales tienen valo 'S' y los selecciona
  function hasChecked(){	
		$('tr[name=renglons]').each(function() {
			var numero= this.id.substr(8,this.id.length);
			var jqIdChecked = eval("'documentoAcep" + numero+ "'");	
						
			var valorChecked= document.getElementById(jqIdChecked).value;	
			var documentoAceptado='S';
			if(valorChecked==documentoAceptado){
				$('#docAceptado'+numero).attr('checked','true');
					
			}else{
				$('#docAceptado'+numero).attr('checked',false);
			}	
		});
		
	}
