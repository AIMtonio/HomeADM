<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/empleadosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/puestosRelacionadoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/relacionEmpleadoClienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="js/cliente/relacionEmpleadoCliente.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="relacionEmpleadoClienteBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all"> Relacionados Persona </legend>
				<table>
					<tr>
						<td class="label">
							<label for="Campania">Relacionado:</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="empleadoID" name="empleadoID" path="empleadoID" size="15" autocomplete="off" tabindex="1" />
							<input type="text" id="nombreEmpleado" name="nombreEmpleado" autocomplete="off" onBlur="ponerMayusculas(this)" path="nombreEmpleado" size="50" tabindex="2" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="Campania">Puesto:</label>
						</td>
						<td>
							<input id="puestoEmpleadoID" name="puestoEmpleadoID" size="12" autocomplete="off" tabindex="3" /> <input type="text" id="descPuestoEmpleadoID" name="descPuestoEmpleadoID" autocomplete="off" path="descPuestoEmpleadoID" size="50" readonly="true" disabled="true" tabindex="4" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label id="rFC" for="rFC"> RFC:</label>
						</td>
						<td>
							<form:input id="RFCEmpleado" name="RFCEmpleado" path="RFCEmpleado" autocomplete="off" tabindex="5" size="25" onBlur=" ponerMayusculas(this)" maxlength="13" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="CURP">CURP:</label>
						</td>
						<td>
							<form:input id="CURPEmpleado" name="CURPEmpleado" path="CURPEmpleado" autocomplete="off" tabindex="6" size="25" onBlur=" ponerMayusculas(this)" maxlength="18" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="porcAcciones">Porcentaje Acciones:</label>
						</td>
						<td nowrap="nowrap">
							<form:input id="porcAcciones" name="porcAcciones" path="porcAcciones" autocomplete="off" tabindex="7" size="20" onBlur=" ponerMayusculas(this)" maxlength="6" />
							<label for="porcAcciones"> %</label>
						</td>
					</tr>
				</table>
				<table>
					<tr>
						<td colspan="11">
							<div id="gridRelaciones" style="display: none;" />
						</td>
					</tr>
				</table>
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="1001" /> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" /> <input type="hidden" id="varSafilocale" name="varSafilocale" value="<s:message code="safilocale.cliente"/>" />
						</td>
					</tr>
				</table>
				<input type="hidden" size="500" name="lisEmpleados" id="lisEmpleados" /> <input type="hidden" size="500" name="lisParentesco" id="lisParentesco" /> <input type="hidden" size="500" name="lisClientes" id="lisClientes" /> <input type="hidden" size="500" name="lisNomClientes" id="lisNomClientes" /> <input type="hidden" size="500" name="lisPuestos" id="lisPuestos" /> <input type="hidden" size="500" name="lisCURP" id="lisCURP" /> <input type="hidden" size="500" name="lisRFC" id="lisRFC" />
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista" />
	</div>
	<div id="cajaListaCte" style="display: none; overflow-y: scroll; height: 200px;">
		<div id="elementoListaCte"></div>
	</div>
</body>
<div id="mensaje" style="display: none;" />
</html>
