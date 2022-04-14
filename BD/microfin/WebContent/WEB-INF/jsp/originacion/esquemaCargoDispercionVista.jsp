<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html> 
	<head>	
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaCargoDispServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/calendarioProdServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/nivelCreditoServicio.js"></script>
       	<script type="text/javascript" src="js/originacion/esquemaCargoDisp.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="esquemaCargoDisp">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Esquema de Cargos por Dispersi&oacute;n</legend>
			<table border="0" width="100%">
				<tr>
					<td class="label" nowrap="nowrap"> 
		         		<label for="lblProducto">Producto de Cr&eacute;dito: </label> 
		     		</td> 
		     		<td nowrap="nowrap"> 
		         		<form:input id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="6" tabindex="1" />
		         		<input type= "text" id="descripProducto" name="descripProducto" size="45" type="text" readonly="true"  />
		     		</td> 
		     		<td class="separador"></td>
		 			<td class="label">
		 				<label for="institucionID">Instituci&oacute;n: </label> 
					</td>
		     		<td class="label" nowrap="nowrap">  
						<form:input type="text" id="institucionID" name="institucionID" path="institucionID" size="6" tabindex="2" />
		         		<input type= "text" id="nombInstitucion" name="nombInstitucion" size="45" type="text" readonly="true"  />
					</td>
				</tr>
		 		<tr id="tr1"> 
		 			<td class="label" nowrap="nowrap"> 
		 				<label for="tipoDispersion">Tipo Dispersi&oacute;n: </label> 
					</td>
					<td>
						<form:select id="tipoDispersion" name="tipoDispersion" path="tipoDispersion" tabindex="3">
							<form:option value="">SELECCIONAR</form:option>
						</form:select>
					</td>
		     		<td class="separador"></td>
		 			<td id="tipoCargo1" class="label" nowrap="nowrap" style="display: none;"> 
		 				<label for="tipoCargo">Tipo Cargo: </label> 
					</td>
					<td id="tipoCargo2" style="display: none;">
						<form:select id="tipoCargo" name="tipoCargo" path="tipoCargo" tabindex="4">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="M">MONTO</form:option>
							<form:option value="P">PORCENTAJE</form:option>
						</form:select>
					</td>
				</tr>
		 		<tr id="tr2"> 
		 			<td class="label" nowrap="nowrap"> 
		 				<label for="tipoCargo">Nivel: </label> 
					</td>
					<td>
						<form:select id="nivel" name="nivel" path="nivel" tabindex="4">
							<form:option value="">SELECCIONAR</form:option>
						</form:select>
					</td>
		     		<td class="separador"></td>
		 			<td id="montoCargo1" class="label" nowrap="nowrap" style="display: none;"> 
		 				<label for="montoCargo">Valor Cargo: </label> 
					</td>
		     		<td id="montoCargo2" class="label" style="display: none;">  
						<form:input type="text" id="montoCargo" name="montoCargo" path="montoCargo" onkeypress="validaSoloNumero(event)" esMoneda="true" value="" tabindex="6" style="text-align: right;" maxlength="12"/>
		 				<label id="porcentaje" style="display: none;">&nbsp;%</label> 
					</td>
				</tr> 
				<tr>
					<td colspan="5" align="right">
						<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="7" />
						<input type="submit" id="eliminar" name="eliminar" class="submit" value="Eliminar" tabindex="8" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="0"/>
						<input type="hidden" size = "5" id="estatusProducCredito" name="estatusProducCredito"/>
					</td>
				</tr>	
		 		<tr> 
		     		<td colspan="5" >  
		 				<div id="gridEsquemaCobro"></div>
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