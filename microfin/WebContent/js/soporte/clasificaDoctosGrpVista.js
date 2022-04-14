	$(document).ready(function() {
		consultaGridGrupos();
		$("#grupoDocumentoID").focus();
		deshabilitaBoton('modifica','submit');
		deshabilitaBoton('agrega','submit');
		deshabilitaBoton('elimina','submit');
		esTab = true;
		deshabilitaBoton('agrega', 'submit');
		//Definicion de Constantes y Enums  
		var catTipoTransaccionGrupo = {
				'agrega':'1',
			  	'modifica':'2',
			  	'agregaDoc':'3',
			  	'elimina':'4'
			  		
		};
					
		var catConsultaGrupo = {
				'principal':1
		};	
			
			
		//------------ Metodos y Manejo de Eventos -----------------------------------------
			$(':text').focus(function() {	
			 	esTab = false;
			});	
			
			$.validator.setDefaults({
				submitHandler: function(event) { 
				  var valida =validaOperacion();
				   if(valida==0){
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','grupoDocumentoID','Exito','Error'); 
				   }else{
					   mensajeSis("El Grupo de Documento se encuentra en uso no puede Eliminarse");
					   $('#grupoDocumentoID').focus();
				   }
				}
		    });			
				    
			$(':text').bind('keydown',function(e){
				if (e.which == 9 && !e.shiftKey){
					esTab= true;
				}
			});
			
			$('#agrega').click(function() {		
				$('#tipoTransaccion').val(catTipoTransaccionGrupo.agrega);
			});
			
			$('#agregaDoc').click(function() {		
				$('#tipoTransaccion').val(catTipoTransaccionGrupo.agregaDoc);
				guardarGriTipos();
				if($('#datosTipoDoc').val()==""&& $('#datosGridBaja').val()==""){
					mensajeSis("No Existen Datos para Capturar");
					event.preventDefault();
				}
			});
			
			$('#modifica').click(function() {		
			
				$('#tipoTransaccion').val(catTipoTransaccionGrupo.modifica);
			});
		
			$('#elimina').click(function() {	
				
				$('#tipoTransaccion').val(catTipoTransaccionGrupo.elimina);
			});
			
			$('#grupoDocumentoID').blur(function() {
				$("#requeridoEn option").removeAttr("selected");
				$("#tipoPersona option").removeAttr("selected");
				if(	$('#grupoDocumentoID').asNumber()>0){
					consultaGrupoDocumento(this);
					consultaGridGrupos();
				}else if ($('#grupoDocumentoID').val()=="0") {
					//$('#grupoDocumentoID').val('0');
					habilitaBoton('agrega','submit');
					deshabilitaBoton('modifica','submit');
					deshabilitaBoton('elimina','submit');
					$('#descripcion').val('');
					//inicializaForma('formaGenerica','grupoDocumentoID');
				}else{
					deshabilitaBoton('agrega','submit');
					deshabilitaBoton('modifica','submit');
					deshabilitaBoton('elimina','submit');
				}
				
			});
		
			$('#grupoDocumentoID').bind('keyup',function(e){
				//TODO Agregar Libreria de Constantes Tipo Enum
				lista('grupoDocumentoID', '2', '2', 'grupoDocumentoID', $('#grupoDocumentoID').val(), 'listaGrupoDocumentos.htm');
			});
		
				
			//----------- Validaciones de la Forma -------------------------------------
			
			$('#formaGenerica').validate({
				rules: {
					requeridoEn: {
						required: function() {return $('#tipoTransaccion').val() !=3;}

					},
					tipoPersona: {
						required: function() {return $('#tipoTransaccion').val() !=3;}
					}
				},
				messages: {		
					requeridoEn: {
						required: 'Especifique en que Proceso es Requerido'
					},
					tipoPersona: {
						required: 'Especifique Tipo de Persona'
					},
					
				}		
			});
			
			//------------ Validaciones de Controles ----------
		//Consulta y valida el tipo de documento	
			function consultaGrupoDocumento(control) {
				var numgrupoDoc = $('#grupoDocumentoID').val();
				var bean ={
					'grupoDocumentoID':numgrupoDoc
				};
			
					setTimeout("$('#cajaLista').hide();", 200);
					if(numgrupoDoc != '' && !isNaN(numgrupoDoc)){
						habilitaBoton('agrega', 'submit');
						grupoDocumentosServicio.consulta(catConsultaGrupo.principal,bean, function(grupo) { 
							if(grupo!=null){
								$('#descripcion').val(grupo.descripcion);
								consultaRequeridos(grupo.requeridoEn);
								consultaPersona(grupo.tipoPersona);
								deshabilitaBoton('agrega', 'submit');
								habilitaBoton('modifica', 'submit');
								habilitaBoton('elimina', 'submit');
								$('#documentosPorGrupo').html("");
								$('#documentosPorGrupo').hide();	
								$('#fieldsetDoc').hide();		
								$('#datosTipoDoc').val("");
								$('#datosGridBaja').val("");
								$('#agregaDoc').hide();
								$('#enUso').val(grupo.enUso);
								
							}else{
								//inicializaForma('formaGenerica','grupoDocumentoID');
								mensajeSis("El Grupo de Documento no Existe");
								$('#grupoDocumentoID').val("");
								$("#requeridoEn option").removeAttr("selected");
								$('#grupoDocumentoID').focus();
								$('#descripcion').val('');
								$("#tipoPersona option").removeAttr("selected");
								deshabilitaBoton('agrega', 'submit');
								deshabilitaBoton('modifica', 'submit');
								deshabilitaBoton('elimina', 'submit');
								$('#documentosPorGrupo').html("");
								$('#documentosPorGrupo').hide();	
								$('#fieldsetDoc').hide();	
								$('#enUso').val("");
							}
						});
					}
			}
			
			//funcion identifica en que procesos es requerido el documento
			function consultaRequeridos(requerido) {
				var req= requerido.split(',');
				var tamanio = req.length;
				for (var i=0;i< tamanio;i++) {
					var re = req[i];
					var jqRequerido = eval("'#requeridoEn option[value="+re+"]'");  
					$(jqRequerido).attr("selected","selected");	  
				}
			}
			
			//funcion identifica que tipos de personas son aptos para el grupo de documentos
			function consultaPersona(tipo) {
				var tipoP= tipo.split(',');
				var tamanio = tipoP.length;
				for (var i=0;i< tamanio;i++) {
					var tipoPer = tipoP[i];
					var jqTipoPersona = eval("'#tipoPersona option[value="+tipoPer+"]'");  
					$(jqTipoPersona).attr("selected","selected");	  
				}
			}
			
			function validaOperacion(){
				if ($('#tipoTransaccion').val()==catTipoTransaccionGrupo.elimina){
					if($('#enUso').val()=="S" ){
						retorno=1;					
					}else{
						retorno=0;
					}
				}else{
					retorno =0;
				}
				return retorno;
			}
				
		});//fin Document
		
		//grid de documentos entregados
		function consultaGridGrupos(){		
			$('#gruposExistentes').val('');
			var params = {};	
			params['tipoLista'] = 3;	
			params['instrumento'] = 0;	
			params['tipoInstrumento'] =0;		
			
			$.post("grupoDoctosGridVista.htm", params, function(data){
				if(data.length >0) {	
					$('#gruposExistentes').html(data);
					$('#gruposExistentes').show();	
					$('#fieldsetDocEnt').show();
					var numFilas=consultaFilas();		
					if(numFilas == 0 ){
						$('#gruposExistentes').html("");
						$('#gruposExistentes').hide();	
						$('#fieldsetDocEnt').hide();
						deshabilitaBoton('grabar', 'submit');
					}
				}else{				
					$('#gruposExistentes').html("");
					$('#gruposExistentes').hide();
					$('#fieldsetDocEnt').hide();			
				}
			});
		}
		
		//grid tipo de documentos por grupo
		function consultaGridTiposDoctos(grupo){		
			$('#documentosPorGrupo').val('');
			var params = {};
			params['tipoLista'] = 2;	
			params['grupoDocumentoID'] = grupo;	
			
			$.post("doctosPorGrupoGridVista.htm", params, function(data){
				if(data.length >0) {	
					$('#documentosPorGrupo').html(data);
					$('#documentosPorGrupo').show();	
					$('#fieldsetDoc').show();
					$('#agregaDoc').show();
					var numFilas=consultaFilasDoc();	
					$("#numeroTipos").val(numFilas);
					if(numFilas == 0 ){
						$('#numeroTipos').val(0);
						$('#documentosPorGrupo').show();	
						$('#fieldsetDoc').show();
						deshabilitaBoton('agregaDoc', 'submit');
					}else{
						habilitaBoton('agregaDoc', 'submit');
					}
				}else{	
					$('#documentosPorGrupo').html("");
					$('#documentosPorGrupo').hide();
					$('#fieldsetDoc').hide();			
				}
			});
		}
		
		//Consulta los tipod de documentos que tiene el Seleccionado 
		function consultaSeleccion(control){	
				if($('#'+control).attr('checked')==true){
					var lenght=control.length;
					var numero= control.substr(14,lenght);
					var grupo=eval("'grupoID" + numero+ "'");	
					consultaGridTiposDoctos($("#"+grupo).val());
					$('#numeroGrupo').val($("#"+grupo).val());
				}			
		}
		
		
		 // Consulta el número de filas del grid de Grupo de Documentos
	  function consultaFilas(){
			var totales=0;
			$('tr[name=renglons]').each(function() {
				totales++;
				
			});
			return totales;
		}
	  // Consulta el número de filas del grid de tipos de documentos por grupo
	  function consultaFilasDoc(){
			var totales=0;
			$('tr[name=renglones]').each(function() {
				totales++;
				
			});
			return totales;
		}
	  
	  //Funcion de Exito 
	  function Exito() {
			inicializaForma('formaGenerica','grupoDocumentoID');
			$("#requeridoEn option").removeAttr("selected");
			$("#tipoPersona option").removeAttr("selected");
			consultaGridGrupos();	
			//if ($('#tipoTransaccion').val()!=3){
				$('#documentosPorGrupo').html("");
				$('#documentosPorGrupo').hide();	
				$('#fieldsetDoc').hide();		
				$('#agregaDoc').hide();
			//}
			$('#datosTipoDoc').val("");
			$('#datosGridBaja').val("");
			
			deshabilitaBoton('modifica','submit');
			deshabilitaBoton('agrega','submit');
			deshabilitaBoton('elimina','submit');
			$('#enUso').val("");
			
		}
	//Funcion de Error 	
	function Error() {
		}
		
	//Funcion para agregar nuevo detalle al grid de Tipos de Documentos por grupo	
	function agregaNuevoDetalle(){
			habilitaBoton('agregaDoc', 'submit');
			var numeroFila = ($('#miTablaGrid >tbody >tr').length ) -1 ;
			var nuevaFila = parseInt(numeroFila) + 1;	
			var  td= '<tr id="renglones' + nuevaFila + '" name="renglones">';
			
			if(nuevaFila == 0){
				td += '<td><input type="hidden" id="consecutivoGrupo'+nuevaFila+'" readOnly="true" name="consecutivoGrupo" size="6" value="1"  />';
				td += '<input  type="text" id="tipoDocumentoID'+nuevaFila+'" name="tipoDocumentoID" size="6" value="" onkeypress="listaDescripcion(this.id)" onblur="consultaDescripcion(this.id)" />';
				td += '</td>';   
				td += '<td>';
				td += '<input type="text" id="descripcionTipo'+nuevaFila+'"  name="descripcionTipo" value="" size="80" readOnly="true" /></td>';
				
			}else{
				var valor =numeroFila+1;
				td += '<td><input type="hidden" id="consecutivoGrupo'+nuevaFila+'" readOnly="true" name="consecutivoGrupo" size="6" value="'+valor+'"autocomplete="off"   />';
				td += '<input  type="text" id="tipoDocumentoID'+nuevaFila+'" name="tipoDocumentoID" size="6" value="" onkeypress="listaDescripcion(this.id)" onblur="consultaDescripcion(this.id)"/>';
				td += '</td>';   
				td += '<td nowrap="nowrap">';
				td += '<input type="text" id="descripcionTipo'+nuevaFila+'"  name="descripcionTipo" value=""  size="80" readOnly="true"  /></td>';
			}
			
			td += '<td align="center" nowrap="nowrap">';
			td += '<input type="button" name="elimina" id="'+nuevaFila +'" class="btnElimina" onclick="eliminaDetalle(this.id)"/>';
			td += '<input type="button" name="agregafila" id="agregafila'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoDetalle()"/>';
			td += '</td>';
			td += '</tr>';    	
			$("#miTablaGrid").append(td);
			$('#tipoDocumentoID'+nuevaFila).focus();
			agregaFormatoControles('formaGenerica');
			return false;	
		} 
	//Funcion para eliminar detalles o renglones en grid de Tipos de Documentos por Grupo 	
	function eliminaDetalle(control){
			var contador = 0 ;
			var numeroID = control;
		
			var datosBaja=$('#datosGridBaja').val();	
			var valorDatos=document.getElementById("tipoDocumentoID"+numeroID+"").value;
			if(valorDatos!=0){	
				if(datosBaja =='' ){						
					$('#datosGridBaja').val($('#datosGridBaja').val() +
					document.getElementById("tipoDocumentoID"+numeroID+"").value + ']' +
					document.getElementById("descripcionTipo"+numeroID+"").value + ']' +
					document.getElementById("numeroGrupo").value);
				}else{
					$('#datosGridBaja').val($('#datosGridBaja').val() + '[' +
					document.getElementById("tipoDocumentoID"+numeroID+"").value + ']' +
					document.getElementById("descripcionTipo"+numeroID+"").value + ']' +
					document.getElementById("numeroGrupo").value);
				}	
			}
					
			
			var jqTr = eval("'#renglones" + numeroID + "'");
			var jqConsecutivoID = eval("'#consecutivoGrupo" + numeroID + "'");	
			var jqDescripcion = eval("'#descripcionTipo" + numeroID + "'");
			var jqElimina = eval("'#" + numeroID + "'");
			var jqAgrega = eval("'#agregafila" + numeroID + "'");
			var tipoDoc =eval("'#tipoDocumentoID"+numeroID+"'");
	
			//Se eliminan los inputs
			$(jqConsecutivoID).remove();
			$(jqDescripcion).remove();		
			$(jqElimina).remove();
			$(jqAgrega).remove();
			$(jqTr).remove();
			$(tipoDoc).remove();
			
			contador = 1;
			var numero= 0;
			$('tr[name=renglones]').each(function() {		
				numero= this.id.substr(9,this.id.length);
				var jqRenglon1 = eval("'#renglones"+numero+"'");
				var jqNumero1 = eval("'#consecutivoGrupo"+numero+"'");
				var jqDescripcion1 = eval("'#descripcionTipo"+numero+"'");		
				var jqTipoDoc1= eval("'#tipoDocumentoID"+numero+"'");
				var jqAgrega1=eval("'#agregafila"+ numero+"'");
				var jqElimina1 = eval("'#"+numero+ "'");
			
				$(jqNumero1).attr('id','consecutivoGrupo'+contador);
				$(jqTipoDoc1).attr('id','tipoDocumentoID'+contador);
				$(jqDescripcion1).attr('id','descripcionTipo'+contador);
				$(jqAgrega1).attr('id','agregafila'+contador);
				$(jqElimina1).attr('id',contador);
				$(jqRenglon1).attr('id','renglones'+ contador);
				contador = parseInt(contador + 1);			
			});
		};
		
		//Funcion para enlistar los tipos de Documentos existentes en el sistema
		function listaDescripcion(idControl){
			var jq = eval("'#" + idControl + "'");
			$(jq).bind('keyup',function(e){
				var jqControl = eval("'#" + this.id + "'");
				var num = $(jqControl).val();
					
				var camposLista = new Array();
				var tiposDocumentosLista = new Array();			
				camposLista[0] = "descripcion"; 
				tiposDocumentosLista[0] = num;
				lista(idControl, '2', '3', camposLista, tiposDocumentosLista, 'ListaTiposDocumentos.htm');
			});
		}

		//consulta la descripcion del Tipo de Documento elegido en grid de Tipo de Documentos por Grupo
		function consultaDescripcion(control){
			setTimeout("$('#cajaLista').hide();", 200);
			var jq = eval("'#" + control + "'");
			var numero= control.substr(15,control.length);
			var descrip=eval("'#descripcionTipo" +numero + "'");
			var num = $(jq).val();
		
			var bean={
					'tipoDocumentoID':num
			};
			var tipoConsulta=3;
			if(num != '' && !isNaN(num)){
					tiposDocumentosServicio.consulta(tipoConsulta,bean, function(descripcion) { 
					if(descripcion!=null){
						if (descripcion.estatus=="I"){
							mensajeSis("El Tipo de Documento se Encuentra Inactivo");
							$(jq).focus();
							$(jq).val('');
						}else{
						$(descrip).val(descripcion.descripcion);			
						}
					}else{
						mensajeSis("No existe el Tipo de Documento");
						$(jq).val("");
						$(jq).focus();
						$(descrip).val("");
					}
				});
			}
		}
				
		//se construye la cadena de datos del grid a guargar esto para Altas 
		function guardarGriTipos(){		
			var mandar = verificarVacios();
			var numDoc = consultaFilasDoc();		
			$('#documentosPorGrupo').val("");
			if(mandar!=1){   		  		
				$('tr[name=renglones]').each(function() {
					var numero= this.id.substr(9,this.id.length);
					var tiposDoc= eval("'#tipoDocumentoID" + numero + "'");   
					var descTipo= eval("'#descripcionTipo" + numero + "'");   
					if (numDoc==1){
						$('#datosTipoDoc').val($('#datosTipoDoc').val() +
						$(tiposDoc).val() + ']' + $(descTipo).val()+ ']' +
						document.getElementById("numeroGrupo").value);
					}else{
						$('#datosTipoDoc').val($('#datosTipoDoc').val() + '['+
						$(tiposDoc).val() + ']' + $(descTipo).val()+ ']' +
						document.getElementById("numeroGrupo").value);
					}			
				});
			}else{
				mensajeSis("Faltan Datos");
				event.preventDefault();
			}
		}
		
		//verificamos que no existan campos vacios en el grid de Tipos de documentos
		function verificarVacios(){	
			quitaFormatoControles('documentosPorGrupo');
			var numDoc = consultaFilasDoc();		 
			$('#documentosPorGrupo').val("");
			for(var i = 1; i <= numDoc; i++){
				var idTipoDoc = document.getElementById("tipoDocumentoID"+i+"").value;
				if (idTipoDoc ==""){ 				
					document.getElementById("tipoDocumentoID"+i+"").focus();
					$(idTipoDoc).addClass("error");
					return 1; 
				} 					
				var idDescTipo = document.getElementById("descripcionTipo"+i+"").value;
				if (idDescTipo ==""){ 				
					document.getElementById("descripcionTipo"+i+"").focus();
	 				$(idDescTipo).addClass("error");
		 					return 1; 
				}
					
			}
		}