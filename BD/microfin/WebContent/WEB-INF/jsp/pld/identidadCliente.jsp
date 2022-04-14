<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>   	
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
   		<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
   		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
   		<script type="text/javascript" src="dwr/interface/identidadClienteServicio.js"></script>                                                                                                                                                
   		
		<script type="text/javascript" src="js/pld/identidadCliente.js"></script>  
	</head>
<body>

<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Identidad del Cliente</legend>
<form:form id="formaGenerica" name="formaGenerica" method="post" commandName="identiCliente">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                        		
			<table width="100%">
				<tr>
					<td class="label">
							<label for="clientelb">Cliente: </label> 
					</td>
				   	<td>
				    		<input id="clienteID" name="clienteID"  path="clienteID" size="10" tabindex="1"/>       				
		         			<input id="nombreCliente" name="nombreCliente"size="50" type="text" readOnly="false"/>
			  		</td>	
				</tr>	
	 			<tr>
					<td class="label"> 
         				<label for="clienteID">Promotor: </label> 
					</td>
      				<td>
         				<input type="text" id="promotorID" name="promotorID" size="10" readOnly="true" />  
         				<input type="text" id="nombrePromotor" name="nombrePromotor" size="50" readOnly="true"/>  
      				</td> 
      			</tr>
      			<tr>
					<td class="label"> 
         				<label for="sucursalID">Sucursal: </label> 
					</td>
      				<td>
         				<input type="text" id="sucursalID" name="sucursalID" size="10" readOnly="true"  />  
         				<input type="text" id="nombreSucursal" name="nombreSucursal" size="50" readOnly="true"/>         				
      				</td> 
      			</tr>
			</table>
		 	</fieldset>  
		</td>  
	</tr>
	<tr><td>
	   <br>
	   <div id="divCuestionarioPrin" style="display: none;">
	   <fieldset class="ui-widget ui-widget-content ui-corner-all">
	   <LEGEND>Cuestionario</LEGEND>                       			
		<div>
			<table width="100%">
				<tr>
					<td class="label" width="350px"> 
         				<label for="aplicaCuest">El presente cuestionario se aplica por: </label> 
					</td>					
					<td nowrap>
						<input type="radio" id="actAltoRiesgo" name="aplicaCuest" class="clAplcCuest" tabindex="2" value="A" checked/><label> Actividad de Alto Riesgo</label>
						<input type="radio" id="peps" name="aplicaCuest" class="clAplcCuest" tabindex="3" value="P"/><label> PEP'S</label>
						<input type="radio" id="cambioPerfil" name="aplicaCuest" class="clAplcCuest" tabindex="4" value="C"/><label>Cambio perfil Transaccional</label>
						<input type="radio" id="otroAplCuest" name="aplicaCuest" tabindex="5" value="O"/><label>Otros</label>
						<textarea id="otroAplDetalle" name="otroAplDetalle" cols="14" rows="2" tabindex="6" style="display:none;" maxlength="200" onblur="ponerMayusculas(otroAplDetalle)"></textarea>
					</td>
				</tr>
				<tr>
					<td class="label" width="350px"> 
         				<label for="aplicaCuest">1.- ¿Ha realizado operaciones en efectivo de manera consecutiva? </label> 
					</td>					
					<td>
						<input type="radio" id="realizadoOpSI" name="realizadoOp" value="S" tabindex="7"/><label>SI</label>
						<input type="radio" id="realizadoOpNO" name="realizadoOp" value="N" tabindex="8" checked/><label>NO</label>
					</td>
				</tr>				
			</table>
		</div>
	  	<div id="divFuenteRecursos" style="display: none;">
			<table>
				<tr>	
					<td class="label" width="350px"> 
        					<label for="fuenteRecursos">2.- ¿Cuál es la fuente de sus recursos? </label> 
					</td>	
					<td>
						<input type="radio" id="fuenteApoyoGuber" name="fuenteRecursos" value="A" tabindex="9" checked/><label>a) Apoyo Gubernamental</label>	
						<input type="radio" id="fuenteComer" name="fuenteRecursos" value="C" tabindex="10"/><label>b) Comercio</label>
						<input type="radio" id="fuenteNuevaAct" name="fuenteRecursos" value="N" tabindex="11"/><label>c) Nueva Actividad</label>
						<input type="radio" id="fuenteProvRecur" name="fuenteRecursos" value="P" tabindex="12"/><label>d) Proveedores de Recursos</label>
					</td>					
				</tr>	
				<tr>
					<td class="separador"/>
					<td>
						<input type="radio" id="fuenteOtra" name="fuenteRecursos" value="O" tabindex="13"/><label>e) Otro. Cualquier caso especifique: </label>
						<textarea id="fuenteOtraDet" name="fuenteOtraDet" colspan="10" rowspan="2" tabindex="14" maxlength="200" onblur="ponerMayusculas(fuenteOtraDet)"></textarea>
					</td>
				</tr>				
			</table>
		</div>
		<div id="divPersonasFisicEmp" style="display: none;">
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend>Personas Físicas con Actividad Empresarial</legend>
			<div >
				<table>
					<tr>	
						<td nowrap> 	        					
	        					<input type="radio" id="incrementoVentas" name="negocioPersona" value="I" tabindex="15"/>
	        					<label for="negocioPersona">a) Incremento de ventas: </label> 
						</td>
					</tr>																
				</table>
				<div id="divIncrementoVentas" style="display: none;">
					<table>
						<tr>
							<td class="label">
								<label for="tipoNegocio">Tipo de negocio:</label>
							</td>
							<td colspan="4" >
								<input type="radio" id="tipoFijo" name="tipoNegocio" class="tnActEmp" value="F" tabindex="16"/><label>Fijo</label>
								<input type="radio" id="tipoSemifijo" name="tipoNegocio" class="tnActEmp" value="S" tabindex="17"/><label>Semifijo</label>	
								<input type="radio" id="tipoAmbulante" name="tipoNegocio" class="tnActEmp" value="A" tabindex="18"/><label>Ambulante</label>
								<input type="radio" id="tipoOtro" name="tipoNegocio"  value="O" tabindex="19" /><label>Otro</label>
								<input type="text" id="tipoOtroNegocio" name="tipoOtroNegocio" size="30" tabindex="20" maxlength="100" onblur="ponerMayusculas(tipoOtroNegocio)"/>															
							</td>																	
						</tr>																									
						<tr>
							<td class="label">
								<label for="giroNegocio">¿Giro del Negocio?:</label>
							</td>
							<td>										
								<input type="text" id="giroNegocio" name="giroNegocio" size="40" tabindex="21" maxlength="100" onblur="ponerMayusculas(giroNegocio)"/>					
							</td>
							<td class="label" nowrap>
								<label for="antigNegocio">Antiguedad Negocio: </label>
							</td>
							<td class="label" nowrap>
								<label for="aniosAntig">Años(s) : </label>
								<input type="text" id="aniosAntig" name="aniosAntig" size="10" tabindex="23"/>
							</td>						
							<td class="label" nowrap>
								<label for="mesesAntig">Meses : </label>
								<input type="text" id="mesesAntig" name="mesesAntig" size="10" tabindex="24"/>
							</td>							
						</tr>
						<tr>
							<td class="label">
								<label for="ubicacNegocio">Ubicación del Negocio : </label>
							</td>
							<td>
								<textarea id="ubicacNegocio" name="ubicacNegocio" cols="30" rows="2" tabindex="25" maxlength="200" onblur="ponerMayusculas(ubicacNegocio)"></textarea>									
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="esNegocioPropio">¿Es Propia?</label>
							</td>
							<td>										
								<input type="radio" id="esNegocioPropioSI" name="esNegocioPropio" value="S" tabindex="26" checked/><label>SI</label>
								<input type="radio" id="esNegocioPropioNO" name="esNegocioPropio" value="N" tabindex="27"/><label>NO</label>										
							</td>
							<td class="label" id="lblEspecifiqueQuien" style="display: none;">
								<label for="especificarNegocio">Especifique de quien es: </label>
							</td>
							<td id="tdEspecifiqueQuien" style="display: none;">
								<input type="text" id="especificarNegocio" name="especificarNegocio" size="20" tabindex="28" maxlength="200" onblur="ponerMayusculas(especificarNegocio)"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="tipoProducto">¿Que tipo de productos comercializa? </label>
							</td>
							<td colspan="2">										
								<input type="text" id="tipoProducto" name="tipoProducto" size="60" tabindex="29" maxlength="500" onblur="ponerMayusculas(tipoProducto)"/>					
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="mercadoDeProducto">¿A quién(es) vende su mercancía (persona/empresa)?:  </label>
							</td>
							<td colspan="2">										
								<input type="text" id="mercadoDeProducto" name="mercadoDeProducto" size="60" tabindex="30" onblur="ponerMayusculas(mercadoDeProducto)"/>					
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="ingresosMensuales">¿Ingresos Mensuales?:  </label>
							</td>
							<td>										
								<input type="text" id="ingresosMensuales" name="ingresosMensuales" size="40" tabindex="31" esMoneda="true"/>					
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="dependientesEcon">¿Dependientes Económicos?:  </label>
							</td>
							<td>										
								<input type="text" id="dependientesEcon" name="dependientesEcon" size="20" tabindex="32"/>					
							</td>
							<td class="label" nowrap>
								<label for="ingresosMensuales">Hijos:  </label>
								<input type="text" id="dependienteHijo" name="dependienteHijo" size="20" tabindex="33"/>
							</td>					
							<td class="label" nowrap>
								<label for="ingresosMensuales">Otro:  </label>
								<input type="text" id="dependienteOtro" name="dependienteOtro" size="20" tabindex="34"/>
							</td>							
						</tr>			
					</table>
				</div>			
			</div>
			<div >
				<table>
					<tr>						
						<td class="label">
							<input type="radio" id="negocioNuevoTipo" name="negocioPersona" value="N" tabindex="35"/>
							<label for="nuevoTipoNeg">b) Nuevo Tipo de Negocio </label>							
						</td>										
					</tr>					
				</table>
				<div id="divNuevoTipoNeg" style="display: none;">
					<table>
						<tr>	
						<td class="label">
							<label for="tipoNegocio">Tipo de negocio:</label>
						</td>							
						<td colspan="4">
							<input type="radio" id="tipoFijoNuev" name="tipoNuevoNegocio" class="clTipoNuevo" value="F" tabindex="36"/><label>Fijo</label>
							<input type="radio" id="tipoSemifijoNuev" name="tipoNuevoNegocio"  class="clTipoNuevo" value="S" tabindex="37"/><label>Semifijo</label>	
							<input type="radio" id="tipoAmbulanteNuev" name="tipoNuevoNegocio" class="clTipoNuevo" value="A" tabindex="38"/><label>Ambulante</label>
							<input type="radio" id="tipoOtroNuev" name="tipoNuevoNegocio" value="O" tabindex="39" /><label>Otro</label>
							<input type="text" id="tipoOtroNuevoNegocio" name="tipoOtroNuevoNegocio" size="30" tabindex="40" 
															onblur="ponerMayusculas(tipoOtroNuevoNegocio)" style="display: none;"/>															
						</td>								
						</tr>
						<tr>
							<td class="label">
								<label for="tipoProdTipoNeg">¿Que tipo de productos comercializa? </label>
							</td>
							<td>										
								<input type="text" id="tipoProdTipoNeg" name="tipoProdTipoNeg" size="60" tabindex="41" maxlength="500" onblur="ponerMayusculas(tipoProdTipoNeg)"/>					
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="mercadoDeProdTipoNeg">¿A quién(es) vende su mercancía (persona/empresa)?:  </label>
							</td>
							<td colspan="2">										
								<input type="text" id="mercadoDeProdTipoNeg" name="mercadoDeProdTipoNeg" size="60" tabindex="42" maxlength="200" onblur="ponerMayusculas(mercadoDeProdTipoNeg)"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="ingresosMensTipoNeg">¿Ingresos Mensuales?:  </label>
							</td>
							<td>										
								<input type="text" id="ingresosMensTipoNeg" name="ingresosMensTipoNeg" size="40" tabindex="43" esMoneda="true"/>					
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="dependientesEconTipoNeg">¿Dependientes Económicos?:  </label>
							</td>
							<td>										
								<input type="text" id="dependientesEconTipoNeg" name="dependientesEconTipoNeg" size="40" tabindex="44"/>					
							</td>
							<td class="label">
								<label for="dependienteHijoTipoNeg">Hijos:  </label>
							</td>
							<td>															
								<input type="text" id="dependienteHijoTipoNeg" name="dependienteHijoTipoNeg" size="20" tabindex="45"/>					
							</td>
							<td class="label">
								<label for="dependienteOtroTipoNeg">Otro:  </label>
							</td>
							<td>															
								<input type="text" id="dependienteOtroTipoNeg" name="dependienteOtroTipoNeg" size="20" tabindex="46"/>					
							</td>
						</tr>
					</table>
				</div>
			</div>
			</fieldset>
		</div>
		<div id="divPersonasSinAct" style="display: none;">
		<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<LEGEND>Personas Físicas sin Actividad Empresarial</LEGEND>
				<table>
					<tr>
						<td class="label">
						 	<label  for="fuenteIngresos">1.- ¿Cuál es la fuente de sus nuevos ingresos?: </label>
						</td>									
					</tr>
					<tr>
						<td>
						 	<input type="radio" id="tipoApertNuev" value="A" name="fteNuevosIngresos" tabindex="47"/><label>a) Apertura de un nuevo negocio: </label>						 	
						</td>						
					</tr>
					<tr>
						<td>
							<input type="radio" id="tipoFamiliarExt" value="F" name="fteNuevosIngresos" tabindex="48"/><label>b) Familiar en el extranjero: </label>
							<div id="divFamiliarExt" style="display: none;">
						 		<table>
						 			<tr>
						 				<td class="label">
						 					<label for="tiempoNuevoNeg">¿Desde Cuándo?</label>
						 				</td>
						 				<td>
						 					<input type="text" id="tiempoNuevoNeg" name="tiempoNuevoNeg" size="20" tabindex="49" maxlength="50" onblur="ponerMayusculas(tiempoNuevoNeg)"/>
						 				</td>
						 			</tr>
						 			<tr>
						 				<td class="label">
						 					<label for="parentescoApertNeg">I.- Parentesco</label>
						 				</td>
						 				<td>
						 					<input type="radio" id="parentescoHijo" name="parentescoApert" value="H" class="clParentApert" tabindex="50"/><label>Hijo(a):</label>
						 				</td>
						 				<td>
						 					<input type="radio" id="parentescoConyuge" name="parentescoApert" value="C" class="clParentApert" tabindex="51"/><label>Cónyuge:</label>
						 				</td>
						 				<td>
						 					<input type="radio" id="parentescoHermano" name="parentescoApert" value="E" class="clParentApert" tabindex="52"/><label>Hermano:</label>
						 				</td>
						 				<td>
						 					<input type="radio" id="parentescoOtro" name="parentescoApert" value="O" tabindex="53"/><label>Otro:</label>
						 					<input type="text" id="parentesOtroDet" name="parentesOtroDet" size="20" tabindex="54" maxlength="200" onblur="ponerMayusculas(parentesOtroDet)"/>
						 				</td>
						 			</tr>
						 			<tr>
						 				<td class="label">
						 					<label for="tiempoEnvio">II.- ¿Cada cuándo le envia?:</label>
						 				</td>
						 				<td>
						 					<input type="text" id="tiempoEnvio" name="tiempoEnvio" size="20" tabindex="55" onblur="ponerMayusculas(tiempoEnvio)"/>
						 				</td>
						 				<td class="label">
						 					<label for="tiempoEnvio">¿Cuánto le envía?: </label>
						 				</td>
						 				<td>
						 					<input type="text" id="cuantoEnvio" name="cuantoEnvio" size="20" tabindex="56" esMoneda = "true"/>
						 				</td>
						 			</tr>
						 		</table>
						 	</div>
						</td>						
					</tr>
					<tr>
						<td>
							<input type="radio" id="tipoCambioTrab" name="fteNuevosIngresos" value="C" tabindex="57"/><label>c) Cambio de trabajo: </label>
							<div id="divCambioTrabajo" style="display: none;">
								<table>
									<tr>
										<td class="label">
						 					<label for="trabajoActual">¿En qué trabaja actualmente?: </label>
						 				</td>
						 				<td>
						 					<input type="text" id="trabajoActual" name="trabajoActual" size="40" tabindex="58" maxlength="100" onblur="ponerMayusculas(trabajoActual)"/>
						 				</td>
									</tr>
									<tr>
										<td class="label">
						 					<label for="lugarTrabajoAct">¿Dónde trabaja actualmente?: </label>
						 				</td>
						 				<td>
						 					<input type="text" id="lugarTrabajoAct" name="lugarTrabajoAct" size="40" tabindex="59" maxlength="100" onblur="ponerMayusculas(lugarTrabajoAct)"/>
						 				</td>
									</tr>
									<tr>
										<td class="label">
						 					<label for="cargoTrabajo">¿Qué cargo ocupa?: </label>
						 				</td>
						 				<td>
						 					<input type="text" id="cargoTrabajo" name="cargoTrabajo" size="40" tabindex="60" maxlength="100" onblur="ponerMayusculas(cargoTrabajo)"/>
						 				</td>
									</tr>
									<tr>
										<td class="label">
						 					<label for="periodoDePago">¿Cada Cuándo le pagan?: </label>
						 				</td>
						 				<td>
						 					<input type="text" id="periodoDePago" name="periodoDePago" size="20" tabindex="61" maxlength="100" onblur="ponerMayusculas(periodoDePago)"/>
						 				</td>
									</tr>
									<tr>
										<td class="label">
						 					<label for="montoPeriodoPago">¿Cuánto le pagan?: </label>
						 				</td>
						 				<td>
						 					<input type="text" id="montoPeriodoPago" name="montoPeriodoPago" size="20" tabindex="62" esMoneda="true"/>
						 				</td>
						 				<td class="label">
						 					<label for="tiempoLaborado">¿Tiempo que tiene laborando?: </label>
						 				</td>
						 				<td>
						 					<input type="text" id="tiempoLaborado" name="tiempoLaborado" size="20" tabindex="63" onblur="ponerMayusculas(tiempoLaborado)"/>
						 				</td>
									</tr>
									<tr>
										<td class="label">
											<label for="dependientesEconSA">¿Dependientes Económicos?:  </label>
										</td>
										<td>										
											<input type="text" id="dependientesEconSA" name="dependientesEconSA" size="40" tabindex="64"/>					
										</td>
										<td class="label">
											<label for="dependienteHijoSA">Hijos:  </label>
										</td>
										<td>															
											<input type="text" id="dependienteHijoSA" name="dependienteHijoSA" size="20" tabindex="65"/>					
										</td>
										<td class="label">
											<label for="dependienteOtroSA">Otro:  </label>
										</td>
										<td>															
											<input type="text" id="dependienteOtroSA" name="dependienteOtroSA" size="20" tabindex="66" onblur="ponerMayusculas(dependienteOtroSA)"/>					
										</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" id="tipoOtroNuevo" name="fteNuevosIngresos" value="O" tabindex="67"/><label>d) Otro: </label>
						</td>
					</tr>
				</table>
			</fieldset>		
		</div>
		<div id="divProveedoresRec" style="display: none;">
			<br>
			<FIELDSET class="ui-widget ui-widget-content ui-corner-all">			
				<legend>Proveedores de Recursos</legend>
				<table>
					<tr>
						<td class="label">
							<input type="radio" id="proveedRecursosP" name="proveedRecursos" value="P" tabindex="68"/>
							<label for="proveedRecursos">a) Proveedor de Recursos:</label>							
						</td>						
					</tr>
					<tr>					
						<td class="label" width="150px">
							<label for="lugarRecursos">¿De dónde proviene el recurso?: </label>
						</td>
						<td>
							<input type="radio" id="proveedPFisica" name="tipoProvRecursos" value="F" tabindex="69"/>
							<label>P. Fisica</label>
							<input type="radio" id="proveedPMoral" name="tipoProvRecursos" value="M" tabindex="70"/>							
							<label>P. Moral</label>							
						</td>
					</tr>
				</table>
				<div id="divApartadoA" style="display: none;">
					<table>
						<tr>
							<td class="label" width="150px">
								<label for="nombreCompProv">Nombre Completo: </label>
							</td>
							<td>
								<input type="text" id="nombreCompProv" name="nombreCompProv" size="50" tabindex="71" maxlength="100" onblur="ponerMayusculas(nombreCompProv)"/>
							</td>
							<td class="separador"/>
							<td class="label" >
								<label for="domicilioProv">Domicilio: </label>
							</td>
							<td>
							<textarea id="domicilioProv" name="domicilioProv" cols="24" rows="2" tabindex="72" maxlength="300" onblur="ponerMayusculas(domicilioProv)"></textarea>								
							</td>														
						</tr>
						<tr>
							<td class="label" >	
								<label for="fechaNacProv">Fecha de Nacimiento: </label>
							</td>
							<td>
								<input type="text" id="fechaNacProv" name="fechaNacProv" size="30" tabindex="73" esCalendario="true"/>
							</td>
							<td class="separador"/>
							<td class="label" >
								<label for="nacionalidProv">Nacionalidad: </label>
							</td>
							<td>
								<select id="nacionalidProv" name="nacionalidProv" tabindex="74">  
									<option value="">SELECCIONAR</option>
									<option value="N">MEXICANA</option>
									<option value="E">EXTRANJERA</option>
								</select>				
