$(document).ready(function() {
	esTab = false;
	comboTiposDocumento();
	//Definicion de Constantes y Enums
	var catTipoTransaccionFileUpload = {
  		'enviar':4,
  		'modificar':5,
  		'eliminar':6
  	};
	var nomAr = "";

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('pdf', 'submit');
	deshabilitaBoton('enviar', 'button');
	$('#cuentaAhoID').focus();

	$(':text').focus(function() {
	 	esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
		grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cuentaAhoID');
	 	}
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#adjuntar').click(function() {
		if($('#cuentaAhoID').val()==null || $('#cuentaAhoID').val()==''){
			mensajeSis("Especifique Cuenta de Ahorro");
			$('#cuentaAhoID').focus();
		}else{
			if ($('#tipoDocumento').val()==null || $('#tipoDocumento').val()==''){
				mensajeSis("Seleccione un tipo de Documento");
				$('#tipoDocumento').focus();
			}else{
				subirArchivos();
			}
		}
	});

	$('#pdf').click(function() {


			$('#enlace').removeAttr("href");

			consultaNumeroDocumentosPorCuenta();

	});
	var numeroDocumentos = 0;
	//funcion que consulta si exite documentos digitalizados y generar el pdf
	function consultaNumeroDocumentosPorCuenta() {
		var  cuentaArchivosBean={
			'cuentaAhoID' :$('#cuentaAhoID').val(),


		};
		setTimeout("$('#cajaLista').hide();", 200);


			fileServicio.consultaArCuenta(14,cuentaArchivosBean,function(cuenta) {
				if(cuenta!=null){
					numeroDocumentos = 	cuenta.numeroDocumentos;
					if(numeroDocumentos > 0 ){
						var parametrosBean = consultaParametrosSession();
						var fechaEmision = parametrosBean.fechaAplicacion;
						var claveUsuario = parametrosBean.claveUsuario;
						var nombreInstitucion = parametrosBean.nombreInstitucion;
						var clienteID = cuenta.clienteID;

						var pagina='cuentaFilesPDF.htm?&cuentaAhoID='+$('#cuentaAhoID').val()+'&clienteID='+clienteID+
						'&usuario='+claveUsuario+'&fechaActual='+fechaEmision+'&nombreInstitucion='	+nombreInstitucion+
						'&recurso='+parametroBean.rutaArchivos;
					window.open(pagina);

					} else{
						mensajeSis("No hay documentos digitalizados.");
					}
				}else{
					mensajeSis("No hay documentos digitalizados.");
				}
			});

	}
	//fin de la funcion que consulta si exite documentos digitalizados y generar el pdf



	$('#cuentaAhoID').blur(function() {
		$('#tipoDocumento').val('');
		$('#gridArchivosCta').hide();
  		consultaCtaAho(this.id);
	});

	$('#cuentaAhoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#cuentaAhoID').val();

			lista('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}
	});

	$('#file').change(function(){
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
		$('#observacion').focus();
	});

	$('#tipoDocumento').blur(function() {
		consultaArchivCliente();
	});
	$('#tipoDocumento').change(function() {
		consultaArchivCliente();
	});

	$('#observacion').change(function() {
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
	});

	var parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	$('#recurso').val(parametroBean.rutaArchivos);

	//------------ Validaciones de la Forma -------------------------------------
	$.validator.addMethod('filesize', function(value, element, param) {
	    // param = size (en bytes)
	    // element = element to validate (<input>)
	    // value = value of the element (file name)
	    return this.optional(element) || (element.files[0].size <= param) ;
	});

	$('#formaGenerica').validate({
		rules: {
			cuentaAhoID: {
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
			cuentaAhoID: {
				required: 'Especificar Cuenta'
			},
			tipoDocumento: {
				required: 'Especificar Tipo de Documento'
			},
			observacion: {
				required: 'Especificar Observacion'
			}	,
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamanio maximo de 3MB'
			}
		}
	});

//------------ Validaciones de Controles -------------------------------------

	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente =2;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
				if(cliente!=null){
					$('#nombreCliente').val(cliente.nombreCompleto);
				}else{
					mensajeSis("No Existe el Cliente");
					$(jqCliente).focus();
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
		var conCtaAho =2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaAho != '' && !isNaN(numCtaAho)){
			cuentasAhoServicio.consultaCuentasAho(conCtaAho,CuentaAhoBeanCon,function(ctaAho){
						if(ctaAho!=null){
							$('#cuentaAhoID').val(ctaAho.cuentaAhoID);
							$('#nombreCliente').val(ctaAho.clienteID);
							consultaCliente('nombreCliente');
							habilitaBoton('pdf', 'button');
						}else{
							mensajeSis("No Existe la Cuenta de Ahorro");
							$(jqCtaAho).focus();
							$(jqCtaAho).val("");
							$(nombreCliente).val("");
							deshabilitaBoton('enviar', 'submit');
							deshabilitaBoton('pdf', 'button');
						}
				});
		}else{
			if(isNaN(numCtaAho) && esTab){
				mensajeSis("No Existe la Cuenta de Ahorro");
				$(jqCtaAho).focus();
				$(jqCtaAho).val("");
				$(nombreCliente).val("");
				deshabilitaBoton('enviar', 'submit');

			}
		}
	}


});

