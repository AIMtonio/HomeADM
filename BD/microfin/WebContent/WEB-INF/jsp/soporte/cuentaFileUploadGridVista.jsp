<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>
<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
<c:set var="cuentaArchivo"  value="${cuentaArchivo}"/>
<!-- Ativando o jQuery lightBox plugin -->
<script type="text/javascript">
	$(function() {
        $('#gridArchivosCta a').lightBox();
    });
</script>
<style type="text/css">
/* jQuery lightBox plugin - Gallery style */
	#gridArchivosCta {
		background-color: #FFFFFF;
		padding: 10px;
		width: 520px;
	}
	#gridArchivosCta ul { list-style: none; }
	#gridArchivosCta ul li { display: inline; }
	#gridArchivosCta ul img {
		border: 5px solid #3e3e3e;
		border-width: 5px 5px 20px;
	}
	#gridArchivosCta ul a:hover img {
		border: 5px solid #fff;
		border-width: 5px 5px 20px;
		color: #fff;
	}
	#gridArchivosCta ul a:hover { color: #fff; }
</style>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Documentos de la Cuenta</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label">
					<label for="lblNo">Número</label>
				</td>
				<td class="label">
					<label for="lblObservacion"> Observación</label>
			  	</td>
			  	<td class="label">
		        	<label for="lblDocumento">Ver</label>
		     	</td>
		     	<td class="separador"></td>
		    </tr>
		    <c:forEach items="${cuentaArchivo}" var="cuentaArchi" varStatus="status">
			<tr>
				<td>
					<input id="archivoCuentaID${status.count}"  name="archivoCuentaID" size="7"
									value="${cuentaArchi.archivoCuentaID}" readOnly="true"/>
				</td>
				<td>
					<input id="observacion${status.count}" name="observacion" size="60"
									value="${cuentaArchi.observacion}"readOnly="true"/>
				</td>
				<td>
					<c:set var="varRecursoCte"  value="${cuentaArchi.recurso}"/>
					<input id="recursoCteInput${status.count}"  name="recursoCteInput" size="7"
									value="${varRecursoCte}" readOnly="true" type="hidden"/>
					<input type="button" name="verArchivoCta" id="verArchivoCta${status.count}" class="submit" value="Ver" onclick="verArchivosCta(${status.count},${cuentaArchi.tipoDocumento},${cuentaArchi.archivoCuentaID})"/>
				</td>
			  	<td>
					<input type="button" name="elimina" id="elimina${status.count}" class="btnElimina" onclick="eliminaArchivo(${cuentaArchi.archivoCuentaID},'${cuentaArchi.descTipoDoc}')"/>

				</td>
			</tr>
			</c:forEach>
		</table>
	</fieldset>