<!-- 								<input type="text" id="nacionalidProv" name="nacionalidProv" size="30" maxlength="100"  readOnly="true"/> -->
							</td>
						</tr>
						<tr>							
							<td class="label" >
								<label for="rfcProv">RFC: </label>
							</td>
							<td>
								<input type="text" id="rfcProv" name="rfcProv" size="25" tabindex="75" maxlength="18" onblur="ponerMayusculas(rfcProv)"/>
							</td>
						</tr>
					</table>
				</div>
				<div id="divApartadoB" style="display: none;">
					<table>
						<tr>
							<td class="label" width="150px">
								<label for="razonSocialProvB">Denominación o Razón Social: </label>
							</td>
							<td>
								<input type="text" id="razonSocialProvB" name="razonSocialProvB" size="50" tabindex="76" maxlength="100" onblur="ponerMayusculas(razonSocialProvB)"/>
							</td>
							<td class="separador"/>
							<td class="label">
								<label for="nacionalidProvB">Nacionalidad: </label>
							</td>
							<td>
								<select id="nacionalidProvB" name="nacionalidProvB" tabindex="77">  
									<option value="">SELECCIONAR</option>
									<option value="N">MEXICANA</option>
									<option value="E">EXTRANJERA</option>
								</select>	
<!-- 								<input type="text" id="nacionalidProvB" name="nacionalidProvB" size="30" tabindex="77" maxlength="100" onblur="ponerMayusculas(nacionalidProvB)"/> -->
							</td>					
						</tr>
						<tr>													
							<td class="label">
								<label for="rfcProvB">RFC: </label>
							</td>
							<td>
								<input type="text" id="rfcProvB" name="rfcProvB" size="25" tabindex="78" maxlength="18" onblur="ponerMayusculas(rfcProvB)"/>
							</td>
							<td class="separador"/>
							<td class="label">
								<label for="domicilioProvB">Domicilio: </label>
							</td>
							<td>
								<textarea id="domicilioProvB" name="domicilioProvB" cols="24" rows="2" tabindex="79" maxlength="300" onblur="ponerMayusculas(domicilioProvB)"></textarea>								
							</td>
						</tr>						
					</table>
				</div>
			</FIELDSET>
		</div>
		<div id="divPropietarioReal" style="display: none;">
			<br>
			<FIELDSET class="ui-widget ui-widget-content ui-corner-all">
				<legend>Propietario Real</legend>
				<table>
					<tr>
						<td class="label">
							<label for="propietarioDinero">1.- ¿Para Quién es el dinero?: </label>													
						</td>
						<td >
							<input type="radio" id="propietarioFam" name="propietarioDinero" value="F" tabindex="80"/><label>Familiar: </label>
							<input type="radio" id="propietarioOtro" name="propietarioDinero" value="O" tabindex="81"/><label>Otro: </label>													
						</td>						
						<td id="tdPropOtroDet" style="display: none;" colspan="2">
							<label for="propietarioOtroDet">Especifique: </label>
							<input type="text" id="propietarioOtroDet" name="propietarioOtroDet" size="20" tabindex="82" maxlength="100" onblur="ponerMayusculas(propietarioOtroDet)"/>
						</td>
					</tr>				
					<tr>
						<td class="label">
							<label for="propietarioNombreCom">2.- Nombre Completo del Propietario Real: </label>
						</td>
						<td colspan="2">
							<input type="text" id="propietarioNombreCom" name="propietarioNombreCom" size="50" tabindex="83" maxlength="45" onblur="ponerMayusculas(propietarioNombreCom)"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="propietarioDomici">3.- Domicilio del Propietario Real: </label>
						</td>
						<td colspan="2">
							<textarea id="propietarioDomici" name="propietarioDomici" tabindex="84" cols="30" rows="2" maxlength="300" onblur="ponerMayusculas(propietarioDomici)"></textarea>							
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="propietarioNacio">4.- Nacionalidad: </label>
						</td>
						<td>
							<select id="propietarioNacio" name="propietarioNacio" tabindex="85">  
									<option value="">SELECCIONAR</option>
									<option value="N">MEXICANA</option>
									<option value="E">EXTRANJERA</option>
							</select>
