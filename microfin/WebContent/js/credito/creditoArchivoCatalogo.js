var Par_TipoDocumento = "0";
$(document).ready(function() {
	comboTiposDocumento();
	
	esTab = true;
	var parametroBean = consultaParametrosSession();  
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
	  		'enviar':1,
	  		}; 
	var catTipoConsultaCreditoAut = { 
	  		'principal'	:11,
	  		
		};
	var nomAr = "";	
  	
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	deshabilitaBoton('pdf', 'submit');
  	$('#creditoID').focus();
  	
  	$(':text').focus(function() {	
	 	esTab = false;
	});
	
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID');
	  	}
	});	

	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	
	
	//Muestra la lista Lista	
	$('#creditoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "creditoID"; 
		parametrosLista[0] = $('#creditoID').val();
		lista('creditoID', '1', '1', camposLista, parametrosLista, 'ListaCredito.htm');
	});
	
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccion(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','creditoID');
		}
	});
	
	$('#enviar').click(function() {		
		if($('#creditoID').val()==null || $('#creditoID').val()==''){
			mensajeSis("Especifique Número de Crédito");
			$('#creditoID').focus();
		}else{
			if ($('#tipoDocumentoID').val()==null || $('#tipoDocumentoID').val()==''){
				mensajeSis("Seleccione un tipo de Documento");
				$('#tipoDocumentoID').focus();
			}else{
				subirArchivos();
			}
		}
	});

	$('#pdf').click(function() {	
		consultaTipodocumento('creditoID');
	
	});
	
	
	$('#creditoID').blur(function() {
		consultaCredito('creditoID'); 
		consultaArchivCredito();
		$('#imagenCre').hide();

	});
	
	$('#file').blur(function(){
		nomAr= $('#file').val();
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
		$('#observacion').focus();
	});
	
	$('#tipoDocumentoID').blur(function() {
		esTab=true;
		consultaArchivCredito();
		$('#imagenCre').hide();
	

	});	

	$('#comentario').focus(function() {	
			nomAr= $('#file').val();
			$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
	});
	
	var parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	$('#recurso').val(parametroBean.rutaArchivos);
	//------------ Validaciones de la Forma -------------------------------------
	
	$.validator.addMethod('filesize', function(value, element, param) {
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({
		rules: {
			creditoID: {
				required: true
			},
			tipoDocumento: {
				required: true
			},
			observacion: {
				required: true
			},
			file: { required: true,filesize: 3145728  }
	
		},
		messages: {
			creditoID: {
				required: 'Especificar Crédito'
			},
			tipoDocumento: {
				required: 'Especificar Tipo de Documento'
			},
			observacion: {
				required: 'Especificar Comentario'
			}	,
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamanio maximo de 3MB' 
			}	 
		}			
	});
	
	
//------------ Validaciones de Controles -------------------------------------

	function consultaCredito(idControl) {
		var jqCredito  = eval("'#" + idControl + "'");
		var credito = $(jqCredito).val();	 
		
		var creditoBeanCon = {
			'creditoID'	:credito
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(credito != '' && !isNaN(credito) && esTab){
			credito = parseInt(credito); 
			creditosServicio.consulta(catTipoConsultaCreditoAut.principal, creditoBeanCon,function(creditos) {
					if(creditos!=null){
						esTab=true; 			
						$('#clienteID').val(creditos.clienteID);
						$('#productoCreditoID').val(creditos.producCreditoID);
						$('#grupoID').val(creditos.grupoID);
						$('#cuentaID').val(creditos.cuentaID);
						consultaCliente('clienteID');
						consultaGrupo('grupoID');
						$('#ciclo').val(credito.cicloGrupo);
						validaEstatusCredito(creditos.estatus);
						consultaProducCredito(creditos.producCreditoID);
						consultaCta(creditos.cuentaID);
						
						habilitaBoton('pdf', 'submit');
						
						
						
					}else{						
						mensajeSis("El Cŕedito No existe");	
						$('#creditoID').val("");
						$('#clienteID').val("");
						$('#productoCreditoID').val("");
						$('#nombreCliente').val("");
						$('#estatus').val("");
						$('#decripcioncre').val("");
						$('#cuentaID').val("");
						$('#decripcionGrupo').val("");
						$('#decripcioncta').val("");
						$('#ciclo').val("");
						deshabilitaBoton('pdf', 'submit');
						$('#creditoID').focus();
					
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
		
		if(credito != '' && !isNaN(credito && esTab)){
			creditoArchivoServicio.consulta(ConsulCantDoc,creditoBeanCon,function(credito) {
				if(credito!=null){	
					Par_TipoDocumento= credito.numeroDocumentos;
						if(Par_TipoDocumento ==0 || Par_TipoDocumento==null ){
								mensajeSis("No hay documentos digitalizados");
							}else{
								if($('#creditoID').val()==null || $('#creditoID').val()==''){
									mensajeSis("Especifique Número de Crédito");
									$('#creditoID').focus();
									}
							
									else{
										var creditoID = $('#creditoID').val();
										var usuario = 	parametroBean.claveUsuario;
										var nombreInstitucion =  parametroBean.nombreInstitucion;
										var fechaEmision = parametroBean.fechaSucursal;
										consultaArchivCredito();
										var pagina='creditoArchivoPDF.htm?creditoID='+creditoID+'&clienteID='+$('#clienteID').val()+
										'&cuentaID='+$('#cuentaID').val()+'&descripcionCta='+$('#decripcioncta').val()
										+'&usuario='+usuario+'&nombreInstitucion='+nombreInstitucion+'&fechaActual='+fechaEmision;
										window.open(pagina, '_blank'); 										
										}
									}
								}
					else{
							mensajeSis("No hay documentos digitalizados");
							
						
						}    	 						
				});
			} 
		}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;
		
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
						if(cliente!=null){					
							$('#nombreCliente').val(cliente.nombreCompleto);
							
							 
							
						}else{
							$('#nombreCliente').val("");
						
						}    	 						
				});
			} 
		}

	
	function consultaProducCredito(idControl) {  
		var ProdCred = idControl;
		var conTipoCta=2;
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		if(ProdCred != '' && !isNaN(ProdCred) ){		
			productosCreditoServicio.consulta(conTipoCta,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					$('#nombreProducto').val(prodCred.descripcion);
				}else{							
					$('#nombreProducto').val("");
				}
			});
		}			 					
	}
	
	function validaEstatusCredito(var_estatus) {
		var estatusInactivo 	="I";		
		var estatusAutorizado 	="A";
		var estatusVigente		="V";
		var estatusPagado		="P";
		var estatusCancelada 	="C";		
		var estatusVencido		="B";
		var estatusCastigado 	="K";		
		if(var_estatus == estatusInactivo){
			$('#estatus').val('INACTIVO');
		}	
		if(var_estatus == estatusAutorizado){
			$('#estatus').val('AUTORIZADO');
		}
		if(var_estatus == estatusVigente){
			$('#estatus').val('VIGENTE');
		}
		if(var_estatus == estatusPagado){
			$('#estatus').val('PAGADO');
			deshabilitaBoton('graba', 'submit');
		}
		if(var_estatus == estatusCancelada){
			$('#estatus').val('CANCELADO');
		}
		if(var_estatus == estatusVencido){
			$('#estatus').val('VENCIDO');
		}
		if(var_estatus == estatusCastigado){
			$('#estatus').val('CASTIGADO');
		}		
	}
	

	function consultaGrupo(idControl) {
		var jqGrupo = eval("'#" + idControl + "'");
		var numGrupo = $(jqGrupo).val();	
		var tipConPrincipal = 1;
		var grupoBeanCon = { 
  				'grupoID':numGrupo		  				
			};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numGrupo != '' && !isNaN(numGrupo) && esTab){
			gruposCreditoServicio.consulta(tipConPrincipal,grupoBeanCon,function(grupos) {
				if(grupos!=null){		
							esTab=true;
							$('#decripcionGrupo').val(grupos.nombreGrupo);
						}else{
							$('#decripcionGrupo').val("");
						}
				});
			}
		}	
	

	
	
	function consultaCta(idControl) {
		var numCta = idControl;
        var conCta = 3;  
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteID').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if(numCta != '' && !isNaN(numCta)){
        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
        		if(cuenta!=null){         			
        			consultaTipoCta(cuenta.tipoCuentaID);
                   
        		}else{        			
        			$('#decripcioncta').val("");
        		}
        	});                                                                                                                        
        }
	}
	
	function consultaTipoCta(idControl) {
		var numTipoCta = idControl;	
		var conTipoCta=2;
		var TipoCuentaBeanCon = {
  			'tipoCuentaID':numTipoCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoCta != '' && !isNaN(numTipoCta)){
			tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,function(tipoCuenta) {
				if(tipoCuenta!=null){
					$('#decripcioncta').val(tipoCuenta.descripcion);							
				}else{
					$('#decripcioncta').val("");	
				}    						
			});
		}
	}
});

	

