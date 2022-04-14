<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>

		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
      	<script type="text/javascript" src="js/cuentas/repMovsCuentas.js"></script>  
				
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasAhoMovBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de <s:message code="safilocale.ctaAhorroRep"/></legend>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr> 
	 		<td> 
			 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>
												<label>Parámetros: </label> </legend>
		 		<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr> 
						<td class="label"> 
							<label for="lblFechaCarga">Fecha de Inicio:</label> 
						</td> 
							<td class="separador">
					   	<td> 
					    	<input type="text" id="fechaCargaInicial" name="fechaCargaInicial"  size="14" tabindex="1" 
					    		esCalendario="true"/> 
					   	</td>
					   	<td class="separador"><br><!-- <br></td> --> 
					 </tr>
					 	
					 <tr>
					   	<td class="label"> 
							<label for="lblFechaCarga">Fecha de Fin:</label> 
					   	</td> 
					   		<td class="separador">
					   	<td> 
					    	<input type="text" id="fechaCargaFinal" name="fechaCargaFinal"  size="14" tabindex="2" 
					    		path="fechaCargaFinal" esCalendario="true"/> 
					   </td>
					   <td class="separador"><br><!--<br></td>--> 
					</tr>
					<tr>			
						<td class="label">
							<label for=cuentasAho> Mostrar: </label> 
						</td>
							<td class="separador">
						<td>
							<select id="mostrar" name="mostrar"  tabindex="3">
								<option value="">SELECCIONAR</option>
								<option value="T">TODOS</option>
								<option value="M">SOLO CON MOVIMIENTOS</option>
							</select>				
						</td>	
						<td class="separador"><br><!-- <br></td> -->
					</tr>
					<tr>
						<td>
							<label>Tipo Cuenta:</label> 
						</td>
							<td class="separador">
						<td>
							<select id="tipoCuentaID" name="tipoCuentaID" path="tipoCuentaID"  tabindex="4" >
							<option value="">SELECCIONAR</option>
							<option value="0">TODOS</option>
							</select>									 
						</td>
						<td class="separador"><br><!--<br></td>-->
					</tr>
					<tr>
						<td>
							<label>Sucursal:</label>
						</td>
							<td class="separador">
						<td>
							<select id="sucursal" name="sucursal"  path="sucursal" tabindex="5" >
							<option value="">SELECCIONAR</option>
							<option value="0">TODOS</option>
							 </select>									 
						</td>
						<td class="separador"><br><!--<br></td>-->
					</tr>
					<tr>		
						<td>
							<label>Moneda:</label>
						</td>
							<td class="separador">
						<td>
							<select name="monedaID" id="monedaID" tabindex="6" >
							<option value="">SELECCIONAR</option>	 						
							<option value="0">TODOS</option>
							</select>
						</td>
						<td class="separador"><br><!--  <br></td>-->
					</tr>
					<tr> 
						<td class="label">
							<label for="promotorInicial">Promotor:</label>
						</td>
							<td class="separador">
						<td >
							<input id="promotorID" name="promotorID"  tabindex="7" size="12"/> <input type="text"id="nombrePromotorI" name="nombrePromotorI" size="39"  readOnly />
						</td>
						<td class="separador"><br><!-- <br></td> -->
					</tr>
					<tr>
						<td class="label">
							<label for="sexo"> Género:</label>
						</td>
							<td class="separador">
						<td>
							<select id="sexo" name="sexo" path="sexo"  tabindex="8">
							<option value="">SELECCIONAR</option>
							<option value="">TODOS</option>
							<option value="M">Masculino</option>
							<option value="F">Femenino</option>
							</select>
						</td>
						<td class="separador"><br><!--<br></td>-->
					 </tr>	
					<tr>
					    <td class="label"> 
							 <label for="estado">Estado: </label> 
						</td> 
							<td class="separador">
						<td> 
						     <input id="estadoID" name="estadoID" path="estadoID" size="12" tabindex="9" /> <input type="text" id="nombreEstado" name="nombreEstado" size="39"   readOnly/>   
					   </td> 
					   <td class="separador"><br><!--<br></td> -->
					</tr> 
			 		<tr> 
					     <td class="label"> 
					         <label for="municipio">Municipio: </label> 
					     </td> 
					     	<td class="separador">
					     <td> 
					         <input id="municipioID" name="municipioID" size="12" tabindex="10" /> <input type="text" id="nombreMuni" name="nombreMuni" size="39"  readOnly/>   
					     </td> 
					     <td class="separador"><br><!--<br></td> -->
		     		</tr>	
				 </table> 
 		 		</fieldset>  
 		 </td>  
      	<td> 
      		<table width="200px"> 
				<tr>
					<td class="label" style="position:absolute;top:8%;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
								<legend><label>Presentaci&oacute;n</label></legend>
								<input type="radio" id="pdf" name="generaRpt" value="pdf" tabindex="11"/>
								<label> PDF </label>
								 <br>
								<input type="radio" id="excel" name="generaRpt" value="excel" tabindex="12">
								<label> Excel </label>
						 		</fieldset>
					</td>      
				</tr>
			</table> 
		</td>
    </tr>
    </table>
	<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
	<input type="hidden" id="tipoLista" name="tipoLista" />
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		
		<tr>
			<td colspan="4">
				<table align="right" border='0'>
					<tr>
						<td align="right">
					
						<a id="ligaGenerar" href="/reporteMovCuentas.htm" target="_blank" >  		 
							 <input type="button" id="generar" name="generar" class="submit" 
									 tabIndex = "48" value="Generar" />
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
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>