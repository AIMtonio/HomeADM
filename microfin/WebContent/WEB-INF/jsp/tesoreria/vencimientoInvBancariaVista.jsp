<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="js/tesoreria/vencimientoInvBancaria.js"></script>  
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="invBancariaBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Vencimientos de Inversiones Bancarias</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	 	<tr>
	 		<td class="label">
				<label for="lblFechaActual">Fecha Actual:</label>
				<form:input id="fechaSistema" name="fechaSistema" tabindex="1" path="fechaSistema" size="10" disabled="true"/>
			</td>
		</tr>
		<tr>
			<table id="descrip proceso Batch">
				<tr>
					<td class="label">
						<DIV class="label">
							<label> 
								<br>
									Este proceso realiza el Vencimiento (Pago) de las Inversiones Bancarias:
								<br>
									Proceso Contable
						   		<br>
									Afectación a la Cuenta Operativa de Bancos
						   		<br>
									Movimientos de Pago de la Inversión
						   		<br>						
							</label>
						</DIV>
					</td>
				</tr>
			</table>
		</tr>
	</table>
		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="4"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				</td>
			</tr>
		</table>	
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