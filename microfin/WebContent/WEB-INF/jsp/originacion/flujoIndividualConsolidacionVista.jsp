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
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>   
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>     
		<script type="text/javascript" src="dwr/interface/opRolServicio.js"></script> 	
 		<script type="text/javascript" src="js/originacion/flujoIndividualConsolidacionControlador.js"></script>
 		<script type="text/javascript" src="dwr/interface/asignaCartaLiqServicio.js"></script>

       	<script>
			$(function() { 
				$("#tabs" ).tabs();
			});
   		</script>
	</head>
<body>
<div id="contenedorForma">
<input type="hidden" id="clienteSocio" value="<s:message code="safilocale.cliente"/>" />

	<div id="tabs"> 
		<ul> 
			<li><a id="selecciona" href="#_selecciona">Seleccione<br> <br></a></li> 
			<li><a id="asignaCartas" href="#asignaCartasLiq">Asignaci&oacute;n de cartas de liquidaci&oacute;n<br> <br></a></li> 
			<li ><a id="solic" href="#solicitud"  >Solicitud  <br> <br></a></li> 
			<li ><a id="datSosEc" href="#dtsSocioEcon" >Datos <br>Socioeconómicos</a></li> 
			<li ><a id="capacidadPagoPorSol" href="#capacidadPagoPorSolicitud">Alta de capacidad de pago<br> <br></a></li>
			<li ><a id="buroCredito" href="#buroCred"  >Buró Crédito  <br> <br></a></li> 
			<li ><a id="aval" href="#contAvales">Avales <br> <br></a></li> 
			<li ><a id="asigAval" href="#asignaAval">Asignación <br>Aval</a></li> 
			<li ><a id="garan" href="#garantias" >Garantías <br> <br></a></li> 
			<li ><a id="asigGaran" href="#asignaGarantias" >Asigna <br>Garantías</a></li> 
			<li ><a id="referenciasSolicitud" href="#referenciasSol">Referencias<br> <br></a></li>	 
			<li ><a id="dispersion" href="#instrucDispersion">Instrucciones de dispersión <br> <br></a></li>
			<li ><a id="check" href="#checklist">Checklist <br> <br></a></li>
		</ul> 
		
		<div id="asignaCartasLiq"></div>
	 	<div id="solicitud"></div>
	 	<div id="dtsSocioEcon"></div>
	 	<div id="capacidadPagoPorSolicitud"></div>
	 	<div id="buroCred"></div>
		<div id="contAvales"></div>
		<div id="asignaAval"></div>
		<div id="garantias"></div>
		<div id="asignaGarantias"></div>
		<div id="referenciasSol"></div>
		<div id="instrucDispersion"></div>
		<div id="checklist"></div>
		
		
		<div id="_selecciona"> 
			<form:form id="formaMenu" name="formaMenu" method="POST" commandName="solicitudCredito">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Flujo de Consolidaci&oacute;n</legend>
					<table border="0"  width="100%">
						<tr>
							<td>
								<table border="0"  width="100%">
									<tr>
										<td class="label">
											<label for="numSolicitud">Solicitud de Cr&eacute;dito: </label>
										</td> 
										<td >
											<input type="text"  id="numSolicitud" name="numSolicitud"  size="15" tabindex="1" autofocus />
											<input type="hidden"  id="consolidacionID" name="consolidacionID"/>	
											<input type="hidden"  id="creditoRelacionadoID" name="creditoRelacionadoID"/>		
											<input type="hidden"  id="solicitudRelacionadoID" name="solicitudRelacionadoID"/>																											
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="cicloActual">Ciclo Actual: </label>
										</td> 
										<td>
											<input type="text" id="cicloActual" name="cicloActual"  size="12" readonly/>
										</td>				
									</tr>
									<tr>
										<td class="label">
											<label for="fechaRegistro">Fecha Registro: </label>
										</td> 
							  			<td >
								 			<input type="text"  id="fechaRegistro" name="fechaRegistro"  size="15" readonly/>
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="lblProducto">Producto de Cr&eacute;dito: </label>
										</td> 
										<td>
											<input type="text"  id="productoCredito" name="productoCredito"  size="12" readonly/>
											<input  type="text" id="nombreProducto" name="nombreProducto"  size="40" readonly/>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="nombreEstatus">Estatus de la Solicitud: </label>
										</td> 
							  			<td >
								 			<input  type="text"  id="nombreEstatus" name="nombreEstatus"  size="15" readonly />
								 			<input  type="hidden"  id="flujoIndividualBandera" name="flujoIndividualBandera"  size="15" value="S" />
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
											<input type="submit" id="liberar" class="submit" value="Liberar Solicitud" tabindex="5"  />
											<input type="submit" id="cancelar" name="cancelar" class="submit" value="Rechazar Solicitud" tabindex="6"  />
