<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaPaginada" 	value="${listaResultado[1]}"/>
<c:set var="exitoError" value="${listaResultado[2]}"/>
<c:set var="transaccion" value="${listaResultado[3]}"/>
<c:set var="numPagina"	  	value="${listaResultado[4]}"/>
<c:set var="totalPagina"	value="${listaResultado[5]}"/>
<c:set var="lista" value="${listaPaginada.pageList}"/>




<form id="gridVal" name="gridVal">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Validaci&oacute;n</legend>
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '1'}">
					<tr id="encabezadoLista">
						<td align="center">
					   		Linea
						</td>
						<td align="center">
					   		Descripci&oacute;n
						</td>
					
				  	</tr>
					<c:forEach items="${lista}" var="valida" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<label>${valida.linea}</label>									
						</td> 
						<td> 
							<label>${valida.validacion}</label> 
						</td>
						
				 	</tr>
			
					</c:forEach>
				</c:when>
			</c:choose>
		</table>
		<table align="center">
				<tr>
					<td>
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="pegaHtml('primero')" type="button" id="primero" value="" class="btnPrimero" />
						</c:if>
					</td>
					<td >
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="pegaHtml('anterior')" type="button" id="anterior" value="" class="btnAnterior" />
						</c:if>
					</td>
					<td>
						<c:if test="${totalPagina>1}">
							<label class="label">${numPagina}</label><label class="label">/</label><label class="label">${totalPagina}</label>
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="pegaHtml('siguiente')" type="button" id="siguiente" value="" class="btnSiguiente" />
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="pegaHtml('ultimo')" type="button" id="ultimo" value="" class="btnUltimo" />
						</c:if>
					</td>
				</tr>
			</table>
		<input type="hidden" id="exitoError" value="${exitoError}"/>
		<input type="hidden" id="transaccion" value="${transaccion}"/>
	</fieldset>
</form>

