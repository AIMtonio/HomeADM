<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
			<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
			<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
			<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
			<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	      	<script type="text/javascript" src="js/tesoreria/dispersionMasiva.js"></script>     
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="dispersionMasivaBean">
			
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Carga de dispersi&oacute;n masiva</legend>
					<br/> 	
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label">
							         <label for="lblinstitucionID">Instituci&oacute;n:</label>
								</td>
							    <td>
					         		<input type="text" id="institucionID" name="institucionID" path="institucionID" size="10"  tabindex="1" />
					         		<input id="nombreInstitucion" name="nombreInstitucion" size="50" readonly="true" />
							    </td>
							</tr>
							<tr>
								<td class="label"> 
									<label for="lblcueNumCtaInstit">Cuenta Bancaria:</label> 
								</td>
								<td colspan="2">
									<input type="text" id="cuentaAhorro" name="cuentaAhorro" size="20" tabindex="2" />
									<input type="hidden" name="numCtaInstit" id="numCtaInstit" path="numCtaInstit" /> 
								</td>  	
							</tr>
							<tr>
								<td class="label">
									<label for="lblSaldo">Saldo:</label>
								</td>
								<td>
									<input type="text" id="saldo" name="saldo"  size="20" tabindex="5"  readonly="readonly" style="text-align: right;" esMoneda="true"/>
								</td>
							</tr>
							<tr>
								<td class="label">
						      		<label for="lblfecha">Fecha de Dispersi&oacute;n:</label>
						     	</td>
						      	<td>
							     	<input type="text" id="fechaDisp" name="fechaDisp" size="20" tabindex="3"  esCalendario="true" />
							   	</td>
							</tr>
							<tr>
								<td class="label">
									<label for="rutaArchivo">Adjuntar archivo: </label>
								</td>
								<td >
									<input type="text" id="rutaArchivo" name="rutaArchivo" size="50" type="text" readonly="readonly"/>
									<input type="hidden" id="extension" name="extension" size="50" type="text" readonly="readonly"/>	
									<input type="button" id="subirArchivo" name="subirArchivo" class="submit" value="Adjuntar" tabindex="4"/>
								</td>
							</tr>
						</table>
						<br/>

						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label" align="right">
									<input type="button" id="validar" name="validar" class="submit" value="Validar" tabindex="5"/>
									<input type="submit" id="procesar" name="peocesar" class="submit" value="Procesar" tabindex="6"/>
									
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/> 
									<input type="hidden" id="numTransaccion" name="numTransaccion"/>
								</td>
							</tr>
						</table>
						<br/>
						<div id="gridValidacion"/>
				</fieldset>
				
										
			</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
			
		</div>
		<div id="mensaje" style="display: none;"></div>
	</body>
	
</html>