<!-- 											<input type="button" id="checkDatos" name="checkDatos" class="submit" value="CheckDatos" tabindex="7"  />     -->
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
													<input type="text" id="solicitudCre1" name="solicitudCre" size="12" readOnly/> 
											  	</td>
											  	<td> 
													<input type="text" id="creditoID1" name="creditoID" size="12" readOnly/> 
											  	</td>
											  	<td> 
													<input type="text" id="prospectIDGrupal"  name="prospectIDGrupal" size="12" readOnly/> 
												</td> 
												<td> 
													<input type="text" id="clientIDGrupal"  name="clientIDGrupal" size="12" readOnly/> 
												</td>  
											  	<td> 
											  		<input type="text" id="nomb1" name="nomb1" size="50" readOnly/> 
											  	</td> 
											  	<td> 
													<input type="text" id="montSolicit"  name="montSolicit" size="15"  style="text-align:right;" readOnly="readonly" esMoneda="true"/> 
												</td> 
												<td> 
													<input type="text" id="montoAutori"  name="montoAutori" size="15"  style="text-align:right;" readOnly="readonly" esMoneda="true" /> 
												</td>
												<td> 
													<input type="text" id="fechaIni1"  name="fechaIni" size="10" readOnly="readonly"/> 
												</td> 
												<td> 
													<input type="text" id="fechaVencimiento1"  name="fechaVencimiento" size="10" readOnly="readonly"/> 
												</td> 
												<td> 
													<input type="hidden" id="comentarioEjecutivo1"  name="LcomentarioEjecutivo" readOnly/> 
													<input type="hidden" id="nuevosComentarios1"  name="LnuevosComentarios" value="" readOnly /> 
													<input type="hidden" id="requiereGarantia1"  name="LrequiereGarantia" readOnly /> 
													<input type="hidden" id="requiereAvales1"  name="LrequiereAvales" readOnly /> 
													<input type="hidden" id="perAvaCruzados1"  name="LperAvaCruzados"  readOnly /> 	
													<input type="hidden" id="perGarCruzadas1"  name="LperGarCruzadas" readOnly /> 										  			    		  
												</td>
											</tr>
											<tr>
												<td align="right" colspan="5" align="right">
													<input id="prodCreditoID" name="prodCreditoID" size="10" type = "hidden" readOnly/>	
													<input id="fecRegistro" name="fecRegistro" size="10"  type = "hidden" readOnly/>													 
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
											<label for="agregarComent">Nuevos Comentarios  </label>	
											<input style="text-align: right;" type="submit" id="agregarComent" class="submit" value="Agregar" tabindex="6"  /> 			
										</td>
									</tr>
									<tr>
										<td>
											<div id="comentDeEjecutivo"  style="display: none;">  
												<textarea id="comentEjecut" name="comentEjecut" disabled rows="2" cols="42" style="margin: 2px; width: 480px; height: 64px;" ></textarea>
											</div>					
										</td>
										<td >
											<input type="hidden" id="motivoRechazo" name="motivoRechazo" value=""/>
											<div id="divNuevosComentarios"  >  
												<textarea id="nuevosComents" name="nuevosComents" onChange="ponerMayusculas(this);" onBlur="ponerMayusculas(this);"
													rows="2" cols="42" style="margin: 2px; width: 280px; height: 64px;" ></textarea>
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
	<div id="pruebaDatos"></div>
</div> <!-- contenedorForma -->

<div id="cargando" style="display: none;"></div>
<div id="cajaListaContenedor" style="display: none;">
	<div id="elementoListaContenedor"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>