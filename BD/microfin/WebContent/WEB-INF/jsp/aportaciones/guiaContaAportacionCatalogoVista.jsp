<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	      
    	<script type="text/javascript" src="dwr/engine.js"></script>
      	<script type="text/javascript" src="dwr/util.js"></script>     
		<script type="text/javascript" src="dwr/interface/tiposAportacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/plazosAportacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>   
      	<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/conceptosAportacionServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/cuentasMayorAportacionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/subCtaTiProAportacionServicio.js"></script>         
		<script type="text/javascript" src="dwr/interface/subCtaTiPerAportacionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/subCtaMonedaAportacionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/subCtaPlazoAportacionServicio.js"></script>	
      
	   <script type="text/javascript" src="js/forma.js"></script>
	   <script type="text/javascript" src="js/aportaciones/guiaContaAportacionCatalogo.js"></script>
	</head>
   
	<body>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Gu&iacute;a Contable Aportaciones</legend>
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="GuiaContable">  	
					<fieldset class="ui-widget ui-widget-content ui-corner-all">           
					<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas Mayor</legend>     
						<table border="0" cellpadding="0" cellspacing="0" width="100%">     
							<tr>
						  		<td class="label"> 
						       	<label for="conceptoAportacionID">Concepto:</label> 
						    	</td>
						    	<td> 
						       		<select id="conceptoAportacionID" name="conceptoAportacionID" tabindex="1" style="text-transform:uppercase">
									<option value="-1">SELECCIONAR<option>
								</select>  
						    	</td> 
							</tr> 
							<tr>  
								<td class="label"> 
							        <label for="cuenta">Cuenta:</label> 
							    </td>
							    <td>
							    	 <input id="cuenta" name="cuenta"  size="13" tabindex="2" /> 
							    </td>  		
							</tr> 
							<tr> 
						    	<td class="label"> 
						        	<label for="nomenclatura">Nomenclatura Cuentas Aportaciones:</label> 
						     	</td>
						     	<td>
						     		<input id="nomenclatura" name="nomenclatura"  size="25" tabindex="3" /> 
						         	<a href="javaScript:" onClick="ayuda();">
									 	<img src="images/help-icon.gif" >
									</a> 
						     	</td>  		
							</tr> 
							<tr>
								<td class="label"> 
					         		<label for="lblClaves"><b>Claves de Nomenclatura Cuentas Aportaciones: 	
					         		<i><br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&CM');return false;">  &CM = Cuentas de Mayor </a>
							         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TP');return false;">  &TP = SubCuenta por Tipo de Producto</a>
							         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TD');return false;">  &TD = SubCuenta por Plazo (n&uacute;mero de d&iacute;as)</a>
							         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TC');return false;">  &TC = SubCuenta por Tipo de Cliente</a>
							         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TM');return false;">  &TM = SubCuenta por Tipo de Moneda </b> </a></label>
							         </i> 
						     	</td>
							</tr> 
							<tr> 
						    	<td class="label"> 
						        	<label for="nomenclaturaCR">Nomenclatura Centro Costo:</label> 
						    	</td>
						     	<td >
						     		<input id="nomenclaturaCR" name="nomenclaturaCR"  size="25" tabindex="4" /> 
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
				<form:form id="formaGenerica3" name="formaGenerica3" method="POST" commandName="GuiaContable"> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Producto</legend>                   
						<table border="0" cellpadding="0" cellspacing="0" width="100%">     
							<tr>
						   		<td> 
						     		<input id="conceptoAportacionID3" name="conceptoAportacionID3"  size="13" tabindex="8" type="hidden"/> 
						     	</td> 
						   </tr> 
						   <tr>
						   		<td class="label"> 
						        	<label for="tipoProductoID">Producto:</label> 
						     	</td>
						     	<td> 
						        	<select id="tipoProductoID" name="tipoProductoID"  tabindex="9" style="text-transform:uppercase">
										<option value="-1">SELECCIONAR</option>
									</select>
						     	</td> 
							</tr> 
							<tr>  
						    	<td class="label"> 
						        	<label for="subCuenta">SubCuenta:</label> 
						     	</td>
						     	<td >
						     		<input id="subCuenta" name="subCuenta"  size="5" tabindex="10" /> 
						     	</td>  		
							</tr> 
						</table>
						<br></br>
						<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
							<tr>
								<td align="right">
									<input type="submit" id="grabaTPR" name="grabaTPR" class="submit" value="Grabar" tabindex="11"/>
									<input type="submit" id="modificaTPR" name="modificaTPR" class="submit" value="Modificar" tabindex="12" />
									<input type="submit" id="eliminaTPR" name="eliminaTPR" class="submit" value="Eliminar" tabindex="13"/>
									<input type="hidden" id="tipoTransaccionTPR" name="tipoTransaccionTPR" value="2"/>
								</td>
							</tr>
						</table>
					</fieldset> 
				</form:form>
				<br></br>
				<form:form id="formaGenerica2" name="formaGenerica2" method="POST" commandName="GuiaContable"> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Por Plazo</legend>                   
						<table border="0" cellpadding="0" cellspacing="0" width="100%">     
							<tr>
					   			<td> 
					     			<input id="conceptoAportacionID2" name="conceptoAportacionID2"  size="13" tabindex="14" type="hidden" /> 
					     		</td> 
					   		</tr> 
							<tr>
					   			<td class="label"> 
					         		<label for="subCtaPlazoAportacionID">Plazo:</label> 
					     		</td>
					     		<td> 
					         		<select id="subCtaPlazoAportacionID" name="subCtaPlazoAportacionID"  tabindex="15" style="text-transform:uppercase">
										<option value="-1">SELECCIONAR</option>
									</select>
					     		</td> 
					   		</tr> 
							<tr>  
					      		<td class="label"> 
					         		<label for="subCuentaP">SubCuenta:</label> 
					     		</td>
					     		<td>
					     			<input id="subCuentaP" name="subCuentaP"  size="5" tabindex="16" /> 
					     		</td>  		
							</tr> 
						</table>
						<br></br>
						<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
							<tr>
								<td align="right">
									<input type="submit" id="grabaSP" name="grabaSP" class="submit" value="Grabar" tabindex="17"/>
									<input type="submit" id="modificaSP" name="modificaSP" class="submit" value="Modificar" tabindex="18" />
									<input type="submit" id="eliminaSP" name="eliminaSP" class="submit" value="Eliminar" tabindex="19"/>
									<input type="hidden" id="tipoTransaccionSP" name="tipoTransaccionSP" value="2"/>
									<input type="hidden" id="tipoAportacionID" name="tipoAportacionID" />
									<input type="hidden" id="plazoInferior" name="plazoInferior"/>
									<input type="hidden" id="plazoSuperior" name="plazoSuperior"/>
								</td>
							</tr>
						</table>
					</fieldset> 
				</form:form>
				<br></br>
				<form:form id="formaGenerica4" name="formaGenerica4" method="POST" commandName="GuiaContable"> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de <s:message code="safilocale.cliente"/> </legend>   
						<table border="0" cellpadding="0" cellspacing="0" width="100%">     
							<tr>
						   		<td> 
						     		<input id="conceptoAportacionID4" name="conceptoAportacionID4"  size="10" tabindex="20" type="hidden"/> 
								</td> 
						  	</tr> 
						  	<tr>
						  		<td class="label"> 
						        	<label for="fisica">F&iacute;sica:</label> 
						    	</td>
						    	<td> 
						    		<input id="fisica" name="fisica"  size="5" tabindex="21" /> 
						    	</td> 
						  	</tr> 
							<tr>  
						    	<td class="label"> 
						        	<label for="moral">Moral:</label> 
						     	</td>
						     	<td>
						     		<input id="moral" name="moral"  size="5" tabindex="22" /> 
						     	</td>  		
							</tr> 
							<tr>  
						    	<td class="label"> 
						        	<label for="fisicaActEmp">F&iacute;sica Act. Emp.:</label> 
						     	</td>
						     	<td>
						     		<input id="fisicaActEmp" name="fisicaActEmp"  size="5" tabindex="23" /> 
						     	</td>  		
							</tr> 
						</table>
						<br></br>
						<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
							<tr>
								<td align="right">
									<input type="submit" id="grabaTPE" name="grabaTPE" class="submit" value="Grabar" tabindex="24"/>
									<input type="submit" id="modificaTPE" name="modificaTPE" class="submit" value="Modificar" tabindex="25"/>
									<input type="submit" id="eliminaTPE" name="eliminaTPE" class="submit" value="Eliminar" tabindex="26"/>
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
					     			<input id="conceptoAportacionID5" name="conceptoAportacionID5"  size="13" tabindex="27" type="hidden"/> 
					     		</td> 
							</tr> 
							<tr>
					   			<td class="label"> 
					         		<label for="monedaID">Moneda:</label> 
					     		</td>
					     		<td> 
					     			<select id="monedaID" name="monedaID" tabindex="28" style="text-transform:uppercase">
										<option value="-1">SELECCIONAR</option>
									</select> 
					     		</td> 
							</tr> 
							<tr>  
					      		<td class="label"> 
					         		<label for="subCuenta2">SubCuenta:</label> 
					     		</td>
					     		<td>
					     			<input id="subCuenta2" name="subCuenta2"  size="5" tabindex="29" /> 
					     		</td>  		
							</tr> 
						</table>
						<br></br>
						<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
							<tr>
								<td align="right">
									<input type="submit" id="grabaSM" name="grabaSM" class="submit" value="Grabar" tabindex="30"/>
									<input type="submit" id="modificaSM" name="modificaSM" class="submit" value="Modificar" tabindex="31" />
									<input type="submit" id="eliminaSM" name="eliminaSM" class="submit" value="Eliminar" tabindex="32"/>
									<input type="hidden" id="tipoTransaccionSM" name="tipoTransaccionSM" value="2"/>
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
		<div id="mensaje" style="display: none;"></div>
		<div id="ContenedorAyuda" style="display: none;">
		</div>
		<div id="elementoLista">
		</div>
	</body>
</html>
