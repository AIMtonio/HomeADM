<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>
<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tarjetaCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/catalogoBloqueoCancelacionTarDebitoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="js/tarjetas/bloqueoManualTarjeta.js"></script>

</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarjetaDebitoBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Bloqueo de Tarjeta</legend>
	<table border="0" width="100%">
				<tr>
					<input type="hidden" name="tipoTarjeta" id="tipoTarjeta" value="1">
					
					<td class="label">
						<label> Tipo de Tarjeta</label>
						<input type="radio" id="tipoTarjetaDeb" name="tipoTarjetaDeb">
						<label> D&eacute;bito</label>
						<input type="radio" id="tipoTarjetaCred" name="tipoTarjetaCred">
						<label> Cr&eacute;dito </label>
					</td>
				</tr> 
				<tr>
					<td class="label" >
						<label for="lblNumeroTarjeta">N&uacute;mero Tarjeta:</label>
	       		 		<input  type="text" id="tarjetaDebID" name="tarjetaDebID" path="tarjetaDebID" size="20" maxlength="16" tabindex="1" />
	       		 		<input  type="hidden" id="tarjetaCredID" name="tarjetaCredID" path="tarjetaCredID" size="20" maxlength="16" tabindex="1" />
					</td> 	
					<td class="label">
					  	<label for="estatus">Estatus: </label>
				   </td>
					<td>
						<input type="text" id="estatus" name="estatus"  readOnly="true" size="40" />
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Datos Tarjeta</legend>
							<table>
								<tr>
									<td class="label">
					  					<label for="tarjeta">Tarjetahabiente: </label>
									</td>
									<td>
										<input type="text" id="tarjetaHabiente" name="tarjetaHabiente" readOnly="true" size="11" />					
										<input type="text" id="nombreCli" name="nombreCli" readOnly="true"  size="60"/>	
									</td>					
								</tr>
								<tr id="corpTr">
					 				<td class="label">
					  					<label for="fecha">Corporativo (Contrato): </label>
					 				</td>
									<td>
										<input type="text" id="coorporativo" name="coorporativo" readOnly="true" size="11"  />					
										<input type="text" id="nomCorp" name="nomCorp"  readOnly="true" size="60"   />	
									</td>
			  					</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Datos Bloqueo</legend>
							<table>
								<tr>
									<td class="label">
										<label > Motivo Bloqueo: </label>
			    					</td>
									<td>
					  					<select id="motivoBloqID" name="motivoBloqID"  path="motivoBloqID" tabindex="2" >
					  						<option value="">Selecciona</option>
					  					</select>
			   	  				</td>
			   	  	 			<td class="separador"></td> 	
									<td>
										<input type="hidden" id="fecha" name="fecha"  readOnly="true" size="10"  esCalendario="true" />	
									</td>
								</tr>
								<tr>
			       				<td>
										<label> Descripci&oacute;n Adicional: </label>
									</td>
									<td>
										<textarea id="descripcion" name="descripcion"  class="contador"  rows="7" cols="50" onblur="ponerMayusculas(this); limpiarCajaTexto(this.id);"  maxlength="500"  tabindex="3" ></textarea>
						 				<div align="right">
											<label for="longitud_textarea" id="longitud_textarea" name="longitud_textarea"></label>
										</div>
									</td>
								</tr>								
							</table>
						</fieldset>
					</td>
				</tr>		   
		</table>
					
		<table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="bloquear" name="bloquear" class="submit" tabindex="4" value="Bloquear"   /> 
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
													
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