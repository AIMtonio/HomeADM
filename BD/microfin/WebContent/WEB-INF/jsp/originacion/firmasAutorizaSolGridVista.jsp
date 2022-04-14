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


<form id="gridFirmasAutorizar" name="gridFirmasAutorizar">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">     
	<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="50%">           
		<legend>Firmas Pendientes para Autorizar</legend>	

			<c:choose>
				<c:when test="${tipoLista == '4'}">
					<tr>
						<td class="label"> 
					   	<label for="lblFirma">Firma</label> 
						</td>
						<td class="label"> 
							<label for="lblOrgano">Organo</label> 
				  		</td>	
				  		<td class="label"> 
							<label for="lblOrgano">Autorizar</label> 
				  		</td>	
					</tr>
					
					<c:forEach items="${listaResultado}" var="organo" varStatus="status">
						<tr id="filas${status.count}" name="filas">
							<td> 
								<input id="numero${status.count}"  name="numero" size="4"  type="hidden" value="${status.count}" readOnly="true" disabled="true"/> 
								<input id="esquema${status.count}"  name="esquema" size="4"  type="hidden" value="${organo.esquemaID}" readOnly="true" disabled="true"/>
								<input id="numeroFirm${status.count}"  name="numeroFirm" size="4"  type="hidden" value="${organo.numeroFirma}" readOnly="true" disabled="true"/>
								<c:if test="${organo.numeroFirma == '1'}">
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma A" size="10" readOnly="true"   />							 							
						  		</c:if> 
								<c:if test="${organo.numeroFirma == '2'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma B" size="10" readOnly="true"    />							 							
						  		</c:if>
						  		<c:if test="${organo.numeroFirma == '3'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma C" size="10" readOnly="true"    />							 							
						  		</c:if>
								<c:if test="${organo.numeroFirma == '4'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma D" size="10" readOnly="true"   />							 							
						  		</c:if>
						  		<c:if test="${organo.numeroFirma == '5'}">  
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma E" size="10" readOnly="true"   />							 							
						  		</c:if>
						  	</td>
							
						  	<td>
						  		<input id="organoA${status.count}"  name="organoA" size="45" value="${organo.organoID}" type="hidden" readOnly="true" /> 
								<input id="descripcionOrgano${status.count}"  name="descripcionOrgano" size="45" value="${organo.descripcionOrgano}" readOnly="true"/> 
						  	</td>
							<td>  
									<input type="checkbox" id="checkFirma${status.count}" name="checkFirma"  readOnly="true"  onClick="consultaEstado()"/>
																	 
																 							
						  	</td> 
																								
						</tr>
					</c:forEach>
					<input type="hidden" id="numeroFilas${status.count}"  name="numeroFilas" size="6" value="${organo.descripcionOrgano}" readOnly="true" disabled="true"/>
					
				</c:when>
					<c:when test="${tipoLista == '6'}">
					<tr>
						<td class="label"> 
					   	<label for="lblFirma">Firma</label> 
						</td>
						<td class="label"> 
							<label for="lblOrgano">Organo</label> 
				  		</td>	
				  		<td class="label"> 
							<label for="lblOrgano">Autorizar</label> 
				  		</td>	
					</tr>
					
					<c:forEach items="${listaResultado}" var="organo" varStatus="status">
						<tr id="filas${status.count}" name="filas">
							<td> 
								<input id="numero${status.count}"  name="numero" size="4"  type="hidden" value="${status.count}" readOnly="true" disabled="true"/> 
								<input id="esquema${status.count}"  name="esquema" size="4"  type="hidden" value="${organo.esquemaID}" readOnly="true" disabled="true"/>
								<input id="numeroFirm${status.count}"  name="numeroFirm" size="4"  type="hidden" value="${organo.numeroFirma}" readOnly="true" disabled="true"/>
								<c:if test="${organo.numeroFirma == '1'}">
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma A" size="10" readOnly="true"   />							 							
						  		</c:if> 
								<c:if test="${organo.numeroFirma == '2'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma B" size="10" readOnly="true"    />							 							
						  		</c:if>
						  		<c:if test="${organo.numeroFirma == '3'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma C" size="10" readOnly="true"    />							 							
						  		</c:if>
								<c:if test="${organo.numeroFirma == '4'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma D" size="10" readOnly="true"   />							 							
						  		</c:if>
						  		<c:if test="${organo.numeroFirma == '5'}">  
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma E" size="10" readOnly="true"   />							 							
						  		</c:if>
						  	</td>
							
						  	<td>
						  		<input id="organoA${status.count}"  name="organoA" size="45" value="${organo.organoID}" type="hidden" readOnly="true" /> 
								<input id="descripcionOrgano${status.count}"  name="descripcionOrgano" size="45" value="${organo.descripcionOrgano}" readOnly="true"/> 
						  	</td>
							<td>  
									<input type="checkbox" id="checkFirma${status.count}" name="checkFirma"  readOnly="true" onClick="consultaEstado()" />
																	 
																 							
						  	</td> 
																								
						</tr>
					</c:forEach>
					<input type="hidden" id="numeroFilas${status.count}"  name="numeroFilas" size="6" value="${organo.descripcionOrgano}" readOnly="true" disabled="true"/>
					
				</c:when>
				<c:when test="${tipoLista == '5'}">
					<tr>
						<td class="label"> 
					   	<label for="lblFirma">Firma</label> 
						</td>
						<td class="label"> 
							<label for="lblOrgano">Organo</label> 
				  		</td>	
				  		<td class="label"> 
							<label for="lblOrgano">Autorizar</label> 
				  		</td>	
					</tr>
					
					<c:forEach items="${listaResultado}" var="organo" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input id="nume${status.count}"  name="nume" size="4"  type="hidden" value="${status.count}" readOnly="true" disabled="true"/> 
								<input id="esquemaID${status.count}"  name="esquemaID" size="4"  type="hidden" value="${organo.esquemaID}" readOnly="true" disabled="true"/>
								<input id="numeroFirma${status.count}"  name="numeroFirma" size="4"  type="hidden" value="${organo.numeroFirma}" readOnly="true" disabled="true"/>
								<c:if test="${organo.numeroFirma == '1'}">
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma A" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if> 
								<c:if test="${organo.numeroFirma == '2'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma B" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if>
						  		<c:if test="${organo.numeroFirma == '3'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma C" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if>
								<c:if test="${organo.numeroFirma == '4'}"> 
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma D" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if>
						  		<c:if test="${organo.numeroFirma == '5'}">  
									<input type="text" id="numeroFir${status.count}" name="numeroFir" value="Firma E" size="10" readOnly="true" disabled="true"   />							 							
						  		</c:if>
						  	</td>
							
						  	<td>
						  		<input id="organoA${status.count}"  name="organoA" size="45" value="${organo.organoID}" type="hidden" readOnly="true" disabled="true"/> 
								<input id="descripcionOrgano${status.count}"  name="descripcionOrgano" size="45" value="${organo.descripcionOrgano}" readOnly="true" disabled="true"/> 
						  	</td>
							<td>  
									<input type="checkbox" id="checkFirma${status.count}" name="checkFirma"  readOnly="true"  />							 							
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