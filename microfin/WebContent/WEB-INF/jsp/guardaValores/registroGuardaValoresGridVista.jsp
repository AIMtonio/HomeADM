<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<br>
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all" id="labelTitulo">Documentos</legend>
	<table border="0" width="100%">
		<tr>
			<td colspan="5">
				<table align="left">
					<tr>
						<td align="left">
							<input type="button" id="agregaEsquema" value="Agregar" class="submit" tabIndex="7" onClick="agregaNuevoEsquema()"/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<table id="miTabla" border="0" width="100%">
		<tr id="encabezadoLista">
			<td style="text-align: center;" id="lblDocumentoID">N&#250;mero</td>
			<td style="text-align: center;" id="lblOrigenDocumento" >Origen Documento</td>
			<td style="text-align: center;" id="lblTipoDocumento" >Tipo Documento</td>
			<td style="text-align: center;" id="lblDocumento" >Documento</td>
			<td style="text-align: center;" id="lblEstatus" >Estatus</td>
		</tr>
	</table>
</fieldset>