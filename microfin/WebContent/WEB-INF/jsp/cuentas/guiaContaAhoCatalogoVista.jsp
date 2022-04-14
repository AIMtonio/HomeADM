<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>	
	<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>   
	<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>  
	<script type="text/javascript" src="dwr/interface/conceptosAhorroServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasMayorAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/subCtaRendiAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/subCtaTiProAhoServicio.js"></script>         
	<script type="text/javascript" src="dwr/interface/subCtaTiPerAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/subCtaMonedaAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/subCtaClasifAhoServicio	.js"></script>	
	<script type="text/javascript" src="js/cuentas/guiaContaAhoCatalogo.js"></script>
</head>
<body>
<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Gu&iacute;a Contable Tipos de Cuenta</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="GuiaContable">  	
			<fieldset class="ui-widget ui-widget-content ui-corner-all">           
				<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas Mayor</legend>     
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   		<td class="label"> 
					         <label for="lblconceptoAhoID">Concepto:</label> 
					     	</td>
					     	<td> 
			         		<select id="conceptoAhoID" name="conceptoAhoID" tabindex="1">
								<option value="">SELECCIONAR<option>
							</select>  
					     	</td> 
					   	</tr> 
						<tr>  
					    	<td class="label"> 
					        	<label for="lblcuenta">Cuenta:</label> 
					     	</td>
					     	<td >
					     		<input type="text" id="cuenta" name="cuenta"  size="13" tabindex="2" /> 
					     	</td>  		
						</tr> 
						<tr>  
					     	<td class="label"> 
					        	<label for="lblnomenclatura">Nomenclatura Cuentas Ahorro:</label> 
					     	</td>
					     	<td >
					     		<input type="text" id="nomenclatura" name="nomenclatura"  size="25" tabindex="3" /> 
					         	<a href="javaScript:" onClick="ayuda();"><img src="images/help-icon.gif" ></a> 
					     	</td>  		
						</tr> 
						<tr>
							<td class="label"> <i>
					         <label for="lblClaves"><b>Claves de Nomenclatura Cuentas Ahorro: 	
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&CM');return false;">  &CM = Cuentas de Mayor </a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TR');return false;">  &TR = SubCuenta por Tipo de Rendimiento </a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TP');return false;">  &TP = SubCuenta por Tipo de Producto</a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TC');return false;">  &TC = SubCuenta por Tipo de Persona</a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&CL');return false;">  &CL = SubCuenta por Clasificaci&oacute;n</a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TM');return false;">  &TM = SubCuenta por Tipo de Moneda </b> </a></label> 
							</i>
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
					         <i><br><a href="javascript:" onClick="insertAtCaret('nomenclaturaCR','&SO');return false;">  &SO = Sucursal Origen </a>
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

		<form:form id="formaGenerica2" name="formaGenerica2" method="POST" commandName="GuiaContable"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Rendimiento</legend>                
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					     	<td> 
					     		 <input id="conceptoAhoID2" name="conceptoAhoID2"  size="13" 
					         		tabindex="8" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblPaga">Paga Rendimiento:</label> 
					     	</td>
					     	<td> 
					     		 <input id="paga" name="paga"  size="13" tabindex="9" maxlength="2"/> 
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblNoPaga">No Paga Rendimiento</label> 
					     	</td>
					     	<td >
					     		 <input id="noPaga" name="noPaga"  size="13" tabindex="10"  maxlength="2"/> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaSR" name="grabaSR" class="submit" value="Grabar" tabindex="11" />
								<input type="submit" id="modificaSR" name="modificaSR" class="submit" value="Modificar" tabindex="12" />
								<input type="submit" id="eliminaSR" name="eliminaSR" class="submit" value="Eliminar" tabindex="13" />
								<input type="hidden" id="tipoTransaccionSR" name="tipoTransaccionSR" value="2"/>
							</td>
						</tr>
					</table>
				</fieldset>
		
	</form:form>
	<br></br>

	<form:form id="formaGenerica3" name="formaGenerica3" method="POST" commandName="GuiaContable"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Producto</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td> 
					     		 <input id="conceptoAhoID3" name="conceptoAhoID3"  size="13" 
					         		tabindex="14" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lbltipoProductoID">Producto:</label> 
					     	</td>
					     	<td> 
					         <select id="tipoProductoID" name="tipoProductoID"  tabindex="15">
									<option value="-1">Seleccionar</option>
								</select>
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuenta">SubCuenta:</label> 
					     	</td>
					     	<td >
					     		 <input id="subCuenta" name="subCuenta"  size="5" tabindex="16" maxlength="6"/> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaTPR" name="grabaTPR" class="submit" value="Grabar" tabindex="17"/>
								<input type="submit" id="modificaTPR" name="modificaTPR" class="submit" value="Modificar" tabindex="18" />
								<input type="submit" id="eliminaTPR" name="eliminaTPR" class="submit" value="Eliminar" tabindex="19"/>
								<input type="hidden" id="tipoTransaccionTPR" name="tipoTransaccionTPR" value="2"/>
							</td>
						</tr>
					</table>
				</fieldset> 
	</form:form>
	<br></br>

	<form:form id="formaGenerica4" name="formaGenerica4" method="POST" commandName="GuiaContable"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Persona</legend>   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   		<td> 
					     		 <input id="conceptoAhoID4" name="conceptoAhoID4"  size="10" tabindex="20" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblfisica">F&iacute;sica:</label> 
					     	</td>
					     	<td> 
					     		 <input id="fisica" name="fisica"  size="5" tabindex="21" maxlength="2"/> 
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblmoral">Moral:</label> 
					     	</td>
					     	<td >
					     		 <input id="moral" name="moral"  size="5" tabindex="22" maxlength="2"/> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaTPE" name="grabaTPE" class="submit" value="Grabar" tabindex="23"/>
								<input type="submit" id="modificaTPE" name="modificaTPE" class="submit" value="Modificar" tabindex="24"/>
								<input type="submit" id="eliminaTPE" name="eliminaTPE" class="submit" value="Eliminar" tabindex="25"/>
								<input type="hidden" id="tipoTransaccionTPE" name="tipoTransaccionTPE" value="2"/>
							</td>
						</tr>
					</table>
				</fieldset>
	</form:form>
	<br></br>	
	
	<form:form id="formaGenerica5" name="formaGenerica5" method="POST" commandName="GuiaContable"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Moneda</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   		<td> 
					     		 <input id="conceptoAhoID5" name="conceptoAhoID5"  size="13" tabindex="26" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblmonedaID">Moneda:</label> 
					     	</td>
					     	<td> 
					     		 <select id="monedaID" name="monedaID" tabindex="27">
									<option value="">SELECCIONAR</option>
								</select> 
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuenta2">SubCuenta</label> 
					     	</td>
					     	<td >
					     		 <input id="subCuenta2" name="subCuenta2"  size="5" tabindex="28" maxlength="2"/> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaSM" name="grabaSM" class="submit" value="Grabar" tabindex="29"/>
								<input type="submit" id="modificaSM" name="modificaSM" class="submit" value="Modificar" tabindex="30" />
								<input type="submit" id="eliminaSM" name="eliminaSM" class="submit" value="Eliminar" tabindex="31"/>
								<input type="hidden" id="tipoTransaccionSM" name="tipoTransaccionSM" value="2"/>
							</td>
						</tr>
					</table>
				</fieldset>
	</form:form>
	<br/>
	<form:form id="formaGenerica1" name="formaGenerica1" method="POST" commandName="GuiaContable"> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Por Clasificaci&oacute;n</legend>                   
				<table border="0" cellpadding="0" cellspacing="0" width="100%">     
					<tr>
				   	<td> 
				   		<input type="hidden" id="conceptoAhoID1" name="conceptoAhoID1"  size="13" tabindex="32 type="hidden"/> 
				     	</td> 
				   </tr> 
					<tr>
				   	<td class="label"> 
				         <label for="lblmonedaID">Clasificaci&oacute;n:</label> 
				     	</td>
				     	<td> 
				     		 <label for="clasificacionContaV">Dep&oacute;sitos a la Vista</label> 
							<input type="radio" id="clasificacionContaV" name="clasificacionContaV" value="V" tabindex="33" checked="checked" />&nbsp;&nbsp;
							<label for="clasificacionContaA">Ahorro(Ordinario)</label> 
							<input type="radio" id="clasificacionContaA" name="clasificacionContaA" value="A" tabindex="34" />
							<input type="hidden" id="clasificacion" name="clasificacion" size="12" tabindex="15" value="V" />
				     	</td> 
				   </tr> 
					<tr>  
				      <td class="label"> 
				         <label for="subCuenta3">SubCuenta</label> 
				     	</td>
				     	<td >
				     		 <input type="text" id="subCuenta3" name="subCuenta3"  size="5" tabindex="35" maxlength="6"/> 
				     	</td>  		
					</tr> 
				</table>
				<br></br>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
					<tr>
						<td align="right">
							<input type="submit" id="grabaSCT" name="grabaSCT" class="submit" value="Grabar" tabindex="36"/>
							<input type="submit" id="modificaSCT" name="modificaSCT" class="submit" value="Modificar" tabindex="37" />
							<input type="submit" id="eliminaSCT" name="eliminaSCT" class="submit" value="Eliminar" tabindex="38"/>
							<input type="hidden" id="tipoTransaccionSCT" name="tipoTransaccionSCT" value="2"/>
						</td>
					</tr>
				</table>
			</fieldset>
	</form:form>

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
