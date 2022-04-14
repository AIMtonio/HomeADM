<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
<head>

<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
<script type="text/javascript" src="dwr/interface/rolesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/perfilesAnalistasCreServicio.js"></script>
<script type="text/javascript" src="js/credito/perfilesAnalistasCre.js"></script>
</head>
<c:set var="tipoCatalogo" value="${tipoCatalogo}" />
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="perfilesAnalistasCreBean" >
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metro de An&aacute;lisis de Cr&eacute;dito </legend>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Generales</legend>
	 <table >
		<tr>
			<td class="label">
			   <label for="lblPerfilesAnalistasCre">Perf&iacute;l Edici&oacute;n Expediente:</label> 
			</td> 
				<td nowrap="nowrap">

				<input type="text" id="perfilExpediente"  tabindex="1"  name="perfilExpediente" size="5" maxlength="5" onblur="consultaRoles(this.id,'perfilExpedienteID')" value="${perfilExp}"   onkeypress="listaRoles(this.id)"  />
				</td>
			<td> 
			   <input type="text" id="perfilExpedienteID" name="perfilExpedienteID" size="55" disabled="true " />         	  
			</td>	
			<td class="separador"></td>
	
	    </tr>
 		
 	  </table>
	</fieldset>
	  <table border="0" width="100%">
					<tr>
					<c:choose>
					 <tr>
						<c:when test="${tipoCatalogo == '2'}">
						<td colspan="5" valign="top">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend >Perfiles de An&aacute;listas de Cr&eacute;dito </legend>
								<table >
									<tr>
										<td class="label">
										    <label for="lblPerfilesAnalistasCre">Perfil:</label> 
										</td> 
										<td nowrap="nowrap">

										<input type="text" id="perfilIDAnalista" tabindex="2" name="perfilID" size="5" maxlength="5" onblur="consultaRoles(this.id,'nombreRolAnalista')" onkeypress="listaRoles(this.id)"  />
										</td>
										<td> 
											<input type="text" id="nombreRolAnalista" name="nombreRol" size="35"  disabled="true"/>         	  
										</td>	
										<td>
										  <input type="button" onclick="agregarDetalle('tbParamAnalistas')"   class="submit" value="Agregar" id="agregarAnalistas" tabindex="300"/>
										</td>
									</tr>

								</table>
								<div id="gridAnalistas"></div>
						
							</fieldset>
						</td>
						</c:when>
					  </tr>
					  <tr>
						<c:when test="${tipoCatalogo == '1'}">
						<td colspan="5" valign="top">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend >Perfiles de Ejecutivos de Cuenta</legend>
								<table >
									<tr>
										<td class="label">
										    <label for="lblPerfilesAnalistasCre">Perfil:</label> 
										</td> 
										<td nowrap="nowrap">

										<input type="text" id="perfilIDEjecutivo"   tabindex="3"  name="perfilID" size="5" maxlength="5" onblur="consultaRoles(this.id,'nombreRolEjecutivo')" onkeypress="listaRoles(this.id)" onchange="verificaSeleccionado(this.id)" />
										</td>
										<td> 
											<input type="text" id="nombreRolEjecutivo" name="nombreRol" size="35" tabindex="199" disabled="true"/>         	  
										</td>	
										<td>
											<input type="button" onclick="agregarDetalle('tbParamEjecutivos')" class="submit" value="Agregar" id="agregarEjecutivos" tabindex="200"/>
										</td>
									</tr>

								</table>
								<div id="gridEjecutivos"></div>
						
							</fieldset>
						</td>
						</c:when>
				       </tr>
						</c:choose>
					</tr>
					<table style="margin-left:auto;margin-right:0px">
							<tr>
								<td>
									<input type="button" class="submit" value="Grabar" id="grabarAE" tabindex="4 " />
								</td>
							</tr>
				    	</table>
					<tr>
						<td>
							<input id="detalleEjecutivos" type="hidden" name="detalleEjecutivos" />
							<input id="detalleAnalistas" type="hidden" name="detalleAnalistas" />
							<input id="tipoTransaccion" type="hidden" name="tipoTransaccion" />
							<input id="tipoPerfil" type="hidden"   name="tipoPerfil" />
						</td>
					</tr>
				</table>
			
	</fieldset>		
					
</form:form> 
</div> 

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje"  style='display: none;'></div>
</html>