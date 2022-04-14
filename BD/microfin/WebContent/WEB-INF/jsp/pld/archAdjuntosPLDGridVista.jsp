<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="lista" value="${listaResultado[1]}" />
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Documentos</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<thead>
			<tr>
				<td class="label">
					<label>N&uacute;mero</label>
				</td>
				<td class="label">
					<label> Observaci&oacute;n</label>
				</td>
				<td class="label">
					<label>Ver</label>
				</td>
				<td class="separador"></td>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${lista}" var="bean" varStatus="status">
				<tr>
					<td>
						<input type="text" id="adjuntoID${status.count}" name="adjuntoID" size="7" tabindex="82" value="${bean.adjuntoID}" readOnly="true" />
						<input type="hidden" id="opeInusualID${status.count}" name="opeInusualID${status.count}" size="7" value="${bean.opeInusualID}" />
						<input type="hidden" id="opeInterPreoID${status.count}" name="opeInterPreoID${status.count}" size="7" value="${bean.opeInterPreoID}" />
					</td>
					<td>
						<textarea id="observacion${status.count}" name="observacion" cols="35" rows="2" tabindex="82" readOnly="true">${bean.observacion}</textarea>
					</td>
					<td>
						<c:set var="varRecursoUsr" value="${bean.recurso}" />
						<input type="hidden" id="recursoUsrInput${status.count}" name="recursoUsrInput" size="7" value="${varRecursoUsr}" readOnly="true" />
						<input type="button" name="verArchivo" id="verArchivo${status.count}" class="submit" value="Ver" onclick="verArchivos('recursoUsrInput${status.count}')" />
						<input type="button" name="elimina" id="elimina${status.count}" class="btnElimina" value="" onclick="eliminaArchivo(${bean.adjuntoID})" />
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</fieldset>