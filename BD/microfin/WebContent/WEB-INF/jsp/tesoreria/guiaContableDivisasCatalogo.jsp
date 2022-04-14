<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	     
		<script type="text/javascript" src="dwr/engine.js"></script>
		<script type="text/javascript" src="dwr/util.js"></script>     
		<script type="text/javascript" src="dwr/interface/cuentasMayorMonServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conceptosDivServicio.js"></script>   
		<script type="text/javascript" src="dwr/interface/subCtaMonedaDivServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/subCtaTipoDivServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>	
				
		<script type="text/javascript" src="dwr/interface/subCtaSucursalDivisaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/subCtaTipoCajaDivisaServicio.js"></script>			
		<script type="text/javascript" src="dwr/interface/subCtaCajeroDivisaServicio.js"></script>	     
	      
		<script type="text/javascript" src="js/forma.js"></script>
		<script type="text/javascript" src="js/tesoreria/guiaContableDivisasCatalogo.js"></script>
	      
	</head>
   
<body>

<div id="contenedorForma">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Gu&iacute;a Contable Divisas</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="Divisas">  	
			<fieldset class="ui-widget ui-widget-content ui-corner-all">           
				<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas Mayor</legend>     
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td class="label"> 
					         <label for="lblconceptoMonID">Concepto:</label> 
					     	</td>
					     	<td> 
			         		<select id="conceptoMonID" name="conceptoMonID" tabindex="1">
									<option value="-1">Seleccionar<option>
								</select>  
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblcuenta">Cuenta:</label></td>
					     	<td>
					     		 <input id="cuenta" name="cuenta"  size="13" tabindex="2" /> 
					     	</td>  		
						</tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblnomenclatura">Nomenclatura:</label> 
					     	</td>
					     	<td >
					     		<input id="nomenclatura" name="nomenclatura"  size="35" tabindex="3" /> 
					         <a href="javaScript:" onClick="ayuda();">
								  	<img src="images/help-icon.gif" >
								</a> 
					     	</td>  		
						</tr> 
						<tr>
							<td class="label"> 
					         <label for="lblClaves"><b>Claves de Nomenclatura Cuentas: 	
					         <i><br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&CM');return false;">  &CM = Cuentas de Mayor </a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TP');return false;">  &TP = SubCuenta por Tipo de Producto</a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TM');return false;">  &TM = SubCuenta por Tipo de Moneda </a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&SU');return false;">  &SU = SubCuenta por Sucursal  </a>
					          <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TC');return false;">  &TC = SubCuenta por Tipo de Caja </a>
					          <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&CA');return false;">  &CA = SubCuenta por Caja</b> </a>
					           
					          </i> 
					         </label>					         					         					          					         					 
					        
					     	</td>
						</tr> 
						<tr> 
					      <td class="label"> 
					         <label for="lblnomenclaturaCR">Nomenclatura Centro Costo:</label> 
					     	</td>
					     	<td >
					     		 <input id="nomenclaturaCR" name="nomenclaturaCR"  size="25" 
					         		tabindex="4" /> 
					         <a href="javaScript:" onClick="ayudaCR();">
								  	<img src="images/help-icon.gif" >
								</a> 
					     	</td>  	
						</tr> 
						<tr>
							<td class="label"> 
					         <label for="lblClaves"><b>Claves de Nomenclatura  Centro Costo: 	
					         <i>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclaturaCR','&SO');return false;">  &SO = Sucursal Origen </a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclaturaCR','&SC');return false;">  &SC = Sucursal Cliente </a></b> </label> 
					     		</i>	
					     	</td>
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaCM" name="grabaCM" class="submit" value="Grabar"  tabindex="5"/>
								<input type="submit" id="modificaCM" name="modificaCM" class="submit" value="Modificar" tabindex="6"/>
								<input type="submit" id="eliminaCM" name="eliminaCM" class="submit" value="Eliminar" tabindex="7"/>
								<input type="hidden" id="tipoTransaccionCM" name="tipoTransaccionCM" value="tipoTransaccionCM"/>
							</td>
						</tr>
					</table>
				</fieldset>
		</form:form>
		<br></br>
		<form:form id="formaGenerica3" name="formaGenerica3" method="POST" commandName="Divisas"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Producto</legend>   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td> 
					     		 <input id="conceptoMonID3" name="conceptoMonID3"  size="10" 
					         		tabindex="10" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblfisica">Billetes:</label> 
					     	</td>
					     	<td> 
					     		 <input id="billetes" name="billetes"  size="5" 
					         		tabindex="11" maxlength="4"/> 
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblmoral">Monedas Metálicas:</label> 
					     	</td>
					     	<td >
					     		 <input id="monedas" name="monedas"  size="5" 
					         		tabindex="12" maxlength="4"/> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaTDiv" name="grabaTDiv" class="submit" value="Grabar" tabindex="13"/>
								<input type="submit" id="modificaTDiv" name="modificaTDiv" class="submit" value="Modificar" tabindex="14"/>
								<input type="submit" id="eliminaTDiv" name="eliminaTDiv" class="submit" value="Eliminar" tabindex="15"/>
								<input type="hidden" id="tipoTransaccionTDiv" name="tipoTransaccionTDiv" value="2"/>
							</td>
						</tr>
					</table>
				</fieldset>
	</form:form> 
		<br></br>
