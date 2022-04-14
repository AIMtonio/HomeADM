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
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   	<label for="lblTipoDocumento">Documento</label> 
						</td>
						<td class="label"> 
					   	<label for="lblDocumento">Comentarios</label> 
						</td>
						<td class="label"> 
							<label for="lblComentarios">Aceptado</label> 
				  		</td>
				  			
					</tr>					
					<c:forEach items="${listaResultado}" var="checkList" varStatus="estado">
						<tr id="renglons${estado.count}" name="renglons">
							<td>
								<input type="hidden" id="consecutivo${estado.count}" name="consecutivo" size="6" value="${estado.count}" />
								
								<input  type="hidden" id="creditoID${estado.count}" name="credito" size="6" value="${checkList.creditoID}" />
								
								
								<input  type="hidden" id="clasificaTipDocID${estado.count}" name="clasificaTipDocID" size="6" value="${checkList.clasificaTipDocID}" />
								<input  type="hidden" id="tipoDocumentoID${estado.count}" name="tipoDocumentoID" size="6" value="${checkList.tipoDocumentoID}" />
 								<input type="text" id="descripcion${estado.count}" name="descripcion" size="80" value="${checkList.descripcion}" readOnly="true" disabled="true" onblur="ponerMayusculas(this)" />   								
						  	</td> 
						 
						  	<td> 
								<input  type="text" id="comentarios${estado.count}" name="comentarios" size="70" 
										value="${checkList.comentarios}" onBlur="ponerMayusculas(this)"  /> 							 							
						  	</td> 	
						  	<td> 
								<input type="hidden" id="documentoAcep${estado.count}" name="documentoAcep" size="30" value="${checkList.docAceptado}"  />  														
								<input TYPE="checkbox"id="docAceptado${estado.count}" name="docAceptado" value="${checkList.docAceptado}" onclick="realiza(this.id)"/>
	    							<label for="Aceptado" > </label>  							 							
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
	
	

</body>
</html>

