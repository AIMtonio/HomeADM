<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%><html>
<head>
<LINK href="css/login.css" media="all" rel="stylesheet" type="text/css">

</HEAD><BODY id="">

<DIV id="ajaxWin" class="loginAjaxWinBody quickpopup">
<DIV id="ajaxWinBody">

<DIV id="loginContainer">

    <DIV id="formContainer">
	<form:form method="POST" commandName="contrato" id="reporteContratoCreForm" name="reporteContratoCreForm">
	
		<DIV class="elmHldr">
			<form:input path="numero" name="numeroContrato"
				id="numeroContrato" value="" tabindex="1"/>
		</DIV>

		<DIV class="elmHldr">

			<INPUT type="submit" name="submit" id="submit" value="Generar Reporte"
				  class="btn_orange_regular buyButton" tabindex="2">
		</DIV>
	</form:form>
    </DIV>
</DIV>

</DIV>
</DIV>

</body>
</html>