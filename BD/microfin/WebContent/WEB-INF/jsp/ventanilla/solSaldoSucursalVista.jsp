<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head> 
		<script type="text/javascript" src="dwr/interface/solSaldoSucursalServicio.js"></script>
		<script type="text/javascript" src="js/ventanilla/solSaldoSucursal.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solSaldoSucursalBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Solicitud de Saldos por Sucursal</legend>			
	<table border="0"  width="100%">
	 	<tr>
	 		<td class="label" nowrap="nowrap">
	 			<label for="lblUsuario">Usuario: </label>
	 		</td>
			<td>
				<form:input id="usuarioID" name="usuarioID" path="usuarioID" size ="11" readOnly="true" disabled="true"/>
				<input type="text" id="nomUsuario" name="nomUsuario" size="36" readOnly="true" disabled="true"/>
	 		</td>
		</tr>

		<tr>
 			<td class="label" nowrap="nowrap">
 				<label for="lblSucursal">Sucursal: </label>
	 		</td>
			<td>
				<form:input id="sucursalID" name="sucursalID" path="sucursalID" size ="11" readOnly="true" disabled="true"/>
				<input type="text" id="nomSucursal" name="nomSucursal" size="36" readOnly="true" disabled="true"/>
	 		</td>
		</tr>
		<tr height="20px">
		</tr>
	</table>

	<table border="0"  width="100%">
		<tr>
			<td></td>
			<td class="label" nowrap="nowrap">
 				<label for="lblCantidad">Cantidad </label> 				
	 		</td>
	 		<td class="label" nowrap="nowrap">
 				<label for="lblMonto">Monto </label>
	 		</td>
			<td class="separador"></td>
			<td></td>
	 		<td class="label" nowrap="nowrap">
 				<label for="lblMonto">Monto </label>
	 		</td>
		</tr>

		<tr>
			<td class="label" nowrap="nowrap">
 				<label for="lblCreDesem">Cr&eacute;ditos Por Desembolsar: </label>
	 		</td>
			<td nowrap="nowrap">
	 			<input type="text" id="canCreDesem" name="canCreDesem" size="11" readOnly="true" disabled="true" style="text-align: right" />
	 		</td>
	 		<td nowrap="nowrap">
	 			<input type="text" id="monCreDesem" name="monCreDesem" size="25" readOnly="true" disabled="true" esmoneda="true" style="text-align: right"/>
	 		</td>
	 		<td class="separador"></td>
	 		<td class="label" nowrap="nowrap">
 				<label for="lblSaldosCP">Saldos en Caja Principal: </label>
	 		</td>
	 		<td nowrap="nowrap">
	 			<input type="text" id="saldosCP" name="saldosCP" size="25" readOnly="true" disabled="true" esmoneda="true" style="text-align: right"/>
	 		</td>
		</tr>
		
		<tr>
			<td class="label" nowrap="nowrap">
 				<label for="lblInverVenci">Inversiones Por Vencer Hoy: </label>
	 		</td>
			
			<td nowrap="nowrap">
	 			<input type="text" id="canInverVenci" name="canInverVenci" size="11" readOnly="true" disabled="true" style="text-align: right"/>
	 		</td>
	 		<td nowrap="nowrap">
	 			<input type="text" id="monInverVenci" name="monInverVenci" size="25" readOnly="true" disabled="true" esmoneda="true" style="text-align: right"/>
	 		</td>

	 		<td class="separador"></td>
	 		<td class="label" nowrap="nowrap">
 				<label for="lblSaldosCA">Saldos en Cajas Atenci&oacute;n: </label>
	 		</td>
	 		<td nowrap="nowrap">
	 			<input type="text" id="saldosCA" name="saldosCA" size="25" readOnly="true" disabled="true" esmoneda="true" style="text-align: right"/>
	 		</td>
		</tr>

		<tr>
			<td class="label" nowrap="nowrap">
 				<label for="lblChequeEmi">Cheques Emitidos Tr&aacute;nsito: </label>
	 		</td>
			<td nowrap="nowrap">
	 			<input type="text" id="canChequeEmi" name="canChequeEmi" size="11" readOnly="true" disabled="true" style="text-align: right" />
	 		</td>
	 		<td nowrap="nowrap">
	 			<input type="text" id="monChequeEmi" name="monChequeEmi" size="25" readOnly="true" disabled="true" esmoneda="true" style="text-align: right"/>
	 		</td>
		</tr>

		<tr>
			<td class="label" nowrap="nowrap">
 				<label for="lblChequeIntReA">Cheques Internos Recibidos D&iacute;a Anterior: </label>
	 		</td>
			<td nowrap="nowrap">
	 			<input type="text" id="canChequeIntReA" name="canChequeIntReA" size="11" readOnly="true" disabled="true" style="text-align: right" />
	 		</td>
	 		<td nowrap="nowrap">
	 			<input type="text" id="monChequeIntReA" name="monChequeIntReA" size="25" readOnly="true" disabled="true" esmoneda="true" style="text-align: right"/>
	 		</td>
		</tr>

		<tr>
			<td class="label" nowrap="nowrap">
 				<label for="lblChequeIntRe">Cheques Internos Recibidos Hoy: </label>
	 		</td>
			<td nowrap="nowrap">
	 			<input type="text" id="canChequeIntRe" name="canChequeIntRe" size="11" readOnly="true" disabled="true" style="text-align: right" />
	 		</td>
	 		<td nowrap="nowrap">
	 			<input type="text" id="monChequeIntRe" name="monChequeIntRe" size="25" readOnly="true" disabled="true" esmoneda="true" style="text-align: right"/>
	 		</td>
		</tr>

		<tr height="30px">
		</tr>

		<tr>
			<td class="label" nowrap="nowrap">
 				<label for="lblMontoSolicitado">MONTO SOLICITADO: </label>
	 		</td>
	 		<td></td>
			<td nowrap="nowrap">
	 			<input type="text" id="montoSolicitado" name="montoSolicitado" size="25"  esmoneda="true" style="text-align: right"/>
	 		</td>
		</tr>

		<tr height="15px">
		</tr>

		<tr>
			<td class="label" nowrap="nowrap">
 				<label for="lblComentarios">Comentarios: </label>
	 		</td>			
		</tr>
		<tr>
			<td nowrap="nowrap" colspan="3">
				<textarea id="comentarios" name="comentarios" rows="3" cols="70" maxlength="300" onblur="ponerMayusculas(this);"></textarea>
			</td>
		</tr>
		<tr>
			<td class="label" nowrap="nowrap" colspan="3" style="text-align: right">
				<label for="lblCaracteres" id="lblCaracteres">Caracteres 0/300</label>
			</td>
		</tr>
	</table>

	<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false"/>
			</td>
		</tr>
	</table>

	</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>