//------------------------ FUNCIONES  ------------------------   


function consultaArchivCredito(){
	if($('#creditoID').val()!= "" && $('#tipoDocumentoID').val()!=""){
		var params = {};
		params['tipoLista'] = 2;
		params['creditoID'] =$('#creditoID').val();
		params['tipoDocumentoID'] =$('#tipoDocumentoID').val();
		
		$.post("creditoConsulArchGridVista.htm", params, function(data){		
			if(data.length >0) {
				$('#gridArchivosCredito').html(data);
				$('#gridArchivosCredito').show();
				
			}else{
				$('#gridArchivosCredito').html("");
				$('#gridArchivosCredito').show();
			}
		});
	}	
}


var parametrosBean = consultaParametrosSession();
var rutaArchivos = parametrosBean.rutaArchivos;
var ventanaArchivosCredito ="";
function subirArchivos() {
	var url ="creditosAdjuntaArchivoVista.htm?Cre="+$('#creditoID').val()+"&td="+$('#tipoDocumentoID').val();
	var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
	var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

	ventanaArchivosCredito = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
									"left="+leftPosition+
									",top="+topPosition+
									",screenX="+leftPosition+
									",screenY="+topPosition);	
	
	//$.blockUI({message: "Favor de terminar el proceso"});

}


