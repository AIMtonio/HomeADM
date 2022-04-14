$(document).ready(function() {
	
	//Definicion de Constantes y Enums  	
	var catTipoTranClasificacion = {
  		'alta'		:1,
  		'modifica'	:2,
  		'elimina'	:3
  		
  		};
	var catTipoBajaClasificacion = {
  		'principal'	:1	  		
  		};

	var catTipoConClasificacion = {
  		'principal':1
  		};	
	
	var ClasTipoDoc = '';

	//------------ Metodos y Manejo de Eventos -----------------------------------------
   deshabilitaBoton('guardar', 'submit');
   deshabilitaBoton('modificar', 'submit');
   deshabilitaBoton('eliminar', 'submit');
   
	agregaFormatoControles('formaGenerica');

	
	$.validator.setDefaults({
      submitHandler: function(event) { 
   	   grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clasificaTipDocID','exitoPantallaClasificacion','falloPantallaClasificacion');
           
      }
   });					
		
	consultaClasificacionesGrid();
	
	$('#guardar').click(function() {	
		$('#tipoTransaccion').val(catTipoTranClasificacion.alta);
		limpiaGridClas();
	});	
	
	$('#modificar').click(function() {		
		$('#tipoTransaccion').val(catTipoTranClasificacion.modifica);
		limpiaGridClas();
	});
	
	$('#eliminar').click(function() {
		$('#tipoTransaccion').val(catTipoTranClasificacion.elimina);
		$('#tipoBaja').val(catTipoBajaClasificacion.principal);
		limpiaGridClas();
	});
	
	
	$('#clasificaTipDocID').blur(function() {
		limpiaGridClas();
		validaClasificacion(this.id);
	});
	
	
	 $('#clasificaTipDocID').bind('keyup',function(e){
		 if(this.value.length >= 2){ 
			var camposLista = new Array(); 
		    var parametrosLista = new Array(); 
	    	camposLista[0] = "clasificaDesc";
	    	parametrosLista[0] = $('#clasificaTipDocID').val();
	    	listaAlfanumerica('clasificaTipDocID', '2', '1', camposLista, parametrosLista, 'clasificaDocumentosListaVista.htm'); 
		 }
		
	 });
	 
	 //click en Mesa
	 $('#clasificaTipo1').click(function() {
		$('#filsetMesa').show(500);
	 });
	 //click en SOLICITUD
	 $('#clasificaTipo2').click(function() {
		$('#filsetMesa').hide(500);
		$('#grupoAplica').val('0');	
		$('#esGarantia2').attr("checked",true);
		$('#tipoGrupInd3').attr("checked",true);
		
	 });
	//click en Ambos
	 $('#clasificaTipo3').click(function() {
		$('#filsetMesa').show(500);		
	 });
	 	
 	//clic en individual
 	$('#tipoGrupInd1').click(function() {
		$('#labelIntegrante').hide(500);
		$('#grupoAplica').hide(500);	
		$('#grupoAplica').val('0');		
	});
 	// clic en  grupal
 	 $('#tipoGrupInd2').click(function() {
 		$('#labelIntegrante').show(500);
 		$('#grupoAplica').show(500); 																
 	});
 	//clic en Ambos
  	$('#tipoGrupInd3').click(function() {
 		$('#labelIntegrante').show(500);
 		$('#grupoAplica').show(500);														 			
 	});
  	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clasificaTipDocID:'required',
			clasificaDesc	 :'required',
			clasificaTipo	 :'required',
			tipoGrupInd		 :'required',
			grupoAplica		 :'required',
			esGarantia		 :'required'
		},
		
		messages: {
			clasificaTipDocID	:'Especifique el número de Tipo de Documento',
				clasificaDesc	:'Especifique la Descripción',
			   clasificaTipo 	:'Especifique',
			   tipoGrupInd		:'Especifique',
			   grupoAplica		:'required',
			   esGarantia		:'Especifique'
			   
		}		
		
	});

	$('#clasificaTipDocID').focus();
	//------------ Validaciones de Controles -------------------------------------
	function validaClasificacion(idControl){
		
		var solicitud	='S';
		var mesa		='M';
		var individual	='I';
		var grupal		='G';
		var no 			='N';
				
		var jqClasificacionID  = eval("'#" + idControl + "'");
		var valorClasificacionID = $(jqClasificacionID).val();	 
		
	
		setTimeout("$('#cajaLista').hide();", 200);
		if(valorClasificacionID != '' && !isNaN(valorClasificacionID)){
			if(valorClasificacionID==0){
				$('#clasificaDesc').val('');
				 habilitaBoton('guardar', 'submit');
				 deshabilitaBoton('modificar', 'submit');
				 deshabilitaBoton('eliminar', 'submit');
					
				
			}else{
				var clasificaDocBen = { 
						'clasificaTipDocID':valorClasificacionID
					};						
				clasificaTipDocServicio.consulta(catTipoConClasificacion.principal,clasificaDocBen,function(data) {
					if(data!=null){
						dwr.util.setValues(data);	
					
						 deshabilitaBoton('guardar', 'submit');
						 habilitaBoton('modificar', 'submit');
						 habilitaBoton('eliminar', 'submit');
						 
						if(data.clasificaTipDocID==9998){
							mensajeSis("El Tipo de Documento 9998 es para uso interno del sistema");
							 deshabilitaBoton('guardar', 'submit');
							 deshabilitaBoton('modificar', 'submit');
							 deshabilitaBoton('eliminar', 'submit');							
						}
							// Aplica para:					 
					 	if (data.clasificaTipo == solicitud) {
							$('#clasificaTipo2').attr("checked",true);
							$('#clasificaTipo1').attr("checked",false);
							$('#clasificaTipo3').attr("checked",false);
							$('#filsetMesa').hide(500);
							
						}else if (data.clasificaTipo == mesa){						
							$('#clasificaTipo2').attr("checked",false);
							$('#clasificaTipo1').attr("checked",true);
							$('#clasificaTipo3').attr("checked",false);
							$('#filsetMesa').show(500);
						}else{
							$('#clasificaTipo2').attr("checked",false);
							$('#clasificaTipo1').attr("checked",false);
							$('#clasificaTipo3').attr("checked",true);
							$('#filsetMesa').show(500);

						}	
					 	//Requerido en:
					 	if (data.tipoGrupInd == individual) {
							$('#tipoGrupInd1').attr("checked",true);
							$('#tipoGrupInd2').attr("checked",false);
							$('#tipoGrupInd3').attr("checked",false);
							
							$('#labelIntegrante').hide(500);
							$('#grupoAplica').hide(500);	
							$('#grupoAplica').val('0');	
	
						}else if (data.tipoGrupInd == grupal){						
							$('#tipoGrupInd1').attr("checked",false);
							$('#tipoGrupInd2').attr("checked",true);
							$('#tipoGrupInd3').attr("checked",false);
							
							$('#labelIntegrante').show(500);
							$('#grupoAplica').show(500);		
							
						}else{
							$('#tipoGrupInd1').attr("checked",false);
							$('#tipoGrupInd2').attr("checked",false);
							$('#tipoGrupInd3').attr("checked",true);
							$('#labelIntegrante').show(500);
							$('#grupoAplica').show(500);	
						}	
					 	
					 	//Documento Relacionado a una Garantia
					 	if (data.esGarantia == no) {
					 		$('#esGarantia1').attr("checked",false);
							$('#esGarantia2').attr("checked",true);															
						}else{						
							$('#esGarantia1').attr("checked",true);
							$('#esGarantia2').attr("checked",false);
						}						
					}else{ 
						mensajeSis("El Tipo de Documento no Existe");
						$(jqClasificacionID).focus();					     
					     deshabilitaBoton('guardar', 'submit');
						 deshabilitaBoton('modificar', 'submit');
						 deshabilitaBoton('eliminar', 'submit');	
						limpiaForm($('#formaGenerica'));
						consultaClasificacionesGrid();
						}
				});		
			}
		}	
		
	}
	

});//fin


