<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<link href="css/redmond/jquery-ui-1.8.16.custom.css" media="all"  rel="stylesheet" type="text/css">  
		<script type="text/javascript" src="js/jquery-ui-1.8.16.custom.min.js"></script>  
		<script type='text/javascript' src='js/jquery.ui.tabs.js'></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/identifiClienteServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tiposIdentiServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
	 	<script type="text/javascript" src="dwr/interface/expedienteCliente.js"></script>
		<script type="text/javascript" src="dwr/interface/flujoPantallaClienteServicio.js"></script>   
		
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>     
 		<script type="text/javascript" src="js/cliente/flujoCliente.js"></script>

       	<script>
			$(function() { 
				$("#tabs" ).tabs();
			});
   		</script>
	</head>
<body>
<div id="contenedorForma">
	<div id="tabs"> 
		<ul>
			<li><a	id="selecciona"	href="#_selecciona">Seleccione<br> <br></a></li> 
			<li><a	hidden="true" id="pantalla1" 	href="#_pantalla1"></a></li>
			<li><a	hidden="true" id="pantalla2" 	href="#_pantalla2"></a></li>
			<li><a	hidden="true" id="pantalla3" 	href="#_pantalla3"></a></li>
			<li><a	hidden="true" id="pantalla4" 	href="#_pantalla4"></a></li>
			<li><a	hidden="true" id="pantalla5" 	href="#_pantalla5"></a></li>
			<li><a	hidden="true" id="pantalla6" 	href="#_pantalla6"></a></li>
			<li><a	hidden="true" id="pantalla7" 	href="#_pantalla7"></a></li>
			<li><a	hidden="true" id="pantalla8" 	href="#_pantalla8"></a></li>
			<li><a	hidden="true" id="pantalla9" 	href="#_pantalla9"></a></li>
			<li><a	hidden="true" id="pantalla10" 	href="#_pantalla10"></a></li>
			<li><a	hidden="true" id="pantalla11" 	href="#_pantalla11"></a></li>
			<li><a	hidden="true" id="pantalla12" 	href="#_pantalla12"></a></li>
			<li><a	hidden="true" id="pantalla13" 	href="#_pantalla13"></a></li>
			<li><a	hidden="true" id="pantalla14" 	href="#_pantalla14"></a></li>
			<li><a	hidden="true" id="pantalla15" 	href="#_pantalla15"></a></li>
			
			
		</ul>
	<div id="_pantalla1"></div>
	<div id="_pantalla2"></div>
	<div id="_pantalla3"></div>
	<div id="_pantalla4"></div>
	<div id="_pantalla5"></div>
	<div id="_pantalla6"></div>
	<div id="_pantalla7"></div>
	<div id="_pantalla8"></div>
	<div id="_pantalla9"></div>
	<div id="_pantalla10"></div>
	<div id="_pantalla11"></div>
	<div id="_pantalla12"></div>
	<div id="_pantalla13"></div>
	<div id="_pantalla14"></div>
	<div id="_pantalla15"></div>
	
	
	<div id="_selecciona"> 
			<form:form id="formaMenu" name="formaMenu" method="POST" commandName="cliente">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Flujo <s:message code="safilocale.cliente"/></legend>
					<table border="0"  width="100%">
						<tr>
							<td>
								<table border="0"  width="100%">
									<tr>
										<td class="label">
											<label for="lblGrupo">Número de <s:message code="safilocale.cliente"/>: </label>
										</td> 
										<td >
											<input type="text"  id="flujoCliNumCli" name="flujoCliNumCli"  				size="12" 	tabindex="1"  />
											<input type="text"  id="nomCompleto" name="nomCompleto"  		size="45" 	tabindex="2"	readonly/>
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="lblCiclo">Sucursal Origen: </label>
										</td> 
										<td>
											<input type="text" id="sucOrigen" name="sucOrigen"  		size="12" 	tabindex="3"  readonly />
											<input type="text" id="nomsucOrigen" name="nomsucOrigen"  size="45" 	tabindex="4"  readonly />
										</td>				
									</tr>
<!-- 									<tr> -->
<!-- 										<td><input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td> -->
<!-- 										<td><input type ="button" id="buscarGeneral" name="buscarGeneral" value="Busqueda General" class="submit"/></td> -->
<!-- 									</tr> -->
									<tr>
										<td class="label">
											<label for="fecha">Tipo de Persona: </label>
										</td> 
							  			<td >
								 			<input type="text"  id="tipoPer" name="tipoPer"  			size="45"	tabindex="5" readonly/>
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="lblProducto">Promotor Actual: </label>
										</td> 
										<td >
											<input type="text"  id="promActual" name="promActual"  		size="12"	tabindex="6" readonly/>
											<input  type="text" id="nompromotorActual" name="nompromotorActual" size="45"	tabindex="7" readonly/>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="fecha">Dirección Oficial: </label>
										</td> 
							  			<td >
							  				<input  type="hidden" id="flujoCliDirOfi" name="flujoCliDirOfi" size="45"	/>
								 			<textarea id="direCompleta" name="direCompleta" cols="45" rows="6" 	tabindex="8" readonly></textarea>
								 		</td>		
										<td class="separador"></td>
										
										<td class="label">
											<label for="fecha">Identificación Oficial: </label>
										</td> 
							  			<td >
							  				<input  type="hidden"  id="flujoCliIdeID" name="flujoCliIdeID"  		size="24"	/>
								 			<input  type="text"  id="flujoCliIdent" name="flujoCliIdent"  		size="24"	tabindex="9"	readonly/>
								 			<input  type="text"  id="nomidentificacion" name="nomidentificacion"	size="45"	tabindex="10"	readonly />
								 		</td>		
									</tr>
									<tr>
										<td class="label">
											<label for="fecha">Solicitud de Cuenta: </label>
										</td> 
							  			<td >
								 			<input  type="hidden"  id="flujoCliSolCue" name="flujoCliSolCue"  			size="15"	tabindex="12"	readonly/>
								 			<input  type="text"  id="flujoCliSolCuePrinc" name="flujoCliSolCuePrinc"  			size="15"	tabindex="12"	readonly/>
								 		</td>		
									</tr>
								</table>
							</td>
						</tr>

					</table>	
				</fieldset>
			</form:form>
		</div> 
	</div> 
		 
</div> <!-- contenedor de forma -->


<div id="cargando" style="display: none;"></div>
<div id="cajaListaContenedor" style="display: none;">
	<div id="elementoListaContenedor"></div>
</div>
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>