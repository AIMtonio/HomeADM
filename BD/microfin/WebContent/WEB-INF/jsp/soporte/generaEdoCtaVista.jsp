<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/generaEdoCtaServicio.js"></script>
	<script type="text/javascript" src="js/soporte/generaEdoCta.js"></script> 
</head>
<body>


<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Generaci&oacute;n de Estado de Cuenta &Uacute;nico</legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="estadoCuenta" >
			<table border="0" width="100%">	
				<tr id="opcionesTipoGeneracion">
					<td class="label">
						<label>Tipo Generaci&oacute;n:</label>
					</td>
					<td>
						<input type="radio" id="tipoGeneracionM" name="opcionesGeneracion" value="M" tabindex="1"  checked="checked" >
						<label> Mensual </label>
						<input type="radio" id="tipoGeneracionS" name="opcionesGeneracion" value="S" tabindex="2">
						<label> Semestral </label>
					</td>
				</tr>	
				<tr id="generacionMensual" style="display: none;">
					<td class="label">
						<label>Año:</label>
					</td>
					<td>
						<select id="anio" name="anio" tabindex="3">
						</select>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label>Mes:</label>
						
					</td>
					<td>
						<select id="mes" name="mes" tabindex="4">
						</select>
					</td>
				</tr>	
				<tr id="generacionSemestral" style="display: none;">
					<td class="label">
						<label>Año:</label>
					</td>
					<td>
						<select id="anioSemestre" name="anioSemestre" tabindex="5">
						</select>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label>Semestre:</label>
						
					</td>
					<td>
						<select id="numSemestre" name="numSemestre" tabindex="6">
							<option value="1" selected="selected">1</option>
							<option value="2">2</option>
						</select>
					</td>
				</tr>
				<tr id="rangoSemestral" style="display: none;">
					<td class="label">
						<label>Mes Inicio:</label>
					</td>
					<td>
						<input type="text" id="mesInicio" name="mesInicio" size="5" disabled="true" readOnly="true" />
					</td>
					<td class="separador"></td>
					<td class="label">
						<label>Mes Fin:</label>
					</td>
					<td>
						<input type="text" id="mesFin" name="mesFin" size="5" disabled="true" readOnly="true" />
					</td>
				</tr>
				<tr>
					<td class="label">
						<label>Sucursal Inicio:</label>
					</td>
					<td>
						<input type="text" id="sucursalInicio" name="sucursalInicio" path="sucursalInicio" size="5" tabindex="7" autocomplete="off" />
					</td>
					<td colspan="3">
						<input type="text" id="descsucursalInicio" name="descsucursalInicio" size="32" readonly="true"/>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label>Sucursal Fin:</label>
					</td>
					<td>
						<input type="text" id="sucursalFin" name="sucursalFin" path="sucursalFin" size="5" tabindex="8" autocomplete="off" />
					</td>
					<td colspan="3">
						<input type="text" id="descsucursalFin" name="descsucursalFin" size="32" readonly="true"/>
					</td>
				</tr>				
				<tr>
				<table id="descrip proceso Batch">
		         <tr>
						<td class="label">
						<DIV class="label"><label> 
				
						<br>
							Este proceso realiza la Generación Automatica de los Estados de Cuenta
						<br>
							de todos los Clientes, se realizar&aacute;n las siguientes acciones:
						<br>
							Generación de archivos en formato PDF por Cliente
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
										
										<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="9"  />
				            		</a>
				            		
								</td>
								<input type="hidden" id="sucursal" name="sucursal" path="sucursal" />
								<input type="hidden" id="fechaProceso" name="fechaProceso" path="fechaProceso" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1" />	
								<input type="hidden" id="clienteInicio" name="clienteInicio" path="clienteInicio" />
								<input type="hidden" id="clienteFin" name="clienteFin" path="clienteFin"/>
								<input type="hidden" id="tipoGeneracion" name="tipoGeneracion" path="tipoGeneracion"/>
								<input type="hidden" id="anioGeneracion" name="anioGeneracion" path="anioGeneracion"/>
								<input type="hidden" id="mesInicioGen" name="mesInicioGen" path="mesInicioGen"/>
								<input type="hidden" id="mesFinGen" name="mesFinGen" path="mesFinGen"/>
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
