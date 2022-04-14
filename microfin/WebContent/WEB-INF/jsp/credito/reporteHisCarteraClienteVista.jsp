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
	<script type="text/javascript" src="js/credito/reporteHisCarteraCliente.js"></script>
</head>
<body>
<input type='hidden' id="tipoCliente" size="15" value="<s:message code="safilocale.cliente"/>"/>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST"  commandName="creditosBean">

			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Hist&oacute;rico de Cartera por <s:message code="safilocale.cliente"/> </legend>

					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="clienteID"><s:message code="safilocale.cliente"/>:</label>
							</td>
							<td>
								<input type='text' id="clienteID" name="clienteID"  size="15" tabindex="1" />
								<input type='text' id="clienteIDDes" name="clienteIDDes" size="80" readonly="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="estatus">Estatus Cr&eacute;dito:</label>
							</td>
							<td>
								<select id="estatus" name="estatus" path="estatus" tabindex="3" type="select">
									<option value="">TODOS</option>
									<option value="I">INACTIVOS</option>
									<option value="A">AUTORIZADOS</option>
									<option value="V">VIGENTES</option>	
									<option value="B">VENCIDOS</option>									
									<option value="K">CASTIGADOS</option>
									<option value="P">PAGADOS</option>
									<option value="S">SUSPENDIDO</option>				
								</select>
							</td>
						</tr>
					</table>
										
					<table align="right">
						<tr>
							<td>
								<a id="ligaGenerar" href="/historicoCarteraCliente.htm" target="_blank" >  		 
									<input type="button" id="generar" name="generar" class="submit" tabIndex="4" value="Generar" />
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