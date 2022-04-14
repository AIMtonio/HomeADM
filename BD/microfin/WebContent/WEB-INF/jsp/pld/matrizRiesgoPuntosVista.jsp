<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Matriz de Riesgo</title>
<script type="text/javascript" src="js/pld/matrizRiesgoPuntos.js"></script>
<script type="text/javascript" src="js/utileria.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="ConfiguracionRatios">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Matriz de Riesgo</legend>
				<table border="0" width="100%">
					<tbody>
						<tr>
							<td colspan="5">
								<input type="text" id="detalles" name="detalles" size="100" style="display: none;" />
								<div id="listaConcepto" style="display: none;"></div>
								<br> <br>
								<div id="listaClasificacion" style="display: none;"></div>
								<br> <br>
								<div id="listaSubClasificacion" style="display: none;"></div>
								<br> <br>
								<div id="listaPuntos" style="display: none;"></div>
							</td>
						</tr>
						
					</tbody>
				</table>
			</fieldset>
			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion" />
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none; overflow:">
		<div id="elementoLista"></div>
	</div>
	<div id="mensaje" style="display: none;"></div>
</body>
</html>
