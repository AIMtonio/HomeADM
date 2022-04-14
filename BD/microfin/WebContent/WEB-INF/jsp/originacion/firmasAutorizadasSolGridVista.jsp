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


<form id="gridFirmasOtorgadas" name="gridFirmasOtorgadas">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">     
	<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="50%">           
		<legend>Firmas Otorgadas</legend>	

			<c:choose>
				<c:when test="${tipoLista == '1'}">
					<tr>
						<td class="label"> 
					   	<label for="lblFirma">Firma</label> 
						</td>
						<td class="label"> 
							<label for="lblOrgano">Organo</label> 
				  		</td>						  	
					</tr>
					
					<c:forEach items="${listaResultado}" var="firmas" varStatus="status">
						<tr id="renglones${status.count}" name="renglones">
							<td> 
								<input id="numeroAut${status.count}"  name="numeroAut" size="4"  type="hidden" value="${status.count}" readOnly="true" disabled="true"/> 
								<input id="esquemaID${status.count}"  name="esquemaID" size="4"  type="hidden" value="${firmas.esquemaID}" readOnly="true" disabled="true"/>
								<input id="numFirma${status.count}"  name="numFirma" size="4"  type="hidden" value="${firmas.numFirma}" readOnly="true" disabled="true"/>
								<c:if test="${firmas.numFirma == '1'}">
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma A" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if> 
								<c:if test="${firmas.numFirma == '2'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma B" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if>
						  		<c:if test="${firmas.numFirma == '3'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma C" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if>
								<c:if test="${firmas.numFirma == '4'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma D" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if>
						  		<c:if test="${firmas.numFirma == '5'}">  
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma E" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if>
						  	</td>
							
						  	<td>
						  		<input id="organoID${status.count}"  name="organoID" size="45" value="${firmas.organoID}" type="hidden" readOnly="true" disabled="true"/> 
								<input id="descripcionOrgano${status.count}"  name="descripcionOrgano" size="45" value="${firmas.descripcionOrgano}" readOnly="true" disabled="true"/> 
						  	</td>
							
						</tr>
					</c:forEach>
				</c:when>
					<c:when test="${tipoLista == '2'}">
					<tr>
						<td class="label"> 
					   	<label for="lblFirma">Firma</label> 
						</td>
						<td class="label"> 
							<label for="lblOrgano">Organo</label> 
				  		</td>	
				  		<td class="label"> 
							<label for="lblSolicitudes">Solicitudes</label> 
				  		</td>
					</tr>
					
					<c:forEach items="${listaResultado}" var="firmas" varStatus="status">
						<tr id="renglones${status.count}" name="renglones">
							<td> 
								<input id="numeroAut${status.count}"  name="numeroAut" size="4"  type="hidden" value="${status.count}" readOnly="true" disabled="true"/> 
								<input id="esquemaID${status.count}"  name="esquemaID" size="4"  type="hidden" value="${firmas.esquemaID}" readOnly="true" disabled="true"/>
								<input id="numFirma${status.count}"  name="numFirma" size="4"  type="hidden" value="${firmas.numFirma}" readOnly="true" disabled="true"/>
								<c:if test="${firmas.numFirma == '1'}">
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma A" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if> 
								<c:if test="${firmas.numFirma == '2'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma B" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if>
						  		<c:if test="${firmas.numFirma == '3'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma C" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if>
								<c:if test="${firmas.numFirma == '4'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma D" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if>
						  		<c:if test="${firmas.numFirma == '5'}">  
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma E" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if>
						  	</td>
							
						  	<td>
						  		<input id="organoID${status.count}"  name="organoID" size="45" value="${firmas.organoID}" type="hidden" readOnly="true" disabled="true"/> 
								<input id="descripcionOrgano${status.count}"  name="descripcionOrgano" size="45" value="${firmas.descripcionOrgano}" readOnly="true" disabled="true"/> 
						  	</td>
							<td>
								<input id="solicitudes${status.count}"  name="solicitudes" size="45" value="${firmas.solicitudes}" readOnly="true" disabled="true"/> 
						  	</td>
						</tr>
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>

</body>
</html>