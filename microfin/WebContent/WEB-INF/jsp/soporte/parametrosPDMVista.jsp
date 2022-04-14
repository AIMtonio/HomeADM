<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
 	   <script type="text/javascript" src="dwr/interface/parametrosPDMServicio.js"></script>  
      <script type="text/javascript" src="js/soporte/parametrosPDM.js"></script>  	
	</head>
      
<body>

	<script>
		var nomServicio = "";

		var conParametroBean = {  
			'principal' : 1	
		};

		consultaParametros();

		// Funcion pra consultar el nombre del Servicio
		function consultaParametros(){
			var numEmpresaID = 1;
	
			var parametrosBean = {
	  				'empresaID':numEmpresaID	
	  		};
	
			setTimeout("$('#cajaLista').hide();", 200);
			if (numEmpresaID != '' && !isNaN(numEmpresaID)) { 
				
				parametrosPDMServicio.consulta(parametrosBean,conParametroBean.principal,function(data) { 	
					//si el resultado obtenido de la consulta regreso un resultado
					if (data != null) {				
						//coloca los valores del resultado en sus campos correspondientes
						nomServicio = data.nombreServicio;
						agregaServicio(nomServicio);
					}
				});
			}
		}

		// Funcion para obtener el nombre del servicio para mostrarlo en el titulo de la Pantalla
		function agregaServicio(nomServicio){
			document.getElementById('nomServicio').innerHTML = nomServicio;
		}
	</script>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosPDMBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros <label id="nomServicio"></label></legend>
		<table border="0"  width="100%">
			 <tr> <td> 
          	<table border="0" width="100%">
				<tr>
					<td class="label">
						<label for="lblNombre">Nombre del Servicio:</label>
						<input id=nombreServicio name="nombreServicio" size="50" tabindex="1" type="text" maxlength="50" autocomplete="off" />	
					</td>				
				</tr>
			</table>
			<table  border="0"  width="100%">
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend>Preguntas de Seguridad</legend>
							<table>
								<tr>
									<td class="label">
										<label for="lblPreguntas">N&uacute;mero de Preguntas Seg:</label>
									</td>
									<td>
										<input id="numeroPreguntas" name="numeroPreguntas" size="7" type="text" style="text-align: right;" 
												maxlength="6" autocomplete="off" tabindex="2"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="lblRespuestas">Respuestas para Aprobar: </label>
									</td>
									<td class="label">
										<input id="numeroRespuestas" name="numeroRespuestas" size="7" type="text" style="text-align: right;" 
											maxlength="6" autocomplete="off" tabindex="3" />	
									</td>				
								</tr>
							 </table>
						  </fieldset>
				  	 </td>
				  </tr>
			   </table>
 			</td>  
   		  </tr>
		</table>
		<table border="0"  width="100%">
			<tr>
				<td align="right">
					<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="4"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
					<input type="hidden" id="empresaID" name="empresaID" value= "1"/>
				</td>
			</tr> 
		</table> 
</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>

