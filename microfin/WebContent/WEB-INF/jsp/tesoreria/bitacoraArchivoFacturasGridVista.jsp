<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaBitacoraCarga[0]}" />
<c:set var="listaPaginada" value="${listaBitacoraCarga[1]}" />
<c:set var="listaResultado" value="${listaPaginada.pageList}"/>

<br>
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<legend id="labelTitulo">Facturas Cargadas</legend>
				<table  width="100%">
						<tr id="encabezadoLista">
							<td align="center">Número</td>
							<td align="center">ID SAFI</td>
							<td align="center"> RFC</td>
							<td align="center"> Nombre/Razón Social</td>
							<td align="center"> Total Factura</td>
							<td align="center"> Fecha Emisión</td>
							<td align="center">UUID</td>
							<td align="center">Folio Factura</td>
						</tr>
						<tr>
							<td colspan="8" style="text-align:right;">
								<label>Seleccionar Todos</label>
							</td>
							<td align="center">
								<input type="checkbox" id="selecTodos" name="selecTodos" value="N" onclick="seleccionarTodos(this.id)"/>
							</td>
						</tr>
					<c:forEach items="${listaResultado}" var="bitacoraArchivo" varStatus="status">
						<tr>
							<td>
								<label for="consecutivoID" id="consecutivoID${status.count}"  name="consecutivoID" size="11" >
									${bitacoraArchivo.consecutivo}
								</label>
							</td>
							<td>
								<label for="consecutivoID" id="consecutivoID${status.count}"  name="consecutivoID" size="11" >
									${bitacoraArchivo.safiID}
								</label>
							</td>
							<td>
								<label for="lrfc" id="lrfc${status.count}"  name="lrfc" size="16" >
									${bitacoraArchivo.rfcEmisor}
								</label>
							</td>
							<td>
								<label for="lnombre" id="lnombre${status.count}"  name="lnombre" size="16" >
									${bitacoraArchivo.nombreEmisor}
								</label>
							</td>
							<td align="right">
								<label for="ltotalFactura" id="ltotalFactura${status.count}"  name="ltotalFactura" size="16" >
									${bitacoraArchivo.total}
								</label>
							</td>
							<td  align="center">
								<label for="lfechaEmision" id="lfechaEmision${status.count}" name="lfechaEmision" size="50">
									${bitacoraArchivo.fechaEmision}
								</label>
							</td>
							<td>
								<label for="luuid" id="luuid${status.count}"  name="luuid" size="1" >
									${bitacoraArchivo.UUID}
								</label>
							</td>
							<td align="right">
								<label for="luuid" id="luuid${status.count}"  name="luuid" size="1" >
									${bitacoraArchivo.folio}
								</label>
							</td>
							<td align="center">
								<input type="hidden" id="estatus${status.count}" name="estatus" size="8" value="${bitacoraArchivo.estatus}"  />
								<input type="hidden" id="lfolioCargaID${status.count}" name="lfolioCargaID" size="8" value="${bitacoraArchivo.folioFacturaID}" />
								<input type="checkbox" id="seleccionadoCheck${status.count}" name="seleccionadoCheck" onclick="seleccionIndividual(this.id,'estatus${status.count}');" value="${bitacoraArchivo.seleccionadoCheck}"/>
							</td>
						</tr>
					</c:forEach>
				</table>
				<c:if test="${!listaPaginada.firstPage}">
					 <input onclick="consultaBitacoraExito('previous', '1')" type="button" value="" class="btnAnterior" />
				</c:if>
				<c:if test="${!listaPaginada.lastPage}">
					 <input onclick="consultaBitacoraExito('next', '1')" type="button" value="" class="btnSiguiente" />
				</c:if>
			</fieldset>
		</c:when>

		<c:when test="${tipoLista == '2'}">
			<legend>Notificaci&oacute;n de Errores en la Carga</legend>
			<div id="datosResultado"></div>
				<table  width="100%">
						<tr id="encabezadoLista">
							<td align="center">Num.</td>
							<td align="center">Folio Carga</td>
							<td align="center">UUID</td>
							<td align="center"> RFC Emisor</td>
							<td align="center"> Nombre Emisor</td>
							<td align="center"> Total Factura</td>
							<td align="center"> Motivo Rechazo</td>

						</tr>
					<c:forEach items="${listaResultado}" var="bitacoraArchivo" varStatus="status">
						<tr>
							<td>
								<label for="folioCargaID" id="folioCargaID${status.count}"  name="folioCargaID" size="11" >
									${bitacoraArchivo.consecutivo}
								</label>
							</td>
							<td>
								<label for="folioCargaID" id="folioCargaID${status.count}"  name="folioCargaID" size="11" >
									${bitacoraArchivo.folioCargaID}
								</label>
							</td>
							<td>
								<label for="UUID" id="UUID${status.count}"  name="UUID" size="1" >
									${bitacoraArchivo.UUID}
								</label>
							</td>
							<td>
								<label for="rfcEmisor" id="irfcEmisor${status.count}"  name="rfcEmisor" size="16" >
									${bitacoraArchivo.rfcEmisor}
								</label>
							</td>
							<td>
								<label for="nombreEmisor" id="nombreEmisor${status.count}"  name="nombreEmisor" size="16" >
									${bitacoraArchivo.nombreEmisor}
								</label>
							</td>
							<td>
								<label for="total" id="total${status.count}"  name="total" size="16" >
									${bitacoraArchivo.total}
								</label>
							</td>
							<td>
								<label for="descripcion" id="descripcion${status.count}" name="descripcion" size="50">
									${bitacoraArchivo.descripcionError}
								</label>
							</td>

						</tr>
					</c:forEach>
				</table>
				<c:if test="${!listaPaginada.firstPage}">
					 <input onclick="consultaBitacora('previous', '2')" type="button" value="" class="btnAnterior" />
				</c:if>
				<c:if test="${!listaPaginada.lastPage}">
					 <input onclick="consultaBitacora('next', '2')" type="button" value="" class="btnSiguiente" />
				</c:if>
			</fieldset>
		</c:when>


	</c:choose>
</fieldset>


<script type="text/javascript">
function consultaBitacora(pageValor, tipoLista){
	var params = {};
	params['tipoLista'] =  tipoLista;
	params['folioCargaID'] = $('#folioCargaID').val();
	params['page'] = pageValor ;
	params['nombreLista'] = "ListaCargaMasiva2";
	$.post("bitArchivoFacturaGrid.htm", params, function(data){
		if(data.length >0) {
			$('#gridBitacoraCargaArchivo').html(data);
			$('#gridBitacoraCargaArchivo').show();

		}else{
			$('#gridBitacoraCargaArchivo').html("");
			$('#gridBitacoraCargaArchivo').show();
		}
	});

}

</script>