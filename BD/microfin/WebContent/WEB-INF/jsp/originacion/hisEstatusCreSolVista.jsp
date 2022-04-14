<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>   
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>     
        <script type="text/javascript" src="js/originacion/hisEstatusCreSol.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="hisEstatusCreSolBean" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Hist&oacute;rico de Solicitud de Cr&eacute;dito</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
					 		<tr> 
					 			<td> 
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										 <legend ><label>Par&aacute;metros</label></legend>	
		         						<table  border="0"  width="100%">
										
											<tr>
												<td class="label"><label >Solicitud:</label></td>
												<td>
													<input type="text" name="solicitudCreID"	id="solicitudCreID"   size="13" tabindex="1" />
												</td>
											</tr>
											<tr>
												<td class="label"><label >Cliente:</label></td>
												<td>
													<form:input type="text" name="clienteID"	id="clienteID" path="clienteID" autocomplete="off" size="12" tabindex="3"  disabled="true" />
													<input type="text"	name="clienteDes" id="clienteDes" autocomplete="off" size="40"  disabled="true" /> 
												</td>
											</tr>
											<tr>
												<td class="label"><label>Producto de Cr&eacute;dito:</label></td>
												<td>
													<form:input type="text" name="productoCreID"	id="productoCreID" path="productoCreID" autocomplete="off" size="12" tabindex="3"  disabled="true"  />
													<input type="text"	name="productoCreDes" id="productoCreDes" autocomplete="off" size="40"  disabled="true"  /> 
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