<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	     
		<script type="text/javascript" src="js/forma.js"></script>
		<script type="text/javascript" src="dwr/engine.js"></script>
		<script type="text/javascript" src="dwr/util.js"></script>   
		<script type="text/javascript" src="dwr/interface/divisasServicio.js"></script>    
		<script type="text/javascript" src="js/tesoreria/divisasRegistro.js"></script>
	</head>
<body>
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Registro de Divisas</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="divisas">
			<table border="0" width="100%">     
				<tr>
					<td class="label"> 
						<label for="monedaId">N&uacute;mero de Divisa:</label> 
					</td>
					<td> 
						<form:input id="monedaId" name="monedaId" path="monedaId" size="11" tabindex="1" iniforma="false"/> 
					</td> 
				</tr>
				<tr> 	
					<td class="label"> 
						<label for="descripcion">Descripci&oacute;n: </label> 
					</td>
					<td> 
						<form:input id="descripcion" name="descripcion" path="descripcion" size="38" tabindex="2" onBlur=" ponerMayusculas(this)" maxlength="80"/> 		         						
					</td> 
				</tr>
				<tr>
					<td class="label"> 
						<label for="descriCorta">Descripci&oacute;n corta:</label> 
					</td>
					<td> 
						<form:input id="descriCorta" name="descriCorta" path="descriCorta" size="38" tabindex="3" onBlur=" ponerMayusculas(this)" maxlength="45"/> 		         						
					</td>			    			     		
				</tr>
				<tr>	
					<td class="label"> 
						<label for="simbolo">S&iacute;mbolo:</label> 
					</td> 
					<td>
						<form:input type="text" id="simbolo" name="simbolo" path="simbolo"  size="11" tabindex="4" onBlur=" ponerMayusculas(this)" maxlength="45"/> 			
					</td>   		 
					<td class="separador"></td>
					<td class="label"> 
						<label for="tipoMoneda">Tipo de moneda:</label> 
					</td>
					<td>
						<form:select id="tipoMoneda" name="tipoMoneda" path="tipoMoneda" tabindex="5" >
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="1">NACIONAL</form:option>
							<form:option value="2">EXTRANJERA</form:option>
						</form:select>
					</td>
				</tr> 
				<tr>
					<td class="label"> 
						<label for="eqCNBVUIF">C&oacute;digo CNBV:</label> 
					</td>
					<td> 
						<form:input id="eqCNBVUIF" name="eqCNBVUIF" path="eqCNBVUIF" size="11" tabindex="6" onBlur=" ponerMayusculas(this)"  maxlength="3"/> 		         						
					</td> 
					<td class="separador"></td>
					<td class="label"> 
						<label for="monedaCNBV">C&oacute;digo Moneda CC:</label> 
					</td>
					<td> 
						<form:input id="monedaCNBV" name="monedaCNBV" path="monedaCNBV" size="16" tabindex="7" onBlur=" ponerMayusculas(this)" maxlength="5" /> 		         						
					</td>
				</tr> 
				<tr>
					<td class="label"> 
						<label for="eqBuroCred">C&oacute;digo Bur&oacute; de Crédito:</label> 
					</td>
					<td> 
						<form:input id="eqBuroCred" name="eqBuroCred" path="eqBuroCred" size="11" tabindex="8" onBlur=" ponerMayusculas(this)" maxlength="5"/> 		         						
					</td> 
				</tr> 
			</table> 
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend >Tipo de Cambio en Ventanilla</legend>			
				<table>					    
					<tr>
						<td class="label" style="width: 50px"> 
							<label for="tipCamComVen">Compra:</label> 
						</td>
						<td >
							<form:input id="tipCamComVen" name="tipCamComVen" path="tipCamComVen" size="15" tabindex="9" maxlength="18" seisDecimales="true"  style="text-align: right"/>
						</td> 
						<td class="separador"></td>
						<td class="label"> 
							<label for="tipCamVenVen">Venta:</label> 
						</td>
						<td >
							<form:input id="tipCamVenVen" name="tipCamVenVen" path="tipCamVenVen" size="15" tabindex="10" maxlength="18" seisDecimales="true"  style="text-align: right"/>
						</td> 
					</tr>
				</table>
			</fieldset>			           	
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend >Tipo de Cambio en Operaciones Internas</legend>	
				<table>
					<tr>  
						<td class="label" style="width: 50px"> 
							<label for="tipCamComInt">Compra:</label> 
						</td>
						<td >
							<form:input id="tipCamComInt" name="tipCamComInt" path="tipCamComInt" size="15" tabindex="11" maxlength="18"  seisDecimales="true" style="text-align: right"/>
						</td> 
						<td class="separador"></td>
						<td class="label"> 
							<label for="tipCamVenInt">Venta:</label> 
						</td>
						<td >
							<form:input id="tipCamVenInt" name="tipCamVenInt" path="tipCamVenInt" size="15" tabindex="12" maxlength="18"  seisDecimales="true" style="text-align: right"/>
						</td> 			           	
					</tr>
				</table>
			</fieldset>
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend>Tipo de Cambio en Fix</legend>	                 
				<table>
					<tr>  
						<td class="label" style="width: 50px"> 
							<label for="tipCamFixCom">Compra:</label> 
						</td>
						<td >
							<form:input id="tipCamFixCom" name="tipCamFixCom" path="tipCamFixCom" size="15" tabindex="13" maxlength="18" seisDecimales="true"  style="text-align: right"/>
						</td> 
						<td class="separador"></td>
						<td class="label"> 
							<label for="tipCamFixVen">Venta:</label> 
						</td>
						<td >
							<form:input id="tipCamFixVen" name="tipCamFixVen" path="tipCamFixVen" size="15" tabindex="14" maxlength="18" seisDecimales="true"  style="text-align: right"/>
						</td> 			           	
					</tr>													
				</table>
			</fieldset>
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend>Tipo de Cambio en Dof</legend>	                 
				<table>
					<tr>  
						<td class="label" style="width: 50px"> 
							<label for="tipCamDof">Dof:</label> 
						</td>
						<td >
							<form:input id="tipCamDof" name="tipCamDof" path="tipCamDof" size="15" tabindex="15" maxlength="18" seisDecimales="true" style="text-align: right" /> 		         	
						</td>  			           	
					</tr>													
				</table>
			</fieldset>
			<br>
			<table border="0" width="100%" align="right">  
				<tr>
					<td align="right">
						<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="30"/>
						<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="31"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					</td>
				</tr>
			</table>
		</form:form> 
	</fieldset>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"></div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"></div>
</div>	
</body>
</html>