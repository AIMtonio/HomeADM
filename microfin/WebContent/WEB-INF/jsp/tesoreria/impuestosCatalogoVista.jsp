<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/impuestoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 
	  	<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="js/tesoreria/impuestosCatalogo.js"></script>  
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="impuestos">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Impuestos</legend>
			<br> 		
			<table border="0" width="100%">
				<tr>
					<td>
						<table border="0" width="100%">
							<tr>
								<td class="label">
									<label for="lblImpuestoID">N&uacute;m. Impuesto:</label>
								</td>
								<td>
									<form:input id="impuestoID" name="impuestoID" path="impuestoID" size="5" tabindex="1"  />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblDescripCorta">Nombre Corto:</label>
								</td>
								<td>
									<form:input id="descripCorta" name="descripCorta" path="descripCorta" size="15" tabindex="2" onBlur=" ponerMayusculas(this);" maxlength="10"/>
								</td>
								</tr>
								<tr>
								<td class="label">
									<label for="lblDescripcion">Descripci&oacute;n:</label>
								</td>
								<td>
									<textarea id="descripcion" name="descripcion" path="descripcion" cols =30 rows=3 tabindex="3" onBlur=" ponerMayusculas(this);" maxlength="70"></textarea>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblTasa">Tasa:</label>
								</td>
								<td>
									<form:input id="tasa" name="tasa" path="tasa" size="8" tabindex="4" style="text-align:right;" esMoneda="true" /><label>%</label>
								</td>
								</tr>
								<tr>
								<td class="label"> 
						    		<label for="lblCtaEnTransito">Cuenta en Tr&aacute;nsito:</label> 
						    	</td>
						   		<td>
				         			<form:input id="ctaEnTransito" name="ctaEnTransito" path="ctaEnTransito" size="25" tabindex="5" 
				         				maxlength="25"/>		         	
				         			<textarea id="descripcionCuenta" name="descripcionCuenta" cols =30 rows=2 readonly="true"></textarea>
				         		
						     	</td>
						     	<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="lblGravaRetiene">Tipo de Impuesto:</label>
								</td>
								<td>
									<form:select id="gravaRetiene" name="gravaRetiene" path="gravaRetiene"  tabindex="6">
										<form:option value="">SELECCIONAR</form:option>								
										<form:option value="G">GRAVADO</form:option>
										<form:option value="R">RETENIDO</form:option>
									</form:select>
								</td>
								</tr>
								<tr>	
								<td class="label"> 
						    		<label for="lblCtaRealizado">Cuenta Realizado:</label> 
						    	</td>
						   		<td>
				         			<form:input id="ctaRealizado" name="ctaRealizado" path="ctaRealizado" size="25" tabindex="7" 
				         				maxlength="25"/>		         	
				         			<textarea id="descripcionCuentaRealizado" name="descripcionCuentaRealizado" cols =30 rows=2 readonly="true"></textarea>		
						     	</td>
						   		<td class="separador"></td>	
						     	<td>
									<label for="lblBaseCalculo">Base C&aacute;lculo:</label>							
								</td>
								<td>
									<label>Subtotal</label><input type="radio" id="baseCalculoS" 	name="baseCalculo" value="S" tabindex="8"/><br>
									<label>Importe de Impuesto</label><input type="radio"	id="baseCalculoI"	name="baseCalculo" value="I" tabindex="9"/>
								</td>
								</tr>	
								<tr>
								<td></td>
								<td></td>
								<td class="separador"></td>
								<td>
								<label id="lblImpuestoCalculo" for="lblImpuestoCalculo">Impuesto:</label>
								</td>
								<td>
									<form:select id="impuestoCalculo" name="impuestoCalculo" path="impuestoCalculo"  tabindex="10">
										<form:option value="">SELECCIONAR</form:option>
									</form:select>
								</td>
								</tr>
						</table>
					</td>
				</tr>
			
			</table>
			<br>
				<table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="agrega" name="agrega" class="submit" 
							 value="Agregar" tabindex="11" />
						<input type="submit" id="modifica" name="modifica" class="submit" 
							 value="Modificar" tabindex="12" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>						
					</td>
				</tr>
			</table>	
			</fieldset>

			
						
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>