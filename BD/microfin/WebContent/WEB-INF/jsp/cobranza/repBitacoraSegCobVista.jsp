<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<html>
	<head>
      	<script type="text/javascript" src="dwr/interface/tipoRespuestaCobServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/tipoAccionCobServicio.js"></script> 
 	  	<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>  
 	  	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
        <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>  
      	
		<script type="text/javascript" src="js/cobranza/repBitacoraSegCob.js"></script>
	</head>

	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repBitacoraSegCobBean" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Bit&aacute;cora de Seguimiento de Cobranza</legend>
				<table>
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend><label>Par&aacute;metros</label></legend>
								<table border="0">
									<tr>	
										<td class="label" nowrap="nowrap">
											<label for="fechaIniReg">Fecha de Inicio: </label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="fechaIniReg" name="fechaIniReg" size="15" maxlength="10" tabindex="1"  esCalendario="true" />	
										</td>
										<td class="separador"></td>
										<td class="label" nowrap="nowrap">
											<label for="creditoID">Cr&eacute;dito:</label>
						      			</td>
						 				<td>
					       		 			<input type="text" id="creditoID" name="creditoID" size="15" tabindex="2" maxlength = "19" autocomplete="off"/>
										</td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="fechaFinReg">Fecha de Fin: </label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="fechaFinReg" name="fechaFinReg" size="15" maxlength="10" tabindex="3"  esCalendario="true" />	
										</td>
										<td class="separador"></td>							
										<td class="label" nowrap="nowrap">
											<label for="usuarioReg">Usuario Reg:</label>
						      			</td>
						 				<td nowrap="nowrap">
					       		 			<input type="text" id="usuarioReg" name="usuarioReg" size="8" tabindex="4" maxlength = "16" autocomplete="off"/>
											<input type="text" id="nombreUsu" name="nombreUsu" size="30" tabindex="6" disabled="true" readOnly="true"/>										
										</td>
									</tr>						
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="accionID">Tipo Acci&oacute;n:</label>
										</td>
										<td>
											<select id="accionID" name="accionID" tabindex="5"  style="width:270px">
											<option value="">TODAS</option>
											</select>
										</td>
										<td class="separador"></td>		
										<td class="label" nowrap="nowrap">
											<label for="fechaIniProm">Fecha Inicio Prom: </label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="fechaIniProm" name="fechaIniProm" size="15" maxlength="10" tabindex="6"  esCalendario="true" />	
										</td>
									</tr>					
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="respuestaID">Tipo Respuesta:</label>
										</td>
										<td>
											<select id="respuestaID" name="respuestaID" tabindex="7" style="width:270px">
											<option value="">TODAS</option>
											</select>
										</td>
										<td class="separador"></td>		
										<td class="label" nowrap="nowrap">
											<label for="fechaFinProm">Fecha Final Prom: </label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="fechaFinProm" name="fechaFinProm" size="15" maxlength="10" tabindex="8"  esCalendario="true" />	
										</td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="clienteID"><s:message code="safilocale.cliente"/>:</label>
						      			</td>
						 				<td nowrap="nowrap">
					       		 			<input type="text" id="clienteID" name="clienteID" size="10" tabindex="9" maxlength = "20" autocomplete="off"/>
					       		 			<input type="text" id="nombreCli" name="nombreCli" size="30" tabindex="6" disabled="true" readOnly="true"/>	
										</td>
										<td class="separador"></td>	
										<td class="label" nowrap="nowrap">
											<label for="limiteReglones">L&iacute;mite de Renglones:</label>
						      			</td>
						 				<td>
					       		 			<input type="text" id="limiteReglones" name="limiteReglones" size="15" tabindex="10" maxlength = "9" autocomplete="off" onkeypress="validaSoloNumero(event,this)"/>
										</td>								
									</tr>											
								</table>
							</fieldset>
						</td>
						<td VALIGN=TOP>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="pdf" name="generaRpt" value="pdf" tabindex="11"/>
									<label> PDF </label> 
								<br> 
									<input type="radio" id="excel" name="generaRpt" value="excel" tabindex="12"> 
									<label>Excel </label>
							</fieldset>
						</td>
					</tr>
					<tr>						
						<td align="right" colspan="2">
							<a id="ligaGenerar" target="_blank"> 
								<input type="button" id="generar" name="generar" class="submit"	tabIndex="13" value="Generar" />
							</a> 
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