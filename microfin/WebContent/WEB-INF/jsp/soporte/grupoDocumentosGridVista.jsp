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
		<c:set var="tipoLista"  value="${listaResultado[0]}"/>
		<c:set var="listaResultado" value="${listaResultado[1]}"/>
				
				<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
					
					<c:choose>
						<c:when test="${tipoLista == '1'}">
					<tbody>	
						<tr>
							<td class="label"> 
						   	<label for="lblTipoDocumento">Tipo de Documento</label> 
							</td>
							<td class="label" > 
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
									<input  type="hidden" id="grupoDocumentoID${estado.count}" name="grupoDocumentoID" size="6" value="${checkList.grupoDocumentoID}" />
									<input type="text" id="descripcion${estado.count}" name="descripcion" size="60"  value="${checkList.descripcion}" readOnly="true"/>   								
							  	</td> 
							  	<td>		
							  		<script type="text/javascript">
							  			var grupo=${checkList.grupoDocumentoID};
							  			var idTipoDocumento = "<c:out value="tipoDocumentoID${estado.count}"/>"; 
							  			var tipo =${checkList.tipoDocumentoID};
							  			Combo(grupo,idTipoDocumento,tipo);
									</script> 
									
							  		<input type="hidden" id="tipo${estado.count}" name="tipo" size="30" value="${checkList.tipoDocumentoID}"  />  																	
							   		<select id="tipoDocumentoID${estado.count}" name="tipoDocumentoID" path="tipoDocumentoID" type="select" >
							  			<option value="9999">SELECCIONA</option>							
									</select>
							  	</td>					 
							  	<td> 
									<input  type="text" id="comentarios${estado.count}" name="comentarios" size="70" maxlength="200" value="${checkList.comentarios}" onBlur="ponerMayusculas(this)"  /> 							 							
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
					</c:when>
					
						<c:when test="${tipoLista == '3'}">
						<tbody>	
						<tr>
							<td class="label"> 
						   	<label for="lblnumero">N&uacute;mero</label> 
							</td>
							<td class="label" > 
						   		<label for="lblDescripcion">Descripci&oacute;n</label> 
							</td>
							<td class="label"> 
						   	<label for="lblSeleccionar">Seleccionar</label> 			  			
						</tr>	
										
						<c:forEach items="${listaResultado}" var="grupo" varStatus="estado">
							<tr id="renglons${estado.count}" name="renglons">
								<td>
									<input type="hidden" id="consecutivo${estado.count}" name="consecutivo" size="6" value="${estado.count}" readonly="true" />
									<input  type="text" id="grupoID${estado.count}" name="grupoID" size="6" value="${grupo.grupoDocumentoID}" />
							  	</td> 
							  	<td>		
							  		<input type="text" id="descripcionGrupo${estado.count}" name="descripcionGrupo" size="60" value="${grupo.descripcion}" readOnly="true"/>   								
							  	</td>					 
							  	<td> 
									<input id="radioSeleccion${estado.count}" name="radioSeleccion"  type="radio" value="" onclick="consultaSeleccion(this.id)" />
							  	</td> 					
							</tr>					
						</c:forEach>
					</tbody>
					<tr align="right">
						<td class="label" colspan="5"> 
					   	<br>
				     	</td>
					</tr>
						</c:when>
					</c:choose>
						
				</table>
				
				<input type="hidden" value="0" name="numeroDocumento" id="numeroDocumento" />
		</body>
		</html>
