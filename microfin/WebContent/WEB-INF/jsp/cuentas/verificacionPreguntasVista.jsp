<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/cuentasBCAMovilServicio.js"></script> 
 	   	<script type="text/javascript" src="dwr/interface/verificacionPreguntasServicio.js"></script>  
 	   	<script type="text/javascript" src="js/soporte/mascara.js"></script>
      	<script type="text/javascript" src="js/cuentas/verificacionPreguntas.js"></script>  	
	</head>
      
<body>


<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="verificacionPreguntasBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Verificaci&oacute;n de Preguntas </legend>
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
									<input type="text" id="clienteID" name="clienteID" size="12" tabindex="1" autocomplete="off"/>
									<input type="text" id="nombreCompleto" name="nombreCompleto" size="50"  readonly="true" disabled="disabled"/>
								</td>
							</tr>
							<tr>  
							  	<td class="label">
							  		<label for="lblTelefono">Tel&eacute;fono: </label>
							  	</td>
								<td>
									<input type="text" id="numeroTelefono" name="numeroTelefono" size="16" maxlength="15" tabindex="2" autocomplete="off"/>
									<input type="hidden" id="telefonoCelular" name="telefonoCelular" size="16" maxlength="15" />
								</td>
							</tr>	
							<tr>  
							  	<td class="label">
							  		<label for="lblFecha">Fecha de Nacimiento: </label>
							  	</td>
								<td>
									<input type="text" id="fechaNacimiento" name="fechaNacimiento" size="16" tabindex="3" maxlength="10" esCalendario="true" autocomplete="off"/>
								</td>
							</tr>
							<tr>  
							  	<td class="label">
							  		<label for="lblTipoSoporte">Tipo de Soporte: </label>
							  	</td>
								<td>
									<select  id="tipoSoporteID" name="tipoSoporteID"  tabindex="4" >
										<option value="">SELECCIONAR</option>
									</select>
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
				

		<table  border="0"  width="100%">
			<tr>
				<td>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend>Comentarios</legend>
						<table>
							<tr> 
							    <td>
									<form:textarea id="comentarios" name="comentarios" path="comentarios" COLS="60" ROWS="4" tabindex="60"  onBlur=" ponerMayusculas(this)" maxlength = "200"/> 
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
					<input type="submit" id="enviar" name="enviar" class="submit" value="Enviar" tabindex="63"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
					<input type="hidden" id="usuarioID" name="usuarioID"/>
					<input type="hidden" id="resAprobadas" name="resAprobadas"/>
				</td>
			</tr> 
		</table> 
		
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
