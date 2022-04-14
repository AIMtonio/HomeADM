<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="js/originacion/productividadAnalis.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="analistasAsignacionBean" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Productivididad de Analistas </legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
					 		<tr> 
					 			<td> 
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										 <legend ><label>Par&aacute;metros</label></legend>	
		         						<table  border="0"  width="100%">
											<tr>
												<td class="label"> 
													<label>Fecha Inicio: </label>
												</td>
												<td>
													<form:input type="text" name="fechaInicio" id="fechaInicio" path="fechaInicio" autocomplete="off" size="12" tabindex="1"  esCalendario="true"/>						
												</td>
											</tr>
											<tr>
												<td class="label"> 
													<label>Fecha Final: </label>
												</td>
												<td>
													<form:input type="text" name="fechaFin" id="fechaFin" path="fechaFin" autocomplete="off" size="12" tabindex="2"  esCalendario="true"/>						
												</td>
											</tr>
											<tr>
												<td class="label"><label>Usuario:</label></td>
												<td>
													<form:input type="text" name="usuarioID"	id="usuarioID" path="usuarioID" autocomplete="off" size="12" tabindex="3" value='0'/>
													<input type="text"	name="nombreCompletoC" id="nombreCompletoC" autocomplete="off" size="40"  disabled="true" value="TODOS" /> 
												</td>
											</tr>

						  			</table>
						 		</fieldset>  
							</td>

						    <td  valign="top">
								<table  border="0" width="100px" > 
									<tr>
										<td class="label" >
											<fieldset class="ui-widget ui-widget-content ui-corner-all"> 
											 <legend ><label>Presentaci&oacute;n</label></legend>	
												<input type="radio" id="pdf" name="tipoReporte" value="1" tabindex="6"/>
												<label for="pdf"> PDF </label>
												<br>
												<input type="radio" id="excel" name="tipoReporte" value="2" tabindex="7"/>
												<label for="excel"> Excel </label>
											</fieldset>
										</td>
									</tr>
							    </table>
				  		    </td>

					</tr>

				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="5">
							<table align="right" border='0'>
								<tr>
									<td width="350px">&nbsp;</td>
									<td align="right">
										<input type="button" id="generar"	name="generar" class="submit" tabindex="9" value="Generar" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>	
			</fieldset>
		</form:form>
		</div>

		<div id="cajaLista" style="display: none;">
			<div id="elementoLista" />
		</div>
	</body>
</html>