function grabaGrid(){

		var numeroFila=parseInt(getRenglones('gvMainDocumentos'));
		var valor;
		var flag = false;

		for (var i = 0; i < numeroFila; i++) {
					valor = $("#" + "tipoDocID" + (i + 1)).val();
					if(valor == '' || valor == 0){
						flag = true;
					}
			}

			if (numeroFila > 0 && flag == false) {
				
				var params = {};
				params['tipoTransaccion'] = '1';
				params['clasDocID'] = ClasTipoDoc;
				params['lisTipoDocID'] = {	};
				params['lisDescDocumento'] = {	};
				
				for (var i = 0; i < numeroFila; i++) {
					params["lisTipoDocID"][i] = $("#" + "tipoDocID" + (i + 1)).val();
					params["lisDescDocumento"][i] = $("#" + "descDocumento" + (i + 1)).val();			
					
				}

								
				$.post("documentosPorClasificaGrid.htm", params, function(data) {
					
					mensajeSisRetro({
						mensajeAlert : 'Clasificación de Documentos Grabado Exitosamente',
						muestraBtnAceptar: true,
						muestraBtnCancela: false,
						txtAceptar : 'Aceptar',
						txtCancelar : 'Cancelar',
						funcionAceptar : function(){
							bloquearPantallaCarga();
							consultaClasificaDocGrid(ClasTipoDoc);
							$('#contenedorForma').unblock(); // desbloquear

						},
						funcionCancelar : function(){
							
						}
					});
						});
				
			} else {
				mensajeSis('Debe de definirse un Documento');
			}

}
function exitoPantallaClasificacion(){
	inicializaLimpia($('#formaGenerica'));	
	consultaClasificacionesGrid();
}

