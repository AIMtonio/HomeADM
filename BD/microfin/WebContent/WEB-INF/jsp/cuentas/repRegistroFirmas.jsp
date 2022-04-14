<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
	<head>			
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>		
		<script type="text/javascript" src="js/cuentas/repCuentasCliente.js"></script>
	</head>   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cliente" target="_blank">


<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Cuentas por <s:message code="safilocale.cliente"/></legend>
					
			<table border="0" cellpadding="0" cellspacing="0" width="600px">
				<tr>
					<td class="label">
						<label for="clienteID"><s:message code="safilocale.cliente"/>: </label>
					</td>
					<td >
						<form:input id="numero" name="numero" path="numero" size="11"  iniForma = "false"  tabindex="1" />
						<form:input id="nombreCliente" name="nombreCliente" path="nombreCompleto" readOnly="true"
										size="70" tabindex="2" class="desplegado"/>
					</td>					
				</tr>
				<tr>
					<td class="label">
						<label for="RFC">RFC: </label>
					</td>
					<td class="label">
						<form:input id="RFC" name="RFC" path="RFC" size="20" tabindex="3" disabled="true" readOnly="true"/>
						<label for="telefono">Telefono: </label>
						<input type="text" id="telefonoCasa" name="telefonoCasa" size="20" tabindex="4"
								 disabled="true" readOnly="true"/>
					</td>					
				</tr>								
				<tr>
					<td colspan="2">
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="consultarRep" name="consultarRep" class="submit" value="Pantalla" />
								</td>
							</tr>
						</table>		
					</td>
				</tr>	
			</table>
</fieldset>
</form:form>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</html>