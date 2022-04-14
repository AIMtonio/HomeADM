<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<!-- se cargar los servicios para accesar por dwr -->
	 <script type="text/javascript" src="dwr/interface/esquemaGarantiaLiqServicio.js"></script> 
	  <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
	   
	<!-- se cargan las funciones o recursos js -->
	<script type="text/javascript" src="js/originacion/esquemaGarantiaLiq.js"></script> 
</head>
	<body>
	
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST"  commandName="esquemaGarantiaLiqBean">
			
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Esquema de Garant&iacute;a L&iacute;quida</legend>	
					<table border="0" width="100%">
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="producCreditoID">Producto Cr&eacute;dito:</label>									
							</td>
							<td>
								<select id="producCreditoID" name="producCreditoID" tabindex="1" >
										<option value="">SELECCIONAR<option>
								</select>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="garantiaLiquida">Garant&iacute;a L&iacute;quida:</label>									
							</td>
							<td>
								<select id="garantiaLiquida" name="garantiaLiquida" tabindex="2" >
									<option value="">SELECCIONAR</option>
									<option value="S">SI</option>
									<option value="N">NO</option>
								</select>
							</td>
							<td id= "garantiaNoFinanciadaLbl" class="label" nowrap="nowrap" style="display: none;">
								<label for="liberarGaranLiq1">Liberar Gar. Liq. Al Liquidar:</label>								
							</td>
							<td id= "garantiaNoFinanciada" style="display: none;">
								<select id="liberarGaranLiq1" name="liberarGaranLiq1" tabindex="3" >
									<option value="">SELECCIONAR</option>
									<option value="S">SI</option>
									<option value="N">NO</option>
								</select>
							</td>
							<td class="separador" id= "separadorBonificacion" style="display: none;"></td>
							<td class="label" nowrap="nowrap" id= "lblBonificacion" style="display: none;">
								<label for="bonificacionFOGA">Bonificaci&oacute;n:</label>
							</td>								
							<td id= "tdBonificacion" style="display: none;">
			
						 		<form:select id="bonificacionFOGA" path="bonificacionFOGA" tabindex="4" >
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="S">SI</form:option>
									<form:option value="N">NO</form:option>
								</form:select> 
							</td>
							<td class="separador" id= "separadorDesbloquea" style="display: none;"></td>
							<td class="label" nowrap="nowrap" id= "lblDesbloquea" style="display: none;">
								<label for="desbloqAutFOGA">Desbloqueo autom&aacute;tico para Pago:</label>								
							</td>
							<td id= "tdDesbloquea" style="display: none;">
								<form:select id="desbloqAutFOGA" path="desbloqAutFOGA" tabindex="5" >
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="S">SI</form:option>
									<form:option value="N">NO</form:option>
								</form:select> 
							</td>
							
						</tr>
						<tr>
							<td class="label" nowrap="nowrap" id="garFogafiLblTD"  style="display: none;">
								<label for="garantiaFOGAFI">Garant&iacute;a L&iacute;quida Financiada:</label>									
							</td>
							<td id="garFogafiTD" style="display: none;">
								<form:select id="garantiaFOGAFI" path="garantiaFOGAFI" tabindex="6" >
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="S">SI</form:option>
									<form:option value="N">NO</form:option>
								</form:select> 
							</td>
								
							<td class="separador" id="separadorModalidad" style="display: none;"></td>
							<td class="label" nowrap="nowrap" id="modalidadLbl" style="display: none;">
								<label for="modalidadFOGAFI">Modalidad:</label>									
							</td>
							<td id="modalidad" style="display: none;">
								<form:select id="modalidadFOGAFI" path="modalidadFOGAFI" tabindex="7" >
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="A">ANTICIPADO</form:option>
									<form:option value="P">PERI&Oacute;DICO</form:option>
								</form:select> 
							</td>
							<td class="separador" id="separadoBonFOGAFI" style="display: none;"></td>
							<td class="label" nowrap="nowrap" id="lblBonificaFOGAFI" style="display: none;">
								<label for="bonificacionFOGAFI">Bonificaci&oacute;n:</label>	
																
							</td>
							<td id="bonificaFOGAFI" style="display: none;">
								<form:select id="bonificacionFOGAFI" path="bonificacionFOGAFI" tabindex="8" >
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="S">SI</form:option>
									<form:option value="N">NO</form:option>
								</form:select> 
							</td>
							<td class="separador" id="separadorDesbFOGAFI" style="display: none;"></td>
							<td class="label" nowrap="nowrap" id="lblseparadorDesbFOGAFI" style="display: none;">
								<label for="desbloqAutFOGAFI">Desbloqueo autom&aacute;tico para Pago:</label>										
							</td>
							<td id="desbloqueoFOGAFI" style="display: none;">
								<form:select id="desbloqAutFOGAFI" path="desbloqAutFOGAFI" tabindex="9" >
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="S">SI</form:option>
									<form:option value="N">NO</form:option>
								</form:select> 
							</td>
						</tr>
						<tr id = "garantiaFinanciadaLib" style="display: none;">
							<td class="label" nowrap="nowrap">
								<label for="liberarGaranLiq2">Liberar Gar. Liq. Al Liquidar:</label>								
							</td>
							<td >
								<select id="liberarGaranLiq2" name="liberarGaranLiq2" tabindex="10" >
									<option value="">SELECCIONAR</option>
									<option value="S">SI</option>
									<option value="N">NO</option>
								</select>
								<input type="hidden" id="liberarGaranLiq" name="liberarGaranLiq" tabindex="152"/>							
						</tr>
					</table>
					
					<br>

						<div id="divGrid">
						
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend >Esquema de Garant&iacute;a</legend>	
								<!-- Muestra la tabla con los esquemas de garantia liquida del producto de credito seleccionado-->
								<div id="tablaGrid"></div>
								
							</fieldset>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td align="right" colspan="5">
										<input type="submit" id="grabar" class="submit" value="Grabar" tabindex="40"/>

									</td>
								</tr> 
						 </table>
							
						</div>		

						
						<!--	DIV que contiene el grid del Esquema FOGAFI -->
						
						<div id="divGridFOGAFI">
						
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend >Esquema de Garant&iacute;a Financiada</legend>	
								<!-- Muestra la tabla con los esquemas de garantia FOGAFI del producto de credito seleccionado-->
								<div id="tablaGridFOGAFI"></div>
								
							</fieldset>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td align="right" colspan="5">
										<input type="submit" id="grabarFOGAFI" class="submit" value="Grabar" tabindex="40"/>

									</td>
								</tr> 
						 </table>
						</div>	
					
						<br>
					
						 	
						<table border="0" cellpadding="0" cellspacing="0" width="100%" style="display: none;" id="tablaBtn">
							<tr>
								<td align="right" colspan="5">
									<input type="submit" id="grabarGral" class="submit" value="Grabar" tabindex="40"/>
								 	<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" size="10" />  	
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
	<div id="imagenCte" style="display: none;">
		<img id= "imgCliente" SRC="images/user.jpg" WIDTH="100%" HEIGHT="100%" border ="0" alt="Foto cliente"/> 
	</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>