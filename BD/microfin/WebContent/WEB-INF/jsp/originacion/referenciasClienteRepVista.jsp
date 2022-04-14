<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="js/originacion/reporteReferenciasCte.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="referenciasBean" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Referencias por Solicitud de Cr&eacute;dito</legend>
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
												<td class="label"><label>Producto de Cr&eacute;dito:</label></td>
												<td>
													<form:input type="text" name="productoCreditoID"	id="productoCreditoID" path="productoCreditoID" autocomplete="off" size="12" tabindex="3" value='0'/>
													<input type="text"	name="descripProducto" id="descripProducto" autocomplete="off" size="40"  disabled="true" value="TODOS" /> 
												</td>
											</tr>
											<tr>
												<td class="label"> 
													<label for="interesado">Interesado: </label> 
												</td>
												<td>
													<select id="interesado" name="interesado" tabindex="3" >
														<option value=''>TODOS</option>
														<option value='S'>Si</option>
														<option value='N'>No</option>					  
													</select>
												</td> 
											</tr>
						  			</table>
						 		</fieldset>  
							</td>
					</tr>
					<tr>
						<td>
							<table width="200px"> 
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