<form:form id="formaGenerica2" name="formaGenerica2" method="POST" commandName="tipoMoneda"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Moneda</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr><td> 
					     		 <input id="conceptoMonID2" name="conceptoMonID2"  size="10" 
					         		tabindex="20" type="hidden"/> 
					     	</td> 
					   </tr>     
						<tr><td> 
					     		 <input id="conceptoMonID2" name="conceptoMonID2"  size="13" 
					         		tabindex="21" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblmonedaID">Moneda:</label> 
					     	</td>
					     	<td> 
					     		 <select id="monedaID" name="monedaID" tabindex="22">
									<option value="-1">Seleccionar</option>
								</select> 
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuenta">SubCuenta</label> 
					     	</td>
					     	<td >
					     		 <input id="subCuenta" name="subCuenta"  size="5" 
					         		tabindex="23" maxlength="4"/> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaMDiv" name="grabaMDiv" class="submit" value="Grabar" tabindex="24"/>
								<input type="submit" id="modificaMDiv" name="modificaMDiv" class="submit" value="Modificar" tabindex="25" />
								<input type="submit" id="eliminaMDiv" name="eliminaMDiv" class="submit" value="Eliminar" tabindex="26"/>
								<input type="hidden" id="tipoTransaccionMDiv" name="tipoTransaccionMDiv" value="2"/>
							</td>
						</tr>
					</table>
				</fieldset>
	</form:form>
	<br></br>

	<form:form id="formaGenerica4" name="formaGenerica4" method="POST" commandName="sucursal"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Sucursal</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr><td> 
					     		 <input id="conceptoMonID4" name="conceptoMonID4"  size="10" 
					         		tabindex="30" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lbltipoProductoID">Sucursal:</label> 
					     	</td>
					     	<td> 
					         <select id="sucursalID" name="sucursalID"  tabindex="31">
									<option value="-1">Seleccionar</option>
								</select>
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuenta">SubCuenta:</label> 
					     	</td>
					     	<td>
					     		 <input id="subCuenta01" name="subCuenta01"  size="5" 
					         		tabindex="32" maxlength="4"/> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaSuc" name="grabaSuc" class="submit" value="Grabar" tabindex="33"/>
								<input type="submit" id="modificaSuc" name="modificaSuc" class="submit" value="Modificar" tabindex="34" />
								<input type="submit" id="eliminaSuc" name="eliminaSuc" class="submit" value="Eliminar" tabindex="35"/>
								<input type="hidden" id="tipoTransaccionSuc" name="tipoTransaccionSuc" value="2"/>
							</td>
						</tr>
					</table>
				</fieldset> 
	</form:form>
	<br></br>
	<form:form id="formaGenerica5" name="formaGenerica5" method="POST" commandName="tipoCaja"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Caja</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr><td> 
					     		 <input id="conceptoMonID5" name="conceptoMonID5"  size="10" 
					         		tabindex="40" type="hidden"/> 
					     	</td> 
					   </tr>
						<tr>
					   	<td class="label"> 
					         <label for="lblTipoCaja">Caja:</label> 
					     	</td>
					     	<td> 
					         <select id="tipoCaja" name="tipoCaja"  tabindex="41">
									<option value="-1">Seleccionar</option>
									<option value="CA">CAJA DE ATENCIÓN AL PÚBLICO</option>
									<option value="CP">CAJA PRINCIPAL DE SUCURSAL</option>
									<option value="BG">BOBEDA CENTRAL</option>
								</select>
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuenta">SubCuenta:</label> 
					     	</td>
					     	<td>
					     		 <input id="subCuenta02" name="subCuenta02"  size="5" 
					         		tabindex="42" maxlength="4"/> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaTC" name="grabaTC" class="submit" value="Grabar" tabindex="43"/>
								<input type="submit" id="modificaTC" name="modificaTC" class="submit" value="Modificar" tabindex="44" />
								<input type="submit" id="eliminaTC" name="eliminaTC" class="submit" value="Eliminar" tabindex="45"/>
								<input type="hidden" id="tipoTransaccionTC" name="tipoTransaccionTC" value="2"/>
							</td>
						</tr>
					</table>
				</fieldset> 
	</form:form>
	<br></br>
	<form:form id="formaGenerica1" name="formaGenerica1" method="POST" commandName="tipoCaja"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Cajero</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr><td> 
					     		 <input id="conceptoMonID1" name="conceptoMonID1"  size="10" 
					         		tabindex="50" type="hidden"/> 
					     	</td> 
					   </tr>
						<tr>
					   	<td class="label"> 
					         <label for="lblTipoCaja">Caja:</label> 
					     	</td>
					     	<td> 
					         <select id="cajaID" name="cajaID"  tabindex="51">
									<option value="-1">Seleccionar</option>
								</select>
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuenta">SubCuenta:</label> 
					     	</td>
					     	<td>
					     		 <input id="subCuenta03" name="subCuenta03"  size="5" 
					         		tabindex="52" maxlength="4"/> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaC" name="grabaC" class="submit" value="Grabar" tabindex="53"/>
								<input type="submit" id="modificaC" name="modificaC" class="submit" value="Modificar" tabindex="54" />
								<input type="submit" id="eliminaC" name="eliminaC" class="submit" value="Eliminar" tabindex="55"/>
								<input type="hidden" id="tipoTransaccionC" name="tipoTransaccionC" value="2"/>
							</td>
						</tr>
					</table>
				</fieldset> 
	</form:form>
	<br></br>
			
</fieldset>
</div>

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"> </div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"/>
</div>	

</body>
</html>
