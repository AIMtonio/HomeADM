<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<link rel="stylesheet" type="text/css"
	href="css/jquery.lightbox-0.5.css" media="screen" />
<script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>
<script type="text/javascript" src="js/bancaMovil/imagenesAntiphishingCatalogo.js"></script>
<script type="text/javascript" src="dwr/interface/imagenAntiphishingServicio.js"></script>
<script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>
</head>



<body>
	<div id="contenedorForma">
		<form method="post" id="formaGenerica" name="formaGenerica"
			action="/microfin/catalogoAntiphishing.htm" enctype="multipart/form-data">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Cat&aacute;logo de Im&aacute;genes Antiphishing</legend>
				<div id="listaImagenes">
		
				</div>
			</fieldset>
		</form>
	</div>
	<div id="cargando"></div>
	
</body>
<div id="mensaje" style="display: none;"></div>
</html>