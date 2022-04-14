var Par_TipoDocumento = "0";
$(document).ready(function() {
	comboTiposDocumento();
	$('#solicitudCreditoID').focus();
	esTab = true;
	var parametroBean = consultaParametrosSession();  
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
	  		'enviar':1,
	  		}; 
	var catTipoConsultaSolAut = { 
	  		'principal'	:9,
	  		
		};
	var nomAr = "";	
  	
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	deshabilitaBoton('pdf', 'submit');
  	deshabilitaBoton('enviar', 'submit');
  	
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
	
	
	$('#solicitudCreditoID').bind('keyup',function(e) {
		if (this.value.length >= 0) {
			var camposLista = new Array();
			var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				parametrosLista[0] = $('#solicitudCreditoID').val();
			lista('solicitudCreditoID', '1', '14',camposLista, parametrosLista,'listaSolicitudCredito.htm');
		}
	});


	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccion(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','creditoID');
		}
	});
	
	$('#enviar').click(function() {		
		if($('#solicitudCreditoID').val()==null || $('#solicitudCreditoID').val()==''){
			mensajeSis("Especifique Número de Solicitud de Crédito");
			$('#solicitudCreditoID').focus();
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
		consultaTipodocumento('solicitudCreditoID');
	
	});	
	
	$('#solicitudCreditoID').blur(function() {
		consultaSolicitudCredito('solicitudCreditoID'); 
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
			solicitudCreditoID: {
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
			solicitudCreditoID: {
				required: 'Especificar Solicitud de Crédito'
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

	function consultaSolicitudCredito(idControl) {
		var jqSolCredito  = eval("'#" + idControl + "'");
		var solicitud = $(jqSolCredito).val();	 
		var solicitudBeanCon = {
			'solicitudCreditoID'	:solicitud
		};		
		setTimeout("$('#cajaLista').hide();", 200);
		if(solicitud != '' && !isNaN(solicitud) && esTab){	
			solicitud = parseInt(solicitud); 
			solicitudCredServicio.consulta(catTipoConsultaSolAut.principal, solicitudBeanCon,function(solicitud) {
					if(solicitud!=null && solicitud.solicitudCreditoID !=0){
						esTab=true; 			
						$('#clienteID').val(solicitud.clienteID);
						$('#prospectoID').val(solicitud.prospectoID);
						$('#productoCreditoID').val(solicitud.productoCreditoID);
						$('#grupoID').val(solicitud.grupoID);
						consultaCliente('clienteID');
						consultaProspecto('prospectoID');
						if(solicitud.grupoID==0 ){							
							$('#decripcionGrupo').val("");
						}
						else{
							consultaGrupo('grupoID');
						}
						$('#ciclo').val(solicitud.cicloActual);
						validaEstatusCredito(solicitud.estatus);
						consultaProducCredito(solicitud.productoCreditoID);			
						comboTiposDocumentoProducto(solicitud.productoCreditoID);			
						habilitaBoton('pdf', 'submit');		
						habilitaBoton('enviar', 'submit');				
						
					}else{						
						mensajeSis("La Solicitud de Crédito no Existe");	
						$('#solicitudCreditoID').focus();
						$('#solicitudCreditoID').val("");
						$('#clienteID').val("");
						$('#nombreCliente').val("");
						$('#prospectoID').val("");
						$('#nombreProspecto').val("");
						$('#productoCreditoID').val("");
						$('#nombreProducto').val("");
						$('#estatus').val("");
						$('#grupoID').val("");
						$('#decripcionGrupo').val("");
						$('#ciclo').val("");
						deshabilitaBoton('pdf', 'submit');
						deshabilitaBoton('enviar', 'submit');
					
					}
			});
					
		}
											
	}
	function consultaTipodocumento(idControl) {
		var ConsulCantDoc = 1;
		var jqSolicitud  = eval("'#" + idControl + "'");
		var solicitud = $(jqSolicitud).val();	 
		
		var solicitudBeanCon = {
			'solicitudCreditoID'	:solicitud
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(solicitud != '' && !isNaN(solicitud && esTab)){
			solicitudArchivoServicio.consulta(ConsulCantDoc,solicitudBeanCon,function(solicitud) {
				if(solicitud!=null){	
					Par_TipoDocumento= solicitud.numeroDocumentos;
						if(Par_TipoDocumento ==0 || Par_TipoDocumento==null ){
								mensajeSis("No hay documentos digitalizados");
						}else{
							if($('#solicitudCreditoID').val()==null || $('#solicitudCreditoID').val()==''){
								mensajeSis("Especifique Número de Solicitud de Crédito");
								$('#solicitudCreditoID').focus();
							}
							else{
								var solicitudCreditoID = $('#solicitudCreditoID').val();
								var usuario = 	parametroBean.claveUsuario;
								var nombreInstitucion =  parametroBean.nombreInstitucion;
								var fechaEmision = parametroBean.fechaSucursal;
								consultaArchivCredito();
								var pagina='solicitudArchivoPDF.htm?solicitudCreditoID='+solicitudCreditoID
									+'&clienteID='+$('#clienteID').val()
									+'&nombreCliente='+$('#nombreCliente').val()
									+'&estatus='+$('#estatus').val()
									+'&productoCreditoID='+$('#productoCreditoID').val()
									+'&nombreProducto='+$('#nombreProducto').val()
									+'&grupoID='+$('#grupoID').val()
									+'&nombreGrupo='+ $('#decripcionGrupo').val()
									+'&ciclo='+$('#ciclo').val()
									+'&nombreusuario='+usuario+'&nombreInstitucion='+nombreInstitucion
									+'&parFechaEmision='+fechaEmision;
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
					// -----------------consulta el prospecto----------------------------
	function consultaProspecto(idControl) {
		var jqProspecto = eval("'#" + idControl + "'");
		var numProspecto = $(jqProspecto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var prospectoBeanCon = {
			'prospectoID' : numProspecto
		};
		tipoConProspForanea = 2;
		if (numProspecto != '' && !isNaN(numProspecto) && esTab) {
			prospectosServicio.consulta(tipoConProspForanea,prospectoBeanCon,function(prospectos) {
			if (prospectos != null) {
				if (prospectos.cliente != '' && prospectos.cliente != null) {
					$('#clienteID').val(prospectos.cliente);
					$('#nombreProspecto').val("");
					$('#prospectoID').val("");
					habilitaControl('clienteID');
				} else {
					soloLecturaControl('clienteID');
					$('#productoCreditoID').focus();
					$('#clienteID').val('');
					$('#nombreCliente').val('');
					$('#nombreProspecto').val(prospectos.nombreCompleto);
					esTab = true;
				}
			} else {
				if ($('#prospectoID').asNumber() != '0') {
					mensajeSis("No Existe el Prospecto.");
					$('#prospectoID').focus();
					$('#prospectoID').select();
				}
				$('#nombrePromotor').val('');
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
		var estatusLiberado		='L';
		var estatusRechazado	='R';		
		var estatusAutorizado 	="A";
		var estatusCancelado	="V";
		var estatusDesembolsado	="D";
	
		if(var_estatus == estatusInactivo){
			$('#estatus').val('INACTIVO');
		}	
		if(var_estatus == estatusLiberado){
			$('#estatus').val('LIBERADO');
		}
		if(var_estatus == estatusRechazado){
			$('#estatus').val('RECHAZADO');
		}
		if(var_estatus == estatusAutorizado){
			$('#estatus').val('AUTORIZADO');
		}		
		if(var_estatus == estatusCancelado){
			$('#estatus').val('CANCELADO');
		}
		if(var_estatus == estatusDesembolsado){
			$('#estatus').val('DESEMBOLSADO');
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
});

//------------------------ FUNCIONES  ------------------------   


function consultaArchivCredito(){	
	if($('#solicitudCreditoID').val()!= "" && $('#tipoDocumentoID').val()!=""){
		var params = {};
		params['tipoLista'] = 2;
		params['solicitudCreditoID'] =$('#solicitudCreditoID').val();
		params['tipoDocumentoID'] =$('#tipoDocumentoID').val();
		
		$.post("solicitudConsulArchGridVista.htm", params, function(data){		
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
	var url ="solicitudesAdjuntaArchivoVista.htm?Sol="+$('#solicitudCreditoID').val()+"&td="+$('#tipoDocumentoID').val();
	var	leftPosition = (screen.width) ? (screen.width-650)/2 : 0;
	var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

	ventanaArchivosCredito = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
									"left="+leftPosition+
									",top="+topPosition+
									",screenX="+leftPosition+
									",screenY="+topPosition);		
}

//funcion para llenar el combo de 
function comboTiposDocumento() {	
	var LisDocmCred= 1;
	var tiposDoc = {
		'requeridoEn':'S'			
	};
	dwr.util.removeAllOptions('tipoDocumentoID'); 
	dwr.util.addOptions('tipoDocumentoID', {'':'SELECCIONAR'}); 
	tiposDocumentosServicio.listaCombo(LisDocmCred,tiposDoc, function(tiposDocumentos){
		dwr.util.addOptions('tipoDocumentoID', tiposDocumentos, 'tipoDocumentoID', 'descripcion');
	});
}

//funcion para llenar el combo de acuerdo al Producto de Crédito
function comboTiposDocumentoProducto(idControl) {	
	var ProdCred = idControl;
	var LisDocProdCred= 3;
	var ProdCredBeanCon = {
		'productoCreditoID':ProdCred			
	};

	dwr.util.removeAllOptions('tipoDocumentoID'); 

	dwr.util.addOptions('tipoDocumentoID', {'':'SELECCIONAR'}); 

	solicitudArchivoServicio.listaCombo(LisDocProdCred,ProdCredBeanCon, function(prodCred){
	dwr.util.addOptions('tipoDocumentoID', prodCred, 'tipoDocumentoID', 'descripcion');
	
	});


}
	
//funcion para eliminar el documento digitalizado
function  eliminaArchivo(folioDocumentoSolCreditoID,idDesTipoDoc){
	confirmarEliminar(folioDocumentoSolCreditoID,idDesTipoDoc);
}

function  eliminarArchivo(folioDocumentoSolCreditoID){
	var bajaFolioDocumentoSolCredID = 1;
	var solCreditosArchivoBean = {
		'solicitudCreditoID'	:$('#solicitudCreditoID').val(),
		'digSolID'	:folioDocumentoSolCreditoID
	};

	solicitudArchivoServicio.bajaArchivoCredito(bajaFolioDocumentoSolCredID, solCreditosArchivoBean, function(mensajeTransaccion) {		
		if(mensajeTransaccion!=null){
			mensajeSis(mensajeTransaccion.descripcion);
			consultaArchivCredito();

		}else{				
			mensajeSis("Existio un Error al Borrar el Documento");			
		}
	});

}

function confirmarEliminar(folioDocumentoSolCreditoID,idDesTipoDoc) {
	mensajeSisRetro({
		mensajeAlert : '¿Desea eliminar el documento '+ idDesTipoDoc +'?',
		muestraBtnAceptar: true,
		muestraBtnCancela: true,
		muestraBtnCerrar: true,
		txtAceptar : 'Aceptar',
		txtCancelar : 'Cancelar',
		txtCabecera:  'Mensaje:',
		funcionAceptar : function(){
			eliminarArchivo(folioDocumentoSolCreditoID);
		},
		funcionCancelar : function(){},
		funcionCerrar   : function(){}
	});
	
}

function verArchivosCredito(id, idTipoDoc, idarchivo,recurso) {
	
	var varClienteVerArchivo = $('#solicitudCreditoID').val();
	var varTipoDocVerArchivo = idTipoDoc;
	var varArchivoCreVerArchivo = idarchivo;
	var parametros = "?solicitudCreditoID="+varClienteVerArchivo+"&tipoDocumentoID="+
		varTipoDocVerArchivo+"&recurso="+recurso+"&archivoCreditotID="+varArchivoCreVerArchivo;

	var pagina="solicitudVerArchivos.htm"+parametros;
	var idrecurso = eval("'#recursoCreInput"+ id+"'");
	var extensionArchivo=  $(idrecurso).val().substring( $(idrecurso).val().lastIndexOf('.'));
	extensionArchivo = extensionArchivo.toLowerCase();
	if(extensionArchivo==".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg"){
		$('#imgCredito').attr("src",pagina); 
		
		
		$('#imagenCre').html(); 
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