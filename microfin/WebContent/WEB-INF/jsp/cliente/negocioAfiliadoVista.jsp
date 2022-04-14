<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	
<head>	 
	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>      	
	<script type="text/javascript" src="dwr/interface/negocioAfiliadoServicio.js"></script>      	     				      
    <script type="text/javascript" src="js/cliente/negocioAfiliadoVista.js"></script>
</head>
  
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica"    method="POST" commandName="negocioAfiliado">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			  <legend class="ui-widget ui-widget-header ui-corner-all">Negocio Afiliado </legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label"> 
						         	<label for="lblNegocioAfiliado">N&uacute;mero: </label> 
						      </td>
							<td class="label"> 			    
								<form:input type="text" id="negocioAfiliadoID" name="negocioAfiliadoID" path="negocioAfiliadoID" size="13"
										 autocomplete="off" tabindex="1" />
						    </td>	
						</tr>
						<tr>
						   	<td class="label"> 
								<label for="lblnumero">Raz&oacute;n Social: </label> 
						 	</td>
						    <td class="label"> 
								<form:input type="text" id="razonSocial" name="razonSocial" path="razonSocial" size="68"
										 autocomplete="off" tabindex="2"  onblur="ponerMayusculas(this)" maxlength="200" />
							</td>
						</tr>
						
						<tr>
						    <td class="label"> 
								<label for="lblrfc">RFC: </label> 
						 	</td>
						    <td class="label"> 
								<form:input type="text" id="rfc" name="rfc" path="rfc" size="30"
										 autocomplete="off" tabindex="3" maxlength="12" onblur="ponerMayusculas(this)"/>
							</td>
						    <td class="separador"></td>
						   	<td class="label"> 
								<label for="lblTelefonoContacto">Tel&eacute;fono: </label> 
						 	</td>
						    <td class="label"> 
								<form:input type="text" id="telefonoContacto" name="telefonoContacto" path="telefonoContacto" size="20"
										 autocomplete="off" tabindex="4" maxlength="20" />
							</td>
						</tr>
						<tr>
							<td class="label"> 
						         	<label for="lblrfc">Direcci&oacute;n: </label> 
						      </td>
							<td class="label"> 			    
								<form:textarea type="text" id="direccionCompleta" name="direccionCompleta" path="direccionCompleta"
										size="50" cols="42" rows="3" tabindex="5" resize="none" maxlength="400" 
										autocomplete="off" onblur="ponerMayusculas(this)" ></form:textarea>
						    </td>	
						    <td class="separador"></td>
						   	<td class="label"> 
								<label for="lblTelefonoContacto">Correo: </label> 
						 	</td>
						    <td class="label"> 
								<form:input type="text" id="correo" name="email" path="email" size="30" 
										 autocomplete="off" tabindex="6" maxlength="50"  />
							</td>
						</tr>
						<tr>
					       	<td class="label"> 
					         <label for="lblnumero">Nombre del Contacto: </label> 
					        </td>
					       	<td class="label" > 			    
								<form:input type="text" id="nombreContacto" name="nombreContacto" path="nombreContacto" size="50" 
									autocomplete="off" tabindex="7" onblur="ponerMayusculas(this)" maxlength="400"  />
							</td>	
						    <td class="separador"></td>
						    <td class="label"> 
								<label for="lblTelefonoContacto">Fecha Registro: </label> 
						 	</td>
						    <td class="label"> 
								<form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="15" disabled="true" readonly="true"
										 tabindex="8"  />
							</td>
					  	</tr>
						<tr>
					       	<td class="label"> 
					         <label for="lblnumero">Promotor: </label> 
					        </td>
					       	<td class="label" > 			    
								<form:input type="text" id="promotorOrigen" name="promotorOrigen" path="promotorOrigen" size="13" tabindex="9"  />
								<input type="text" id="nombrePromotor" name="nombrePromotor"  size="50" tabindex="9" disabled="true" readonly="true"
									onblur="ponerMayusculas(this)"  />
							</td>	
						    <td class="separador"></td>
						    <td class="label"> 
								<label for="lblestatus">Estatus: </label> 
						 	</td>
						    <td class="label"> 
								<form:input type="text" id="estatusDescripcion" name="estatusDescripcion" path="estatusDescripcion" size="15" disabled="true" readonly="true"
										 tabindex="10"  />
								<form:input type="hidden" id="estatus" name="estatus" path="estatus" size="15" disabled="true" readonly="true"
										 tabindex="10"  />
							</td>
					  	</tr>
						<tr>
					       	<td class="label"> 
					         <label for="lblCliente"><s:message code="safilocale.cliente"/>: </label> 
					        </td>
					       	<td class="label"> 			    
								<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="13" tabindex="10"  />
								<input type="text" id="nombreCliente" name="nombreCliente"  size="50" tabindex="11" disabled="true" readonly="true"
									onblur="ponerMayusculas(this)" />
							</td>	
					  	</tr>
					</table>
					<table align="right">
						<tr>
						<td align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" tabindex="20" value="Agregar"/>	
							<input type="submit" id="modifica" name="modifica" class="submit" tabindex="20" value="Modificar"/>
							<input type="submit" id="baja" name="baja" class="submit" tabindex="20" value="Baja"/>								
							<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="0"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"  value="1" />
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