<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>                  
    <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/socDemoConyugServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/serviFunFoliosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosCajaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clientesCancelaServicio.js"></script>
           
     <script type="text/javascript" src="js/cliente/serviFunFolios.js"></script>     
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="serviFunFolio">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Solicitud Servicios Funerarios (SERVIFUN)</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>			   
	     	<td class="label" >
	     		<label for="lblFolio">Folio: </label>         	
	     	</td>       
	     	<td class="label">
	        	<input  type="text" id="serviFunFolioID" name="serviFunFolioID" size="15"  tabindex="1" />	        	
	     	</td>    
			<td class="separador"></td>	
			<td class="label" nowrap="nowrap"><label for="lblEstatus">Estatus:</label></td>
			<td>
				<select id="estatus" name="estatus"   disabled="true">
					<option value=""></option>
					<option value="C">CAPTURADO</option>
				    <option value="R">RECHAZADO</option>
				    <option value="A">AUTORIZADO</option>
				    <option value="P">PAGADO</option>
			    </select>
			</td>	   		
		</tr>
		<tr>	
			<td class="label"><label for="lblSocio">
				Tipo Servicio:</label>
			</td>									
			<td nowrap="nowrap" colspan="4">
				<input id="tipoServicio1" name="tipoServicio1"  type="radio" value="C" tabindex="2"/>
				<label for="lblCliente">Fallecimiento de <s:message code="safilocale.cliente"/> &nbsp;</label>																							
				
				<input id="tipoServicio2" name="tipoServicio2" type="radio" value="F" tabindex="3"/>
				<label for="lblFamiliar">Fallecimiento Familiar <s:message code="safilocale.cliente"/></label>
				<input type="hidden" id="tipoServicio" name="tipoServicio" value="" tabindex="4"/>			
			</td>	     		      		     	
		</tr>
	</table>
	<br>
	<div id="divSocio"  width="100%">
 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend><s:message code="safilocale.cliente"/></legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label"><label for="clienteID"><s:message code="safilocale.cliente"/>:</label></td>
				<td><input type="text" id="clienteID" name="clienteID" size="15"  tabindex="5" />
					<input type="text" id="nombreCte" name="nombreCte" size="55"   readOnly="true" disabled="true" tabindex="6"/></td>						
			</tr>
