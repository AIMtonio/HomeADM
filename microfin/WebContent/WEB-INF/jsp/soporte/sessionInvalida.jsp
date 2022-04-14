<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Session Expirada</title>
</head>
<body>
	<h1>Session Finalizada ! (SesionIvalidaController)</h1>
	<p>
		Por Seguridad, su sesion ha sido Finalizada,
		Al alcanzar el tiempo maximo de inactividad o 
		interacción con la Aplicacion.
	</p>
		
<c:url value="/entradaAplicacion.htm" var="entradaURL"/>
<li><a href="${entradaURL}">Entrar a la Aplicacion</a></li>

</body>
</html>