<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
</br>
<c:set var="ciclo" value="1" />
<div id="TiposCuenta" style="width: 100%;">
	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Tipos
			de Cuentas</legend>
		<table border="0" width="100%">
			<tr>
				<td colspan="5">
					<table align="left">
						<tr>
							<td align="left"><input type="button" id="agregaTipoCta"
								value="Agregar" class="submit" tabindex="25"
								onClick="agregaNuevaTiposCta()" /></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br>
			<table id="tablaTiposCta">
				<tr id="encabezadoLista">
					<td>Tipo Cuenta</td>
					<td nowrap="nowrap">Descripción</td>

				</tr>
				<c:forEach items="${tiposCuentaList}" var="tiposCuenta"
					varStatus="status">
					<tr id="renglonTiposCta${status.count}" name="renglonTiposCta">
						<td><input type="text" size="25" name="lisTiposCta"
							id="tiposCuentaID${status.count}"
							value="${tiposCuenta.tipoCuentaID}" style="text-align: center"  onkeypress="listaTipoCtas(this.id)"onblur="consultaTipoCuentaAyuda(this.id)" tabindex="26" />
						</td>
						<td>
							<input type="text" size="25" name="descripcion"
								id="descripcion${status.count}"
								value="${tiposCuenta.descripcion}" style="text-align: left" readOnly="true" />
						</td>
						<td>
							<input type="button" name="agregaT" id="agregaT${status.count}"class="btnAgrega" onclick="agregaNuevaTiposCta()" tabindex="27" />
							<input type="button" name="eliminaT" id="eliminaT${status.count}"class="btnElimina" onclick="eliminarTipoCta(this.id);" style="text-align: right"  tabindex="28" />
						</td>

					</tr>
				</c:forEach>
			</table> <input type="hidden" value="0" name="numeroTiposCta"
			id="numeroTiposCta" tabindex="29" />
	</fieldset>

</div>
</br>

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