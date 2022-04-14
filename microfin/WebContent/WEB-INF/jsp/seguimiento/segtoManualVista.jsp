<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/catSegtoCategoriasServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/segtoManualServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
        <script type="text/javascript" src="js/soporte/mascara.js" charset="utf-8"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/seguimientoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
		<script type="text/javascript" src="js/seguimiento/segtoManual.js"></script>  
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="segtoManualBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Alta Manual de Evento de Seguimiento</legend>			
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="label">Registro</legend>	
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<table border="0" cellpadding="0" cellspacing="0" >
						 	<tr>
	 							<td class="label" nowrap="nowrap">
									<label for="lblsegtoProgra">Secuencia Seguimiento: </label>
								</td>
								<td>
									<input type="text" id="segtoPrograID" name="segtoPrograID" tabindex="1" size="12" />
								</td>
							</tr>
							
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblcreditoID">Cr&eacute;dito: </label>
								</td>
								<td>
								    <input type="text" id="creditoID" name="creditoID" tabindex="2" size="12" />
									<input type="text" id="nombreCompleto" name="nombreCompleto" onBlur="ponerMayusculas(this)" size="50" disabled="true" />
								</td>
							</tr>
							
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblgrupoID">Grupo: </label>
								</td>
								<td>
									<input type="text" id="grupoID" name="grupoID" tabindex="3" size="12" />
									<input type="text" id="nombreGrupo" name="nombreGrupo" size="50" onBlur="ponerMayusculas(this)" disabled="true" />
								</td>
							</tr>
						</table>	
						</fieldset>
                    <fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="label">Generales del Cr&eacute;dito</legend>	
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblsolicituID">Solicitud:</label>
								</td>
								<td>
									<input type="text" id="solicitudCreditoID" name="solicitudCreditoID"  size="12" disabled="true"/> 
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="lblprodCredID">Producto:</label>
								</td>
								<td>
									<input type="text" id="producCredID" name="producCredID"  size="12" disabled="true"/>
									<input type="text" id="nombreProdCred" name="nombreProdCred" size="40" disabled="true"/>
								</td>
							</tr>
							
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblmontoSol">Monto Solicitado:</label>
								</td>
								<td>
									<input id="montoSolicitado" name="montoSolicitado" size="12" esMoneda="true" disabled="true"/> 
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="lblmontoAut">Monto Autorizado:</label>
								</td>
								<td>
									<input id="montoAutorizado" name="montoAutorizado" size="12" esMoneda="true" disabled="true"/> 
								</td>
							</tr>
							
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblfechaSol">Fecha Solicitud:</label>
								</td>
								<td>
									<input type="text" id="fechaSol" name="fechaSol" size="12" disabled="true"/> 
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="lblmontoAut">Fecha Desembolso:</label>
								</td>
								<td>
									<input type="text" id="fechaDesembolso" name="fechaDesembolso" size="12" disabled="true"/> 
								</td>
							</tr>	
							
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblestatus">Estatus:</label>
								</td>
								<td>
									<select id="estatusCre" name="estatusCre" disabled="true">
											<option value="I">INACTIVO</option>
											<option value="A">AUTORIZADO</option>
											<option value="V">VIGENTE</option>
											<option value="P">PAGADO</option>
											<option value="C">CANCELADO</option>
											<option value="B">VENCIDO</option>
											<option value="K">CASTIGADO</option>
										</select>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="lblsaldoVig">Saldo Vigente:</label>
								</td>
								<td>
									<input type="text" id="saldoVigente" name="saldoVigente" size="12" esMoneda="true" disabled="true"/> 
								</td>
							</tr>
							
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbldiasatra">D&iacute;as Atraso:</label>
								</td>
								<td>
									<input type="text" id="diasAtraso" name="diasAtraso" size="12" disabled="true" />
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="lblsaldoAtras">Saldo Atrasado:</label>
								</td>
								<td>
									<input type="text" id="saldoAtrasado" name="saldoAtrasado" size="12" esMoneda="true" disabled="true" /> 
								</td>
							</tr>
							
							<tr>			
							    <td class="label" nowrap="nowrap"></td>
								<td class="label" nowrap="nowrap"></td>
								<td class="label" nowrap="nowrap"></td>
								<td class="label" nowrap="nowrap">
									<label for="lblsaldoVencido">Saldo Vencido:</label>
								</td>
								<td>
									<input type="text" id="saldoVencido" name="saldoVencido" size="12" esMoneda="true" disabled="true"/> 
								</td>
							</tr>
							</table>
					</fieldset>							
					
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="label">Programaci&oacute;n</legend>	
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblfechaProg">Fecha Programada:</label>
								</td>
								<td>
									<input type="text" id="fechaProg" name="fechaProgramada"  tabindex="4" size="12" esCalendario="true"/> 
								    <label for="lblfechaProg">Hora:</label>
								    <input type="text" id="horaProgramada" name="horaProgramada"  tabindex="5" size="6"/>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="lblprodCredID">Categor&iacute;a:</label>
								</td>
								<td>
									<input type="text" id="categoriaID" name="categoriaID"  tabindex="6" size="12"/> 
        							<input type="text" id="descCategoria" name="descCategoria" size="45"  disabled="true"/>

								</td>
							</tr>
							
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblgestorID">Gestor:</label>
								</td>
								<td>
									<input type="text" id="puestoResponsableID" name="puestoResponsableID"  tabindex="7" size="12" /> 
									<input type="text" id="nombreResponsable" name="nombreResponsable" size="45" disabled="true" />
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="lblsupervisorID">Supervisor:</label>
								</td>
								<td>
									<input id="puestoSupervisorID" name="puestoSupervisorID" size="12" disabled="true" /> 
									<input id="nombreSupervisor" name="nombreSupervisor" size="45" disabled="true" />
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbltipoGeneración">Tipo Generaci&oacute;n:</label>
								</td>
								<td>
									<select id="tipoGeneracion" name="tipoGeneracion" disabled="true">
										<option value="M">MANUAL</option>
										<option value="A">AUTOMATICO</option>
									</select>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
                                    <label for="lblsegtoforza">Seguimiento Forzado: </label>								
								</td>
								<td>
								        <input type="checkbox" id="segtoForzado" name="esForzado" tabindex="8" value="S"/>
								</td>
							</tr>	
							
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblestatusPro">Estatus:</label>
								</td>
								<td>
									<select id="estatusProg" name="estatus" readOnly="true">
										<option value="P">PROGRAMADO</option>
										<option value="I">INICIADO</option>
										<option value="T">TERMINADO</option>
										<option value="C">CANCELADO</option>
										<option value="R">REPROGRAMADO</option>
										<option value="A">AUTORIZADO</option>
									</select>
								</td>
								<td class="separador"></td>
								<td class="label" nowrap="nowrap">
									<label for="lblfechaForza">Fecha Registro:</label>
								</td>
								<td>
									<input type="text" id="fechaRegistro" name="fechaRegistro" size="12" /> 
								</td>
							</tr>
							</table>
					</fieldset>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="9"/>
								<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="10"/>
								<input type="submit" id="eliminar" name="eliminar" class="submit" value="Eliminar" tabindex="10"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							</td>
						</tr>
					</table>
					</fieldset>
				</fieldset>
			</form:form>
		</div>
		
		<div id="cargando" style="display: none;">	
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
		</body>
		<div id="mensaje" style="display:none;"></div> 
</html>