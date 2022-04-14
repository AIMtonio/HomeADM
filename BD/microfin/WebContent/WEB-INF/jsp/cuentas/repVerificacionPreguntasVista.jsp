<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
     <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
     <script type="text/javascript" src="dwr/interface/repVerificacionPreguntasServicio.js"></script>  
     <script type="text/javascript" src="js/cuentas/repVerificacionPreguntas.js"></script>  
				
	</head>    
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repVerificacionPreguntasBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Verificaci&oacute;n de Preguntas</legend>
					<table border="0" width="100%">
						<tr> 
							<td> 
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
									<legend><label>Par&aacute;metros</label></legend>         
							          	<table  border="0"  width="100%"> 	
											<tr>
												<td class="label">
													<label for="lblFechaInicio">Fecha Inicio: </label>
												</td>
												<td>
													<input id="fechaInicio" name="fechaInicio" size="12" tabindex="1" type="text"  esCalendario="true" autocomplete="off"/>	
												</td>					
											</tr>
											<tr>			
												<td>
													<label for="lblFechaFin">Fecha Fin: </label> 
												</td>
												<td>
													<input id="fechaFin" name="fechaFin" size="12" tabindex="2" type="text" esCalendario="true" autocomplete="off"/>				
												</td>	
											</tr>	
											<tr>
												<td>
													<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
												</td>
												<td>
													<input type="text" id="clienteID" name="clienteID" size="12" tabindex="3" value="0"  autocomplete="off">
													<input type="text" id="nombreCliente" name="nombreCliente" readonly="true" disabled="disabled" size="50" value="TODOS">														 
												</td>
											</tr>
							  		</table> 
			  				</fieldset>
						</td>        
			        </tr>  
				</table>
				<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
				<input type="hidden" id="tipoLista" name="tipoLista" />
				<table border="0" width="100%">
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
										<input type="button" class="submit" id="generar" name="generar" tabindex="10"  value="Generar">	
									</td>
								</tr>
							</table>		
						</td>
					</tr>					
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;">	
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"/>
	</div>
</body>
	<div id="mensaje" style="display: none;"/>
</html>