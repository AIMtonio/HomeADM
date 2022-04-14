<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
 	<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
 	<script type="text/javascript" src="dwr/interface/generaConsRetencionCteServicio.js"></script>  
 	<script type="text/javascript" src="js/soporte/generaConsRetencionCte.js"></script> 
 	
</head>
<body>
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Generaci&oacute;n de Constancia de Retenci&oacute;n </legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="generaConstanciaRetencionBean" >
			<table>		
				<tr>
					<td class="label" nowrap="nowrap"> 
						<label for="anio">A&ntilde;o:</label>
					</td>
					<td>
						<select id="anio" name="anio" disabled = "true" ></select>
					</td>
				</tr>
				<tr>
		 			<td class="label" nowrap="nowrap"> 
						<label for="clienteID">N&uacute;mero de <s:message code="safilocale.cliente"/>:</label>
						<input type="hidden" id="clienteSocio" value="<s:message code="safilocale.cliente"/>" />
					</td>
					<td>
						<input type="text" id="clienteID" name="clienteID" size="13" tabindex="1" autocomplete="off" />
						<input type="text" id="nombreCompleto" name="nombreCompleto" size="40" readonly="true" disabled = "true"/>
					</td>	
				</tr>
				<tr>
					<td class="label" nowrap="nowrap"> 
						<label for="sucursalInicio">Sucursal:</label>
					</td>
					<td nowrap = "nowrap">
						<input type="text" id="sucursalInicio" name="sucursalInicio" size="13" readonly="true" disabled = "true"/>
						<input type="text" id="descsucursalInicio" name="descsucursalInicio" size="40"  readonly="true" disabled = "true"/>
					</td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap"> 
						<label for="direccion">Direcci&oacute;n:</label>
					</td>
					<td colspan="3">
						<textarea type="text" id="direccion" name="direccion" cols="51" rows="3"  readonly="true" disabled = "true"/>
					</td>
				</tr>
				<tr style="display: none;">
					<td>
						<input type="text" id="OrigenDatos" name="OrigenDatos" size="5" tabindex="4"/>
					</td>
				</tr>
				<tr>
				<table>
		         <tr>
						<td class="label">
						<DIV class="label"><label> 
				
						<br>
							Este proceso realiza la Generaci&oacute;n Autom&aacute;tica de las Constancias de
						<br>
							Retenci&oacute;n del <s:message code="safilocale.cliente"/> especificado, se realizar&aacute;n las siguientes acciones:
						<br>
							Generaci&oacute;n de archivos en formato PDF por <s:message code="safilocale.cliente"/>.
						<br>						
						</label>
						</DIV>
						</td>
					</tr>
				</table>
				</tr>
				<tr>
					<td colspan="5">
						<table align="right" >
							<tr align="right">
								<td width="350px">
									&nbsp;
								</td>
								<td align="right">
									<a target="_blank" >
										<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="2"  />
				            		</a>
									<input type="hidden" id="sucursal" name="sucursal"  />
									<input type="hidden" id="anioProceso" name="anioProceso" />
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1" />	
									<input type="hidden" id="clienteInicio" name="clienteInicio"  />
									<input type="hidden" id=clienteFin name="clienteFin"/>
								</td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</form:form>
	</fieldset>	
</div>
<div id="cargando" style="display: none;">	
</div>				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>