//funcion para llenar el combo de procesos de escalamiento
function comboTiposDocumento() {	
	var LisDocmCred= 2;
	var tiposDoc = {
		'requeridoEn':'K'			
	};
	dwr.util.removeAllOptions('tipoDocumentoID'); 
	dwr.util.addOptions('tipoDocumentoID', {'':'SELECCIONAR'}); 
	tiposDocumentosServicio.listaCombo(LisDocmCred,tiposDoc, function(tiposDocumentos){
		dwr.util.addOptions('tipoDocumentoID', tiposDocumentos, 'tipoDocumentoID', 'descripcion');
	});
}

//funcion para eliminar el documento digitalizado
function  eliminaArchivo(folioDocumentoCreditoID,idDesTipoDoc){
	confirmarEliminar(folioDocumentoCreditoID,idDesTipoDoc) ;
}

function  eliminarArchivo(folioDocumentoCreditoID){
	var bajaFolioDocumentoCreditoID = 1;
	var creditosArchivoBean = {
		'creditoID'	:$('#creditoID').val(),
		'digCreaID'	:folioDocumentoCreditoID
	};
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
	$('#contenedorForma').block({
			message: $('#mensaje'),
		 	css: {border:		'none',
		 			background:	'none'}
	});
	
	creditoArchivoServicio.bajaArchivoCredito(bajaFolioDocumentoCreditoID, creditosArchivoBean, function(mensajeTransaccion) {
		
		if(mensajeTransaccion!=null){
			$('#contenedorForma').unblock(); 
			mensajeSis(mensajeTransaccion.descripcion);
			consultaArchivCredito();

		}else{				
			mensajeSis("Existio un Error al Borrar el Documento");			
		}
	});
	
}

function confirmarEliminar(folioDocumentoCreditoID,idDesTipoDoc) {
	mensajeSisRetro({
		mensajeAlert : '¿Desea eliminar el documento '+ idDesTipoDoc +'?',
		muestraBtnAceptar: true,
		muestraBtnCancela: true,
		muestraBtnCerrar: true,
		txtAceptar : 'Aceptar',
		txtCancelar : 'Cancelar',
		txtCabecera:  'Mensaje:',
		funcionAceptar : function(){
			eliminarArchivo(folioDocumentoCreditoID);
		},
		funcionCancelar : function(){},
		funcionCerrar   : function(){}
	});
	
}

function verArchivosCredito(id, idTipoDoc, idarchivo,recurso) {
	
	var varClienteVerArchivo = $('#creditoID').val();
	var varTipoDocVerArchivo = idTipoDoc;
	var varArchivoCreVerArchivo = idarchivo;
	var parametros = "?creditoID="+varClienteVerArchivo+"&tipoDocumentoID="+
		varTipoDocVerArchivo+"&recurso="+recurso+"&archivoCreditotID="+varArchivoCreVerArchivo;

	var pagina="creditoVerArchivos.htm"+parametros;
	var idrecurso = eval("'#recursoCreInput"+ id+"'");
	var extensionArchivo=  $(idrecurso).val().substring( $(idrecurso).val().lastIndexOf('.'));
	extensionArchivo = extensionArchivo.toLowerCase();
	if(extensionArchivo==".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg"){
		$('#imgCredito').attr("src",pagina); 
		
		
		$('#imagenCre').html(); 
		 // $.blockUI({message: $('#imagenCte')}); 
		  $.blockUI({message: $('#imagenCre'),
			   css: { 
           top:  ($(window).height() - 400) /2 + 'px', 
           left: ($(window).width() - 1000) /2 + 'px', 
           width: '70%' 
       } });  
		  $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);

	}else{
		window.open(pagina, '_blank'); 
		$('#imagenCre').hide();
	}	
	
}