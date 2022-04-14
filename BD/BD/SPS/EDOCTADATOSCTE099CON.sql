-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADATOSCTE099CON
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADATOSCTE099CON`;DELIMITER $$

CREATE PROCEDURE `EDOCTADATOSCTE099CON`(
	-- Store procedure para consultar los datos del cliente para los estados de cuenta de clientes nuevos en tronco principal
	Par_ClienteID						INT(11),					-- Identificador del cliente
	Par_FechaInicio	 					DATE,						-- Fecha de inicio del perido
	Par_FechaFin						DATE,						-- Fecha de finalizacion del perido del estado de cuenta

	Par_NumCon							TINYINT UNSIGNED,			-- Numero de consulta

	Par_EmpresaID						INT(11),					-- Parametro de Auditoria
	Aud_Usuario							INT(11),					-- Parametro de Auditoria
	Aud_FechaActual						DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP						VARCHAR(15),				-- Parametro de Auditoria
	Aud_ProgramaID						VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal						INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion					BIGINT(20)					-- Parametro de Auditoria
	)
TerminaStore:BEGIN
-- DECLARACION DE VARIABLES
-- variables para validar la visibilidad en de las secciones en el reporte.
DECLARE Var_NumCuentas					BIGINT(12);					-- Numero de las cuentas
DECLARE Var_NumCredito					BIGINT(12);					-- Numero de Creditos
DECLARE Var_NumInversion				BIGINT(12);					-- Numero de Inersión
DECLARE Var_FolioFiscal					VARCHAR(50);				-- Valor de UUID
DECLARE Var_CtaAho						BIGINT(12);					-- Valor de cuentas de ahorro

DECLARE Var_CredCliente					BIGINT(12);					-- Numero de credito
DECLARE Var_DiasPeriodo					VARCHAR(45);				-- Almacena el total de dias que abarca el periodo
DECLARE Var_RutaLogo					VARCHAR(90);				-- Almacena la ruta del logo a desplegar en el estado de cuenta

-- DECLARACION DE CONSTANTES
DECLARE Con_Principal					INT(11);

-- ASIGNACION DE CONSTANTES
SET Con_Principal						:=1;						-- Consulta principal

	IF (Par_NumCon = Con_Principal)then
		SET Var_NumCuentas:= IFNULL((SELECT	CuentaAhoID
								FROM EDOCTARESUMCTA Edo
									WHERE Edo.ClienteID = Par_ClienteID
									ORDER BY Edo.CuentaAhoID limit 1),0);

		SET Var_NumCredito := IFNULL((SELECT 	CreditoID
										FROM EDOCTARESUM099CREDITOS
										WHERE ClienteID = Par_ClienteID limit 1),0);

		SET Var_NumInversion := IFNULL((SELECT	Head.InversionID
										FROM EDOCTAHEADER099INV Head INNER JOIN EDOCTADETINVER Detail ON Head.InversionID = Detail.InversionID
										WHERE Head.ClienteID = Par_ClienteID
										ORDER BY Head.InversionID, Detail.Orden ASC limit 1),0);

		SET Var_FolioFiscal := IFNULL((SELECT CFDIUUID
										FROM EDOCTADATOSCTE
											WHERE
										ClienteID = Par_ClienteID limit 1),"");

		SET Var_CtaAho := IFNULL((SELECT CuentaAhoID
									FROM EDOCTAHEADERCTA
									WHERE ClienteID = Par_ClienteID
									ORDER BY CuentaAhoID limit 1),0);

		SET Var_CredCliente := IFNULL((SELECT Head.CreditoID
										FROM EDOCTAHEADERCRED Head INNER JOIN EDOCTADETCRE Detail ON Head.CreditoID = Detail.CreditoID
											WHERE Head.ClienteID =  Par_ClienteID limit 1),0);

		SET Var_RutaLogo := IFNULL((SELECT RutaLogo FROM EDOCTAPARAMS),'');

		-- Se obtiene la cantidad de dias del periodo procesado
		SET	Var_DiasPeriodo := CAST(DATEDIFF(Par_FechaFin,Par_FechaInicio) AS CHAR);
		SET	Var_DiasPeriodo := IFNULL(Var_DiasPeriodo, '');

		SELECT		AnioMes,						SucursalID,							NombreSucursalCte,					ClienteID,						NombreComple,
					Colonia,						TipPer,								TipoPersona,						Calle,							NumInt,
					NumExt,							MunicipioDelegacion,				Localidad,							Estado,							CodigoPostal,
					RFC,							InstrucEnvio,						NombreInstitucion,					DireccionInstitucion,			FechaGeneracion,
					Var_DiasPeriodo as Dias,		DireccionCompleta,					Par_FechaInicio as FechaIni ,		Par_FechaFin as FechaFin,		Var_NumCuentas AS NumCuentas,
					Var_NumCredito as NumCredito,	Var_NumInversion as NumInversion,	Var_FolioFiscal as FolioFiscal,		Var_CtaAho AS CtaAho,			Var_CredCliente AS CredCliente,
					Var_RutaLogo as RutaLogo
		FROM EDOCTADATOSCTE
		WHERE ClienteID = Par_ClienteID;
	END IF;

END TerminaStore$$