<!-- 							<input type="text" id="propietarioNacio" name="propietarioNacio" size="20" tabindex="85" maxlength="100" onblur="ponerMayusculas(propietarioNacio)"/> -->
						</td>
						<td class="label">
							<label for="propietarioCurp">CURP: </label>
						</td>
						<td>
							<input type="text" id="propietarioCurp" name="propietarioCurp" size="25" tabindex="86" maxlength="18" onblur="ponerMayusculas(propietarioCurp)"/>
						</td>
						<td class="label">
							<label for="propietarioRfc">RFC: </label>
						</td>
						<td>
							<input type="text" id="propietarioRfc" name="propietarioRfc" size="25" tabindex="87" maxlength="18" onblur="ponerMayusculas(propietarioRfc)"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="propietarioGener">5.- Género: </label>
						</td>
						<td>
							<select id="propietarioGener" name="propietarioGener" tabindex="88">  
									<option value="">SELECCIONAR</option>
									<option value="M">MASCULINO</option>
									<option value="F">FEMENINO</option>
							</select>
						</td>
						<td class="label">
							<label for="propietarioOcupac">Ocupación: </label>
						</td>
						<td colspan="2">
							<input type="text" id="propietarioOcupac" name="propietarioOcupac" size="40" tabindex="89" maxlength="100" onblur="ponerMayusculas(propietarioOcupac)"/>
						</td>						
					</tr>
					<tr>
						<td class="label">
							<label for="propietarioFecha">6.- Fecha de Nacimiento: </label>
						</td>
						<td>
							<input type="text" id="propietarioFecha" name="propietarioFecha" size="20" tabindex="90" esCalendario="true"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="propietarioLugarNac">7.- Lugar de Nacimiento: </label>
						</td>
						<td colspan="2">
							<input type="text" id="propietarioLugarNac" name="propietarioLugarNac" size="40" tabindex="91" maxlength="100" onblur="ponerMayusculas(propietarioLugarNac)"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="propietarioEntid">8.- Entidad Federativa de Nacimiento: </label>
						</td>
						<td>
							<input type="text" id="propietarioEntid" name="propietarioEntid" size="20" tabindex="92" maxlength="100" onblur="ponerMayusculas(propietarioEntid)"/>
						</td>
						<td class="label">
							<label for="propietarioPais">País: </label>
						</td>
						<td>
							<input type="text" id="propietarioPais" name="propietarioPais" size="20" tabindex="93" maxlength="100" onblur="ponerMayusculas(propietarioPais)"/>
						</td>
					</tr>
				</table>
			</FIELDSET>
		</div>
		<div id="divPersonasPEPS" style="display: none;">
			<br>
			<FIELDSET class="ui-widget ui-widget-content ui-corner-all">
				<LEGEND>Personas Políticamente Expuestas (PEP´S)</LEGEND>		
				<table>
					<tr>
						<td class="label">
							<label for="cargoPubPEP">¿Usted o algún familiar ha ocupado actualmente un cargo público?: </label>
						</td>
						<td>
							<input type="radio" id="cargoPubPEPSi" name="cargoPubPEP" value="O" tabindex="94"/><label>I) Si ocupo: </label>
							<input type="radio" id="cargoPubPEPSO" name="cargoPubPEP" value="A" tabindex="95"/><label>II) Si ocupaba: </label>
							<input type="radio" id="cargoPubPEPFa" name="cargoPubPEP" value="F" tabindex="96"/><label>III) Un familiar: </label>
							<input type="radio" id="cargoPubPEPNo" name="cargoPubPEP" value="N" checked tabindex="97"/><label>IV) No: </label>
						</td>
					</tr>
				</table>
				<div id="divApartadoAPEP" style="display: none;">
					<table>
						<tr>
							<td class="label" width="300px">
								<label for="cargoPubPEPDet">1.-¿Que cargo público ocupa(ba)?: </label>
							</td>
							<td>
								<input type="text" id="cargoPubPEPDet" name="cargoPubPEPDet" size="40" tabindex="98" maxlength="100" onblur="ponerMayusculas(cargoPubPEPDet)"/>	
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="nivelCargoPEP">2.- A nivel: </label>
							</td>
							<td>
								<input type="radio" id="nivelFederalPEP" name="nivelCargoPEP" value="F" tabindex="99"/><label>a) Federal</label>
								<input type="radio" id="nivelEstatalPEP" name="nivelCargoPEP" value="E" tabindex="100"/><label>b) Estatal</label>
								<input type="radio" id="nivelMunicipalPEP" name="nivelCargoPEP" value="M" tabindex="101"/><label>c) Municipal</label>									
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="periodo1PEP">3.- Periodo: </label>
							</td>
							<td>
								<input type="text" id="periodo1PEP" name="periodo1PEP" size="20" tabindex="102" onblur="ponerMayusculas(periodo1PEP)"/>
								<label>a</label>
								<input type="text" id="periodo2PEP" name="periodo2PEP" size="20" tabindex="103" onblur="ponerMayusculas(periodo2PEP)"/>
							</td>
						</tr>
						</tr>
							<td class="label">
								<label for="ingresosMenPEP">4.- ¿Ingresos Mensuales?: </label>
							</td>
							<td>
								<input type="text" id="ingresosMenPEP" name="ingresosMenPEP" size="20" tabindex="104" esMoneda="true"/>							
							</td>
						<tr>
						</tr>
							<td class="label">
								<label for="famEnCargoPEP">5.- ¿Tiene algún familiar que también ocupa u ocupaba algún cargo público?: </label>
							</td>
							<td>
								<input type="radio" id="famEnCargoPEPSi" name="famEnCargoPEP" value="S" tabindex="105"/><label>Si</label>
								<input type="radio" id="famEnCargoPEPNo" name="famEnCargoPEP" value="N" tabindex="106"/><label>No</label>							
							</td>
						<tr>
						</tr>
							<td class="label">
								<label for="parentescoPEP">6.- ¿Parentesco con el Familiar?: </label>
							</td>
							<td>
								<input type="radio" id="parentescoPEPPad" name="parentescoPEP" value="P" tabindex="107"/><label>a) Padre</label>
								<input type="radio" id="parentescoPEPMad" name="parentescoPEP" value="M" tabindex="108"/><label>b) Madre</label>
								<input type="radio" id="parentescoPEPHij" name="parentescoPEP" value="H" tabindex="109"/><label>c) Hijo</label>										
							</td>
						<tr>
						</tr>
							<td class="label">
								<label for="nombreCompletoPEP">7.- ¿Cuál es su nombre?: </label>
							</td>
							<td>
								<input type="text" id="nombreCompletoPEP" name="nombreCompletoPEP" size="50" tabindex="110" onblur="ponerMayusculas(nombreCompletoPEP)"/>
							</td>
						<tr>																
					</table>
				</div>
				<div id="divApartadoBPEP" style="display: none;">
					<table>
						<tr>
							<td class="label" width="300px">
								<label for="cargoPubPEPDetFam">1.-¿Que cargo público ocupa u ocupaba?: </label>
							</td>
							<td>
								<input type="text" id="cargoPubPEPDetFam" name="cargoPubPEPDetFam" size="40" tabindex="111" 
														maxlength="100" onblur="ponerMayusculas(cargoPubPEPDetFam)"/>	
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="nivelCargoPEPFam">2.- A nivel: </label>
							</td>
							<td>
								<input type="radio" id="nivelFederalPEPF" name="nivelCargoPEPFam" value="F" tabindex="112"/><label>a) Federal</label>
								<input type="radio" id="nivelEstatalPEPF" name="nivelCargoPEPFam" value="E" tabindex="113"/><label>b) Estatal</label>
								<input type="radio" id="nivelMunicipalPEPF" name="nivelCargoPEPFam" value="M" tabindex="114"/><label>c) Municipal</label>
							</td>
						</tr>	
						<tr>
							<td class="label">
								<label for="periodo1PEP">3.- Periodo: </label>
							</td>
							<td>
								<input type="text" id="periodo1PEPFam" name="periodo1PEPFam" size="20" tabindex="115" maxlength="50" onblur="ponerMayusculas(periodo1PEPFam)"/>
								<label>a</label>
								<input type="text" id="periodo2PEPFam" name="periodo2PEPFam" size="20" tabindex="116" maxlength="50" onblur="ponerMayusculas(periodo2PEPFam)"/>
							</td>
						</tr>
						</tr>
							<td class="label">
								<label for="parentescoPEPFam">4.- ¿Parentesco con el Familiar?: </label>
							</td>
							<td>
								<input type="radio" id="parentescoPEPFPad" name="parentescoPEPFam" class="clParentPEP" value="P" tabindex="117"/><label>a) Padre</label>
								<input type="radio" id="parentescoPEPFMad" name="parentescoPEPFam" class="clParentPEP" value="M" tabindex="118"/><label>b) Madre</label>
								<input type="radio" id="parentescoPEPFHij" name="parentescoPEPFam" class="clParentPEP"  value="H" tabindex="119"/><label>c) Hijo</label>
								<input type="radio" id="parentescoPEPFOtr" name="parentescoPEPFam"  value="O" tabindex="120"/><label>d) Otro</label>
								<input type="text" id="parentescoPEPDet" name="parentescoPEPDet" size="20" tabindex="121" style="display: none;" 
																				maxlength="100" onblur="ponerMayusculas(parentescoPEPDet)"/>
							</td>																						
						<tr>
						</tr>
							<td class="label">
								<label for="nombreCtoPEPFam">5.- ¿Cuál es su nombre?: </label>
							</td>
							<td>
								<input type="text" id="nombreCtoPEPFam" name="nombreCtoPEPFam" size="50" tabindex="122" maxlength="100" onblur="ponerMayusculas(nombreCtoPEPFam)"/>
							</td>
						<tr>
						</tr>
							<td class="label">
								<label for="relacionPEP">6.- ¿Tiene alguna relación con alguna asociacion u organización?: </label>
							</td>
							<td>
								<input type="radio" id="relacionPEPSi" name="relacionPEP" value="S" tabindex="123"/><label>Si</label>
								<input type="radio" id="relacionPEPNo" name="relacionPEP" value="N" tabindex="124"/><label>No</label>
							</td>
						<tr>
						</tr>
							<td class="label">
								<label for="nombreRelacionPEPFam">7.- ¿Como se llama?: </label>
							</td>
							<td>
								<input type="text" id="nombreRelacionPEP" name="nombreRelacionPEP" size="50" tabindex="125" maxlength="100" onblur="ponerMayusculas(nombreRelacionPEP)"/>
							</td>
						<tr>
					</table>
				</div>
			</FIELDSET>
		</div>
		<div id="divOtrosServicios" style="display: none;">
			<br>
			<FIELDSET class="ui-widget ui-widget-content ui-corner-all">
			<LEGEND>Otros Servicios</LEGEND>
			<table>
				<tr>
					<td class="label">
						<label for="ingresoAdici">1.- ¿Cuenta usted con algún ingreso adicional?: </label>						
					</td>
					<td>
						<input type="radio" id="ingresoAdiciSi" name="ingresoAdici" value="S" tabindex="126"/><label>a) Si</label>
						<input type="radio" id="ingresoAdiciNo" name="ingresoAdici" value="N" checked tabindex="127"/><label>b) No</label>
					</td>			
				</tr>
			</table>
			<div id="divOtrosServiciosSI" style="display: none;">
				<table>
					<tr>								
						<td class="label">
							<label for="fuenteIngreOS">2.- ¿Cuál es la fuente de ingreso?: </label>
						</td>
						<td>
							<input type="text" id="fuenteIngreOS" name="fuenteIngreOS" size="20" tabindex="128" maxlength="200" onblur="ponerMayusculas(fuenteIngreOS)"/>
						</td>																			
					</tr>
					<tr>
						<td class="label">
							<label for="UbicFteIngreOS">3.- ¿Cuál es la ubicación de la fuente de ingreso?: </label>
						</td>
						<td>
							<input type="text" id="UbicFteIngreOS" name="UbicFteIngreOS" size="20" tabindex="129" maxlength="300" onblur="ponerMayusculas(UbicFteIngreOS)"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="esPropioFteIng">4.- ¿Es propia?: </label>
						</td>
						<td>
							<input type="radio" id="esPropioFteIngSi" name="esPropioFteIng" value="S" tabindex="130"/><label>a) Si</label>
							<input type="radio" id="esPropioFteIngNo" name="esPropioFteIng" value="N" tabindex="131"/><label>b) No</label>
						</td>				
						<td class="label" id="tdEspecifiqlbl" style="display:none;">
							<label for="esPropioFteIng">Especifique: </label>
						</td>
						<td id="tdEsPropioDet" style="display:none;">
							<input type="text" id="esPropioFteDet" name="esPropioFteDet" size="20" tabindex="132" maxlength="100" onblur="ponerMayusculas(esPropioFteDet)"/>									
						</td>		
					</tr>															
					<tr>
						<td class="label">
							<label for="ingMensualesOS">5.- ¿Ingresos Mensuales?: </label>
						</td>
						<td>
							<input type="text" id="ingMensualesOS" name="ingMensualesOS" size="20" tabindex="133" esMoneda="true"/>
						</td>
					</tr>
				</table>
			</div>								
			</FIELDSET>
		</div>
		</fieldset>
		</div>
		</td>		
	</tr>
	<tr>		
		<td class="label" id="tdObservaciones" style="display:none;">
			<br>
			<label for="observacionesEjec">Observaciones del Ejecutivo: </label>
			<textarea id="observacionesEjec" name="observacionesEjec" cols="50" rows="3" tabindex="134" 
												onblur="ponerMayusculas(observacionesEjec)" maxlength="200"></textarea>
		</td>		
	</tr>
	</table>
	<table align="right" border='0'>
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" value="Agregar" class="submit" tabindex="135"/>
				<input type="submit" id="modifica" name="modifica" value="Modificar" class="submit" tabindex="136"/>				
				<a id="ligaGenerar" target="_blank" >
					<input type="button" id="imprimir" name="imprimir" value="Imprimir" class="submit" 
							tabindex="137" style="display: none; width:80px; height:30px" />
				</a>				
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>														
			</td>
		</tr>
	</table>
</form:form>
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
