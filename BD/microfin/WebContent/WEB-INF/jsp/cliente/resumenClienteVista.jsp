<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<link href="css/redmond/jquery-ui-1.8.16.custom.css" media="all"  rel="stylesheet" type="text/css">
		<script type="text/javascript" src="js/jquery-ui-1.8.16.custom.min.js"></script>
		<script type='text/javascript' src='js/jquery.ui.tabs.js'></script>

		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
     	<script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/ocupacionesServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/gruposEmpServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoSociedadServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clientesPROFUNServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>

		<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
  		<script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>

  		<script type="text/javascript" src="js/cliente/resumenCte.js"></script>
  		<script type="text/javascript" src="js/soporte/mascara.js"></script>

  		<script>
			$(function() {
				$("#tabs" ).tabs();
			});
		 	$(function() {
        		$('#imagenCte a').lightBox();
		 	});
   		</script>
	</head>
<body>
		<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Resumen <s:message code="safilocale.cliente"/></legend>

			<table border="0"  width="100%" >
					<tr>
						<td>
							<div id="imagenCte">
								<a href="images/user.jpg"  id="imagen">
									<img id="imgCliente" SRC="images/user.jpg" WIDTH=90 HEIGHT=90 BORDER=0 ALT="Foto cliente"/>
								</a>
							</div>
				      	</td>
				    	<td>
				       		<font face="verdana" color="black" size="4">
				       			<b><div id="nom"></div></b>
				       		</font>
				    	</td>
					</tr>
				</table>

				<div id="tabs">
						<ul>
							<li><a id="perfilCte" href="#perfil" >Perfil</a></li>
							<li><a id="productosCte" href="#productos" >Productos </a></li>
							<li><a id="direccionesCte" href="#direcciones" >Direcciones</a></li>
						</ul>
						<div id="productos">
							<div id="gridAhoCte"></div>
							<br>
							<div id="gridInvCte"></div>
							<br>
							<div id="gridCredCte"></div>
							<br>
							<div id="gridCreditosAvalados"></div>
							<br>
							<div id="gridMisAvales"></div>
							<br>
							<div id="gridCedeCte"></div>
							<br>
							<div id="gridAportaciones"></div>
						</div>

						<div id="direcciones"></div>

						<div id="perfil" class="tab_content"  >
								<form:form id="formaGenerica" name="formaGenerica"  commandName="cliente">
									<fieldset class="ui-widget ui-widget-content ui-corner-all" >
									<legend >General</legend>
										<table border="0" width="100%">
											<tr id ="tarjetaIdentiCA">
												<td class="label"><label for="IdentificaSocio">N&uacute;mero Tarjeta:</label>
												<td nowrap="nowrap">
													<input id="numeroTarjeta" name="numeroTarjeta" size="20" tabindex="1" type="text" />
													<input id="idCtePorTarjeta" name="idCtePorTarjeta" size="20" type="hidden" />
													<input id="nomTarjetaHabiente" name="nomTarjetaHabiente" size="20" type="hidden" />
												</td>
											</tr>
											<tr>
									      		<td class="label">
									         		<label for="lblclienteID">No. de <s:message code="safilocale.cliente"/>: </label>
									     		</td>
									     		<td>
									         		<input type="text" id="numero" name="numero" size="15" tabindex="2" />
									      		</td>
									 		</tr>
									 		<tr>
									      		<td class="label">
									         		<label for="lbltipoPersona">Tipo de Persona: </label>
												</td>
									     		<td>
									         		<input type="text" id="tipoPersona" name="tipoPersona" size="20" tabindex="3" readOnly="true"/>
									     		</td>
										 	</tr>
											<tr>
									      		<td class="label">
									         		<label for="lblpromotorActual">Promotor: </label>
									     		</td>
									     		<td>
									         		<input type="text" id="promotorActual" name="promotorActual"  size="50" tabindex="3" readOnly="true"/>
									     		</td>
										 	</tr>
									    	<tr>
										    	<td class="label">
										        	<label for="lblsucursal">Sucursal: </label>
										     	</td>
										     	<td>
										        	<input type="text" id="sucursalOrigen" name="sucursalOrigen"  size="30" readOnly="true" tabindex="4" />
										     	</td>
									     	</tr>
									     	<tr>
										    	<td class="label">
										        	<label for="lblfechaAlta">Fecha de Alta: </label>
										     	</td>
										     	<td>
										        	<input type="text" id="fechaAlta" name="fechaAlta"  size="15" readOnly="true" tabindex="5" />
										     	</td>
									     	</tr>
									     	<tr>
						     					<td id="lblAdeudoProfun" class="label" style="display: none;">
							         				<label for="lbladeudoPROFUN1">Adeudo PROFUN: </label>
							     				</td>
							     				<td id='tdadeudoPROFUN'style="display: none;">
							         				<input type="text" id="adeudoPROFUN"  size="15" readOnly="true" esMoneda="true" style="text-align: right"  />
							     				</td>
						     				</tr>
										</table>
									</fieldset>
									<div id="personaMoral" style="display:none" >
										<table>
											<tr>
						     					<td class="label">
							         				<label for="lblsociedad">Sociedad: </label>
							     				</td>
							     				<td>
							         				<input type="text" id="tipoSociedadID" name="tipoSociedadID"  size="50" readOnly="true" tabindex="6" />
							     				</td>
						     				</tr>
											<tr>
									     		<td class="label">
										        	<label for="lblgrupoEmp">GrupoEmpresarial: </label>
										     	</td>
										     	<td>
										        	<input type="text" id="grupoEmpresarial" name="grupoEmpresarial"  size="50" readOnly="true" tabindex="7" />
										     	</td>
						     				</tr>
						    			</table>
						    		</div>  <!-- PERSONA MORAL-->


						    <br>

							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend >Informaci&oacute;n Personal del <s:message code="safilocale.cliente"/> o Representante Legal</legend>
								<table border="0"  width="100%">
									<tr>
							      		<td class="label">
							         		<label for="lblgenero">G&eacute;nero: </label>
							     		</td>
							     		<td>
							         		<input type="text" id="sexo" name="sexo" size="25" tabindex="8" readOnly="true" />
							      		</td>
							     	</tr>
							     	<tr>
							      		<td class="label">
							         		<label for="lblfechaNac">Fecha de Nacimiento: </label>
							     		</td>
							     		<td>
							         		<input id="fechaNacimiento" name="fechaNacimiento" size="25" readOnly="true"/>
							      		</td>
							     	</tr>
							     	<tr>
							      		<td class="label">
							         		<label for="lblnacionalidad">Nacionalidad: </label>
							     		</td>
							     		<td>
							         		<input id="nacion" name="nacion" size="25" readOnly="true"/>
							      		</td>
							     	</tr>
							    	<tr>
							      		<td class="label">
							         		<label for="lblestadoCiv">Estado Civil: </label>
							     		</td>
							     		<td>
							         		<input id="estadoCivil" name="estadoCivil" size="25" readOnly="true"/>
							      		</td>
							     	</tr>
							     	<tr>
							      		<td class="label">
							         		<label for="lbltelefono">Tel&eacute;fono: </label>
							     		</td>
							     		<td>
							         		<input id="telefonoCasa" name="telefonoCasa" size="15" readOnly="true" />
							      		</td>
							     	</tr>
							     	<tr>
							     		<td class="label">
							         		<label for="lblcorreo">Correo Electr&oacute;nico: </label>
							     		</td>
							     		<td>
							         		<input id="correo" name="correo" size="35" readOnly="true"/>
							      		</td>
							     	</tr>
								</table>
							</fieldset>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend >Informaci&oacute;n Econ&oacute;mica</legend>
									<table border="0" width="100%">
										<tr>
								      		<td class="label">
												<label for="lblactividad">Actividad BMX:</label>
											</td>
											<td>
												<input id="actividadBancoMX" name="actividadBancoMX" size="95"  readOnly="true"/>
											</td>
								     	</tr>
								     	<tr>
											<td class="label">
												<label for="lblactividadINEGI">Actividad INEGI</label>
											</td>
											<td>
												<input id="actividadINEGI" name="actividadINEGI" size="60" readOnly="true"/>
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblsector">Sector Economico</label>
											</td>
											<td>
												<input id="sectorEconomico" name="sectorEconomico" size="60" readOnly="true"/>
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblocupacion">Ocupaci&oacute;n</label>
											</td>
											<td>
												<input id="ocupacionID" name="ocupacionID" size="35"readOnly="true"/>
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="lblpuesto">Puesto</label>
											</td>
											<td>
												<input id="puesto" name="puesto" size="35"readOnly="true"/>
											</td>
										</tr>
									</table>
							</fieldset>

						</form:form>

				   </div>   <!-- PERFIL -->

			</div> <!-- TABS -->
			</fieldset>
		</div> <!-- contenedorForma -->

<div id="cargando" style="display: none;"></div>
<div id="cajaListaContenedor" style="display: none;">
	<div id="elementoListaContenedor"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>