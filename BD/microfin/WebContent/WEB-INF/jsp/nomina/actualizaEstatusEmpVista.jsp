<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>	
  <script type="text/javascript" src="dwr/interface/bitacoraPagoNominaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/actualizaEstatusEmpServicio.js"></script>
	<script type="text/javascript" src="js/nomina/actualizaEstatusEmp.js"></script>
</head>

<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="actualizaEstatusEmpBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all" >
			<legend class="ui-widget ui-widget-header ui-corner-all">Bajas e Incapacidades</legend>
			    <!-- <fieldset class="ui-widget ui-widget-content ui-corner-all"> -->
				<table border="0" cellpadding="0" cellspacing="0" width="100%">	
					<tr>
					  <td class="label">
					  	<label for="lblEmpresa">Empresa N&oacute;mina: </label>
					  </td>
					  	<td>
					 		<input type="text" id="institNominaID" name="institNominaID" size="7" tabindex="1" />
					 		  <input type="text" id="nombreEmpresa" name="nombreEmpresa" size="68" disabled= "true" 
	         					 readonly="true" iniforma='false'/>  
						</td>
					</tr>
					<tr>
					  <td class="label">
					  	<label for="lblNumEmpleado">Cliente: </label>
					  </td>
					 <td>
						 <input id="clienteID" name="clienteID" size="7" tabindex="2" type="text" tabindex="2"  iniForma="false"  />
						 <input id="nombreEmpleado" name="nombreEmpleado" size="68"  type="text" readOnly="true"
		                         iniForma="false"  disabled="true" />
					 </td>
					</tr>
					<tr>
				          <td class="label">
				          <label for="lblEstatusActual">Estatus Actual: </label>
				          </td>
					  <td>
					  	<input id="estatusActual" name="estatusActual" size="13"  tabindex="3" type="text" 
					  		readOnly="true" disabled="true"/>
					 </td> 
					</tr>
					<tr>
						<td class="label"><label for="lblestatus">Nuevo Estatus: </label></td>
						<td>  <select id="estatus" name="estatus"  path="estatus" tabindex="4" iniForma= "false">
						      <option value="0">SELECCIONA</option>
						      <option value="A">ACTIVO</option>
						      <option value="I">INCAPACIDAD</option>
						      <option value="B">BAJA</option>
							 </select>
						      
					  	</td>
					</tr>  	
				</table>
			  <!--  </fieldset> -->
		<div id="incapacidadDiv" style="display:none">
			   <fieldset class="ui-widget ui-widget-content ui-corner-all">
			   <legend>Incapacidad</legend>
					<table>
	    				<tr>
						  <td class="label"><label for="lblfechaInicialInc">Fecha Inicial: </label></td>
						  <td><input id="fechaInicialInca" name="fechaInicialInca"  size="15" 
					         			tabindex="5" type="text"  esCalendario="true" />	
						  </td>					
						</tr>
						<tr>			
						   <td class="label"><label for="lblfechaFinInc">Fecha Final: </label></td>
						   <td><input id="fechaFinInca" name="fechaFinInca"  size="15" 
					         			tabindex="6" type="text" esCalendario="true"/>				
						   </td>	
						</tr>
					</table>
			   </fieldset>
	   </div>
	   <div id="bajaDiv" style="display:none">
			   <fieldset class="ui-widget ui-widget-content ui-corner-all">
			   <legend>Baja</legend>
			       <table>	
			          <tr>
				    <td class="label"><label for="lblfechaIni">Fecha Baja: </label></td>
						  <td><input id="fechaBaja" name="fechaBaja"  size="15" 
					         			tabindex="7" type="text"  esCalendario="true" />	
						  </td>		
			          </tr>
			          <tr>
				    <td class="label"><label for="lblReferencia">Motivo Baja:</label></td>
				    
				    <td><textarea id="motivoBaja" name="motivoBaja" iniForma="false" cols="30" rows="2" tabindex="8" 
				         class="contador" onblur="ponerMayusculas(this)" maxlength="50" ></textarea>
			                 <div id="longitud" >
					  <label for="longitud_textarea" id="longitud_textarea" name="longitud_textarea"></label>
				         </div>
				    </td>
			         </tr>
					
			    </table>
				</fieldset>
		</div>
				<table>	
					<tr>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>
						<td style="text-align: right;">									
							<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="9"/>
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
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>