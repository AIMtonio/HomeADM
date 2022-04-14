<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Usuario Concurrente(Doble Login)</title>
</head>
<body>
	<h1>Su Sesi&oacute;n ha expirado (Control de Acceso Recurrente)!</h1>
	<p>Alguien más ha ingresado a la Aplicaci&oacute;n con tu Usuario y Contraseña te recomendamos seguir las instrucciones de seguridad.</p>
	<c:url value="/entradaAplicacion.htm" var="entradaURL" />
	<li><a href="${entradaURL}">Entrar a la Aplicaci&oacute;n</a></li>
</body>
</html>