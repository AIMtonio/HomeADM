	var catTipoTransaccion = {
		'prestamo' : 1,
		'solicitante' : 2,
		'otrasFuentes' : 3,
		'prestamoElimina': 4,
		'solicitaElimina': 5,
		'otrasFuenElimina': 6

	};

	$(document).ready(function() {
		esTab = false;		
		/********** METODOS Y MANEJO DE EVENTOS ************/
		agregaFormatoControles('formaGenerica');
		//consultaRecursosPrestamo();
		deshabilitaBoton('agregar', 'submit');
		$('#solicitudCreditoID').focus();
		$('#divRecursosPrestamo').hide();
		$('#divRecursosSolicitante').hide();
		$('#divRecursosOtrasFuentes').hide();

		$(':text').focus(function() {	
		 	esTab = false;
		});
	
		$(':text').bind('keydown',function(e){
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
			}
		});	

		$('#solicitudCreditoID').bind('keyup', function(e) {
		if (this.value.length >= 0) {
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#solicitudCreditoID').val();

			lista('solicitudCreditoID', '1', '14', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
			}
		});

		$('#solicitudCreditoID').blur(function() {
			if(esTab ){
				consultaSolicitud(this.id);
			}
		});

		if( $('#numSolicitud').val() != "" ){

			var numSolicitud=  $('#numSolicitud').val();
			$('#solicitudCreditoID').val(numSolicitud);
			if(esTab){
				consultaSolicitud('solicitudCreditoID');
			} 
		}

		$.validator.setDefaults({
			submitHandler: function(event) { 	
				       	
		       	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','solicitudCreditoID','exito','fallo');
	   		}
		});	
		
		//------------ Validaciones de la Forma -------------------------------------
		$('#formaGenerica').validate({
			rules: {	
				solicitudCreditoID: {
					required: true,
					numeroPositivo : true,
				},			
			},
			messages: {	
				solicitudCreditoID: {
					required: 'Especifique el número de Solicitud',
					numeroPositivo : "Sólo números",
				},			
			}		
		});
		

		$('#grabarPres').click(function() {
			var numFilas = consultaFilas();
			var validado = validaVacios();
			if(numFilas==1 && validado==2){
				$('#tipoTransaccion').val(catTipoTransaccion.prestamoElimina);
			}else if(validado==0){

				$('#tipoTransaccion').val(catTipoTransaccion.prestamo);
				guardarDatos(); 
				validaTotales();
			}

		});

		$('#grabarSol').click(function() {
			var numFilas = consultaFilaSolicita();
			var validado = validaVacioSol();
			if(numFilas==1 && validado==2){
				$('#tipoTransaccion').val(catTipoTransaccion.solicitaElimina);
			}else if(validado ==0){

				$('#tipoTransaccion').val(catTipoTransaccion.solicitante);
				guardarDatosSolicita(); 
			}
		
		});

		$('#grabarOF').click(function() {

			var numFilas = consultaFilaOF();
			var validado = validaVacioOtrasF();
			if(numFilas==1 && validado==2){
				$('#tipoTransaccion').val(catTipoTransaccion.otrasFuenElimina);
			}else if(validado==0){
				$('#tipoTransaccion').val(catTipoTransaccion.otrasFuentes);
				guardarDatosOtrasF(); 
			}
		});

	
	}); // Fin document ready

	// consulta La solicitud

	function consultaSolicitud(idControl) {
		var jqSolicitud = eval("'#" + idControl + "'");
		var solCred = $(jqSolicitud).val();
		var numConsulta = 9;
		var SolCredBeanCon = {
			'solicitudCreditoID' : solCred
			};
		setTimeout("$('#cajaLista').hide();", 200);
	
		if (solCred != '' && !isNaN(solCred)) {
			solicitudCredServicio.consulta(numConsulta, SolCredBeanCon, function(solicitud) {
				if (solicitud.solicitudCreditoID != null && solicitud.solicitudCreditoID != 0) {
					$('#clienteID').val(solicitud.clienteID);
					$('#montoSolicitud').val(solicitud.montoSolici);
					consultaCliente(solicitud.clienteID);


				} else {
					mensajeSis("No Existe La Solicitud de Crédito Agropecuaria");
					limpiarPantalla();
				}
			});
		}
		else{
			$('#solicitudCreditoID').val('');
			limpiarPantalla();

		}
		
	}
	// consulta el cliente

	function consultaCliente(idControl) {
		//var jqCliente = eval("'#" + idControl + "'");
		var numCliente = idControl;
		var tipConForanea = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente)) {
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if (cliente != null) {
					$('#clienteID').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
					consultaFecha();
					consultaRecursosOtrasFuentes();	
					consultaRecursosSolicitante();	 
					consultaRecursosPrestamo();	 
					
					$('#conceptoInvIDRP'+1).focus(); 

					 if (cliente.estatus=='I'){
							deshabilitaBoton('agregar','submit');
							mensajeSis("El Cliente se encuentra Inactivo");
							$('#clienteID').val('');
							$('#nombreCliente').val('');
							$('#solicitudCreditoID').focus();
					 }
				} else {
					mensajeSis("No Existe el Cliente");
					limpiarPantalla();
				}
			});
		}
		else{
			
			$('#clienteID').val('');
			$('#nombreCliente').val('');
			$('#clienteID').focus();
			$('#gridRecPrestamo').html("");
			$('#gridRecPrestamo').hide();

		}
		
	}

	function consultaRecursosPrestamo(){
		if($('#clienteID').val()!=''){
			var params = {};
			params['tipoLista'] = 1;
			params['tipoRecurso']= 'P';
			params['clienteID'] = $('#clienteID').val();
			params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
			$.post("conceptosInvAgroGridVista.htm", params, function(data){	
				if(data.length >0 ) {
					$('#divRecursosPrestamo').show();
					$('#gridRecPrestamo').show();
					$('#gridRecPrestamo').html(data);
					agregaFormatoControles('formaGenerica');
					var numero = consultaFilas();
					if(numero > 0){
						habilitaBoton('grabar');	
					}
					else if(numero == 0){
						agregaNuevoDetalle();	
						$('#totalRecursoPrestamo').val(0.00);
						$('#totalRecursoPrestamo').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

					}
					
				}
			});
		}
		else{
			$('#divRecursosPrestamo').show();
			$('#gridRecPrestamo').html("");
			$('#gridRecPrestamo').hide();
			$('input[name=elimina]').each(function() {
				eliminaDetalle(this);
			});	
		}	
	}
	
	function consultaRecursosSolicitante(){
		if($('#clienteID').val()!=''){
			var params = {};
			params['tipoLista'] = 2;
			params['tipoRecurso']= 'S';
			params['clienteID'] = $('#clienteID').val();
			params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
			$.post("conceptosInvSolAgroGridVista.htm", params, function(data){	
				if(data.length >0 ) {
					$('#divRecursosSolicitante').show();
					$('#gridRecSolicitante').show();
					$('#gridRecSolicitante').html(data);
					agregaFormatoControles('formaGenerica');
					var numero = consultaFilaSolicita();
					if(numero > 0){
						habilitaBoton('grabar');	
					}
					else if(numero == 0){
						agregaNuevoDetalleSol();	
						$('#totalSolicitante').val(0.00);
						$('#totalSolicitante').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

					}
					
				}
			});
		}
		else{
			$('#divRecursosSolicitante').show();
			$('#gridRecSolicitante').html("");
			$('#gridRecSolicitante').hide();
			$('input[name=elimina]').each(function() {
				eliminaDetalle(this);
			});	
		}	
	}

	function consultaRecursosOtrasFuentes(){
		if($('#clienteID').val()!=''){
			var params = {};
			params['tipoLista'] = 3;
			params['tipoRecurso']= 'OF';
			params['clienteID'] = $('#clienteID').val();
			params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
			$.post("conceptosInvOFAgroGridVista.htm", params, function(data){
				if(data.length >0 ) {
					$('#divRecursosOtrasFuentes').show();
					$('#gridRecOtrasFuentes').show();
					$('#gridRecOtrasFuentes').html(data);
					agregaFormatoControles('formaGenerica');
					var numero = consultaFilaOF();
					if(numero > 0){
						habilitaBoton('grabar');	
					}
					else if(numero == 0){
						agregaNuevoDetalleOF();	
						$('#totalotrasFuentes').val(0.00);
						$('#totalotrasFuentes').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

					}
					
				}
			});
		}
		else{
			$('#divRecursosOtrasFuentes').show();
			$('#gridRecOtrasFuentes').html("");
			$('#gridRecOtrasFuentes').hide();
			$('input[name=elimina]').each(function() {
				eliminaDetalle(this);
			});	
		}	
	}
	function muestraLista(input){
		var conceptoID = eval("'#" + input + "'");
		var conceptoFiraID = $(conceptoID).val();

		var camposLista = new Array();	
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		camposLista[1] = "clienteID";

		parametrosLista[0] = conceptoFiraID;
		parametrosLista[1] = $('#clienteID').val();
		lista(input, '', '1',camposLista,parametrosLista,'listaConceptosInvAgro.htm');

	}
	
	function muestraListaUnidad(input){
				lista(input, '1', '1','clave',$('#'+input).val(),'listaUnidadConceptoInvAgro.htm');

	}
	
	function consultaFecha() {
		var numConsulta   = 2;
		var conceptosInvBean = {
			'solicitudCreditoID' : $('#solicitudCreditoID').val(),
			'clienteID' : $('#clienteID').val()
		};	
		conceptosInversionAgroServicio.consulta(conceptosInvBean,numConsulta,function(conceptosInv) {	
			if(conceptosInv.fechaRegistro !=null){
				$('#fechaRegistro').val(conceptosInv.fechaRegistro);	
			}else{
				
				$('#fechaRegistro').val(parametroBean.fechaAplicacion);	
			}
		});
		
	}
	

	
	
