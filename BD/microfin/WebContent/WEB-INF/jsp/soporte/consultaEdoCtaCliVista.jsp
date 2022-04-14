<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="js/soporte/consultaEdoCtaCliVista.js"></script>
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="edoCtaEnvioCorreoBean"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Consulta de Estados de Cuentas Por Cliente</legend>
					<table border="0" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
						<tr id="buscarPorCliente" style="display: none;">
							<td rowspan="2" ><label for="clienteID"><s:message code="safilocale.cliente"/>: </label> </td>
							<td class="separador"></td>
							<td rowspan="2">
								<input type="text" id="clienteID" name="clienteID" size="10" iniForma='false' tabindex="4" maxlength="10" autocomplete="off"/>
								<input type="text" id="nombreCliente" name="nombreCliente" size="60" iniForma='false' readOnly="true" disabled="true" />
							</td>
						</tr>
						
						<tr>
							<td colspan="3" align=right>
								<input type="button" id="buscar" name="buscar" class="submit" value="Buscar" tabindex="5" style="display: none;"/>
							</td>
						</tr>
					</table>
					
					<div id="formaTabla" style="display: none;"></div>
					
					<table border="0" width="100%"> 
						<tr>
							<td align="right">
								<input type="hidden" id="tipoUsuario" value="<s:message code='safilocale.cliente'/>"/>
								<input type="hidden" id="tipoLista" name="tipoLista" value=""/>
							</td>
						</tr>
					</table>
			</fieldset>
		</form:form>
	</div>
	
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>