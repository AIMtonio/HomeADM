<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	 	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/cuentasMayorArrendaServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/subCtaTiProArrendaServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/subCtaTipoArrendaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/subCtaMonedaArrendaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conceptosArrendaServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/productoArrendaServicio.js"></script>		
		<script type="text/javascript" src="dwr/interface/subCtaPlazoArrendaServicio.js"></script>		
		<script type="text/javascript" src="dwr/interface/subCtaSucurArrendaServicio.js"></script>	
		
		<script type="text/javascript" src="js/arrendamiento/guiaContaArrendaCatalogo.js"></script>
	</head>
<body>

<div id="contenedorForma">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Gu&iacute;a Contable Arrendamiento</legend>
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="GuiaContable">  	
		<fieldset class="ui-widget ui-widget-content ui-corner-all">           
		<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas Mayor</legend>     
			<table border="0" width="100%">  
				<tr>
					<td class="label"><label for="conceptoArrendaID">Concepto:</label></td>
				    <td> 
		         		<select id="conceptoArrendaID" name="conceptoArrendaID" tabindex="1">
							<option value="">SELECCIONAR<option>
						</select>  
					</td> 
				</tr> 
				<tr>  
					<td class="label"><label for="cuenta">Cuenta:</label></td>
				    <td>
				    	<input id="cuenta" name="cuenta"  size="13" maxlength="12" class="valid" tabindex="2" /> 
				    </td>  		
				</tr> 
				<tr>  
					<td class="label"><label for="nomenclatura">Nomenclatura:</label></td>
					<td>
						<input id="nomenclatura" name="nomenclatura"  size="25"  maxlength="30" class="valid" tabindex="3" /> 
					         <a href="javaScript:" onClick="ayuda();"><img src="images/help-icon.gif" ></a> 
					</td>  		
				</tr> 
				<tr>
					<td class="label"> <i>
			         	<label for="lblClaves"><b>Claves de Nomenclatura: 	
			         		<br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&CM');return false;">  &CM = Cuentas de Mayor </a>
				         	<br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&PA');return false;">  &PA = SubCuenta por Producto</a>
				         	<br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TA');return false;">  &TA = SubCuenta por Tipo</a>
				         	<br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&SM');return false;">  &SM = SubCuenta Moneda</a>
				         	<br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&SS');return false;">  &SS = SubCuenta Sucursal</a>
				         	<br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&SP');return false;">  &SP = SubCuenta Plazo</a>

			         	</label> 
			     		</i>
			     	</td>
				</tr>
				<tr>  
			      	<td class="label"><label for="nomenclaturaCR">Nomenclatura Centro Costo:</label></td>
			     	<td>
			 			<input id="nomenclaturaCR" name="nomenclaturaCR"  size="25"  tabindex="4" /> 
			         	<a href="javaScript:" onClick="ayudaCR();"><img src="images/help-icon.gif" ></a> 
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
			<table border="0" width="100%" align="right">  
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
		<legend class="ui-widget ui-widget-header ui-corner-all">Por Producto</legend>                   
			<table border="0" width="100%">     
				<tr>
			   		<td> 
			     		 <input id="conceptoArrendaID2" name="conceptoArrendaID2"  size="13"  tabindex="8" type="hidden"/>
			     	</td> 
		   		</tr> 
				<tr>
			   		<td class="label"><label for="productoArrendaID">Producto Arrendamiento:</label></td>
		     		<td> 
		         		<input type="text" id="productoArrendaID" name="productoArrendaID"  size="12" tabindex="9" autocomplete="off" />
		 				<input type="text" id="descripcionProducto" name="descripcionProducto"  disabled="true"  readonly="readonly" size="35"/>
					</td>
		   		</tr> 
				<tr>  
		      		<td class="label"><label for="subCuenta">SubCuenta:</label></td>
		     		<td >
		     		 	<input id="subCuenta" name="subCuenta"   size="7" maxlength="6" class="valid"  tabindex="10" /> 
		     		</td>  		
				</tr> 
			</table>
			<br></br>
			<table border="0" width="100%" align="right">  
				<tr>
					<td align="right">
						<input type="submit" id="grabaSTP" name="grabaSTP" class="submit" value="Grabar" tabindex="11"/>
						<input type="submit" id="modificaSTP" name="modificaSTP" class="submit" value="Modificar" tabindex="12" />
						<input type="submit" id="eliminaSTP" name="eliminaSTP" class="submit" value="Eliminar" tabindex="13"/>
						<input type="hidden" id="tipoTransaccionSTP" name="tipoTransaccionSTP"/>
					</td>
				</tr>
			</table>
		</fieldset> 
	</form:form>
	<br></br>
	
	<form:form id="formaGenerica3" name="formaGenerica3" method="POST" commandName="GuiaContable"> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo</legend>                   
		<table border="0"  width="100%">     
			<tr>
				<td><input id="conceptoArrendaID3" name="conceptoArrendaID3"  size="13" tabindex="14" type="hidden"/></td> 
			</tr> 
			<tr>
			   	<td class="label"><label for="tipoArrenda">Tipo Arrendamiento</label> 
				</td>
				<td >
			   		<select id="tipoArrenda" name="tipoArrenda"  tabindex="15" >
				    	<option value="">SELECCIONAR</option>
				    	<option value="F">FINANCIADO</option>
				    	<option value="P">PURO</option>
					</select>
				</td>  	
		 	</tr> 
			<tr>  
	      		<td class="label"><label for="subCuenta2">SubCuenta:</label></td>
	     		<td >
	     		 	<input id="subCuenta2" name="subCuenta2"   size="7" maxlength="6" class="valid"  tabindex="16" /> 
	     		</td>  		
			</tr> 	
			</table>
			<br></br>
			<table border="0" width="100%" align="right">  
				<tr>
					<td align="right">
						<input type="submit" id="grabaSTA" name="grabaSTA" class="submit" value="Grabar" tabindex="17"/>
						<input type="submit" id="modificaSTA" name="modificaSTA" class="submit" value="Modificar" tabindex="18" />
						<input type="submit" id="eliminaSTA" name="eliminaSTA" class="submit" value="Eliminar" tabindex="19"/>
						<input type="hidden" id="tipoTransaccionSTA" name="tipoTransaccionSTA" />
					</td>
				</tr>
			</table>
		</fieldset> 
	</form:form>
	<br></br>
	<form:form id="formaGenerica4" name="formaGenerica4" method="POST" commandName="GuiaContable"> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Por Moneda</legend>                   
			<table border="0" width="100%">     
				<tr>
			   		<td><input id="conceptoArrendaID4" name="conceptoArrendaID4"  size="13"  tabindex="20" type="hidden"/></td> 
			   	</tr> 
				<tr>
				   	<td class="label"><label for="monedaID">Moneda:</label></td>
					<td> 
			     		 <select id="monedaID" name="monedaID" tabindex="21">
							<option value="">SELECCIONAR</option>
						</select> 
			     	</td> 
				</tr> 
				<tr>  
			      <td class="label"> 
			         <label for="subCuenta3">SubCuenta:</label> 
			     	</td>
			     	<td >
			     		 <input id="subCuenta3" name="subCuenta3"  size="7" maxlength="6" class="valid"  tabindex="22" /> 
			     	</td>  		
				</tr> 
			</table>
			<br></br>
			<table border="0"  width="100%" align="right">  
				<tr>
					<td align="right">
						<input type="submit" id="grabaSM" name="grabaSM" class="submit" value="Grabar" tabindex="23"/>
						<input type="submit" id="modificaSM" name="modificaSM" class="submit" value="Modificar" tabindex="24" />
						<input type="submit" id="eliminaSM" name="eliminaSM" class="submit" value="Eliminar" tabindex="25"/>
						<input type="hidden" id="tipoTransaccionSM" name="tipoTransaccionSM" value="tipoTransaccionSM"/>
					</td>
				</tr>
			</table>
		</fieldset> 
	</form:form>
	<form:form id="formaGenerica5" name="formaGenerica4" method="POST" commandName="GuiaContable"> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Por Sucursal</legend>                   
			<table border="0" width="100%">     
				<tr>
			   		<td><input id="conceptoArrendaID5" name="conceptoArrendaID5"  size="13"  tabindex="26" type="hidden"/></td> 
			   	</tr> 
				<tr>
				   	<td class="label"><label for="sucursalID">Sucursal:</label></td>
					<td> 
			     		<input type="text" id="sucursalID" name="sucursalID"  size="12" tabindex="27" autocomplete="off" />
		 				<input type="text" id="sucursalDes" name="sucursalDes"  disabled="true"  readonly="readonly" size="35"/>
			     	</td> 
				</tr> 
				<tr>  
			      <td class="label"> 
			         <label for="subCuenta4">SubCuenta:</label> 
			     	</td>
			     	<td >
			     		 <input id="subCuenta4" name="subCuenta4"  size="7" maxlength="6" class="valid"  tabindex="28" /> 
			     	</td>  		
				</tr> 
			</table>
			<br></br>
			<table border="0"  width="100%" align="right">  
				<tr>
					<td align="right">
						<input type="submit" id="grabaSS" name="grabaSS" class="submit" value="Grabar" tabindex="29"/>
						<input type="submit" id="modificaSS" name="modificaSS" class="submit" value="Modificar" tabindex="30" />
						<input type="submit" id="eliminaSS" name="eliminaSS" class="submit" value="Eliminar" tabindex="31"/>
						<input type="hidden" id="tipoTransaccionSS" name="tipoTransaccionSS" value="tipoTransaccionSS"/>
					</td>
				</tr>
			</table>
		</fieldset> 
	</form:form>
	<form:form id="formaGenerica6" name="formaGenerica4" method="POST" commandName="GuiaContable"> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Por Plazo</legend>                   
			<table border="0" width="100%">     
				<tr>
			   		<td><input id="conceptoArrendaID6" name="conceptoArrendaID6"  size="13"  tabindex="32" type="hidden"/></td> 
			   	</tr> 
				<tr>
				   	<td class="label"><label for="plazo">Plazo:</label></td>
					<td> 
			     		 <select id="plazo" name="plazo" tabindex="33">
							<option value="">SELECCIONAR</option>
							<option value="L">LARGO PLAZO</option>
							<option value="C">CORTO PLAZO</option>
						</select> 
			     	</td> 
				</tr> 
				<tr>  
			      <td class="label"> 
			         <label for="subCuenta5">SubCuenta:</label> 
			     	</td>
			     	<td >
			     		 <input id="subCuenta5" name="subCuenta5"  size="7" maxlength="6" class="valid"  tabindex="34" /> 
			     	</td>  		
				</tr> 
			</table>
			<br></br>
			<table border="0"  width="100%" align="right">  
				<tr>
					<td align="right">
						<input type="submit" id="grabaSP" name="grabaSP" class="submit" value="Grabar" tabindex="35"/>
						<input type="submit" id="modificaSP" name="modificaSP" class="submit" value="Modificar" tabindex="36" />
						<input type="submit" id="eliminaSP" name="eliminaSP" class="submit" value="Eliminar" tabindex="37"/>
						<input type="hidden" id="tipoTransaccionSP" name="tipoTransaccionSP" value="tipoTransaccionSP"/>
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