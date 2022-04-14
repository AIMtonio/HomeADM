<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>      
<html>
	<head>
      
	 <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
     <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
		      
      <script type="text/javascript" src="js/cliente/repCtePorPromotor.js"></script>  
				
	</head>
       
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reporteBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all"><s:message code="safilocale.cliente"/>s por Promotor</legend>
		
			<table border="0" cellpadding="0" cellspacing="0" width="100px">
			<tr> <td> 
					      
         	 <table  border="0"  width="560px">
					<tr>
					<td>
						<label>Sucursal:</label>
					</td>
					<td>
						<input type="text" id="sucursalID" name="sucursalID" path="sucursalID" tabindex="1" value="0" size="6" />
						<input type="text" id ="nombreSucursal" name="nombreSucursal" readOnly="true" size="39" value="TODAS"/>							 
					</td>
					

					</tr>
				<tr> 
				<td class="label">
					<label for="promotorActual">Promotor:</label>
				</td>
				<td >
					<input id="promotorID" name="promotorID"  value="0"	size="6" tabindex="2"/>
					<input type="text"id="nombrePromotor" name="nombrePromotor" size="39" value="TODOS" readOnly="true" />
				</td>
				
				</tr>
				<tr>
			<td class="label">
				<label for="sexo"> G&eacute;nero:</label>
			</td>	
			<td>
				<select id="sexo" name="sexo" path="sexo" tabindex="6">
				<option value="0">TODOS </option>
				<option value="M">MASCULINO</option>
		     	<option value="F">FEMENINO</option>
				</select>
			</td>		
			
		</tr>	
		<tr>
		<td class="label"> 
         <label for="estado">Estado: </label> 
     </td> 
     <td> 
         <input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="7" value="0"/> 
         <input type="text" id="nombreEstado" name="nombreEstado" size="39"   value="TODOS"  readOnly="true"/>   
     </td> 
 	</tr> 
		
	<tr> 
     <td class="label"> 
         <label for="municipio">Municipio: </label> 
     </td> 
     <td> 
         <input id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="8" value="0" /> 
         <input type="text" id="nombreMunicipio" name="nombreMunicipio" size="39" value="TODOS" readOnly="true"/>   
     </td> 
     </tr>	
     
     <tr> 
     	<td class="label">
				<label for="creditoEstatus"> Cr&eacute;dito Activo:</label>
		</td>	
    	<td>	<select id="estatus" name="estatus" path="estatus" tabindex="9">
				<option value="0">TODOS </option>
				<option value="V">VIGENTE</option>
		     	<option value="B">VENCIDO</option>
				</select>
		</td>
     </tr>	
     
     
     
  </table> 
    </td>           
    </tr>
     
	</table>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				
				<tr>
					<td colspan="4">
						<table align="right" border='0'>
							<tr>
								<td align="right">
							
								<a id="ligaGenerar" href="repCtesPromotor.htm" target="_blank" >  		 
									 <input type="button" id="generar" name="generar" class="submit" 
											 tabIndex = "10" value="Generar" />
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