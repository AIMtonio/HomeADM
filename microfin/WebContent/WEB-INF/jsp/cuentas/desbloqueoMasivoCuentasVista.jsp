<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="js/cuentas/desbloqueoMasivoCatalogo.js"></script> 
</head>
<body>


<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Desbloqueo Masivo de Cuentas</legend>
	
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="DesbloqueoMasCtaBean" >
			<table border="0" cellpadding="0" cellspacing="0" width="100%">		
				<tr>
					<td colspan="6" align="right"><label>Fecha Actual:</label>
					<td >
						<input type="text" id="fechaBlo" name="fechaBlo" size="12" tabindex="1" readOnly="true" disabled = "true"/>  
					</td>
				</tr>		
				<tr>
					<td class="label" colspan="6">
						<DIV class="label">
							<label> 
								<br>
	                               Este proceso realiza el Desbloqueo Autom&aacute;tico de Saldo de las Cuentas de Ahorro.
							  	<br>
							        El Desbloqueo Aplica para los Tipos de Cuenta que as&iacute; lo Especifican. 
						      	<br>
						      	<br>
							  	<br>
							  	<br>
							</label>
						</DIV>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="numeroCuenta">Total de Cuentas a Desbloquear:</label>
					</td>
					<td class="separador"></td>
					<td>
						<input type="text" size="11" name="numeroCuenta" id="numeroCuenta"  readonly="true"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="monto"> Monto a Desbloquear:</label>
					</td>
					<td class="separador"></td>
					<td>
						<input type="text" size="20" name="saldo" id="saldo" readonly="true" />
					</td>
				</tr>
				<tr>		
					<td colspan="7"  align="right">
						<input type="submit" id="desbloquear" name="desbloquear" class="submit" value="Desbloquear" tabindex="2"  />		
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>		
				</tr>
			</table>
		</form:form>
	</fieldset>	
</div>
<div id="cargando" style="display: none;">	
</div>				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>