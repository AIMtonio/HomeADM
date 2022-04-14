<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<!-- importaciones de jss -->
	<script type="text/javascript"	src="dwr/interface/institucionNomServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/afiliacionBajaCtasClabeServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasTransferServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	<script type="text/javascript" src="js/nomina/afiliacionBajaCtasClabe.js"></script>
	
</head>
<body>
	<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="afiliacionBajaCtasClabe">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend class="ui-widget ui-widget-header ui-corner-all">Afiliaci&oacute;n/Baja Cuentas Clabes</legend>
			
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="afiliacionID">N&uacute;mero: </label>
						</td>
						<td>
							<input type="text" id="afiliacionID" name="afiliacionID"  size="12" tabindex="1"/>
						</td>
						<td class="separador">
						</td>
						<td class="label">
							<label>Es N&oacute;mina: </label>
						</td>
						<td class="label"> 
							<input type="radio" id="esNominaSi" name="esNomina" value="S" tabindex="2" />
							<label for="esNominaSi">Si</label>&nbsp;&nbsp;
							<input type="radio" id="esNominaNo" name="esNomina" value="N" tabindex="3"  />
							<label for="esNominaNo">No</label>
							<input type="hidden" id="esNomina" name="esNomina" value="">
						</td>
					</tr>
					<tr id="soloNomina" style="display: none;">
						<td class="label">
							<label>Empresa N&oacute;mina: </label>
						</td>
						<td nowrap="nowrap">
							<input type="text" id="instNominaID" name="instNominaID"  size="12" tabindex="4"/>
							<input type="text" id="nombreInstNomina" name="nombreInstNomina" disabled="true" readonly="true" size="50"/>
						</td>
						<td class="separador">
						</td>
						<td class="label">
							<label>No. Convenio: </label>
						</td>
						<td>
							<select id="convenio" name="convenio" tabindex="5">
						      		<option value="0">SELECCIONAR</option>
							</select>			    
						</td>
					</tr>
					<tr>
						<td class="label">
							<label>Tipo: </label>
						</td>
						<td>
							<select id="tipoAfiliacion" name="tipoAfiliacion" tabindex="6">
						      		<option value="">SELECCIONAR</option>
						      		<option value="A">ALTA</option>
						      		<option value="B">BAJA</option>
							</select>
						</td>
						<td class="separador">
						</td>
						<td class="label">
							<label>Cliente: </label>
						</td>
						<td nowrap="nowrap">
							<input type="text" id="clienteID" name="clienteID" path="clienteID" tabindex="7" size="12" autocomplete="off"/>
							<input type="text" id="nombreCliente" name="nombreCliente" disabled="true" readonly="true" size="50"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label>Estatus: </label>
						</td>
						<td>
							<input type="text" id="estatusFolio" name="estatusFolio" disabled="true" readonly="true" size="12"/>
							<input type="hidden" id="estatus" name="estatus" value=""/>
						</td>
					</tr>
				</table>
				<table>
					<tr >
						<td></td>
					</tr>
					<tr>

						<td>
							<input type="button" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="9"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						</td>
					</tr>
				</table>	
				<div id="gridAfiliacionBaja">
				
				</div>
				<div id="botonesGrid" style="display:none;">
					<table id="botones" align="right">
				<tr>
					<td>
						<input type="button" id="generarExcel" name="generarExcel" class="submit" value="Generar Excel" onClick="generaExcel()"/> 
					</td>
					<td>
						<input type="submit" id="generarLayout" name="generarLayout" class="submit" value="Generar Layout"/>	
					</td>
				</tr>
		</table>
				</div>
			</fieldset>
		</form:form>
	</div>

	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>