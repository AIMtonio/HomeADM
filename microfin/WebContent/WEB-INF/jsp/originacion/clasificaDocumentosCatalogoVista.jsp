<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	  	<script type="text/javascript" src="dwr/interface/clasificaTipDocServicio.js"></script>   
       <script type="text/javascript" src="js/originacion/clasificaDocumentosCatalogo.js"></script>
       <script type="text/javascript" src="js/utileria.js"></script>
		<script type="text/javascript" src="js/gridviewscroll.js"></script>
</head>
<body>


<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clasificaDocumentos">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Tipos de Documentos</legend>
						
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			
				<tr> 
					<td class="label"> 
		         		<label for="lblClasificacion">Tipo Doc.: </label> 
		     		</td> 
		     		<td> 
		         		 <form:input type="text"  id="clasificaTipDocID" name="clasificaTipDocID" path="clasificaTipDocID" size="6" tabindex="1" />  
		     		</td>
		     		   
		     		     
		     		 <td class="label" class="separador"> </td> 
		     		 <td class="label">
		         		<label for="lblgarantia">Descripción: </label> 
		         	</td>
		     		
		     		<td> 		         
		     		  	<form:textarea type="textarea" id="clasificaDesc" name="clasificaDesc" path="clasificaDesc" COLS="50" ROWS="2" tabindex="2"  onBlur=" ponerMayusculas(this)"/>   
		     		</td>
		     		
		     	</tr> 
		     	<tr> 
					<td class="label"> 
				    	<label for="Aplica">Aplica Para:</label> 
					</td> 		     		
				    <td>
				    	<form:radiobutton type="radio" id="clasificaTipo1" name="clasificaTipo" path="clasificaTipo" value="M" tabindex="3"  />
							<label for="clasificaTipoM">Mesa de Control</label>
						<form:radiobutton type="radio" id="clasificaTipo2" name="clasificaTipo" path="clasificaTipo" value="S" tabindex="4" />
							<label for="clasificaTipoS">Solicitud</label>
						<form:radiobutton type="radio" id="clasificaTipo3" name="clasificaTipo" path="clasificaTipo" value="A" tabindex="5" />
							<label for="clasificaTipoA">Ambas</label>					
				   	</td> 					    
				</tr> 					     
		</table> 
		<br></br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all" id="filsetMesa">  
		<legend>Mesa de Control</legend>		
		<table border="0" cellpadding="0" cellspacing="0" width="100%">							
		     	<tr> 								    
				   	<td class="label"> 
				    	<label for="requerido">Requerido en: </label> 
					</td> 
				    <td> 
				    	<form:radiobutton type="radio" id="tipoGrupInd1" name="tipoGrupInd" path="tipoGrupInd" value="I" tabindex="6"  />
							<label for="tipoGrupInd">Individual</label>
						<form:radiobutton type="radio" id="tipoGrupInd2" name="tipoGrupInd" path="tipoGrupInd" value="G" tabindex="7" />
							<label for="tipoGrupIndG">Grupal</label>
						<form:radiobutton type="radio" id="tipoGrupInd3" name="tipoGrupInd" path="tipoGrupInd" value="A" tabindex="8" />
							<label for="tipoGrupIndA">Ambos</label>
					</td>
					
					<td class="label" class="separador"> </td>
					<td class="label"> 
		         		<label id="idlabelGarantia" for="lblRelacionado">Solicitado sólo si</br>Existen Garantías:  </label> 
		     		</td> 
		     		<td> 	<div id="garantia">	         
		         		<form:radiobutton type="radio" id="esGarantia1" name="esGarantia" path="esGarantia" value="S" tabindex="9"  />
							<label  id="esGarantiaSi" for="esGarantiaS">Si</label>
						<form:radiobutton type="radio" id="esGarantia2" name="esGarantia" path="esGarantia" value="N" tabindex="10"/>
							<label id="esGarantiaNo" for="esGarantiaN">No</label> 
						</div>
		     		</td>
				</tr> 
				<tr> 		     	
		     		<td class="label"> 
		         		<label id="labelIntegrante" for="lblIntegrante">Aplica para Integrante: </label> 
		     		</td> 
		     		<td> 
		         		 <form:select id="grupoAplica" name="grupoAplica" path="grupoAplica" tabindex="11" type="select" >
								<!--<form:option value=" ">Seleccionar</form:option>-->
								<form:option value="0">No Aplica</form:option>
								<form:option value="1">Presidente</form:option>
								<form:option value="2">Tesorero</form:option>
								<form:option value="3">Secretario</form:option>
								<form:option value="4">Integrante</form:option>
								<form:option value="5">Todos</form:option>								
						</form:select>      
		     		</td>
		     		
		     	</tr> 
		     
		</table> 
		</fieldset>		
		
		<br></br>		     	
 	
		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar" tabindex="12"  />
					<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="13"  />
					<input type="submit" id="eliminar" name="eliminar" class="submit" value="Eliminar" tabindex="14"  />
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="0"/>	
					<input type="hidden" id="tipoBaja" name="tipoBaja" value="0"/>				
				</td>
				
			</tr>
		</table>
		<table border="0" width="100%" class="divListaClasificacion">
			<tr>
				<div id="divListaClasificacion"></div>
			</tr>
		</table>
		<table border="0" width="100%" class="divListaDocClas">
			<tr>
				<div id="divListaDocClas"></div>
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
