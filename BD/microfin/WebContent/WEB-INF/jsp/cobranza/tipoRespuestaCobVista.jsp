<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 

<html>
	<head>
      	<script type="text/javascript" src="dwr/interface/tipoAccionCobServicio.js"></script> 
		<script type="text/javascript" src="js/cobranza/tipoRespuestaCob.js"></script>
	</head>
	
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tipoAccionCobBean" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Tipos de Respuesta</legend>
						<table >
							<tr>
								<td colspan="2">
									<table >
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="accionID">Tipo Acci&oacute;n:</label>
											</td>
											<td>
												<select id="accionID" name="accionID" tabindex="1"  style="width:500px">
												<option value="">SELECCIONAR</option>
												</select>
											</td>	
										</tr>
									</table>
								</td>	
							</tr>
							<tr>
								<td>									
									<input type="button" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="1" />
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<div id="divGridTiposRespuesta"></div>	
								</td>	
							</tr>
							<tr>															
								<td align="right" colspan="2">	
									<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="101" />
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>											
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