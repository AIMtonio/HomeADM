<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
	 
		<script type="text/javascript" src="dwr/interface/aclaracionServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>  
        <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script> 
        <script type="text/javascript" src="js/tarjetas/resultadoAclaraTarDeb.js"></script>     
	</head> 
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="registro">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Resultado de Aclaración</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">			
								<label>Tipo Tarjeta: </label>
								<input type="radio" id="tipoTarjetaD" value="D" tabIndex="1"/><label>Debito</label>
								<input type="radio" id="tipoTarjetaC" value="C" tabIndex="2" /><label>Credito</label>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="lnumerorep">No. de Reporte: </label>
							</td>
							<td>
								<input type="text" id="reporteID" name="reporteID" path="reporteID" size="10" tabindex="1" />
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
							    <label for="fechaOperacion">Fecha:&nbsp;&nbsp;</label>
							    <form:input id="fecha" name="fecha" path="fecha" readOnly="true"  size="20"  /> 
	     		  			</td>		
	     		  			<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="lnumerotar">No. de Tarjeta:</label>
							</td>
							<td> 
								<input type="text" id="tarjetaDebID" name="tarjetaDebID" path="tarjetaDebID" size="20" readOnly="true" />
							</td>		
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lestatus">Estatus: </label>
								<input type="text" id="estatus" name="estatus" size="20" readOnly="true" disabled = "true"/>
							</td>	
						</tr>
					</table>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">	
						<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Datos Tarjeta</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lnombre">Tarjetahabiente:</label>
								</td>
								<td>
				    				<input type="text" id="clienteID" name="clienteID" size="20" readOnly="true" disabled = "true" />
									<input type="text" id="nombre" name="nombre" size="70" onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
								</td>		
							</tr>
							<tr id="cuentaAho" style="display: none;">
								<td class="label" nowrap="nowrap">
									<label for="lnumCuenta">Cuenta Asociada:</label>
								</td>
								<td>
				    				<input type="text" id="numCuenta" name="numCuenta" size="20" readOnly="true" disabled="true"/>
									<input type="text" id="descCuenta" name="descCuenta" size="70" onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
								</td>		
							</tr>
							<tr id="producto" style="display: none;">
								<td class="label" nowrap="nowrap">
									<label for="lnumCuenta">Producto Crédito:</label>
								</td>
								<td>
				    				<input type="text" id="productoID" name="productoID" size="20" readOnly="true" disabled="true" />
									<input type="text" id="nombreProducto" name="nombreProducto" size="70" onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
								</td>
							</tr>
							<tr id="cteCorpTr">
								<td class="label" nowrap="nowrap">
									<label for="lcorporativo">Corporativo (Contrato):</label>
								</td>
								<td>
				    				<input type="text" id="corporativoID" name="corporativoID" size="20" readOnly="true" disabled = "true" />
									<input type="text" id="nombreCorp" name="nombreCorp" size="70" onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
								</td>						
							</tr>			
						</table>
					</fieldset>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">		
						<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Datos del Reporte</legend>	
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lboperacion">Operación:</label>
									</td>
									<td>
										<input type="text" id="descMovimiento" name="descMovimiento" size="50" tabindex="3" readOnly="true" disabled = "true" />
									</td>		
								</tr>
								<tr>
									<td>
										<label for="ldetalle">Detalle de Reporte: </label>
									</td>
									<td>
										<textarea id="detalleReporte" name="detalleReporte" path="detalleReporte" rows="4" cols="68" class="contador"  readOnly="true" ></textarea>
									</td>
								</tr>
								<tr>
									<td>
										<label for="ldetalle">Resolución: </label>
									</td>
									<td>
										<textarea id="detalleResolucion" name="detalleResolucion" path="detalleResolucion" rows="7" cols="68" class="contador" tabindex="2" maxlength="2000" onblur="ponerMayusculas(this);"></textarea>
										<div align="right">
											<label for="longitud_textarea" id="longitud_textarea" name="longitud_textarea"></label>
										</div>
									</td>
								</tr>
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="estatus">Estatus:</label>
									</td>
									<td>
										<form:select id="estatusResult" name="estatusResult" path="estatusResult" tabindex="3">
											<form:option value="">SELECCIONA</form:option> 
											    <option value="S">SEGUIMIENTO</option>
											  	<option value="R">RESUELTO</option>
										</form:select>
									</td>		
								</tr>
								<tr>
										<td class="label">
										<label for="lcorporativo">Usuario:</label>
									</td>
									<td>
					    				<input type="text" id="usuarioID" name="usuarioID" size="13" tabindex="4" />
										<input type="text" id="nombreCompleto" name="nombreCompleto" size="70" onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
									</td>		
								</tr>
							</table>
						</fieldset>
				<table width="100%">
					<tr>
						<td align="right">
					  		<input type="submit" id="agrega" name="agrega" class="submit" value="Grabar"  tabindex="5" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="button" id="reimprimir" name="reimprimir" class="submit" value="Resolución" tabindex="6" />
						</td>
					</tr>
				</table>
			</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>