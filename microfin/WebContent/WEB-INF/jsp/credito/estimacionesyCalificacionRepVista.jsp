<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>      
<html>
	<head>
      
     <script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>  
     <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
     <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	 <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
	 <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
     <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>  
     <script type="text/javascript" src="dwr/interface/estimacionPreventivaServicio.js"></script>
     
     <script type="text/javascript" src="js/credito/estimacionesyCalif.js"></script>  
				
	</head>
       
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Estimaciones y Calificaci&oacute;n</legend>
		
			<table border="0" cellpadding="0" cellspacing="0" width="760px">
			<tr> <td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros</label></legend>         
          <table  border="0"  width="560px">
                 <tr>
							<td class="label">
								<label for="lblTipoRango">Reporte</label>
							</td>
							<td class="label">
								<input type="radio" id="tipoReporte" name="tipoReporte" value="E" tabindex="1"/><label>Estimaciones</label>
								<input type="radio" id="tipoReporte2" name="tipoReporte2" value="C" tabindex="2"/><label>Calificaci&oacute;n</label>
							</td>
						</tr>
				<tr>
					<td class="label">
						<label for="creditoID">Fecha </label>
					</td>
					<td >
						<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="13" 
		         			tabindex="3" type="text"  esCalendario="true" />	
					</td>					
					<td class="separador"></td>				
				</tr>
				<tr>
								<td class="label" >
									<label for="lblclienteID">Cliente: </label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="clienteID" name="clienteID" tabindex="4" size="13" />
									<input type="text" id="nombreCompleto" name="nombreCompleto" size="50" tabindex="5" onBlur="ponerMayusculas(this)" disabled="true" />
								</td>
							</tr>
				<tr>
								<td class="label" >
									<label for="lblgrupoID">Grupo: </label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="grupoID" name="grupoID" tabindex="6" size="13" />
									<input type="text" id="nombreGrupo" name="nombreGrupo" size="50" tabindex="7" onBlur="ponerMayusculas(this)" disabled="true" />
								</td>
							</tr>
				<tr>
					<td>
						<label>Sucursal:</label>
					</td>
					<td><select id="sucursal" name="sucursal" path="sucursal" tabindex="8" >
				         <option value="0">TODAS</option>
					      </select>									 
					</td>
					

					</tr>
					<tr>		
					<td>
						<label>Moneda:</label>
					</td>
					<td><select name="monedaID" id="monedaID" path="monedaID" tabindex="9" >	 						
						<option value="0">TODAS</option>
							</select>
									 
					</td>
				</tr>
				<tr>
					<td>
						<label>Producto de Cr&eacute;dito:</label> 
					</td>
					<td><select id="producCreditoID" name="producCreditoID" path="producCreditoID"  tabindex="10" >
				         <option value="0">TODAS</option>
					      </select>									 
					</td>
				
					
				</tr>
				
				<tr> 
				<td class="label">
					<label for="promotorInicial">Promotor:</label>
				</td>
				<td nowrap="nowrap">
					<form:input id="promotorID" name="promotorID" path="promotorID"
					size="13" tabindex="11"/>
					<input type="text"id="nombrePromotorI" name="nombrePromotorI" size="50" tabindex="12" 
					 disabled= "true" readOnly="true" />
					 
				</td>
				
				</tr>
				<tr>
			<td class="label">
				<label for="sexo"> G&eacute;nero:</label>
			</td>
			<td>
				<form:select id="sexo" name="sexo" path="sexo" tabindex="13">
				<form:option value="0">TODOS</form:option>
				<form:option value="M">MASCULINO</form:option>
		     	<form:option value="F">FEMENINO</form:option>
				</form:select>
			</td>		
			
		</tr>	
		<tr>
		<td class="label"> 
         <label for="estado">Estado: </label> 
     </td> 
     <td nowrap="nowrap"> 
         <form:input id="estadoID" name="estadoID" path="estadoID" size="13" tabindex="14" /> 
         <input type="text" id="nombreEstado" name="nombreEstado" size="50"   disabled ="true" tabindex="15"
           readOnly="true"/>   
     </td> 
 	</tr> 
		
	<tr> 
     <td class="label"> 
         <label for="municipio">Municipio: </label> 
     </td> 
     <td nowrap="nowrap"> 
         <form:input id="municipioID" name="municipioID" path="municipioID" size="13" tabindex="16" /> 
         <input type="text" id="nombreMuni" name="nombreMuni" size="50" tabindex="7" disabled="true" tabindex="17"
          readOnly="true"/>   
     </td> 
     </tr>	
  </table> </fieldset>  </td>  
      
<td> <table width="100px"> <tr>
				
					<td class="label" style="position:absolute;top:8%;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Presentaci&oacute;n</label></legend>
											<input type="radio" id="pdf" name="generaRpt" value="pdf" tabindex="18"/>
							<label> PDF </label>
				            <br>
							<input type="radio" id="excel" name="generaRpt" value="excel" tabindex="19">
						<label> Excel </label>
					 	
						</fieldset>
					</td>      
					</tr>
					
					
					<tr>
					
					<td class="label" id="tdPresenacion" style="position:absolute;top:40%;">
					
					</td>  
					
					</tr> 
					
	</table> </td>
         
    </tr>
     
	</table>
				<input type="hidden" id="tipoLista" name="tipoLista" />
				<input type="hidden" id="reporte" name="reporte" />
				<input type="hidden" id="formato" name="formato" />
				<input type="hidden" id="fechaValida" name="fechaValida"/>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
								
									<a id="ligaGenerar" target="_blank" >  		 
										 <input type="button" id="generar" name="generar" class="submit" 
												 tabIndex = "20" value="Generar" />
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
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>