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

<form id="gridCkeckList" name="gridCkeckList">
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
							<label for="lblComentarios">Comentarios</label> 
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
								
								<input  type="hidden" id="solicitudCreditoID${status.count}" name="solicitudCreditoID" size="6" 
										value="${checkList.solicitudCreditoID}" /> 
 
								<input  type="hidden" id="clasificaTipDocID${status.count}" name="clasificaTipDocID" size="6" 
										value="${checkList.clasificaTipDocID}" /> 
							
								<input type="text" id="clasificaDesc${status.count}" name="clasificaDesc" size="40" 
										value="${checkList.clasificaDesc}"  readOnly="true" disabled="true" />  
						  	</td> 
						  	<td> 
								
								<input type="hidden" id="tipoDocumento${status.count}" name="tipoDocumento" size="30" value="${checkList.tipoDocumentoID}"  />  
								<select id="tipoDocumentoID${status.count}" name="tipoDocumentoID"  type="select" style="width:200px"  onchange="limpiaComentario(this.id)" >
										<option value=" ">Seleccione</option>										
								</select>   
						  	</td> 
						  	<td> 
								<input  TYPE="text" id="comentarios${status.count}" name="comentarios" size="50" 
										value="${checkList.comentarios}" onBlur=" ponerMayusculas(this)" /> 							 							
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
			comentarios: { 
				required: true,
			}
		},
		messages: { 			
			tipoDocumentoID: {
				required: 'Seleccione una opción '
			},
			comentarios: {
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
		var tipoConsulta = 1;	
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jsDesID = eval("'tipoDocumentoID" + numero+ "'");	
			var jsTDocH= eval("'tipoDocumento" + numero+ "'");
				
			var jqIDTipoDoc = eval("'clasificaTipDocID" + numero+ "'");	
			
			var valorClasID = document.getElementById(jqIDTipoDoc).value;
			var valorjsTDocH= document.getElementById(jsTDocH).value;
			
			var claTipDoc = {
					'clasificaTipDocID':valorClasID			
				};
			
			dwr.util.removeAllOptions(jsDesID); 
			dwr.util.addOptions(jsDesID, {0:'SELECCIONAR'});  
			solicitudCheckListServicio.listaCombo(tipoConsulta, claTipDoc, function(documento){
			dwr.util.removeAllOptions(jsDesID);
			dwr.util.addOptions(jsDesID, documento, 'tipoDocumentoID', 'descripcion');
			$('#tipoDocumentoID'+numero+' option[value='+ valorjsTDocH +']').attr('selected','true');
			//$('#estatus option[value=A]').attr('selected','true');
			});
		});
		
	}
	
	/*
	realizaChecked();
	function realizaChecked(){	
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqIdChecked = eval("'documento" + numero+ "'");				
			var jqIdDocRecibido = eval("'docRecibido" + numero+ "'");
			
			var valorChecked= document.getElementById(jqIdChecked).value;
			
			if(valorChecked=='S'){
				$('#docRecibido'+numero).attr('checked','true');
				document.getElementById(jqIdDocRecibido).value = 'S';
					
			}else{
				$('#docRecibido'+numero).attr('checked',false);
			}	
		});
		
	}*/
	function realiza(control){
		
		if($('#'+control).attr('checked')==true){
		var valorChec= document.getElementById(control).value = 'S';
		
		 //$('#control option[value=S]');
		}else{
			document.getElementById(control).value = 'N';
	 }
			
	}
	
	function limpiaComentario(control){
		var numero= control.substr(15,control.length);
		var comentarioID = eval("'comentarios" + numero+ "'");
		document.getElementById(comentarioID).value = '';				
	}
	

</script>