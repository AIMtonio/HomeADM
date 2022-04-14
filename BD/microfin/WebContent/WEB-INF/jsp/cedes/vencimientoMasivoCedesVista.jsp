<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="js/cedes/vencimientoMasivoCedes.js"></script> 
	</head>
<body> 

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cedesBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Vencimientos Masivo de CEDES</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	 	<tr>
	 		<td class="label">
				<label for="lblFechaActual">Fecha Actual:</label>
				<form:input id="fechaInicio" name="fechaInicio" tabindex="1" path="fechaInicio" size="10" disabled="true"/>
			</td>
		</tr>
		<tr>
			<table id="descrip proceso Batch">
				<tr>
					<td class="label">
						<div class="label">
							<label> 
								<br>
									Este proceso realiza las siguientes operaciones:
								<br>
									Vencimiento de CEDES
						   		<br>
									Pago de Capital + Intereses
						   		<br>
									Retención de ISR
						   		<br>
									Reinversión automática de CEDES (Sólo Capital ó Capital + Intereses)
						   		<br>						
							</label>
						</div>
					</td>
				</tr>
			</table>
		</tr>
	</table>
		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="4" onclick="return confirmar()"/>
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