///Metodos del grid recursos del prestamo************************************************************
	//consulta cuantas filas tiene el grid
	function consultaFilas(){
		var totales=0;
		$('tr[name=renglonP]').each(function() {
			totales++;		
		});
		return totales;
		
	}
	
	// suma monto de recursos prestamo
	function sumaMontoPrestamo(){ 
		var numCodigo = consultaFilas();
		var cont = 0;
		var montoTotal = 0;
		var montoSolicitudCred	= $('#montoSolicitud').asNumber();

		for(var i = 1; i <= numCodigo; i++){
			var jsMonto = $('#'+"montoInversionRP"+i+"").asNumber();

				montoTotal = (montoTotal) + (jsMonto);
				cont ++;
				if(montoTotal>montoSolicitudCred){
					mensajeSis("La Suma de los Recursos del Préstamo es Mayor al Monto de la Solicitud de Crédito.");
					
					montoTotal = parseInt(montoTotal) - parseInt(jsMonto);

					$('#'+"montoInversionRP"+i+"").val('0.00');
					$('#'+"montoInversionRP"+i+"").focus();
				}
				$('#totalRecursoPrestamo').val(montoTotal);	
				$('#totalRecursoPrestamo').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		}
		if(cont < 1){
			$('#totalRecursoPrestamo').val('0.00');
		}
		
	}

	function consultaConcepto(idControl, numFila) {
		var jqConcepto  = eval("'#" + idControl + "'");
		var numConcepto = $(jqConcepto).val();	
		var numConsulta   = 1;

		var conceptosInvBean = {
			'conceptoInvID' : numConcepto
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto)  && numConcepto>0){		
		conceptosInversionAgroServicio.consulta(conceptosInvBean,numConsulta,function(conceptosInv) {	
			if(conceptosInv !=null){
				$('#descripcionRP'+numFila).val(conceptosInv.descripcion);
				$('#noUnidadRP'+numFila).focus();
			}else{
				
				mensajeSis("No Existe el Concepto De Inversión Fira");
				$('#conceptoInvIDRP'+numFila).focus();
				$('#conceptoInvIDRP'+numFila).val("");
				$('#descripcionRP'+numFila).val("");
			}
		});
		}	else{
				$('#conceptoInvIDRP'+numFila).val("");
				$('#descripcionRP'+numFila).val("");

		}
	}
	

	function consultaConceptoRPUnidad(input, numFila){
		esTab = true;
		var unidad = $('#'+input).asNumber();
		var principal = 1;
		var bean = {
			'uniConceptoInvID' : unidad
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (unidad != 0 && esTab) {
			uniConceptosInvAgroServicio.consulta(principal,bean,{ callback:function(bean) {
				if (bean != null) {
					$('#unidadRP'+numFila).val(bean.unidad);
					$('#montoInversionRP'+numFila).focus();
				} else {
					mensajeSis("No Existe la Unidad De Inversión Fira");
					$('#claveUnidadRP'+numFila).focus();
					$('#claveUnidadRP'+numFila).val("");
					$('#unidadRP'+numFila).val("");
				}
			}
			});
		} else {
			$('#claveUnidadRP'+numFila).val("");
			$('#unidadRP'+numFila).val("");
		}
	
	}
	
	function validarSiNumeroRP(numero,numFila){
		  var er1_EntradaS = /^[0-9]*(\.[0-9]+)?$/
	          if(!er1_EntradaS.test(numero)) {
	        	  mensajeSis("Inserte un valor numerico correcto en No Unidades.");
	        	  $('#noUnidadRP'+numFila).focus();
	        	  $('#noUnidadRP'+numFila).val("");
	        	  
	          return false;
	          }
		}
	

	// Funcion para agregar nuevas Filas en el grid
	function agregaNuevoDetalle(){
		var numeroFila = consultaFilas();
		var nuevaFila = parseInt(numeroFila) + 1;		

		var td = '<tr id="renglonP' + nuevaFila + '" name="renglonP">';
		
		
		td+='<td nowrap="nowrap">';
		td+= '<input type="hidden" id="consecutivo'+nuevaFila+'" name="consecutivo" size="4"  value="'+nuevaFila+'" />';
		td+='<input type="text" id="conceptoInvIDRP'+nuevaFila+'"  name="conceptoInvIDRP" path="conceptoInvIDRP" onkeyup="muestraLista(this.id)" onblur="consultaConcepto(this.id,'+nuevaFila+');" size="12" autocomplete="off" />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="descripcionRP'+nuevaFila+'"  path="descripcionRP" name="descripcionRP" size="53"  readonly="true"  />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="noUnidadRP'+nuevaFila+'"  path="noUnidadRP" name="noUnidadRP" size="20" onChange="validarSiNumeroRP(this.value,'+nuevaFila+');"/>';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="claveUnidadRP'+nuevaFila+'"  name="claveUnidadRP" path="claveUnidadRP" onkeyup="muestraListaUnidad(this.id)" onblur="consultaConceptoRPUnidad(this.id,'+nuevaFila+');" size="6" autocomplete="off" />';
		td+='<input type="text" id="unidadRP'+nuevaFila+'"  path="unidadRP" name="unidadRP" size="30"  readonly="true"  />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="montoInversionRP'+nuevaFila+'" style="text-align:right;" size="20" name="montoInversionRP" esMoneda="true" path="montoInversionRP" onblur="sumaMontoPrestamo();" />';
		td+='</td>';
		td+='<td align="center" nowrap="nowrap"><input type="button" name="elimina" id="'+nuevaFila +'" class="btnElimina" onclick="eliminaDetalle(this);sumaMontoPrestamo()" />';
		td+='</td>';
		td+='<td>';
		td+='<input type="button" name="agrega" id="agrega'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoDetalle();"/>';
		td+='</td>';
		td+='<td nowrap="nowrap">';
		td+='<input type="hidden" id="tipoRecursoPR'+nuevaFila+'"  name="tipoRecursoPR" path="tipoRecursoPR" value="P"/>';
		td+='</td>';
		td+='</tr>';

		//document.getElementById("numeroDetalle").value = nuevaFila;    	
		$("#miTablaP").append(td);
		$('#conceptoInvIDRP'+nuevaFila).focus();
		agregaFormatoControles('formaGenerica');
		$('#montoInversionRP'+nuevaFila).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#montoInversionRP').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});


	}
	// Funcion para eliminar Filas en el grid	
	function eliminaDetalle(control){
		var numeroID = control.id;
		
		var jqRenglon = eval("'#renglonP" + numeroID + "'");
		var jqNumero = eval("'#consecutivo" + numeroID + "'");
		var jqConceptoInvIDRP = eval("'#conceptoInvIDRP" + numeroID + "'");		
		var jqDescripcion =eval("'#descripcionRP" + numeroID + "'");
		var jqNoUnidad =eval("'#noUnidadRP" + numeroID + "'");
		var jqClaveUnidad =eval("'#claveUnidadRP" + numeroID + "'");
		var jqUnidad =eval("'#unidadRP" + numeroID + "'");
		var jqMontoInversionRP = eval("'#montoInversionRP" + numeroID + "'");
		var jqTipoRecurso = eval("'#tipoRecurso" + numeroID + "'");		
		var jqAgregar=eval("'#agrega" + numeroID + "'");
		var jqEliminar = eval("'#" + numeroID + "'");
	
		// se elimina la fila seleccionada
		$(jqRenglon).remove();
		$(jqNumero).remove();
		$(jqConceptoInvIDRP).remove();
		$(jqDescripcion).remove();
		$(jqNoUnidad).remove();
		$(jqClaveUnidad).remove();
		$(jqUnidad).remove();
		$(jqMontoInversionRP).remove();
		$(jqTipoRecurso).remove();
	
		$(jqAgregar).remove();
		$(jqEliminar).remove();

		asignaID();
		var numFilas = consultaFilas();

		if(numFilas==0){
			agregaNuevoDetalle();
		}
	}

	function asignaID(){
		var contador = 1 ;
		var numero= 0;
		$('tr[name=renglonP]').each(function() {
			numero= this.id.substr(7,this.id.length);
			var jqRenglon1 = eval("'#renglonP" + numero + "'");
			var jqNumero1 = eval("'#consecutivo" + numero + "'");
			var jqConceptoInvIDRP1 = eval("'#conceptoInvIDRP" + numero + "'");		
			var jqDescripcion =eval("'#descripcionRP" + numero + "'");
			var jqNoUnidad =eval("'#noUnidadRP" + numero + "'");
			var jqClaveUnidad =eval("'#claveUnidadRP" + numero + "'");
			var jqUnidad =eval("'#unidadRP" + numero + "'");
			var jqMontoInversionRP =eval("'#montoInversionRP" + numero + "'");
			var jqTipoRecurso =eval("'#tipoRecursoPR" + numero + "'");

			var jqAgregar1=eval("'#agrega" + numero + "'");
			var jqEliminar1 = eval("'#" + numero + "'");
			
	
			$(jqNumero1).val(contador);
			
			$(jqRenglon1).attr('id','renglonP'+contador);
			$(jqNumero1).attr('id','consecutivo'+contador);
			$(jqConceptoInvIDRP1).attr('id','conceptoInvIDRP'+contador);
			$(jqDescripcion).attr('id','descripcionRP'+contador);
			$(jqNoUnidad).attr('id','noUnidadRP'+contador);
			$(jqClaveUnidad).attr('id','claveUnidadRP'+contador);
			$(jqUnidad).attr('id','unidadRP'+contador);
			$(jqMontoInversionRP).attr('id','montoInversionRP'+contador);
			$(jqTipoRecurso).attr('id','tipoRecursoPR'+contador);
			
			$(jqAgregar1).attr('id','agrega'+contador);		
			$(jqEliminar1).attr('id',contador);
	
	
			// reordenamiento indices
			$(jqRenglon1).attr('tabindex','renglonP'+contador);
			$(jqNumero1).attr('tabindex','consecutivo'+contador);
			$(jqConceptoInvIDRP1).attr('tabindex','conceptoInvIDRP'+contador);
			$(jqDescripcion).attr('tabindex','descripcionRP'+contador);
			$(jqNoUnidad).attr('tabindex','noUnidadRP'+contador);
			$(jqClaveUnidad).attr('tabindex','claveUnidadRP'+contador);
			$(jqUnidad).attr('tabindex','unidadRP'+contador);
			$(jqMontoInversionRP).attr('tabindex','montoInversionRP'+contador);
			
			$(jqAgregar1).attr('tabindex','agrega'+contador);		
			$(jqEliminar1).attr('tabindex',contador);
			
			contador = parseInt(contador + 1);	
			
		});
		
	}

	//guarda los datos como string
	function guardarDatos(){		
			
		var numCodigo = consultaFilas();
		$('#datosGrid').val("");

		for(var i = 1; i <= numCodigo; i++){
	
			controlQuitaFormatoMoneda("montoInversionRP"+i+"");
			if(i == 1){
				
				$('#datosGrid').val($('#datosGrid').val() +
				document.getElementById("conceptoInvIDRP"+i+"").value + ']' +
			    document.getElementById("descripcionRP"+i+"").value + ']' +
			    document.getElementById("noUnidadRP"+i+"").value + ']' +
			    document.getElementById("claveUnidadRP"+i+"").value + ']' +
			    document.getElementById("unidadRP"+i+"").value + ']' +
			    document.getElementById("montoInversionRP"+i+"").value + ']' +
				document.getElementById("tipoRecursoPR"+i+"").value );	
			}else{
				$('#datosGrid').val($('#datosGrid').val() + '[' +
						document.getElementById("conceptoInvIDRP"+i+"").value + ']' +
						document.getElementById("descripcionRP"+i+"").value + ']' +
						document.getElementById("noUnidadRP"+i+"").value + ']' +
						document.getElementById("claveUnidadRP"+i+"").value + ']' +
						document.getElementById("unidadRP"+i+"").value + ']' +
						document.getElementById("montoInversionRP"+i+"").value + ']' +
						document.getElementById("tipoRecursoPR"+i+"").value);
				}	
		}
	}

	//valida campos vacios grid recursos del prestamo
	function validaVacios(){ 
		var numCodigo = consultaFilas();
		var error = 0;
		if(numCodigo==1){
			var jsConcepto    = document.getElementById("conceptoInvIDRP"+1+"").value;
			var jsMonto 	  = document.getElementById("montoInversionRP"+1+"").value;
			var jsDescripcion = document.getElementById("descripcionRP"+1+"").value;
			var jsNoUnidad = document.getElementById("noUnidadRP"+1+"").value;
			var jsClaveUnidad = document.getElementById("claveUnidadRP"+1+"").value;
			var jsUnidad = document.getElementById("unidadRP"+1+"").value;
			var jsMontoTotal  = $('#totalRecursoPrestamo').val();

			if(jsConcepto == '' && jsMonto == '' && jsDescripcion == ''&& jsNoUnidad == ''&& jsClaveUnidad == ''&& jsUnidad == '' && jsMontoTotal == 0.00){
				error = 2;
			}else if (jsConcepto == ''){
				 mensajeSis("Especificar Concepto de Inversión Fira.");
				 $('#conceptoInvIDRP'+1).focus();
				 error = 1;	 
			}else if (jsMonto == ''){
					 mensajeSis("Especificar el Monto del Concepto.");
					 $('#montoInversionRP'+1).focus();
					 error = 1;	 
			}
			else if (jsNoUnidad == ''){
				 mensajeSis("Especificar No de Uniad.");
				 $('#noUnidadRP'+1).focus();
				 error = 1;	 
			}else if (jsClaveUnidad == ''){
					 mensajeSis("Especificar el ID del concepto de la Unidad.");
					 $('#claveUnidadRP'+1).focus();
					 error = 1;	 
			}
			return error;

		}else{
			for(var i = 1; i <= numCodigo; i++){
				var jsConcepto = document.getElementById("conceptoInvIDRP"+i+"").value;
				var jsMonto = document.getElementById("montoInversionRP"+i+"").value;
				var jsNoUnidad = document.getElementById("noUnidadRP"+i+"").value;
				var jsClaveUnidad = document.getElementById("claveUnidadRP"+i+"").value;
				
				if (jsConcepto == ''){
					 mensajeSis("Especificar Concepto de Inversión Fira.");
					 $('#conceptoInvIDRP'+i).focus();
					 error = 1;	 
				}else if (jsMonto == ''){
					 mensajeSis("Especificar el Monto del Concepto.");
					 $('#montoInversionRP'+i).focus();
					 error = 1;	 
				}
				else if (jsNoUnidad == ''){
					 mensajeSis("Especificar el No de Unidad.");
					 $('#noUnidadRP'+i).focus();
					 error = 1;	 
				}
				else if (jsClaveUnidad == ''){
					 mensajeSis("Especificar el ID del Concepto de la Unidad.");
					 $('#claveUnidadRP'+i).focus();
					 error = 1;	 
				}
				return error;
			
			}

		}
		
		
	}

///Metodos del grid recursos del Solicitante************************************************************
	//consulta cuantas filas tiene el grid
	function consultaFilaSolicita(){
		var totales=0;
		$('tr[name=renglonS]').each(function() {
			totales++;		
		});
		return totales;
		
	}
	
	// suma monto de recursos prestamo
	function sumaMontoSolicitante(){ 
		var numCodigo = consultaFilaSolicita();
		var cont = 0;
		var montoTotal = 0;
		for(var i = 1; i <= numCodigo; i++){
			var jsMonto = $('#'+"montoInversionRS"+i+"").asNumber();
				montoTotal = (montoTotal) + (jsMonto);
				cont ++;
				$('#totalSolicitante').val(montoTotal);	
				$('#totalSolicitante').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		
		}
		if(cont < 1){
			$('#totalSolicitante').val('0.00');
		}
		
	}


	function consultaConceptoSol(idControl, numFila) {
		var jqConcepto  = eval("'#" + idControl + "'");
		var numConcepto = $(jqConcepto).val();	
		var numConsulta   = 1;

		var conceptosInvBean = {
			'conceptoInvID' : numConcepto
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto)  && numConcepto>0){		
		conceptosInversionAgroServicio.consulta(conceptosInvBean,numConsulta,function(conceptosInv) {	
			if(conceptosInv !=null){
				$('#descripcionRS'+numFila).val(conceptosInv.descripcion);
				$('#noUnidadRS'+numFila).focus();
			}else{
				
				mensajeSis("No Existe el Concepto De Inversión Fira");
				$('#conceptoInvIDRS'+numFila).focus();
				$('#conceptoInvIDRS'+numFila).val("");
				$('#descripcionRS'+numFila).val("");
			}
		});
		}	else{
				$('#conceptoInvIDRS'+numFila).val("");
				$('#descripcionRS'+numFila).val("");

		}
	}
	
	function consultaConceptoRSUnidad(input, numFila) {
		var unidad = $('#'+input).asNumber();
		var principal = 1;
		var bean = {
			'uniConceptoInvID' : unidad
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (unidad != 0 && esTab) {
			uniConceptosInvAgroServicio.consulta(principal,bean,{ callback:function(bean) {
				if (bean != null) {
					$('#unidadRS'+numFila).val(bean.unidad);
					$('#montoInversionRS'+numFila).focus();
				} else {
					mensajeSis("No Existe la Unidad De Inversión Fira");
					$('#claveUnidadRS'+numFila).focus();
					$('#claveUnidadRS'+numFila).val("");
					$('#unidadRS'+numFila).val("");
				}
			}
			});
		} else {
			$('#claveUnidadRS'+numFila).val("");
			$('#unidadRS'+numFila).val("");
		}
	
	}
	
	function validarSiNumeroRS(numero,numFila){
		  var er1_EntradaS = /^[0-9]*(\.[0-9]+)?$/
	          if(!er1_EntradaS.test(numero)) {
	        	  mensajeSis("Inserte un valor numerico correcto en No Unidades.");
	        	  $('#noUnidadRS'+numFila).focus();
	        	  $('#noUnidadRS'+numFila).val("");
	        	  
	          return false;
	          }
		}

	// Funcion para agregar nuevas Filas en el grid
	function agregaNuevoDetalleSol(){
		var numeroFila = consultaFilaSolicita();
		var nuevaFila = parseInt(numeroFila) + 1;		

		var td = '<tr id="renglonS' + nuevaFila + '" name="renglonS">';

		td+='<td nowrap="nowrap">';
		td+= '<input type="hidden" id="consecutivo'+nuevaFila+'" name="consecutivo" size="4"  value="'+nuevaFila+'" />';
		td+='<input type="text" id="conceptoInvIDRS'+nuevaFila+'"  name="conceptoInvIDRS" path="conceptoInvIDRS" onkeyup="muestraLista(this.id)" onblur="consultaConceptoSol(this.id,'+nuevaFila+');" size="12" autocomplete="off" />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="descripcionRS'+nuevaFila+'"  path="descripcionRS" name="descripcionRS" size="53"  readonly="true"  />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="noUnidadRS'+nuevaFila+'"  path="noUnidadRS" name="noUnidadRS" size="20" onChange="validarSiNumeroRS(this.value,'+nuevaFila+');"/>';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="claveUnidadRS'+nuevaFila+'"  name="claveUnidadRS" path="claveUnidadRS" onkeyup="muestraListaUnidad(this.id)" onblur="consultaConceptoRSUnidad(this.id,'+nuevaFila+');" size="6" autocomplete="off" />';
		td+='<input type="text" id="unidadRS'+nuevaFila+'"  path="unidadRS" name="unidadRS" size="30"  readonly="true"  />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="montoInversionRS'+nuevaFila+'" style="text-align:right;" size="20" name="montoInversionRS" esMoneda="true" path="montoInversionRS" onblur="sumaMontoSolicitante();" />';
		td+='</td>';
		td+='<td align="center" nowrap="nowrap"><input type="button" name="elimina" id="eliminaRS'+nuevaFila +'" class="btnElimina" onclick="eliminaDetalleSol(this);sumaMontoSolicitante()" />';
		td+='</td>';
		td+='<td>';
		td+='<input type="button" name="agrega" id="agregarRS'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoDetalleSol();"/>';
		td+='</td>';
		td+='<td nowrap="nowrap">';
		td+='<input type="hidden" id="tipoRecursoRS'+nuevaFila+'"  name="tipoRecursoRS" path="tipoRecursoRS" value="S"/>';
		td+='</td>';
		td+='</tr>';

		//document.getElementById("numeroDetalle").value = nuevaFila;    	
		$("#miTablaSol").append(td);
		$('#conceptoInvIDRS'+nuevaFila).focus();
		agregaFormatoControles('formaGenerica');
		$('#montoInversionRS'+nuevaFila).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#montoInversionRS').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});


	} 
	// Funcion para eliminar Filas en el grid	
	function eliminaDetalleSol(control){
		var numeroID= control.id;
		numeroID= numeroID.substr(9,numeroID.length);
		var jqRenglon = eval("'#renglonS" + numeroID + "'");
		var jqNumero = eval("'#consecutivo" + numeroID + "'");
		var jqConceptoInvIDRP = eval("'#conceptoInvIDRS" + numeroID + "'");		
		var jqDescripcion =eval("'#descripcionRS" + numeroID + "'");
		var jqNoUnidad =eval("'#noUnidadRS" + numeroID + "'");
		var jqClaveUnidad =eval("'#claveUnidadRS" + numeroID + "'");
		var jqUnidad =eval("'#unidadRS" + numeroID + "'");
		var jqMontoInversionRP = eval("'#montoInversionRS" + numeroID + "'");
		var jqTipoRecurso = eval("'#tipoRecursoRS" + numeroID + "'");		
		var jqAgregar=eval("'#agregarRS" + numeroID + "'");
		var jqEliminar = eval("'#eliminaRS" + numeroID + "'");
	
		// se elimina la fila seleccionada
		$(jqRenglon).remove();
		$(jqNumero).remove();
		$(jqConceptoInvIDRP).remove();
		$(jqDescripcion).remove();
		$(jqNoUnidad).remove();
		$(jqClaveUnidad).remove();
		$(jqUnidad).remove();
		$(jqMontoInversionRP).remove();
		$(jqTipoRecurso).remove();
	
		$(jqAgregar).remove();
		$(jqEliminar).remove();
		asignaIDSol();
		// para el primer elemento
		var numFilas = consultaFilaSolicita();

		if(numFilas==0){
			agregaNuevoDetalleSol();
		}
	}

	function asignaIDSol(){
		var contador = 1 ;
		var numero= 0;
		$('tr[name=renglonS]').each(function() {
			numero= this.id.substr(8,this.id.length);
			var jqRenglon1 = eval("'#renglonS" + numero + "'");
			var jqNumero1 = eval("'#consecutivo" + numero + "'");
			var jqConceptoInvIDRP1 = eval("'#conceptoInvIDRS" + numero + "'");		
			var jqDescripcion =eval("'#descripcionRS" + numero + "'");
			var jqNoUnidad =eval("'#noUnidadRS" + numero + "'");
			var jqClaveUnidad =eval("'#claveUnidadRS" + numero + "'");
			var jqUnidad =eval("'#unidadRS" + numero + "'");
			var jqMontoInversionRP =eval("'#montoInversionRS" + numero + "'");
			var jqTipoRecurso =eval("'#tipoRecursoRS" + numero + "'");

			var jqAgregar1=eval("'#agregarRS" + numero + "'");
			var jqEliminar1 = eval("'#eliminaRS" + numero + "'");
			
	
			$(jqNumero1).val(contador);
			
			$(jqRenglon1).attr('id','renglonS'+contador);
			$(jqNumero1).attr('id','consecutivo'+contador);
			$(jqConceptoInvIDRP1).attr('id','conceptoInvIDRS'+contador);
			$(jqDescripcion).attr('id','descripcionRS'+contador);
			$(jqNoUnidad).attr('id','noUnidadRS'+contador);
			$(jqClaveUnidad).attr('id','claveUnidadRS'+contador);
			$(jqUnidad).attr('id','unidadRS'+contador);
			$(jqMontoInversionRP).attr('id','montoInversionRS'+contador);
			$(jqTipoRecurso).attr('id','tipoRecursoRS'+contador);
			
			$(jqAgregar1).attr('id','agregarRS'+contador);		
			$(jqEliminar1).attr('id','eliminaRS'+contador);
	
	
			// reordenamiento indices
			$(jqRenglon1).attr('tabindex','renglonP'+contador);
			$(jqNumero1).attr('tabindex','consecutivo'+contador);
			$(jqConceptoInvIDRP1).attr('tabindex','conceptoInvIDRP'+contador);
			$(jqDescripcion).attr('tabindex','descripcionRP'+contador);
			$(jqNoUnidad).attr('tabindex','noUnidadRS'+contador);
			$(jqClaveUnidad).attr('tabindex','claveUnidadRS'+contador);
			$(jqUnidad).attr('tabindex','unidadRS'+contador);
			$(jqMontoInversionRP).attr('tabindex','montoInversionRS'+contador);
			
			$(jqAgregar1).attr('tabindex','agregarRS'+contador);		
			$(jqEliminar1).attr('tabindex','eliminaRS'+contador);
			
			contador = parseInt(contador + 1);	
			
		});
		
	}

	//guarda los datos como string
	function guardarDatosSolicita(){		
			
		var numCodigo = consultaFilaSolicita();
		$('#datosGridSol').val("");

		for(var i = 1; i <= numCodigo; i++){
	
			controlQuitaFormatoMoneda("montoInversionRS"+i+"");
			if(i == 1){
				
				$('#datosGridSol').val($('#datosGridSol').val() +
				document.getElementById("conceptoInvIDRS"+i+"").value + ']' +
			    document.getElementById("descripcionRS"+i+"").value + ']' +
			    document.getElementById("noUnidadRS"+i+"").value + ']' +
			    document.getElementById("claveUnidadRS"+i+"").value + ']' +
			    document.getElementById("unidadRS"+i+"").value + ']' +
			    document.getElementById("montoInversionRS"+i+"").value + ']' +
				document.getElementById("tipoRecursoRS"+i+"").value );	
			}else{
				$('#datosGridSol').val($('#datosGridSol').val() + '[' +
						document.getElementById("conceptoInvIDRS"+i+"").value + ']' +
						document.getElementById("descripcionRS"+i+"").value + ']' +
						document.getElementById("noUnidadRS"+i+"").value + ']' +
						document.getElementById("claveUnidadRS"+i+"").value + ']' +
						document.getElementById("unidadRS"+i+"").value + ']' +
						document.getElementById("montoInversionRS"+i+"").value + ']' +
						document.getElementById("tipoRecursoRS"+i+"").value);
				}	
		}
	}

	//valida campos vacios grid recursos del solicitante
	function validaVacioSol(){ 
		var numCodigo = consultaFilaSolicita();
		var error = 0;
		if(numCodigo==1){
			var jsConcepto    = document.getElementById("conceptoInvIDRS"+1+"").value;
			var jsMonto 	  = document.getElementById("montoInversionRS"+1+"").value;
			var jsDescripcion = document.getElementById("descripcionRS"+1+"").value;
			var jsNoUnidad = document.getElementById("noUnidadRS"+1+"").value;
			var jsClaveUnidad = document.getElementById("claveUnidadRS"+1+"").value;
			var jsUnidad = document.getElementById("unidadRS"+1+"").value;
			var jsMontoTotal  = $('#totalSolicitante').val();

			if(jsConcepto == '' && jsMonto == '' && jsDescripcion == '' && jsNoUnidad == ''&& jsClaveUnidad == ''&& jsUnidad == ''&& jsMontoTotal == 0.00){
				error = 2;
			}else if (jsConcepto == ''){
				 mensajeSis("Especificar Concepto de Inversión Fira.");
				 $('#conceptoInvIDRS'+1).focus();
				 error = 1;	 
			}else if (jsMonto == ''){
					 mensajeSis("Especificar el Monto del Concepto.");
					 $('#montoInversionRS'+1).focus();
					 error = 1;	 
			}
			else if (jsNoUnidad == ''){
				 mensajeSis("Especificar el No de Unidad de Inversión.");
				 $('#noUnidadRS'+1).focus();
				 error = 1;	 
			}else if (jsClaveUnidad == ''){
					 mensajeSis("Especificar el ID de la Unidad.");
					 $('#claveUnidadRS'+1).focus();
					 error = 1;	 
			}
			else if (jsUnidad == ''){
				 mensajeSis("Especificar la Unidad del Concepto.");
				 $('#unidadRS'+1).focus();
				 error = 1;	 
		}
			return error;

		}else{
			for(var i = 1; i <= numCodigo; i++){
				var jsConcepto = document.getElementById("conceptoInvIDRS"+i+"").value;
				var jsMonto = document.getElementById("montoInversionRS"+i+"").value;
				var jsNoUnidad = document.getElementById("noUnidadRS"+i+"").value;
				var jsClaveUnidad = document.getElementById("claveUnidadRS"+i+"").value;

				if (jsConcepto == ''){
					 mensajeSis("Especificar Concepto de Inversión Fira.");
					 $('#conceptoInvIDRS'+i).focus();
					 error = 1;	 
				}else if (jsMonto == ''){
					 mensajeSis("Especificar el Monto del Concepto.");
					 $('#montoInversionRS'+i).focus();
					 error = 1;	 
				}
				else if (jsNoUnidad == ''){
					 mensajeSis("Especificar el No de Unidad del Concepto.");
					 $('#noUnidadRS'+i).focus();
					 error = 1;	 
				}else if (jsClaveUnidad == ''){
					 mensajeSis("Especificar la Clave del Concepto.");
					 $('#claveUnidadRS'+i).focus();
					 error = 1;	 
				}
				return error;
			
			}

		}
		
		
	}

///Metodos del grid recursos de otras fuentes************************************************************
	//consulta cuantas filas tiene el grid
	function consultaFilaOF(){
		var totales=0;
		$('tr[name=renglonOF]').each(function() {
			totales++;		
		});
		return totales;
		
	}
	
	// suma monto de recursos prestamo
	function sumaMontoOtrasFuentes(){ 
		var numCodigo = consultaFilaOF();
		var cont = 0;
		var montoTotal = 0;
		for(var i = 1; i <= numCodigo; i++){
			var jsMonto = $('#'+"montoInversionROF"+i+"").asNumber();
				montoTotal = (montoTotal) + (jsMonto);
				cont ++;
				$('#totalotrasFuentes').val(montoTotal);	
				$('#totalotrasFuentes').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		
		}
		if(cont < 1){
			$('#totalotrasFuentes').val('0.00');
		}
		
	}


function consultaConceptoOF(idControl, numFila) {
	
	var jqConcepto = eval("'#" + idControl + "'");
	var numConcepto = $(jqConcepto).val();
	var numConsulta = 1;

	var conceptosInvBean = {
		'conceptoInvID' : numConcepto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numConcepto != '' && !isNaN(numConcepto) && numConcepto > 0) {
		conceptosInversionAgroServicio.consulta(conceptosInvBean, numConsulta, function(conceptosInv) {
			if (conceptosInv != null) {
				$('#descripcionOF' + numFila).val(conceptosInv.descripcion);
				$('#noUnidadOF' + numFila).focus();
			} else {

				mensajeSis("No Existe el Concepto De Inversión Fira");
				$('#conceptoInvIDROF' + numFila).focus();
				$('#conceptoInvIDROF' + numFila).val("");
				$('#descripcionOF' + numFila).val("");
			}
		});
	} else {
		$('#conceptoInvIDROF' + numFila).val("");
		$('#descripcionOF' + numFila).val("");

	}
}
	

	function consultaConceptoOFUnidad(input, numFila) {
		var unidad = $('#'+input).asNumber();
		var principal = 1;
		var bean = {
			'uniConceptoInvID' : unidad
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (unidad != 0 && esTab) {
			uniConceptosInvAgroServicio.consulta(principal,bean,{ callback:function(bean) {
				if (bean != null) {
					$('#unidadOF'+numFila).val(bean.unidad);
					$('#montoInversionROF'+numFila).focus();
				} else {
					mensajeSis("No Existe la Unidad De Inversión Fira");
					$('#claveUnidadOF'+numFila).focus();
					$('#claveUnidadOF'+numFila).val("");
					$('#unidadOF'+numFila).val("");
				}
			}
			});
		} else {
			$('#claveUnidadOF'+numFila).val("");
			$('#unidadOF'+numFila).val("");
		}
	
	}

	function validarSiNumeroOF(numero,numFila){
		  var er1_EntradaS = /^[0-9]*(\.[0-9]+)?$/
	        if(!er1_EntradaS.test(numero)) {
	      	  mensajeSis("Inserte un valor numerico correcto en No Unidades.");
	      	  $('#noUnidadOF'+numFila).focus();
	      	  $('#noUnidadOF'+numFila).val("");
	      	  
	        return false;
	        }
		}

	// Funcion para agregar nuevas Filas en el grid
	function agregaNuevoDetalleOF(){
		var numeroFila = consultaFilaOF();
		var nuevaFila = parseInt(numeroFila) + 1;		

		var td = '<tr id="renglonOF' + nuevaFila + '" name="renglonOF">';

		td+='<td nowrap="nowrap">';
		td+= '<input type="hidden" id="consecutivo'+nuevaFila+'" name="consecutivo" size="4"  value="'+nuevaFila+'" />';
		td+='<input type="text" id="conceptoInvIDROF'+nuevaFila+'"  name="conceptoInvIDROF" path="conceptoInvIDROF" onkeyup="muestraLista(this.id)" onblur="consultaConceptoOF(this.id,'+nuevaFila+');" size="12" autocomplete="off" />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="descripcionOF'+nuevaFila+'"  path="descripcionOF" name="descripcionOF" size="53"  readonly="true"  />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="noUnidadOF'+nuevaFila+'"  path="noUnidadOF" name="noUnidadOF" size="20" onChange="validarSiNumeroOF(this.value,'+nuevaFila+');"/>';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="claveUnidadOF'+nuevaFila+'"  name="claveUnidadOF" path="claveUnidadOF" onkeyup="muestraListaUnidad(this.id)" onblur="consultaConceptoOFUnidad(this.id,'+nuevaFila+');" size="6" autocomplete="off" />';
		td+='<input type="text" id="unidadOF'+nuevaFila+'"  path="unidadOF" name="unidadOF" size="30"  readonly="true"  />';
		td+='</td>';
		td+='<td>';
		td+='<input type="text" id="montoInversionROF'+nuevaFila+'" style="text-align:right;" size="20" name="montoInversionROF" esMoneda="true" path="montoInversionROF" onblur="sumaMontoOtrasFuentes();" />';
		td+='</td>';
		td+='<td align="center" nowrap="nowrap"><input type="button" name="elimina" id="eliminaOF'+nuevaFila +'" class="btnElimina" onclick="eliminaDetalleOF(this);sumaMontoOtrasFuentes()" />';
		td+='</td>';
		td+='<td>';
		td+='<input type="button" name="agrega" id="agregarOF'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoDetalleOF();"/>';
		td+='</td>';
		td+='<td nowrap="nowrap">';
		td+='<input type="hidden" id="tipoRecursoOF'+nuevaFila+'"  name="tipoRecursoOF" path="tipoRecursoOF" value="OF"/>';
		td+='</td>';
		td+='</tr>';

		//document.getElementById("numeroDetalle").value = nuevaFila;    	
		$("#miTablaOF").append(td);
		$('#conceptoInvIDROF'+nuevaFila).focus();
		agregaFormatoControles('formaGenerica');
		$('#montoInversionROF'+nuevaFila).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#montoInversionROF').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});


	} 
	// Funcion para eliminar Filas en el grid	
	function eliminaDetalleOF(control){
		var numeroID= control.id;
		numeroID= numeroID.substr(9,numeroID.length);
		var jqRenglon = eval("'#renglonOF" + numeroID + "'");
		var jqNumero = eval("'#consecutivo" + numeroID + "'");
		var jqConceptoInvIDRP = eval("'#conceptoInvIDROF" + numeroID + "'");		
		var jqDescripcion =eval("'#descripcionOF" + numeroID + "'");
		var jqNoUnidad =eval("'#noUnidadOF" + numeroID + "'");
		var jqClaveUnidad =eval("'#claveUnidadOF" + numeroID + "'");
		var jqUnidad =eval("'#unidadOF" + numeroID + "'");
		var jqMontoInversionRP = eval("'#montoInversionROF" + numeroID + "'");
		var jqTipoRecurso = eval("'#tipoRecursoOF" + numeroID + "'");		
		var jqAgregar=eval("'#agregarOF" + numeroID + "'");
		var jqEliminar = eval("'#eliminaOF" + numeroID + "'");
	
		// se elimina la fila seleccionada
		$(jqRenglon).remove();
		$(jqNumero).remove();
		$(jqConceptoInvIDRP).remove();
		$(jqDescripcion).remove();
		$(jqNoUnidad).remove();
		$(jqClaveUnidad).remove();
		$(jqUnidad).remove();
		$(jqMontoInversionRP).remove();
		$(jqTipoRecurso).remove();
	
		$(jqAgregar).remove();
		$(jqEliminar).remove();
		asignaIDOF();
		// para el primer elemento
		var numFilas = consultaFilaOF();

		if(numFilas==0){
			agregaNuevoDetalleOF();
		}
	}

	function asignaIDOF(){
		var contador = 1 ;
		var numero= 0;
		$('tr[name=renglonOF]').each(function() {
			numero= this.id.substr(9,this.id.length);
			var jqRenglon1 = eval("'#renglonOF" + numero + "'");
			var jqNumero1 = eval("'#consecutivo" + numero + "'");
			var jqConceptoInvIDRP1 = eval("'#conceptoInvIDROF" + numero + "'");		
			var jqDescripcion =eval("'#descripcionOF" + numero + "'");
			var jqNoUnidad =eval("'#noUnidadOF" + numero + "'");
			var jqClaveUnidad =eval("'#claveUnidadOF" + numero + "'");
			var jqUnidad =eval("'#unidadOF" + numero + "'");
			var jqMontoInversionRP =eval("'#montoInversionROF" + numero + "'");
			var jqTipoRecurso =eval("'#tipoRecursoOF" + numero + "'");

			var jqAgregar1=eval("'#agregarOF" + numero + "'");
			var jqEliminar1 = eval("'#eliminaOF" + numero + "'");
			
	
			$(jqNumero1).val(contador);
			
			$(jqRenglon1).attr('id','renglonOF'+contador);
			$(jqNumero1).attr('id','consecutivo'+contador);
			$(jqConceptoInvIDRP1).attr('id','conceptoInvIDROF'+contador);
			$(jqDescripcion).attr('id','descripcionOF'+contador);
			$(jqNoUnidad).attr('id','noUnidadOF'+contador);
			$(jqClaveUnidad).attr('id','claveUnidadOF'+contador);
			$(jqUnidad).attr('id','unidadOF'+contador);
			$(jqMontoInversionRP).attr('id','montoInversionROF'+contador);
			$(jqTipoRecurso).attr('id','tipoRecursoOF'+contador);
			
			$(jqAgregar1).attr('id','agregarOF'+contador);		
			$(jqEliminar1).attr('id','eliminaOF'+contador);
	
	
			// reordenamiento indices
			$(jqRenglon1).attr('tabindex','renglonP'+contador);
			$(jqNumero1).attr('tabindex','consecutivo'+contador);
			$(jqConceptoInvIDRP1).attr('tabindex','conceptoInvIDROF'+contador);
			$(jqDescripcion).attr('tabindex','descripcionOF'+contador);
			$(jqNoUnidad).attr('tabindex','noUnidadOF'+contador);
			$(jqClaveUnidad).attr('tabindex','claveUnidadOF'+contador);
			$(jqUnidad).attr('tabindex','unidadOF'+contador);
			$(jqMontoInversionRP).attr('tabindex','montoInversionROF'+contador);
			
			$(jqAgregar1).attr('tabindex','agregarOF'+contador);		
			$(jqEliminar1).attr('tabindex','eliminaOF'+contador);
			
			contador = parseInt(contador + 1);	
			
		});
		
	}

	//guarda los datos como string
	function guardarDatosOtrasF(){		
			
		var numCodigo = consultaFilaOF();
		$('#datosGridOF').val("");

		for(var i = 1; i <= numCodigo; i++){
	
			controlQuitaFormatoMoneda("montoInversionROF"+i+"");
			if(i == 1){
				
				$('#datosGridOF').val($('#datosGridOF').val() +
				document.getElementById("conceptoInvIDROF"+i+"").value + ']' +
			    document.getElementById("descripcionOF"+i+"").value + ']' +
			    document.getElementById("noUnidadOF"+i+"").value + ']' +
			    document.getElementById("claveUnidadOF"+i+"").value + ']' +
			    document.getElementById("unidadOF"+i+"").value + ']' +
			    document.getElementById("montoInversionROF"+i+"").value + ']' +
				document.getElementById("tipoRecursoOF"+i+"").value );	
			}else{
				$('#datosGridOF').val($('#datosGridOF').val() + '[' +
						document.getElementById("conceptoInvIDROF"+i+"").value + ']' +
						document.getElementById("descripcionOF"+i+"").value + ']' +
						document.getElementById("noUnidadOF"+i+"").value + ']' +
						document.getElementById("claveUnidadOF"+i+"").value + ']' +
						document.getElementById("unidadOF"+i+"").value + ']' +
						document.getElementById("montoInversionROF"+i+"").value + ']' +
						document.getElementById("tipoRecursoOF"+i+"").value);
				}	
		}
	}

	//valida campos vacios grid recursos de otras fuentes
	function validaVacioOtrasF(){ 
		var numCodigo = consultaFilaOF();
		var error = 0;
		if(numCodigo==1){
			var jsConcepto    = document.getElementById("conceptoInvIDROF"+1+"").value;
			var jsMonto 	  = document.getElementById("montoInversionROF"+1+"").value;
			var jsDescripcion = document.getElementById("descripcionOF"+1+"").value;
			var jsNoUnidad = document.getElementById("noUnidadOF"+1+"").value;
			var jsClaveUnidad = document.getElementById("claveUnidadOF"+1+"").value;
			var jsUnidad = document.getElementById("unidadOF"+1+"").value;
			var jsMontoTotal  = $('#totalotrasFuentes').val();

			if(jsConcepto == '' && jsMonto == '' && jsDescripcion == ''  && jsNoUnidad == '' && jsClaveUnidad == '' && jsUnidad == ''&& jsMontoTotal == 0.00){
				error = 2;
			}else if (jsConcepto == ''){
				 mensajeSis("Especificar Concepto de Inversión Fira.");
				 $('#conceptoInvIDROF'+1).focus();
				 error = 1;	 
			}else if (jsMonto == ''){
					 mensajeSis("Especificar el Monto del Concepto.");
					 $('#montoInversionROF'+1).focus();
					 error = 1;	 
			}
			else if (jsNoUnidad == ''){
				 mensajeSis("Especificar el No de Unidad de Inversión.");
				 $('#noUnidadOF'+1).focus();
				 error = 1;	 
			}else if (jsClaveUnidad == ''){
					 mensajeSis("Especificar el Concepto de Unidad.");
					 $('#claveUnidadOF'+1).focus();
					 error = 1;	 
			}
			return error;

		}else{
			for(var i = 1; i <= numCodigo; i++){
				var jsConcepto = document.getElementById("conceptoInvIDROF"+i+"").value;
				var jsMonto = document.getElementById("montoInversionROF"+i+"").value;
				var jsNoUnidad = document.getElementById("noUnidadOF"+i+"").value;
				var jsClaveUnidad = document.getElementById("claveUnidadOF"+i+"").value;
				if (jsConcepto == ''){
					 mensajeSis("Especificar Concepto de Inversión Fira.");
					 $('#conceptoInvIDROF'+i).focus();
					 error = 1;	 
				}else if (jsMonto == ''){
					 mensajeSis("Especificar el Monto del Concepto.");
					 $('#montoInversionROF'+i).focus();
					 error = 1;	 
				}else if (jsNoUnidad == ''){
					 mensajeSis("Especificar el No de Unidad de Inversión.");
					 $('#noUnidadOF'+i).focus();
					 error = 1;	 
				}else if (jsClaveUnidad == ''){
					 mensajeSis("Especificar el Concepto de Unidad.");
					 $('#claveUnidadOF'+i).focus();
					 error = 1;	 
				}
				return error;
			
			}

		}
		
		
	}
	// valida montos totales vs monto de la solicitud
	function validaTotales(){ 
		var montoTotal = 0;
		var montoSol = 0;
		var montoPrestamo 		= $('#totalRecursoPrestamo').asNumber();
		var montoSolicitudCred 	= $('#montoSolicitud').asNumber();
		montoTotal = parseInt(montoPrestamo);
		montoSol = parseInt(montoSolicitudCred);
		if(montoTotal!= montoSol){
			mensajeSis("La Suma de los Recursos del Préstamo no Coincide con el  Monto de la Solicitud de Crédito.");
			$('#solicitudCreditoID').focus();
		}
	}

	//limpia pantalla
	function limpiarPantalla(){
		$('#clienteID').val('');
		$('#nombreCliente').val('');
		$('#montoSolicitud').val('');
		$('#fechaRegistro').val('');
		$('#solicitudCreditoID').focus();
		$('#gridRecPrestamo').html("");
		$('#gridRecPrestamo').hide();
		$('#gridRecSolicitante').show();
		$('#gridRecSolicitante').html("");
		$('#gridRecOtrasFuentes').show();
		$('#gridRecOtrasFuentes').html("");

	}
	
	//Funcion de exito al realizar una transaccion
	function exito(){
		var jQmensaje = eval("'#ligaCerrar'");
		if($(jQmensaje).length > 0) { 
		mensajeAlert=setInterval(function() { 
			if($(jQmensaje).is(':hidden')) { 	
				clearInterval(mensajeAlert); 
				limpiarPantalla();
				$('#divRecursosPrestamo').hide();
				$('#divRecursosSolicitante').hide();
				$('#divRecursosOtrasFuentes').hide();
					
			}
	        }, 50);
		}
		
	}
	//Funcion de error al realizar una trasaccion
	
	function fallo(){	
	}