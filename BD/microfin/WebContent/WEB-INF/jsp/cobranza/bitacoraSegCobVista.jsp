<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<html>
	<head>
      	<script type="text/javascript" src="dwr/interface/tipoRespuestaCobServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/tipoAccionCobServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/esquemaNotificaServicio.js"></script> 
 	  	<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>  
 	  	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
 	  	
	 	<script type="text/javascript" src="js/cobranza/bitacoraSegCob.js"></script> 
		
	</head>

	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="bitacoraSegCobBean" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Bit&aacute;cora de Seguimiento de Cobranza</legend>
					<table border="0" >
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="usuarioID">Usuario:</label>
				      		</td>
				 			<td nowrap="nowrap">
				 				<form:input type="text" id="usuarioID" name= "usuarioID" path="usuarioID" size="15" disabled="true" readOnly="true" />
				 				<input type="text" id="nombreUsuario" name="nombreUsuario" size="40" disabled="true" readOnly="true"/>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="sucursalID">Sucursal:</label>
				      		</td>
				 			<td nowrap="nowrap">
				 				<form:input type="text" id="sucursalID" name= "sucursalID" path="sucursalID" size="15" disabled="true" readOnly="true" />
				 				<input type="text" id="nombreSucursal" name="nombreSucursal" size="40" disabled="true" readOnly="true"/>
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="creditoID">Cr&eacute;dito:</label>
				      		</td>
				 			<td nowrap="nowrap">
				 				<form:input type="text" id="creditoID" name= "creditoID" path="creditoID" size="15" maxlength="25" autocomplete="off" tabindex="1"/>
				 			</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="clienteID"><s:message code="safilocale.cliente"/>:</label>
				      		</td>
				 			<td nowrap="nowrap">
				 				<form:input type="text" id="clienteID" name= "clienteID" path="clienteID" size="15"  disabled="true" readOnly="true" />
				 				<input type="text" id="nombreCliente" name="nombreCliente" size="40" disabled="true" readOnly="true"/>
							</td>							
						</tr>
						<tr>							
							<td class="label" nowrap="nowrap">
								<label for="accionID">Tipo Acci&oacute;n:</label>
							</td>
							<td nowrap="nowrap">
								<select id="accionID" name="accionID" tabindex="2" style="width:375px">
									<option value="">SELECCIONAR</option>
								</select>
							</td>	
							<td class="separador"></td>							
							<td class="label" nowrap="nowrap">
								<label for="respuestaID">Tipo Respuesta:</label>
							</td>
							<td nowrap="nowrap">
								<select id="respuestaID" name="respuestaID" tabindex="3"  style="width:375px">
									<option value="">SELECCIONAR</option>
								</select>
							</td>					
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="estatus">Estatus:</label>
				      		</td>
				 			<td nowrap="nowrap">
				 				<input type="text" id="estatus" name= "estatus" size="15" disabled="true" readOnly="true" />
				 			</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="comentario">Comentario:</label>
							</td>
							<td nowrap="nowrap">
								<form:textarea id="comentario" name="comentario" path="comentario" COLS="53" ROWS="4" tabindex="4"  onBlur=" ponerMayusculas(this)" maxlength = "300"/> 
							</td> 
						</tr>
						<tr>
							<td colspan="5">						
								<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetLisProm" >
								<legend >Promesas</legend>	
								<table>
									<tr>
										<td>									
											<input type="button" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="5" />
										</td>
									</tr>
									<tr>
										<td>
											<div id="divListaPromesas"></div>	
										</td>	
									</tr>
								</table>								
								</fieldset>
							</td>
						</tr>
						<tr>
							<td colspan="5">
								<table>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="etapaCobranza">Etapa Cobranza:</label>
										</td>
										<td nowrap="nowrap">
											<select id="etapaCobranza" name="etapaCobranza" tabindex="7" >
												<option value="">SELECCIONAR</option>
											</select>
										</td>
										<td class="separador"></td>
										<td class="label" nowrap="nowrap">
											<label for="fechaEntregaDoc">Fecha Entrega del Documento:</label>
							      		</td>
							 			<td nowrap="nowrap">
							 				<form:input type="text" id="fechaEntregaDoc" name= "fechaEntregaDoc" path="fechaEntregaDoc" size="15" maxlength="30" esCalendario="true" autocomplete="off" tabindex="8"/>
							 			</td>
									</tr>
								</table>
							</td>						
						</tr>
						<tr>
							<td  align="right" colspan="5">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="9" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
								<form:input type="hidden" id="fechaSis" name="fechaSis" path="fechaSis"/>	
							</td>
						</tr>
					</table>					
				</fieldset>		
			</form:form>
		</div>
		
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;overflow:">
		<div id="elementoLista"></div>
	</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>