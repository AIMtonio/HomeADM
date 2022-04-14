<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<link href="css/redmond/jquery-ui-1.8.16.custom.css" media="all"  rel="stylesheet" type="text/css">  
		<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
		<script type="text/javascript" src="js/jquery-ui-1.8.16.custom.min.js"></script>  
		<script type='text/javascript' src='js/jquery.ui.tabs.js'></script>
		<script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>
		<script type="text/javascript" src="dwr/interface/regulatorioC0922Servicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/regulatorioInsServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/opcionesMenuRegServicio.js"></script>		
		<script type="text/javascript" src="js/regulatorios/regulatorioC0922.js"></script>
		<script>
			$(function() { 
				$("#tabs" ).tabs();
			});
   		</script>
	</head> 
<body>
<div id="contenedorForma" style="
    width: 100%; 
">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Altas y Bajas de Comisionistas  (A-2611)</legend> 
	<div id="tblRegulatorio">


				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="regulatorioC0922" style="min-width: 400px">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label style="
										    width: 150px;
										    font-size: .80em;
										    color: #999999;
										">Periodo:</label></legend>
						 	<table border="0" cellpadding="0" cellspacing="0" width="">    	
								<tr>
																<td class="label" > 
															        <label for="anio">Año: </label> 
															    </td> 
															    <td>
																	<select id="anio" name="anio">
																	</select>
																</td>

																<td class="separador"></td>

															    <td class="label" > 
															        <label for="mes">Mes: </label> 
															    </td> 					    
															   <td>
																	<select id="mes" name="mes">
																		<option value="0">SELECCIONAR</option>
																		<option value="1">ENERO</option>
																		<option value="2">FEBRERO</option>
																		<option value="3">MARZO</option>
																		<option value="4">ABRIL</option>
																		<option value="5">MAYO</option>
																		<option value="6">JUNIO</option>
																		<option value="7">JULIO</option>
																		<option value="8">AGOSTO</option>
																		<option value="9">SEPTIEMBRE</option>
																		<option value="10">OCTUBRE</option>
																		<option value="11">NOVIEMBRE</option>
																		<option value="12">DICIEMBRE</option>
																	</select>
																</td>
															</tr>

							</table>
						</fieldset>
						<br>

						
						<div id="tabs"> 
							<ul> 
								<li ><a id="reporteD0842" href="#_reporte">Reporte</a></li> 	
								<li ><a id="registroD0842" href="#_registro">Registro </a></li> 	
							</ul> 	 
									<div id="_reporte"> 
										<table id="reporte" width="100%">
											<tr>
											<td>
										 		<table width="100%" >  	
															<tr>
															<td class="label" >
															<fieldset class="ui-widget ui-widget-content ui-corner-all">                
																<legend><label>Presentaci&oacute;n</label></legend>
																<table>
																	<tbody>
																		
																		<tr>
																		<td><input type="radio" id="excel" name="presentacion" selected="true" tabindex="999" ></td><td>
																				<label> Excel </label>	</td>
																			
																		</tr>
																		<tr>
																			<td><input type="radio" id="csv" name="presentacion" tabindex="1000" ></td><td>
																				<label> Csv </label>	</td>
																			
																											
																		</tr>
																	</tbody>
																</table>
															</fieldset>
															</td>
														</tr>
												</table>
											<br>	
												<table border="0" cellpadding="0" cellspacing="0" width="100%">
													<tr> 
														<td >
															<table align="right" border='0'>
																<tr>
																	<td align="right"">
																			<input type="button" id="generar" name="generar" class="submit"
																				 tabindex="4" value="Generar" />
																	</td>	
																</tr> 
															</table>		
														</td>
													</tr>					
												</table>
											</td>
											</tr>
										</table>
									</div>


						<div id="_registro"> 
							<div id="listaRegistroC0922"></div>
					</fieldset>
				</div>

							
						
				</form:form>

	</div>

</fieldset>

</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>