function falloPantallaClasificacion(){	
}


function inicializaLimpia(limforma) {
	$(':input', limforma).each(function() {
		var type = this.type;
		$('#clasificaDesc').val('');
		 if (type == 'checkbox' || type == 'radio')
			this.checked = false;
		else if (type == 'select')
			this.selectedIndex = -1;
	});
}


function consultaClasificacionesGrid(){
	var params = {};		
	params['tipoLista'] = 2;		
		
	$.post("clasificaDocumentosGridVista.htm", params, function(data){		
		if(data.length >0) { 			
			$('#divListaClasificacion').html(data);			
			$('#divListaClasificacion').show();	
			validaValores();					
		}else{
			$('#divListaClasificacion').html("");
			$('#divListaClasificacion').show();
		}			
	}); 
}


function generaSeccionClasificaciones(pageValor) {
	$('#divListaDocClas').html('');
 	$('#divListaDocClas').hide();

	var params = {};		
	params['tipoLista'] = 2;
	params['page'] = pageValor;

	$.post("clasificaDocumentosGridVista.htm", params, function(data){		
		if(data.length >0) { 			
			$('#divListaClasificacion').html(data);			
			$('#divListaClasificacion').show();	
			validaValores();					
		}else{
			$('#divListaClasificacion').html("");
			$('#divListaClasificacion').show();
		}			
	}); 


}


function validaValores(){
	var solicitud		='S';
	var mesaControl		='M';
	var individual		='I';
	var grupal			='G';
	
	var noAplica		='0';
	var presidente		='1';
	var tesoreso		='2';
	var secretario		='3';
	var integrante		='4';
	var todos			='5';
	var si				='S';
	var no				='N';

	$('tr[name=renglon]').each(function() {	
		var numero= this.id.substr(7,this.id.length);
		var jqIdClasificaT = eval("'clasificaT" +numero+ "'");	
		var jqIdTipoGI = eval("'tipoGrupI" +numero+ "'");	
		var jqIdGrupoA = eval("'grupoA" +numero+ "'");	//Aplica para integrante
		var jqIdGarantia = eval("'esGaran" +numero+ "'");		
		
		var valorClasificaT= document.getElementById(jqIdClasificaT).value;	
		var valorGI= document.getElementById(jqIdTipoGI).value;	
		var valorGAplica= document.getElementById(jqIdGrupoA).value;
		var valorGarantia= document.getElementById(jqIdGarantia).value;
	
		//APLCIA PARA:
		if(valorClasificaT==solicitud){
			$('#clasificaT'+numero).val('SOLICITUD');					
		}else if(valorClasificaT==mesaControl){
			$('#clasificaT'+numero).val('MESA');
		}else{
			$('#clasificaT'+numero).val('AMBOS');
		}	
		//REQUERIDO EN:
		if(valorGI==individual){
			$('#tipoGrupI'+numero).val('INDIVIDUAL');					
		}else if(valorGI==grupal){
			$('#tipoGrupI'+numero).val('GRUPAL');
		}else{
			$('#tipoGrupI'+numero).val('AMBOS');
		}	
		
		//APLICA PARA INTEGRANTE
		if(valorGAplica==noAplica){
			$('#grupoA'+numero).val('NO APLICA');					
		}else if(valorGAplica==presidente){
			$('#grupoA'+numero).val('PRESIDENTE');
		}else if(valorGAplica==tesoreso){
			$('#grupoA'+numero).val('TESORERO');
		}else if(valorGAplica==secretario){
			$('#grupoA'+numero).val('SECRETARIO');
		}else if(valorGAplica==integrante){
			$('#grupoA'+numero).val('INTEGRANTE');
		}else  if(valorGAplica==todos){
			$('#grupoA'+numero).val('TODOS');
		}
		
		//Solicitado sólo si existen garantias:  
		if(valorGarantia==si){
			$('#esGaran'+numero).val('SI');					
		}else if(valorGarantia==no){
			$('#esGaran'+numero).val('NO');
		}
	});
	
}

