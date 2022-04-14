<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>

<head>
<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>

<script type="text/javascript" src="js/tesoreria/estadoCuentaBancosVista.js"></script>

<title>Consulta Saldo Cuenta Nostro</title>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentaNostro"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Estado de Cuenta de Bancos</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">			
					<tr>
					    <td class="label">
					        <label for="institucion">Instituci&oacute;n: </label> 
					    </td>
					    <td >
					        <input type="text" id="institucionID" name="institucionID"  size="24" tabindex="1"/>
					        <input type="text" id="nombreInstitucion" name="nombreInstitucion" tabindex="2" size="50" disabled="true" readOnly="true"/>
					        <input type="hidden" id="nombreCortoInstitucion" name="nombreCortoInstitucion" size="50" disabled="true" readOnly="true"/> 
					    </td>                                            
					</tr>         
					<tr>
					    <td class="label">
					        <label for="cuentaBan">Cuenta bancaria:</label> 
					    </td>
					    <td>
					    <input id="cuentaBancaria" name="cuentaBancaria"  size="24" tabindex="3"/>
					    </td>
					</tr>
					<tr> 
						<td class="label"> 
							<label for="lblFecha">Fecha:</label> 
					   </td> 
					   <td> 
					    	<input type="text" id="fecha" name="fecha"  size="14" tabindex="4" esCalendario="true"></input> 
					   </td> 
					</tr>
					
					<tr>
						<td colspan="5">
							<table align="right">
								<tr>
									<td align="right">									
										<input type="button" id="consultar" name="consultar" class="submit" value="Consultar" tabindex="5"/>
										<a id="enlace" target="_blank"> 
											<input type="button" id="generar" name="generar" class="submit" value="Generar PDF" tabindex="6" 
												style="display: none;"/>
										</a>
										<a id="enlaceExcel" target="_blank"> 
											<input type="button" id="generarExcel" name="generarExcel" class="submit" value="Exportar Excel" tabindex="7" 
												style="display: none;"/>
										</a>
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion" />
										<input type="hidden" id="nombreInstitucionSistema" name="nombreInstitucionSistema" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				
			</fieldset>
		</form:form>
	</div>
	<div id="gridMovEstadoCuentaBancos" style="display: none;"></div>
	
	
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
