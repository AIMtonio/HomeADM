<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="clienteArchivo"  value="${clienteArchivo}"/>
              
	<table border="0" cellpadding="0" cellspacing="0" width="60%"> 		
		<tr>
			<td class="label" align="center"> 	<label for="lblNo">Número</label> </td> 	
			<td class="label" align="center"> 	<label for="lblObservacion"> Observación</label> </td>
			<td class="label" align="center"> 	<label for="fechaRegistro"> Fecha Registro</label> </td>
		 <td class="label" align="center"> 	<label for="ver"></label> </td>  	
			<td class="label" align="center">  <label for="elimina">Eliminar</label> </td> 
		</tr>
		<c:forEach items="${clienteArchivo}" var="clienteArchi" varStatus="status"> 
		<tr id="trArchivosCte${status.count}" name="trArchivosCte">
			<td align="center"> 
				<input id="clienteArchivosID${status.count}"  name="clienteArchivosID" size="7"
					value="${clienteArchi.clienteArchivosID}" readOnly="true" disabled="disabled"/> 
			</td> 
			<td align="center"> 
				<textarea id="observacion${status.count}" name="nameobservacion" cols="35" rows="2"
					 readonly="true" disabled="disabled">${clienteArchi.observacion}</textarea> 
			</td>
			<td align="center"> 
				<input id="fechaRegistro${status.count}"  name="fechaRegistro" size="15"
					value="${clienteArchi.fechaRegistro}" readOnly="true" disabled="disabled"/> 
			</td>
			<td align="center">
				<c:set var="varRecursoCte"  value="${clienteArchi.recurso}"/>
				<input id="recursoCteInput${status.count}"  name="recursoCteInput" size="7"
					value="${varRecursoCte}" readOnly="true" disabled="disabled" type="hidden"/> 	
				<input type="button" name="verArchivoCte" id="verArchivoCte${status.count}" class="submit" value="Ver" onclick="verArchivosCliente(${status.count},${clienteArchi.tipoDocumento},${clienteArchi.clienteArchivosID},'${clienteArchi.recurso}')"/>
			</td> 
			<td align="center"> 
				<input  type="button" name="elimina" id="elimina${status.count}" class="btnElimina" value="" onclick="eliminaArchivo(${clienteArchi.clienteArchivosID})"/>					
			</td> 
		</tr>
		</c:forEach>	
		<tr>
			<td>
			</td>
		</tr>
	</table>