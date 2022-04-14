<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoCuentaSucursalServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposAportacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/aportacionesServicio.js"></script>
		<script type="text/javascript" src="js/aportaciones/tipoAportacionesSucursal.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tipoCuentaSucursalBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Tipos de Aportaciones por Sucursal</legend>
				   <table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
						         <label for="lblaportacionID">Tipo Aportaci&oacute;n:</label>
						     </td>
						     <td>
						         <input type="text" id="tipoAportacionID" name="tipoAportacionID"  size="10" tabindex="1" />
						          <input type="hidden" id="instrumentoID" name="instrumentoID"/>

						     </td>
						     <td>
						         <input type="text" id="tipoCuentaIDDes" size="50" readonly="true" />
						     </td>
						     <td class="separador"></td>
						     <td class="separador"></td>
						     <td class="separador"></td>
						     <td class="separador"></td>
						     <td class="separador"></td>
						     <td class="separador"></td>
						     <td class="separador"></td>
						</tr>
					</table>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Filtros</legend>
						<table border="0" width="100%">
							<tr>
								 <td class="label">
							         <label for="tipoCuentaID">Sucursal:</label>
							     </td>
							     <td>
							         <input type="text" id="sucursalID" name="sucursalID" size="10" tabindex="3" />
							     </td>
							     <td>
							         <input type="text" id="sucursalIDDes" name="sucursalIDDes"  size="50" readonly="true" />
							         <font size="2"><label>0 = Todas</label></font>
							     </td>
							     <td class="separador"></td>
								 <td>
							         <input type="checkbox" id="excSucursal" name="excSucursal" tabindex="5" />
							         <label for="excSucursal">Excepci&oacute;n</label>
							     </td>
							     <td class="separador"></td>
							     <td  align="center">
									<input type="button" id="agregaSucursal" class="btnAgrega" value="" tabindex="6"/>
								</td>
							     <td class="separador"></td>
							     <td class="separador"></td>
							     <td class="separador"></td>
							     <td class="separador"></td>
							     <td class="separador"></td>
							</tr>
							<tr>
								<td class="label">
							    	<label for="tipoCuentaID">Estado:</label>
							    </td>
							    <td>
							    	<input type="text" id="estadoID" name="estadoID" size="10" tabindex="19" />
							    </td>
							    <td>
							    	<input type="text" id="estadoIDDes" name="estadoIDDes"  size="50" readonly="true"/>
							        <font size="2"><label>0 = Todos</label></font>
							    </td>
							    <td class="separador"></td>
								<td>
							    	<input type="checkbox" id="excEstado" name="excEstado" tabindex="21" />
							        <label for="excEstado">Excepci&oacute;n</label>
							    </td>
							    <td class="separador"></td>
							    <td  align="center">
									<input type="button" id="agregaEstado" class="btnAgrega" value="" tabindex="23"/>
								</td>
								<td class="separador"></td>
							    <td class="separador"></td>
							    <td class="separador"></td>
							    <td class="separador"></td>
							    <td class="separador"></td>
							</tr>
						</table>
						<br>
						<!-- Seccion de Grid Resultado -->
						<div id="divGridSucursales" style=" width: 1000px; height: 380px; overflow-y: scroll;  display: none; "></div>
					</fieldset>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabar" class="submit" value="Grabar" tabindex="400"/>
							    <input type="hidden" id="tipoTransaccion" value="" name="tipoTransaccion"/>
								<input type="hidden" id="tipoInstrumentoID"  name="tipoInstrumentoID" value="31"/>
							</td>
							<td><input type="button" id="imprimir" class="submit" name="imprimir" tabindex="401" value="Imprimir"  onclick="generaReporte()"/>
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
		<div id="mensaje" style="display: none;"></div>
	</body>
<html>