//funcion que bloquea la pantalla mientras se cargan los datos
 function bloquearPantallaCarga() {
 	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
 	$('#contenedorForma').block({
 	message : $('#mensaje'),
 	css : {
 	border : 'none',
 	background : 'none'
 	}
 	});

 }

//Funcion para mostrar los Datos del esquema segun el Check
 function consultaCheck(idControl) {
 	ClasTipoDoc = '';
	var sbtrn = (idControl.length);
	var Control = idControl.substr(9, sbtrn);
 	 	ClasTipoDoc = $('#clasificaTipDoc' + Control).val();
 	consultaClasificaDocGrid(ClasTipoDoc);
}


 function consultaClasificaDocGrid(ClasTipoDoc){
			
 	var params = {};
 		params['tipoLista'] = 1;
 		params['clasificaDoc'] = ClasTipoDoc;
 		
 	$.post("documentosPorClasificaGridVista.htm", params, function(data){
 		if(data.length >0) { 			
 			$('#divListaDocClas').html(data);
 			$('#divListaDocClas').show();

 		}else{
 			$('#divListaClasificacion').html("");
 			$('#divListaClasificacion').show();
 		}
 	}); 
 }

 
	/**
	 * Regresa el número de renglones de un grid.
	 * @param idTabla : ID de la tabla a la que se va a contar el número de renglones.
	 * @returns Número de renglones de la tabla.
	 */
	function getRenglones(idTabla){
		var numRenglones = $('#'+idTabla+' >tbody >tr[name^="tr'+'"]').length;
		return numRenglones;
	}

	/**
	 * Reasigna/actualiza el número de tabindex de los inputs que se encuentran dentro de la tabla. 
	 * @param idTabla : ID de la tabla a actualizar.
	 */
	function reasignaTabIndex(idTabla){
		var numInicioTabs = 15;
		var idTab = 'numTab';
			idReg = 'numeroFila';
		var numeroFila=parseInt(getRenglones('gvMainDocumentos'));
		var numReg = -1;


		$('#'+idTabla+' tr').each(function(index){
				var clasDocID="#"+$(this).find("input[name^='clasDocID"+"']").attr("id");
				var tipoDocID="#"+$(this).find("input[name^='tipoDocID"+"']").attr("id");
				var descDocumento="#"+$(this).find("input[name^='descDocumento"+"']").attr("id");
				var agrega="#"+$(this).find("input[name^='agrega"+"']").attr("id");
				var elimina="#"+$(this).find("input[name^='eliminar"+"']").attr("id");

				numInicioTabs++;
				$(tipoDocID).attr('tabindex' , numInicioTabs);
				$(agrega).attr('tabindex' , numInicioTabs);
				$(elimina).attr('tabindex' , numInicioTabs);

				numReg ++;
				
				$(clasDocID).attr('id' , 'clasDocID'+numReg);
				$(tipoDocID).attr('id' , 'tipoDocID' + numReg);
				$(descDocumento).attr('id' , 'descDocumento' + numReg);
				$(agrega).attr('id' , 'elimina' +numReg);
				$(elimina).attr('id' , 'agrega' +numReg);

			});
	
		$('#'+idTab).val(numInicioTabs);
		$('#'+idReg).val(numeroFila);

	}
	
 /*** Agrega un nuevo renglón (detalle) a la tabla del grid. ***/

	 function agregarDetalle(){
		var numTab=$('#numTab').asNumber();
		var numeroFila=parseInt(getRenglones('gvMainDocumentos'));

		numeroFila++;
		numTab ++;
		var nuevaFila=
		"<tr id=\"tr"+numeroFila+"\" name=\"tr"+"\">"+
			"<td nowrap=\"nowrap\">"+
				"<input type=\"hidden\" id=\"clasDocID"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"clasDocID"+"\" value=\""+(ClasTipoDoc)+"\" />"+
				"<input type=\"text\" id=\"tipoDocID"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"tipoDocID"+"\" size=\"10\" maxlength=\"10\" onkeyup=\"listaDocumentos(this.id)\" onBlur=\"consultaDocumento(this.id)\"'/>"+
			"<td>"+
				"<input type=\"text\" id=\"descDocumento"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"descDocumento"+"\" size=\"50\" maxlength=\"100\" disabled=\"disabled\" onBlur='ponerMayusculas(this)'/>"+
			"<td nowrap=\"nowrap\">"+
				"<input type=\"button\" id=\"eliminar"+numeroFila+"\"name=\"eliminar"+"\" value=\"\" class=\"btnElimina\" onclick=\"eliminarParam('tr"+numeroFila+"')\" tabindex=\""+(numTab)+"\"/> "+
				"<input type=\"button\" id=\"agrega"+numeroFila+"\" name=\"agrega"+"\" value=\"\" class=\"btnAgrega\" onclick=\"agregarDetalle(this.id)\" tabindex=\""+(numTab)+"\"/>"+
			"</td>"+
		"</tr>";
		$('#gvMainDocumentos').append(nuevaFila);
		$('#numTab').val(numTab);
		$("#numeroFila").val(numeroFila);

	 }

 /**
	 * Remueve de la tabla un tr.
	 * @param id : ID del tr.
	 */
	function eliminarParam(id){
		$('#'+id).remove();
		reasignaTabIndex('gvMainDocumentos');
	}


	function listaDocumentos(idControl) {
		var jq = eval("'#" + idControl + "'");

		$(jq).bind('keyup',function(e){
			lista(idControl, '2', '3', 'ClasificaDesc', $(jq).val(), 'clasificaDocumentosListaVista.htm');
		});	

		if($(jq).asNumber()){

		}
		
	}


