<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>

</head>
<body>
</br>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>


<form id="gridDocumentosRequeridos" name="gridDocumentosRequeridos">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">     
	<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">           
		<legend>Documentos Requeridos</legend>	

			<c:choose>
				<c:when test="${tipoLista == '2'}">
					<tr>
						<td class="label"> 
					   	<label for="lblFecIni">Descripción</label> 
						</td>
						<td class="label"> 
							<label for="lblFecVen">Seleccionar</label> 
				  		</td>	
					</tr>
					
					<c:forEach items="${listaResultado}" var="documento" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input id="numero${status.count}"  name="numero" size="4"  type="hidden" value="${status.count}" readOnly="true" disabled="true"/> 
								<input id="clasificaTipDocID${status.count}"  name="clasificaTipDocID" size="4"  type="hidden" value="${documento.clasificaTipDocID}" readOnly="true" disabled="true"/> 
								<input id="clasificaDesc${status.count}"  name="clasificaDesc" size="80"  
										value="${documento.clasificaDesc}" readOnly="true" disabled="true"/> 
						  	</td> 
						  	<c:if test="${documento.asignado == 'S'}">
						  		<td>  
									<input type="checkbox" id="checkDoc${status.count}" name="checkDoc"  readOnly="true" checked="true"  />							 							
						  		</td> 
						  	</c:if>
						  	<c:if test="${documento.asignado == 'N'}">
						  		<td>  
									<input type="checkbox" id="checkDoc${status.count}" name="checkDoc"  readOnly="true"  />
						  		</td> 
						  	</c:if>					     		
						</tr>
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>

</body>
</html>
