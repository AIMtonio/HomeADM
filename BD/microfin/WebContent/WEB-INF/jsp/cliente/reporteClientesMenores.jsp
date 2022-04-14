<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%><html>
<head>
<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="js/cliente/reporteClientesMenores.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repoteClientesMenoresBean" target="_blank">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all"><s:message code="safilocale.cteMen"/></legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="sucursalOrigen">Sucursal: </label>
			</td>
			<td>
				<form:select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="1">
				<form:option value="0">TODAS</form:option>
				</form:select>
			</td>
		</tr>
		
		<tr>
			<td class="label" nowrap="nowrap">
				<label>Estatus Cuenta: </label>
			</td>
			<td>
				<form:select id="estatusCta" name="estatusCta" path="estatusCta" tabindex="2">
					<form:option value="">TODOS</form:option>
					<form:option value="A">ACTIVA</form:option>
					<form:option value="B">BLOQUEADA</form:option>
					<form:option value="C">CANCELADA</form:option>
					<form:option value="I">INACTIVA</form:option>
					<form:option value="R">REGISTRADA</form:option>
				</form:select>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="promotorActual">Promotor Actual:</label>
			</td>
			<td>
				<form:input id="promotorActual" name="promotorActual" path="promotorActual" size="6" tabindex="3" />
				<input type="text" id="nombrePromotor" name="nombrePromotor" size="30" tabindex="61" disabled="true" readOnly="true"/>
			</td>	
		</tr>
		<tr>
			<td>
				<form:input type="hidden" name="nombreInstitucion" id="nombreInstitucion" path="nombreInstitucion" size="30" />
		   		<form:input type="hidden" name="usuario" id="usuario" path="usuario" size="30" />
		   		<form:input type="hidden" name="fechaSistema" id="fechaSistema" path="fechaSistema" size="12" />								 			 	  
			</td>
		</tr>
		<tr>
			<td class="label">
			<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Presentación: </label></legend>
					<input type="radio" id="excel" name="excel" /" tabindex="10">
					<label> Excel </label><br> 	
						<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="11">
					<label> PDF </label>
				</fieldset>
			</td>
		</tr>		
					
		<tr>		
			<td colspan="5">
			</br>
				<table align="right" border='0'>
					<tr>
						<td width="350px">
								&nbsp;					
						</td>								
						<td align="right">
							<input type="button" id="generar" name="generar" class="submit"
									 tabindex="12" value="Generar" />
						</td>
					</tr>
				</table>		
			</td>
		</tr>
	</table>
</fieldset>
</form:form>
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
</html>