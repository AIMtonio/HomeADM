<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>

	<head>	
	<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/autorizaSolicitudGrupoServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/esquemaGarantiaLiqServicio.js"></script>
    

      <script type="text/javascript" src="js/originacion/autorizaSolicitudGrupo.js"></script>   
	</head>
   <script language="javascript">
$(document).ready(function() {

  $('form').keypress(function(e){   
    if(e == 13){
      return false;
    }
  });

  $('input').keypress(function(e){
    if(e.which == 13){
      return false;
    }
  });

});
</script>
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="autorizaSolicitudGrupoBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Autorizaci&oacute;n de Solicitud Grupal</legend>
						
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
		         		<label for="lblGrupo">Grupo: </label> 
				    </td>
				    <td>
				      <form:input id="grupoID" name="grupoID" path="grupoID" size="10" tabindex="1" maxlength ="10"/>  
				      <input type="text" id="nombreGrupo" name="nombreGrupo"size="50" readOnly="true"  />
				    </td> 
		     		<td class="separador"></td> 
		     		<td class="label"> 
				   		<label for="lblProducto">Producto Cr&eacute;dito: </label> 
				   		<input type="hidden" id="producCreditoID" name="producCreditoID"/>	
				   </td>   	
				   <td nowrap="nowrap"> 
		         	<input id="descripProducto" name="descripProducto" size="50" type="text" 
		         		readOnly="true" />
		     		</td>	
		 		</tr>  
		 		<tr> 
		 			<td class="label"> 
		         		<label for="lblCiclo">Ciclo: </label> 
		     		</td> 
		     		<td> 
		         		 <form:input id="ciclo" name="ciclo" path="ciclo" size="10"  readOnly = "true"/>  
		     		</td>
		     		<td class="separador"></td> 
		     		<td class="label"> 
		         		<label for="lblfechaAutoriza">Fecha Autorizaci&oacute;n: </label> 
		     		</td> 
		     		<td> 
		         		 <form:input id="fechaAutoriza" name="fechaAutoriza" path="fechaAutoriza" size="12" 
		         		 readOnly="true"   />  
		         		 <input type="hidden" id="estatus" name="estatus" size="5"/>	
		         		 <input type="hidden" id="atiendeSucursal" name="atiendeSucursal" size="5" />	
		         		 <input type="hidden" id="sucursalLogeado" name="sucursalLogeado" size="5" />	
		         		 <input type="hidden" id="sucursalSolicitud" name="sucursalSolicitud" size="5" />	
		     		</td>
		     	</tr>	
		    </table>
	 	    <table>
	 	    	<br>
	 	    	<tr>	
					<td>
					 	<div id="integrantesGrupo" style="overflow: scroll; width: 935px; height: 200px; display: none;" />
					</td>		
				</tr> 	
	 		</table>
	 		 <table>
				<tr> 
				<td>						
					<div id="gridFirmasAutoriza" style="display: none;" width="50%">  </div>
											 			
		 				<div id="gridFirmas" style="display: none;">  </div>
		 			<input type="hidden" id="detalleFirmasAutoriza" name="detalleFirmasAutoriza" size="100" />	
		 			<input type="hidden" id="listaIntegrantes" name="listaIntegrantes" size="100" />	
		 			
	 			</td>
	 			<td>
	 				<div id="gridFirmasOtorgadas" style="display: none; width:50%" >  </div>	
	 			</td>
	 			</tr>	
	 		</table>
			
			<table align="center">
				<tr>
					<td>
						<input type="button" id="rechazar" name="rechazar" class="submit" value="Rechazar" tabindex="2"  />
					</td>
					<td class="separador"></td> 
					<td>
						<input type="button" id="regresarEjec" name="regresarEjec" class="submit" value="Regresar a Ejecutivo" tabindex="3"  />
					</td>
					<td class="separador"></td> 
					<td align="right">
						<input type="button" id="autorizar" name="autorizar" class="submit" value="Autorizar" tabindex="4"  />
						<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
							<input id="montoProd" name="montoProd"  size="15" type="hidden" esMoneda="true" disabled = "true"/>			
					</td>
					
				</tr>
			</table>		
	
		
 			<div id="gridComentariosRechazoRegreso" style="display: none;" >
	 			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend id="legendRegreso" style="display: none;">Regresar Solicitud a Ejecutivo</legend>
					<legend id="legendRechazo" style="display: none;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Rechazar Solicitud &nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</legend>
		 			<table >
		 			<tr > 
						<td class="label" > 
					   		<label id="eComentario" for="lblComentarioEjec">Comentarios:  </label> 
					   </td>  	
					   <td> 
			         		<form:textarea  id="comentarioEjecutivo" name="comentarioEjecutivo" path="comentarioEjecutivo" maxlength ="1500" tabindex="5" COLS="38" ROWS="4" onBlur=" ponerMayusculas(this);" />
			     		</td> 
			     		<td class="separador"></td>
	 					<td>  
			     			<input type="submit" id="guardarRechazo" name="guardarRechazo" class="submit" value="Guardar" tabindex="6" style="display: none;"  />
			     		</td> 
			     		<td>  
			     			<input type="submit" id="guardarRegresar" name="guardarRegresar" class="submit" value="Guardar" tabindex="7" style="display: none;" />
			     		</td>  
		 			</tr> 
		 			</table>
	 			</fieldset>
 			 </div>
		 			 
 			 <div id="gridComentariosAutoriza" style="display: none;">
	 			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend id="legendAutoriza">Autorizar Solicitud</legend>
		 			<table>
			 			<tr> 
							<td class="label"> 
						   		<label for="lblComentarioEjec">Términos Y <br/> Condiciones: </label> 
						   </td>   	
						   <td> 
				         		<form:textarea  id="comentarioMesaControl" name="comentarioMesaControl" 				         		
				         		path="comentarioMesaControl" tabindex="8" COLS="38" ROWS="4" onBlur=" ponerMayusculas(this);"  />
				     		</td> 
				     		<td class="separador"></td>  
				     		<td>  
				     			<input type="submit" id="guardarAutoriza" name="guardarAutoriza" class="submit" value="Guardar" tabindex="9" />
				     		</td>
			 			</tr> 
		 			</table>
	 			</fieldset>
 			 </div>	  		 	 	
</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista" ></div>
</div>
</body>
<div id="mensaje" style="display: none;" ></div>
</html>