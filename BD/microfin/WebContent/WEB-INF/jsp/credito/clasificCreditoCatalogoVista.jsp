<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>

	<head>	
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clasificCreditoBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Clasificaci&oacute;n de Tipos de Productos de Cr&eacute;ditos</legend>
					
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
		         	<label for="lblclasificacionID">Clasificaci&oacute;n: </label> 
				   </td>
				   <td>
				      <form:input id="clasificacionID" name="clasificacionID" path="clasificacionID" size="12" tabindex="1"/>  
				   </td>
				   <td class="separador"></td> 
				   <td class="label"> 
		         	<label for="lbltipoClasificacion">Tipo Clasificacion: </label> 
		     		</td> 
		     		<td> 
		         	 <form:input id="tipoClasificacion" name="tipoClasificacion" path="tipoClasificacion" size="12" tabindex="1"/>  
		     		</td>
		     		
				</tr>
				<tr> 
		     		<td class="label"> 
		         	<label for="lbldescripClasifica">Descripci&oacute;n:</label> 
					</td> 		     		
		     		<td>
		         	 <form:input id="descripClasifica" name="descripClasifica" path="descripClasifica" size="12" tabindex="1"/>  
		     		</td> 	
		     		<td class="separador"></td> 
		     		<td class="label"> 
		         	<label for="lblcodigoClasific">C&oacute;digo: </label> 
		     		</td> 
		     		<td> 
		         	 <form:input id="codigoClasific" name="codigoClasific" path="codigoClasific" size="12" tabindex="1"/>  
		     		</td>
		 		</tr> 
				<tr>
					<td colspan="5">
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="activa" name="activa" class="submit" value="Activar" tabindex="5"  />
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>				
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