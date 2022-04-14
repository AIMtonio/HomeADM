<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="tipoLista"  	value="${listaResultado[0]}"/>
<c:set var="listaPaginada"	value="${listaResultado[1]}"/>
<c:set var="numPagina"	  	value="${listaResultado[2]}"/>
<c:set var="totalPagina"	value="${listaResultado[3]}"/>
<c:set var="listaResultado" value="${listaPaginada.pageList}"/>
<br>
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<legend class="ui-widget ui-widget-header ui-corner-all" id="labelTitulo">DOCUMENTOS</legend>
			<table id="miTabla" border="0" width="100%">
				<tr id="encabezadoLista">
					<td style="text-align: center;" id="lblDocumentoID">N&#250;mero</td>
					<td style="text-align: center;" id="lblOrigenDocumento" >Origen Documento</td>
					<td style="text-align: center;" id="lblTipoDocumento" >Tipo Documento</td>
					<td style="text-align: center;" id="lblDocumento" >Documento</td>
					<td style="text-align: center;" id="lblEstatus" >Estatus</td>
				</tr>
				<c:forEach items="${listaResultado}" var="documento" varStatus="status">
					<tr id="renglonCliente${status.count}" name="renglon">
						<td>
							<input type="text" id="listaDocumentoID${status.count}" name="listaDocumentoID" path="listaDocumentoID" value="${documento.documentoID}" disabled="disabled" style="text-align: center;"/>
						</td>
						<td>
							<input type="text" id="listaOrigenDocumento${status.count}" name="listaOrigenDocumento" path="listaOrigenDocumento" value="${documento.numeroInstrumento}" disabled="disabled" style="text-align: center;" />
						</td>
						<td>
							<input type="text" id="listaGrupoDocumento${status.count}" name="listaGrupoDocumento" path="listaGrupoDocumento" value="${documento.grupoDocumentoID}" disabled="disabled" style="text-align: center;" />
						</td>
						<td>
							<input type="text" id="listaTipoDocumentoID${status.count}" name="listaTipoDocumentoID" path="listaTipoDocumentoID" size="10" value="${documento.tipoDocumentoID}" disabled="disabled" style="text-align: center;"/>
							<input type="text" id="listaClienteDescripcion${status.count}" name="listaClienteDescripcion" path="listaClienteDescripcion" value ="${documento.nombreDocumento}" tabindex="${status.count}" size="50"  onBlur=" ponerMayusculas(this)"  maxlength = "100" disabled="disabled"/>
						</td>
						<td>
							<input type="text" id="listaEstatus${status.count}" name="listaEstatus" path="listaEstatus" value="${documento.estatus}" disabled="disabled" style="text-align: center;"/>
						</td>
					</tr>
				</c:forEach>
			</table>
			<table align="center">
				<tr>
					<td>
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('primero')" type="button" id="primero" value="" class="btnPrimero" />
						</c:if>
					</td>
					<td >
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('anterior')" type="button" id="anterior" value="" class="btnAnterior" />
						</c:if>
					</td>
					<td>
						<c:if test="${totalPagina>1}">
							<label class="label">${numPagina}</label>
							<label class="label">/</label>
							<label class="label">${totalPagina}</label>
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
		</c:when>
		<c:when test="${tipoLista == '2'}">
			<legend class="ui-widget ui-widget-header ui-corner-all" id="labelTitulo">CLIENTE</legend>
			<table id="miTabla" border="0" width="100%">
				<tr id="encabezadoLista">
					<td style="text-align: center;" id="lblDocumentoID">N&#250;mero</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Instrumento</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Documento</td>
					<td style="text-align: center;" id="lblEstatus" >Estatus</td>
					<td style="text-align: center;" id="lblUbicacion" >Ubicaci&oacute;n</td>
				</tr>
				<c:forEach items="${listaResultado}" var="documento" varStatus="status">
					<tr id="renglonCliente${status.count}" name="renglon">
						<td>
							<input type="text" id="listaClienteDocumentoID${status.count}" name="listaDocumentoID" path="listaDocumentoID" value="${documento.documentoID}" disabled="disabled" style="text-align: center;"/>
						</td>
						<td>
							<input type="text" id="listaNumeroInstrumento${status.count}" name="listaNumeroInstrumento" path="listaNumeroInstrumento" value="${documento.numeroInstrumento}" disabled="disabled" style="text-align: center;" />
						</td>
						<td>
							<input type="text" id="listaTipoDocumentoID${status.count}" name="listaTipoDocumentoID" path="listaTipoDocumentoID" size="10" value="${documento.tipoDocumentoID}" disabled="disabled" style="text-align: center;"/>
							<textarea type="text" id="listaClienteDescripcion${status.count}" name="listaClienteDescripcion" path="listaClienteDescripcion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "100" disabled="disabled">${documento.nombreDocumento}</textarea>
						</td>
						<td>
							<input type="text" id="listaEstatus${status.count}" name="listaEstatus" path="listaEstatus" value="${documento.estatus}" disabled="disabled" />
						</td>
						<td>
							<textarea type="text" id="listaUbicacion${status.count}" name="listaUbicacion" path="listaUbicacion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "500" disabled="disabled">${documento.ubicacion}</textarea>
						</td>
						<td>
							<input type="button" name="reporte" id="reporteCliente${status.count}" class="submit" value="Reporte" onclick="generaReporte(1, this.id)" tabindex="${status.count}"/>
						</td>
					</tr>
				</c:forEach>
			</table>
			<table align="center">
				<tr>
					<td>
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('primero', 2, 1)" type="button" id="primero" value="" class="btnPrimero" />
						</c:if>
					</td>
					<td >
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('anterior', 2, 1)" type="button" id="anterior" value="" class="btnAnterior" />
						</c:if>
					</td>
					<td>
						<c:if test="${totalPagina>1}">
							<label class="label">${numPagina}</label>
							<label class="label">/</label>
							<label class="label">${totalPagina}</label>
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('siguiente', 2, 1)" type="button" id="siguiente" value="" class="btnSiguiente" />
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('ultimo', 2, 1)" type="button" id="ultimo" value="" class="btnUltimo" />
						</c:if>
					</td>
				</tr>
			</table>
		</c:when>
		<c:when test="${tipoLista == '3'}">
			<legend class="ui-widget ui-widget-header ui-corner-all" id="labelTitulo">CUENTAS DE AHORRO</legend>
			<table id="miTabla" border="0" width="100%">
				<tr id="encabezadoLista">
					<td style="text-align: center;" id="lblDocumentoID">N&#250;mero</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Instrumento</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Documento</td>
					<td style="text-align: center;" id="lblEstatus" >Estatus</td>
					<td style="text-align: center;" id="lblUbicacion" >Ubicaci&oacute;n</td>
				</tr>
				<c:forEach items="${listaResultado}" var="documento" varStatus="status">
					<tr id="renglonCuenta${status.count}" name="renglon">
						<td>
							<input type="text" id="listaCuentaDocumentoID${status.count}" name="listaCuentaDocumentoID" path="listaCuentaDocumentoID" value="${documento.documentoID}" disabled="disabled" style="text-align: center;"/>
						</td>
						<td>
							<input type="text" id="listaNumeroInstrumento${status.count}" name="listaNumeroInstrumento" path="listaNumeroInstrumento" value="${documento.numeroInstrumento}" disabled="disabled" style="text-align: center;" />
						</td>
						<td>
							<input type="text" id="listaTipoDocumentoID${status.count}" name="listaTipoDocumentoID" path="listaTipoDocumentoID" size="10" value="${documento.tipoDocumentoID}" disabled="disabled" style="text-align: center;"/>
							<textarea type="text" id="listaCuentaDescripcion${status.count}" name="listaCuentaDescripcion" path="listaCuentaDescripcion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "100" disabled="disabled">${documento.nombreDocumento}</textarea>
						</td>
						<td>
							<input type="text" id="listaEstatus${status.count}" name="listaEstatus" path="listaEstatus" value="${documento.estatus}" disabled="disabled" />
						</td>
						<td>
							<textarea type="text" id="listaUbicacion${status.count}" name="listaUbicacion" path="listaUbicacion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "500" disabled="disabled">${documento.ubicacion}</textarea>
						</td>
						<td>
							<input type="button" name="reporte" id="reporteCuenta${status.count}" class="submit" value="Reporte" onclick="generaReporte(2,this.id)" tabindex="${status.count}"/>
						</td>
					</tr>
				</c:forEach>
			</table>
			<table align="center">
				<tr>
					<td>
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('primero', 3, 2)" type="button" id="primero" value="" class="btnPrimero" />
						</c:if>
					</td>
					<td >
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('anterior', 3, 2)" type="button" id="anterior" value="" class="btnAnterior" />
						</c:if>
					</td>
					<td>
						<c:if test="${totalPagina>1}">
							<label class="label">${numPagina}</label>
							<label class="label">/</label>
							<label class="label">${totalPagina}</label>
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('siguiente', 3, 2)" type="button" id="siguiente" value="" class="btnSiguiente" />
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('ultimo', 3, 2)" type="button" id="ultimo" value="" class="btnUltimo" />
						</c:if>
					</td>
				</tr>
			</table>
		</c:when>
		<c:when test="${tipoLista == '4'}">
			<legend class="ui-widget ui-widget-header ui-corner-all" id="labelTitulo">CEDES</legend>
			<table id="miTabla" border="0" width="100%">
				<tr id="encabezadoLista">
					<td style="text-align: center;" id="lblDocumentoID">N&#250;mero</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Instrumento</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Documento</td>
					<td style="text-align: center;" id="lblEstatus" >Estatus</td>
					<td style="text-align: center;" id="lblUbicacion" >Ubicaci&oacute;n</td>
				</tr>
				<c:forEach items="${listaResultado}" var="documento" varStatus="status">
					<tr id="renglonCede${status.count}" name="renglon">
						<td>
							<input type="text" id="listaCedeDocumentoID${status.count}" name="listaCedeDocumentoID" path="listaCedeDocumentoID" value="${documento.documentoID}" disabled="disabled" style="text-align: center;"/>
						</td>
						<td>
							<input type="text" id="listaNumeroInstrumento${status.count}" name="listaNumeroInstrumento" path="listaNumeroInstrumento" value="${documento.numeroInstrumento}" disabled="disabled" style="text-align: center;" />
						</td>
						<td>
							<input type="text" id="listaTipoDocumentoID${status.count}" name="listaTipoDocumentoID" path="listaTipoDocumentoID" size="10" value="${documento.tipoDocumentoID}" disabled="disabled" style="text-align: center;"/>
							<textarea type="text" id="listaCedeDescripcion${status.count}" name="listaCedeDescripcion" path="listaCedeDescripcion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "100" disabled="disabled">${documento.nombreDocumento}</textarea>
						</td>
						<td>
							<input type="text" id="listaEstatus${status.count}" name="listaEstatus" path="listaEstatus" value="${documento.estatus}" disabled="disabled" />
						</td>
						<td>
							<textarea type="text" id="listaUbicacion${status.count}" name="listaUbicacion" path="listaUbicacion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "500" disabled="disabled">${documento.ubicacion}</textarea>
						</td>
						<td>
							<input type="button" name="reporte" id="reporteCede${status.count}" class="submit" value="Reporte" onclick="generaReporte(3,this.id)" tabindex="${status.count}"/>
						</td>
					</tr>
				</c:forEach>
			</table>
			<table align="center">
				<tr>
					<td>
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('primero', 4, 3)" type="button" id="primero" value="" class="btnPrimero" />
						</c:if>
					</td>
					<td >
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('anterior', 4, 3)" type="button" id="anterior" value="" class="btnAnterior" />
						</c:if>
					</td>
					<td>
						<c:if test="${totalPagina>1}">
							<label class="label">${numPagina}</label>
							<label class="label">/</label>
							<label class="label">${totalPagina}</label>
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('siguiente', 4, 3)" type="button" id="siguiente" value="" class="btnSiguiente" />
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('ultimo', 4, 3)" type="button" id="ultimo" value="" class="btnUltimo" />
						</c:if>
					</td>
				</tr>
			</table>
		</c:when>
		<c:when test="${tipoLista == '5'}">
			<legend class="ui-widget ui-widget-header ui-corner-all" id="labelTitulo">INVERSIONES</legend>
			<table id="miTabla" border="0" width="100%">
				<tr id="encabezadoLista">
					<td style="text-align: center;" id="lblDocumentoID">N&#250;mero</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Instrumento</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Documento</td>
					<td style="text-align: center;" id="lblEstatus" >Estatus</td>
					<td style="text-align: center;" id="lblUbicacion" >Ubicaci&oacute;n</td>
				</tr>
				<c:forEach items="${listaResultado}" var="documento" varStatus="status">
					<tr id="renglonInversion${status.count}" name="renglon">
						<td>
							<input type="text" id="listaInversionDocumentoID${status.count}" name="listaInversionDocumentoID" path="listaInversionDocumentoID" value="${documento.documentoID}" disabled="disabled" style="text-align: center;"/>
						</td>
						<td>
							<input type="text" id="listaNumeroInstrumento${status.count}" name="listaNumeroInstrumento" path="listaNumeroInstrumento" value="${documento.numeroInstrumento}" disabled="disabled" style="text-align: center;" />
						</td>
						<td>
							<input type="text" id="listaTipoDocumentoID${status.count}" name="listaTipoDocumentoID" path="listaTipoDocumentoID" size="10" value="${documento.tipoDocumentoID}" disabled="disabled" style="text-align: center;"/>
							<textarea type="text" id="listaInversionDescripcion${status.count}" name="listaInversionDescripcion" path="listaInversionDescripcion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "100" disabled="disabled">${documento.nombreDocumento}</textarea>
						</td>
						<td>
							<input type="text" id="listaEstatus${status.count}" name="listaEstatus" path="listaEstatus" value="${documento.estatus}" disabled="disabled" />
						</td>
						<td>
							<textarea type="text" id="listaUbicacion${status.count}" name="listaUbicacion" path="listaUbicacion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "500" disabled="disabled">${documento.ubicacion}</textarea>
						</td>
						<td>
							<input type="button" name="reporte" id="reporteInversion${status.count}" class="submit" value="Reporte" onclick="generaReporte(4,this.id)" tabindex="${status.count}"/>
						</td>
					</tr>
				</c:forEach>
			</table>
			<table align="center">
				<tr>
					<td>
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('primero', 5, 4)" type="button" id="primero" value="" class="btnPrimero" />
						</c:if>
					</td>
					<td >
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('anterior', 5, 4)" type="button" id="anterior" value="" class="btnAnterior" />
						</c:if>
					</td>
					<td>
						<c:if test="${totalPagina>1}">
							<label class="label">${numPagina}</label>
							<label class="label">/</label>
							<label class="label">${totalPagina}</label>
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('siguiente', 5, 4)" type="button" id="siguiente" value="" class="btnSiguiente" />
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('ultimo', 5, 4)" type="button" id="ultimo" value="" class="btnUltimo" />
						</c:if>
					</td>
				</tr>
			</table>
		</c:when>
		<c:when test="${tipoLista == '6'}">
			<legend class="ui-widget ui-widget-header ui-corner-all" id="labelTitulo">SOLICITUD DE CR&Eacute;DITO</legend>
			<table id="miTabla" border="0" width="100%">
				<tr id="encabezadoLista">
					<td style="text-align: center;" id="lblDocumentoID">N&#250;mero</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Instrumento</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Documento</td>
					<td style="text-align: center;" id="lblEstatus" >Estatus</td>
					<td style="text-align: center;" id="lblUbicacion" >Ubicaci&oacute;n</td>
				</tr>
				<c:forEach items="${listaResultado}" var="documento" varStatus="status">
					<tr id="renglonSolicitud${status.count}" name="renglon">
						<td>
							<input type="text" id="listaSolicitudDocumentoID${status.count}" name="listaSolicitudDocumentoID" path="listaSolicitudDocumentoID" value="${documento.documentoID}" disabled="disabled" style="text-align: center;"/>
						</td>
						<td>
							<input type="text" id="listaNumeroInstrumento${status.count}" name="listaNumeroInstrumento" path="listaNumeroInstrumento" value="${documento.numeroInstrumento}" disabled="disabled" style="text-align: center;" />
						</td>
						<td>
							<input type="text" id="listaTipoDocumentoID${status.count}" name="listaTipoDocumentoID" path="listaTipoDocumentoID" size="10" value="${documento.tipoDocumentoID}" disabled="disabled" style="text-align: center;"/>
							<textarea type="text" id="listaSolicitudDescripcion${status.count}" name="listaSolicitudDescripcion" path="listaSolicitudDescripcion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "100" disabled="disabled">${documento.nombreDocumento}</textarea>
						</td>
						<td>
							<input type="text" id="listaEstatus${status.count}" name="listaEstatus" path="listaEstatus" value="${documento.estatus}" disabled="disabled" />
						</td>
						<td>
							<textarea type="text" id="listaUbicacion${status.count}" name="listaUbicacion" path="listaUbicacion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "500" disabled="disabled">${documento.ubicacion}</textarea>
						</td>
						<td>
							<input type="button" name="reporte" id="reporteSolicitud${status.count}" class="submit" value="Reporte" onclick="generaReporte(5, this.id)" tabindex="${status.count}"/>
						</td>
					</tr>
				</c:forEach>
			</table>
			<table align="center">
				<tr>
					<td>
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('primero', 6, 5)" type="button" id="primero" value="" class="btnPrimero" />
						</c:if>
					</td>
					<td >
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('anterior', 6, 5)" type="button" id="anterior" value="" class="btnAnterior" />
						</c:if>
					</td>
					<td>
						<c:if test="${totalPagina>1}">
							<label class="label">${numPagina}</label>
							<label class="label">/</label>
							<label class="label">${totalPagina}</label>
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('siguiente', 6, 5)" type="button" id="siguiente" value="" class="btnSiguiente" />
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('ultimo', 6, 5)" type="button" id="ultimo" value="" class="btnUltimo" />
						</c:if>
					</td>
				</tr>
			</table>
		</c:when>
		<c:when test="${tipoLista == '7'}">
			<legend class="ui-widget ui-widget-header ui-corner-all" id="labelTitulo">CR&Eacute;DITO</legend>
			<table id="miTabla" border="0" width="100%">
				<tr id="encabezadoLista">
					<td style="text-align: center;" id="lblDocumentoID">N&#250;mero</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Instrumento</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Documento</td>
					<td style="text-align: center;" id="lblEstatus" >Estatus</td>
					<td style="text-align: center;" id="lblUbicacion" >Ubicaci&oacute;n</td>
				</tr>
				<c:forEach items="${listaResultado}" var="documento" varStatus="status">
					<tr id="renglonCredito${status.count}" name="renglon">
						<td>
							<input type="text" id="listaCreditoDocumentoID${status.count}" name="listaCreditoDocumentoID" path="listaCreditoDocumentoID" value="${documento.documentoID}" disabled="disabled" style="text-align: center;"/>
						</td>
						<td>
							<input type="text" id="listaNumeroInstrumento${status.count}" name="listaNumeroInstrumento" path="listaNumeroInstrumento" value="${documento.numeroInstrumento}" disabled="disabled" style="text-align: center;" />
						</td>
						<td>
							<input type="text" id="listaTipoDocumentoID${status.count}" name="listaTipoDocumentoID" path="listaTipoDocumentoID" size="10" value="${documento.tipoDocumentoID}" disabled="disabled" style="text-align: center;"/>
							<textarea type="text" id="listaCreditoDescripcion${status.count}" name="listaCreditoDescripcion" path="listaCreditoDescripcion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "100" disabled="disabled">${documento.nombreDocumento}</textarea>
						</td>
						<td>
							<input type="text" id="listaEstatus${status.count}" name="listaEstatus" path="listaEstatus" value="${documento.estatus}" disabled="disabled" />
						</td>
						<td>
							<textarea type="text" id="listaUbicacion${status.count}" name="listaUbicacion" path="listaUbicacion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "500" disabled="disabled">${documento.ubicacion}</textarea>
						</td>
						<td>
							<input type="button" name="reporte" id="reporteCredito${status.count}" class="submit" value="Reporte" onclick="generaReporte(6,this.id)" tabindex="${status.count}"/>
						</td>
					</tr>
				</c:forEach>
			</table>
			<table align="center">
				<tr>
					<td>
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('primero', 7, 6)" type="button" id="primero" value="" class="btnPrimero" />
						</c:if>
					</td>
					<td >
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('anterior', 7, 6)" type="button" id="anterior" value="" class="btnAnterior" />
						</c:if>
					</td>
					<td>
						<c:if test="${totalPagina>1}">
							<label class="label">${numPagina}</label>
							<label class="label">/</label>
							<label class="label">${totalPagina}</label>
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('siguiente', 7, 6)" type="button" id="siguiente" value="" class="btnSiguiente" />
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('ultimo', 7, 6)" type="button" id="ultimo" value="" class="btnUltimo" />
						</c:if>
					</td>
				</tr>
			</table>
		</c:when>
		<c:when test="${tipoLista == '8'}">
			<legend class="ui-widget ui-widget-header ui-corner-all" id="labelTitulo">PROSPECTO</legend>
			<table id="miTabla" border="0" width="100%">
				<tr id="encabezadoLista">
					<td style="text-align: center;" id="lblDocumentoID">N&#250;mero</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Instrumento</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Documento</td>
					<td style="text-align: center;" id="lblEstatus" >Estatus</td>
					<td style="text-align: center;" id="lblUbicacion" >Ubicaci&oacute;n</td>
				</tr>
				<c:forEach items="${listaResultado}" var="documento" varStatus="status">
					<tr id="renglonProspecto${status.count}" name="renglon">
						<td>
							<input type="text" id="listaProspectoDocumentoID${status.count}" name="listaProspectoDocumentoID" path="listaProspectoDocumentoID" value="${documento.documentoID}" disabled="disabled" style="text-align: center;"/>
						</td>
						<td>
							<input type="text" id="listaNumeroInstrumento${status.count}" name="listaNumeroInstrumento" path="listaNumeroInstrumento" value="${documento.numeroInstrumento}" disabled="disabled" style="text-align: center;" />
						</td>
						<td>
							<input type="text" id="listaTipoDocumentoID${status.count}" name="listaTipoDocumentoID" path="listaTipoDocumentoID" size="10" value="${documento.tipoDocumentoID}" disabled="disabled" style="text-align: center;"/>
							<textarea type="text" id="listaProspectoDescripcion${status.count}" name="listaProspectoDescripcion" path="listaProspectoDescripcion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "100" disabled="disabled">${documento.nombreDocumento}</textarea>
						</td>
						<td>
							<input type="text" id="listaEstatus${status.count}" name="listaEstatus" path="listaEstatus" value="${documento.estatus}" disabled="disabled" />
						</td>
						<td>
							<textarea type="text" id="listaUbicacion${status.count}" name="listaUbicacion" path="listaUbicacion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "500" disabled="disabled">${documento.ubicacion}</textarea>
						</td>
						<td>
							<input type="button" name="reporte" id="reporteProspecto${status.count}" class="submit" value="Reporte" onclick="generaReporte(7, this.id)" tabindex="${status.count}"/>
						</td>
					</tr>
				</c:forEach>
			</table>
			<table align="center">
				<tr>
					<td>
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('primero', 8, 7)" type="button" id="primero" value="" class="btnPrimero" />
						</c:if>
					</td>
					<td >
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('anterior', 8, 7)" type="button" id="anterior" value="" class="btnAnterior" />
						</c:if>
					</td>
					<td>
						<c:if test="${totalPagina>1}">
							<label class="label">${numPagina}</label>
							<label class="label">/</label>
							<label class="label">${totalPagina}</label>
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('siguiente', 8, 7)" type="button" id="siguiente" value="" class="btnSiguiente" />
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('ultimo', 8, 7)" type="button" id="ultimo" value="" class="btnUltimo" />
						</c:if>
					</td>
				</tr>
			</table>
		</c:when>
		<c:when test="${tipoLista == '9'}">
			<legend class="ui-widget ui-widget-header ui-corner-all" id="labelTitulo">APORTACIONES</legend>
			<table id="miTabla" border="0" width="100%">
				<tr id="encabezadoLista">
					<td style="text-align: center;" id="lblDocumentoID">N&#250;mero</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Instrumento</td>
					<td style="text-align: center;" id="lblNombreDocumento" >Documento</td>
					<td style="text-align: center;" id="lblEstatus" >Estatus</td>
					<td style="text-align: center;" id="lblUbicacion" >Ubicaci&oacute;n</td>
				</tr>
				<c:forEach items="${listaResultado}" var="documento" varStatus="status">
					<tr id="renglonAportacion${status.count}" name="renglon">
						<td>
							<input type="text" id="listaAportacionDocumentoID${status.count}" name="listaAportacionDocumentoID" path="listaAportacionDocumentoID" value="${documento.documentoID}" disabled="disabled" style="text-align: center;"/>
						</td>
						<td>
							<input type="text" id="listaNumeroInstrumento${status.count}" name="listaNumeroInstrumento" path="listaNumeroInstrumento" value="${documento.numeroInstrumento}" disabled="disabled" style="text-align: center;" />
						</td>
						<td>
							<input type="text" id="listaTipoDocumentoID${status.count}" name="listaTipoDocumentoID" path="listaTipoDocumentoID" size="10" value="${documento.tipoDocumentoID}" disabled="disabled" style="text-align: center;"/>
							<textarea type="text" id="listaAportacionDescripcion${status.count}" name="listaAportacionDescripcion" path="listaAportacionDescripcion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "100" disabled="disabled">${documento.nombreDocumento}</textarea>
						</td>
						<td>
							<input type="text" id="listaEstatus${status.count}" name="listaEstatus" path="listaEstatus" value="${documento.estatus}" disabled="disabled" />
						</td>
						<td>
							<textarea type="text" id="listaUbicacion${status.count}" name="listaUbicacion" path="listaUbicacion" tabindex="${status.count}" COLS="28" ROWS="2"  onBlur=" ponerMayusculas(this)"  maxlength = "500" disabled="disabled">${documento.ubicacion}</textarea>
						</td>
						<td>
							<input type="button" name="reporte" id="reporteAportacion${status.count}" class="submit" value="Reporte" onclick="generaReporte(8,this.id)" tabindex="${status.count}"/>
						</td>
					</tr>
				</c:forEach>
			</table>
			<table align="center">
				<tr>
					<td>
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('primero', 9, 8)" type="button" id="primero" value="" class="btnPrimero" />
						</c:if>
					</td>	
					<td >
						<c:if test="${!listaPaginada.firstPage}">
							<input onclick="cargaGrid('anterior', 9, 8)" type="button" id="anterior" value="" class="btnAnterior" />
						</c:if>
					</td>
					<td>
						<c:if test="${totalPagina>1}">
							<label class="label">${numPagina}</label>
							<label class="label">/</label>
							<label class="label">${totalPagina}</label>
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('siguiente', 9, 8)" type="button" id="siguiente" value="" class="btnSiguiente" />
						</c:if>
					</td>
					<td>
						<c:if test="${!listaPaginada.lastPage}">
							<input onclick="cargaGrid('ultimo', 9, 8)" type="button" id="ultimo" value="" class="btnUltimo" />
						</c:if>
					</td>
				</tr>
			</table>
		</c:when>
	</c:choose>
</fieldset>