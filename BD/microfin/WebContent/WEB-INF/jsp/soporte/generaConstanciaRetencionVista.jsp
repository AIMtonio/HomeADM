<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/generaConstanciaRetencionServicio.js"></script> 
	<script type="text/javascript" src="js/soporte/generaConstanciaRetencion.js"></script> 
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
						<label for="sucursalInicio">Sucursal Inicio:</label>
					</td>
					<td nowrap = "nowrap">
						<input type="text" id="sucursalInicio" name="sucursalInicio" size="13" tabindex="3" autocomplete="off" />
						<input type="text" id="descsucursalInicio" name="descsucursalInicio" size="40" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap"> 
						<label>Sucursal Fin:</label>
					</td>
						<td nowrap = "nowrap">
						<input type="text" id="sucursalFin" name="sucursalFin" size="13" tabindex="4" autocomplete="off" />
						<input type="text" id="descsucursalFin" name="descsucursalFin" size="40" readonly="true"/>
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
							Este proceso realiza la Generaci&oacute;n Automatica de las Constancias de 
						<br>
							Retenci&oacute;n de todos los <s:message code="safilocale.cliente"/>s, se realizar&aacute;n las siguientes acciones:
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
						<table align="right" border='0'>
							<tr align="right">
								<td width="350px">
									&nbsp;
								</td>
								<td align="right">
									<a target="_blank" >
										<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="5"  />
				            		</a>
								<input type="hidden" id="sucursal" name="sucursal" />
								<input type="hidden" id="anioProceso" name="anioProceso"  />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1" />	
								<input type="hidden" id="clienteInicio" name="clienteInicio"  />
								<input type="hidden" id=clienteFin name="clienteFin" />
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