function consultaArchivCliente(){

	var tipoDoc = $('#tipoDocumento').val();
	if($('#cuentaAhoID').val()==null || $('#cuentaAhoID').val()==''){

	}else{
		if (tipoDoc != '' ){
			var params = {};

			params['tipoLista'] = 4;
			params['cuentaAhoID'] = $('#cuentaAhoID').val();
			params['tipoDocumento'] = $('#tipoDocumento').val();
			$.post("gridCtaFileUpload.htm", params, function(data){
					if(data.length >0) {
						$('#gridArchivosCta').html(data);
						$('#gridArchivosCta').show();
						habilitaBoton('pdf', 'button');
						habilitaBoton('enviar', 'button');
					}else{
						$('#gridArchivosCta').html("");
						$('#gridArchivosCta').show();
					}
			});
		}else{
			$('#gridArchivosCta').html("");
			$('#gridArchivosCta').hide();
		}
	}

}


//funcion para llenar el combo de procesos de escalamiento
function comboTiposDocumento() {
	var tiposDoc = {
		'requeridoEn':'Q'
	};
	dwr.util.removeAllOptions('tipoDocumento');
	dwr.util.addOptions('tipoDocumento', {'':'Selecciona'});
	tiposDocumentosServicio.listaCombo(1,tiposDoc, function(tiposDocumentos){
		dwr.util.addOptions('tipoDocumento', tiposDocumentos, 'tipoDocumentoID', 'descripcion');
	});
}

function eliminaArchivo(id,idDesTipoDoc) {
	$('#tipoTransaccion').val('6');
	$('#archivoCuentaID').val(id);
	confirmarEliminar(id,idDesTipoDoc) ;
}

function eliminarArchivo(id) {
	$('#tipoTransaccion').val('6');
	var tipoTrans = 6;

		var cuentaArchivoBean ={
				'cuentaAhoID': $('#cuentaAhoID').val(),
				'tipoDocumento': $('#tipoDocumento').val(),
				'archivoCuentaID':id
		};

		fileServicio.bajaArchivosCta(cuentaArchivoBean, function(mensaje){
			if(mensaje != null){
				mensajeSis(mensaje.descripcion);
				consultaArchivCliente();
				}
		});
}


function confirmarEliminar(id,idDesTipoDoc) {
	mensajeSisRetro({
				mensajeAlert : '¿Desea eliminar el documento '+ idDesTipoDoc +'?',
				muestraBtnAceptar: true,
				muestraBtnCancela: true,
				muestraBtnCerrar: true,
				txtAceptar : 'Aceptar',
				txtCancelar : 'Cancelar',
				txtCabecera:  'Mensaje:',
				funcionAceptar : function(){
					eliminarArchivo(id);
				},
				funcionCancelar : function(){},
				funcionCerrar   : function(){}
			});
}


var parametrosBean = consultaParametrosSession();
var rutaArchivos = parametrosBean.rutaArchivos;
var ventanaArchivosCliente ="";
function subirArchivos() {
	var url ="cuentasFileUploadVista.htm?Cta="+$('#cuentaAhoID').val()+"&td="+$('#tipoDocumento').val();
	var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
	var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

	ventanaArchivosCuenta = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
									"left="+leftPosition+
									",top="+topPosition+
									",screenX="+leftPosition+
									",screenY="+topPosition);

	//$.blockUI({message: "Favor de terminar el proceso"});

}


function verArchivosCta(id, idTipoDoc, idarchivo) {

	var varCuentaVerArchivo = $('#cuentaAhoID').val();
	var varTipoDocVerArchivo = idTipoDoc;
	var varArchivoCtaVerArchivo = idarchivo;
	var varTipoConVerArchivo = 11;
	var parametros = "?cuentaAhoID="+varCuentaVerArchivo+"&tipoDocumento="+
		varTipoDocVerArchivo+"&tipoConsulta="+varTipoConVerArchivo+"&archivoCuentaID="+varArchivoCtaVerArchivo;

	var pagina="cuentasVerArchivos.htm"+parametros;

	var idrecurso = eval("'#recursoCteInput"+ id+"'");
	var extensionArchivo=  $(idrecurso).val().substring( $(idrecurso).val().lastIndexOf('.'));

	if(extensionArchivo ==".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg"){
		$('#imgCliente').attr("src",pagina);
		$('#imagenCte').html();
		  //$.blockUI({message: $('#imagenCte')});
		 $.blockUI({message: $('#imagenCte'),
			   css: {
         top:  ($(window).height() - 400) /2 + 'px',
         left: ($(window).width() - 1000) /2 + 'px',
         width: '70%'
     } });
		  $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);


	}else{
		window.open(pagina,'_blank');
		$('#imagenCte').hide();
	}
}