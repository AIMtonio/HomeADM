<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
 	   	<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/conceptosInversionAgroServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/uniConceptosInvAgroServicio.js"></script>
 	   	
 	   	<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>  
		<script type="text/javascript" src="js/fira/conceptosInversionAgro.js"></script>
	</head>
	
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="conceptosInversionAgroBean" target="_blank">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Conceptos de Inversi&oacute;n</legend>
						<table width="100%">
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="solicitudCreditoID">Solicitud de Cr&eacute;dito: </label>
								</td>
								<td>
									<form:input type="text" id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="12" tabindex="1" autocomplete="false" />
								</td>
								<td class="separador"></td>

								<td>
									<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
	     						</td> 
	     						<td> 
	         						<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="2" readOnly="true" disabled = "true"/>
	         						<input id="nombreCliente" name="nombreCliente" size="50" type="text" tabindex="3" readOnly="true" disabled ="true"/>
	     						</td> 
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="montoSolicitud">Monto Solicitud de Cr&eacute;dito: </label>
								</td>
								<td>
									<form:input type="text" id="montoSolicitud" name="montoSolicitud" path="monto" size="12" tabindex="4" autocomplete="false"  esMoneda="true" style="text-align:right;"  readOnly="true" disabled = "true" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="fechaRegistro">Fecha de Registro: </label>
								</td>
								<td>
									<form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" readOnly="true" disabled="true" />
								</td>
								<td>
									<input type="hidden" id="datosGrid" name="datosGrid" size="100" />
									<input type="hidden" id="datosGridSol" name="datosGridSol" size="100" />
									<input type="hidden" id="datosGridOF" name="datosGridOF" size="100" />
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
									<input type="hidden" id="totalConceptos" name="totalConceptos"/>
								</td>
							</tr>
						</table>	
						<br>
						 <div id="divRecursosPrestamo">
						 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
						 		<legend class="ui-widget ui-widget-header ui-corner-all">Recursos del Pr&eacute;stamo</legend>
						 		<c:set var="listaResultado"  value="${listaResultado[0]}"/>	
						 		<table id="tablaPrestamo"  width="100%">
							 		
							 	</table>
								<div id="gridRecPrestamo"></div>
								<table align="right">
									<tr>
										<td align="right">
											<input type="submit" id="grabarPres" name="grabarPres" class="submit" value="Grabar"  />						
										</td>
										
									</tr>
								</table>
								<input type="hidden" id="numeroDetalle" name="numeroDetalle" value="-1" />		
							</fieldset>
				 		</div>
				 		<br>
						 <div id="divRecursosSolicitante">
						 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
						 		<legend class="ui-widget ui-widget-header ui-corner-all">Recursos del Solicitante</legend>
						 		<c:set var="listaResultado"  value="${listaResultado[0]}"/>	
						 		<table id="tablaSolicita" width="100%">
							 		
							 	</table>
							 	<div id="gridRecSolicitante"></div>
							 	<table align="right">
									<tr>
										<td align="right">
											<input type="submit" id="grabarSol" name="grabarSol" class="submit" value="Grabar"  />
										</td>
										
									</tr>
								</table>
								<input type="hidden" id="numeroDetalle" name="numeroDetalle" value="-1" />	
							</fieldset>
				 		</div>
				 		<br>
						 <div id="divRecursosOtrasFuentes">
						 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
						 		<legend class="ui-widget ui-widget-header ui-corner-all">Recursos de Otras Fuentes</legend>
						 		<c:set var="listaResultado"  value="${listaResultado[0]}"/>	
						 		<table id="tablaOF" width="100%">
							 		
							 	</table>
							 	<div id="gridRecOtrasFuentes"></div>
							 	<table align="right">
									<tr>
										<td align="right">
											<input type="submit" id="grabarOF" name="grabarOF" class="submit" value="Grabar"  />
										</td>
										
									</tr>
								</table>
								<input type="hidden" id="numeroDetalle" name="numeroDetalle" value="-1" />	
							</fieldset>
				 		</div>
				 		<table align="right">
						<tr>
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