function consultaDocumento(idControl) {
	var jqControl  = eval("'#" + idControl + "'");
	var  documentoID= $(jqControl).val();
	var  doc= $(jqControl).asNumber();
	var tipoCon = 2;
	var sbtrn = (jqControl.length);
	var numReg = idControl.substr(9, sbtrn);

	var clasificaDocBen = { 
						'clasificaTipDocID':doc
					};
	setTimeout("$('#cajaLista').hide();", 200);
	
	if(doc != '' && !isNaN(doc)){
		clasificaTipDocServicio.consulta(tipoCon,clasificaDocBen,  { async: false, callback:function(tipoDoc) {
			if(tipoDoc!=null){
				$('#descDocumento'+numReg).val(tipoDoc.descDocumento);
				$(jqControl).val(doc);
			}else{
				mensajeSisRetro({
						mensajeAlert : 'No Existe el Documento',
						muestraBtnAceptar: true,
						muestraBtnCancela: false,
						txtAceptar : 'Aceptar',
						txtCancelar : 'Cancelar',
						funcionAceptar : function(){
						$(jqControl).val('');
						$(jqControl).focus();	
						$(jqControl).select();	
						$('#descDocumento'+numReg).val('');
						},
						funcionCancelar : function(){
							
						}
					});
			}
		}	});
	}else{
		if(isNaN(doc)){
			mensajeSisRetro({
						mensajeAlert : 'Ingrese un Valor Valido',
						muestraBtnAceptar: true,
						muestraBtnCancela: false,
						txtAceptar : 'Aceptar',
						txtCancelar : 'Cancelar',
						funcionAceptar : function(){
						$(jqControl).val('');
						$(jqControl).focus();	
						$(jqControl).select();	
						$('#descDocumento'+numReg).val('');

						},
						funcionCancelar : function(){
							
						}
					});	
		}		
	}

}


 function limpiaGridClas(idControl){
		for (var i = 0; i <= 15; i++) {
			$("#" + "checkProc" + i).attr('checked' ,false);
		}
		$('#divListaDocClas').html('');
 		$('#divListaDocClas').hide();
	 }