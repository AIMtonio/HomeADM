<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
	  	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	    <script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 
	    <script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script> 
	    <script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
	  	<script type="text/javascript" src="dwr/interface/proveedoresServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/requisicionGastosServicio.js"></script> 
		
		 <script type="text/javascript" src="js/tesoreria/proveedores.js"></script>  
		 <script type="text/javascript" src="js/tesoreria/proveeTipoGasto.js"></script>  

	
	
	</head>
<body>
	<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="proveedoresTipoGasto">

						<fieldset class="ui-widget ui-widget-content ui-corner-all">		
								<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Proveedores y Tipos de Gastos</legend>
								<br> 		
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>
										<td class="label">
											<label for="1"></label>
											<label for="lblproveedor">Proveedor: </label>
											<form:input id="proveedorID" name="proveedorID" path="proveedorID" size="12" tabindex="1"  />
										</td>
									</tr>
								</table>
						<br>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">	
								<legend >Datos Del Proveedor o Representante Legal</legend>
								<br>
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
	
									<tr>
	
										<td class="label"> 
											<label for="tipoPersona">Tipo Persona: </label> 
										</td>
										<td class="label"> 
											<form:input type="text" id="tipoPersona" disabled="true" name="tipoPersona" path="tipoPersona" value="" tabindex="2"  size="25"/>
											
										</td>
									</tr>
				
									<tr>
	
										<td class="label">
											<label for="primerNombre">Primer Nombre:</label>
										</td>
										<td>
											<form:input id="primerNombre" name="primerNombre" disabled="true" path="primerNombre" tabindex="4" size="25"
														onBlur=" ponerMayusculas(this)"/>
										</td>		
	
										<td class="separador"></td>
										<td class="label">
											<label for="segundoNombre">Segundo Nombre: </label>
										</td>
										<td >
											<form:input id="segundoNombre" name="segundoNombre" disabled="true" path="segundoNombre" size="25"
														 tabindex="5" onBlur=" ponerMayusculas(this)"/>
										</td>			
										</tr>
	
										<tr>
	
											<td class="label">
												<label for="apellidoPaterno">Apellido Paterno:</label>
											</td>
											<td>
												<form:input id="apellidoPaterno" name="apellidoPaterno" disabled="true" path="apellidoPaterno" size="25"
															tabindex="6" onBlur=" ponerMayusculas(this)"/>
											</td>
											<td class="separador"></td>
				
	
											<td class="label">
													<label for="apellidoMaterno">Apellido Materno:</label>
											</td>
											<td >
												<form:input id="apellidoMaterno" name="apellidoMaterno"disabled="true"  path="apellidoMaterno" size="25"
															tabindex="7" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="fechaNacimiento"> Fecha de Nacimiento:</label>
											</td>
											<td>
												<form:input id="fechaNacimiento" name="fechaNacimiento"  disabled="true" path="fechaNacimiento" size="25" tabindex="8" />	
											</td>
											<td class="separador"></td>
											<td class="label">
													<label for="CURP">CURP:</label>
											</td>
											<td>
		
												<form:input id="CURP" name="CURP" path="CURP"  disabled="true" tabindex="9" size="25" 
															 maxlength="18"/>
											</td>		
										</tr>
			
										<tr>
											<td class="label">
												<label id="RFCpf" for="RFCpf"> RFC:</label>
												<label id="RFCrl" for="RFCrl" style="display:none"> RFC Representante Legal: </label>
											</td>
											<td>
												<form:input id="RFC" name="RFC" path="RFC" disabled="true" tabindex="10" size="25"
															  maxlength="13"/>
			
											
											</td>	
										</tr>	
										<tr>	
										
											<td class="label">
												<label id="tipoGastolb" for="tipoGastolbl"> Tipo de Gasto:</label>
											
											</td>
											<td>
												<input id="tipoGastoID" name="tipoGastoID"  path="tipoGastoID" tabindex="10" size="25"
															  maxlength="13"/>
												<input id="descripcionTG" name="descripcionTG" disabled="true" path="descripcionTG" tabindex="10" size="50"
															  maxlength="13"/>
												 <input type="hidden" id="tipoPago" name="tipoPago"  value="N" path="tipoPago" />
											</td>	
										</tr>	
												<tr>	
										
											<td class="label">
												
											
											</td>
											<td>
												
											</td>	
										</tr>		
									</table>
				
				
				<div id="personaMoral"  style="display:none">
				
						<fieldset class="ui-widget ui-widget-content ui-corner-all">		
						<legend>Persona Moral</legend>
				<br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
									
					<tr>
						<td class="label">
							<label for="razonSocial">Razon Social:</label>
						</td>
						<td >
							<form:input id="razonSocial" name="razonSocial" path="razonSocial" size="50"
										 tabindex="11" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="RFCpm">RFC:</label>
						</td>
						<td>
							<form:input id="RFCpm" name="RFCpm" path="RFCpm" tabindex="12"
										  maxlength="12"/>
					</tr>				 
					</table>
					</fieldset>
				</div>
					<br><label id="sucurlb" for="sucurlb"> Sucursales:</label>
						<c:set var="listaResultado"  value="${listaResultado[0]}"/>	
						<div id="listaSucursalesDiv">
						
						</div>					
				
				
					</fieldset>	
		
			<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="agregaProv" name="agrega" class="submit" 
							 value="Agrega"/>
														
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>						
						</td>
					</tr>
				</table>		
			</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>