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
			<table id="miTablaGrid" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   	<label for="lblTipoDocumento">N&uacute;mero</label> 
						</td>
						<td class="label" > 
					   		<label for="lblDescripcion">Descripci&oacute;n</label> 
						</td>
					</tr>	
									
					<c:forEach items="${listaResultado}" var="tiposDocs" varStatus="estado">
						<tr id="renglones${estado.count}" name="renglones">
							<td>
								<input type="hidden" id="consecutivoGrupo${estado.count}" name="consecutivoGrupo" size="6" value="${estado.count}" />
								<input  type="text" id="tipoDocumentoID${estado.count}" name="tipoDocumentoID" size="6" value="${tiposDocs.tipoDocumentoID}" readOnly="true" />
						  	</td> 		 
						  	<td> 
								<input type="text" id="descripcionTipo${estado.count}" name="descripcionTipo" size="80" value="${tiposDocs.descripcion}" readOnly="true" maxlength="60"/>   								
						  	</td> 	
							<td align="center" nowrap="nowrap">
								<input type="button" name="elimina" id="${estado.count}" class="btnElimina" onclick="eliminaDetalle(this.id)"/>
								<input type="button" name="agregafila" id="agregafila${estado.count}" class="btnAgrega" onclick="agregaNuevoDetalle();"/>
							</td>					
						</tr>					
					</c:forEach>
				</tbody>
			</table>
			<input type="hidden" value="0" name="numeroTipos" id="numeroTipos" />
			
	</body>
	</html>
		