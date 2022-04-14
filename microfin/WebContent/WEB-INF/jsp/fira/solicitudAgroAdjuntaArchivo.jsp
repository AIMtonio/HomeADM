<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head> 
	<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
	<script type="text/javascript" src="dwr/interface/solicitudArchivoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>	
	<script type="text/javascript" src="dwr/interface/fileServicio.js"></script>  
	<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>	
	<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>

	
	
	<script type="text/javascript" src="js/fira/solicitudArchivoCatalogo.js"></script>    
	<script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form method="post" id="formaGenerica" name="formaGenerica" action="/microfin/solicitudesAdjuntaArchivo.htm" commandName="archivo" enctype="multipart/form-data">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
				<legend class="ui-widget ui-widget-header ui-corner-all">Expediente de Solicitud de Cr&eacute;dito</legend>			
				<table border="0" cellpadding="0" cellspacing="0" width="100%"></table>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">	
				<legend >Solicitud de Cr&eacute;dito</legend>
				<table  width="100%">
					<tr>
			    		<td class="label"> 
			       			<label for="solicitudCreditoID">N&uacute;mero: </label> 
			    		</td>
				   		<td>
				       		<input id="solicitudCreditoID" name="solicitudCreditoID" size="13" tabindex="1" iniforma='false' /> 	 
				   		</td>    
				      	<td class="separador"></td> 
						<td class="label" nowrap="nowrap"> 
					       	<label for="estatus">Estatus: </label> 
					    </td>
					    <td>  
					       	<input type="text" id="estatus" name="estatus" size="13" tabindex="2" disabled= "true" readOnly="true"/>  
					    </td> 
			    	</tr>
			      	<tr>
				    	<td class="label" nowrap="nowrap"> 
				       		<label for="cliente"><s:message code="safilocale.cliente"/>: </label> 
				    	</td>
			     		<td>
					      	<input type="text" id="clienteID" name="clienteID" size="13" tabindex="3" disabled= "true" readOnly="true" iniforma='false' />  
					       	<input type="text" id="nombreCliente" name="nombreCliente" size="50" tabindex="4" disabled= "true" readOnly="true"/>  
					    </td>
			      		<td class="separador"></td> 
			      		<td class="label" nowrap="nowrap"> 
				       		<label for="prospecto">Prospecto: </label> 
				    	</td>
			     		<td>
					      	<input type="text" id="prospectoID" name="prospectoID" size="13" tabindex="5" disabled= "true" readOnly="true" iniforma='false' />  
					       	<input type="text" id="nombreProspecto" name="nombreProspecto" size="50" tabindex="6" disabled= "true" readOnly="true"/>  
					    </td> 
			      	</tr>
			      	<tr>
				    	<td class="label" nowrap="nowrap"> 
				       		<label for="cuenta">Producto: </label> 
				    	</td>
					   	<td>
					       	<input type="text" id="productoCreditoID" name="productoCreditoID" size="13" tabindex="7"  disabled= "true" iniforma='false' />  
					       	<input type="text" id="nombreProducto" name="nombreProducto" size="50" tabindex="8" disabled= "true" readOnly="true"/>  
					   	</td> 
						<td class="separador"></td> 
						<td class="label" nowrap="nowrap"> 
			        		<label for="grupo">Grupo: </label> 
			     		</td>
					   	<td>
					       	<input type="text" id="grupoID" name="grupoID" size="13" tabindex="8" disabled= "true" readOnly="true" iniforma='false' />  
					       	<input type="text" id="decripcionGrupo" name="decripcionGrupo" size="50" tabindex="9" disabled= "true" readOnly="true"/>  
					    </td> 
			      	</tr>      	 
			       	<tr>
					   	<td class="label" nowrap="nowrap"> 
					      	<label for="tipoDocumentoID">Tipo de Documento: </label> 
					   	</td> 
					   	<td> 
							<select id="tipoDocumentoID" name="tipoDocumentoID" tabindex="7">
								<option value="">SELECCIONAR</option>			
							</select>     
					    </td>			
						<td class="separador"></td> 
						<td class="label"> 
					       	<label for="ciclo">Ciclo: </label> 
					    </td>
					    <td>  
					       	<input type="text" id="ciclo" name="ciclo" size="13" tabindex="8" disabled= "true" readOnly="true"/>  
					    </td> 
			      	</tr>
			     </table>
			</fieldset>	 
			<br>
			<div id="gridArchivosCredito" >	</div> 
			<table align="right">
				<tr>
			    	<td class="label">	
			      		<input type="button" class="submit" id="pdf" tabindex="9" value="Expediente Sol"/> 	
			  		</td> 
			      	<td>
			       		<input type="button" id="enviar" name="enviar" class="submit" tabindex="10" value="Adjuntar"   /> 
			      		<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			      	</td> 
				</tr>
				<tr>
					<td>
						<div id="imagenCre" style="overflow: scroll; width: 950px; height: 500px;display: none;">
							<img id="imgCredito" src="images/user.jpg"  border="0"  />
						</div>  
			       </td> 
				</tr>  
			</table>
		</form>
	</div>
	<div id="cargando" style="display: none;">	
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display:none;"></div> 
</html>
