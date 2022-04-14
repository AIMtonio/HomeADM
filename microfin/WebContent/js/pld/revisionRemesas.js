var parametroBean = consultaParametrosSession();

$(document).ready(function() {
	esTab = false;

	var catTipoTransaccion = {
		 'grabar'	: 1
	};

	$.validator.setDefaults({
        submitHandler: function(event) {
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','remesaFolioID','funcionExito','funcionFallo');
        }
	});
	
	// METODOS  Y MANEJO DE EVENTOS
	var parametroBean = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	limpiaCamposPantalla();
	$("#remesaFolioID").focus();
	$('#monto').val(0.00);
	$('#monto').formatCurrency({
		positiveFormat : '%n',
		roundToDecimalPlace : 2
	});
	
	// Pone tab falso cuando toma el foco input text
	$(':text').focus(function() {
	 	esTab = false;
	});

	// Pone tab en verdadero cuando se presiona tab
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab = true;
		}
	});
	
	// Función para consultar la Referencia de la Remesa
	$('#remesaFolioID').bind('keyup', function(e){
		var camposLista = new Array();
	    var parametrosLista = new Array();
	    camposLista[0] = "descripcion";
	    parametrosLista[0] = $('#remesaFolioID').val();
		lista('remesaFolioID', '2', '1', camposLista, parametrosLista,'listaRemesasWS.htm');
	});
	
	// Consulta de Referencia de la Remesa
	$('#remesaFolioID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			var remesaFolio = $('#remesaFolioID').val();
			if(remesaFolio == 0 || remesaFolio == ''){
				limpiaCamposPantalla();
			}
			else {
				consultaReferenciaRemesa();
			}
		}
	});
	
	
	// Graba Revisión de Remesas
	$('#grabar').click(function() {
		if(!$('#permiteOperacionS').is(':checked') && !$('#permiteOperacionN').is(':checked')){
			mensajeSis("Especifique Permite Operación.");
			$('#permiteOperacionS').focus();
	    }else{
	    	$('#tipoTransaccion').val(catTipoTransaccion.grabar);
	    }
	});
	
	// Consulta de Documentos del Check List de Remesa
	$('#expediente').click(function() {
		consultaDocumentosCheckListRemesa();
	});
	
	 // VALIDACIONES DE LA FORMA
	$('#formaGenerica').validate({
		rules: {
			remesaFolioID: {
				required: true
			},
			comentario: {
				required: true
			}
		},
		messages: {
			remesaFolioID: {
				required: 'Especifique la Referencia.'
			},
			comentario: {
				required: 'Especifique el Comentario.'
			}
		}
	});

	 // ============================= VALIDACIONES DE CONTROLES =============================
	
	// Función para consultar la Referencia de Remesas
	function consultaReferenciaRemesa() {
		var remesaFolioID = $('#remesaFolioID').val();
		var numConsulta = 1;

		limpiaCamposPantalla();
		
		$('#imagenCre').hide();
		
		var bean = {
			'remesaFolioID':remesaFolioID 
		};
		
		setTimeout("$('#cajaLista').hide();", 200);
		if(remesaFolioID != ''){
			bloquearPantalla();
			revisionRemesasServicio.consulta(numConsulta,bean,function(remesas){
				if (remesas != null) {
					$('#contenedorForma').unblock();
					$('#remesadora').val(remesas.remesadora);
					if(remesas.clienteID > 0){
						$('#clienteID').val(remesas.clienteID);
						$('#usuarioServicioID').val("");
						$('#nombreUsuario').val("");
						consultaCliente('clienteID');
						
					}else{
						$('#usuarioServicioID').val(remesas.usuarioServicioID);
						$('#clienteID').val("");
						$('#nombreCliente').val("");
						consultaUsuarioServicio('usuarioServicioID');
					}
					$('#monto').val(remesas.monto);
					$('#monto').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});
					$('#direccion').val(remesas.direccion);
					$('#motivoRevision').val(remesas.motivoRevision);
					$('#formaPago').val(remesas.formaPago);
					$('#estatus').val(remesas.estatus);
					
					if(remesas.formaPago == 'R'){
						$('#formaPagoR').attr("checked",true);
						$('#formaPagoA').attr("checked",false);
						$('#formaPagoS').attr("checked",false);
					}
					else if(remesas.formaPago == 'A'){
						$('#formaPagoR').attr("checked",false);
						$('#formaPagoA').attr("checked",true);
						$('#formaPagoS').attr("checked",false);
					}
					else {
						$('#formaPagoR').attr("checked",false);
						$('#formaPagoA').attr("checked",false);
						$('#formaPagoS').attr("checked",true);
					}
					
					$('#identificacion').val(remesas.identificacion);
					consultaCheckListRemesas();
				}else {
					$('#contenedorForma').unblock();
					limpiaCamposPantalla();
					mensajeSis('La Referencia No Existe.');
					$('#remesaFolioID').val('');				
					$('#remesaFolioID').focus();
				}
			});
		}
	}
	
	// Función para consultar el Cliente
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var numConsulta = 1;
		
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente)) {
			clienteServicio.consulta(numConsulta,numCliente,function(cliente) {
				if (cliente != null) {
					$('#nombreCliente').val(cliente.nombreCompleto);
					if(cliente.estatus != 'A'){
						mensajeSis("El Cliente No está Activo.");
						$('#clienteID').val('');				
						$('#clienteID').focus();
						$('#nombreCliente').val('');
					}
				}else{
					mensajeSis("El Cliente No Existe.");
					$('#clienteID').val('');				
					$('#clienteID').focus();
					$('#nombreCliente').val('');
				}
			});
		}
	}
	
	// Función para consultar el Usuario de Servicio
	function consultaUsuarioServicio(idControl) {
		var jqUsuario  = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();
		var conUsuario = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario)){
			
			var usuarioBean = {
				'usuarioID' : numUsuario
			};
			
			usuarioServicios.consulta(conUsuario,usuarioBean,function(usuario) {
				if(usuario!=null){
					if(usuario.estatus == "A"){
						$('#nombreUsuario').val(usuario.nombreCompleto);
					}else {
						mensajeSis("El Usuario de Servicio No está Activo.");
						$('#usuarioServicioID').focus();
						$('#usuarioServicioID').val('');
						$('#nombreUsuario').val('');
					}
				}else{
					mensajeSis("El Usuario de Servicio No Existe.");
					$('#usuarioServicioID').focus();
					$('#usuarioServicioID').val('');
					$('#nombreUsuario').val('');
				}
			});
		}
	}
	
	// Función para consultar los Documentos del Check List de Remesa
	function consultaDocumentosCheckListRemesa() {
		setTimeout("$('#cajaLista').hide();", 200);
		var remesaFolioID = $('#remesaFolioID').val();
		var numConsulta = 2;
		
		var bean = {
			'remesaFolioID':remesaFolioID

		};

		if (remesaFolioID != '') {
			revisionRemesasServicio.consulta(numConsulta, bean, function(remesas) {
				if (remesas != null) {
					var numeroDocumentos = remesas.numeroDocumentos;
					if (numeroDocumentos > 0) {
						var parametrosBean = consultaParametrosSession();
						var fechaEmision = parametrosBean.fechaAplicacion;
						var claveUsuario = parametrosBean.claveUsuario;
						var nombreInstitucion = parametrosBean.nombreInstitucion;

						var clienteID = $('#clienteID').val();
						var nombreCliente = $('#nombreCliente').val();
						var usuarioServicioID = $('#usuarioServicioID').val();
						var nombreUsuario = $('#nombreUsuario').val();

						var pagina = 'revisionRemesasFilePDF.htm?remesaFolioID=' + remesaFolioID + '&clienteID=' + clienteID 
																+ '&nombreCliente=' + nombreCliente + '&usuarioServicioID=' + usuarioServicioID 
																+ '&nombreUsuario=' + nombreUsuario + '&usuario=' + claveUsuario 
																+ '&fechaEmision=' + fechaEmision + '&nombreInstitucion=' + nombreInstitucion;
						window.open(pagina);

					} else {
						mensajeSis("La Referencia No tiene Documentos Digitalizados.");
					}
				} else {
					mensajeSis("La Referencia No tiene Documentos Digitalizados.");
				}
			});
		}
	}

});  // Fin document
	
	//Función para consultar Check List Remesas
	function consultaCheckListRemesas(){	
		var params = {};
		
		params['remesaFolioID'] = $('#remesaFolioID').val();
		params['tipoLista'] = 1;
		
		$.post("revRemesasCheckListGrid.htm", params, function(data){		
			if(data.length >0) {
				$('#gridRevRemesasCheckList').html(data);
				$('#gridRevRemesasCheckList').show();
				consultaNumeroDocumentosCheckListRemesa();
				validaEstatusRemesas();
			}else{
				$('#gridRevRemesasCheckList').html("");
				$('#gridRevRemesasCheckList').show();
				consultaNumeroDocumentosCheckListRemesa();
				validaEstatusRemesas();
			}
		});
	}
	
	// Función para Consultar el Número de los Documentos del Check List de Remesa
	function consultaNumeroDocumentosCheckListRemesa() {
		var remesaFolioID = $('#remesaFolioID').val();
		var numConsulta = 2;
		
		var bean = {
			'remesaFolioID':remesaFolioID
		};
		
		if (remesaFolioID != '') {
			revisionRemesasServicio.consulta(numConsulta, bean,{ async: false, callback: function(remesas) {
				if (remesas != null) {
					var numeroDocumentos = remesas.numeroDocumentos;
					if (numeroDocumentos > 0) {
						habilitaBoton('expediente', 'submit');
					} else {
						deshabilitaBoton('expediente', 'submit');
					}
				} else {
					deshabilitaBoton('expediente', 'submit');
				}
			}});
		}
	}

	
	// Función para agregar un Nuevo Documento
	function agregarDocumentos(){
		var numeroFila = ($('#miTabla >tbody >tr').length - 1);
		var nuevaFila = parseInt(numeroFila) + 1;
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
		
		if(numeroFila == 0){
			tds += '<td><input type="text" id="checkListRemWSID'+nuevaFila+'" name="checkListRemWSID"  size="10"  value="1" readOnly="true" disabled="true" autocomplete="off"/></td>';
			tds += '<td><input type="text" id="tipoDocumentoID'+nuevaFila+'" name="tipoDocumentoID"  size="10"  onkeypress="listaTipoDocumento(this.id)" onblur="consultaTipoDocumento(this.id)" autocomplete="off" /></td>';
			tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="descripcion"  size="60" maxlength="60" readOnly="true" disabled="true" autocomplete="off" /></td>';
			tds += '<td><textarea id="descripcionDoc'+nuevaFila+'" name="descripcionDoc" cols="35" rows="2" maxlength="200" onBlur="ponerMayusculas(this);" autocomplete="off" /></td>';
			tds += '<td><input type="button" id="ver'+nuevaFila+'" name="ver" class="submit" value="Ver" </td>';
			tds += '<td><input type="button" id="adjuntar'+nuevaFila+'" name="adjuntar" class="submit" value="Adjuntar" onclick="adjuntarDocumentoRemesaNuevo(this.id)" /></td>';
			
		} else{
			var valor = numeroFila+ 1;
			tds += '<td><input type="text" id="checkListRemWSID'+nuevaFila+'" name="checkListRemWSID"  size="10"  value="" readOnly="true" disabled="true" /></td>';
			tds += '<td><input type="text" id="tipoDocumentoID'+nuevaFila+'" name="tipoDocumentoID"  size="10"  onkeypress="listaTipoDocumento(this.id)" onblur="consultaTipoDocumento(this.id)" autocomplete="off" /></td>';
			tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="descripcion"  size="60" maxlength="60" readOnly="true" disabled="true" autocomplete="off" /></td>';
			tds += '<td><textarea id="descripcionDoc'+nuevaFila+'" name="descripcionDoc" cols="35" rows="2" maxlength="200" onBlur="ponerMayusculas(this);" autocomplete="off" /></td>';
			tds += '<td><input type="button" id="ver'+nuevaFila+'" name="ver" class="submit" value="Ver" /></td>';
			tds += '<td><input type="button" id="adjuntar'+nuevaFila+'" name="adjuntar" class="submit" value="Adjuntar" onclick="adjuntarDocumentoRemesaNuevo(this.id)" /></td>';
			
		}
			tds += '</tr>';
			$("#miTabla").append(tds);
			deshabilitaBotonVer(nuevaFila);
			obtenerNumeroProximo(nuevaFila);
			agregaFormatoControles('formaGenerica');

			return false;
	}
	
	// Función para consultar las Filas del Grid
	function consultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;
		});
		return totales;
	}
	
	// Función para obtener el Consecutivo Próximo del Check List
	function obtenerNumeroProximo(fila){
		var totales = 0;
		$('tr[name=renglon]').each(function() {
			totales++;
		});
		
		if(totales == 1){
			$('#checkListRemWSID'+(fila)).val("1");
			$('#tipoDocumentoID1').focus();
		}
		
		if(totales > 1){
			var valorAnterior = $('#checkListRemWSID'+(fila-1)).val();
			var valorSiguiente = parseInt(valorAnterior) + 1; 
	
			$('#checkListRemWSID'+(fila)).val(valorSiguiente);
			$('#tipoDocumentoID'+(fila)).focus();
		}
	}
	
	// Función para listar Tipos de Documentos
	function listaTipoDocumento(idControl){
		var jq = eval("'#" + idControl + "'");
		$(jq).bind('keyup',function(e){
			var jqControl = eval("'#" + this.id + "'");
			var num = $(jqControl).val();
			
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = num;
			lista(idControl, '2', '3', camposLista, parametrosLista, 'ListaTiposDocumentos.htm');
		});
	}

	// Función para consultar el Tipo de Documento
	function consultaTipoDocumento(control){
		var jq = eval("'#" + control + "'");
		var tipoDocumento = $(jq).val();
		var jqDescripcion = eval("'#descripcion" + control.substr(15) + "'");
		setTimeout("$('#cajaLista').hide();", 200);
		
		var tipoConsulta = 3;
		
		var bean={
			'tipoDocumentoID':tipoDocumento
		};
		
		if(tipoDocumento != '' && !isNaN(tipoDocumento)){
			if(verificaSeleccionado(control) == 0){
				tiposDocumentosServicio.consulta(tipoConsulta,bean, function(descripcion) { 
					if(descripcion!=null){
						$(jqDescripcion).val(descripcion.descripcion);
					}else{
						mensajeSis("El Tipo de Documento No existe.");
						$(jq).focus();
						$(jq).val("");
						$(jqDescripcion).val("");
					}
				});
			}
		}else{
			$(jq).val("");
			$(jqDescripcion).val("");
		}
	}
	
	// Función para verificar si ya existe un Tipo de Documento seleccionado
	function verificaSeleccionado(idCampo){
		var contador = 0;
		var nuevoTipo = $('#'+idCampo).val();
		var numeroNuevo = idCampo.substr(15,idCampo.length);
		var jqDescripcion 	= eval("'descripcion" + numeroNuevo+ "'");
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqIdDocumentos = eval("'tipoDocumentoID" + numero+ "'");
			var valorDocumentos = $('#'+jqIdDocumentos).val();
			if(jqIdDocumentos != idCampo){
				if(valorDocumentos == nuevoTipo){
					mensajeSis("El Número de Tipo de Documento ya Existe.");
					$('#'+idCampo).focus();
					$('#'+idCampo).val("");
					$('#'+jqDescripcion).val("");
					contador = contador+1;
				}
			}
		});
		return contador;
	}
	
	// Función para Ver el Documento de Check List de Revisión de Remesas
	function verDocumentoRemesa(id, idarchivo,recurso) {
		var varRemesaFolioID = $('#remesaFolioID').val();
		var varIdarchivo = idarchivo;
		var parametros = "?remesaFolioID="+varRemesaFolioID+"&recurso="+recurso+"&checkListRemWSID="+varIdarchivo;

		var pagina = "revRemesasCheckListVerDoc.htm"+parametros;
		var idrecurso = eval("'#recursoRemesasInput"+ id+"'");
		var extensionArchivo =  $(idrecurso).val().substring( $(idrecurso).val().lastIndexOf('.'));
		extensionArchivo = extensionArchivo.toLowerCase();
		
		if(extensionArchivo == ".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg"){
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
	
	// Función para Adjuntar el Documento de Check List de Revisión de Remesas
	function adjuntarDocumentoRemesa(id, idarchivo,idDocumento,descripcionDoc) {
		var varRemesaFolioID = $('#remesaFolioID').val();
		var varIdarchivo = idarchivo;
		var varIdDocumento = idDocumento;
		var varDescripcionDoc = descripcionDoc;
		
		var url ="revRemesasCheckListDoc.htm?remesaFolioID="+varRemesaFolioID+"&checkListRemWSID="+varIdarchivo+"&tipoDocumentoID="+varIdDocumento+"&descripcionDoc="+varDescripcionDoc;
 		var leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
 		var topPosition = (screen.height) ? (screen.height-500)/2 : 0;
 		ventanaDocumentosRemesas = window.open(url,
 				"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no," +
 				"addressbar=0,menubar=0,toolbar=0"+
 				"left="+leftPosition+
 				",top="+topPosition+
 				",screenX="+leftPosition+
 				",screenY="+topPosition);
	}
	
	// Función para Adjuntar el Documento de Check List de Revisión de Remesas Nuevo
	function adjuntarDocumentoRemesaNuevo(control) {
		var numero = control.substr(8,control.length);
		var varRemesaFolioID = $('#remesaFolioID').val();
		var varIdarchivo = $('#checkListRemWSID'+numero).val();
		var varIdDocumento =$('#tipoDocumentoID'+numero).val();
		var varDescripcionDoc = $('#descripcionDoc'+numero).val();

		var url ="revRemesasCheckListDoc.htm?remesaFolioID="+varRemesaFolioID+"&checkListRemWSID="+varIdarchivo+"&tipoDocumentoID="+varIdDocumento+"&descripcionDoc="+varDescripcionDoc;
 		var leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
 		var topPosition = (screen.height) ? (screen.height-500)/2 : 0;
 		ventanaDocumentosRemesas = window.open(url,
 				"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no," +
 				"addressbar=0,menubar=0,toolbar=0"+
 				"left="+leftPosition+
 				",top="+topPosition+
 				",screenX="+leftPosition+
 				",screenY="+topPosition);
	}
	
	// Función para deshabilitar el Botón Ver
	function deshabilitaBotonVer(numero) {
		deshabilitaBoton('ver'+numero, 'submit');
	}
	
	// Función para Bloquear la Pantalla
	function bloquearPantalla(){
		$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
		$('#contenedorForma').block({
			message: $('#mensaje'),
		 	css: {border:		'none',
		 			background:	'none'}
		});
	}
	
	// Función para validar el Estatus de la Remesa
	function validaEstatusRemesas() {
		var estatus = $('#estatus').val();
		var estatusNuevo 		="N";
		var estatusEnRevision 	="R";
		var estatusPagada		="P";
		var estatusRechazada 	="C";

		if(estatus == estatusNuevo){
			mensajeSis('El Estatus de la Remesa es NUEVA.');
			deshabilitaCamposPantalla();
		}
		if(estatus == estatusEnRevision){
			habilitaBoton('grabar', 'submit');
		}
		if(estatus == estatusPagada){
			mensajeSis('El Estatus de la Remesa es PAGADA.');
			deshabilitaCamposPantalla();
		}
		if(estatus == estatusRechazada){
			mensajeSis('El Estatus de la Remesa es RECHAZADA.');
			deshabilitaCamposPantalla();
		}
	}
	
	// Función para deshabilitar campos de la Pantalla
	function deshabilitaCamposPantalla(){
		$('tr[name=renglon]').each(function() {
			numero = this.id.substr(7,this.id.length);
			deshabilitaBoton('adjuntar'+numero, 'submit');
		});
		deshabilitaBoton('agregar', 'submit');
		deshabilitaBoton('grabar', 'submit');
	}
	

	// Función para limpiar Campos de la Pantalla
	function limpiaCamposPantalla(){
		agregaFormatoControles('formaGenerica');
		$('#remesadora').val('');
		$('#clienteID').val('');
		$('#nombreCliente').val('');
		$('#usuarioServicioID').val('');
		$('#nombreUsuario').val('');
		$('#monto').val(0.00);
		$('#monto').formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});
		$('#direccion').val('');
		$('#motivoRevision').val('');
		$('#formaPago').val('');
		$('#formaPagoR').attr("checked",false);
		$('#formaPagoA').attr("checked",false);
		$('#formaPagoS').attr("checked",false);
		$('#identificacion').val('');
		$('#permiteOperacionS').attr("checked",false);
		$('#permiteOperacionN').attr("checked",false);
		$('#comentario').val('');
		$('#estatus').val('');
		$('#gridRevRemesasCheckList').html("");
		$('#gridRevRemesasCheckList').hide();
		deshabilitaBoton('grabar', 'submit');
		deshabilitaBoton('expediente', 'submit');
	}

	// Función Exito
	function funcionExito(){
		limpiaCamposPantalla();
		$('#remesaFolioID').focus();
	}

	// Función Error
	function funcionFallo(){
	$('#monto').formatCurrency({
		positiveFormat : '%n',
		roundToDecimalPlace : 2
		});
	}
