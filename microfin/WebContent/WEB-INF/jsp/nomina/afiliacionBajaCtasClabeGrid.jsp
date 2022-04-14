<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Grid para la parte de alta y baja de cuentas clabe para domiciliacion -->


<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Detalle</legend>
		<c:set var="listaPaginada" 	value="${listaResultado[0]}"/>
		<c:set var="numPagina"	  	value="${listaResultado[1]}"/>
		<c:set var="totalPagina"	value="${listaResultado[2]}"/>
		<c:set var="listaResultado" value="${listaPaginada.pageList}"/>
		
			<table id="miTabla">
				<thead alingn="center" id="encabezadoLista">
					<tr>
						<td class="label" nowrap="nowrap" size="12">No. Cliente</td>
						<td class="label" nowrap="nowrap" size="45">Nombre</td>
						<td class="label" nowrap="nowrap" size="45">Instituci&oacute;n</td>
						<td class="label" nowrap="nowrap">Cuenta Clabe</td>
						<td class="label" nowrap="nowrap" size="35">Comentario</td>
						<td class="label" nowrap="nowrap"></td>
					</tr>
				</thead>
				<tbody>
						<c:forEach items="${listaResultado}" var="afiliado" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
								<td>
									<input type="text" value="${afiliado.clienteID}" name="clienteID" id="clienteID${status.count}" readOnly="true" disabled="true" size="11"/>
								</td>
								<td>
									<input type="text" value="${afiliado.nombreCompleto}" name="nombreCompleto" id="nombreCompleto${status.count}" readOnly="true" disabled="true" size="50"/>									
								</td>
								<td>
									<input type="text" value="${afiliado.nombreBanco}" name="nombreInstitucion" id="nombreInstitucion${status.count}" readOnly="true" disabled="true" size="30"/>
								</td>
								<td>
									<input type="text" value="${afiliado.clabe}" name="convenio" id="convenio${status.count}" readOnly="true" disabled="true"/>
														
								</td>
								<td>
									<input type="text" value="${afiliado.comentario}" name="lisComentario" id="comentario${status.count}" size="35"/>
									<input type="hidden" value="${afiliado.clienteID}" name="lisClienteID" id="lisClienteID${status.count}"/>
								</td>
								<td>
									<input type="button" name="elimina" id="${status.count}" class="btnElimina" onClick="eliminaDetalle(this)"/>
								</td>
							</tr>
						</c:forEach>
					</tbody>
			</table>
			<table align="center">
				<tr>
					<td>
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('primero')" type="button" id="anterior" value="" class="btnPrimero" />
						</c:if>
					</td>
					<td >
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('anterior')" type="button" id="anterior" value="" class="btnAnterior" />
						</c:if>
					</td>
					<td>
						<c:if test="${totalPagina>1}">
							<label class="label">${numPagina}</label><label class="label">/</label><label class="label">${totalPagina}</label>
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('siguiente')" type="button" id="siguiente" value="" class="btnSiguiente" />
						</c:if>	
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('ultimo')" type="button" id="ultimo" value="" class="btnUltimo" />
						</c:if>	
					</td>
				</tr>
			</table>
		<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />
		<input type="hidden" id="tipo" name="tipo" value="11"/>
		
	</fieldset>

	
