<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/usuariosServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/cuentasOrigenServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/perfilServicio.js"></script> 
	
	<script type="text/javascript" src="js/bancaMovil/cuentasOrigenCatalogo.js"></script>
	
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasOrigen">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Cuentas Origen Cargo</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label">
							<label for="ClienteID">No. de cliente:</label>
						</td>
						<td>
							<form:input id="clienteID" name="clienteID" path="clienteID" size="10" maxlength="14"  tabindex="1"  />
							<input id="nombreCliente" name="nombreCliente" disabled="true" readOnly="true" path="nombreCliente" size="49" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="telefono">Tel&eacute;fono:</label>
						</td>
						<td>
							<input id="telefono" name="telefono" disabled="true" readOnly="true" path="telefono" maxlength="20" size="15" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="clienteID">Email:</label>
						</td>
						<td>
							<input id="email" name="email" path="email" size="30" disabled="true"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="estatus">Estatus:</label>
						</td>
						<td>
							<input id="estatus" name="estatus" path="estatus"  disabled="true" readOnly="true" size="15"   />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="perfilID">Perfil:</label>
						</td>
						<td>
							<input id="perfilID" name="perfilID" path="perfilID" disabled="true" readOnly="true" size="14"   />
							<input id="nombrePerfil" name="nombrePerfil" path="nombrePerfil" disabled="true" readOnly="true" size="30" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="fechaCreacion">Fecha de Registro:</label>
						</td>
						<td>
							<input id="fechaCreacion" name="fechaCreacion" path="fechaCreacion" disabled="true" readOnly="true" size="15"/>
						</td>
					</tr>
					<!-- <tr>
						<td colspan="2">
							<div id="gridCuentas" style="display: none;"/>							
						</td>
					</tr> -->										
				</table>
				<input type="hidden" size="70" name="cuentaAhoID" id="cuentaAhoID"/>	

				<fieldset class="ui-widget ui-widget-content ui-corner-all" id ="gridCuenta">		
				<legend >Cuentas</legend>
					<table>
					<tr>
						<td colspan="2">
							<div id="gridCuentas" style="display: none;"/>							
						</td>
					</tr>
				</table>
				</fieldset>
				
				
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
										
					<tr align="right">
							<td >
							</td>
							<td >
							</td>
							<td>
							</td>
							<td>
							</td>
							<td align="right">
										<input type="submit" tabindex="88" id="agregarCuen" name="agregarCuen" class="submit" value="Grabar" />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						</td>	
					</tr>			
				</table>
				

				</fieldset>		
					
		</form:form>
	</div>
</body>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
<div id="mensaje" style="display: none;"></div>
</html>