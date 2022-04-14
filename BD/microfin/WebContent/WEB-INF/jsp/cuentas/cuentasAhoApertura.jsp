<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
	   <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
 	   <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
 	   <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
 	   <script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>   
       <script type="text/javascript" src="dwr/interface/conocimientoCteServicio.js"></script>     
	   <script type="text/javascript" src="dwr/interface/conocimientoCtaServicio.js"></script> 
       <script type="text/javascript" src="dwr/interface/cuentasPersonaServicio.js"></script>
       <script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
       <script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script> 
      <script type="text/javascript" src="js/cuentas/cuentaAhoApertura.js"></script>     
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasAhoBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Apertura de <s:message code="safilocale.ctaAhorro"/></legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label"> 
		    	<label for="lblCuentaAhoID">Cuenta: </label> 
			</td>
			<td>
				<form:input type="text" id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="15" tabindex="1"/>  
			</td>
			<td class="separador"></td> 
			<td class="label"> 
		    	<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
		   	</td> 
		    <td> 
		     	<form:input id="clienteID" name="clienteID" path="clienteID" size="11"  readOnly="true" tabindex="2"/>
		        <input id="nombreCte" name="nombreCte"size="50" type="text" readOnly="true" disabled="true"/>
		  	</td>
		</tr>
		<tr> 
			<td class="label"> 
		    	<label for="lblFecha">Fecha:</label> 
			</td> 		     		
		    <td>
		    	<form:input id="fechaApertura" name="fechaApertura" path="fechaApertura" readOnly="true" disabled="true" size="15" tabindex="3"/> 
		   	</td> 	
		    <td class="separador"></td> 
		   	<td class="label"> 
		    	<label for="lblusuarioApeID">Usuario Autoriza: </label> 
			</td> 
		    <td> 
		    	<form:input id="usuarioApeID" name="usuarioApeID" path="usuarioApeID" size="7" tabindex="4" readOnly="true" iniForma = "false"/>
				<input id="nombreUsuario" name="nombreUsuario"size="40" type="text" readOnly="true" disabled="true" iniForma = "false"/>
			</td>
		</tr> 
		<tr> 
			<td class="label"> 
				<label for="lblEstatus">Estatus: </label> 
			</td>   	
			<td> 
				<input id="estatus" name="estatus" path="estatus" size="15" tabindex="5" type="text" readOnly="true" disabled="true"/>
			</td>
			<td> 
		   		<input id="tipoPersona" name="tipoPersona" size="12"  iniForma = "false" tabindex="6" type="text" style="display: none;" /> 
			</td>
		</tr> 
		<tr>
			<td colspan="5">
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="activa" name="activa" class="submit" value="Activar" tabindex="7"  />
							<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>			
							<input type="hidden" id="varSafilocale" name="varSafilocale" value="<s:message code="safilocale.ctaAhorro"/>"/>	
							<input type="hidden" id="estatusDepositoActiva" name="estatusDepositoActiva" />	
						</td>
						<td>
							<a id="ligaPDF" target="_blank" tabindex="9">
					        	<button type="button" class="submit" id="PDF">
					              Imprimir Contrato
					            </button> 
							</a>
				           	<a id="ligaPDF2"  target="_blank" tabindex="11">
					        	<button type="button" class="submit" id="anexoPDF">
					            	Anexo Apoderados
					            </button> 
				           	</a>
				           	<a id="ligaPDF3"  target="_blank" tabindex="12">
					        	<button type="button" class="submit" id="formatoDecCte">
					            	Formato de Declaraci&oacute;n
					            </button> 
				           	</a>
						</td> 
					</tr>
				</table>		
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
</body>
<div id="mensaje" style="display: none;"></div>
</html>