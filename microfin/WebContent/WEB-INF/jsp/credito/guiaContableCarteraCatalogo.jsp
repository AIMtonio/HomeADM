<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	         
	<script type="text/javascript" src="dwr/interface/guiaContableCartServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>  
      <script type="text/javascript" src="dwr/interface/conceptosCarteraServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/cuentasMayorCarServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/subctaClasifCartServicio.js"></script>   
      <script type="text/javascript" src="dwr/interface/subctaMonedaCartServicio.js"></script>  
      <script type="text/javascript" src="dwr/interface/subctaProductCartServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/subctaTipoCartServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/clasificCreditoServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/subCtaSubClasifCartServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/subCuentaIVACartServicio.js"></script> 
      
	   <script type="text/javascript" src="js/credito/guiaContableCarteraCatalogo.js"></script>	      
	</head>
   
<body>

<div id="contenedorForma">   
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Gu&iacute;a Contable Cartera</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="Cartera">  	
			<fieldset class="ui-widget ui-widget-content ui-corner-all">           
				<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas Mayor</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td class="label"> 
					         <label for="lblconceptoCarID">Concepto:</label> 
					     	</td>
					     	<td> 
			         		<select id="conceptoCarID" name="conceptoCarID" tabindex="1">
									<option value="0">Seleccionar<option>
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
					         <label for="lblnomenclatura">Nomenclatura:</label> 
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
					         <label for="lblClaves"><b>Claves de Nomenclatura Cuentas: 	
					         <i><br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&CM');return false;">  &CM = Cuentas de Mayor </a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&CL');return false;">  &CL = SubCuenta Clasificaci&oacute;n</a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&SC');return false;">  &SC = SubCuenta SubClasificaci&oacute;n</a>					         
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TP');return false;">  &TP = SubCuenta por Producto de Cr&eacute;dito</a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TM');return false;">  &TM = SubCuenta por Tipo de Moneda </a>			         
							 <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&FD');return false;">  &FD = SubCuenta por Fondeador </a>
							 <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&IA');return false;">  &IA = SubCuenta por IVA Asignado </b> </b> </b> </a></label>					         
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
 
		<form:form id="formaGenerica2" name="formaGenerica2" method="POST" commandName="Cartera"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Clasificación</legend>   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td> 
					     		 <input id="conceptoCarID2" name="conceptoCarID2"  size="10" 
					         		tabindex="19" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblConsumo">Consumo:</label> 
					     	</td>
					     	<td> 
					     		 <input id="consumo" name="consumo"  size="5" 
					         		tabindex="20" maxlength="2"/> 
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblcomercial">Comercial:</label> 
					     	</td>
					     	<td >
					     		 <input id="comercial" name="comercial"  size="5" 
					         		tabindex="21" maxlength="2"/> 
					     	</td>  		
						</tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblvivienda">Vivienda:</label> 
					     	</td>
					     	<td >
					     		 <input id="vivienda" name="vivienda"  size="5" 
					         		tabindex="22" maxlength="2"/> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaClas" name="grabaClas" class="submit" value="Grabar" tabindex="23"/>
								<input type="submit" id="modificaClas" name="modificaClas" class="submit" value="Modificar" tabindex="24"/>
								<input type="submit" id="eliminaClas" name="eliminaClas" class="submit" value="Eliminar" tabindex="25"/>
								<input type="hidden" id="tipoTransaccionCC" name="tipoTransaccionCC" value="2"/>
							</td>
						</tr>
					</table>		
				</fieldset>
			
	</form:form>
	<br><br>
	
	<form:form id="formaGenerica5" name="formaGenerica5" method="POST" commandName="Cartera"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Por SubClasificación</legend>   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   		<td> 
					     		 <input type="hidden" id="conceptoCarID5" name="conceptoCarID5"  size="13" 
					         		tabindex="26" /> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblproducCreditoID">Producto:</label> 
					     	</td>
					     	<td> 
					     		 <select id="producCreditoID5" name="producCreditoID5" tabindex="27">
									<option value="">Seleccionar</option>
								</select> 
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuenta">SubCuenta</label> 
					     	</td>
					     	<td >
					     		 <input type="text" id="subCuenta5" name="subCuenta5"  size="8" tabindex="28" maxlength="6"/>
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaSubClas" name="grabaSubClas" class="submit" value="Grabar" tabindex="29"/>
								<input type="submit" id="modificaSubClas" name="modificaSubClas" class="submit" value="Modificar" tabindex="30"/>
								<input type="submit" id="eliminaSubClas" name="eliminaSubClas" class="submit" value="Eliminar" tabindex="31"/>
								<input type="hidden" id="tipoTransaccionSC" name="tipoTransaccionSC"/>
							</td>
						</tr>
					</table>		
				</fieldset>
			
	</form:form>
	<br><br>
	
	<form:form id="formaGenerica3" name="formaGenerica3" method="POST" commandName="Cartera"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Producto</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   		<td> 
					     		 <input id="conceptoCarID3" name="conceptoCarID3"  size="13" 
					         		tabindex="32" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblproducCreditoID">Producto:</label> 
					     	</td>
					     	<td> 
					     		 <select id="producCreditoID" name="producCreditoID" tabindex="33">
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
					         		tabindex="34" /> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaPro" name="grabaPro" class="submit" value="Grabar" tabindex="35"/>
								<input type="submit" id="modificaPro" name="modificaPro" class="submit" value="Modificar" tabindex="36" />
								<input type="submit" id="eliminaPro" name="eliminaPro" class="submit" value="Eliminar" tabindex="37"/>
								<input type="hidden" id="tipoTransaccionPC" name="tipoTransaccionPC"/>
							</td>
						</tr>
					</table>
				</fieldset>
	</form:form>
	<br><br>
		<form:form id="formaGenerica4" name="formaGenerica4" method="POST" commandName="Cartera"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Moneda</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td> 
					     		 <input id="conceptoCarID4" name="conceptoCarID4"  size="13" 
					         		tabindex="38" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblmonedaID">Moneda:</label> 
					     	</td>
					     	<td> 
					     		 <select id="monedaID" name="monedaID" tabindex="39">
									<option value="-1">Seleccionar</option>
								</select> 
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuenta">SubCuenta</label> 
					     	</td>
					     	<td >
					     		 <input id="subCuenta1" name="subCuenta1"  size="5" 
					         		tabindex="40" /> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaMon" name="grabaMon" class="submit" value="Grabar" tabindex="41"/>
								<input type="submit" id="modificaMon" name="modificaMon" class="submit" value="Modificar" tabindex="42" />
								<input type="submit" id="eliminaMon" name="eliminaMon" class="submit" value="Eliminar" tabindex="43"/>
								<input type="hidden" id="tipoTransaccionMC" name="tipoTransaccionMC"/>
							</td>
						</tr>
					</table>
				</fieldset>
	</form:form>
	<br><br>
	
	<!--FONDEADOR-->
			<form:form id="formaGenerica6" name="formaGenerica6" method="POST" commandName="Cartera"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Fondeador</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td> 
					     		 <input id="conceptoCarID6" name="conceptoCarID6"  size="13" 
					         		tabindex="41" type="hidden"/> 
					     	</td> 
					   </tr>
					   
					    
						<tr>
						   	<td class="label"> 
						         <label for="lblfondeoID">Fondeo:</label> 
						     </td>
						     
						     <td> 
									 <input id="fondeoID" name="fondeoID" path="fondeoID" size="12" tabindex="42" style="margin-bottom:3px"/>
							     	<input type="text" id="descripFondeo" name="descripFondeo" size="43"  disabled="true"/>         	  
						     </td>
					    </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuenta">SubCuenta</label> 
					     	</td>
					     	<td >
					     		 <input id="subCuenta6" name="subCuenta6"  size="5" 
					         		tabindex="44" /> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaFon" name="grabaFon" class="submit" value="Grabar" tabindex="45"/>
								<input type="submit" id="modificaFon" name="modificaFon" class="submit" value="Modificar" tabindex="46" />
								<input type="submit" id="eliminaFon" name="eliminaFon" class="submit" value="Eliminar" tabindex="47"/>
								<input type="hidden" id="tipoTransaccionFD" name="tipoTransaccionFD"/>
							</td>
						</tr>
					</table>
				</fieldset>
	</form:form>
	
	<br></br>
	
	<!--IVA Asignado -->
	<form:form id="formaGenerica7" name="formaGenerica7" method="POST" commandName="Cartera"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por IVA Asignado</legend>                   
				<table >     
					<tr>
				   		<td> 
				     		 <input id="conceptoCarID7" name="conceptoCarID7" size="13" type="hidden"/> 
				     	</td> 
				   </tr> 
					<tr>
				   		<td class="label"> 
				        	<label for="lblporcentaje">% IVA:</label> 
				     	</td>
				     	<td> 
				     		 <select id="porcentaje" name="porcentaje" tabindex="50">
								<option value="">SELECCIONAR</option>
								<option value="8"> 8 % </option>
								<option value="16"> 16 % </option>
							</select> 
				     	</td> 
				   </tr> 
					<tr>  
				      	<td class="label"> 
				        	<label for="lblsubCuenta">SubCuenta: </label> 
				     	</td>
				     	<td >
				     		 <input id="subCuenta7" name="subCuenta7" maxlength="2" size="5" tabindex="51" /> 
				     	</td>  		
					</tr> 
				</table>
				<br></br>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
					<tr>
						<td align="right">
							<input type="submit" id="grabaIA" name="grabaIA" class="submit" value="Grabar" tabindex="52"/>
							<input type="submit" id="modificaIA" name="modificaIA" class="submit" value="Modificar" tabindex="53" />
							<input type="submit" id="eliminaIA" name="eliminaIA" class="submit" value="Eliminar" tabindex="54"/>
							<input type="hidden" id="tipoTransaccionIA" name="tipoTransaccionIA"/>
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