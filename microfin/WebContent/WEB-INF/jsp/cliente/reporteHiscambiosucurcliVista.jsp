<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<!-- se cargar los servicios para accesar por dwr -->
	 <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	 
	<!-- se cargan las funciones o recursos js -->
	<script type="text/javascript" src="js/cliente/reporteHiscambiosucurcli.js"></script> 
</head>
	<body>	
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST"  commandName="hiscambiosucurcliBean">	
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Cambios de Sucursal al <s:message code="safilocale.cliente"/></legend> 
					 	<table border="0" cellpadding="0" cellspacing="0" width="100%">
					 		<tr>
					 			<td>					 			
					 				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
										<legend class="label"><label>Parámetros</label></legend>  
					 						<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
												<tr>
									     			 <td class="label"> 
									        		 <label for="clienteInicio"><s:message code="safilocale.cliente"/> Inicial: </label> 
									      			</td>
									     			 <td>
									         			<input type="text" id="clienteInicio" name="clienteInicio" size="12"  tabindex="1" />  
									        			 <input type="text" id="clienteInicioDes" name="clienteInicioDes" readonly="true" size="70" />    
									     			 </td> 	
								 				</tr> 
												<tr>
									      			<td class="label"> 
									         			<label for="clienteFin"><s:message code="safilocale.cliente"/> Final: </label> 
									    			</td>
									     			 <td>
									        			 <input type="text" id="clienteFin" name="clienteFin" autocomplete="off" size="12" tabindex="2" />  
									         			 <input type="text" id="clienteFinDes" name="clienteFinDes" readonly="true" size="70" />    
									      			</td> 
								 				</tr>
								 				<tr>
													<td>
														<label>Fecha Inicial:</label>
													</td>
													<td><input type="text" name="fechaInicial" id="fechaInicial" path="fechaInicial"
																		 autocomplete="off" esCalendario="true" size="12" tabindex="3" >						
													</td>
													
												</tr>				
												<tr>
													<td>
														<label>Fecha Final:</label>
													</td>
													<td><input type="text" name="fechaFinal" id="fechaFinal" path="fechaFinal"
																		 autocomplete="off" esCalendario="true" size="12" tabindex="4">
													</td>
													
												</tr>									
								 			</table>
								 	</fieldset>
								 		</td></tr>							 	
										</table>
										<table align="right">
											<tr>
												<td>
													<a id="ligaGenerar" href="/reporteHiscambiosucurcli.htm" target="_blank" >  		 
													<input type="button" id="generar" name="generar" class="submit" tabIndex="6" value="Generar" />
													</a>
												</td>
											</tr>				
										</table>										 
									</fieldset>			
			</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	<div id="imagenCte" style="display: none;">
		<img id= "imgCliente" SRC="images/user.jpg" WIDTH="100%" HEIGHT="100%" border ="0" alt="Foto cliente"/> 
	</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>