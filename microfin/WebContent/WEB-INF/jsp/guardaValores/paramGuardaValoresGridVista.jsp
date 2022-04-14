<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<div id="paramGuardaValoresGrid" style="width:100%;">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<c:choose>
			<c:when test="${tipoLista == '2'}">
				<legend>Facultados</legend>
				<table border="0" width="100%">
					<tr>
						<td colspan="5">
							<table align="left">
								<tr>
									<td align="left">
										<input type="button" id="agregaEsquema" value="Agregar" class="submit" tabIndex="19" onClick="agregaNuevoEsquema()"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<br>
				<table id="miTabla" border="0" width="100%">
					<tr id="encabezadoLista">
						<td style="text-align: center;" id="lblPuesto">Puesto</td>
						<td style="text-align: center;" id="lblNombrePuesto">Nombre Puesto</td>
						<td style="text-align: center;" id="lblUsuario">Usuario</td>
						<td style="text-align: center;" id="lblNombreUsuario">Nombre Usuario</td>
					</tr>
					<c:forEach items="${listaResultado}" var="esquema" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<input type="hidden" id="consecutivoID${status.count}"  name="consecutivoID" size="3" value="${status.count}" readOnly="true" disabled="true"/>
							<td>
								<input type="text" id="puestoFacultado${status.count}" name="lisPuestoFacultado" path="lisPuestoFacultado" value="${esquema.puestoFacultado}" tabindex="20" onkeyPress="listaPuestos(this.id)" onblur="validarPuestoFacultado(this.id)" size="10" value="" maxlength="11"  autocomplete="off" />
							</td>
							<td>
								<input type="text" id="nombrePuestoFacultado${status.count}" name="lisNombrePuestoFacultado" path="lisNombrePuestoFacultado" value="${esquema.nombrePuestoFacultado}" readOnly="true" size="60" maxlength="100" autocomplete="off" disabled="true" />
							</td>
							<td>
								<input type="text" id="usuarioFacultadoID${status.count}" name="lisUsuarioFacultadoID" path="lisUsuarioFacultadoID" value="${esquema.usuarioFacultadoID}"  tabindex="22" onkeyPress="listaUsuariosRol(this.id)" onblur="validaUsuarioFacultado(this.id)" size="10" maxlength="11"  autocomplete="off" />
							</td>
							<td>
								<input type="text" id="nombreUsuarioFacultado${status.count}" name="lisNombreUsuarioFacultado" path="lisNombreUsuarioFacultado" value="${esquema.nombreUsuarioFacultado}" readOnly="true" size="60" maxlength="100" autocomplete="off"  disabled="true"/>
							</td>
							<td>
								<input type="button" name="agregaE" id="agregaE${status.count}" value="" class="btnAgrega" onclick="agregaNuevoEsquema();"/>
								<input type="button" name="elimina" id="${status.count}" value="" class="btnElimina" onclick="eliminarEsquema(this.id)"/>
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