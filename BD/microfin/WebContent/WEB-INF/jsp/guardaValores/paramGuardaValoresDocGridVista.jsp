<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<div id="paramGuardaValoresGrid" style="width:100%;">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<c:choose>
			<c:when test="${tipoLista == '3'}">
				<legend>Documentos</legend>
				<table border="0" width="100%">
					<tr>
						<td colspan="5">
							<table align="left">
								<tr>
									<td align="left">
										<input type="button" id="agregaEsquemaDocumento" value="Agregar" class="submit" tabIndex="19" onClick="agregaNuevoEsquemaDoc()"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<br>
				<table id="tablaDocumentos" border="0" width="100%">
					<tr id="encabezadoLista">
						<td style="text-align: center;" id="lblPuesto">Tipo Documento</td>
						<td style="text-align: center;" id="lblNombrePuesto">Nombre Documento</td>
					</tr>
					<c:forEach items="${listaResultado}" var="esquema" varStatus="status">
						<tr id="renglonDoc${status.count}" name="renglonDoc">
							<input type="hidden" id="consecutivoID${status.count}"  name="consecutivoID" size="3" value="${status.count}" readOnly="true" disabled="true"/>
							<td>
								<input type="text" id="documentoID${status.count}" name="listaDocumentoID" path="listaDocumentoID" value="${esquema.documentoID}" tabindex="20" onkeyPress="listaDocumentos(this.id)" onblur="validarDocumento(this.id)" size="18"  maxlength="30"  autocomplete="off" width="30%" />
							</td>
							<td>
								<input type="text" id="nombreDocumento${status.count}" name="listaNombreDocumento" path="listaNombreDocumento" value="${esquema.nombreDocumento}"  size="124" maxlength="100" autocomplete="off" disabled="true" width="0%" />
							</td>
							<td>
								<input type="button" name="agregaDoc" id="agregaDoc${status.count}" value="" class="btnAgrega" onclick="agregaNuevoEsquemaDoc(this.id)"/>
								<input type="button" name="eliminaDoc" id="eliminaDoc${status.count}" value="" class="btnElimina" onclick="eliminarEsquemaDocumento(this.id);"/>
							</td>
						</tr>
					</c:forEach>
				</table>
			</c:when>
		</c:choose>
	 </fieldset>
</div>
<script type="text/javascript">
	esTab=true;

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

</script>