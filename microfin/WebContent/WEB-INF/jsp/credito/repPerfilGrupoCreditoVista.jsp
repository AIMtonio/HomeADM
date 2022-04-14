<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>	
	<script type="text/javascript" src="js/credito/repPerfilGrupoCredito.js"></script>
</head>
<body>
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Perfil de Grupo</legend>	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repPerfilGrupoCreditoBean"  target="_blank">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
					<label>Fecha: </label>
					</td>
					<td>
					<form:input type="text" name="fechaEmision" id="fechaEmision" path="fechaEmision" autocomplete="off" size="12" tabindex="1" disabled="true"/>						
					</td>
				</tr>				
				<tr>
					<td class="label"> 
					<label>No. Grupo:</label>
					</td>
					<td>
					<form:input type="text" name="grupoID" id="grupoID" path="grupoID" autocomplete="off" size="12" tabindex="2" />	
					<form:input type="text" name="nombreGrupo" id="nombreGrupo" path="nombreGrupo" autocomplete="off" size="40" disabled="true"/>
					</td>
				</tr>
				<tr>
					<td>
						<form:input type="hidden" name="nombreInstitucion" id="nombreInstitucion" path="nombreInstitucion" size="30" />
				   		<form:input type="hidden" name="usuario" id="usuario" path="usuario" size="30" />
				   		<form:input type="hidden" name="fechaRegistro" id="fechaRegistro" path="fechaRegistro" size="12" />
				   		<form:input type="hidden" name="cicloActual" id="cicloActual" path="cicloActual" size="5" />
				   		<form:input type="hidden" name="estatusCiclo" id="estatusCiclo" path="estatusCiclo" size="10" />								 			 	  
					</td>
				</tr>			
				<tr>		
					<td colspan="5">
						</br>
						<table align="left" border='0'>
							<tr>
								<td width="350px">			
								</td>				
								<td align="right"">
										<input type="button"  id="generar" name="generar" class="submit"
												 tabindex="7" value="Generar PDF" />
								</td>				
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</form:form>
	</fieldset>
</div>
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>

</body>
</html>