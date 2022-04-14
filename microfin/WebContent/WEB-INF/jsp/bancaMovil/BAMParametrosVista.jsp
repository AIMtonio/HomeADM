<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

<head>
	<script type="text/javascript"src="dwr/interface/bamParametrosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	 <script type="text/javascript" src="dwr/interface/banTiposCuentaServicio.js"></script>	
	<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
	<script type="text/javascript" src="js/bancaMovil/parametrosCatalogo.js"></script>
</head>

<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" pcommandName="parametrosSisBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros Banca M&oacute;vil</legend>
	
	<input type="hidden" id="empresaID" name="empresaID"  size="70"  tabindex="16"/>	
	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>General</legend>	
	<table>
	
		<tr>
			<td class="label"> 
	    		<label for="nombreCortoInsitucion">Nombre Institucion: </label> 
	   		 </td> 
	   		 <td>
	     		<input type="text" id="nombreCortoInsitucion" name="nombreCortoInsitucion" path="nombreCortoInsitucion" size="30"  maxlength="20" tabindex="1"/>		     
	  		</td>
	  		
	  		<td class="separador"></td> 
	  		
	  		<td class="label"> 
	    		<label for="remitente">Remitente Notificaciones: </label> 
	   		 </td> 
	   		 <td>
				<input type="text" id="remitente" name="remitente" path="remitente" size="70"  maxlength="200" tabindex="2"/>		     
			 </td>
			
		</tr>
		
		<tr>
			<td class="label"> 
	    		<label for="minimoCaracteresPin">Minimo de caracteres para contraseña: </label> 
	   		 </td> 
	   		 <td>
				<input type="text" id="minimoCaracteresPin" name="minimoCaracteresPin" path="minimoCaracteresPin" size="30"  maxlength="10" tabindex="3"/>
			 </td>
		</tr>
		
	</table>
	</fieldset>
	
	<br>
	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>SMS</legend>	
	<table>
		<tr>
			<td class="label"> 
		    	<label for="tiempoValidoSMS">Tiempo de validez SMS (min): </label> 
		  	 </td> 
		    <td>
		     	<input type="text" id="tiempoValidoSMS" name="tiempoValidoSMS" size="30" tabindex="4" maxlength="45"/>
		    </td>
		    
			 <td class="separador"></td> 
			 
			 <td class="label"> 
		    	<label for="textoActivacionSMS">Mensaje código activación: </label> 
		   	 </td> 
		    <td>
		    <input type="text" id="textoActivacionSMS" name="textoActivacionSMS"  size="70"  tabindex="5" maxlength="200"/>	
		  		
		</tr>
		
	</table>
	</fieldset>
	
	<br>
	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Rutas de Acceso</legend>	
	<table>
	
		<tr>
			<td class="label"> 
		    	<label for="rutaArchivos">Archivos: </label> 
		   	 </td> 
		    <td>
		     	<input type="text" id="rutaArchivos" name="rutaArchivos" path="rutaArchivos" size="70"  tabindex="6"/>		     
		  	</td>
		    
		</tr>
		
	</table>
	</fieldset>
	
	<br>
	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>SPEI</legend>	
	<table>
	
		<tr>
			<td class="label"> 
		    	<label for="ivaPagarSpei">Iva a pagar: </label> 
		   	 </td> 
		    <td>
		     	<input type="text" id="ivaPagarSpei" name="ivaPagarSpei" path="ivaPagarSpei" size="30"  tabindex="8"/>		     
		  	</td>
		  	
		  	<td class="separador"></td> 
		  	
		  	<td class="label"> 
		    	<label for="usuarioSpei">Usuario envio SPEI: </label> 
		   	 </td> 
		    <td>
		     	<input type="text" id="usuarioSpei" name="usuarioSpei"  size="40"  tabindex="9"/>		     
		  	</td>
		</tr>
		
	</table>
	</fieldset>
	
	<br>
	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Notificaciones</legend>	
	<table>		
		<tr>
			<td class="label"> 
		    	<label for="textoNotifNuevoUsuario">Asunto para nuevos usuarios: </label> 
		   	 </td> 
		    <td>
		     	<input type="text" id="textoNotifNuevoUsuario" name="textoNotifNuevoUsuario"  size="70"  tabindex="10"/>		     
		  	</td>
		  	
		  	<td class="separador"></td> 
		  	
		  	<td class="label"> 
		    	<label for="textoNotifiCambioSeg">Asunto para cambios en las opciones de seguridad: </label> 
		   	 </td> 
		    <td>
		     	<input type="text" id="textoNotifiCambioSeg" name="textoNotifiCambioSeg"  size="70"  tabindex="11"/>		     
		  	</td>
		</tr>
		<tr>
			<td class="label"> 
		    	<label for="textoNotifPagos">Asunto para Pagos: </label> 
		   	 </td> 
		    <td>
		     	<input type="text" id="textoNotifPagos" name="textoNotifPagos"  size="70"  tabindex="12"/>		     
		  	</td>
		  	
		  	<td class="separador"></td> 
		  	
		  	<td class="label"> 
		    	<label for="textoNotifSesion">Asunto para inicio de sesión: </label> 
		   	 </td> 
		    <td>
		     	<input type="text" id="textoNotifSesion" name="textoNotifSesion"  size="70"  tabindex="13"/>		     
		  	</td>
		</tr>
		<tr>
			<td class="label"> 
		    	<label for="textoNotifTransferencias">Asunto para transferencias: </label> 
		   	 </td> 
		    <td>
		     	<input type="text" id="textoNotifTransferencias" name="textoNotifTransferencias"  size="70"  tabindex="14"/>		     
		  	</td>
		</tr>
		
	</table>
	</fieldset>
	
	<br>
	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Verisec Freja</legend>	
	<table>		
		<tr>
			<td class="label"> 
		    	<label for="urlFreja">URL del servidor: </label> 
		   	 </td> 
		    <td>
		     	<input type="text" id="urlFreja" name="urlFreja"  size="70"  tabindex="15"/>		     
		  	</td>
		  	
		  	<td class="separador"></td> 
		  	
		  	<td class="label"> 
		    	<label for="tituloTransaccion">Titulo inicio transacci&oacute;n: </label> 
		   	 </td> 
		    <td>
		     	<input type="text" id="tituloTransaccion" name="tituloTransaccion"  size="70"  tabindex="16"/>		     
		  	</td>
		</tr>
		<tr>
			<td class="label"> 
		    	<label for="periodoValidacion">Periodo de validez: </label> 
		   	 </td> 
		    <td>
		     	<input type="text" id="periodoValidacion" name="periodoValidacion"  size="70"  tabindex="17"/>		     
		  	</td>
		  	
		  	<td class="separador"></td> 
		  	
		  	<td class="label"> 
		    	<label for="tiempoMaxEspera">Tiempo m&aacute;ximo de espera: </label> 
		   	 </td> 
		    <td>
		     	<input type="text" id="tiempoMaxEspera" name="tiempoMaxEspera"  size="70"  tabindex="18"/>		     
		  	</td>
		</tr>
		<tr>
			<td class="label"> 
		    	<label for="tiempoAprovisionamiento">Tiempo de espera para completar el aprovisionamiento: </label> 
		   	 </td> 
		    <td>
		     	<input type="text" id="tiempoAprovisionamiento" name="tiempoAprovisionamiento"  size="70"  tabindex="19"/>		     
		  	</td>
		  	
		</tr>
	</table>
	</fieldset>
	
	<br>
	
	<div id="gridProductosCreditos" style="display: none;"/>
	
	<br>
	
	<br>
	
	<div id="gridTiposCuentas" style="display: none;"/>	
	
	<br>
	
	
	
	<table align="right">
		<tr>
			<td align="right">				
				<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="100"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>										
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
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"></div>
</div>

</body>
<div id="mensaje" style="display: none;"></div>