<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
		<script type="text/javascript" src="dwr/interface/companiasServicio.js"></script>  		      
	    <script type="text/javascript" src="js/soporte/companiasCatalogo.js"></script>
       
	</head>
   
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="compania">
																			  
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Compañias</legend>
			
			<table border="0" width="100%">
				<tr>
					<td class="label"> 
						<label for="companialb">Número: </label> 
					</td>
					<td >
						<input id="companiaID" name="companiaID" path="companiaID" size="8" 
		         	 		tabindex="1" />  
					</td>
					<td class="separador"></td>

					<td class="label"> 
						<label for="razonSociallb">Raz&oacute;n Social: </label> 
					</td>
					<td >
						<form:input id="razonSocial" name="razonSocial" path="razonSocial" size="40" 
		         	 		tabindex="2"  maxlength="100"  />  
					</td>
				</tr>						
					
		
					
				<tr>						
					
					<td class="label"> 
						<label for="direccionCompletalb">Direcci&oacute;n Completa: </label> 
					</td>
					<td >
						<textarea id="direccionCompleta" name="direccionCompleta" path="direccionCompleta" cols="40" rows="3"  
							  onblur=" ponerMayusculas(this)" tabindex="3" maxlength = "100"></textarea> 
					</td>

					<td class="separador"></td>
					
					<td class="label"> 
						<label for="origenDatoslb">Origen de Datos: </label> 
					</td>
					<td >
						<form:input id="origenDatos" name="origenDatos" path="origenDatos" size="25" 
		         	 		tabindex="4" maxlength="45" />  
					</td>
	

				</tr>	

								
				<tr>						
					<td class="label"> 
						<label for="prefijolb">Prefijo: </label> 
					</td>
					<td >
						<form:input id="prefijo" name="prefijo" path="prefijo" size="25" 
		         	 		tabindex="5"  maxlength="45"  />  
					</td>

					<td class="separador"></td>

					<td class="label"> 
	       				<label for="timbraEdoCta">Mostrar Prefijo: </label> 
	   	 					
					</td>
					<td>
						<form:radiobutton id="mostrarPrefijo1" name="mostrarPrefijo1"  path="mostrarPrefijo" value="S" tabindex="6" />
							<label for="timbraEdoCta1">Si</label>
							<form:radiobutton id="mostrarPrefijo2" name="mostrarPrefijo1"  path="mostrarPrefijo" value="N" tabindex="7"/>
							<label for="timbraEdoCta2">No</label>
					</td>

				</tr>	
				
				<tr>						
					<td class="label"> 
						<label for="prefijolb">Desplegado: </label> 
					</td>
					<td >
						<form:input id="desplegado" name="desplegado" path="desplegado" size="25" 
		         	 		tabindex="8" maxlength="45" />  
					</td>

					<td class="separador"></td>

					<td class="label"> 
						<label for="origenDatoslb">Subdominio: </label> 
					</td>
					<td >
						<form:input id="subdominio" name="subdominio" path="subdominio" size="25" 
		         	 		tabindex="9" maxlength="50" />  
					</td>
					
				</tr>				
					
					<td align="right" colspan="5">
							 <br>
							 <br>
							<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="10"/>
							<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="11"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>		
					</td>			
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