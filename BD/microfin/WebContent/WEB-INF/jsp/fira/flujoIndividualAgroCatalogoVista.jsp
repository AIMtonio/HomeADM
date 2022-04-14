<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<link href="css/redmond/jquery-ui-1.8.16.custom.css" media="all"  rel="stylesheet" type="text/css">  
		<script type="text/javascript" src="js/jquery-ui-1.8.16.custom.min.js"></script>  
		<script type='text/javascript' src='js/jquery.ui.tabs.js'></script>
		<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>                 
 	   	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
 	   	<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>   
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>     
		<script type="text/javascript" src="dwr/interface/opRolServicio.js"></script> 
 		
 		<script type="text/javascript" src="js/fira/flujoIndividualAgro.js"></script>

       	<script>
			$(function() { 
				$("#tabs" ).tabs();
			});
   		</script>
	</head>
<body>
<div id="contenedorForma">
	<div id="tabs"> 
		<ul> 
			<li><a id="selecciona" href="#_selecciona">Seleccione<br> <br></a></li> 	
			<li ><a id="solic" href="#solicitud"  >Solicitud  <br> <br></a></li> 
			<li ><a id="bc" href="#burocredito">Buró <br>Crédito</a></li>
			<li ><a id="datSosEc" href="#dtsSocioEcon" >Datos <br>Socioeconómicos</a></li> 
			<li ><a id="aval" href="#contAvales">Avales <br> <br></a></li> 
			<li ><a id="asigAval" href="#asignaAval">Asignación <br>Aval</a></li> 
			<li ><a id="garan" href="#garantias" >Garantías <br> <br></a></li> 
			<li ><a id="asigGaran" href="#asignaGarantias" >Asigna <br>Garantías</a></li>  
			<li ><a id="conceptoInver" href="#conInver">Conceptos <br>de Inversión</a></li>
			<li ><a id="check" href="#checklist">Checklist <br> <br></a></li>	
		</ul> 
		
		<div id="capacidadPago"></div>
	 	<div id="solicitud"></div>
		<div id="burocredito"></div>
		<div id="checklist"></div>
		<div id="contAvales"></div>
		<div id="asignaAval"></div>
		<div id="garantias"></div>
		<div id="asignaGarantias"></div>
		<div id="dtsSocioEcon"></div>
		<div id="conInver"></div>
		
		
		<div id="_selecciona"> 
			<form:form id="formaMenu" name="formaMenu" method="POST" commandName="solicitudCredito">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Flujo Individual</legend>
					<table border="0"  width="100%">
						<tr>
							<td>
								<table border="0"  width="100%">
									<tr>
										<td class="label">
											<label for="lblGrupo">Solicitud de Cr&eacute;dito: </label>
										</td> 
										<td >
											<input type="text"  id="numSolicitud" name="numSolicitud"  size="15" tabindex="1"  />
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="lblCiclo">Ciclo Actual: </label>
										</td> 
										<td>
											<input type="text" id="cicloActual" name="cicloActual"  size="12"  readOnly="true" />
										</td>				
									</tr>
									<tr>
										<td class="label">
											<label for="fecha">Fecha Registro: </label>
										</td> 
							  			<td >
								 			<input type="text"  id="fechaRegistro" name="fechaRegistro"  size="15" 
								 			readOnly="true"   />
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="lblProducto">Producto de Crédito: </label>
										</td> 
										<td >
											<input type="text"  id="productoCredito" name="productoCredito"  size="12"  readOnly="true"/>
											<input  type="text" id="nombreProducto" name="nombreProducto"  size="40"  readOnly="true"/>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="fecha">Estatus de la Solicitud: </label>
										</td> 
							  			<td >
								 			<input  type="text"  id="nombreEstatus" name="nombreEstatus"  size="15" 
								 				 readOnly="true"  />
								 			<input  type="hidden"  id="flujoIndividualBandera" name="flujoIndividualBandera"  size="15" 
								 				value="S" tabindex="3" />
										</td>		
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<table align="left">
									<tr>					 	
										<td align="left">
											<input type="submit" id="liberarGrupal" name="liberarGrupal" class="submit" value="Liberar Solicitud" tabindex="5"  />
											<input type="submit" id="cancelar" name="cancelar" class="submit" value="Rechazar Solicitud" tabindex="6"  />  
											<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />				
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<br>
								<div id="Integrantes" style="display: none;" >
								<form id="gridIntegrantes" name="gridIntegrantes">
									<fieldset class="ui-widget ui-widget-content ui-corner-all">                
									<legend>Solicitud de Crédito</legend>	
										<table id="miTabla" border="0" width="100%">
											<tr>
												<td class="label"> 
											   		<label for="lblSolicitudCre">Solicitud</label> 
												</td>
												<td class="label"> 
											   		<label for="lblSolicitudCre">Crédito</label> 
												</td>
												<td class="label"> 
													<label for="lblClienteID">Prospecto</label> 
										  		</td>
										  		<td class="label"> 
													<label for="lblClienteID"><s:message code="safilocale.cliente"/></label> 
										  		</td>
										  		<td class="label"> 
													<label for="lblNombre">Nombre</label> 
										  		</td>
										  		<td class="label"> 
													<label for="lblMontoAu">Monto <br> Solicitado</label> 
										  		</td>
										  		<td class="label"> 
													<label for="lblMontoAu">Monto <br> Autorizado</label> 
										  		</td>
										  		<td class="label"> 
													<label for="lblProductoCre">Fecha <br> Inicio</label> 
										  		</td>
										  		<td class="label"> 
													<label for="lblCargo">Fecha <br>Vencimiento</label> 
										  		</td>
										  	</tr>
											<tr id="renglon1" >
											  	<td> 
													<input type="text" id="solicitudCre1" name="solicitudCre" size="9" 
														readOnly/> 
											  	</td>
											  	<td> 
													<input type="text" id="creditoID1" name="creditoID" size="9" 
														 readOnly/> 
											  	</td>
											  	<td> 
													<input type="text" id="prospectIDGrupal"  name="prospectIDGrupal" size="7"  
															  readOnly/> 
												</td> 
												<td> 
													<input type="text" id="clientIDGrupal"  name="clientIDGrupal" size="7"  
															  readOnly/> 
												</td>  
											  	<td> 
											  		<input type="text" id="nomb1" name="nomb1" size="40" 
															 readOnly/> 
											  	</td> 
											  	<td> 
													<input type="text" id="montSolicit"  name="montSolicit" size="15"  style="text-align:right;"
														   readOnly="readonly" esMoneda="true"/> 
												</td> 
												<td> 
													<input type="text" id="montoAutori"  name="montoAutori" size="15"  style="text-align:right;"
															readOnly="readonly" esMoneda="true" /> 
												</td>
												<td> 
													<input type="text" id="fechaIni1"  name="fechaIni" size="10"  
															  readOnly="readonly"/> 
												</td> 
												<td> 
													<input type="text" id="fechaVencimiento1"  name="fechaVencimiento" size="10"  
															readOnly="readonly"/> 
												</td> 
												<td> 
													<input type="hidden" id="comentarioEjecutivo1"  name="LcomentarioEjecutivo"  
														   readOnly/> 
													<input type="hidden" id="nuevosComentarios1"  name="LnuevosComentarios"  
													    	  value="" readOnly /> 
													<input type="hidden" id="requiereGarantia1"  name="LrequiereGarantia" 
															   readOnly /> 
													<input type="hidden" id="requiereAvales1"  name="LrequiereAvales"  
															  readOnly /> 
													<input type="hidden" id="perAvaCruzados1"  name="LperAvaCruzados"  
															   readOnly /> 	
													<input type="hidden" id="perGarCruzadas1"  name="LperGarCruzadas" 
															  readOnly /> 										  			    		  
												</td>
											</tr>
											<tr>
												<td align="right" colspan="5" align="right">
													<input id="prodCreditoID" name="prodCreditoID" size="10" type = "hidden"
													        readOnly/>	
													<input id="fecRegistro" name="fecRegistro" size="10"  type = "hidden"
													          readOnly/>													 
												</td>
											</tr>
											</table>
										</fieldset>
									</form>
								</div>
								<br>
							</td>
						</tr>
						<tr>
							<td>
								<table align="left">
									<tr>
										<td>
											<label  id="labelHistorialCom" for="lblProducto"  style="display: none;" >Historial de Comentarios</label>	 					
										</td>
										<td >
											<label for="lblProducto">Nuevos Comentarios  </label>	
											<input style="text-align: right;" type="submit" id="agregarComent" name="agregarComent" class="submit" value="Agregar" tabindex="6"  /> 			
										</td>
									</tr>
									<tr>
										<td>
											<div id="comentDeEjecutivo"  style="display: none;">  
												<textarea id="comentEjecut" name="comentEjecut" disabled rows="2" cols="42" 
														style="margin: 2px; width: 480px; height: 64px;" ></textarea>
											</div>					
										</td>
										<td >
											<input type="hidden" id="motivoRechazo" name="motivoRechazo"	value=""/>
											<div id="divNuevosComentarios"  >  
												<textarea id="nuevosComents" name="nuevosComents" onChange="ponerMayusculas(this);" onBlur="ponerMayusculas(this);"
													rows="2" cols="42" style="margin: 2px; width: 280px; height: 64px;" maxlength="500"></textarea>
											</div>							
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>	
				</fieldset>
			</form:form>
		</div> <!-- grupo -->
	</div> <!-- tab -->
</div> <!-- contenedorForma -->

<div id="cargando" style="display: none;"></div>
<div id="cajaListaContenedor" style="display: none;">
	<div id="elementoListaContenedor"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>