<!-- 			<tr> -->
<!-- 				<td><input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td> -->
<!-- 				<td><input type ="button" id="buscarGeneral" name="buscarGeneral" value="Busqueda General" class="submit"/></td>		 -->
<!-- 			</tr>	 -->
			<tr>									
				<td class="label"><label for="fechaNacimiento">Fecha Nacimiento:</label></td>
				<td><input  type="text" id="fechaNacimiento" name="fechaNacimiento" size="15" readOnly="true" disabled="true" tabindex="7" />
				</td>
					<td class="separador"></td>
				<td class="label"><label for="rfc">RFC:</label></td>
				<td><input type="text" id="rfc" name="rfc"	size="30" readOnly="true" disabled="true" tabindex="8"/></td>
			</tr>	
			<tr>															  
		     	<td class="label" > <label for="tipoPersona">Tipo de Persona: </label> </td>			
		     	<td> 
		        	<input  type="text" id="tipoPersona" name="tipoPersona" size="40" readOnly="true" disabled="true" tabindex="9" />	        	
		     	</td> 	
				<td class="separador"></td>
				<td class="label" > <label for="curp">CURP:</label> </td>			
		     	<td> 
		        	<input  type="text" id="curp" name="curp" size="30"    readOnly="true" disabled="true" tabindex="10"/>	        	
		     	</td> 						
		     
			</tr>	
			<tr>					
		     	<td class="label" > <label for="fechaIngreso">Fecha Ingreso: </label> </td>			
		     	<td> 
		        	<input  type="text" id="fechaIngreso" name="fechaIngreso" size="20"  readOnly="true" disabled="true" tabindex="11" />	        	
		     	</td> 			
		     	<td class="separador"></td>
		     		<td class="label" > <label for="edadIngreso">Edad al Ingreso: </label> </td>			
		     	<td> 
		        	<input  type="text" id="edadIngreso" name="edadIngreso" size="13"  readOnly="true" disabled="true"   tabindex="12" />	        	
		     	</td> 	
			</tr>																									
		</table>						
	 </fieldset>
	</div>
	
	<div id="conyuge" style="display:none"  >
 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Datos del C&oacute;nyuge</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label" nowrap="nowrap"><label for="lblClienteIDCon"><s:message code="safilocale.cliente"/>:</label></td>
				<td colspan="2">
					<input type="text" id="clienteIDConyuge" name="clienteIDConyuge" size="15"   readOnly="true" disabled="true"  tabindex="13"/>							
					<input type="text" id="nombreCteConyuge" name="nombreCteConyuge" size="40"   readOnly="true" disabled="true" tabindex="14" />
				</td>
			</tr>	
			<tr>									
				<td class="label" nowrap="nowrap"><label for="lblFechaNacimientoConyuge">Fecha Nacimiento:</label></td>
				<td>
					<input  type="text" id="fechaNacimientoConyuge" name="fechaNacimientoConyuge" size="20"	readOnly="true" disabled="true" 
						tabindex="15" />
				</td>
				<td class="separador"></td>
				<td class="label"  nowrap="nowrap">
					<label for="lblefc">RFC:</label></td>
				<td>
					<input type="text" id="RFCConyuge" name="RFCConyuge" rows="3" cols="50" readOnly="true" disabled="true"  tabindex="16"/></td>
			</tr>											
		</table>						
	 </fieldset>
	</div>

	<div id="tramite" style="display:none">
 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Familiar que Realiza el Trámite</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="lblSocioFamiliar"><s:message code="safilocale.cliente"/>:</label>
				</td>
				<td>
					<input type="text" id="tramClienteID" name="tramClienteID" size="15"  tabindex="17" />							
				</td>					
			</tr>	
			<tr>	
				<td class="label" nowrap="nowrap">
					<label for="lblPrimerNombre">Primer Nombre:</label></td>
				<td>
					<input type="text" id="tramPrimerNombre" name="tramPrimerNombre" size="30" 	onblur="ponerMayusculas(this)" 
						readOnly="true" disabled="true" tabindex="18" maxlength="200"/></td>											
				<td class="separador"></td>																		
				<td class="label" nowrap="nowrap"><label for="lblSegundoNombre">Segundo Nombre:</label></td>
				<td><input type="text" id="tramSegundoNombre" name="tramSegundoNombre" size="30" 	onblur="ponerMayusculas(this)"
						readOnly="true" disabled="true" tabindex="19" maxlength="200"/></td>							
			</tr>
			<tr>	
				<td class="label" nowrap="nowrap"><label for="lblTercerNombre">Tercer Nombre:</label></td>
				<td><input type="text" id="tramTercerNombre" name="tramTercerNombre" size="30"  onblur="ponerMayusculas(this)" 
						readOnly="true" disabled="true" tabindex="20" maxlength="200"/></td>											
				<td class="separador" ></td>																		
				<td class="label" nowrap="nowrap"><label for="lblApellidoPaterno">Apellido Paterno:</label></td>
				<td><input type="text" id="tramApePaterno" name="tramApePaterno" size="30"	onblur="ponerMayusculas(this)"
						readOnly="true" disabled="true" tabindex="21" maxlength="200" /></td>							
			</tr>
			<tr>	
				<td class="label" nowrap="nowrap"><label for="lblApMater">Apellido Materno:</label></td>
				<td><input type="text" id="tramApeMaterno" name="tramApeMaterno" size="30"	onblur="ponerMayusculas(this)" 
						readOnly="true" disabled="true" tabindex="22" maxlength="200" /></td>								
				<td class="separador"></td>		
				<td class="label" nowrap="nowrap"><label for="lblFechaNacimientoFamiliar">Fecha Nacimiento:</label></td>
				<td><input  type="text" id="tramFechaNacim" name="tramFechaNacim" size="20"	esCalendario="true" onblur="ponerMayusculas(this)"
						readOnly="true" disabled="true" tabindex="23" />
				</td>			
			</tr>			
			<tr>									
				<td class="label" nowrap="nowrap"><label for="lblParentescoFam">Parentesco:</label></td>
				<td colspan="2" ><input  type="text" id="tramParentesco" name="tramParentesco" size="10"	 tabindex="24" />
					<input  type="text" id="descParentescoTram" name="descParentescoTram" readOnly="true" disabled="true" size="40"
							tabindex="25"	 />
				</td>		
			</tr>																								
		</table>						
	 </fieldset>
	</div>

	<div id="difunto" style="display:none">
 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Datos de Difunto</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label" nowrap="nowrap"><label for="lblSocioDif"><s:message code="safilocale.cliente"/>:</label></td>
				<td>
					<input type="text" id="difunClienteID" name="difunClienteID" size="15"  tabindex="26" />
				</td>						
			</tr>	
			<tr>
				<td class="label" nowrap="nowrap"><label for="lblSocioDif">Primer Nombre:</label></td>
				<td>
					<input type="text" id="difunPrimerNombre" name="difunPrimerNombre" size="20"  	onblur="ponerMayusculas(this)" 
						readOnly="true" disabled="true" tabindex="27" maxlength="200"/>
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap"><label for="lblFechaNacimientoDif">Segundo Nombre:</label></td>
				<td><input type="text" id="difunSegundoNombre" name="difunSegundoNombre" size="20" 	onblur="ponerMayusculas(this)" 
					readOnly="true" disabled="true" tabindex="28" maxlength="200"/>
				</td>								
			</tr>	
			<tr>
				<td class="label" nowrap="nowrap"><label for="lblSocioDif">Tercer Nombre:</label></td>
				<td>														
					<input type="text" id="difunTercerNombre" name="difunTercerNombre" size="20" 	onblur="ponerMayusculas(this)" 
						readOnly="true" disabled="true" tabindex="29" maxlength="200"/>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap"><label for="lblFechaNacimientoDif">Apellido Paterno:</label></td>
				<td><input type="text" id="difunApePaterno" name="difunApePaterno" size="20" 	onblur="ponerMayusculas(this)"
					readOnly="true" disabled="true" tabindex="30"maxlength="200"/>
				</td>								
			</tr>
			<tr>
				<td class="label" nowrap="nowrap"><label for="lblSocioDif">Apellido Materno:</label></td>																		
				<td><input type="text" id="difunApeMaterno" name="difunApeMaterno" size="20" 	onblur="ponerMayusculas(this)" 
					readOnly="true" disabled="true" tabindex="31" maxlength="200"/></td>		
				<td class="separador"></td>
				<td class="label" nowrap="nowrap"><label for="lblFechaNacimientoDif">Fecha Nacimiento:</label></td>
				<td><input  type="text" id="difunFechaNacim" name="difunFechaNacim" size="20"	readOnly="true" disabled="true"
					 esCalendario="true" tabindex="32" />
				</td>							
			</tr>
			<tr>									
				<td class="label" nowrap="nowrap"><label for="difunParentesco">Parentesco:</label></td>
				<td colspan="2">
					<input  type="text" id="difunParentesco" name="difunParentesco" size="10"	 tabindex="33" />
					<input  type="text" id="descParentescoDif" name="descParentescoDif" size="40"	readOnly="true" disabled="true" 
						tabindex="34" />
				</td>			
			</tr>																				
		</table>						
	 </fieldset>
	</div>

	<div id="certificado" style="display:none">
 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Certificado de Defunción</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label" nowrap="nowrap"><label for="noCertificadoDefun">Acta de Defunci&oacute;n:</label></td>
				<td>
					<input type="text" id="noCertificadoDefun" name="noCertificadoDefun" size="40"  tabindex="35" disabled="disabled" readonly="readonly"
						maxlength="100" />
				</td>	
				<td class="separador"></td>
				<td class="label" nowrap="nowrap"><label for="lblFechaNacimientoDif">Fecha de Defunci&oacute;n:</label></td>
				<td>
					<input  type="text" id="fechaCertiDefun" name="fechaCertiDefun" size="20" disabled="disabled" readonly="readonly" esCalendario="true" tabindex="36" />
				</td>																
			</tr>							
			<tr>									
				<td colspan="5">							
					<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fielSetArchivosCliente" style="display: none;">
						<legend>Archivos Cliente</legend>								
							<div id="gridArchivos" style="display: none;"></div>																																					
					 </fieldset>							
				</td>		
			</tr>
			<tr>
				<td style="text-align: right;" colspan="5">
					<input type="button" id="adjuntar" name="adjuntar" class="submit" value="Adjuntar" tabindex="37"/>
				</td>
			</tr>																																						
		</table>						
	 </fieldset>
	</div>			

	<div id="autorizarDiv" style="display:none">
 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Autorizar</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					<input  type="radio" id="autorizar" name="proceso"  value="A"  tabindex="38"/>
					<label for="autorizar">Autorizar</label>
					<input type="radio"  id="rechazar" name="proceso" value="R" tabindex="39"/>
					<label for="rechazar">Rechazar</label>																								
				</td>
				<td class="separador"></td>	
				<td class="label" nowrap="nowrap" id="lblMotivoRechazo" style="display:none">
					<label for="motivoRechazo">Motivo de Rechazo:</label></td>
				<td><textarea style="display:none"  id="motivoRechazo" name="motivoRechazo" maxlength="400"
					rows="2" cols="50" 	onblur="ponerMayusculas(this)"  tabindex="40" /></textarea></td>
										
			</tr>	
			<tr>
				<td align="right"  colspan="10">
					<input type="submit"  id="grabar" name="grabar" class="submit" value="Grabar"  tabindex="41"/>																			
					
				</td>
			</tr>
																																							
		</table>						
	</fieldset>
	</div>
	
	<div id="imagenCte" style="display: none;">
	 	<img id= "imgCliente" SRC="images/user.jpg" WIDTH="100%" HEIGHT="100%" border ="0" alt="Foto cliente"/> 
	</div> 
	
	<a id="enlaceTicket" target="_blank"> </a>
	
	<table style="width: 100%;">
		<tr>
			<td align="right">
				<input type="submit"   id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="42"/>						
				<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="441"/>							
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="prospectoID" name="prospectoID" value="0"/>	
				<input type="hidden" id="usuarioAutoriza" name="usuarioAutoriza" value="0"/>	
				<input type="hidden" id="usuarioRechaza" name="usuarioRechaza" value="0"/>	
				<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>
			</td>
		</tr>
	</table>
</fieldset>				
</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>