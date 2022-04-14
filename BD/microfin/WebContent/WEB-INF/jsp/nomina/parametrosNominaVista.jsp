<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/parametrosNominaServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>  
		 <script type="text/javascript" src="dwr/interface/TiposMovTesoServicioScript.js"></script> 
		 <script type="text/javascript" src="dwr/interface/rolesServicio.js"></script> 
		<script type="text/javascript" src="js/nomina/parametrosNomina.js"></script> 
	</head>
<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="paramsNominaBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Par&aacute;metros de N&oacute;mina</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<input type="hidden" id="clienteSocio" value='<s:message code="safilocale.cliente"/>' />
						<tr>
							<td class="label">
								<label>Empresa:</label>
							</td>
							<td>
								<form:input id="empresaID" name="empresaID" path="empresaID" type="text" size="6" tabindex="1"/>
							</td>	
						</tr>
						<tr>
							<td class="label">
								<label>Correo Electr&oacute;nico:</label>
							</td>
							<td>
								<form:input id="correoElectronico" name="correoElectronico" path="correoElectronico" type="text" size="30" maxlength="50" tabindex="2"/>
							</td>	
						</tr>
						<tr>
							<td class="label">
								<label>Cta. Contable en Tr&aacute;nsito:</label>
							</td>
							<td>
								<form:input id="ctaPagoTransito" name="ctaPagoTransito" path="ctaPagoTransito" type="text" maxlength="30" size="30" tabindex="3"/>
							</td>
						</tr>
					  	<tr>
							<td class="label" nowrap="nowrap">
								<label>Cta. Contable Tr&aacute;nsito Domiciliaci&oacute;n:</label>
							</td>
							<td>
								<form:input id="ctaTransDomicilia" name="ctaTransDomicilia" path="ctaTransDomicilia" type="text" maxlength="30" size="30" tabindex="4" autocomplete="off"/>
							</td>
						</tr>
						<tr>  
					      	<td class="label"> 
					         <label for="lblnomenclaturaCR">Nomenclatura Centro Costo:</label> 
					     	</td>
					     	<td >
					     		 <input id="nomenclaturaCR" name="nomenclaturaCR"  size="25" 
					         		tabindex="5" maxlength="3" /> 
					         <a href="javaScript:" onClick="ayudaCR();">
								  	<img src="images/help-icon.gif" >
								</a> 
					     	</td>  		
						</tr> 
						<tr>
							<td class="label"> 
					         <label for="lblClaves"><b>Claves de Nomenclatura  Centro Costo: 	
					         <i><br><a href="javascript:" onClick="insertAtCaret('nomenclaturaCR','&SO');return false;">  &SO = Sucursal Origen </a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclaturaCR','&SC');return false;"> &SC = Sucursal <s:message code="safilocale.cliente"/></a></b> </label> 
					     		</i>
					     	</td>
						</tr> 
						<tr>
						<td class="label">
							<label>Tipo de Movimiento:</label>
						</td>
						<td>
							<input type="text" id="tipoMovTesoID" name="tipoMovTesoID" maxlength="4" size="6" tabindex="6"/>
							<input id="descripcionMov" name="descripcionMov" size="50" disabled="true"  >
						</td>
						</tr>	
						<tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label>Tipo de Mov. Domiciliaci&oacute;n:</label>
							</td>
							<td>
								<input type="text" id="tipoMovDomiciliaID" name="tipoMovDomiciliaID" maxlength="4" size="6" tabindex="7" autocomplete="off"/>
								<input id="descMovDomiciliacion" name="descMovDomiciliacion" size="50" readonly="true"  >
							</td>
						</tr>
						<td class="label">
							<label>Perfil Autorización Calendario:</label>
						</td>
						<td>
							<input type="text" id="perfilAutCalend" name="perfilAutCalend" maxlength="4" size="6" tabindex="8"/>
							<input id="descripcionPerfil" name="descripcionPerfil" size="50" disabled="true"  >
						</td>
						</tr>
					</table>
					<table border="0" cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td align="right">
							<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar"  tabindex="9"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/> 
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
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"/>
</div>	
</html>