<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="clienteArchivo" value="${clienteArchivo}" />
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Documentos del <s:message code="safilocale.cliente" /></legend>
	<table border="0" style="width: auto; vertical-align: text-top;">
		<tr>
			<td class="label" style="text-align: center;">
				<label for="lblNo">N&uacute;mero</label>
			</td>
			<td class="label" style="text-align: center;">
				<label for="lblObservacion"> Observaci&oacute;n</label>
			</td>
			<td class="label" nowrap="nowrap" style="text-align: center;">
				<label>Fecha Registro</label>
			</td>
			<td class="label" style="text-align: center;">
				<label for="lblDocumento">Ver</label>
			</td>
			<td class="separador"></td>
		</tr>
		<c:forEach items="${clienteArchivo}" var="clienteArchi" varStatus="status">
			<tr>
				<td valign="top">
					<input id="clienteArchivosID${status.count}" name="clienteArchivosID" size="7" value="${clienteArchi.clienteArchivosID}" readOnly="true" />
				</td>
				<td valign="top">
					<textarea id="observacion${status.count}" name="nameobservacion" cols="120" rows="2" readOnly="true">${clienteArchi.observacion}</textarea>
				</td>
				<td valign="top"  style="text-align: center;">
					<input type="text" id="fechaRegistro${status.count}" name="fechaRegistro" value="${clienteArchi.fechaRegistro}" readOnly="true" size="10" />
				</td>
				<td>
					<c:set var="varRecursoCte" value="${clienteArchi.recurso}" />
					<input id="recursoCteInput${status.count}" name="recursoCteInput" size="7" value="${varRecursoCte}" readOnly="true" type="hidden" />
					<input type="button" name="verArchivoCte" id="verArchivoCte${status.count}" class="submit" value="Ver" onclick="verArchivosCliente(${status.count},${clienteArchi.tipoDocumento},${clienteArchi.clienteArchivosID},'${clienteArchi.recurso}')" />
				</td>
				<td  style="text-align: center;">
					<input type="button" name="elimina" id="elimina${status.count}" class="btnElimina" value="" onclick="eliminaArchivo(${clienteArchi.clienteArchivosID},'${clienteArchi.descTipoDoc}')" />
				</td>
			</tr>
		</c:forEach>
	</table>
</fieldset>