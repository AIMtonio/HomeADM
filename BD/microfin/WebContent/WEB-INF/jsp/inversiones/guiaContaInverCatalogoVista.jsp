<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>	     
      <script type="text/javascript" src="dwr/engine.js"></script>
      <script type="text/javascript" src="dwr/util.js"></script>     
		<script type="text/javascript" src="dwr/interface/tipoInversionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>   
      <script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>  
      <script type="text/javascript" src="dwr/interface/conceptosInverServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/cuentasMayorInvServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/subCtaTiProInvServicio.js"></script>         
		<script type="text/javascript" src="dwr/interface/subCtaTiPerInvServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/subCtaMonedaInvServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/subCtaPlazoInvServicio.js"></script>	
      
	   <script type="text/javascript" src="js/forma.js"></script>
	   <script type="text/javascript" src="js/inversiones/guiaContaInverCatalogo.js"></script>
	      
	</head>
   
<body>

<div id="contenedorForma">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Gu&iacute;a Contable Inversiones</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="GuiaContable">  	
			<fieldset class="ui-widget ui-widget-content ui-corner-all">           
				<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas Mayor</legend>     
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td class="label"> 
					         <label for="lblconceptoInvID">Concepto:</label> 
					     	</td>
					     	<td> 
			         		<select id="conceptoInvID" name="conceptoInvID" tabindex="1">
									<option value="-1">Seleccionar<option>
								</select>  
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblcuenta">Cuenta:</label> 
					     	</td>
					     	<td >
					     		 <input id="cuenta" name="cuenta"  size="13" 
					         		tabindex="2" /> 
					     	</td>  		
						</tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblnomenclatura">Nomenclatura Cuentas Inversi&oacute;n:</label> 
					     	</td>
					     	<td >
					     		<input id="nomenclatura" name="nomenclatura"  size="25" 
					         		tabindex="3" /> 
					         <a href="javaScript:" onClick="ayuda();">
								  	<img src="images/help-icon.gif" >
								</a> 
					     	</td>  		
						</tr> 
						<tr>
							<td class="label"> 
					         <label for="lblClaves"><b>Claves de Nomenclatura Cuentas Inversion: 	
					         <i><br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&CM');return false;">  &CM = Cuentas de Mayor </a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TD');return false;">  &TD = SubCuenta por Plazo (n&uacute;mero de dias)</a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TP');return false;">  &TP = SubCuenta por Tipo de Producto</a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TC');return false;">  &TC = SubCuenta por Tipo de Persona</a>
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
								<input type="submit" id="grabaCM" name="grabaCM" class="submit" value="Grabar"  tabindex="4"/>
								<input type="submit" id="modificaCM" name="modificaCM" class="submit" value="Modificar" tabindex="5"/>
								<input type="submit" id="eliminaCM" name="eliminaCM" class="submit" value="Eliminar" tabindex="6"/>
								<input type="hidden" id="tipoTransaccionCM" name="tipoTransaccionCM" value="tipoTransaccionCM"/>
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
					     		 <input id="conceptoInvID4" name="conceptoInvID4"  size="10" 
					         		tabindex="19" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblfisica">Fisica:</label> 
					     	</td>
					     	<td> 
					     		 <input id="fisica" name="fisica"  size="5" 
					         		tabindex="20" /> 
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblmoral">Moral:</label> 
					     	</td>
					     	<td >
					     		 <input id="moral" name="moral"  size="5" 
					         		tabindex="21" /> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaTPE" name="grabaTPE" class="submit" value="Grabar" tabindex="22"/>
								<input type="submit" id="modificaTPE" name="modificaTPE" class="submit" value="Modificar" tabindex="23"/>
								<input type="submit" id="eliminaTPE" name="eliminaTPE" class="submit" value="Eliminar" tabindex="24"/>
								<input type="hidden" id="tipoTransaccionTPE" name="tipoTransaccionTPE" value="2"/>
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
					     		 <input id="conceptoInvID3" name="conceptoInvID3"  size="13" 
					         		tabindex="13" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lbltipoProductoID">Producto:</label> 
					     	</td>
					     	<td> 
					         <select id="tipoProductoID" name="tipoProductoID"  tabindex="14">
									<option value="-1">Seleccionar</option>
								</select>
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuenta">SubCuenta:</label> 
					     	</td>
					     	<td >
					     		 <input id="subCuenta" name="subCuenta"  size="5" 
					         		tabindex="15" /> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaTPR" name="grabaTPR" class="submit" value="Grabar" tabindex="16"/>
								<input type="submit" id="modificaTPR" name="modificaTPR" class="submit" value="Modificar" tabindex="17" />
								<input type="submit" id="eliminaTPR" name="eliminaTPR" class="submit" value="Eliminar" tabindex="18"/>
								<input type="hidden" id="tipoTransaccionTPR" name="tipoTransaccionTPR" value="2"/>
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
					     		 <input id="conceptoInvID5" name="conceptoInvID5"  size="13" 
					         		tabindex="25" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblmonedaID">Moneda:</label> 
					     	</td>
					     	<td> 
					     		 <select id="monedaID" name="monedaID" tabindex="26">
									<option value="-1">Seleccionar</option>
								</select> 
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuenta2">SubCuenta</label> 
					     	</td>
					     	<td >
					     		 <input id="subCuenta2" name="subCuenta2"  size="5" 
					         		tabindex="27" /> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaSM" name="grabaSM" class="submit" value="Grabar" tabindex="28"/>
								<input type="submit" id="modificaSM" name="modificaSM" class="submit" value="Modificar" tabindex="29" />
								<input type="submit" id="eliminaSM" name="eliminaSM" class="submit" value="Eliminar" tabindex="30"/>
								<input type="hidden" id="tipoTransaccionSM" name="tipoTransaccionSM" value="2"/>
							</td>
						</tr>
					</table>
				</fieldset>
	</form:form>
	
	<form:form id="formaGenerica2" name="formaGenerica2" method="POST" commandName="GuiaContable"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Plazo</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td> 
					     		 <input id="conceptoInvID2" name="conceptoInvID2"  size="13" 
					         		tabindex="13" type="hidden" /> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblsubCtaPlazoInvID">Plazo:</label> 
					     	</td>
					     	<td> 
					         <select id="subCtaPlazoInvID" name="subCtaPlazoInvID"  tabindex="14">
									<option value="-1">Seleccionar</option>
								</select>
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuentaP">SubCuenta:</label> 
					     	</td>
					     	<td >
					     		 <input id="subCuentaP" name="subCuentaP"  size="5" 
					         		tabindex="15" /> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="modificaSP" name="modificaSP" class="submit" value="Grabar" tabindex="17" />
								<input type="submit" id="eliminaSP" name="eliminaSP" class="submit" value="Eliminar" tabindex="18"/>
								<input type="hidden" id="tipoTransaccionSP" name="tipoTransaccionSP" value="2"/>
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
