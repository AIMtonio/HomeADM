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
		<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
		<script type="text/javascript" src="js/cliente/relacionesCliente.js"></script>  
	</head>
	<body>

		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="relacionClienteBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend class="ui-widget ui-widget-header ui-corner-all"> <s:message code="safilocale.clientesRelacion"/> </legend>			
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
	 						<td class="label">
								<label for="Campania"><s:message code="safilocale.cliente"/>:</label>
							</td>
							<td nowrap="nowrap">
								<form:input id="clienteID" name="clienteID" path="clienteID" size="15" tabindex="1"/>
								<input id="nombreCliente" name="nombreCliente" size="50" disabled="true"/>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<div id="gridRelaciones" style="display: none;"/>
							</td>
						</tr>
					</table>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="1001"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								<input type="hidden" id="varSafilocale" name="varSafilocale" value="<s:message code="safilocale.cliente"/>"/>
							</td>
						</tr>
					</table>
					<input type="hidden" size="500" name="lisEmpleados" id="lisEmpleados"/>
					<input type="hidden" size="500" name="lisParentesco" id="lisParentesco"/>
					<input type="hidden" size="500" name="lisClientes" id="lisClientes"/>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
		<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>		
	</body>
	<div id="mensaje" style="display: none;"/>
</html>