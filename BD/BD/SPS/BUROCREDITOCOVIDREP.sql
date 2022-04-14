-- BUROCREDITOCOVIDREP
DELIMITER ;
DROP PROCEDURE IF EXISTS BUROCREDITOCOVIDREP;
DELIMITER $$

CREATE PROCEDURE BUROCREDITOCOVIDREP(
-- SP PARA REPORTE DE BURO DE CREDITO DE PERSONAS MORALES MENSUAL FORMATO CSV Y TXT
	Par_FechaCorteBC	DATE,			-- Fecha de Corte para generar el reporte
	Par_TipoReporte		INT(1),			-- Tipo de Reporte Excel(1) - Txt(2)
	Par_TipoPersona		CHAR(1),		-- Persona Fisica(F), Persona Moral(M)

	Aud_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_Cinta				LONGTEXT;			-- Cinta en formato csv
	DECLARE Var_CintaPipes			LONGTEXT;			-- Cinta en formato texto
	DECLARE Var_ClaveUsuario		INT(11);			-- Clave del usuario
	DECLARE Var_TipoUsuario			VARCHAR(4);			-- Tipo de usuario
	DECLARE Var_FechaFin			DATE;				-- Ultima fecha del mes
	DECLARE Var_FechaInicio			DATE;				-- Primer fecha del mes
	DECLARE Var_NombreArchivo		VARCHAR(50);		-- Nombre del archivo
	DECLARE Var_ClaveInst			VARCHAR(50);		-- Clave unico del usuario
	DECLARE Var_NombreEmpresa		VARCHAR(50);		-- Nombre de la empresa
	DECLARE Var_TipoNegocio			VARCHAR(5);			-- Tipo de negocio de la institucion

	-- Declaracion de constantes
	DECLARE Con_PerFisica			CHAR(1);			-- Persona fisica
	DECLARE Con_PerMoral			CHAR(1);			-- Persona moral
	DECLARE Con_PersonaFCAE			CHAR(1);			-- Persona fisica con actividad empresarial
	DECLARE Reporte_Excel			INT(11);			-- Reporte en excel
	DECLARE Reporte_Txt				INT(11);			-- Tipo de reporte en texto
	DECLARE EqBuroCredPM			VARCHAR(5);			-- Moneda para personas morales
	DECLARE Separador				CHAR(1);			-- Separador para el reporte en csv
	DECLARE SeparadorPipes			CHAR(1);			-- Separador para el reporte de texto
	DECLARE Salto_Linea				VARCHAR(2);			-- Salto de linea
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante cadena vacia ''
	DECLARE KOB_FF					CHAR(2);			-- Tipo de Negocio Compania de Prestamos Personales
	DECLARE Con_NO					CHAR(1);			-- Constante NO
	DECLARE Con_SI					CHAR(1);			-- Constante SI
	DECLARE TipoRespIndividual		CHAR(1);			-- Tipo Responsabilidad Invididual
	DECLARE TipoRespMancomunado		CHAR(1);			-- Tipo Responsabilidad Mancomunado
	DECLARE TipoRespObligadoSol		CHAR(1);			-- Tipo Responsabilidad Responsable obligado Solidario
	DECLARE TipoCtaPagosFijos		CHAR(1);			-- Tipo Cuenta Pagos Fijos
	DECLARE TipoCtaHipoteca			CHAR(1);			-- Tipo Cuenta Hipoteca
	DECLARE TipoCtaSinLimite		CHAR(1);			-- Tipo Cuenta Sin limite
	DECLARE TipoCtaRevolvente		CHAR(1);			-- Tipo Cuenta Revolvente
	DECLARE FormatoFechaInicio		VARCHAR(10);		-- Formato de fecha de inicio
	DECLARE Entero_Uno				INT(11);			-- Constante Entero Uno

	-- Encabezado de la cinta
	DECLARE EncabezadoPMComas		VARCHAR(500);		-- Encabezado de personas morales separado por comas
	DECLARE EncabezadoPFComas		VARCHAR(500);		-- Encabezado de personas fisicas separado por comas
	DECLARE EncabezadoPMPipes		VARCHAR(500);		-- Encabezado de personas morales separado por pipes
	DECLARE EncabezadoPFPipes		VARCHAR(500);		-- Encabezado de personas fisicas separado por pipes

	-- Asignacion de constantes
	SET Con_PerFisica				:= 'F';
	SET Con_PerMoral				:= 'M';
	SET Con_PersonaFCAE				:= 'A';
	SET Reporte_Excel				:= 1;
	SET Reporte_Txt					:= 2;
	SET EqBuroCredPM				:= '001';
	SET Separador					:= ',';
	SET SeparadorPipes				:= '|';
	SET Salto_Linea					:= '\n';
	SET Cadena_Vacia				:= '';
	SET Var_FechaFin				:= LAST_DAY(Par_FechaCorteBC);
	SET KOB_FF						:= 'FF';
	SET Con_NO						:= 'N';
	SET Con_SI						:= 'S';
	-- Tipo de Responsabilidad
	SET TipoRespIndividual			:= 'I';
	SET TipoRespMancomunado			:= 'J';
	SET TipoRespObligadoSol			:= 'C';
	-- Tipo de cuentas
	SET TipoCtaPagosFijos			:= 'I';
	SET TipoCtaHipoteca				:= 'M';
	SET TipoCtaSinLimite			:= 'O';
	SET TipoCtaRevolvente			:= 'R';
	SET FormatoFechaInicio			:= '%Y-%m-01';
	SET Entero_Uno					:= 1;
	SET Var_FechaInicio				:= DATE_FORMAT(Par_FechaCorteBC, FormatoFechaInicio);

	-- Encabezado de la cinta
	SET EncabezadoPMComas 			:= Cadena_Vacia;
	SET EncabezadoPMComas 			:= CONCAT(EncabezadoPMComas,'Contrato,Clave de la Institucion,Moneda,Tipo de Credito,Fecha de Inscripcion');

	SET EncabezadoPMPipes 			:= Cadena_Vacia;
	SET EncabezadoPMPipes 			:= CONCAT(EncabezadoPMPipes,'Contrato|Clave de la Institucion|Moneda|Tipo de Credito|Fecha de Inscripcion');

	SET EncabezadoPFComas 			:= Cadena_Vacia;
	SET EncabezadoPFComas 			:= CONCAT(EncabezadoPFComas,'Tipo de Negocio (KOB),Member Code,Numero de Cuenta,Tipo de Contrato,Tipo de Responsabilidad,Tipo de Cuenta,Moneda,Fecha de Inscripcion');

	SET EncabezadoPFPipes 			:= Cadena_Vacia;
	SET EncabezadoPFPipes 			:= CONCAT(EncabezadoPFPipes,'Tipo de Negocio (KOB)|Member Code|Numero de Cuenta|Tipo de Contrato|Tipo de Responsabilidad|Tipo de Cuenta|Moneda|Fecha de Inscripcion');
	-- INICIA SEGMENTO FINAL


	-- Obtenemos los datos de la institucion
	SELECT	ClaveInstitID,		Nombre,				ClaveUsuarioBCPM,	TipoUsuarioBCPM,	TipoNegocioID
	INTO	Var_ClaveInst,		Var_NombreEmpresa,	Var_ClaveUsuario,	Var_TipoUsuario,	Var_TipoNegocio
	FROM BUCREPARAMETROS;

	DROP TABLE IF EXISTS TMPBUROCREDITOCOVID;
	CREATE TEMPORARY TABLE TMPBUROCREDITOCOVID(
		Cinta			LONGTEXT,
		NombreArchivo	VARCHAR(50)
	);

	-- ========================================================= Reporte en formato csv =========================================================
	IF(Par_TipoReporte = Reporte_Excel)THEN
		-- Se inserta el encabezado para el formato pipes

		-- Persona Fisicas
		IF(Par_TipoPersona = Con_PerFisica)THEN

			SET Var_Cinta 			:= CONCAT(EncabezadoPFComas,Salto_Linea);
			SET Var_NombreArchivo	:= CONCAT('BUROCREDITOPF_OV',Var_FechaFin);
			INSERT INTO TMPBUROCREDITOCOVID
					(Cinta,				NombreArchivo)
			VALUES	(Var_Cinta,			Var_NombreArchivo);

			INSERT TMPBUROCREDITOCOVID (Cinta)
			SELECT	CONCAT_WS(	Separador,	Var_TipoNegocio,	Var_ClaveInst,	Dife.CreditoID,	Pro.TipoContratoBCID,
					IF(IFNULL(Pro.EsGrupal,Con_NO) = Con_NO, TipoRespIndividual, TipoRespMancomunado),
					IF(IFNULL(Pro.EsRevolvente,Con_NO) = Con_NO, TipoCtaPagosFijos, TipoCtaRevolvente),
					Mon.EqBuroCred,	DATE_FORMAT(Dife.FechaAplicacion, '%d/%m/%Y'),
					Salto_Linea)
			FROM CREDITOSDIFERIDOS Dife
			INNER JOIN CREDITOS Cre On Dife.CreditoID = Cre.CreditoID
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID AND Cli.TipoPersona = Con_PerFisica
			INNER JOIN MONEDAS Mon ON Mon.MonedaID = Cre.MonedaID
			INNER JOIN DESTINOSCREDITO Des ON Des.DestinoCreID = Cre.DestinoCreID
			INNER JOIN CLASIFICCREDITO Cla ON Cla.ClasificacionID = Des.SubClasifID
			INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
			WHERE Dife.FechaAplicacion >= Var_FechaInicio
			  AND Dife.FechaAplicacion <= Par_FechaCorteBC
			  AND Dife.NumeroDiferimientos = Entero_Uno;

			SELECT 	Cinta,	NombreArchivo
			FROM TMPBUROCREDITOCOVID;

		END IF;

		-- Persona Moral
		IF(Par_TipoPersona = Con_PerMoral)THEN

			SET Var_Cinta 			:= CONCAT(EncabezadoPMComas,Salto_Linea);
			SET Var_NombreArchivo	:= CONCAT('BUROCREDITOPM_OV',Var_FechaFin);
			INSERT INTO TMPBUROCREDITOCOVID
					(Cinta,				NombreArchivo)
			VALUES	(Var_Cinta,			Var_NombreArchivo);

			INSERT TMPBUROCREDITOCOVID (Cinta)
			SELECT	CONCAT_WS(	Separador,	Dife.CreditoID,	Var_ClaveUsuario,	Mon.EqBuroCredPM,	Cla.CodClasificBuroPM,	DATE_FORMAT(Dife.FechaAplicacion, '%d/%m/%Y'),
								Salto_Linea)
			FROM CREDITOSDIFERIDOS Dife
			INNER JOIN CREDITOS Cre On Dife.CreditoID = Cre.CreditoID
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID AND Cli.TipoPersona IN(Con_PerMoral, Con_PersonaFCAE)
			INNER JOIN MONEDAS Mon ON Mon.MonedaID = Cre.MonedaID
			INNER JOIN DESTINOSCREDITO Des ON Des.DestinoCreID = Cre.DestinoCreID
			INNER JOIN CLASIFICCREDITO Cla ON Cla.ClasificacionID = Des.SubClasifID
			WHERE Dife.FechaAplicacion >= Var_FechaInicio
			  AND Dife.FechaAplicacion <= Par_FechaCorteBC
			  AND Dife.NumeroDiferimientos = Entero_Uno;

			SELECT 	Cinta,	NombreArchivo
			FROM TMPBUROCREDITOCOVID;
		END IF;

	END IF;

	-- ========================================================= Reporte en formato txt =========================================================
	IF(Par_TipoReporte = Reporte_Txt)THEN
		-- Se inserta el encabezado para el formato pipes
		-- Persona Fisicas
		IF(Par_TipoPersona = Con_PerFisica)THEN

			-- Encabezado de persona moral
			SET Var_CintaPipes 		:= CONCAT(EncabezadoPFPipes,Salto_Linea);
			SET Var_NombreArchivo	:= CONCAT('BUROCREDITOPF_OV',Var_FechaFin);
			INSERT INTO TMPBUROCREDITOCOVID
					(Cinta,				NombreArchivo)
			VALUES	(Var_CintaPipes,	Var_NombreArchivo);

			INSERT TMPBUROCREDITOCOVID (Cinta)
			SELECT	CONCAT_WS(	SeparadorPipes,	Var_TipoNegocio,	Var_ClaveInst,	Dife.CreditoID,	Pro.TipoContratoBCID,
					IF(IFNULL(Pro.EsGrupal,Con_NO) = Con_NO, TipoRespIndividual, TipoRespMancomunado),
					IF(IFNULL(Pro.EsRevolvente,Con_NO) = Con_NO, TipoCtaPagosFijos, TipoCtaRevolvente),
					Mon.EqBuroCred,	DATE_FORMAT(Dife.FechaAplicacion, '%d/%m/%Y'),
					Salto_Linea)
			FROM CREDITOSDIFERIDOS Dife
			INNER JOIN CREDITOS Cre On Dife.CreditoID = Cre.CreditoID
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID AND Cli.TipoPersona = Con_PerFisica
			INNER JOIN MONEDAS Mon ON Mon.MonedaID = Cre.MonedaID
			INNER JOIN DESTINOSCREDITO Des ON Des.DestinoCreID = Cre.DestinoCreID
			INNER JOIN CLASIFICCREDITO Cla ON Cla.ClasificacionID = Des.SubClasifID
			INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
			WHERE Dife.FechaAplicacion >= Var_FechaInicio
			  AND Dife.FechaAplicacion <= Par_FechaCorteBC
			  AND Dife.NumeroDiferimientos = Entero_Uno;

			SELECT 	Cinta,	NombreArchivo
			FROM TMPBUROCREDITOCOVID;

		END IF;

		-- Persona Moral
		IF(Par_TipoPersona = Con_PerMoral)THEN

			-- Encabezado de persona moral
			SET Var_CintaPipes 		:= CONCAT(EncabezadoPMPipes,Salto_Linea);
			SET Var_NombreArchivo	:= CONCAT('BUROCREDITOPM_OV',Var_FechaFin);
			INSERT INTO TMPBUROCREDITOCOVID
					(Cinta,				NombreArchivo)
			VALUES	(Var_CintaPipes,	Var_NombreArchivo);
			INSERT TMPBUROCREDITOCOVID (Cinta)
			SELECT	CONCAT_WS(	SeparadorPipes,	Dife.CreditoID,	Var_ClaveUsuario,	Mon.EqBuroCredPM,	Cla.CodClasificBuroPM,	DATE_FORMAT(Dife.FechaAplicacion, '%d/%m/%Y'),
								Salto_Linea)
			FROM CREDITOSDIFERIDOS Dife
			INNER JOIN CREDITOS Cre On Dife.CreditoID = Cre.CreditoID
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID AND Cli.TipoPersona IN(Con_PerMoral, Con_PersonaFCAE)
			INNER JOIN MONEDAS Mon ON Mon.MonedaID = Cre.MonedaID
			INNER JOIN DESTINOSCREDITO Des ON Des.DestinoCreID = Cre.DestinoCreID
			INNER JOIN CLASIFICCREDITO Cla ON Cla.ClasificacionID = Des.SubClasifID
			WHERE Dife.FechaAplicacion >= Var_FechaInicio
			  AND Dife.FechaAplicacion <= Par_FechaCorteBC
			  AND Dife.NumeroDiferimientos = Entero_Uno;

			SELECT 	Cinta,	NombreArchivo
			FROM TMPBUROCREDITOCOVID;
		END IF;

	END IF;

END TerminaStore$$