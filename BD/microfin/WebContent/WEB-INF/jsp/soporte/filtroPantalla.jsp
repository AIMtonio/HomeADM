<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="campoLista" value="${listaResultado[1]}" />
<c:set var="cerraSesion" value="${listaResultado[2]}" />
<link rel="stylesheet" type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" />
<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
<html>
<head>
<title>SAFI</title>
<link rel="stylesheet" type="text/css" href="css/mensaje.css" media="all">
</head>

<body>
<div id="contenedorMsg">




<TABLE WIDTH='600' style='border:solid 1px #242424' CELLSPACING='1' CELLPADDING='1' ALIGN='CENTER' VALIGN='TOP'>
	<TR><TD><BR> </TD></TR>
	<TR><TD>
	<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>
	<TR>
	<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: CCCCCC ;text-decoration: none;'>
	      	Recurso sin acceso
	 </TD>
	</TR>
	<TR>
	<TD ALIGN='CENTER'><IMG id= "error" SRC="images/error2.jpg" WIDTH=60 HEIGHT=60 BORDER=0ALIGN='RIGHT' /></TD>
	</TR>
	<TR>
    	<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>
    			No se encontr&oacute; recurso solicitado.
    			
    	</TD>
	</TR>
		<TR>
    		<TD>&nbsp;</TD>
		</TR>
		<TR>	    		
			<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>  			
    		En este momento ha solicitado acceder a un recurso que no ha sido encontrado. Para acceder a los recursos ofrecidos por el sistema puede<br> <a href="menuAplicacion.htm">Regresar al men&uacute; de la aplicaci&oacute;n</a> y seleccionar una opci&oacute;n accesible.
    		</TD>
    	</TR>
		<TR>
    	<TD>&nbsp;</TD>
		</TR>
    	<TR>
		<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>	    			
    			<p> Disculpe las molestias esto pueda ocasionarle. </p>
    			<p> POR SU SEGURIDAD TENGA EN CUENTA: Si se aleja de su computadora, cierre la Sesi&oacute;n, haga clic en el &iacute;cono Salir en la parte superior <br>de la p&aacute;gina para salir de la zona segura. </p>
				<p>Le recordamos que es responsable del buen uso del Nombre de Usuario y Contrase&ntilde;a que utiliza para los Servicios de la Aplicaci&oacute;n.</p>

   </TD>
		</TR>
		<TR>
    		<TD>&nbsp;</TD>
		</TR>			
	</TABLE>



</body>
</html>
