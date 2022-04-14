<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head> 

</head>
<body>
<br/>

<c:set var="listaResultado"  value="${listaResultado}"/>

<form id="gridCkeckList" name="checkListCedes">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Documentos</legend>			
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   	<label for="lblTipoDocumento">Tipo de Documento</label> 
						</td>
						<td class="label"> 
					   	<label for="lblDocumento">Documento</label> 
						</td>
						<td class="label"> 
							<label for="lblObservacion">Comentarios</label> 
				  		</td>
				  			<td class="label"> 
							<label for="lblVer">Ver</label> 
				  		</td>
				  			<td class="label"> 
							<label for="lblAdjuntar">Adjuntar</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblRecibido">Recibido</label> 
				  		</td>	
					</tr>					
					<c:forEach items="${listaResultado}" var="checkList" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" 
										value="${status.count}" />
							
								<input  type="hidden" id="clasificaTipDocID${status.count}" name="clasificaTipDocID" size="6" 
										 value="${checkList.tipoDocCapID}"/> 
								
				
								<input type="text" id="clasificaDesc${status.count}" name="clasificaDesc" size="40" 
										value="${checkList.descripcion}"  readOnly="true" disabled="true" />  
										
						  	</td> 
						  	<td> 
								<input type="hidden" id="tipoDocumento${status.count}" name="tipoDocumento" size="30" value="${checkList.tipoDocumentoID}"  />   
								<select id="tipoDocumentoID${status.count}" name="tipoDocumentoID"  type="select" style="width:200px"  onchange="consultaDocumento(this.id)" >
										<option value="0">Seleccionar</option>									
								</select>   
						  	</td> 
						  	
						  	<td> 
								<input  TYPE="text" id="observacion${status.count}" name="observacion" size="50" 
										value="${checkList.observacion}" onBlur=" ponerMayusculas(this)" /> 							 							
						  	</td> 
						  	
						  	<td>
						  		<input  type="hidden" id="recurso${status.count}" name="recurso" size="50" value="${checkList.recurso}" />
								<c:set var="recurso"  value="${checkList.recurso}"/>
								<input id="recursoCteInput${status.count}"  name="recursoCteInput" size="7" value="${recurso}" readOnly="true" type="hidden"/> 	
   								<input type="button" name="verArchivoCta" id="verArchivoCta${status.count}" class="submit" value="Ver" onclick="verArchivosCta(${status.count})"/>   
							
							</td> 
			
						<td class="label">
								<input type="button" id="enviar${status.count}" name="enviar" class="submit" value="Adjuntar" onclick="adjuntarArchivos(${status.count})"  /> 
					  		</td> 
											  
						  		
						  	<td> 
							  	<input type="hidden" id="documento${status.count}" name="documento" size="30" value="${checkList.docRecibido}"  /> 
						  		<c:if test="${checkList.docRecibido == 'S'}" >								 														
								<input TYPE="checkbox"id="docRecibido${status.count}" checked="true" name="docRecibido" value="${checkList.docRecibido}" onclick="realiza(this.id)"/>
	    						</c:if>
	    						<c:if test="${checkList.docRecibido != 'S'}" >								 														
								<input TYPE="checkbox"id="docRecibido${status.count}" name="docRecibido" value="${checkList.docRecibido}" onclick="realiza(this.id)"/>
	    						</c:if>
	    						<label for="recibido" > </label> 
	    					    <input type="hidden" id="procedencia${status.count}" name="procedencia" size="30" value="${checkList.procedencia}"  /> 
	    						<input type="hidden" id="archivoCuentaID${status.count}" name="archivoCuentaID" size="30" value="${checkList.archivoCuentaID}"  /> 
	    						 							 							
						  	</td> 					
						</tr>
					<tr>
		<td>
			 <div id="imagenCte" style="display: none;">
			 	<img id= "imgCliente" SRC="images/user.jpg" WIDTH="100%" HEIGHT="100%" border ="0" alt="Foto cliente"/> 
			</div> 
       </td> 
	</tr>
						
					</c:forEach>
				
					
				</tbody>
				<tr align="right">
					<td class="label" colspan="5"> 
				   	<br>
			     	</td>
				</tr>
			</table>
			 <input type="hidden" value="0" name="numeroDocumento" id="numeroDocumento" />
		 </fieldset>
	
</form>

</body>
</html>

<script type="text/javascript">		
	$("#numeroDocumento").val($('input[name=consecutivoID]').length);	
	
	$('#gridCkeckList').validate({
		rules: {
			tipoDocumentoID: { 
				required: true,
			},
			observacion: { 
				required: true,
			}
		},
		messages: { 			
			tipoDocumentoID: {
				required: 'Seleccione una opción '
			},
			observacion: {
				required: 'Escriba un comentario'
			}
		}		
	});	
			
	function agregaFormato(idControl){
		var jControl = eval("'#" + idControl + "'"); 
		
     	$(jControl).bind('keyup',function(){
			$(jControl).formatCurrency({
						colorize: true,
						positiveFormat: '%n', 
						roundToDecimalPlace: -1
						});
		});		
					
	}
	
	cargaListaTiposDocumentos();
	function cargaListaTiposDocumentos(){
		
		var tipoConsulta = 2;	
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jsDesID = eval("'tipoDocumentoID" + numero+ "'");	
			var jsTDocH= eval("'tipoDocumento" + numero+ "'");
			var jqIDTipoDoc = eval("'clasificaTipDocID" + numero+ "'");	
			var jsProcede = eval("'procedencia" + numero+ "'");
			
			
			
			var valorClasID = document.getElementById(jqIDTipoDoc).value;
			var valorjsTDocH= document.getElementById(jsTDocH).value;
			var valorjsProce= document.getElementById(jsProcede).value;

			var claTipDoc = {		
					'clasificaTipDocID':valorClasID			
				};
			
			dwr.util.removeAllOptions(jsDesID); 
			checkListCedesServicio.listaCombo(tipoConsulta, claTipDoc, function(documento){	
			dwr.util.removeAllOptions(jsDesID);
			dwr.util.addOptions(jsDesID, {'0':'SELECCIONAR'}); 
			dwr.util.addOptions(jsDesID, documento, 'tipoDocumentoID', 'descripcion');
			$('#tipoDocumentoID'+numero+' option[value='+ valorjsTDocH +']').attr('selected','true');
			
	
			});
			
			if(valorjsProce == 'D'){
				deshabilitaBoton('enviar'+numero, 'submit');
				habilitaBoton('verArchivoCte'+numero, 'submit');
				
			}else if(valorjsProce == 'C'){
				habilitaBoton('enviar'+numero, 'submit');
				deshabilitaBoton('verArchivoCta'+numero, 'submit');
				deshabilitaControl('docRecibido'+numero);

			}
			
			if(valorjsTDocH != '0'){
				deshabilitaControl('tipoDocumentoID'+numero);
			}	
			
		});
		
	}
	
	
	function realiza(control){
		
		if($('#'+control).attr('checked')==true){
		var valorChec= document.getElementById(control).value = 'S';
		}else{
			document.getElementById(control).value = 'N';
	 }
			
	}
	

	
/*	function limpiaComentario(control){
		var numero= control.substr(15,control.length);
		var comentarioID = eval("'observacion" + numero+ "'");
		document.getElementById(comentarioID).value = '';				
	}
	
	*/
</script>