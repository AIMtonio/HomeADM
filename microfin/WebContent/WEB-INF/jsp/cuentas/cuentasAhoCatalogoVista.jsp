<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>	
 		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>   
 	   	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
		<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="js/cuentas/cuentaAhoCatalogo.js"></script>     
		
		
	</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasAhoBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Solicitud de <s:message code="safilocale.ctaAhorro"/></legend>
			<table border="0"  width="100%">
				<tr>
			    	<td class="label">
			        	<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label>
			     	</td>
			     	<td nowrap="nowrap">
			        	<form:input id="clienteID" name="clienteID" path="clienteID" size="11" tabindex="1" iniForma = 'false'/>
			         	<textarea id="nombreCte" name="nombreCte"size="40" type="text" tabindex="2" 
			         		readOnly="true" disabled = "true" iniForma = 'false'></textarea>
			     	</td> 
			        <td class="separador"></td> 				
					<td class="label"> 
						<label for="lblSucursalID">Sucursal: </label> 
					</td> 
					<td> 
						<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="7" tabindex="3"
					      	disabled = "true" readOnly="true" iniForma = 'false'/>
					   	<input id="sucursal" name="sucursal"size="29"  type="text" tabindex="4" 
					      		 readOnly="true" disabled = "true" iniForma = 'false'/> 
					</td> 
			 	</tr> 
				<tr>
					<td class="label"> 
			        	<label for="lblCuentaAhoID">Cuenta: </label> 
					</td>
					<td>
						<form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="13" tabindex="5"/>  
					</td>	
			     	<td class="separador"></td> 
			     	<td class="label"> 
			        	<label for="lblTipoCtaAhoID">Tipo de Cuenta: </label> 
			     	</td> 
			     	<td> 
			        	<form:select id="tipoCuentaID" name="tipoCuentaID" path="tipoCuentaID" tabindex="6">
							<form:option value="">SELECCIONAR</form:option>
						</form:select> 
			     	</td> 		
				</tr> 
			 	<tr>
					<td class="label" id= "lbclabe"> 
				    	<label for="lblclabe" id= "lblCtaClabe">Cuenta Clabe: </label> 
					</td>
					<td>
						<form:input id="clabe" name="clabe" path="clabe" size="24" tabindex="7" disabled="true" readOnly="true"/>  
					</td>
				    <td class="separador"></td>  
				    <td class="label" id= "lbInstitucion">
						<label for="lblinstitucionID" id="lblinstitucionID">Banco: </label> 
					</td>
		   			<td>
			 			<form:input id="institucionID" name="institucionID" path="institucionID" size="7" tabindex="8" disabled="true" readOnly="true"/>
			 			<input type="text" id="nombreInstitucion" name="nombreInstitucion" tabindex="8" size="50" disabled="true" readOnly="true"/> 
					</td>	
				</tr> 
				<tr>		
			     	<td class="label"> 
			        	<label for="lblMonedaID">Moneda: </label> 
			     	</td> 
			     	<td> 
						<form:input id="monedaID" name="monedaID" path="monedaID" size="3" 
			         			readOnly="true" disabled="true" tabindex="9"/>
			         	<input id="moneda" name="moneda"size="25"  type="text" readOnly="true"
			         			tabindex="9" disabled = "true"/> 
			     	</td> 
			     	<td class="separador"></td> 		
			      	<td class="label"> 
			        	<label for="lblEtiqueta">Etiqueta: </label> 
			     	</td> 
			     	<td> 
			        	<form:textarea id="etiqueta" name="etiqueta" path="etiqueta" size="50" tabindex="10" 
			        		onblur="ponerMayusculas(this)" maxlength="50"/> 
			     	</td> 
			 	</tr> 		
				<tr> 
			   		<td class="label"> 
			        	<label for="lblFecha">Fecha:</label> 
			        </td> 
			     	<td>
			        	<form:input id="fechaReg" name="fechaReg" path="fechaReg" 
			         		disabled = "true" readOnly="true" tabindex="11"/> 
			     	</td>
			     	<td class="separador"></td> 
			     	<td class="label" nowrap="nowrap"> 
				    	<label for="lblEdoCta">Estado de Cuenta:</label> 
				    </td>
			     	<td>
			        	<form:select id="estadoCta" name="estadoCta" path="estadoCta" tabindex="12" >
							<form:option value="D">DOMICILIO</form:option>
					     	<form:option value="I">INTERNET</form:option>
							<form:option value="S">SUCURSAL</form:option>
						</form:select>
			     	</td>		     				         
			 	</tr> 
			 	<tr> 
		 	 	 
				</tr> 
				<tr> 
			    	<td class="label" nowrap="nowrap"> 
				    	<label for="lblEdoCta">Es principal</label> 
				   	</td>
			     	<td>
			        	<form:select id="esPrincipal" name="esPrincipal" path="esPrincipal" tabindex="13" >
							<form:option value="S">SI</form:option>
							<form:option value="N">NO</form:option>
						</form:select>
			     	</td>
			     	<td class="separador"></td> 
			     	
			     	<td class="label" id ="lbCelular"> 
				    <label for="telefonoCelular">Tel&eacute;fono Celular: </label>
				   	</td>
			     	<td id="numCel">
			 		<form:input id="telefonoCelular" name="telefonoCelular" maxlength="15" size="15" path="telefonoCelular"
						 tabindex="14"/>
						  <a href="javaScript:" onClick="ayudaCR();">
								  	<img src="images/help-icon.gif" >
								</a> 
						 
					</td>
			 	</tr> 
				<tr>
					<td colspan="5" align="right">
						<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="15"/>
						<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="16"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
						<input type="hidden" id="varSafilocale" name="varSafilocale" value="<s:message code="safilocale.ctaAhorro"/>"/>				
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
</body>
<div id="mensaje" style="display: none;"></div>
<div id="ContenedorAyuda" style="display: none;">
</html>