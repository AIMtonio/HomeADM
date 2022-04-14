<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/cuentasBCAMovilServicio.js"></script> 
 	   	<script type="text/javascript" src="dwr/interface/verificacionPreguntasServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/parametrosPDMServicio.js"></script> 
 	   	<script type="text/javascript" src="js/soporte/mascara.js"></script>
      	<script type="text/javascript" src="js/cuentas/seguimientoFolioJPMovil.js"></script>  	
	</head>
      
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="verificacionPreguntasBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Seguimiento de Folios <label id="nombreServicio"></label> </legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label for="seguimientoID">Folio:</label>
							</td>
							<td>
								<input type="text" id="seguimientoID" name="seguimientoID" size="12" tabindex="1"  autocomplete="off"/>
							</td>
							<td class="separador"></td>
							<td class="label" align="right">
								<label for="estatus">Estatus:</label>
							</td>
							<td>
								<input type="text" id="estatus" name="estatus" size="15" tabindex="2" readonly="readonly" disabled="disabled"/>
							</td>
						</tr>
					</table>
					
					<table border="0"  width="100%">
						<tr>
							<td>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
								<legend>Datos Generales</legend>
									<table>
										<tr>  
										  	<td class="label">
										  		<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label>
										  	</td>
											<td>
												<input type="hidden" id="clienteID" name="clienteID"/>
												<input type="text" id="cliente" name="cliente" size="12" tabindex="1" readonly="true" disabled="disabled"/>
												<input type="text" id="nombreCompleto" name="nombreCompleto" size="50"  readonly="true" disabled="disabled"/>
											</td>
										</tr>
										<tr>  
										  	<td class="label">
										  		<label for="lblTelefono">Tel&eacute;fono: </label>
										  	</td>
											<td>
												<input type="text" id="numeroTelefono" name="numeroTelefono" size="16" maxlength="15" tabindex="2" readonly="true" disabled="disabled"/>
												<input type="hidden" id="telefonoCelular" name="telefonoCelular"/>
											</td>
										</tr>	
										<tr>  
										  	<td class="label">
										  		<label for="lblFecha">Fecha de Nacimiento: </label>
										  	</td>
											<td>
												<input type="text" id="fechaNac" name="fechaNac" size="16" tabindex="3" maxlength="10" readonly="true" disabled="disabled""/>
												<input type="hidden" id="fechaNacimiento" name="fechaNacimiento" />
												
											</td>
										</tr>
										<tr>  
										  	<td class="label">
										  	</td>
											<td>
												<input type="hidden" id="tipoSoporteID" name="tipoSoporteID" />
											</td>
										</tr>	
									 </table>
								  </fieldset>
						  	 </td>
						  </tr>
					 </table>
						 
					 <table border="0"  width="100%">
						<tr>
							<td align="right">
								<input type="button" id="consultar" name="consultar" class="submit" value="Consultar" tabindex="5"/>
							</td>
						</tr>
					</table> 
						
					<table border="0" width="100%">			
						<tr>
							<td>
								<input type="hidden" id="datosGridPreguntas" name="datosGridPreguntas" size="100" />	
								<div id="gridPreguntasSeguridad" name="gridPreguntasSeguridad" style="display: none;">
								</div>	
							</td>	
						</tr>
					</table>
				
					<table border="0"  width="100%">
						<tr>
							<td align="right">
								<input type="submit" id="validar" name="validar" class="submit" value="Validar" tabindex="50"/>
							</td>
						</tr> 
					</table> 
						
					<div id="seccionSeguimiento">
						<div id="seccionRespuestas">
							<table  border="0"  width="100%">
								<tr>
									<td>
										<fieldset class="ui-widget ui-widget-content ui-corner-all">                
										<legend>Respuesta</legend>
											<table>
												<tr> 
												    <td class="label">
														<label for="comentarioUsuario">Usuario</label> 
													</td>
													<td class="separador"></td>
													<td class="label">
														<label for="comentarioCliente">Cliente</label> 
													</td>    
												</tr>
												<tr> 
												    <td>
														<textarea id="comentarioUsuario" name="comentarioUsuario" COLS="35" ROWS="4" tabindex="60"  onBlur=" ponerMayusculas(this)" onkeyup="contadorTextArea(this.id,'contadorUsuario',150);" maxlength = "150"/> 
													</td>
													<td class="separador"></td>
													<td>
														<textarea id="comentarioCliente" name="comentarioCliente" COLS="35" ROWS="4" tabindex="60"  onBlur=" ponerMayusculas(this)" onkeyup="contadorTextArea(this.id,'contadorCliente',150);" maxlength = "150"/>
														
													</td>    
												</tr>
												<tr>
													<td class="label">
														<label>Caracteres restantes: </label> <label id="contadorUsuario">0/150</label>
													</td>
													<td class="separador"></td>
													<td class="label">
														<label>Caracteres restantes: </label> <label id="contadorCliente">0/150</label>
													</td>  
												</tr>
											 </table>
										  </fieldset>
								  	 </td>
								  </tr>
						  	</table> 
							  
							<table border="0"  width="100%">
								<tr>
									<td align="right">
										<input type="submit" id="enviarComentario" name="enviarComentario" class="submit" value="Enviar Comentario" tabindex="63"/>
									</td>
								</tr> 
							</table>
						</div>
						
						<div id="seccionCometarios">
							<table  border="0"  width="100%">
								<tr>
									<td>
										<fieldset class="ui-widget ui-widget-content ui-corner-all">                
											<legend>Comentarios</legend>
											<div id="historialComentarios">
											</div>
									  	</fieldset>
								  	 </td>
								</tr>
							</table>
							
							<table border="0"  width="100%">
								<tr>
									<td align="right">
										<input type="submit" id="cancelarFolio" name="cancelarFolio" class="submit" value="Cancelar Folio" tabindex="63"/>
										<input type="submit" id="terminarFolio" name="terminarFolio" class="submit" value="Terminar Folio" tabindex="63"/>
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
										<input type="hidden" id="usuarioID" name="usuarioID"/>
										<input type="hidden" id="resAprobadas" name="resAprobadas"/>
									</td>
								</tr> 
							</table> 
						</div>
					</div>
				</fieldset>
				
			</form:form>
			
		</div>
		
		<div id="cargando" style="display: none;"></div>
		
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/></div>
		</div>
	</body>
	
	<div id="mensaje" style="display: none;"></div>
	
</html>
