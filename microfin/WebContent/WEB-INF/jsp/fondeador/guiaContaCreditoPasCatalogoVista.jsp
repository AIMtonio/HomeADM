<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/guiaContableCreditoPasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/cuentasMayorCreditoPasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/subCtaTiInstCreditoPasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/subCtaTipInstFondeo.js"></script>		
		<script type="text/javascript" src="dwr/interface/subCtaPorPlazoFondeo.js"></script>	
		<script type="text/javascript" src="dwr/interface/subCtaInstFondeo.js"></script>	
		<script type="text/javascript" src="dwr/interface/subCtaNacInstFondeo.js"></script>
		<script type="text/javascript" src="dwr/interface/subCtaTipPerFonServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/subCtaMonFonServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
				
		<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/conceptosFondServicio.js"></script>	
		<script type="text/javascript" src="js/fondeador/guiaContaCreditoPasCatalogo.js"></script>

	</head>
   
<body>

<div id="contenedorForma">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Gu&iacute;a Contable Cr&eacute;dito Pasivo</legend>
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="GuiaContable">  	
		<fieldset class="ui-widget ui-widget-content ui-corner-all">           
			<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas Mayor</legend>     
			<table border="0" cellpadding="0" cellspacing="0" width="100%">  
			<tr>
					<td class="label"> 
				    	<label for="lblTipofondeador">Aplica para:</label> 
					</td>
				    <td> 
		         		<select id="tipoFondeador" name="tipoFondeador" tabindex="1">
							<option value="I">INVERSIONISTA</option>
							<option value="F">FONDEADOR</option>
						</select>  
				     </td> 
				</tr>    
				<tr>
					<td class="label"> 
				    	<label for="lblconceptoFondID">Concepto:</label> 
					</td>
				    <td> 
		         		<select id="conceptoFondID" name="conceptoFondID" tabindex="2">
							<option value="-1">SELECCIONAR<option>
						</select>  
				     </td> 
				</tr> 
				<tr>  
					<td class="label"> 
				    	<label for="lblcuenta">Cuenta:</label> 
					</td>
				    <td >
				    	<input id="cuenta" name="cuenta"  size="13" maxlength="12" class="valid" tabindex="3" /> 
				    </td>  		
				</tr> 
				<tr>  
					<td class="label"> 
						<label for="lblnomenclatura">Nomenclatura:</label> 
					</td>
					<td >
						<input id="nomenclatura" name="nomenclatura"  size="25"  maxlength="30" class="valid" tabindex="4" /> 
					         <a href="javaScript:" onClick="ayuda();">
								  	<img src="images/help-icon.gif" >
								</a> 
					     	</td>  		
						</tr> 
						<tr>
							<td class="label"> <i>
					         <label for="lblClaves"><b>Claves de Nomenclatura: 	
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&CM');return false;">  &CM = Cuentas de Mayor </a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TI');return false;">  &TI = SubCuenta por Tipo de Instituci&oacute;n</a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&PL');return false;">  &PL = SubCuenta por Plazo</a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&NC');return false;">  &NC = SubCuenta Nacionalidad Instituci&oacute;n</a>
			     	         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&IF');return false;">  &IF = SubCuenta Instituci&oacute;n Fondeo</a>
			     	         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TC');return false;">  &TC = SubCuenta por Tipo de Persona</a>
			     	         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TM');return false;">  &TM = SubCuenta por Tipo de Moneda</a>
					         </label> 
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
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Instituci&oacute;n</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td> 
					     		 <input id="conceptoFondID2" name="conceptoFondID2"  size="13" 
					         		tabindex="13" type="hidden"/>
					         		
					     		 <input id="tipoFondeador2" name="tipoFondeador2"  size="13" 
					         		tabindex="13" type="hidden"/> 
					         		
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lbltipoInstitID">Tipo Instituci&oacute;n:</label> 
					     	</td>
					     	<td> 
					         <select id="tipoInstitID" name="tipoInstitID"  tabindex="14">
									<option value="-1">Seleccionar</option>
								</select>
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuenta">SubCuenta:</label> 
					     	</td>
					     	<td >
					     		 <input id="subCuenta" name="subCuenta"   size="7" maxlength="6" class="valid" 
					         		tabindex="15" /> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaTP" name="grabaTP" class="submit" value="Grabar" tabindex="16"/>
								<input type="submit" id="modificaTP" name="modificaTP" class="submit" value="Modificar" tabindex="17" />
								<input type="submit" id="eliminaTP" name="eliminaTP" class="submit" value="Eliminar" tabindex="18"/>
								<input type="hidden" id="tipoTransaccionTPI" name="tipoTransaccionTPI"/>
							</td>
						</tr>
					</table>
				</fieldset> 
	</form:form>
	<br></br>
	
	<form:form id="formaGenerica3" name="formaGenerica3" method="POST" commandName="GuiaContable"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Plazo</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td> 
					     		 <input id="conceptoFondID3" name="conceptoFondID3"  size="13" 
					         		tabindex="13" type="hidden"/> 
					     		 <input id="tipoFondeador3" name="tipoFondeador3"  size="13" 
					         		tabindex="13" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblplazoCorto">Corto Plazo</label> 
					     	</td>
					
					     	<td >
					     		 <input id="cortoPlazo" name="cortoPlazo"  size="7" maxlength="6" class="valid"
					         		tabindex="15" /> 
					     	</td>  	
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblPlazoLargo">Largo Plazo</label> 
					     	</td>
					     	<td >
					     		 <input id="largoPlazo" name="largoPlazo"  size="7" maxlength="6" class="valid"
					         		tabindex="15" /> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaPL" name="grabaPL" class="submit" value="Grabar" tabindex="16"/>
								<input type="submit" id="modificaPL" name="modificaPL" class="submit" value="Modificar" tabindex="17" />
								<input type="submit" id="eliminaPL" name="eliminaPL" class="submit" value="Eliminar" tabindex="18"/>
								<input type="hidden" id="tipoTransaccionPLZ" name="tipoTransaccionPLZ" />
							</td>
						</tr>
					</table>
				</fieldset> 
	</form:form>
	<br></br>
	

	<form:form id="formaGenerica4" name="formaGenerica4" method="POST" commandName="GuiaContable"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Nacionalidad de Instituci&oacute;n</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td> 
					     		 <input id="conceptoFondID4" name="conceptoFondID4"  size="13" 
					         		tabindex="13" type="hidden"/> 
					     		 <input id="tipoFondeador4" name="tipoFondeador4"  size="13" 
					         		tabindex="13" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblnacionalidad">Nacional:</label> 
					     	</td>
					     	<td> 
					          <input id="nacional" name="nacional"  size="7" maxlength="6" class="valid"
					         		tabindex="15" />
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblextranjera">Extranjera:</label> 
					     	</td>
					     	<td >
					     		 <input id="extranjera" name="extranjera"  size="7" maxlength="6" class="valid"
					         		tabindex="15" /> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaNC" name="grabaNC" class="submit" value="Grabar" tabindex="16"/>
								<input type="submit" id="modificaNC" name="modificaNC" class="submit" value="Modificar" tabindex="17" />
								<input type="submit" id="eliminaNC" name="eliminaNC" class="submit" value="Eliminar" tabindex="18"/>
								<input type="hidden" id="tipoTransaccionNC" name="tipoTransaccionNC" value="tipoTransaccionNC"/>
							</td>
						</tr>
					</table>
				</fieldset> 
	</form:form>
	<br></br>
		<form:form id="formaGenerica5" name="formaGenerica5" method="POST" commandName="GuiaContable"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Instituci&oacute;n de Fondeo</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td> 
					     		 <input id="conceptoFondID5" name="conceptoFondID5"  size="13" 
					         		tabindex="13" type="hidden"/> 
					     		 <input id="tipoFondeador5" name="tipoFondeador5"  size="13" 
					         		tabindex="13" type="hidden"/> 
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblInstitutFondeo">Instituci&oacute;n Fondeo:</label> 
					     	</td>
					     	<td> 
					     	  <select id="institutFondID" name="institutFondID"  tabindex="15">
									<option value="-1">Seleccionar</option>
								</select>
							</td>
					    
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuenta">SubCuenta:</label> 
					     	</td>
					     	<td >
					     		 <input id="subCuentaIns" name="subCuentaIns"  size="7" maxlength="6" class="valid" 
					         		tabindex="15" /> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaIF" name="grabaIF" class="submit" value="Grabar" tabindex="16"/>
								<input type="submit" id="modificaIF" name="modificaIF" class="submit" value="Modificar" tabindex="17" />
								<input type="submit" id="eliminaIF" name="eliminaIF" class="submit" value="Eliminar" tabindex="18"/>
								<input type="hidden" id="tipoTransaccionIF" name="tipoTransaccionIF" value="tipoTransaccionIF"/>
							</td>
						</tr>
					</table>
				</fieldset> 
	</form:form>
	<br></br>
	<form:form id="formaGenerica1" name="formaGenerica1" method="POST" commandName="GuiaContable"> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Persona</legend>                   
			<table border="0" cellpadding="0" cellspacing="0" width="100%">     
				<tr>
				   	<td> 
						<input id="conceptoFondID1" name="conceptoFondID1"  size="13" tabindex="19" type="hidden"/>
						
					     		 <input id="tipoFondeador1" name="tipoFondeador1"  size="13" 
					         		tabindex="13" type="hidden"/>  
					</td> 
				</tr> 
				<tr>
					<td class="label"> 
				    	<label for="lbltipPersonaF">F&iacute;sica:</label> 
					</td>
				    <td> 
				    	<input id="fisica" name="fisica"  size="7" maxlength ="6" class="valid" tabindex="20" />
				    </td> 										   
				</tr> 
				<tr>
					<td class="label"> 
				    	<label for="lbltipPersonaF">F&iacute;sica con Act.Emp.:</label> 
					</td>
				    <td> 
				    	<input id="fisicaActEmp" name="fisicaActEmp"  size="7" maxlength ="6" class="valid" tabindex="21" />
				    </td> 										   
				</tr> 
				<tr>
					<td class="label"> 
				    	<label for="lbltipPersonaF">Moral:</label> 
					</td>
				    <td> 
				    	<input id="moral" name="moral"  size="7" maxlength ="6" class="valid" tabindex="22" />
				    </td> 										   
				</tr> 
				 
			</table>
			<br></br>
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
				<tr>
					<td align="right">
						<input type="submit" id="grabaTPE" name="grabaTPE" class="submit" value="Grabar" tabindex="23"/>
						<input type="submit" id="modificaTPE" name="modificaTPE" class="submit" value="Modificar" tabindex="24" />
						<input type="submit" id="eliminaTPE" name="eliminaTPE" class="submit" value="Eliminar" tabindex="25"/>
						<input type="hidden" id="tipoTransaccionTPE" name="tipoTransaccionTPE" value="tipoTransaccionTPE"/>
					</td>
				</tr>
			</table>
		</fieldset> 
	</form:form>
	<form:form id="formaGenerica6" name="formaGenerica6" method="POST" commandName="GuiaContable"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Moneda</legend>                   
					<table border="0" cellpadding="0" cellspacing="0" width="100%">     
						<tr>
					   	<td> 
					     		 <input id="conceptoFondID6" name="conceptoFondID6"  size="13" 
					         		tabindex="13" type="hidden"/>
					         		
					     		 <input id="tipoFondeador6" name="tipoFondeador6"  size="13" 
					         		tabindex="13" type="hidden"/> 
					         		
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblMoneda">Moneda:</label> 
					     	</td>
					     	<td> 
					         <select id="monedaID" name="monedaID"  tabindex="23">
									<option value="-1">Seleccionar</option>
								</select>
					     	</td> 
					   </tr> 
						<tr>  
					      <td class="label"> 
					         <label for="lblsubCuentaTM">SubCuenta:</label> 
					     	</td>
					     	<td >
					     		 <input id="subCuentaTM" name="subCuentaTM"   size="7" maxlength="6" class="valid" 
					         		tabindex="24" /> 
					     	</td>  		
						</tr> 
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaTM" name="grabaTM" class="submit" value="Grabar" tabindex="25"/>
								<input type="submit" id="modificaTM" name="modificaTM" class="submit" value="Modificar" tabindex="26" />
								<input type="submit" id="eliminaTM" name="eliminaTM" class="submit" value="Eliminar" tabindex="27"/>
								<input type="hidden" id="tipoTransaccionTM" name="tipoTransaccionTM"/>
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