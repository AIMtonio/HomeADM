<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
      	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      	
		<script type="text/javascript" src="js/soporte/repRelFiscalesRetencion.js"></script>
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="relacionadosFiscalesBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Relacionados Fiscales Retención</legend>
				<table>
					 <tr>
					 	<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend><label>Par&aacute;metros</label></legend>
			        	 	<table>
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="ejercicio">Ejercicio:</label>
									</td>
					 				<td nowrap="nowrap">
										<form:select id="ejercicio" name="ejercicio" path="ejercicio" tabindex="1">
											<form:option value="">SELECCIONAR</form:option>
										</form:select>						
									</td>
								</tr>		
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="clienteID">Aportante:</label>
									</td>
									<td nowrap="nowrap">
								    	<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="2" maxlength="20" autocomplete="off" 	/>
								    	<input type="text" id="nombreCompletoCte" name="nombreCompletoCte" size="60" readonly="readonly" disabled="disabled"/>
									</td>
								</tr>	
							</table>			
							</fieldset>
						</td>
						<td valign="top">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend><label>Presentaci&oacute;n</label></legend>
								<input type="radio" id="excel" name="generaRpt" value="excel" tabindex="3" >
								<label>Excel</label>
							</fieldset>
						</td>
					</tr>
				</table>
				<table width="100%">
					<tr>
						<td align="right">
							<input type="button" id="generar" name="generar" class="submit" tabIndex = "5" value="Generar" />
							<input type="hidden" id="tipoReporte" name="tipoReporte" />
							<input type="hidden" id="tipoLista" name="tipoLista" />
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