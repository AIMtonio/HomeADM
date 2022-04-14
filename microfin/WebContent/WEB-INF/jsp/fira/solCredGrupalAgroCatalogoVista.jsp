<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
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
 		
 		<script type="text/javascript" src="js/fira/solicitudCreditoGrupal.js"></script>

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
			<li><a id="grup" href="#grupos">Grupo<br> <br></a></li> 
			<li ><a id="solic" href="#solicitud" >Solicitud  <br> <br></a></li> 
			<li ><a id="bc" href="#burocredito">Buró <br>Crédito</a></li>
			<li ><a id="datSosEc" href="#dtsSocioEcon" >Datos <br>Socioeconómicos</a></li> 
			<li ><a id="aval" href="#contAvales">Avales <br> <br></a></li> 
			<li ><a id="asigAval" href="#asignaAval">Asignación <br>Aval</a></li> 
			<li ><a id="garan" href="#garantias" >Garantías <br> <br></a></li> 
			<li ><a id="asigGaran" href="#asignaGarantias" >Asigna <br>Garantías</a></li>  
			<li ><a id="conceptoInver" href="#conInver">Conceptos <br>de Inversión</a></li> 
			<li ><a id="check" href="#checklist">Checklist <br> <br></a></li>
		</ul> 
		
	 	<div id="solicitud"></div>
		<div id="burocredito"></div>
		<div id="checklist"></div>
		<div id="contAvales"></div>
		<div id="asignaAval"></div>
		<div id="garantias"></div>
		<div id="asignaGarantias"></div>
		<div id="dtsSocioEcon"></div>
		<div id="conInver"></div>
		
		<div id="grupos"> 
			<form:form id="formaMenu" name="formaMenu" method="POST" commandName="solicitudCredito">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Solicitud de Crédito Grupal</legend>
					<table  width="100%">
						<tr>
							<td>
								<table  width="100%">
									<tr>
										<td class="label">
											<label for="lblGrupo">Grupo: </label>
										</td> 
										<td >
											<input type="text"  id="grupo" name="grupo"  size="12" tabindex="1"  />
											<!--numSolicitud: Numero de solicitud actual, cambia cada que se hace un clic en el readio -->
											<input id="numSolicitud" name="numSolicitud"  size="10"  type="hidden" />
											 <!--clientIDGrupal: ID del cliente Actual, cambia cada que se hace un clic en el readio -->
											<input id="clientIDGrupal" name="clientIDGrupal"    type="hidden" />
											 <!-- prospectIDGrupal: ID del Prospecto Actual, cambia cada que se hace un clic en el readio -->
											<input id="prospectIDGrupal" name="prospectIDGrupal"  size="10"  type="hidden" />
											<!-- Monto solicitado de solicitud actual. Usado solo en la pantalla de solicitud
											y solo cuando se carga en la pantalla grupal, cambia conforme al focus del radio -->
											<input id="montSolicit" name="montSolicit"    type="hidden" />
											<input type="text"  id="nombreGrupo" name="nombreGrupo"  size="40" tabindex="2"  disabled="true" 
												iniForma="false"/>
											<!-- puedeAgregarSolicitudes:bandera para verificar si es posible agregar mas solicitudes al grupo
											cuando el grupo esta cerrado, ya no se podra agregar más -->
											<input id="puedeAgregarSolicitudes" name="puedeAgregarSolicitudes"   value="S" type="hidden" />
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="lblCiclo">Ciclo Actual: </label>
										</td> 
										<td>
											<input type="text" id="cicloActual" name="cicloActual"  size="12" tabindex="3"  disabled="true" 
												iniForma="false"/>
										</td>					
									</tr>
									<tr>
										<td class="label">
											<label for="fecha">Fecha Registro: </label>
										</td> 
							  			<td >
								 			<input type="text"  id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" 
								 			readonly= "true" disabled = "true" tabindex="3" />
										</td>		
										<td class="separador"></td>
										<td class="label">
											<label for="lblProducto">Producto de Crédito: </label>
										</td> 
										<td >
											<input type="text"  id="productoCredito" name="productoCredito"  size="12" tabindex="1" disabled="true" />
											<input  type="text" id="nombreProducto" name="nombreProducto"  size="40" tabindex="2" disabled="true"  />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="fecha">Estatus del Grupo: </label>
										</td> 
							  			<td >
								 			<input  type="text"  id="nombreEstatusCiclo" name="nombreEstatusCiclo" path="nombreEstatusCiclo" size="12" 
								 			readonly= "true" disabled = "true" tabindex="3" />
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="tipo">Tipo de Operación: </label>
										</td> 
							  			<td >
								 			<input  type="text"  id="tipoOperacionFIRA" name="tipoOperacionFIRA" path="tipoOperacionFIRA" size="12" 
								 			readonly= "true" disabled = "true" />
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
											<input type="submit" id="liberarGrupal" name="liberarGrupal" class="submit" value="Liberar Grupo para Autorización" tabindex="5"  />
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
								<div id="Integrantes" style="display: none;" >	</div>
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
												<textarea id="comentEjecut" name="comentEjecut" disabled="true" rows="2" cols="42" 
														style="margin: 2px; width: 480px; height: 64px;" ></textarea>
											</div>					
										</td>
										<td >
											<input type="hidden" id="motivoRechazo" name="motivoRechazo"	value=""/>
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
</div> <!-- contenedorForma -->

<div id="cargando" style="display: none;"></div>
<div id="cajaListaContenedor" style="display: none;">
	<div id="elementoListaContenedor"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>