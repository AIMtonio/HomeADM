<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
	 <script type="text/javascript" src="dwr/interface/organoDecisionServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  	
	<script type="text/javascript" src="dwr/interface/esquemaAutorizaServicio.js"></script>  		
		       	
	<script type="text/javascript" src="js/originacion/esquemaAutorizaGrid.js"></script>
	<script type="text/javascript" src="js/originacion/esquemaOrganoAutorizaGrid.js"></script>
	<script type="text/javascript" src="js/originacion/esquemaAutorizaCatalogo.js"></script>
       
	</head>
   
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="esquemaAutoriza">
																			  
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Esquema Autorización</legend>	
		 <br> </br>
		
			
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
						<label for="organoID">Producto de Crédito: </label> 
					</td>
					<td> 
		       			 <form:select id="producCreditoID" name="producCreditoID" path="producCreditoID" tabindex="1" type="select" >
							<form:option value=" ">Seleccionar</form:option>
						</form:select>       					        	
					</td>	
											
				</tr>						
		 	</table>			
</fieldset>
</form:form>


<form:form id="formaGenerica1" name="formaGenerica1" method="POST" commandName="esquemaAutGrid" action="/microfin/esquemaAutorizaGridVista.htm">	
	<div id="divGridEsquema" style="display: none;" ></div>			
</form:form>
			

<form:form id="formaGenerica2" name="formaGenerica2" method="POST" commandName="organoAutoriza" action="/microfin/esquemaOrganoAutorizaGridVista.htm">
	<div id="divGridFirmas" style="display: none;" ></div>	
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